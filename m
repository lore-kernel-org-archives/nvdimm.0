Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3 2/2] x86/lib/copy_user_64.S: Handle 4-byte nocache copy
Date: Thu, 11 Feb 2016 14:24:17 -0700
Message-Id: <1455225857-12039-3-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1455225857-12039-1-git-send-email-toshi.kani@hpe.com>
References: <1455225857-12039-1-git-send-email-toshi.kani@hpe.com>
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
 arch/x86/lib/copy_user_64.S |   36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 23042ff..9228ce6 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -237,13 +237,14 @@ ENDPROC(copy_user_enhanced_fast_string)
  * Note: Cached memory copy is used when destination or size is not
  * naturally aligned. That is:
  *  - Require 8-byte alignment when size is 8 bytes or larger.
+ *  - Require 4-byte alignment when size is 4 bytes.
  */
 ENTRY(__copy_user_nocache)
 	ASM_STAC
 
-	/* If size is less than 8 bytes, goto byte copy */
+	/* If size is less than 8 bytes, goto 4-byte copy */
 	cmpl $8,%edx
-	jb .Lcun_1b_cache_copy_entry
+	jb .Lcun_4b_nocache_copy_entry
 
 	/* If destination is not 8-byte aligned, "cache" copy to align it */
 	ALIGN_DESTINATION
@@ -282,7 +283,7 @@ ENTRY(__copy_user_nocache)
 	movl %edx,%ecx
 	andl $7,%edx
 	shrl $3,%ecx
-	jz .Lcun_1b_cache_copy_entry	/* jump if count is 0 */
+	jz .Lcun_4b_nocache_copy_entry	/* jump if count is 0 */
 
 	/* Perform 8-byte nocache loop-copy */
 .Lcun_8b_nocache_copy_loop:
@@ -294,11 +295,33 @@ ENTRY(__copy_user_nocache)
 	jnz .Lcun_8b_nocache_copy_loop
 
 	/* If no byte left, we're done */
-.Lcun_1b_cache_copy_entry:
+.Lcun_4b_nocache_copy_entry:
+	andl %edx,%edx
+	jz .Lcun_finish_copy
+
+	/* If destination is not 4-byte aligned, goto byte copy */
+	movl %edi,%ecx
+	andl $3,%ecx
+	jnz .Lcun_1b_cache_copy_entry
+
+	/* Set 4-byte copy count (1 or 0) and remainder */
+	movl %edx,%ecx
+	andl $3,%edx
+	shrl $2,%ecx
+	jz .Lcun_1b_cache_copy_entry	/* jump if count is 0 */
+
+	/* Perform 4-byte nocache copy */
+30:	movl (%rsi),%r8d
+31:	movnti %r8d,(%rdi)
+	leaq 4(%rsi),%rsi
+	leaq 4(%rdi),%rdi
+
+	/* If no byte left, we're done */
 	andl %edx,%edx
 	jz .Lcun_finish_copy
 
 	/* Perform byte "cache" loop-copy for the remainder */
+.Lcun_1b_cache_copy_entry:
 	movl %edx,%ecx
 .Lcun_1b_cache_copy_loop:
 40:	movb (%rsi),%al
@@ -323,6 +346,9 @@ ENTRY(__copy_user_nocache)
 .Lcun_fixup_8b_copy:
 	lea (%rdx,%rcx,8),%rdx
 	jmp .Lcun_fixup_handle_tail
+.Lcun_fixup_4b_copy:
+	lea (%rdx,%rcx,4),%rdx
+	jmp .Lcun_fixup_handle_tail
 .Lcun_fixup_1b_copy:
 	movl %ecx,%edx
 .Lcun_fixup_handle_tail:
@@ -348,6 +374,8 @@ ENTRY(__copy_user_nocache)
 	_ASM_EXTABLE(16b,.Lcun_fixup_4x8b_copy)
 	_ASM_EXTABLE(20b,.Lcun_fixup_8b_copy)
 	_ASM_EXTABLE(21b,.Lcun_fixup_8b_copy)
+	_ASM_EXTABLE(30b,.Lcun_fixup_4b_copy)
+	_ASM_EXTABLE(31b,.Lcun_fixup_4b_copy)
 	_ASM_EXTABLE(40b,.Lcun_fixup_1b_copy)
 	_ASM_EXTABLE(41b,.Lcun_fixup_1b_copy)
 ENDPROC(__copy_user_nocache)
