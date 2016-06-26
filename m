Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 821601A1E0E
 for <linux-nvdimm@lists.01.org>; Sun, 26 Jun 2016 16:13:35 -0700 (PDT)
Subject: [PATCH 2/2] tools/testing/nvdimm: replace CONFIG_DMA_CMA dependency
 with vmalloc()
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 26 Jun 2016 16:12:18 -0700
Message-ID: <146698273882.40036.13111380618579073873.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146698272810.40036.6685354433183952465.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146698272810.40036.6685354433183952465.stgit@dwillia2-desk3.amr.corp.intel.com>
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

DMA_CMA is incompatible with SWIOTLB used in enterprise distro
configurations.  Switch to vmalloc() allocations for all resources.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/Kbuild       |    2 ++
 tools/testing/nvdimm/pmem-dax.c   |   22 +++++++++++++----
 tools/testing/nvdimm/test/iomap.c |   16 ++++++++++++
 tools/testing/nvdimm/test/nfit.c  |   48 +++++--------------------------------
 4 files changed, 41 insertions(+), 47 deletions(-)

diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 4adfa9cdf26f..62d5ac3c988e 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -11,6 +11,8 @@ ldflags-y += --wrap=__devm_release_region
 ldflags-y += --wrap=__request_region
 ldflags-y += --wrap=__release_region
 ldflags-y += --wrap=devm_memremap_pages
+ldflags-y += --wrap=insert_resource
+ldflags-y += --wrap=remove_resource
 
 DRIVERS := ../../../drivers
 NVDIMM_SRC := $(DRIVERS)/nvdimm
diff --git a/tools/testing/nvdimm/pmem-dax.c b/tools/testing/nvdimm/pmem-dax.c
index fdba77f2bb06..1e0218ce6a8b 100644
--- a/tools/testing/nvdimm/pmem-dax.c
+++ b/tools/testing/nvdimm/pmem-dax.c
@@ -21,14 +21,26 @@ long pmem_direct_access(struct block_device *bdev, sector_t sector,
 	struct pmem_device *pmem = bdev->bd_queue->queuedata;
 	resource_size_t offset = sector * 512 + pmem->data_offset;
 
-	/* disable DAX for nfit_test pmem devices */
-	if (get_nfit_res(pmem->phys_addr + offset)) {
-		dev_info_once(pmem->bb.dev, "dax is disabled for nfit_test\n");
+	if (unlikely(is_bad_pmem(&pmem->bb, sector, size)))
 		return -EIO;
+
+	/*
+	 * Limit dax to a single page at a time given vmalloc()-backed
+	 * in the nfit_test case.
+	 */
+	if (get_nfit_res(pmem->phys_addr + offset)) {
+		struct page *page;
+
+		*kaddr = pmem->virt_addr + offset;
+		page = vmalloc_to_page(pmem->virt_addr + offset);
+		*pfn = page_to_pfn_t(page);
+		dev_dbg_ratelimited(disk_to_dev(bdev->bd_disk)->parent,
+				"%s: sector: %#llx pfn: %#lx\n", __func__,
+				(unsigned long long) sector, page_to_pfn(page));
+
+		return PAGE_SIZE;
 	}
 
-	if (unlikely(is_bad_pmem(&pmem->bb, sector, size)))
-		return -EIO;
 	*kaddr = pmem->virt_addr + offset;
 	*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
 
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index 9966f093b4ff..804705f0f3a1 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -230,6 +230,22 @@ struct resource *__wrap___request_region(struct resource *parent,
 }
 EXPORT_SYMBOL(__wrap___request_region);
 
+int __wrap_insert_resource(struct resource *parent, struct resource *res)
+{
+	if (get_nfit_res(res->start))
+		return 0;
+	return insert_resource(parent, res);
+}
+EXPORT_SYMBOL(__wrap_insert_resource);
+
+int __wrap_remove_resource(struct resource *res)
+{
+	if (get_nfit_res(res->start))
+		return 0;
+	return remove_resource(res);
+}
+EXPORT_SYMBOL(__wrap_remove_resource);
+
 struct resource *__wrap___devm_request_region(struct device *dev,
 		struct resource *parent, resource_size_t start,
 		resource_size_t n, const char *name)
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index c919866853a0..4fdd139f6e6c 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -470,11 +470,7 @@ static void release_nfit_res(void *data)
 	list_del(&nfit_res->list);
 	spin_unlock(&nfit_test_lock);
 
-	if (is_vmalloc_addr(nfit_res->buf))
-		vfree(nfit_res->buf);
-	else
-		dma_free_coherent(nfit_res->dev, resource_size(res),
-				nfit_res->buf, res->start);
+	vfree(nfit_res->buf);
 	kfree(res);
 	kfree(nfit_res);
 }
@@ -507,9 +503,7 @@ static void *__test_alloc(struct nfit_test *t, size_t size, dma_addr_t *dma,
 
 	return nfit_res->buf;
  err:
-	if (buf && !is_vmalloc_addr(buf))
-		dma_free_coherent(dev, size, buf, *dma);
-	else if (buf)
+	if (buf)
 		vfree(buf);
 	kfree(res);
 	kfree(nfit_res);
@@ -524,15 +518,6 @@ static void *test_alloc(struct nfit_test *t, size_t size, dma_addr_t *dma)
 	return __test_alloc(t, size, dma, buf);
 }
 
-static void *test_alloc_coherent(struct nfit_test *t, size_t size,
-		dma_addr_t *dma)
-{
-	struct device *dev = &t->pdev.dev;
-	void *buf = dma_alloc_coherent(dev, size, dma, GFP_KERNEL);
-
-	return __test_alloc(t, size, dma, buf);
-}
-
 static struct nfit_test_resource *nfit_test_lookup(resource_size_t addr)
 {
 	int i;
@@ -592,15 +577,15 @@ static int nfit_test0_alloc(struct nfit_test *t)
 		return -ENOMEM;
 	t->nfit_size = nfit_size;
 
-	t->spa_set[0] = test_alloc_coherent(t, SPA0_SIZE, &t->spa_set_dma[0]);
+	t->spa_set[0] = test_alloc(t, SPA0_SIZE, &t->spa_set_dma[0]);
 	if (!t->spa_set[0])
 		return -ENOMEM;
 
-	t->spa_set[1] = test_alloc_coherent(t, SPA1_SIZE, &t->spa_set_dma[1]);
+	t->spa_set[1] = test_alloc(t, SPA1_SIZE, &t->spa_set_dma[1]);
 	if (!t->spa_set[1])
 		return -ENOMEM;
 
-	t->spa_set[2] = test_alloc_coherent(t, SPA0_SIZE, &t->spa_set_dma[2]);
+	t->spa_set[2] = test_alloc(t, SPA0_SIZE, &t->spa_set_dma[2]);
 	if (!t->spa_set[2])
 		return -ENOMEM;
 
@@ -639,7 +624,7 @@ static int nfit_test1_alloc(struct nfit_test *t)
 		return -ENOMEM;
 	t->nfit_size = nfit_size;
 
-	t->spa_set[0] = test_alloc_coherent(t, SPA2_SIZE, &t->spa_set_dma[0]);
+	t->spa_set[0] = test_alloc(t, SPA2_SIZE, &t->spa_set_dma[0]);
 	if (!t->spa_set[0])
 		return -ENOMEM;
 
@@ -1523,12 +1508,6 @@ static struct platform_driver nfit_test_driver = {
 	.id_table = nfit_test_id,
 };
 
-#ifdef CONFIG_CMA_SIZE_MBYTES
-#define CMA_SIZE_MBYTES CONFIG_CMA_SIZE_MBYTES
-#else
-#define CMA_SIZE_MBYTES 0
-#endif
-
 static __init int nfit_test_init(void)
 {
 	int rc, i;
@@ -1538,7 +1517,6 @@ static __init int nfit_test_init(void)
 	for (i = 0; i < NUM_NFITS; i++) {
 		struct nfit_test *nfit_test;
 		struct platform_device *pdev;
-		static int once;
 
 		nfit_test = kzalloc(sizeof(*nfit_test), GFP_KERNEL);
 		if (!nfit_test) {
@@ -1577,20 +1555,6 @@ static __init int nfit_test_init(void)
 			goto err_register;
 
 		instances[i] = nfit_test;
-
-		if (!once++) {
-			dma_addr_t dma;
-			void *buf;
-
-			buf = dma_alloc_coherent(&pdev->dev, SZ_128M, &dma,
-					GFP_KERNEL);
-			if (!buf) {
-				rc = -ENOMEM;
-				dev_warn(&pdev->dev, "need 128M of free cma\n");
-				goto err_register;
-			}
-			dma_free_coherent(&pdev->dev, SZ_128M, buf, dma);
-		}
 	}
 
 	rc = platform_driver_register(&nfit_test_driver);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
