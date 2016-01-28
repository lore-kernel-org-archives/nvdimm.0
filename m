Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 1/2] x86/lib/copy_user_64.S: Handle 4-byte uncached copy
Date: Thu, 28 Jan 2016 11:12:49 -0700
Message-Id: <1454004770-6318-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1454004770-6318-1-git-send-email-toshi.kani@hpe.com>
References: <1454004770-6318-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@suse.de, dan.j.williams@intel.com
Cc: ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, micah.parrish@hpe.com, brian.boylston@hpe.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Data corruption issues were observed in tests which initiated
a system crash while accessing BTT devices.  This problem is
reproducible.

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
a request size is 4 bytes.  The change extends the byte-copy
path for a less-than-8-bytes request, and does not add any
overhead to the regular path.

Also add comments to clarify the cases cached copy is used.

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
 arch/x86/lib/copy_user_64.S |   44 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 11 deletions(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 982ce34..84b5578 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -232,12 +232,17 @@ ENDPROC(copy_user_enhanced_fast_string)
 
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
 	cmpl $8,%edx
-	jb 20f		/* less then 8 bytes, go to byte copy loop */
+	jb 20f
 	ALIGN_DESTINATION
 	movl %edx,%ecx
 	andl $63,%edx
@@ -274,15 +279,28 @@ ENTRY(__copy_user_nocache)
 	decl %ecx
 	jnz 18b
 20:	andl %edx,%edx
-	jz 23f
+	jz 26f
+	movl %edi,%ecx
+	andl $3,%ecx
+	jnz 23f
 	movl %edx,%ecx
-21:	movb (%rsi),%al
-22:	movb %al,(%rdi)
+	andl $3,%edx
+	shrl $2,%ecx
+	jz 23f
+21:	movl (%rsi),%r8d
+22:	movnti %r8d,(%rdi)
+	leaq 4(%rsi),%rsi
+	leaq 4(%rdi),%rdi
+	andl %edx,%edx
+	jz 26f
+23:	movl %edx,%ecx
+24:	movb (%rsi),%al
+25:	movb %al,(%rdi)
 	incq %rsi
 	incq %rdi
 	decl %ecx
-	jnz 21b
-23:	xorl %eax,%eax
+	jnz 24b
+26:	xorl %eax,%eax
 	ASM_CLAC
 	sfence
 	ret
@@ -290,11 +308,13 @@ ENTRY(__copy_user_nocache)
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
 
@@ -318,4 +338,6 @@ ENTRY(__copy_user_nocache)
 	_ASM_EXTABLE(19b,40b)
 	_ASM_EXTABLE(21b,50b)
 	_ASM_EXTABLE(22b,50b)
+	_ASM_EXTABLE(24b,60b)
+	_ASM_EXTABLE(25b,60b)
 ENDPROC(__copy_user_nocache)
