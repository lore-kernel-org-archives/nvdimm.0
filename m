Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A36C22115990D
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 21:37:28 -0700 (PDT)
Subject: [PATCH 3/3] tools/testing/nvdimm: Populate dirty shutdown data
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Sep 2018 21:24:36 -0700
Message-ID: <153802227683.833068.14067072355792705345.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153802226065.833068.11943510429252969385.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153802226065.833068.11943510429252969385.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Allow the unit tests to verify the retrieval of the dirty shutdown
count via smart commands, and allow the driver-load-time retrieval of
the smart health payload to be simulated by nfit_test.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c              |   14 ++++++++------
 tools/testing/nvdimm/Kbuild           |    1 +
 tools/testing/nvdimm/acpi_nfit_test.c |    8 ++++++++
 tools/testing/nvdimm/test/nfit.c      |    3 ++-
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index c28b4d0dbe51..3880b5ac40e4 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1721,7 +1721,7 @@ static bool acpi_nvdimm_has_method(struct acpi_device *adev, char *method)
 	return false;
 }
 
-static void nfit_intel_shutdown_status(struct nfit_mem *nfit_mem)
+__weak void nfit_intel_shutdown_status(struct nfit_mem *nfit_mem)
 {
 	struct nd_intel_smart smart = { 0 };
 	union acpi_object in_buf = {
@@ -1782,10 +1782,6 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	int family = -1;
 	struct acpi_nfit_control_region *dcr = nfit_mem->dcr;
 
-	/* nfit test assumes 1:1 relationship between commands and dsms */
-	nfit_mem->dsm_mask = acpi_desc->dimm_cmd_force_en;
-	nfit_mem->family = NVDIMM_FAMILY_INTEL;
-
 	if (dcr->valid_fields & ACPI_NFIT_CONTROL_MFG_INFO_VALID)
 		sprintf(nfit_mem->id, "%04x-%02x-%04x-%08x",
 				be16_to_cpu(dcr->vendor_id),
@@ -1797,9 +1793,15 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 				be16_to_cpu(dcr->vendor_id),
 				be32_to_cpu(dcr->serial_number));
 
+	/* nfit test assumes 1:1 relationship between commands and dsms */
+	nfit_mem->dsm_mask = acpi_desc->dimm_cmd_force_en;
+	nfit_mem->family = NVDIMM_FAMILY_INTEL;
 	adev = to_acpi_dev(acpi_desc);
-	if (!adev)
+	if (!adev) {
+		/* unit test case */
+		populate_shutdown_status(nfit_mem);
 		return 0;
+	}
 
 	adev_dimm = acpi_find_child_device(adev, device_handle, false);
 	nfit_mem->adev = adev_dimm;
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index a13670d3b389..03f00a6e0841 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -22,6 +22,7 @@ NVDIMM_SRC := $(DRIVERS)/nvdimm
 ACPI_SRC := $(DRIVERS)/acpi/nfit
 DAX_SRC := $(DRIVERS)/dax
 ccflags-y := -I$(src)/$(NVDIMM_SRC)/
+ccflags-y += -I$(src)/$(ACPI_SRC)/
 
 obj-$(CONFIG_LIBNVDIMM) += libnvdimm.o
 obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
diff --git a/tools/testing/nvdimm/acpi_nfit_test.c b/tools/testing/nvdimm/acpi_nfit_test.c
index 43521512e577..fec8fb1b7715 100644
--- a/tools/testing/nvdimm/acpi_nfit_test.c
+++ b/tools/testing/nvdimm/acpi_nfit_test.c
@@ -4,5 +4,13 @@
 #include <linux/module.h>
 #include <linux/printk.h>
 #include "watermark.h"
+#include <nfit.h>
 
 nfit_test_watermark(acpi_nfit);
+
+/* strong / override definition of nfit_intel_shutdown_status */
+void nfit_intel_shutdown_status(struct nfit_mem *nfit_mem)
+{
+	set_bit(NFIT_MEM_DIRTY_COUNT, &nfit_mem->flags);
+	nfit_mem->dirty_shutdown = 42;
+}
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 61ad16beef6d..c6e72f795f4f 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -149,6 +149,7 @@ static const struct nd_intel_smart smart_def = {
 		| ND_INTEL_SMART_ALARM_VALID
 		| ND_INTEL_SMART_USED_VALID
 		| ND_INTEL_SMART_SHUTDOWN_VALID
+		| ND_INTEL_SMART_SHUTDOWN_COUNT_VALID
 		| ND_INTEL_SMART_MTEMP_VALID
 		| ND_INTEL_SMART_CTEMP_VALID,
 	.health = ND_INTEL_SMART_NON_CRITICAL_HEALTH,
@@ -161,8 +162,8 @@ static const struct nd_intel_smart smart_def = {
 	.ait_status = 1,
 	.life_used = 5,
 	.shutdown_state = 0,
+	.shutdown_count = 42,
 	.vendor_size = 0,
-	.shutdown_count = 100,
 };
 
 struct nfit_test_fw {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
