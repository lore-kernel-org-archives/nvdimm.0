Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3428.houston.hpe.com (g4t3428.houston.hpe.com
 [15.241.140.76])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AEB461A1DF4
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 12:09:05 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2] libnvdimm: Fix nvdimm_probe error on NVDIMM-N
Date: Tue, 16 Aug 2016 13:08:40 -0600
Message-Id: <1471374520-3331-1-git-send-email-toshi.kani@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

'ndctl list --buses --dimms' does not list any NVDIMM-Ns since
they are considered as idle.  ndctl checks if any driver is
attached to nmem device.  nvdimm_probe() always fails in
nvdimm_init_nsarea() since NVDIMM-Ns do not implement optinal
ND_CMD_GET_CONFIG_DATA command.

Change nvdimm_probe() to accept the case that the CONFIG_DATA
command is not implemented for NVDIMM-Ns.  The driver attaches
without ndd, which keeps it no-op to the device.

Reported-by: Brian Boylston <brian.boylston@hpe.com>
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
v2:
 - Fix failures in ndctl unit test suite. (Dan Williams)
 - Change ENOENT to ENOTTY, and remove gotos. (Dan Williams)
---
 drivers/nvdimm/dimm.c      |   11 +++++++++++
 drivers/nvdimm/dimm_devs.c |   28 +++++++++++++++-------------
 drivers/nvdimm/nd.h        |    1 +
 3 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index 71d12bb..619834e 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -26,6 +26,14 @@ static int nvdimm_probe(struct device *dev)
 	struct nvdimm_drvdata *ndd;
 	int rc;
 
+	rc = nvdimm_check_config_data(dev);
+	if (rc) {
+		/* not required for non-aliased nvdimm, ex. NVDIMM-N */
+		if (rc == -ENOTTY)
+			rc = 0;
+		return rc;
+	}
+
 	ndd = kzalloc(sizeof(*ndd), GFP_KERNEL);
 	if (!ndd)
 		return -ENOMEM;
@@ -72,6 +80,9 @@ static int nvdimm_remove(struct device *dev)
 {
 	struct nvdimm_drvdata *ndd = dev_get_drvdata(dev);
 
+	if (!ndd)
+		return 0;
+
 	nvdimm_bus_lock(dev);
 	dev_set_drvdata(dev, NULL);
 	nvdimm_bus_unlock(dev);
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index d9bba5e..c22244a 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -28,28 +28,30 @@ static DEFINE_IDA(dimm_ida);
  * Retrieve bus and dimm handle and return if this bus supports
  * get_config_data commands
  */
-static int __validate_dimm(struct nvdimm_drvdata *ndd)
+int nvdimm_check_config_data(struct device *dev)
 {
-	struct nvdimm *nvdimm;
-
-	if (!ndd)
-		return -EINVAL;
-
-	nvdimm = to_nvdimm(ndd->dev);
+	struct nvdimm *nvdimm = to_nvdimm(dev);
 
-	if (!nvdimm->cmd_mask)
-		return -ENXIO;
-	if (!test_bit(ND_CMD_GET_CONFIG_DATA, &nvdimm->cmd_mask))
-		return -ENXIO;
+	if (!nvdimm->cmd_mask ||
+	    !test_bit(ND_CMD_GET_CONFIG_DATA, &nvdimm->cmd_mask)) {
+		if (nvdimm->flags & NDD_ALIASING)
+			return -ENXIO;
+		else
+			return -ENOTTY;
+	}
 
 	return 0;
 }
 
 static int validate_dimm(struct nvdimm_drvdata *ndd)
 {
-	int rc = __validate_dimm(ndd);
+	int rc;
+
+	if (!ndd)
+		return -EINVAL;
 
-	if (rc && ndd)
+	rc = nvdimm_check_config_data(ndd->dev);
+	if (rc)
 		dev_dbg(ndd->dev, "%pf: %s error: %d\n",
 				__builtin_return_address(0), __func__, rc);
 	return rc;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 8024a0e..38d6f03 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -191,6 +191,7 @@ void nvdimm_exit(void);
 void nd_region_exit(void);
 struct nvdimm;
 struct nvdimm_drvdata *to_ndd(struct nd_mapping *nd_mapping);
+int nvdimm_check_config_data(struct device *dev);
 int nvdimm_init_nsarea(struct nvdimm_drvdata *ndd);
 int nvdimm_init_config_data(struct nvdimm_drvdata *ndd);
 int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
