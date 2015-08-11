Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v4 08/10] pmem: convert to generic memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Aug 2015 23:38:33 -0400
Message-ID: <20150811033833.4987.62222.stgit@otcpl-bsw-rvp-2.jf.intel.com>
In-Reply-To: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com>
References: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: ross.zwisler@linux.intel.com, mcgrof@suse.com, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Update memremap_pmem() to query the architecture for the mapping type of
the given persistent memory range  and then pass those flags to generic
memremap().  arch_memremap_pmem_flags() is provided an address range to
evaluate in the event an arch has a need for different mapping types by
address range.  For example the ACPI NFIT carries EFI mapping types in
its memory range description table.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/io.h |    2 +-
 arch/x86/mm/ioremap.c     |   16 ++++++++++------
 include/linux/pmem.h      |   26 +++++++++++++++-----------
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 8aeb6456188a..1644e19ea032 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -248,7 +248,7 @@ static inline void flush_write_buffers(void)
 #endif
 }
 
-void __pmem *arch_memremap_pmem(resource_size_t offset, size_t size);
+unsigned long arch_memremap_pmem_flags(resource_size_t offset, size_t size);
 #endif /* __KERNEL__ */
 
 extern void native_io_delay(void);
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index c0734030e9db..43b12c146113 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -205,6 +205,16 @@ err_free_memtype:
 	return NULL;
 }
 
+unsigned long arch_memremap_pmem_flags(resource_size_t offset, size_t size)
+{
+	/*
+	 * The expectation is that pmem is always WB capable range on
+	 * x86, i.e. no need to walk the range.
+	 */
+	return MEMREMAP_WB;
+}
+EXPORT_SYMBOL(arch_memremap_pmem_flags);
+
 /**
  * ioremap_nocache     -   map bus memory into CPU space
  * @phys_addr:    bus address of the memory
@@ -317,12 +327,6 @@ void __iomem *ioremap_cache(resource_size_t phys_addr, unsigned long size)
 }
 EXPORT_SYMBOL(ioremap_cache);
 
-void __pmem *arch_memremap_pmem(resource_size_t offset, size_t size)
-{
-	return (void __force __pmem *) ioremap_cache(offset, size);
-}
-EXPORT_SYMBOL(arch_memremap_pmem);
-
 void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
 				unsigned long prot_val)
 {
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index 1bf74c735fa0..03f9d73f3e13 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -28,10 +28,10 @@ static inline bool __arch_has_wmb_pmem(void)
 	return false;
 }
 
-static inline void __pmem *arch_memremap_pmem(resource_size_t offset,
+static inline unsigned long arch_memremap_pmem_flags(resource_size_t offset,
 		unsigned long size)
 {
-	return NULL;
+	return 0;
 }
 
 static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
@@ -43,8 +43,8 @@ static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
 
 /*
  * Architectures that define ARCH_HAS_PMEM_API must provide
- * implementations for arch_memremap_pmem(), arch_memcpy_to_pmem(),
- * arch_wmb_pmem(), and __arch_has_wmb_pmem().
+ * implementations for arch_memremap_pmem_flags(),
+ * arch_memcpy_to_pmem(), arch_wmb_pmem(), and __arch_has_wmb_pmem().
  */
 
 static inline void memcpy_from_pmem(void *dst, void __pmem const *src, size_t size)
@@ -54,7 +54,7 @@ static inline void memcpy_from_pmem(void *dst, void __pmem const *src, size_t si
 
 static inline void memunmap_pmem(void __pmem *addr)
 {
-	iounmap((void __force __iomem *) addr);
+	memunmap((void __force *) addr);
 }
 
 /**
@@ -85,16 +85,15 @@ static inline bool arch_has_pmem_api(void)
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
+static inline unsigned long default_memremap_pmem_flags(void)
 {
-	return (void __pmem *) memremap(offset, size, MEMREMAP_WT);
+	return MEMREMAP_WT;
 }
 
 /**
@@ -112,9 +111,14 @@ static void __pmem *default_memremap_pmem(resource_size_t offset,
 static inline void __pmem *memremap_pmem(resource_size_t offset,
 		unsigned long size)
 {
+	unsigned long flags;
+
 	if (arch_has_pmem_api())
-		return arch_memremap_pmem(offset, size);
-	return default_memremap_pmem(offset, size);
+		flags = arch_memremap_pmem_flags(offset, size);
+	else
+		flags = default_memremap_pmem_flags();
+
+	return (void __pmem *) memremap(offset, size, flags);
 }
 
 /**

