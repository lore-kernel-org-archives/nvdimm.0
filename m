Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 1ED861A1E34
 for <linux-nvdimm@lists.01.org>; Sat,  9 Jul 2016 20:28:38 -0700 (PDT)
Subject: [PATCH v2 14/17] pmem: kill wmb_pmem()
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Jul 2016 20:25:44 -0700
Message-ID: <146812114395.32932.6871258291725696871.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, hch@lst.de, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

All users have been replaced with flushing in the pmem driver.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/pmem.h |   36 ++-------------------------------
 include/linux/pmem.h        |   47 ++++---------------------------------------
 2 files changed, 6 insertions(+), 77 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index fbc5e92e1ecc..a8cf2a6b14d9 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -26,8 +26,7 @@
  * @n: length of the copy in bytes
  *
  * Copy data to persistent memory media via non-temporal stores so that
- * a subsequent arch_wmb_pmem() can flush cpu and memory controller
- * write buffers to guarantee durability.
+ * a subsequent pmem driver flush operation will drain posted write queues.
  */
 static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
 		size_t n)
@@ -57,32 +56,12 @@ static inline int arch_memcpy_from_pmem(void *dst, const void __pmem *src,
 }
 
 /**
- * arch_wmb_pmem - synchronize writes to persistent memory
- *
- * After a series of arch_memcpy_to_pmem() operations this drains data
- * from cpu write buffers and any platform (memory controller) buffers
- * to ensure that written data is durable on persistent memory media.
- */
-static inline void arch_wmb_pmem(void)
-{
-	/*
-	 * wmb() to 'sfence' all previous writes such that they are
-	 * architecturally visible to 'pcommit'.  Note, that we've
-	 * already arranged for pmem writes to avoid the cache via
-	 * arch_memcpy_to_pmem().
-	 */
-	wmb();
-	pcommit_sfence();
-}
-
-/**
  * arch_wb_cache_pmem - write back a cache range with CLWB
  * @vaddr:	virtual start address
  * @size:	number of bytes to write back
  *
  * Write back a cache range using the CLWB (cache line write back)
- * instruction.  This function requires explicit ordering with an
- * arch_wmb_pmem() call.
+ * instruction.
  */
 static inline void arch_wb_cache_pmem(void __pmem *addr, size_t size)
 {
@@ -113,7 +92,6 @@ static inline bool __iter_needs_pmem_wb(struct iov_iter *i)
  * @i:		iterator with source data
  *
  * Copy data from the iterator 'i' to the PMEM buffer starting at 'addr'.
- * This function requires explicit ordering with an arch_wmb_pmem() call.
  */
 static inline size_t arch_copy_from_iter_pmem(void __pmem *addr, size_t bytes,
 		struct iov_iter *i)
@@ -136,7 +114,6 @@ static inline size_t arch_copy_from_iter_pmem(void __pmem *addr, size_t bytes,
  * @size:	number of bytes to zero
  *
  * Write zeros into the memory range starting at 'addr' for 'size' bytes.
- * This function requires explicit ordering with an arch_wmb_pmem() call.
  */
 static inline void arch_clear_pmem(void __pmem *addr, size_t size)
 {
@@ -150,14 +127,5 @@ static inline void arch_invalidate_pmem(void __pmem *addr, size_t size)
 {
 	clflush_cache_range((void __force *) addr, size);
 }
-
-static inline bool __arch_has_wmb_pmem(void)
-{
-	/*
-	 * We require that wmb() be an 'sfence', that is only guaranteed on
-	 * 64-bit builds
-	 */
-	return static_cpu_has(X86_FEATURE_PCOMMIT);
-}
 #endif /* CONFIG_ARCH_HAS_PMEM_API */
 #endif /* __ASM_X86_PMEM_H__ */
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index 57d146fe44dd..9e3ea94b8157 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -26,16 +26,6 @@
  * calling these symbols with arch_has_pmem_api() and redirect to the
  * implementation in asm/pmem.h.
  */
-static inline bool __arch_has_wmb_pmem(void)
-{
-	return false;
-}
-
-static inline void arch_wmb_pmem(void)
-{
-	BUG();
-}
-
 static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
 		size_t n)
 {
@@ -101,20 +91,6 @@ static inline int memcpy_from_pmem(void *dst, void __pmem const *src,
 		return default_memcpy_from_pmem(dst, src, size);
 }
 
-/**
- * arch_has_wmb_pmem - true if wmb_pmem() ensures durability
- *
- * For a given cpu implementation within an architecture it is possible
- * that wmb_pmem() resolves to a nop.  In the case this returns
- * false, pmem api users are unable to ensure durability and may want to
- * fall back to a different data consistency model, or otherwise notify
- * the user.
- */
-static inline bool arch_has_wmb_pmem(void)
-{
-	return arch_has_pmem_api() && __arch_has_wmb_pmem();
-}
-
 /*
  * These defaults seek to offer decent performance and minimize the
  * window between i/o completion and writes being durable on media.
@@ -152,7 +128,7 @@ static inline void default_clear_pmem(void __pmem *addr, size_t size)
  * being effectively evicted from, or never written to, the processor
  * cache hierarchy after the copy completes.  After memcpy_to_pmem()
  * data may still reside in cpu or platform buffers, so this operation
- * must be followed by a wmb_pmem().
+ * must be followed by a blkdev_issue_flush() on the pmem block device.
  */
 static inline void memcpy_to_pmem(void __pmem *dst, const void *src, size_t n)
 {
@@ -163,28 +139,13 @@ static inline void memcpy_to_pmem(void __pmem *dst, const void *src, size_t n)
 }
 
 /**
- * wmb_pmem - synchronize writes to persistent memory
- *
- * After a series of memcpy_to_pmem() operations this drains data from
- * cpu write buffers and any platform (memory controller) buffers to
- * ensure that written data is durable on persistent memory media.
- */
-static inline void wmb_pmem(void)
-{
-	if (arch_has_wmb_pmem())
-		arch_wmb_pmem();
-	else
-		wmb();
-}
-
-/**
  * copy_from_iter_pmem - copy data from an iterator to PMEM
  * @addr:	PMEM destination address
  * @bytes:	number of bytes to copy
  * @i:		iterator with source data
  *
  * Copy data from the iterator 'i' to the PMEM buffer starting at 'addr'.
- * This function requires explicit ordering with a wmb_pmem() call.
+ * See blkdev_issue_flush() note for memcpy_to_pmem().
  */
 static inline size_t copy_from_iter_pmem(void __pmem *addr, size_t bytes,
 		struct iov_iter *i)
@@ -200,7 +161,7 @@ static inline size_t copy_from_iter_pmem(void __pmem *addr, size_t bytes,
  * @size:	number of bytes to zero
  *
  * Write zeros into the memory range starting at 'addr' for 'size' bytes.
- * This function requires explicit ordering with a wmb_pmem() call.
+ * See blkdev_issue_flush() note for memcpy_to_pmem().
  */
 static inline void clear_pmem(void __pmem *addr, size_t size)
 {
@@ -230,7 +191,7 @@ static inline void invalidate_pmem(void __pmem *addr, size_t size)
  * @size:	number of bytes to write back
  *
  * Write back the processor cache range starting at 'addr' for 'size' bytes.
- * This function requires explicit ordering with a wmb_pmem() call.
+ * See blkdev_issue_flush() note for memcpy_to_pmem().
  */
 static inline void wb_cache_pmem(void __pmem *addr, size_t size)
 {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
