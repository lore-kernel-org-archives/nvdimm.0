Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 3/3] nfit,
 tools/testing/nvdimm: test multiple control regions per-dimm
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 08 Feb 2016 10:31:09 -0800
Message-ID: <20160208183109.27820.41485.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160208183052.27820.68922.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160208183052.27820.68922.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.1 clarifies that "The system shall include an NVDIMM Control
Region Structure for every Function Interface in the NVDIMM."
Implement this clarification in nfit_test.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |  118 ++++++++++++++++++++++++++++++--------
 1 file changed, 94 insertions(+), 24 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index f9d37143e264..f4f15c544d66 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -425,6 +425,8 @@ static int nfit_test0_alloc(struct nfit_test *t)
 	size_t nfit_size = sizeof(struct acpi_nfit_system_address) * NUM_SPA
 			+ sizeof(struct acpi_nfit_memory_map) * NUM_MEM
 			+ sizeof(struct acpi_nfit_control_region) * NUM_DCR
+			+ offsetof(struct acpi_nfit_control_region,
+					window_size) * NUM_DCR
 			+ sizeof(struct acpi_nfit_data_region) * NUM_BDW
 			+ sizeof(struct acpi_nfit_flush_address) * NUM_DCR;
 	int i;
@@ -474,7 +476,7 @@ static int nfit_test1_alloc(struct nfit_test *t)
 {
 	size_t nfit_size = sizeof(struct acpi_nfit_system_address)
 		+ sizeof(struct acpi_nfit_memory_map)
-		+ sizeof(struct acpi_nfit_control_region);
+		+ offsetof(struct acpi_nfit_control_region, window_size);
 
 	t->nfit_buf = test_alloc(t, nfit_size, &t->nfit_dma);
 	if (!t->nfit_buf)
@@ -607,7 +609,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	memdev->physical_id = 0;
 	memdev->region_id = 0;
 	memdev->range_index = 0+1;
-	memdev->region_index = 0+1;
+	memdev->region_index = 4+1;
 	memdev->region_size = SPA0_SIZE/2;
 	memdev->region_offset = t->spa_set_dma[0];
 	memdev->address = 0;
@@ -622,7 +624,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	memdev->physical_id = 1;
 	memdev->region_id = 0;
 	memdev->range_index = 0+1;
-	memdev->region_index = 1+1;
+	memdev->region_index = 5+1;
 	memdev->region_size = SPA0_SIZE/2;
 	memdev->region_offset = t->spa_set_dma[0] + SPA0_SIZE/2;
 	memdev->address = 0;
@@ -637,7 +639,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	memdev->physical_id = 0;
 	memdev->region_id = 1;
 	memdev->range_index = 1+1;
-	memdev->region_index = 0+1;
+	memdev->region_index = 4+1;
 	memdev->region_size = SPA1_SIZE/4;
 	memdev->region_offset = t->spa_set_dma[1];
 	memdev->address = SPA0_SIZE/2;
@@ -652,7 +654,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	memdev->physical_id = 1;
 	memdev->region_id = 1;
 	memdev->range_index = 1+1;
-	memdev->region_index = 1+1;
+	memdev->region_index = 5+1;
 	memdev->region_size = SPA1_SIZE/4;
 	memdev->region_offset = t->spa_set_dma[1] + SPA1_SIZE/4;
 	memdev->address = SPA0_SIZE/2;
@@ -667,7 +669,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	memdev->physical_id = 2;
 	memdev->region_id = 0;
 	memdev->range_index = 1+1;
-	memdev->region_index = 2+1;
+	memdev->region_index = 6+1;
 	memdev->region_size = SPA1_SIZE/4;
 	memdev->region_offset = t->spa_set_dma[1] + 2*SPA1_SIZE/4;
 	memdev->address = SPA0_SIZE/2;
@@ -682,7 +684,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	memdev->physical_id = 3;
 	memdev->region_id = 0;
 	memdev->range_index = 1+1;
-	memdev->region_index = 3+1;
+	memdev->region_index = 7+1;
 	memdev->region_size = SPA1_SIZE/4;
 	memdev->region_offset = t->spa_set_dma[1] + 3*SPA1_SIZE/4;
 	memdev->address = SPA0_SIZE/2;
@@ -810,7 +812,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	memdev->interleave_ways = 1;
 
 	offset = offset + sizeof(struct acpi_nfit_memory_map) * 14;
-	/* dcr-descriptor0 */
+	/* dcr-descriptor0: blk */
 	dcr = nfit_buf + offset;
 	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
 	dcr->header.length = sizeof(struct acpi_nfit_control_region);
@@ -827,7 +829,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	dcr->status_offset = 8;
 	dcr->status_size = 4;
 
-	/* dcr-descriptor1 */
+	/* dcr-descriptor1: blk */
 	dcr = nfit_buf + offset + sizeof(struct acpi_nfit_control_region);
 	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
 	dcr->header.length = sizeof(struct acpi_nfit_control_region);
@@ -844,7 +846,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	dcr->status_offset = 8;
 	dcr->status_size = 4;
 
-	/* dcr-descriptor2 */
+	/* dcr-descriptor2: blk */
 	dcr = nfit_buf + offset + sizeof(struct acpi_nfit_control_region) * 2;
 	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
 	dcr->header.length = sizeof(struct acpi_nfit_control_region);
@@ -861,7 +863,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	dcr->status_offset = 8;
 	dcr->status_size = 4;
 
-	/* dcr-descriptor3 */
+	/* dcr-descriptor3: blk */
 	dcr = nfit_buf + offset + sizeof(struct acpi_nfit_control_region) * 3;
 	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
 	dcr->header.length = sizeof(struct acpi_nfit_control_region);
@@ -879,6 +881,63 @@ static void nfit_test0_setup(struct nfit_test *t)
 	dcr->status_size = 4;
 
 	offset = offset + sizeof(struct acpi_nfit_control_region) * 4;
+	/* dcr-descriptor0: pmem */
+	dcr = nfit_buf + offset;
+	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
+	dcr->header.length = offsetof(struct acpi_nfit_control_region,
+			window_size);
+	dcr->region_index = 4+1;
+	dcr->vendor_id = 0xabcd;
+	dcr->device_id = 0;
+	dcr->revision_id = 1;
+	dcr->serial_number = ~handle[0];
+	dcr->code = NFIT_FIC_BYTEN;
+	dcr->windows = 0;
+
+	/* dcr-descriptor1: pmem */
+	dcr = nfit_buf + offset + offsetof(struct acpi_nfit_control_region,
+			window_size);
+	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
+	dcr->header.length = offsetof(struct acpi_nfit_control_region,
+			window_size);
+	dcr->region_index = 5+1;
+	dcr->vendor_id = 0xabcd;
+	dcr->device_id = 0;
+	dcr->revision_id = 1;
+	dcr->serial_number = ~handle[1];
+	dcr->code = NFIT_FIC_BYTEN;
+	dcr->windows = 0;
+
+	/* dcr-descriptor2: pmem */
+	dcr = nfit_buf + offset + offsetof(struct acpi_nfit_control_region,
+			window_size) * 2;
+	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
+	dcr->header.length = offsetof(struct acpi_nfit_control_region,
+			window_size);
+	dcr->region_index = 6+1;
+	dcr->vendor_id = 0xabcd;
+	dcr->device_id = 0;
+	dcr->revision_id = 1;
+	dcr->serial_number = ~handle[2];
+	dcr->code = NFIT_FIC_BYTEN;
+	dcr->windows = 0;
+
+	/* dcr-descriptor3: pmem */
+	dcr = nfit_buf + offset + offsetof(struct acpi_nfit_control_region,
+			window_size) * 3;
+	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
+	dcr->header.length = offsetof(struct acpi_nfit_control_region,
+			window_size);
+	dcr->region_index = 7+1;
+	dcr->vendor_id = 0xabcd;
+	dcr->device_id = 0;
+	dcr->revision_id = 1;
+	dcr->serial_number = ~handle[3];
+	dcr->code = NFIT_FIC_BYTEN;
+	dcr->windows = 0;
+
+	offset = offset + offsetof(struct acpi_nfit_control_region,
+			window_size) * 4;
 	/* bdw0 (spa/dcr0, dimm0) */
 	bdw = nfit_buf + offset;
 	bdw->header.type = ACPI_NFIT_TYPE_DATA_REGION;
@@ -958,11 +1017,11 @@ static void nfit_test0_setup(struct nfit_test *t)
 
 	if (t->setup_hotplug) {
 		offset = offset + sizeof(struct acpi_nfit_flush_address) * 4;
-		/* dcr-descriptor4 */
+		/* dcr-descriptor4: blk */
 		dcr = nfit_buf + offset;
 		dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
 		dcr->header.length = sizeof(struct acpi_nfit_control_region);
-		dcr->region_index = 4+1;
+		dcr->region_index = 8+1;
 		dcr->vendor_id = 0xabcd;
 		dcr->device_id = 0;
 		dcr->revision_id = 1;
@@ -976,11 +1035,26 @@ static void nfit_test0_setup(struct nfit_test *t)
 		dcr->status_size = 4;
 
 		offset = offset + sizeof(struct acpi_nfit_control_region);
+		/* dcr-descriptor4: pmem */
+		dcr = nfit_buf + offset;
+		dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
+		dcr->header.length = offsetof(struct acpi_nfit_control_region,
+				window_size);
+		dcr->region_index = 9+1;
+		dcr->vendor_id = 0xabcd;
+		dcr->device_id = 0;
+		dcr->revision_id = 1;
+		dcr->serial_number = ~handle[4];
+		dcr->code = NFIT_FIC_BYTEN;
+		dcr->windows = 0;
+
+		offset = offset + offsetof(struct acpi_nfit_control_region,
+				window_size);
 		/* bdw4 (spa/dcr4, dimm4) */
 		bdw = nfit_buf + offset;
 		bdw->header.type = ACPI_NFIT_TYPE_DATA_REGION;
 		bdw->header.length = sizeof(struct acpi_nfit_data_region);
-		bdw->region_index = 4+1;
+		bdw->region_index = 8+1;
 		bdw->windows = 1;
 		bdw->offset = 0;
 		bdw->size = BDW_SIZE;
@@ -1028,7 +1102,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 		memdev->physical_id = 4;
 		memdev->region_id = 0;
 		memdev->range_index = 10+1;
-		memdev->region_index = 4+1;
+		memdev->region_index = 8+1;
 		memdev->region_size = 0;
 		memdev->region_offset = 0;
 		memdev->address = 0;
@@ -1044,14 +1118,14 @@ static void nfit_test0_setup(struct nfit_test *t)
 		memdev->physical_id = 4;
 		memdev->region_id = 0;
 		memdev->range_index = 11+1;
-		memdev->region_index = 4+1;
+		memdev->region_index = 9+1;
 		memdev->region_size = SPA0_SIZE;
 		memdev->region_offset = t->spa_set_dma[2];
 		memdev->address = 0;
 		memdev->interleave_index = 0;
 		memdev->interleave_ways = 1;
 
-		/* mem-region16 (spa/dcr4, dimm4) */
+		/* mem-region16 (spa/bdw4, dimm4) */
 		memdev = nfit_buf + offset +
 				sizeof(struct acpi_nfit_memory_map) * 2;
 		memdev->header.type = ACPI_NFIT_TYPE_MEMORY_MAP;
@@ -1060,7 +1134,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 		memdev->physical_id = 4;
 		memdev->region_id = 0;
 		memdev->range_index = 12+1;
-		memdev->region_index = 4+1;
+		memdev->region_index = 8+1;
 		memdev->region_size = 0;
 		memdev->region_offset = 0;
 		memdev->address = 0;
@@ -1131,7 +1205,8 @@ static void nfit_test1_setup(struct nfit_test *t)
 	/* dcr-descriptor0 */
 	dcr = nfit_buf + offset;
 	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
-	dcr->header.length = sizeof(struct acpi_nfit_control_region);
+	dcr->header.length = offsetof(struct acpi_nfit_control_region,
+			window_size);
 	dcr->region_index = 0+1;
 	dcr->vendor_id = 0xabcd;
 	dcr->device_id = 0;
@@ -1139,11 +1214,6 @@ static void nfit_test1_setup(struct nfit_test *t)
 	dcr->serial_number = ~0;
 	dcr->code = NFIT_FIC_BYTE;
 	dcr->windows = 0;
-	dcr->window_size = 0;
-	dcr->command_offset = 0;
-	dcr->command_size = 0;
-	dcr->status_offset = 0;
-	dcr->status_size = 0;
 
 	acpi_desc = &t->acpi_desc;
 	set_bit(ND_CMD_ARS_CAP, &acpi_desc->bus_dsm_force_en);
