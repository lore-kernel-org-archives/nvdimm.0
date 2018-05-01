Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 560132007E7E5
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 13:55:11 -0700 (PDT)
Subject: [PATCH 1/6] x86,
 memcpy_mcsafe: update labels in support of write fault handling
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 01 May 2018 13:45:14 -0700
Message-ID: <152520751443.36522.2271502200875424777.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The memcpy_mcsafe() implementation handles CPU exceptions when reading
from the source address. Before it can be used for user copies it needs
to grow support for handling write faults. In preparation for adding
that exception handling update the labels for the read cache word X case
(.L_cache_rX) and write cache word X case (.L_cache_wX).

Cc: <x86@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/lib/memcpy_64.S |   71 ++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 9a53a06e5a3e..6a416a7df8ee 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -204,13 +204,14 @@ ENTRY(memcpy_mcsafe_unrolled)
 	subl $8, %ecx
 	negl %ecx
 	subl %ecx, %edx
-.L_copy_leading_bytes:
+.L_read_leading_bytes:
 	movb (%rsi), %al
+.L_write_leading_bytes:
 	movb %al, (%rdi)
 	incq %rsi
 	incq %rdi
 	decl %ecx
-	jnz .L_copy_leading_bytes
+	jnz .L_read_leading_bytes
 
 .L_8byte_aligned:
 	/* Figure out how many whole cache lines (64-bytes) to copy */
@@ -220,26 +221,26 @@ ENTRY(memcpy_mcsafe_unrolled)
 	jz .L_no_whole_cache_lines
 
 	/* Loop copying whole cache lines */
-.L_cache_w0: movq (%rsi), %r8
-.L_cache_w1: movq 1*8(%rsi), %r9
-.L_cache_w2: movq 2*8(%rsi), %r10
-.L_cache_w3: movq 3*8(%rsi), %r11
-	movq %r8, (%rdi)
-	movq %r9, 1*8(%rdi)
-	movq %r10, 2*8(%rdi)
-	movq %r11, 3*8(%rdi)
-.L_cache_w4: movq 4*8(%rsi), %r8
-.L_cache_w5: movq 5*8(%rsi), %r9
-.L_cache_w6: movq 6*8(%rsi), %r10
-.L_cache_w7: movq 7*8(%rsi), %r11
-	movq %r8, 4*8(%rdi)
-	movq %r9, 5*8(%rdi)
-	movq %r10, 6*8(%rdi)
-	movq %r11, 7*8(%rdi)
+.L_cache_r0: movq (%rsi), %r8
+.L_cache_r1: movq 1*8(%rsi), %r9
+.L_cache_r2: movq 2*8(%rsi), %r10
+.L_cache_r3: movq 3*8(%rsi), %r11
+.L_cache_w0: movq %r8, (%rdi)
+.L_cache_w1: movq %r9, 1*8(%rdi)
+.L_cache_w2: movq %r10, 2*8(%rdi)
+.L_cache_w3: movq %r11, 3*8(%rdi)
+.L_cache_r4: movq 4*8(%rsi), %r8
+.L_cache_r5: movq 5*8(%rsi), %r9
+.L_cache_r6: movq 6*8(%rsi), %r10
+.L_cache_r7: movq 7*8(%rsi), %r11
+.L_cache_w4: movq %r8, 4*8(%rdi)
+.L_cache_w5: movq %r9, 5*8(%rdi)
+.L_cache_w6: movq %r10, 6*8(%rdi)
+.L_cache_w7: movq %r11, 7*8(%rdi)
 	leaq 64(%rsi), %rsi
 	leaq 64(%rdi), %rdi
 	decl %ecx
-	jnz .L_cache_w0
+	jnz .L_cache_r0
 
 	/* Are there any trailing 8-byte words? */
 .L_no_whole_cache_lines:
@@ -249,13 +250,14 @@ ENTRY(memcpy_mcsafe_unrolled)
 	jz .L_no_whole_words
 
 	/* Copy trailing words */
-.L_copy_trailing_words:
+.L_read_trailing_words:
 	movq (%rsi), %r8
+.L_write_trailing_words:
 	mov %r8, (%rdi)
 	leaq 8(%rsi), %rsi
 	leaq 8(%rdi), %rdi
 	decl %ecx
-	jnz .L_copy_trailing_words
+	jnz .L_read_trailing_words
 
 	/* Any trailing bytes? */
 .L_no_whole_words:
@@ -264,13 +266,14 @@ ENTRY(memcpy_mcsafe_unrolled)
 
 	/* Copy trailing bytes */
 	movl %edx, %ecx
-.L_copy_trailing_bytes:
+.L_read_trailing_bytes:
 	movb (%rsi), %al
+.L_write_trailing_bytes:
 	movb %al, (%rdi)
 	incq %rsi
 	incq %rdi
 	decl %ecx
-	jnz .L_copy_trailing_bytes
+	jnz .L_read_trailing_bytes
 
 	/* Copy successful. Return zero */
 .L_done_memcpy_trap:
@@ -287,15 +290,15 @@ EXPORT_SYMBOL_GPL(memcpy_mcsafe_unrolled)
 
 	.previous
 
-	_ASM_EXTABLE_FAULT(.L_copy_leading_bytes, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_cache_w0, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_cache_w1, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_cache_w2, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_cache_w3, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_cache_w4, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_cache_w5, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_cache_w6, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_cache_w7, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_copy_trailing_words, .L_memcpy_mcsafe_fail)
-	_ASM_EXTABLE_FAULT(.L_copy_trailing_bytes, .L_memcpy_mcsafe_fail)
+	_ASM_EXTABLE_FAULT(.L_read_leading_bytes, .L_memcpy_mcsafe_fail)
+	_ASM_EXTABLE_FAULT(.L_cache_r0, .L_memcpy_mcsafe_fail)
+	_ASM_EXTABLE_FAULT(.L_cache_r1, .L_memcpy_mcsafe_fail)
+	_ASM_EXTABLE_FAULT(.L_cache_r2, .L_memcpy_mcsafe_fail)
+	_ASM_EXTABLE_FAULT(.L_cache_r3, .L_memcpy_mcsafe_fail)
+	_ASM_EXTABLE_FAULT(.L_cache_r4, .L_memcpy_mcsafe_fail)
+	_ASM_EXTABLE_FAULT(.L_cache_r5, .L_memcpy_mcsafe_fail)
+	_ASM_EXTABLE_FAULT(.L_cache_r6, .L_memcpy_mcsafe_fail)
+	_ASM_EXTABLE_FAULT(.L_cache_r7, .L_memcpy_mcsafe_fail)
+	_ASM_EXTABLE_FAULT(.L_read_trailing_words, .L_memcpy_mcsafe_fail)
+	_ASM_EXTABLE_FAULT(.L_read_trailing_bytes, .L_memcpy_mcsafe_fail)
 #endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
