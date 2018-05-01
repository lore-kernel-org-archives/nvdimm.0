Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 14534203B9000
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 13:55:16 -0700 (PDT)
Subject: [PATCH 2/6] x86, memcpy_mcsafe: return bytes remaining
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 01 May 2018 13:45:19 -0700
Message-ID: <152520751957.36522.6348894783685371152.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152520750404.36522.15462513519590065300.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152520750404.36522.15462513519590065300.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: tony.luck@intel.com, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Machine check safe memory copies are currently deployed in the pmem
driver whenever reading from persistent memory media, so that -EIO is
returned rather than triggering a kernel panic. While this protects most
pmem accesses, it is not complete in the filesystem-dax case. When
filesystem-dax is enabled reads may bypass the block layer and the
driver via dax_iomap_actor() and its usage of copy_to_iter().

In preparation for creating a copy_to_iter() variant that can handle
machine checks, teach memcpy_mcsafe() to return the number of bytes
remaining rather than -EFAULT when an exception occurs.

Given that the source buffer is aligned to 8-bytes and that x86 reports
poison in terms of cachelines, we can assume that all reads faults occur
at cacheline boundaries. When an exception occurs we have succeeded in
reading some data before the poisoned cacheline. mcsafe_handle_tail() is
introduced as a common helper to complete the copy operation on the good
data while also being careful to limit the accesses to the known good
cachelines to limit reduce the chance for additional machine check
exceptions.

Cc: <x86@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/string_64.h  |    8 ++-
 arch/x86/include/asm/uaccess_64.h |    3 +
 arch/x86/lib/memcpy_64.S          |   85 +++++++++++++++++++++++++++++++------
 arch/x86/lib/usercopy_64.c        |   12 +++++
 drivers/nvdimm/claim.c            |    3 +
 drivers/nvdimm/pmem.c             |    6 +--
 include/linux/string.h            |    4 +-
 7 files changed, 98 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 533f74c300c2..92ee5e187113 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -116,7 +116,8 @@ int strcmp(const char *cs, const char *ct);
 #endif
 
 #define __HAVE_ARCH_MEMCPY_MCSAFE 1
-__must_check int memcpy_mcsafe_unrolled(void *dst, const void *src, size_t cnt);
+__must_check unsigned long memcpy_mcsafe_unrolled(void *dst, const void *src,
+		size_t cnt);
 DECLARE_STATIC_KEY_FALSE(mcsafe_key);
 
 /**
@@ -131,9 +132,10 @@ DECLARE_STATIC_KEY_FALSE(mcsafe_key);
  * actually do machine check recovery. Everyone else can just
  * use memcpy().
  *
- * Return 0 for success, -EFAULT for fail
+ * Return 0 for success, or number of bytes not copied if there was an
+ * exception.
  */
-static __always_inline __must_check int
+static __always_inline __must_check unsigned long
 memcpy_mcsafe(void *dst, const void *src, size_t cnt)
 {
 #ifdef CONFIG_X86_MCE
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 62546b3a398e..c064a77e8fcb 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -194,4 +194,7 @@ __copy_from_user_flushcache(void *dst, const void __user *src, unsigned size)
 unsigned long
 copy_user_handle_tail(char *to, char *from, unsigned len);
 
+unsigned long
+mcsafe_handle_tail(char *to, char *from, unsigned len, unsigned limit);
+
 #endif /* _ASM_X86_UACCESS_64_H */
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 6a416a7df8ee..97b772fcf62f 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -283,22 +283,79 @@ ENDPROC(memcpy_mcsafe_unrolled)
 EXPORT_SYMBOL_GPL(memcpy_mcsafe_unrolled)
 
 	.section .fixup, "ax"
-	/* Return -EFAULT for any failure */
-.L_memcpy_mcsafe_fail:
-	mov	$-EFAULT, %rax
+	/* Return number of bytes not copied for any failure */
+
+	/*
+	 * For .E_cache_{1,2,3} we have successfully read {8,16,24}
+	 * bytes before crossing into the poison cacheline. Arrange for
+	 * mcsafe_handle_tail to write those {8,16,24} bytes to the
+	 * destination without re-triggering the machine check. %ecx
+	 * contains the limit and %edx contains total bytes remaining.
+	 */
+.E_cache_1:
+	shll	$6, %ecx
+	addl	%ecx, %edx
+	movl	$8, %ecx
+	jmp mcsafe_handle_tail
+.E_cache_2:
+	shll	$6, %ecx
+	addl	%ecx, %edx
+	movl	$16, %ecx
+	jmp mcsafe_handle_tail
+.E_cache_3:
+	shll	$6, %ecx
+	addl	%ecx, %edx
+	movl	$24, %ecx
+	jmp mcsafe_handle_tail
+	/*
+	 * In contrast to .E_cache_{1,2,3}, .E_cache_{5,6,7} have
+	 * successfully copied 32-bytes before crossing into the
+	 * poisoned cacheline.
+	 */
+.E_cache_5:
+	shll	$6, %ecx
+	addl	%ecx, %edx
+	movl	$8, %ecx
+	jmp .E_cache_upper
+.E_cache_6:
+	shll	$6, %ecx
+	addl	%ecx, %edx
+	movl	$16, %ecx
+	jmp .E_cache_upper
+.E_cache_7:
+	shll	$6, %ecx
+	addl	%ecx, %edx
+	movl	$24, %ecx
+	jmp .E_cache_upper
+.E_cache_upper:
+	addq	$32, %rsi
+	addq	$32, %rdi
+	subl	$32, %edx
+	jmp mcsafe_handle_tail
+.E_trailing_words:
+	shll	$3, %ecx
+	jmp .E_leading_bytes
+.E_cache_4:
+	subl	$32, %edx
+.E_cache_0:
+	shll	$6, %ecx
+.E_leading_bytes:
+	addl	%edx, %ecx
+.E_trailing_bytes:
+	mov	%ecx, %eax
 	ret
 
 	.previous
 
-	_ASM_EXTABLE_FAULT(.L_read_leading_bytes, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_cache_r0, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_cache_r1, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_cache_r2, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_cache_r3, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_cache_r4, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_cache_r5, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_cache_r6, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_cache_r7, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_read_trailing_words, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_read_trailing_bytes, .L_memcpy_mcsafe_fail)
+	_ASM_EXTABLE_FAULT(.L_read_leading_bytes, .E_leading_bytes)
+	_ASM_EXTABLE_FAULT(.L_cache_r0, .E_cache_0)
+	_ASM_EXTABLE_FAULT(.L_cache_r1, .E_cache_1)
+	_ASM_EXTABLE_FAULT(.L_cache_r2, .E_cache_2)
+	_ASM_EXTABLE_FAULT(.L_cache_r3, .E_cache_3)
+	_ASM_EXTABLE_FAULT(.L_cache_r4, .E_cache_4)
+	_ASM_EXTABLE_FAULT(.L_cache_r5, .E_cache_5)
+	_ASM_EXTABLE_FAULT(.L_cache_r6, .E_cache_6)
+	_ASM_EXTABLE_FAULT(.L_cache_r7, .E_cache_7)
+	_ASM_EXTABLE_FAULT(.L_read_trailing_words, .E_trailing_words)
+	_ASM_EXTABLE_FAULT(.L_read_trailing_bytes, .E_trailing_bytes)
 #endif
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 75d3776123cc..e2bcc7d85436 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -75,6 +75,18 @@ copy_user_handle_tail(char *to, char *from, unsigned len)
 	return len;
 }
 
+__visible unsigned long
+mcsafe_handle_tail(char *to, char *from, unsigned len, unsigned limit)
+{
+	for (; len && limit; --len, --limit, to++) {
+		unsigned long rem = memcpy_mcsafe_unrolled(to, from, 1);
+
+		if (rem)
+			break;
+	}
+	return len;
+}
+
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 /**
  * clean_cache_range - write back a cache range with CLWB
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 30852270484f..2e96b34bc936 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -276,7 +276,8 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 	if (rw == READ) {
 		if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align)))
 			return -EIO;
-		return memcpy_mcsafe(buf, nsio->addr + offset, size);
+		if (memcpy_mcsafe(buf, nsio->addr + offset, size) != 0)
+			return -EIO;
 	}
 
 	if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 9d714926ecf5..e023d6aa22b5 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -101,15 +101,15 @@ static blk_status_t read_pmem(struct page *page, unsigned int off,
 		void *pmem_addr, unsigned int len)
 {
 	unsigned int chunk;
-	int rc;
+	unsigned long rem;
 	void *mem;
 
 	while (len) {
 		mem = kmap_atomic(page);
 		chunk = min_t(unsigned int, len, PAGE_SIZE);
-		rc = memcpy_mcsafe(mem + off, pmem_addr, chunk);
+		rem = memcpy_mcsafe(mem + off, pmem_addr, chunk);
 		kunmap_atomic(mem);
-		if (rc)
+		if (rem)
 			return BLK_STS_IOERR;
 		len -= chunk;
 		off = 0;
diff --git a/include/linux/string.h b/include/linux/string.h
index dd39a690c841..4a5a0eb7df51 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -147,8 +147,8 @@ extern int memcmp(const void *,const void *,__kernel_size_t);
 extern void * memchr(const void *,int,__kernel_size_t);
 #endif
 #ifndef __HAVE_ARCH_MEMCPY_MCSAFE
-static inline __must_check int memcpy_mcsafe(void *dst, const void *src,
-		size_t cnt)
+static inline __must_check unsigned long memcpy_mcsafe(void *dst,
+		const void *src, size_t cnt)
 {
 	memcpy(dst, src, cnt);
 	return 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
