Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E3612063E2FC
 for <linux-nvdimm@lists.01.org>; Wed,  2 May 2018 22:08:54 -0700 (PDT)
Subject: [PATCH v2 3/9] x86, memcpy_mcsafe: return bytes remaining
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 02 May 2018 21:58:57 -0700
Message-ID: <152532353758.17218.8596448562346764078.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152532351517.17218.3583455156840230837.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152532351517.17218.3583455156840230837.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: tony.luck@intel.com, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, x86@kernel.org, hch@lst.de, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
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
 arch/x86/include/asm/string_64.h |    8 +++++---
 arch/x86/lib/memcpy_64.S         |   20 ++++++++++++++------
 drivers/nvdimm/claim.c           |    3 ++-
 drivers/nvdimm/pmem.c            |    6 +++---
 include/linux/string.h           |    4 ++--
 5 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 4752f8984923..d33f92b9fa22 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -116,7 +116,8 @@ int strcmp(const char *cs, const char *ct);
 #endif
 
 #define __HAVE_ARCH_MEMCPY_MCSAFE 1
-__must_check int __memcpy_mcsafe(void *dst, const void *src, size_t cnt);
+__must_check unsigned long __memcpy_mcsafe(void *dst, const void *src,
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
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 5709f3ec22a4..f01a88391c98 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -252,14 +252,22 @@ ENDPROC(__memcpy_mcsafe)
 EXPORT_SYMBOL_GPL(__memcpy_mcsafe)
 
 	.section .fixup, "ax"
-	/* Return -EFAULT for any failure */
-.L_memcpy_mcsafe_fail:
-	mov	$-EFAULT, %rax
+	/*
+	 * Return number of bytes not copied for any failure. Note that
+	 * there is no "tail" handling since the source buffer is 8-byte
+	 * aligned and poison is cacheline aligned.
+	 */
+.E_read_words:
+	shll	$3, %ecx
+.E_leading_bytes:
+	addl	%edx, %ecx
+.E_trailing_bytes:
+	mov	%ecx, %eax
 	ret
 
 	.previous
 
-	_ASM_EXTABLE_FAULT(.L_read_leading_bytes, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_read_words, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_read_trailing_bytes, .L_memcpy_mcsafe_fail)
+	_ASM_EXTABLE_FAULT(.L_read_leading_bytes, .E_leading_bytes)
+	_ASM_EXTABLE_FAULT(.L_read_words, .E_read_words)
+	_ASM_EXTABLE_FAULT(.L_read_trailing_bytes, .E_trailing_bytes)
 #endif
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
