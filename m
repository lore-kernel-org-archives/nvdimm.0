Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3 1/2] x86/lib/copy_user_64.S: cleanup __copy_user_nocache()
Date: Thu, 11 Feb 2016 14:24:16 -0700
Message-Id: <1455225857-12039-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1455225857-12039-1-git-send-email-toshi.kani@hpe.com>
References: <1455225857-12039-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@suse.de, dan.j.williams@intel.com
Cc: ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, micah.parrish@hpe.com, brian.boylston@hpe.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Add comments to __copy_user_nocache() to clarify its procedures
and alignment requirement.

Also change numeric branch target labels to named labels.  The
labels begin with ".L" and prefix "cun" (Copy User Nocache) to
keep them local and unique to the function.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Borislav Petkov <bp@suse.de>
---
 arch/x86/lib/copy_user_64.S |  114 ++++++++++++++++++++++++++++---------------
 1 file changed, 73 insertions(+), 41 deletions(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 982ce34..23042ff 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -232,17 +232,30 @@ ENDPROC(copy_user_enhanced_fast_string)
 
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
 	ASM_STAC
+
+	/* If size is less than 8 bytes, goto byte copy */
 	cmpl $8,%edx
-	jb 20f		/* less then 8 bytes, go to byte copy loop */
+	jb .Lcun_1b_cache_copy_entry
+
+	/* If destination is not 8-byte aligned, "cache" copy to align it */
 	ALIGN_DESTINATION
+
+	/* Set 4x8-byte copy count and remainder */
 	movl %edx,%ecx
 	andl $63,%edx
 	shrl $6,%ecx
-	jz 17f
+	jz .Lcun_8b_nocache_copy_entry	/* jump if count is 0 */
+
+	/* Perform 4x8-byte nocache loop-copy */
+.Lcun_4x8b_nocache_copy_loop:
 1:	movq (%rsi),%r8
 2:	movq 1*8(%rsi),%r9
 3:	movq 2*8(%rsi),%r10
@@ -262,60 +275,79 @@ ENTRY(__copy_user_nocache)
 	leaq 64(%rsi),%rsi
 	leaq 64(%rdi),%rdi
 	decl %ecx
-	jnz 1b
-17:	movl %edx,%ecx
+	jnz .Lcun_4x8b_nocache_copy_loop
+
+	/* Set 8-byte copy count and remainder */
+.Lcun_8b_nocache_copy_entry:
+	movl %edx,%ecx
 	andl $7,%edx
 	shrl $3,%ecx
-	jz 20f
-18:	movq (%rsi),%r8
-19:	movnti %r8,(%rdi)
+	jz .Lcun_1b_cache_copy_entry	/* jump if count is 0 */
+
+	/* Perform 8-byte nocache loop-copy */
+.Lcun_8b_nocache_copy_loop:
+20:	movq (%rsi),%r8
+21:	movnti %r8,(%rdi)
 	leaq 8(%rsi),%rsi
 	leaq 8(%rdi),%rdi
 	decl %ecx
-	jnz 18b
-20:	andl %edx,%edx
-	jz 23f
+	jnz .Lcun_8b_nocache_copy_loop
+
+	/* If no byte left, we're done */
+.Lcun_1b_cache_copy_entry:
+	andl %edx,%edx
+	jz .Lcun_finish_copy
+
+	/* Perform byte "cache" loop-copy for the remainder */
 	movl %edx,%ecx
-21:	movb (%rsi),%al
-22:	movb %al,(%rdi)
+.Lcun_1b_cache_copy_loop:
+40:	movb (%rsi),%al
+41:	movb %al,(%rdi)
 	incq %rsi
 	incq %rdi
 	decl %ecx
-	jnz 21b
-23:	xorl %eax,%eax
+	jnz .Lcun_1b_cache_copy_loop
+
+	/* Finished copying; fence the prior stores */
+.Lcun_finish_copy:
+	xorl %eax,%eax
 	ASM_CLAC
 	sfence
 	ret
 
 	.section .fixup,"ax"
-30:	shll $6,%ecx
+.Lcun_fixup_4x8b_copy:
+	shll $6,%ecx
 	addl %ecx,%edx
-	jmp 60f
-40:	lea (%rdx,%rcx,8),%rdx
-	jmp 60f
-50:	movl %ecx,%edx
-60:	sfence
+	jmp .Lcun_fixup_handle_tail
+.Lcun_fixup_8b_copy:
+	lea (%rdx,%rcx,8),%rdx
+	jmp .Lcun_fixup_handle_tail
+.Lcun_fixup_1b_copy:
+	movl %ecx,%edx
+.Lcun_fixup_handle_tail:
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
+	_ASM_EXTABLE(1b,.Lcun_fixup_4x8b_copy)
+	_ASM_EXTABLE(2b,.Lcun_fixup_4x8b_copy)
+	_ASM_EXTABLE(3b,.Lcun_fixup_4x8b_copy)
+	_ASM_EXTABLE(4b,.Lcun_fixup_4x8b_copy)
+	_ASM_EXTABLE(5b,.Lcun_fixup_4x8b_copy)
+	_ASM_EXTABLE(6b,.Lcun_fixup_4x8b_copy)
+	_ASM_EXTABLE(7b,.Lcun_fixup_4x8b_copy)
+	_ASM_EXTABLE(8b,.Lcun_fixup_4x8b_copy)
+	_ASM_EXTABLE(9b,.Lcun_fixup_4x8b_copy)
+	_ASM_EXTABLE(10b,.Lcun_fixup_4x8b_copy)
+	_ASM_EXTABLE(11b,.Lcun_fixup_4x8b_copy)
+	_ASM_EXTABLE(12b,.Lcun_fixup_4x8b_copy)
+	_ASM_EXTABLE(13b,.Lcun_fixup_4x8b_copy)
+	_ASM_EXTABLE(14b,.Lcun_fixup_4x8b_copy)
+	_ASM_EXTABLE(15b,.Lcun_fixup_4x8b_copy)
+	_ASM_EXTABLE(16b,.Lcun_fixup_4x8b_copy)
+	_ASM_EXTABLE(20b,.Lcun_fixup_8b_copy)
+	_ASM_EXTABLE(21b,.Lcun_fixup_8b_copy)
+	_ASM_EXTABLE(40b,.Lcun_fixup_1b_copy)
+	_ASM_EXTABLE(41b,.Lcun_fixup_1b_copy)
 ENDPROC(__copy_user_nocache)
