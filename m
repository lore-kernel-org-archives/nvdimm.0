Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8675320945BB0
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 13:53:33 -0700 (PDT)
Subject: [PATCH] libnvdimm: clear 'locked' status on successful DIMM enable
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Sep 2017 13:50:19 -0700
Message-ID: <150637261931.11427.8362421108300408075.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

If we successfully enable a DIMM then it must not be locked and we can
clear the label-read failure condition. Otherwise, we need to reload the
entire bus provider driver to achieve the same effect, and that can
disrupt unrelated DIMMs and namespaces.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/dimm.c      |    1 +
 drivers/nvdimm/dimm_devs.c |    7 +++++++
 drivers/nvdimm/nd.h        |    1 +
 3 files changed, 9 insertions(+)

diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index 862bcbd96366..f8913b8124b6 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -70,6 +70,7 @@ static int nvdimm_probe(struct device *dev)
 	rc = nd_label_reserve_dpa(ndd);
 	if (ndd->ns_current >= 0)
 		nvdimm_set_aliasing(dev);
+	nvdimm_clear_locked(dev);
 	nvdimm_bus_unlock(dev);
 
 	if (rc)
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index f0d1b7e5de01..5f1385b96b13 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -200,6 +200,13 @@ void nvdimm_set_locked(struct device *dev)
 	set_bit(NDD_LOCKED, &nvdimm->flags);
 }
 
+void nvdimm_clear_locked(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	clear_bit(NDD_LOCKED, &nvdimm->flags);
+}
+
 static void nvdimm_release(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 9c758a91372b..156be00e1f76 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -254,6 +254,7 @@ long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 		unsigned int len);
 void nvdimm_set_aliasing(struct device *dev);
 void nvdimm_set_locked(struct device *dev);
+void nvdimm_clear_locked(struct device *dev);
 struct nd_btt *to_nd_btt(struct device *dev);
 
 struct nd_gen_sb {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
