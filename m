Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from shadbolt.e.decadent.org.uk (shadbolt.e.decadent.org.uk
 [88.96.1.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 062151A1EE9
 for <linux-nvdimm@lists.01.org>; Tue, 29 Mar 2016 13:05:45 -0700 (PDT)
Content-Disposition: inline
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
Date: Tue, 29 Mar 2016 20:18:22 +0100
Message-ID: <lsq.1459279102.891832774@decadent.org.uk>
Subject: [PATCH 3.2 23/62] x86/uaccess/64: Make the __copy_user_nocache()
 assembly code more readable
In-Reply-To: <lsq.1459279101.951687763@decadent.org.uk>
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
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Denys Vlasenko <dvlasenk@redhat.com>, linux-nvdimm@lists.01.org, Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, micah.parrish@hpe.com, Andy Lutomirski <luto@amacapital.net>, brian.boylston@hpe.com, Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>, Toshi Kani <toshi.kani@hp.com>, akpm@linux-foundation.org, Borislav Petkov <bp@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

3.2.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Toshi Kani <toshi.kani@hpe.com>

commit ee9737c924706aaa72c2ead93e3ad5644681dc1c upstream.

Add comments to __copy_user_nocache() to clarify its procedures
and alignment requirements.

Also change numeric branch target labels to named local labels.

No code changed:

 arch/x86/lib/copy_user_64.o:

    text    data     bss     dec     hex filename
    1239       0       0    1239     4d7 copy_user_64.o.before
    1239       0       0    1239     4d7 copy_user_64.o.after

 md5:
    58bed94c2db98c1ca9a2d46d0680aaae  copy_user_64.o.before.asm
    58bed94c2db98c1ca9a2d46d0680aaae  copy_user_64.o.after.asm

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Luis R. Rodriguez <mcgrof@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: brian.boylston@hpe.com
Cc: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
Cc: micah.parrish@hpe.com
Cc: ross.zwisler@linux.intel.com
Cc: vishal.l.verma@intel.com
Link: http://lkml.kernel.org/r/1455225857-12039-2-git-send-email-toshi.kani@hpe.com
[ Small readability edits and added object file comparison. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.2: aadjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/lib/copy_user_nocache_64.S | 114 ++++++++++++++++++++++++++++----------------
 1 file changed, 73 insertions(+), 41 deletions(-)

--- a/arch/x86/lib/copy_user_nocache_64.S
+++ b/arch/x86/lib/copy_user_nocache_64.S
@@ -44,17 +44,30 @@
 
 /*
  * copy_user_nocache - Uncached memory copy with exception handling
- * This will force destination/source out of cache for more performance.
+ * This will force destination out of cache for more performance.
+ *
+ * Note: Cached memory copy is used when destination or size is not
+ * naturally aligned. That is:
+ *  - Require 8-byte alignment when size is 8 bytes or larger.
  */
 ENTRY(__copy_user_nocache)
 	CFI_STARTPROC
+
+	/* If size is less than 8 bytes, go to byte copy */
 	cmpl $8,%edx
-	jb 20f		/* less then 8 bytes, go to byte copy loop */
+	jb .L_1b_cache_copy_entry
+
+	/* If destination is not 8-byte aligned, "cache" copy to align it */
 	ALIGN_DESTINATION
+
+	/* Set 4x8-byte copy count and remainder */
 	movl %edx,%ecx
 	andl $63,%edx
 	shrl $6,%ecx
-	jz 17f
+	jz .L_8b_nocache_copy_entry	/* jump if count is 0 */
+
+	/* Perform 4x8-byte nocache loop-copy */
+.L_4x8b_nocache_copy_loop:
 1:	movq (%rsi),%r8
 2:	movq 1*8(%rsi),%r9
 3:	movq 2*8(%rsi),%r10
@@ -74,60 +87,79 @@ ENTRY(__copy_user_nocache)
 	leaq 64(%rsi),%rsi
 	leaq 64(%rdi),%rdi
 	decl %ecx
-	jnz 1b
-17:	movl %edx,%ecx
+	jnz .L_4x8b_nocache_copy_loop
+
+	/* Set 8-byte copy count and remainder */
+.L_8b_nocache_copy_entry:
+	movl %edx,%ecx
 	andl $7,%edx
 	shrl $3,%ecx
-	jz 20f
-18:	movq (%rsi),%r8
-19:	movnti %r8,(%rdi)
+	jz .L_1b_cache_copy_entry	/* jump if count is 0 */
+
+	/* Perform 8-byte nocache loop-copy */
+.L_8b_nocache_copy_loop:
+20:	movq (%rsi),%r8
+21:	movnti %r8,(%rdi)
 	leaq 8(%rsi),%rsi
 	leaq 8(%rdi),%rdi
 	decl %ecx
-	jnz 18b
-20:	andl %edx,%edx
-	jz 23f
+	jnz .L_8b_nocache_copy_loop
+
+	/* If no byte left, we're done */
+.L_1b_cache_copy_entry:
+	andl %edx,%edx
+	jz .L_finish_copy
+
+	/* Perform byte "cache" loop-copy for the remainder */
 	movl %edx,%ecx
-21:	movb (%rsi),%al
-22:	movb %al,(%rdi)
+.L_1b_cache_copy_loop:
+40:	movb (%rsi),%al
+41:	movb %al,(%rdi)
 	incq %rsi
 	incq %rdi
 	decl %ecx
-	jnz 21b
-23:	xorl %eax,%eax
+	jnz .L_1b_cache_copy_loop
+
+	/* Finished copying; fence the prior stores */
+.L_finish_copy:
+	xorl %eax,%eax
 	sfence
 	ret
 
 	.section .fixup,"ax"
-30:	shll $6,%ecx
+.L_fixup_4x8b_copy:
+	shll $6,%ecx
 	addl %ecx,%edx
-	jmp 60f
-40:	lea (%rdx,%rcx,8),%rdx
-	jmp 60f
-50:	movl %ecx,%edx
-60:	sfence
+	jmp .L_fixup_handle_tail
+.L_fixup_8b_copy:
+	lea (%rdx,%rcx,8),%rdx
+	jmp .L_fixup_handle_tail
+.L_fixup_1b_copy:
+	movl %ecx,%edx
+.L_fixup_handle_tail:
+	sfence
 	jmp copy_user_handle_tail
 	.previous
 
-	_ASM_EXTABLE(1b,30b)
-	_ASM_EXTABLE(2b,30b)
-	_ASM_EXTABLE(3b,30b)
-	_ASM_EXTABLE(4b,30b)
-	_ASM_EXTABLE(5b,30b)
-	_ASM_EXTABLE(6b,30b)
-	_ASM_EXTABLE(7b,30b)
-	_ASM_EXTABLE(8b,30b)
-	_ASM_EXTABLE(9b,30b)
-	_ASM_EXTABLE(10b,30b)
-	_ASM_EXTABLE(11b,30b)
-	_ASM_EXTABLE(12b,30b)
-	_ASM_EXTABLE(13b,30b)
-	_ASM_EXTABLE(14b,30b)
-	_ASM_EXTABLE(15b,30b)
-	_ASM_EXTABLE(16b,30b)
-	_ASM_EXTABLE(18b,40b)
-	_ASM_EXTABLE(19b,40b)
-	_ASM_EXTABLE(21b,50b)
-	_ASM_EXTABLE(22b,50b)
+	_ASM_EXTABLE(1b,.L_fixup_4x8b_copy)
+	_ASM_EXTABLE(2b,.L_fixup_4x8b_copy)
+	_ASM_EXTABLE(3b,.L_fixup_4x8b_copy)
+	_ASM_EXTABLE(4b,.L_fixup_4x8b_copy)
+	_ASM_EXTABLE(5b,.L_fixup_4x8b_copy)
+	_ASM_EXTABLE(6b,.L_fixup_4x8b_copy)
+	_ASM_EXTABLE(7b,.L_fixup_4x8b_copy)
+	_ASM_EXTABLE(8b,.L_fixup_4x8b_copy)
+	_ASM_EXTABLE(9b,.L_fixup_4x8b_copy)
+	_ASM_EXTABLE(10b,.L_fixup_4x8b_copy)
+	_ASM_EXTABLE(11b,.L_fixup_4x8b_copy)
+	_ASM_EXTABLE(12b,.L_fixup_4x8b_copy)
+	_ASM_EXTABLE(13b,.L_fixup_4x8b_copy)
+	_ASM_EXTABLE(14b,.L_fixup_4x8b_copy)
+	_ASM_EXTABLE(15b,.L_fixup_4x8b_copy)
+	_ASM_EXTABLE(16b,.L_fixup_4x8b_copy)
+	_ASM_EXTABLE(20b,.L_fixup_8b_copy)
+	_ASM_EXTABLE(21b,.L_fixup_8b_copy)
+	_ASM_EXTABLE(40b,.L_fixup_1b_copy)
+	_ASM_EXTABLE(41b,.L_fixup_1b_copy)
 	CFI_ENDPROC
 ENDPROC(__copy_user_nocache)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
