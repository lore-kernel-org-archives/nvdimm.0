Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 56DC81A1E72
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 09:13:01 -0700 (PDT)
Subject: [PATCH 2/2] tools/testing/nvdimm: dynamic label support
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Oct 2016 09:09:59 -0700
Message-ID: <147689339900.9946.4176607017956495677.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147689338812.9946.11071407155879544366.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147689338812.9946.11071407155879544366.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Update nfit_test infrastructure to enable labels for the dimm on the
nfit_test.1 bus.  This bus has a pmem region without aliased blk space,
so it is a candidate for dynamically enabling label support by writing
a namespace index block.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index c9a6458cb63e..c02f9a8bd382 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -124,12 +124,13 @@ struct nfit_test_dcr {
 	(((node & 0xfff) << 16) | ((socket & 0xf) << 12) \
 	 | ((imc & 0xf) << 8) | ((chan & 0xf) << 4) | (dimm & 0xf))
 
-static u32 handle[NUM_DCR] = {
+static u32 handle[] = {
 	[0] = NFIT_DIMM_HANDLE(0, 0, 0, 0, 0),
 	[1] = NFIT_DIMM_HANDLE(0, 0, 0, 0, 1),
 	[2] = NFIT_DIMM_HANDLE(0, 0, 1, 0, 0),
 	[3] = NFIT_DIMM_HANDLE(0, 0, 1, 0, 1),
 	[4] = NFIT_DIMM_HANDLE(0, 1, 0, 0, 0),
+	[5] = NFIT_DIMM_HANDLE(1, 0, 0, 0, 0),
 };
 
 static unsigned long dimm_fail_cmd_flags[NUM_DCR];
@@ -141,6 +142,7 @@ struct nfit_test {
 	void *nfit_buf;
 	dma_addr_t nfit_dma;
 	size_t nfit_size;
+	int dcr_idx;
 	int num_dcr;
 	int num_pm;
 	void **dimm;
@@ -425,11 +427,11 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 			break;
 		case ND_CMD_GET_CONFIG_DATA:
 			rc = nfit_test_cmd_get_config_data(buf, buf_len,
-				t->label[i]);
+				t->label[i - t->dcr_idx]);
 			break;
 		case ND_CMD_SET_CONFIG_DATA:
 			rc = nfit_test_cmd_set_config_data(buf, buf_len,
-				t->label[i]);
+				t->label[i - t->dcr_idx]);
 			break;
 		case ND_CMD_SMART:
 			rc = nfit_test_cmd_smart(buf, buf_len);
@@ -681,7 +683,7 @@ static int nfit_test0_alloc(struct nfit_test *t)
 	if (!t->spa_set[2])
 		return -ENOMEM;
 
-	for (i = 0; i < NUM_DCR; i++) {
+	for (i = 0; i < t->num_dcr; i++) {
 		t->dimm[i] = test_alloc(t, DIMM_SIZE, &t->dimm_dma[i]);
 		if (!t->dimm[i])
 			return -ENOMEM;
@@ -698,7 +700,7 @@ static int nfit_test0_alloc(struct nfit_test *t)
 			return -ENOMEM;
 	}
 
-	for (i = 0; i < NUM_DCR; i++) {
+	for (i = 0; i < t->num_dcr; i++) {
 		t->dcr[i] = test_alloc(t, LABEL_SIZE, &t->dcr_dma[i]);
 		if (!t->dcr[i])
 			return -ENOMEM;
@@ -727,6 +729,7 @@ static int nfit_test1_alloc(struct nfit_test *t)
 	size_t nfit_size = sizeof(struct acpi_nfit_system_address) * 2
 		+ sizeof(struct acpi_nfit_memory_map)
 		+ offsetof(struct acpi_nfit_control_region, window_size);
+	int i;
 
 	t->nfit_buf = test_alloc(t, nfit_size, &t->nfit_dma);
 	if (!t->nfit_buf)
@@ -737,6 +740,13 @@ static int nfit_test1_alloc(struct nfit_test *t)
 	if (!t->spa_set[0])
 		return -ENOMEM;
 
+	for (i = 0; i < t->num_dcr; i++) {
+		t->label[i] = test_alloc(t, LABEL_SIZE, &t->label_dma[i]);
+		if (!t->label[i])
+			return -ENOMEM;
+		sprintf(t->label[i], "label%d", i);
+	}
+
 	t->spa_set[1] = test_alloc(t, SPA_VCD_SIZE, &t->spa_set_dma[1]);
 	if (!t->spa_set[1])
 		return -ENOMEM;
@@ -1449,7 +1459,7 @@ static void nfit_test1_setup(struct nfit_test *t)
 	memdev = nfit_buf + offset;
 	memdev->header.type = ACPI_NFIT_TYPE_MEMORY_MAP;
 	memdev->header.length = sizeof(*memdev);
-	memdev->device_handle = 0;
+	memdev->device_handle = handle[5];
 	memdev->physical_id = 0;
 	memdev->region_id = 0;
 	memdev->range_index = 0+1;
@@ -1471,7 +1481,7 @@ static void nfit_test1_setup(struct nfit_test *t)
 			window_size);
 	dcr->region_index = 0+1;
 	dcr_common_init(dcr);
-	dcr->serial_number = ~0;
+	dcr->serial_number = ~handle[5];
 	dcr->code = NFIT_FIC_BYTE;
 	dcr->windows = 0;
 
@@ -1482,6 +1492,9 @@ static void nfit_test1_setup(struct nfit_test *t)
 	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_cmd_force_en);
 	set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_cmd_force_en);
 	set_bit(ND_CMD_CLEAR_ERROR, &acpi_desc->bus_cmd_force_en);
+	set_bit(ND_CMD_GET_CONFIG_SIZE, &acpi_desc->dimm_cmd_force_en);
+	set_bit(ND_CMD_GET_CONFIG_DATA, &acpi_desc->dimm_cmd_force_en);
+	set_bit(ND_CMD_SET_CONFIG_DATA, &acpi_desc->dimm_cmd_force_en);
 }
 
 static int nfit_test_blk_do_io(struct nd_blk_region *ndbr, resource_size_t dpa,
@@ -1658,12 +1671,15 @@ static __init int nfit_test_init(void)
 		switch (i) {
 		case 0:
 			nfit_test->num_pm = NUM_PM;
+			nfit_test->dcr_idx = 0;
 			nfit_test->num_dcr = NUM_DCR;
 			nfit_test->alloc = nfit_test0_alloc;
 			nfit_test->setup = nfit_test0_setup;
 			break;
 		case 1:
 			nfit_test->num_pm = 1;
+			nfit_test->dcr_idx = NUM_DCR;
+			nfit_test->num_dcr = 1;
 			nfit_test->alloc = nfit_test1_alloc;
 			nfit_test->setup = nfit_test1_setup;
 			break;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
