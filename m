Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9566B221C1923
 for <linux-nvdimm@lists.01.org>; Wed, 28 Mar 2018 14:02:54 -0700 (PDT)
Subject: [PATCH] acpi, nfit: rework NVDIMM leaf method detection
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Mar 2018 14:00:27 -0700
Message-ID: <152227082782.1504.17033843515446218287.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-acpi@vger.kernel.org
Cc: Erik Schmauss <erik.schmauss@intel.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Some BIOSen do not handle 0-byte transfer lengths for the _LSR and _LSW
(label storage read/write) methods. This causes Linux to fallback to the
deprecated _DSM path, or otherwise disable label support.

Introduce acpi_nvdimm_has_method() to detect whether a method is
available rather than calling the method, require _LSI and _LSR to be
paired, and require read support before enabling write support.

Cc: <stable@vger.kernel.org>
Fixes: 4b27db7e26cd ("acpi, nfit: add support for the _LS...")
Suggested-by: Erik Schmauss <erik.schmauss@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   41 +++++++++++++++++++++--------------------
 drivers/acpi/nfit/nfit.h |    5 ++---
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 4530d89044db..12fb414fa678 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -196,7 +196,7 @@ static int xlat_nvdimm_status(struct nvdimm *nvdimm, void *buf, unsigned int cmd
 		 * In the _LSI, _LSR, _LSW case the locked status is
 		 * communicated via the read/write commands
 		 */
-		if (nfit_mem->has_lsi)
+		if (nfit_mem->has_lsr)
 			break;
 
 		if (status >> 16 & ND_CONFIG_LOCKED)
@@ -483,7 +483,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 			min_t(u32, 256, in_buf.buffer.length), true);
 
 	/* call the BIOS, prefer the named methods over _DSM if available */
-	if (nvdimm && cmd == ND_CMD_GET_CONFIG_SIZE && nfit_mem->has_lsi)
+	if (nvdimm && cmd == ND_CMD_GET_CONFIG_SIZE && nfit_mem->has_lsr)
 		out_obj = acpi_label_info(handle);
 	else if (nvdimm && cmd == ND_CMD_GET_CONFIG_DATA && nfit_mem->has_lsr) {
 		struct nd_cmd_get_config_data_hdr *p = buf;
@@ -1653,12 +1653,23 @@ static void acpi_nvdimm_notify(acpi_handle handle, u32 event, void *data)
 	device_unlock(dev->parent);
 }
 
+static bool acpi_nvdimm_has_method(struct acpi_device *adev, char *method)
+{
+	acpi_handle handle;
+	acpi_status status;
+
+	status = acpi_get_handle(adev->handle, method, &handle);
+
+	if (ACPI_SUCCESS(status))
+		return true;
+	return false;
+}
+
 static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_mem *nfit_mem, u32 device_handle)
 {
 	struct acpi_device *adev, *adev_dimm;
 	struct device *dev = acpi_desc->dev;
-	union acpi_object *obj;
 	unsigned long dsm_mask;
 	const guid_t *guid;
 	int i;
@@ -1731,25 +1742,15 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 					1ULL << i))
 			set_bit(i, &nfit_mem->dsm_mask);
 
-	obj = acpi_label_info(adev_dimm->handle);
-	if (obj) {
-		ACPI_FREE(obj);
-		nfit_mem->has_lsi = 1;
-		dev_dbg(dev, "%s: has _LSI\n", dev_name(&adev_dimm->dev));
-	}
-
-	obj = acpi_label_read(adev_dimm->handle, 0, 0);
-	if (obj) {
-		ACPI_FREE(obj);
-		nfit_mem->has_lsr = 1;
+	if (acpi_nvdimm_has_method(adev_dimm, "_LSI")
+			&& acpi_nvdimm_has_method(adev_dimm, "_LSR")) {
 		dev_dbg(dev, "%s: has _LSR\n", dev_name(&adev_dimm->dev));
+		nfit_mem->has_lsr = true;
 	}
 
-	obj = acpi_label_write(adev_dimm->handle, 0, 0, NULL);
-	if (obj) {
-		ACPI_FREE(obj);
-		nfit_mem->has_lsw = 1;
+	if (nfit_mem->has_lsr && acpi_nvdimm_has_method(adev_dimm, "_LSW")) {
 		dev_dbg(dev, "%s: has _LSW\n", dev_name(&adev_dimm->dev));
+		nfit_mem->has_lsw = true;
 	}
 
 	return 0;
@@ -1838,10 +1839,10 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 			cmd_mask |= nfit_mem->dsm_mask & NVDIMM_STANDARD_CMDMASK;
 		}
 
-		if (nfit_mem->has_lsi)
+		if (nfit_mem->has_lsr) {
 			set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
-		if (nfit_mem->has_lsr)
 			set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
+		}
 		if (nfit_mem->has_lsw)
 			set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
 
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 50d36e166d70..ac9c49463731 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -171,9 +171,8 @@ struct nfit_mem {
 	struct resource *flush_wpq;
 	unsigned long dsm_mask;
 	int family;
-	u32 has_lsi:1;
-	u32 has_lsr:1;
-	u32 has_lsw:1;
+	bool has_lsr;
+	bool has_lsw;
 };
 
 struct acpi_nfit_desc {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
