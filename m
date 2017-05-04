Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C9E9C21A070BA
 for <linux-nvdimm@lists.01.org>; Thu,  4 May 2017 15:48:56 -0700 (PDT)
Subject: [PATCH 1/2] libnvdimm: convert NDD_ flags to use bitops,
 introduce NDD_LOCKED
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 04 May 2017 15:43:04 -0700
Message-ID: <149393778452.34042.11808841820577827779.stgit@dwillia2-desk3.amr.corp.intel.com>
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

This is a preparation patch for handling locked nvdimm label regions, a
new concept as introduced by the latest DSM document on pmem.io [1]. A
future patch will leverage nvdimm_set_locked() at DIMM probe time to
flag regions that can not be enabled. There should be no functional
difference resulting from this change.

[1]: http://pmem.io/documents/NVDIMM_DSM_Interface_Example-V1.3.pdf

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c        |    4 ++--
 drivers/nvdimm/dimm_devs.c      |   11 +++++++++--
 drivers/nvdimm/namespace_devs.c |    2 +-
 drivers/nvdimm/nd.h             |    1 +
 drivers/nvdimm/region_devs.c    |    4 ++--
 include/linux/libnvdimm.h       |    6 ++++--
 6 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index ced95a79c1a1..a26c2297c1ed 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1512,7 +1512,7 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		}
 
 		if (nfit_mem->bdw && nfit_mem->memdev_pmem)
-			flags |= NDD_ALIASING;
+			set_bit(NDD_ALIASING, &flags);
 
 		/* collate flags across all memdevs for this dimm */
 		list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
@@ -1527,7 +1527,7 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 
 		mem_flags = __to_nfit_memdev(nfit_mem)->flags;
 		if (mem_flags & ACPI_NFIT_MEM_NOT_ARMED)
-			flags |= NDD_UNARMED;
+			set_bit(NDD_UNARMED, &flags);
 
 		rc = acpi_nfit_add_dimm(acpi_desc, nfit_mem, device_handle);
 		if (rc)
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 8b721321be5b..7d1a3dbc7d5d 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -34,7 +34,7 @@ int nvdimm_check_config_data(struct device *dev)
 
 	if (!nvdimm->cmd_mask ||
 	    !test_bit(ND_CMD_GET_CONFIG_DATA, &nvdimm->cmd_mask)) {
-		if (nvdimm->flags & NDD_ALIASING)
+		if (test_bit(NDD_ALIASING, &nvdimm->flags))
 			return -ENXIO;
 		else
 			return -ENOTTY;
@@ -188,7 +188,14 @@ void nvdimm_set_aliasing(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 
-	nvdimm->flags |= NDD_ALIASING;
+	set_bit(NDD_ALIASING, &nvdimm->flags);
+}
+
+void nvdimm_set_locked(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	set_bit(NDD_LOCKED, &nvdimm->flags);
 }
 
 static void nvdimm_release(struct device *dev)
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 1b481a5fb966..2f2d8afc684a 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2240,7 +2240,7 @@ static int init_active_labels(struct nd_region *nd_region)
 		 * being activated if it aliases DPA.
 		 */
 		if (!ndd) {
-			if ((nvdimm->flags & NDD_ALIASING) == 0)
+			if (!test_bit(NDD_ALIASING, &nvdimm->flags))
 				return 0;
 			dev_dbg(&nd_region->dev, "%s: is disabled, failing probe\n",
 					dev_name(&nd_mapping->nvdimm->dev));
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index c3b33cf655fb..77d032192bf7 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -240,6 +240,7 @@ int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 		unsigned int len);
 void nvdimm_set_aliasing(struct device *dev);
+void nvdimm_set_locked(struct device *dev);
 struct nd_btt *to_nd_btt(struct device *dev);
 
 struct nd_gen_sb {
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 07756b2e1cd5..b550edf2571f 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -222,7 +222,7 @@ int nd_region_to_nstype(struct nd_region *nd_region)
 			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 			struct nvdimm *nvdimm = nd_mapping->nvdimm;
 
-			if (nvdimm->flags & NDD_ALIASING)
+			if (test_bit(NDD_ALIASING, &nvdimm->flags))
 				alias++;
 		}
 		if (alias)
@@ -881,7 +881,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 			return NULL;
 		}
 
-		if (nvdimm->flags & NDD_UNARMED)
+		if (test_bit(NDD_UNARMED, &nvdimm->flags))
 			ro = 1;
 	}
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index f07b1b14159a..6c807017128d 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -20,9 +20,11 @@
 
 enum {
 	/* when a dimm supports both PMEM and BLK access a label is required */
-	NDD_ALIASING = 1 << 0,
+	NDD_ALIASING = 0,
 	/* unarmed memory devices may not persist writes */
-	NDD_UNARMED = 1 << 1,
+	NDD_UNARMED = 1,
+	/* locked memory devices should not be accessed */
+	NDD_LOCKED = 2,
 
 	/* need to set a limit somewhere, but yes, this is likely overkill */
 	ND_IOCTL_MAX_BUFLEN = SZ_4M,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
