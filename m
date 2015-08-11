Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v4 10/10] pmem: switch to devm_ allocations
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Aug 2015 23:38:44 -0400
Message-ID: <20150811033843.4987.15396.stgit@otcpl-bsw-rvp-2.jf.intel.com>
In-Reply-To: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com>
References: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: ross.zwisler@linux.intel.com, mcgrof@suse.com, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
[djbw: tools/testing/nvdimm/ support]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c             |   36 +++++++++--------------------
 include/linux/pmem.h              |    6 ++---
 tools/testing/nvdimm/Kbuild       |    4 ++-
 tools/testing/nvdimm/test/iomap.c |   46 +++++++++++++++++++++----------------
 4 files changed, 42 insertions(+), 50 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index bcf48f133443..eb7552d939e1 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -119,7 +119,7 @@ static struct pmem_device *pmem_alloc(struct device *dev,
 {
 	struct pmem_device *pmem;
 
-	pmem = kzalloc(sizeof(*pmem), GFP_KERNEL);
+	pmem = devm_kzalloc(dev, sizeof(*pmem), GFP_KERNEL);
 	if (!pmem)
 		return ERR_PTR(-ENOMEM);
 
@@ -128,19 +128,16 @@ static struct pmem_device *pmem_alloc(struct device *dev,
 	if (!arch_has_pmem_api())
 		dev_warn(dev, "unable to guarantee persistence of writes\n");
 
-	if (!request_mem_region(pmem->phys_addr, pmem->size, dev_name(dev))) {
+	if (!devm_request_mem_region(dev, pmem->phys_addr, pmem->size,
+			dev_name(dev))) {
 		dev_warn(dev, "could not reserve region [0x%pa:0x%zx]\n",
 				&pmem->phys_addr, pmem->size);
-		kfree(pmem);
 		return ERR_PTR(-EBUSY);
 	}
 
-	pmem->virt_addr = memremap_pmem(pmem->phys_addr, pmem->size);
-	if (!pmem->virt_addr) {
-		release_mem_region(pmem->phys_addr, pmem->size);
-		kfree(pmem);
+	pmem->virt_addr = memremap_pmem(dev, pmem->phys_addr, pmem->size);
+	if (!pmem->virt_addr)
 		return ERR_PTR(-ENXIO);
-	}
 
 	return pmem;
 }
@@ -210,20 +207,12 @@ static int pmem_rw_bytes(struct nd_namespace_common *ndns,
 	return 0;
 }
 
-static void pmem_free(struct pmem_device *pmem)
-{
-	memunmap_pmem(pmem->virt_addr);
-	release_mem_region(pmem->phys_addr, pmem->size);
-	kfree(pmem);
-}
-
 static int nd_pmem_probe(struct device *dev)
 {
 	struct nd_region *nd_region = to_nd_region(dev->parent);
 	struct nd_namespace_common *ndns;
 	struct nd_namespace_io *nsio;
 	struct pmem_device *pmem;
-	int rc;
 
 	ndns = nvdimm_namespace_common_probe(dev);
 	if (IS_ERR(ndns))
@@ -236,16 +225,14 @@ static int nd_pmem_probe(struct device *dev)
 
 	dev_set_drvdata(dev, pmem);
 	ndns->rw_bytes = pmem_rw_bytes;
+
 	if (is_nd_btt(dev))
-		rc = nvdimm_namespace_attach_btt(ndns);
-	else if (nd_btt_probe(ndns, pmem) == 0) {
+		return nvdimm_namespace_attach_btt(ndns);
+
+	if (nd_btt_probe(ndns, pmem) == 0)
 		/* we'll come back as btt-pmem */
-		rc = -ENXIO;
-	} else
-		rc = pmem_attach_disk(ndns, pmem);
-	if (rc)
-		pmem_free(pmem);
-	return rc;
+		return -ENXIO;
+	return pmem_attach_disk(ndns, pmem);
 }
 
 static int nd_pmem_remove(struct device *dev)
@@ -256,7 +243,6 @@ static int nd_pmem_remove(struct device *dev)
 		nvdimm_namespace_detach_btt(to_nd_btt(dev)->ndns);
 	else
 		pmem_detach_disk(pmem);
-	pmem_free(pmem);
 
 	return 0;
 }
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index 03f9d73f3e13..eff2e6ba2a1a 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -108,8 +108,8 @@ static inline unsigned long default_memremap_pmem_flags(void)
  * wmb_pmem() arrange for the data to be written through the
  * cache to persistent media.
  */
-static inline void __pmem *memremap_pmem(resource_size_t offset,
-		unsigned long size)
+static inline void __pmem *memremap_pmem(struct device *dev,
+		resource_size_t offset, unsigned long size)
 {
 	unsigned long flags;
 
@@ -118,7 +118,7 @@ static inline void __pmem *memremap_pmem(resource_size_t offset,
 	else
 		flags = default_memremap_pmem_flags();
 
-	return (void __pmem *) memremap(offset, size, flags);
+	return (void __pmem *) devm_memremap(dev, offset, size, flags);
 }
 
 /**
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 8032a49f7873..04c5fc09576d 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -1,9 +1,9 @@
 ldflags-y += --wrap=ioremap_wc
 ldflags-y += --wrap=devm_ioremap_nocache
-ldflags-y += --wrap=memremap
-ldflags-y += --wrap=memunmap
+ldflags-y += --wrap=devm_memremap
 ldflags-y += --wrap=ioremap_nocache
 ldflags-y += --wrap=iounmap
+ldflags-y += --wrap=__devm_request_region
 ldflags-y += --wrap=__request_region
 ldflags-y += --wrap=__release_region
 
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index 21288f34a5ca..402110cab9e9 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -80,8 +80,8 @@ void __iomem *__wrap_devm_ioremap_nocache(struct device *dev,
 }
 EXPORT_SYMBOL(__wrap_devm_ioremap_nocache);
 
-void *__wrap_memremap(resource_size_t offset, size_t size,
-		unsigned long flags)
+void *__wrap_devm_memremap(struct device *dev, resource_size_t offset,
+		size_t size, unsigned long flags)
 {
 	struct nfit_test_resource *nfit_res;
 
@@ -91,9 +91,9 @@ void *__wrap_memremap(resource_size_t offset, size_t size,
 	if (nfit_res)
 		return (void __iomem *) nfit_res->buf + offset
 			- nfit_res->res->start;
-	return memremap(offset, size, flags);
+	return devm_memremap(dev, offset, size, flags);
 }
-EXPORT_SYMBOL(__wrap_memremap);
+EXPORT_SYMBOL(__wrap_devm_memremap);
 
 void __iomem *__wrap_ioremap_nocache(resource_size_t offset, unsigned long size)
 {
@@ -120,22 +120,9 @@ void __wrap_iounmap(volatile void __iomem *addr)
 }
 EXPORT_SYMBOL(__wrap_iounmap);
 
-void __wrap_memunmap(void *addr)
-{
-	struct nfit_test_resource *nfit_res;
-
-	rcu_read_lock();
-	nfit_res = get_nfit_res((unsigned long) addr);
-	rcu_read_unlock();
-	if (nfit_res)
-		return;
-	return memunmap(addr);
-}
-EXPORT_SYMBOL(__wrap_memunmap);
-
-struct resource *__wrap___request_region(struct resource *parent,
-		resource_size_t start, resource_size_t n, const char *name,
-		int flags)
+static struct resource *nfit_test_request_region(struct device *dev,
+		struct resource *parent, resource_size_t start,
+		resource_size_t n, const char *name, int flags)
 {
 	struct nfit_test_resource *nfit_res;
 
@@ -163,10 +150,29 @@ struct resource *__wrap___request_region(struct resource *parent,
 			return res;
 		}
 	}
+	if (dev)
+		__devm_request_region(dev, parent, start, n, name);
 	return __request_region(parent, start, n, name, flags);
 }
+
+struct resource *__wrap___request_region(struct resource *parent,
+		resource_size_t start, resource_size_t n, const char *name,
+		int flags)
+{
+	return nfit_test_request_region(NULL, parent, start, n, name, flags);
+}
 EXPORT_SYMBOL(__wrap___request_region);
 
+struct resource *__wrap___devm_request_region(struct device *dev,
+		struct resource *parent, resource_size_t start,
+		resource_size_t n, const char *name)
+{
+	if (!dev)
+		return NULL;
+	return nfit_test_request_region(dev, parent, start, n, name, 0);
+}
+EXPORT_SYMBOL(__wrap___devm_request_region);
+
 void __wrap___release_region(struct resource *parent, resource_size_t start,
 				resource_size_t n)
 {

