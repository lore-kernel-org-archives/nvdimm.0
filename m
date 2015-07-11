Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 4/6] tools/testing/nvdimm: add mock
 acpi_nfit_flush_address entries to nfit_test
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 11 Jul 2015 10:40:58 -0400
Message-ID: <20150711144058.25013.94870.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150711142806.25013.16924.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150711142806.25013.16924.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, ross.zwisler@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for fixing the BLK path to properly use "directed
pcommit" enable the unit test infrastructure to emit mock "flush"
tables.  Writes to these flush addresses trigger a memory controller to
flush its internal buffers to persistent media, similar to the x86
"pcommit" instruction.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/Kbuild       |    2 +
 tools/testing/nvdimm/test/iomap.c |   21 ++++++++++++++++
 tools/testing/nvdimm/test/nfit.c  |   50 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 8e020601c773..f56914c7929b 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -1,4 +1,6 @@
 ldflags-y += --wrap=ioremap_wt
+ldflags-y += --wrap=ioremap_wc
+ldflags-y += --wrap=devm_ioremap_nocache
 ldflags-y += --wrap=ioremap_cache
 ldflags-y += --wrap=ioremap_nocache
 ldflags-y += --wrap=iounmap
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index 9f21b150396b..64bfaa50831c 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -65,6 +65,21 @@ void __iomem *__nfit_test_ioremap(resource_size_t offset, unsigned long size,
 	return fallback_fn(offset, size);
 }
 
+void __iomem *__wrap_devm_ioremap_nocache(struct device *dev,
+		resource_size_t offset, unsigned long size)
+{
+	struct nfit_test_resource *nfit_res;
+
+	rcu_read_lock();
+	nfit_res = get_nfit_res(offset);
+	rcu_read_unlock();
+	if (nfit_res)
+		return (void __iomem *) nfit_res->buf + offset
+			- nfit_res->res->start;
+	return devm_ioremap_nocache(dev, offset, size);
+}
+EXPORT_SYMBOL(__wrap_devm_ioremap_nocache);
+
 void __iomem *__wrap_ioremap_cache(resource_size_t offset, unsigned long size)
 {
 	return __nfit_test_ioremap(offset, size, ioremap_cache);
@@ -83,6 +98,12 @@ void __iomem *__wrap_ioremap_wt(resource_size_t offset, unsigned long size)
 }
 EXPORT_SYMBOL(__wrap_ioremap_wt);
 
+void __iomem *__wrap_ioremap_wc(resource_size_t offset, unsigned long size)
+{
+	return __nfit_test_ioremap(offset, size, ioremap_wc);
+}
+EXPORT_SYMBOL(__wrap_ioremap_wc);
+
 void __wrap_iounmap(volatile void __iomem *addr)
 {
 	struct nfit_test_resource *nfit_res;
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 092d4724fe16..d0bdae40ccc9 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -128,6 +128,8 @@ struct nfit_test {
 	int num_pm;
 	void **dimm;
 	dma_addr_t *dimm_dma;
+	void **flush;
+	dma_addr_t *flush_dma;
 	void **label;
 	dma_addr_t *label_dma;
 	void **spa_set;
@@ -331,7 +333,8 @@ static int nfit_test0_alloc(struct nfit_test *t)
 			+ sizeof(struct acpi_nfit_system_address) * NUM_SPA
 			+ sizeof(struct acpi_nfit_memory_map) * NUM_MEM
 			+ sizeof(struct acpi_nfit_control_region) * NUM_DCR
-			+ sizeof(struct acpi_nfit_data_region) * NUM_BDW;
+			+ sizeof(struct acpi_nfit_data_region) * NUM_BDW
+			+ sizeof(struct acpi_nfit_flush_address) * NUM_DCR;
 	int i;
 
 	t->nfit_buf = test_alloc(t, nfit_size, &t->nfit_dma);
@@ -356,6 +359,10 @@ static int nfit_test0_alloc(struct nfit_test *t)
 		if (!t->label[i])
 			return -ENOMEM;
 		sprintf(t->label[i], "label%d", i);
+
+		t->flush[i] = test_alloc(t, 8, &t->flush_dma[i]);
+		if (!t->flush[i])
+			return -ENOMEM;
 	}
 
 	for (i = 0; i < NUM_DCR; i++) {
@@ -408,6 +415,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	struct acpi_nfit_system_address *spa;
 	struct acpi_nfit_control_region *dcr;
 	struct acpi_nfit_data_region *bdw;
+	struct acpi_nfit_flush_address *flush;
 	unsigned int offset;
 
 	nfit_test_init_header(nfit_buf, size);
@@ -831,6 +839,39 @@ static void nfit_test0_setup(struct nfit_test *t)
 	bdw->capacity = DIMM_SIZE;
 	bdw->start_address = 0;
 
+	offset = offset + sizeof(struct acpi_nfit_data_region) * 4;
+	/* flush0 (dimm0) */
+	flush = nfit_buf + offset;
+	flush->header.type = ACPI_NFIT_TYPE_FLUSH_ADDRESS;
+	flush->header.length = sizeof(struct acpi_nfit_flush_address);
+	flush->device_handle = handle[0];
+	flush->hint_count = 1;
+	flush->hint_address[0] = t->flush_dma[0];
+
+	/* flush1 (dimm1) */
+	flush = nfit_buf + offset + sizeof(struct acpi_nfit_flush_address) * 1;
+	flush->header.type = ACPI_NFIT_TYPE_FLUSH_ADDRESS;
+	flush->header.length = sizeof(struct acpi_nfit_flush_address);
+	flush->device_handle = handle[1];
+	flush->hint_count = 1;
+	flush->hint_address[0] = t->flush_dma[1];
+
+	/* flush2 (dimm2) */
+	flush = nfit_buf + offset + sizeof(struct acpi_nfit_flush_address) * 2;
+	flush->header.type = ACPI_NFIT_TYPE_FLUSH_ADDRESS;
+	flush->header.length = sizeof(struct acpi_nfit_flush_address);
+	flush->device_handle = handle[2];
+	flush->hint_count = 1;
+	flush->hint_address[0] = t->flush_dma[2];
+
+	/* flush3 (dimm3) */
+	flush = nfit_buf + offset + sizeof(struct acpi_nfit_flush_address) * 3;
+	flush->header.type = ACPI_NFIT_TYPE_FLUSH_ADDRESS;
+	flush->header.length = sizeof(struct acpi_nfit_flush_address);
+	flush->device_handle = handle[3];
+	flush->hint_count = 1;
+	flush->hint_address[0] = t->flush_dma[3];
+
 	acpi_desc = &t->acpi_desc;
 	set_bit(ND_CMD_GET_CONFIG_SIZE, &acpi_desc->dimm_dsm_force_en);
 	set_bit(ND_CMD_GET_CONFIG_DATA, &acpi_desc->dimm_dsm_force_en);
@@ -933,6 +974,10 @@ static int nfit_test_probe(struct platform_device *pdev)
 				GFP_KERNEL);
 		nfit_test->dimm_dma = devm_kcalloc(dev, num, sizeof(dma_addr_t),
 				GFP_KERNEL);
+		nfit_test->flush = devm_kcalloc(dev, num, sizeof(void *),
+				GFP_KERNEL);
+		nfit_test->flush_dma = devm_kcalloc(dev, num, sizeof(dma_addr_t),
+				GFP_KERNEL);
 		nfit_test->label = devm_kcalloc(dev, num, sizeof(void *),
 				GFP_KERNEL);
 		nfit_test->label_dma = devm_kcalloc(dev, num,
@@ -943,7 +988,8 @@ static int nfit_test_probe(struct platform_device *pdev)
 				sizeof(dma_addr_t), GFP_KERNEL);
 		if (nfit_test->dimm && nfit_test->dimm_dma && nfit_test->label
 				&& nfit_test->label_dma && nfit_test->dcr
-				&& nfit_test->dcr_dma)
+				&& nfit_test->dcr_dma && nfit_test->flush
+				&& nfit_test->flush_dma)
 			/* pass */;
 		else
 			return -ENOMEM;

