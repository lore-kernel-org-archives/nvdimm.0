Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8EA7421A0480F
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 17:18:44 -0700 (PDT)
Subject: [PATCH v2] x86,
 pmem: fix broken __copy_user_nocache cache-bypass assumptions
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Apr 2017 17:12:59 -0700
Message-ID: <149161025237.38725.13508986873214668503.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

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
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
[toshi: trailing bytes flush only needed in the 4B misalign case]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
v2: Change the condition for flushing the last cacheline of the
    destination from 8-byte to 4-byte misalignment (Toshi)

 arch/x86/include/asm/pmem.h |   41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index 2c1ebeb4d737..cf4e68faedc4 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -55,7 +55,8 @@ static inline int arch_memcpy_from_pmem(void *dst, const void *src, size_t n)
  * @size:	number of bytes to write back
  *
  * Write back a cache range using the CLWB (cache line write back)
- * instruction.
+ * instruction. Note that @size is internally rounded up to be cache
+ * line size aligned.
  */
 static inline void arch_wb_cache_pmem(void *addr, size_t size)
 {
@@ -69,15 +70,6 @@ static inline void arch_wb_cache_pmem(void *addr, size_t size)
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
@@ -94,7 +86,34 @@ static inline size_t arch_copy_from_iter_pmem(void *addr, size_t bytes,
 	/* TODO: skip the write-back by always using non-temporal stores */
 	len = copy_from_iter_nocache(addr, bytes, i);
 
-	if (__iter_needs_pmem_wb(i))
+	/*
+	 * In the iovec case on x86_64 copy_from_iter_nocache() uses
+	 * non-temporal stores for the bulk of the transfer, but we need
+	 * to manually flush if the transfer is unaligned. In the
+	 * non-iovec case the entire destination needs to be flushed.
+	 */
+	if (iter_is_iovec(i)) {
+		unsigned long dest = (unsigned long) addr;
+
+		/*
+		 * If the destination is not 8-byte aligned then
+		 * __copy_user_nocache (on x86_64) uses cached copies
+		 */
+		if (dest & 8) {
+			arch_wb_cache_pmem(addr, 1);
+			dest = ALIGN(dest, 8);
+		}
+
+		/*
+		 * If the remaining transfer length, after accounting
+		 * for destination alignment, is not 4-byte aligned
+		 * then __copy_user_nocache() falls back to cached
+		 * copies for the trailing bytes in the final cacheline
+		 * of the transfer.
+		 */
+		if ((bytes - (dest - (unsigned long) addr)) & 4)
+			arch_wb_cache_pmem(addr + bytes - 1, 1);
+	} else
 		arch_wb_cache_pmem(addr, bytes);
 
 	return len;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
