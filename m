Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v5 6/8] pmem: convert to generic memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 12 Aug 2015 20:12:35 -0400
Message-ID: <20150813001235.17702.56586.stgit@otcpl-skl-sds-2.jf.intel.com>
In-Reply-To: <20150813000250.17702.28409.stgit@otcpl-skl-sds-2.jf.intel.com>
References: <20150813000250.17702.28409.stgit@otcpl-skl-sds-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: ross.zwisler@linux.intel.com, mcgrof@suse.com, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Kill arch_memremap_pmem() and just let the architecture specify the
flags to be passed to memremap().  Default to writethrough by default.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/io.h         |    6 +-----
 include/linux/pmem.h              |   28 +++++++++-------------------
 tools/testing/nvdimm/Kbuild       |    4 ++--
 tools/testing/nvdimm/test/iomap.c |   34 +++++++++++++++++++++++++---------
 4 files changed, 37 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index cc9c61bc1abe..d241fbd5c87b 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -248,11 +248,7 @@ static inline void flush_write_buffers(void)
 #endif
 }
 
-static inline void __pmem *arch_memremap_pmem(resource_size_t offset,
-	unsigned long size)
-{
-	return (void __force __pmem *) ioremap_cache(offset, size);
-}
+#define ARCH_MEMREMAP_PMEM MEMREMAP_WB
 
 #endif /* __KERNEL__ */
 
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index d2114045a6c4..093c35ecefcc 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -28,12 +28,6 @@ static inline bool __arch_has_wmb_pmem(void)
 	return false;
 }
 
-static inline void __pmem *arch_memremap_pmem(resource_size_t offset,
-		unsigned long size)
-{
-	return NULL;
-}
-
 static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
 		size_t n)
 {
@@ -43,8 +37,8 @@ static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
 
 /*
  * Architectures that define ARCH_HAS_PMEM_API must provide
- * implementations for arch_memremap_pmem(), arch_memcpy_to_pmem(),
- * arch_wmb_pmem(), and __arch_has_wmb_pmem().
+ * implementations for arch_memcpy_to_pmem(), arch_wmb_pmem(), and
+ * __arch_has_wmb_pmem().
  */
 
 static inline void memcpy_from_pmem(void *dst, void __pmem const *src, size_t size)
@@ -54,7 +48,7 @@ static inline void memcpy_from_pmem(void *dst, void __pmem const *src, size_t si
 
 static inline void memunmap_pmem(void __pmem *addr)
 {
-	iounmap((void __force __iomem *) addr);
+	memunmap((void __force *) addr);
 }
 
 /**
@@ -85,18 +79,12 @@ static inline bool arch_has_pmem_api(void)
  * default_memremap_pmem + default_memcpy_to_pmem is sufficient for
  * making data durable relative to i/o completion.
  */
-static void default_memcpy_to_pmem(void __pmem *dst, const void *src,
+static inline void default_memcpy_to_pmem(void __pmem *dst, const void *src,
 		size_t size)
 {
 	memcpy((void __force *) dst, src, size);
 }
 
-static void __pmem *default_memremap_pmem(resource_size_t offset,
-		unsigned long size)
-{
-	return (void __pmem __force *)ioremap_wt(offset, size);
-}
-
 /**
  * memremap_pmem - map physical persistent memory for pmem api
  * @offset: physical address of persistent memory
@@ -112,9 +100,11 @@ static void __pmem *default_memremap_pmem(resource_size_t offset,
 static inline void __pmem *memremap_pmem(resource_size_t offset,
 		unsigned long size)
 {
-	if (arch_has_pmem_api())
-		return arch_memremap_pmem(offset, size);
-	return default_memremap_pmem(offset, size);
+#ifdef ARCH_MEMREMAP_PMEM
+	return (void __pmem *) memremap(offset, size, ARCH_MEMREMAP_PMEM);
+#else
+	return (void __pmem *) memremap(offset, size, MEMREMAP_WT);
+#endif
 }
 
 /**
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index f56914c7929b..8032a49f7873 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -1,7 +1,7 @@
-ldflags-y += --wrap=ioremap_wt
 ldflags-y += --wrap=ioremap_wc
 ldflags-y += --wrap=devm_ioremap_nocache
-ldflags-y += --wrap=ioremap_cache
+ldflags-y += --wrap=memremap
+ldflags-y += --wrap=memunmap
 ldflags-y += --wrap=ioremap_nocache
 ldflags-y += --wrap=iounmap
 ldflags-y += --wrap=__request_region
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index 64bfaa50831c..21288f34a5ca 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -80,11 +80,20 @@ void __iomem *__wrap_devm_ioremap_nocache(struct device *dev,
 }
 EXPORT_SYMBOL(__wrap_devm_ioremap_nocache);
 
-void __iomem *__wrap_ioremap_cache(resource_size_t offset, unsigned long size)
+void *__wrap_memremap(resource_size_t offset, size_t size,
+		unsigned long flags)
 {
-	return __nfit_test_ioremap(offset, size, ioremap_cache);
+	struct nfit_test_resource *nfit_res;
+
+	rcu_read_lock();
+	nfit_res = get_nfit_res(offset);
+	rcu_read_unlock();
+	if (nfit_res)
+		return (void __iomem *) nfit_res->buf + offset
+			- nfit_res->res->start;
+	return memremap(offset, size, flags);
 }
-EXPORT_SYMBOL(__wrap_ioremap_cache);
+EXPORT_SYMBOL(__wrap_memremap);
 
 void __iomem *__wrap_ioremap_nocache(resource_size_t offset, unsigned long size)
 {
@@ -92,12 +101,6 @@ void __iomem *__wrap_ioremap_nocache(resource_size_t offset, unsigned long size)
 }
 EXPORT_SYMBOL(__wrap_ioremap_nocache);
 
-void __iomem *__wrap_ioremap_wt(resource_size_t offset, unsigned long size)
-{
-	return __nfit_test_ioremap(offset, size, ioremap_wt);
-}
-EXPORT_SYMBOL(__wrap_ioremap_wt);
-
 void __iomem *__wrap_ioremap_wc(resource_size_t offset, unsigned long size)
 {
 	return __nfit_test_ioremap(offset, size, ioremap_wc);
@@ -117,6 +120,19 @@ void __wrap_iounmap(volatile void __iomem *addr)
 }
 EXPORT_SYMBOL(__wrap_iounmap);
 
+void __wrap_memunmap(void *addr)
+{
+	struct nfit_test_resource *nfit_res;
+
+	rcu_read_lock();
+	nfit_res = get_nfit_res((unsigned long) addr);
+	rcu_read_unlock();
+	if (nfit_res)
+		return;
+	return memunmap(addr);
+}
+EXPORT_SYMBOL(__wrap_memunmap);
+
 struct resource *__wrap___request_region(struct resource *parent,
 		resource_size_t start, resource_size_t n, const char *name,
 		int flags)

