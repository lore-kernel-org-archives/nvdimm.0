Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from youngberry.canonical.com (youngberry.canonical.com
 [91.189.89.112]) (using TLSv1 with cipher AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B11061A1F1C
 for <linux-nvdimm@lists.01.org>; Mon,  7 Mar 2016 14:35:48 -0800 (PST)
From: Kamal Mostafa <kamal@canonical.com>
Subject: [4.2.y-ckt stable] Patch "x86/uaccess/64: Handle the caching of
 4-byte nocache copies properly in __copy_user_nocache()" has been added to
 the 4.2.y-ckt tree
Date: Mon,  7 Mar 2016 14:34:21 -0800
Message-Id: <1457390061-32456-1-git-send-email-kamal@canonical.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Toshi Kani <toshi.kani@hpe.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Denys Vlasenko <dvlasenk@redhat.com>, linux-nvdimm@lists.01.org, Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>, Kamal Mostafa <kamal@canonical.com>, Andy Lutomirski <luto@amacapital.net>, kernel-team@lists.ubuntu.com, Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

This is a note to let you know that I have just added a patch titled

    x86/uaccess/64: Handle the caching of 4-byte nocache copies properly in __copy_user_nocache()

to the linux-4.2.y-queue branch of the 4.2.y-ckt extended stable tree 
which can be found at:

    http://kernel.ubuntu.com/git/ubuntu/linux.git/log/?h=linux-4.2.y-queue

This patch is scheduled to be released in version 4.2.8-ckt5.

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 4.2.y-ckt tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Kamal

---8<------------------------------------------------------------

>From e1aa4f7fd1f243f280c9c3fde9d4cbe31e4cc492 Mon Sep 17 00:00:00 2001
From: Toshi Kani <toshi.kani@hpe.com>
Date: Thu, 11 Feb 2016 14:24:17 -0700
Subject: x86/uaccess/64: Handle the caching of 4-byte nocache copies properly
 in __copy_user_nocache()

commit a82eee7424525e34e98d821dd059ce14560a1e35 upstream.

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
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Luis R. Rodriguez <mcgrof@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm@lists.01.org
Link: http://lkml.kernel.org/r/1455225857-12039-3-git-send-email-toshi.kani@hpe.com
[ Small readability edits. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/lib/copy_user_64.S | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index a644aad..27f89c7 100644
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

-	/* If size is less than 8 bytes, go to byte copy */
+	/* If size is less than 8 bytes, go to 4-byte copy */
 	cmpl $8,%edx
-	jb .L_1b_cache_copy_entry
+	jb .L_4b_nocache_copy_entry

 	/* If destination is not 8-byte aligned, "cache" copy to align it */
 	ALIGN_DESTINATION
@@ -282,7 +283,7 @@ ENTRY(__copy_user_nocache)
 	movl %edx,%ecx
 	andl $7,%edx
 	shrl $3,%ecx
-	jz .L_1b_cache_copy_entry	/* jump if count is 0 */
+	jz .L_4b_nocache_copy_entry	/* jump if count is 0 */

 	/* Perform 8-byte nocache loop-copy */
 .L_8b_nocache_copy_loop:
@@ -294,11 +295,33 @@ ENTRY(__copy_user_nocache)
 	jnz .L_8b_nocache_copy_loop

 	/* If no byte left, we're done */
-.L_1b_cache_copy_entry:
+.L_4b_nocache_copy_entry:
+	andl %edx,%edx
+	jz .L_finish_copy
+
+	/* If destination is not 4-byte aligned, go to byte copy: */
+	movl %edi,%ecx
+	andl $3,%ecx
+	jnz .L_1b_cache_copy_entry
+
+	/* Set 4-byte copy count (1 or 0) and remainder */
+	movl %edx,%ecx
+	andl $3,%edx
+	shrl $2,%ecx
+	jz .L_1b_cache_copy_entry	/* jump if count is 0 */
+
+	/* Perform 4-byte nocache copy: */
+30:	movl (%rsi),%r8d
+31:	movnti %r8d,(%rdi)
+	leaq 4(%rsi),%rsi
+	leaq 4(%rdi),%rdi
+
+	/* If no bytes left, we're done: */
 	andl %edx,%edx
 	jz .L_finish_copy

 	/* Perform byte "cache" loop-copy for the remainder */
+.L_1b_cache_copy_entry:
 	movl %edx,%ecx
 .L_1b_cache_copy_loop:
 40:	movb (%rsi),%al
@@ -323,6 +346,9 @@ ENTRY(__copy_user_nocache)
 .L_fixup_8b_copy:
 	lea (%rdx,%rcx,8),%rdx
 	jmp .L_fixup_handle_tail
+.L_fixup_4b_copy:
+	lea (%rdx,%rcx,4),%rdx
+	jmp .L_fixup_handle_tail
 .L_fixup_1b_copy:
 	movl %ecx,%edx
 .L_fixup_handle_tail:
@@ -348,6 +374,8 @@ ENTRY(__copy_user_nocache)
 	_ASM_EXTABLE(16b,.L_fixup_4x8b_copy)
 	_ASM_EXTABLE(20b,.L_fixup_8b_copy)
 	_ASM_EXTABLE(21b,.L_fixup_8b_copy)
+	_ASM_EXTABLE(30b,.L_fixup_4b_copy)
+	_ASM_EXTABLE(31b,.L_fixup_4b_copy)
 	_ASM_EXTABLE(40b,.L_fixup_1b_copy)
 	_ASM_EXTABLE(41b,.L_fixup_1b_copy)
 ENDPROC(__copy_user_nocache)
--
2.7.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
