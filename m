Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 5/7] pmem: add wb_cache_pmem() and clear_pmem()
Date: Thu, 13 Aug 2015 10:51:09 -0600
Message-Id: <1439484671-15718-6-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1439484671-15718-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1439484671-15718-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Dave Chinner <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

Add support for two new PMEM APIs, wb_cache_pmem() and clear_pmem().
The first, wb_cache_pmem(), is used to write back ranges of dirtied
cache lines to media in order to make stores durable.  The contents of
the now-clean cache lines can potentially still reside in the cache
after this write back operation allowing subsequent loads to be serviced
from the cache.

The second, clear_pmem(), zeros a PMEM memory range and ensures that the
newly zeroed data is properly flushed from the processor cache to media.
This can be done either with normal writes followed by wb_cache_pmem()
calls, or by using non-temporal stores.

Both of these new APIs must be explicitly ordered using a wmb_pmem()
function call.  Because both APIs are unordered they can be called as
needed without introducing any unwanted memory barriers.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 arch/x86/include/asm/pmem.h | 40 ++++++++++++++++++++++++++++++++++
 include/linux/pmem.h        | 53 ++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 90 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index 7f3413f..89b04c0 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -66,6 +66,46 @@ static inline void arch_wmb_pmem(void)
 	pcommit_sfence();
 }
 
+/**
+ * arch_wb_cache_pmem - write back a cache range with CLWB
+ * @addr:	virtual start address
+ * @size:	number of bytes to write back
+ *
+ * Write back a cache range using the CLWB (cache line write back)
+ * instruction.  This function requires explicit ordering with an
+ * arch_wmb_pmem() function call.
+ */
+static inline void arch_wb_cache_pmem(void __pmem *addr, size_t size)
+{
+	u16 x86_clflush_size = boot_cpu_data.x86_clflush_size;
+	unsigned long clflush_mask = x86_clflush_size - 1;
+	void *vend = (void __force *)addr + size;
+	void *p;
+
+	for (p = (void *)((unsigned long)addr & ~clflush_mask);
+	     p < vend; p += x86_clflush_size)
+		clwb(p);
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
+	/* TODO: implement the zeroing via non-temporal writes */
+	if (size == PAGE_SIZE && ((unsigned long)addr & ~PAGE_MASK) == 0)
+		clear_page((void __force *)addr);
+	else
+		memset((void __force *)addr, 0, size);
+
+	arch_wb_cache_pmem(addr, size);
+}
+
 static inline bool arch_has_wmb_pmem(void)
 {
 #ifdef CONFIG_X86_64
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index 9d619d2..dd1b72c 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -39,12 +39,22 @@ static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
 {
 	BUG();
 }
+
+static inline void arch_wb_cache_pmem(void __pmem *addr, size_t size)
+{
+	BUG();
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
+ * arch_wb_cache_pmem(), arch_clear_pmem() and arch_has_wmb_pmem().
  */
 
 static inline void memcpy_from_pmem(void *dst, void __pmem const *src, size_t size)
@@ -90,6 +100,14 @@ static void __pmem *default_memremap_pmem(resource_size_t offset,
 	return (void __pmem __force *)ioremap_wt(offset, size);
 }
 
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
@@ -142,4 +160,33 @@ static inline void wmb_pmem(void)
 	if (arch_has_pmem_api())
 		arch_wmb_pmem();
 }
+
+/**
+ * wb_cache_pmem - write back a cache range
+ * @addr:	virtual start address
+ * @size:	number of bytes to write back
+ *
+ * This function requires explicit ordering with a wmb_pmem() call.
+ */
+static inline void wb_cache_pmem(void __pmem *addr, size_t size)
+{
+	if (arch_has_pmem_api())
+		arch_wb_cache_pmem(addr, size);
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

