Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 16CE421A0480F
 for <linux-nvdimm@lists.01.org>; Wed, 19 Apr 2017 10:11:31 -0700 (PDT)
Subject: [4.4-stable PATCH 1/2] x86,
 pmem: fix broken __copy_user_nocache cache-bypass assumptions
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Apr 2017 10:05:47 -0700
Message-ID: <149262154726.9164.12749668242715319890.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149262154180.9164.2041560731963237508.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149262154180.9164.2041560731963237508.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

commit 11e63f6d920d6f2dfd3cd421e939a4aec9a58dcd upstream.

Before we rework the "pmem api" to stop abusing __copy_user_nocache()
for memcpy_to_pmem() we need to fix cases where we may strand dirty data
in the cpu cache. The problem occurs when copy_from_iter_pmem() is used
for arbitrary data transfers from userspace. There is no guarantee that
these transfers, performed by dax_iomap_actor(), will have aligned
destinations or aligned transfer lengths. Backstop the usage
__copy_user_nocache() with explicit cache management in these unaligned
cases.

Yes, copy_from_iter_pmem() is now too big for an inline, but addressing
that is saved for a later patch that moves the entirety of the "pmem
api" into the pmem driver directly.

Fixes: 5de490daec8b ("pmem: add copy_from_iter_pmem() and clear_pmem()")
Cc: <stable@vger.kernel.org>
Cc: <x86@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/pmem.h |   45 +++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index d8ce3ec816ab..bd8ce6bcdfc9 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -72,8 +72,8 @@ static inline void arch_wmb_pmem(void)
  * @size:	number of bytes to write back
  *
  * Write back a cache range using the CLWB (cache line write back)
- * instruction.  This function requires explicit ordering with an
- * arch_wmb_pmem() call.  This API is internal to the x86 PMEM implementation.
+ * instruction. Note that @size is internally rounded up to be cache
+ * line size aligned.
  */
 static inline void __arch_wb_cache_pmem(void *vaddr, size_t size)
 {
@@ -87,15 +87,6 @@ static inline void __arch_wb_cache_pmem(void *vaddr, size_t size)
 		clwb(p);
 }
 
-/*
- * copy_from_iter_nocache() on x86 only uses non-temporal stores for iovec
- * iterators, so for other types (bvec & kvec) we must do a cache write-back.
- */
-static inline bool __iter_needs_pmem_wb(struct iov_iter *i)
-{
-	return iter_is_iovec(i) == false;
-}
-
 /**
  * arch_copy_from_iter_pmem - copy data from an iterator to PMEM
  * @addr:	PMEM destination address
@@ -114,8 +105,36 @@ static inline size_t arch_copy_from_iter_pmem(void __pmem *addr, size_t bytes,
 	/* TODO: skip the write-back by always using non-temporal stores */
 	len = copy_from_iter_nocache(vaddr, bytes, i);
 
-	if (__iter_needs_pmem_wb(i))
-		__arch_wb_cache_pmem(vaddr, bytes);
+	/*
+	 * In the iovec case on x86_64 copy_from_iter_nocache() uses
+	 * non-temporal stores for the bulk of the transfer, but we need
+	 * to manually flush if the transfer is unaligned. A cached
+	 * memory copy is used when destination or size is not naturally
+	 * aligned. That is:
+	 *   - Require 8-byte alignment when size is 8 bytes or larger.
+	 *   - Require 4-byte alignment when size is 4 bytes.
+	 *
+	 * In the non-iovec case the entire destination needs to be
+	 * flushed.
+	 */
+	if (iter_is_iovec(i)) {
+		unsigned long flushed, dest = (unsigned long) addr;
+
+		if (bytes < 8) {
+			if (!IS_ALIGNED(dest, 4) || (bytes != 4))
+				__arch_wb_cache_pmem(addr, 1);
+		} else {
+			if (!IS_ALIGNED(dest, 8)) {
+				dest = ALIGN(dest, boot_cpu_data.x86_clflush_size);
+				__arch_wb_cache_pmem(addr, 1);
+			}
+
+			flushed = dest - (unsigned long) addr;
+			if (bytes > flushed && !IS_ALIGNED(bytes - flushed, 8))
+				__arch_wb_cache_pmem(addr + bytes - 1, 1);
+		}
+	} else
+		__arch_wb_cache_pmem(addr, bytes);
 
 	return len;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
