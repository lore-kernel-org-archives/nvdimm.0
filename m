Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v4 5/7] pmem: add copy_from_iter_pmem() and clear_pmem()
Date: Tue, 18 Aug 2015 11:14:46 -0600
Message-Id: <1439918088-32159-6-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1439918088-32159-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1439918088-32159-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add support for two new PMEM APIs, copy_from_iter_pmem() and
clear_pmem().  copy_from_iter_pmem() is used to copy data from an
iterator into a PMEM buffer.  clear_pmem() zeros a PMEM memory range.

Both of these new APIs must be explicitly ordered using a wmb_pmem()
function call and are implemented in such a way that the wmb_pmem()
will make the stores to PMEM durable.  Because both APIs are unordered
they can be called as needed without introducing any unwanted memory
barriers.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 arch/x86/include/asm/pmem.h | 75 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pmem.h        | 66 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 138 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index 7f3413f..a3a0df6 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -66,6 +66,81 @@ static inline void arch_wmb_pmem(void)
 	pcommit_sfence();
 }
 
+/**
+ * __arch_wb_cache_pmem - write back a cache range with CLWB
+ * @vaddr:	virtual start address
+ * @size:	number of bytes to write back
+ *
+ * Write back a cache range using the CLWB (cache line write back)
+ * instruction.  This function requires explicit ordering with an
+ * arch_wmb_pmem() call.  This API is internal to the x86 PMEM implementation.
+ */
+static inline void __arch_wb_cache_pmem(void *vaddr, size_t size)
+{
+	u16 x86_clflush_size = boot_cpu_data.x86_clflush_size;
+	unsigned long clflush_mask = x86_clflush_size - 1;
+	void *vend = vaddr + size;
+	void *p;
+
+	for (p = (void *)((unsigned long)vaddr & ~clflush_mask);
+	     p < vend; p += x86_clflush_size)
+		clwb(p);
+}
+
+/*
+ * copy_from_iter_nocache() on x86 only uses non-temporal stores for iovec
+ * iterators, so for other types (bvec & kvec) we must do a cache write-back.
+ */
+static inline bool __iter_needs_pmem_wb(struct iov_iter *i)
+{
+	return iter_is_iovec(i) == false;
+}
+
+/**
+ * arch_copy_from_iter_pmem - copy data from an iterator to PMEM
+ * @addr:	PMEM destination address
+ * @bytes:	number of bytes to copy
+ * @i:		iterator with source data
+ *
+ * Copy data from the iterator 'i' to the PMEM buffer starting at 'addr'.
+ * This function requires explicit ordering with an arch_wmb_pmem() call.
+ */
+static inline size_t arch_copy_from_iter_pmem(void __pmem *addr, size_t bytes,
+		struct iov_iter *i)
+{
+	void *vaddr = (void __force *)addr;
+	size_t len;
+
+	/* TODO: skip the write-back by always using non-temporal stores */
+	len = copy_from_iter_nocache(vaddr, bytes, i);
+
+	if (__iter_needs_pmem_wb(i))
+		__arch_wb_cache_pmem(vaddr, bytes);
+
+	return len;
+}
+
+/**
+ * arch_clear_pmem - zero a PMEM memory range
+ * @addr:	virtual start address
+ * @size:	number of bytes to zero
+ *
+ * Write zeros into the memory range starting at 'addr' for 'size' bytes.
+ * This function requires explicit ordering with an arch_wmb_pmem() call.
+ */
+static inline void arch_clear_pmem(void __pmem *addr, size_t size)
+{
+	void *vaddr = (void __force *)addr;
+
+	/* TODO: implement the zeroing via non-temporal writes */
+	if (size == PAGE_SIZE && ((unsigned long)vaddr & ~PAGE_MASK) == 0)
+		clear_page(vaddr);
+	else
+		memset(vaddr, 0, size);
+
+	__arch_wb_cache_pmem(vaddr, size);
+}
+
 static inline bool arch_has_wmb_pmem(void)
 {
 #ifdef CONFIG_X86_64
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index 9d619d2..c7f57eb 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -14,6 +14,7 @@
 #define __PMEM_H__
 
 #include <linux/io.h>
+#include <linux/uio.h>
 
 #ifdef CONFIG_ARCH_HAS_PMEM_API
 #include <asm/pmem.h>
@@ -39,12 +40,24 @@ static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
 {
 	BUG();
 }
+
+static inline size_t arch_copy_from_iter_pmem(void __pmem *addr, size_t bytes,
+		struct iov_iter *i)
+{
+	BUG();
+	return 0;
+}
+
+static inline void arch_clear_pmem(void __pmem *addr, size_t size)
+{
+	BUG();
+}
 #endif
 
 /*
- * Architectures that define ARCH_HAS_PMEM_API must provide
- * implementations for arch_memremap_pmem(), arch_memcpy_to_pmem(),
- * arch_wmb_pmem(), and arch_has_wmb_pmem().
+ * Architectures that define ARCH_HAS_PMEM_API must provide implementations
+ * for arch_memremap_pmem(), arch_memcpy_to_pmem(), arch_wmb_pmem(),
+ * arch_copy_from_iter_pmem(), arch_clear_pmem() and arch_has_wmb_pmem().
  */
 
 static inline void memcpy_from_pmem(void *dst, void __pmem const *src, size_t size)
@@ -90,6 +103,20 @@ static void __pmem *default_memremap_pmem(resource_size_t offset,
 	return (void __pmem __force *)ioremap_wt(offset, size);
 }
 
+static inline size_t default_copy_from_iter_pmem(void __pmem *addr,
+		size_t bytes, struct iov_iter *i)
+{
+	return copy_from_iter_nocache((void __force *)addr, bytes, i);
+}
+
+static inline void default_clear_pmem(void __pmem *addr, size_t size)
+{
+	if (size == PAGE_SIZE && ((unsigned long)addr & ~PAGE_MASK) == 0)
+		clear_page((void __force *)addr);
+	else
+		memset((void __force *)addr, 0, size);
+}
+
 /**
  * memremap_pmem - map physical persistent memory for pmem api
  * @offset: physical address of persistent memory
@@ -142,4 +169,37 @@ static inline void wmb_pmem(void)
 	if (arch_has_pmem_api())
 		arch_wmb_pmem();
 }
+
+/**
+ * copy_from_iter_pmem - copy data from an iterator to PMEM
+ * @addr:	PMEM destination address
+ * @bytes:	number of bytes to copy
+ * @i:		iterator with source data
+ *
+ * Copy data from the iterator 'i' to the PMEM buffer starting at 'addr'.
+ * This function requires explicit ordering with a wmb_pmem() call.
+ */
+static inline size_t copy_from_iter_pmem(void __pmem *addr, size_t bytes,
+		struct iov_iter *i)
+{
+	if (arch_has_pmem_api())
+		return arch_copy_from_iter_pmem(addr, bytes, i);
+	return default_copy_from_iter_pmem(addr, bytes, i);
+}
+
+/**
+ * clear_pmem - zero a PMEM memory range
+ * @addr:	virtual start address
+ * @size:	number of bytes to zero
+ *
+ * Write zeros into the memory range starting at 'addr' for 'size' bytes.
+ * This function requires explicit ordering with a wmb_pmem() call.
+ */
+static inline void clear_pmem(void __pmem *addr, size_t size)
+{
+	if (arch_has_pmem_api())
+		arch_clear_pmem(addr, size);
+	else
+		default_clear_pmem(addr, size);
+}
 #endif /* __PMEM_H__ */
-- 
2.1.0

