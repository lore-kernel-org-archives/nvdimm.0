Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2] x86/lib/copy_user_64.S: Handle 4-byte nocache copy
Date: Wed,  3 Feb 2016 11:35:11 -0700
Message-Id: <1454524511-29416-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@suse.de, dan.j.williams@intel.com
Cc: ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, micah.parrish@hpe.com, brian.boylston@hpe.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Data corruption issues were observed in tests which initiated
a system crash/reset while accessing BTT devices.  This problem
is reproducible.

The BTT driver calls pmem_rw_bytes() to update data in pmem
devices.  This interface calls __copy_user_nocache(), which
uses non-temporal stores so that the stores to pmem are
persistent.

__copy_user_nocache() uses non-temporal stores when a request
size is 8 bytes or larger (and is aligned by 8 bytes).  The
BTT driver updates the BTT map table, which entry size is
4 bytes.  Therefore, updates to the map table entries remain
cached, and are not written to pmem after a crash.

Change __copy_user_nocache() to use non-temporal store when
a request size is 4 bytes.  The change extends the current
byte-copy path for a less-than-8-bytes request, and does not
add any overhead to the regular path.

Also add comments to the code, and clarify the cases that
lead cache copy.

Reported-and-tested-by: Micah Parrish <micah.parrish@hpe.com>
Reported-and-tested-by: Brian Boylston <brian.boylston@hpe.com>
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
---
v2:
 - Add comments (Ingo Molnar).
 - Make this patch as an individual patch since v2 debug changes
   will not depend on this patch.
---
 arch/x86/lib/copy_user_64.S |   74 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 61 insertions(+), 13 deletions(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 982ce34..1641327 100644
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
+ *  - Require 4-byte alignment when size is 4 bytes.
  */
 ENTRY(__copy_user_nocache)
 	ASM_STAC
+
+	/* If size is less than 8 bytes, goto 4-byte copy */
 	cmpl $8,%edx
-	jb 20f		/* less then 8 bytes, go to byte copy loop */
+	jb 20f
+
+	/* If destination is not 8-byte aligned, "cache" copy to align it */
 	ALIGN_DESTINATION
+
+	/* Set 4x8-byte copy count and remainder */
 	movl %edx,%ecx
 	andl $63,%edx
 	shrl $6,%ecx
-	jz 17f
+	jz 17f		/* If count is 0, goto 8-byte copy */
+
+	/* Perform 4x8-byte nocache loop-copy */
 1:	movq (%rsi),%r8
 2:	movq 1*8(%rsi),%r9
 3:	movq 2*8(%rsi),%r10
@@ -263,26 +276,57 @@ ENTRY(__copy_user_nocache)
 	leaq 64(%rdi),%rdi
 	decl %ecx
 	jnz 1b
+
+	/* Set 8-byte copy count and remainder */
 17:	movl %edx,%ecx
 	andl $7,%edx
 	shrl $3,%ecx
-	jz 20f
+	jz 20f		/* If count is 0, goto 4-byte copy */
+
+	/* Perform 8-byte nocache loop-copy */
 18:	movq (%rsi),%r8
 19:	movnti %r8,(%rdi)
 	leaq 8(%rsi),%rsi
 	leaq 8(%rdi),%rdi
 	decl %ecx
 	jnz 18b
+
+	/* If no byte left, we're done */
 20:	andl %edx,%edx
-	jz 23f
+	jz 26f
+
+	/* If destination is not 4-byte aligned, goto byte copy */
+	movl %edi,%ecx
+	andl $3,%ecx
+	jnz 23f
+
+	/* Set 4-byte copy count (1 or 0) and remainder */
 	movl %edx,%ecx
-21:	movb (%rsi),%al
-22:	movb %al,(%rdi)
+	andl $3,%edx
+	shrl $2,%ecx
+	jz 23f		/* If count is 0, goto byte copy */
+
+	/* Perform 4-byte nocache copy */
+21:	movl (%rsi),%r8d
+22:	movnti %r8d,(%rdi)
+	leaq 4(%rsi),%rsi
+	leaq 4(%rdi),%rdi
+
+	/* If no byte left, we're done */
+	andl %edx,%edx
+	jz 26f
+
+	/* Perform byte "cache" loop-copy for the remainder */
+23:	movl %edx,%ecx
+24:	movb (%rsi),%al
+25:	movb %al,(%rdi)
 	incq %rsi
 	incq %rdi
 	decl %ecx
-	jnz 21b
-23:	xorl %eax,%eax
+	jnz 24b
+
+	/* Finished copying; fence the prior stores */
+26:	xorl %eax,%eax
 	ASM_CLAC
 	sfence
 	ret
@@ -290,11 +334,13 @@ ENTRY(__copy_user_nocache)
 	.section .fixup,"ax"
 30:	shll $6,%ecx
 	addl %ecx,%edx
-	jmp 60f
+	jmp 70f
 40:	lea (%rdx,%rcx,8),%rdx
-	jmp 60f
-50:	movl %ecx,%edx
-60:	sfence
+	jmp 70f
+50:	lea (%rdx,%rcx,4),%rdx
+	jmp 70f
+60:	movl %ecx,%edx
+70:	sfence
 	jmp copy_user_handle_tail
 	.previous
 
@@ -318,4 +364,6 @@ ENTRY(__copy_user_nocache)
 	_ASM_EXTABLE(19b,40b)
 	_ASM_EXTABLE(21b,50b)
 	_ASM_EXTABLE(22b,50b)
+	_ASM_EXTABLE(24b,60b)
+	_ASM_EXTABLE(25b,60b)
 ENDPROC(__copy_user_nocache)
