Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 4/6] pmem: Add wb_cache_pmem() and flush_cache_pmem()
Date: Thu,  6 Aug 2015 11:43:18 -0600
Message-Id: <1438883000-9011-5-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Toshi Kani <toshi.kani@hp.com>, Juergen Gross <jgross@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

Add support for two new PMEM APIs, wb_cache_pmem() and
flush_cache_pmem().  The first, wb_cache_pmem(), is used to write back
ranges of dirtied cache lines to media in order to make stores durable.
The contents of the now-clean cache lines can potentially still reside
in the cache after this write back operation allowing subsequent loads
to be serviced from the cache.

The second, flush_cache_pmem(), flushes the cache lines from the
processor cache and writes them to media if they were dirty.  This can
be used to write out data that we don't believe will be read again in
the near future, for example when punching holes of zeros in a DAX file.
It can also be used as a cache invalidate when caller needs to be sure
that the cache lines are completely flushed from the processor cache
hierarchy.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 arch/x86/include/asm/cacheflush.h | 10 ++++++++++
 include/linux/pmem.h              | 25 ++++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 490b3d6..ab75bdb 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -158,6 +158,16 @@ static inline void arch_wmb_pmem(void)
 	pcommit_sfence();
 }
 
+static inline void arch_wb_cache_pmem(void __pmem *addr, size_t size)
+{
+	clwb_cache_range((void __force *) addr, size);
+}
+
+static inline void arch_flush_cache_pmem(void __pmem *addr, size_t size)
+{
+	clflush_cache_range((void __force *) addr, size);
+}
+
 static inline bool __arch_has_wmb_pmem(void)
 {
 #ifdef CONFIG_X86_64
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index fb62ce4..2172578 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -39,12 +39,23 @@ static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
 {
 	BUG();
 }
+
+static inline void arch_wb_cache_pmem(void __pmem *addr, size_t size)
+{
+	BUG();
+}
+
+static inline void arch_flush_cache_pmem(void __pmem *addr, size_t size)
+{
+	BUG();
+}
 #endif
 
 /*
  * Architectures that define ARCH_HAS_PMEM_API must provide
  * implementations for arch_memremap_pmem_flags(),
- * arch_memcpy_to_pmem(), arch_wmb_pmem(), and __arch_has_wmb_pmem().
+ * arch_memcpy_to_pmem(), arch_wmb_pmem(), arch_wb_cache_pmem(),
+ * arch_flush_cache_pmem() and * __arch_has_wmb_pmem().
  */
 
 static inline void memcpy_from_pmem(void *dst, void __pmem const *src, size_t size)
@@ -146,4 +157,16 @@ static inline void wmb_pmem(void)
 	if (arch_has_pmem_api())
 		arch_wmb_pmem();
 }
+
+static inline void wb_cache_pmem(void __pmem *addr, size_t size)
+{
+	if (arch_has_pmem_api())
+		arch_wb_cache_pmem(addr, size);
+}
+
+static inline void flush_cache_pmem(void __pmem *addr, size_t size)
+{
+	if (arch_has_pmem_api())
+		arch_flush_cache_pmem(addr, size);
+}
 #endif /* __PMEM_H__ */
-- 
2.1.0

