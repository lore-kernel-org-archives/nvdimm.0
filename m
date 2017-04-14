Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D6E822194EB64
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 15:03:11 -0700 (PDT)
Subject: [PATCH v2 4/7] acpi, nfit: support "map failed" dimms
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 14:57:27 -0700
Message-ID: <149220704691.36563.10986793740530987407.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149220702552.36563.10552898152402020832.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149220702552.36563.10552898152402020832.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Stop requiring dimms be successfully mapped into a
system-physical-address range. For provisioning and hardware remediation
purposes the kernel should account for failed devices in sysfs. If
possible it should still allow management commands to be sent to the
device.

Reported-by: Toshi Kani <toshi.kani@hpe.com>
Reported-by: Linda Knippers <linda.knippers@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   53 ++++++++++++++++++++++++++++++++++++----------
 drivers/acpi/nfit/nfit.h |    2 +-
 2 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 05829de43b1d..2bd842c46fbb 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -738,28 +738,38 @@ static void nfit_mem_init_bdw(struct acpi_nfit_desc *acpi_desc,
 	}
 }
 
-static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
+static int __nfit_mem_init(struct acpi_nfit_desc *acpi_desc,
 		struct acpi_nfit_system_address *spa)
 {
 	struct nfit_mem *nfit_mem, *found;
 	struct nfit_memdev *nfit_memdev;
-	int type = nfit_spa_type(spa);
+	int type = spa ? nfit_spa_type(spa) : 0;
 
 	switch (type) {
 	case NFIT_SPA_DCR:
 	case NFIT_SPA_PM:
 		break;
 	default:
-		return 0;
+		if (spa)
+			return 0;
 	}
 
+	/*
+	 * This loop runs in two modes, when a dimm is mapped the loop
+	 * adds memdev associations to an existing dimm, or creates a
+	 * dimm. In the unmapped dimm case this loop sweeps for memdev
+	 * instances with an invalid / zero range_index and adds those
+	 * dimms without spa associations.
+	 */
 	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
 		struct nfit_flush *nfit_flush;
 		struct nfit_dcr *nfit_dcr;
 		u32 device_handle;
 		u16 dcr;
 
-		if (nfit_memdev->memdev->range_index != spa->range_index)
+		if (spa && nfit_memdev->memdev->range_index != spa->range_index)
+			continue;
+		if (!spa && nfit_memdev->memdev->range_index)
 			continue;
 		found = NULL;
 		dcr = nfit_memdev->memdev->region_index;
@@ -844,14 +854,15 @@ static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
 				break;
 			}
 			nfit_mem_init_bdw(acpi_desc, nfit_mem, spa);
-		} else {
+		} else if (type == NFIT_SPA_PM) {
 			/*
 			 * A single dimm may belong to multiple SPA-PM
 			 * ranges, record at least one in addition to
 			 * any SPA-DCR range.
 			 */
 			nfit_mem->memdev_pmem = nfit_memdev->memdev;
-		}
+		} else
+			nfit_mem->memdev_dcr = nfit_memdev->memdev;
 	}
 
 	return 0;
@@ -875,6 +886,8 @@ static int nfit_mem_cmp(void *priv, struct list_head *_a, struct list_head *_b)
 static int nfit_mem_init(struct acpi_nfit_desc *acpi_desc)
 {
 	struct nfit_spa *nfit_spa;
+	int rc;
+
 
 	/*
 	 * For each SPA-DCR or SPA-PMEM address range find its
@@ -885,13 +898,20 @@ static int nfit_mem_init(struct acpi_nfit_desc *acpi_desc)
 	 * BDWs are optional.
 	 */
 	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
-		int rc;
-
-		rc = nfit_mem_dcr_init(acpi_desc, nfit_spa->spa);
+		rc = __nfit_mem_init(acpi_desc, nfit_spa->spa);
 		if (rc)
 			return rc;
 	}
 
+	/*
+	 * If a DIMM has failed to be mapped into SPA there will be no
+	 * SPA entries above. Find and register all the unmapped DIMMs
+	 * for reporting and recovery purposes.
+	 */
+	rc = __nfit_mem_init(acpi_desc, NULL);
+	if (rc)
+		return rc;
+
 	list_sort(NULL, &acpi_desc->dimms, nfit_mem_cmp);
 
 	return 0;
@@ -1301,8 +1321,16 @@ static umode_t acpi_nfit_dimm_attr_visible(struct kobject *kobj,
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 
-	if (!to_nfit_dcr(dev))
+	if (!to_nfit_dcr(dev)) {
+		/* Without a dcr only the memdev attributes can be surfaced */
+		if (a == &dev_attr_handle.attr || a == &dev_attr_phys_id.attr
+				|| a == &dev_attr_flags.attr
+				|| a == &dev_attr_family.attr
+				|| a == &dev_attr_dsm_mask.attr)
+			return a->mode;
 		return 0;
+	}
+
 	if (a == &dev_attr_format1.attr && num_nvdimm_formats(nvdimm) <= 1)
 		return 0;
 	return a->mode;
@@ -1522,12 +1550,13 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		if ((mem_flags & ACPI_NFIT_MEM_FAILED_MASK) == 0)
 			continue;
 
-		dev_info(acpi_desc->dev, "%s flags:%s%s%s%s\n",
+		dev_info(acpi_desc->dev, "%s flags:%s%s%s%s%s\n",
 				nvdimm_name(nvdimm),
 		  mem_flags & ACPI_NFIT_MEM_SAVE_FAILED ? " save_fail" : "",
 		  mem_flags & ACPI_NFIT_MEM_RESTORE_FAILED ? " restore_fail":"",
 		  mem_flags & ACPI_NFIT_MEM_FLUSH_FAILED ? " flush_fail" : "",
-		  mem_flags & ACPI_NFIT_MEM_NOT_ARMED ? " not_armed" : "");
+		  mem_flags & ACPI_NFIT_MEM_NOT_ARMED ? " not_armed" : "",
+		  mem_flags & ACPI_NFIT_MEM_MAP_FAILED ? " map_fail" : "");
 
 	}
 
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index fc29c2e9832e..aaabd2721f8e 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -37,7 +37,7 @@
 
 #define ACPI_NFIT_MEM_FAILED_MASK (ACPI_NFIT_MEM_SAVE_FAILED \
 		| ACPI_NFIT_MEM_RESTORE_FAILED | ACPI_NFIT_MEM_FLUSH_FAILED \
-		| ACPI_NFIT_MEM_NOT_ARMED)
+		| ACPI_NFIT_MEM_NOT_ARMED | ACPI_NFIT_MEM_MAP_FAILED)
 
 enum nfit_uuids {
 	/* for simplicity alias the uuid index with the family id */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
