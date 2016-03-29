Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from shadbolt.e.decadent.org.uk (shadbolt.e.decadent.org.uk
 [88.96.1.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9261E1A1EED
 for <linux-nvdimm@lists.01.org>; Tue, 29 Mar 2016 13:06:10 -0700 (PDT)
Content-Disposition: inline
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
Date: Tue, 29 Mar 2016 20:18:22 +0100
Message-ID: <lsq.1459279102.978729100@decadent.org.uk>
Subject: [PATCH 3.2 24/62] x86/uaccess/64: Handle the caching of 4-byte
 nocache copies properly in __copy_user_nocache()
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
Cc: Thomas Gleixner <tglx@linutronix.de>, Denys Vlasenko <dvlasenk@redhat.com>, linux-nvdimm@lists.01.org, Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>, Toshi Kani <toshi.kani@hp.com>, akpm@linux-foundation.org, Borislav Petkov <bp@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

3.2.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Toshi Kani <toshi.kani@hpe.com>

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
[bwh: Backported to 3.2: aadjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/lib/copy_user_nocache_64.S | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

--- a/arch/x86/lib/copy_user_nocache_64.S
+++ b/arch/x86/lib/copy_user_nocache_64.S
@@ -49,13 +49,14 @@
  * Note: Cached memory copy is used when destination or size is not
  * naturally aligned. That is:
  *  - Require 8-byte alignment when size is 8 bytes or larger.
+ *  - Require 4-byte alignment when size is 4 bytes.
  */
 ENTRY(__copy_user_nocache)
 	CFI_STARTPROC
 
-	/* If size is less than 8 bytes, go to byte copy */
+	/* If size is less than 8 bytes, go to 4-byte copy */
 	cmpl $8,%edx
-	jb .L_1b_cache_copy_entry
+	jb .L_4b_nocache_copy_entry
 
 	/* If destination is not 8-byte aligned, "cache" copy to align it */
 	ALIGN_DESTINATION
@@ -94,7 +95,7 @@ ENTRY(__copy_user_nocache)
 	movl %edx,%ecx
 	andl $7,%edx
 	shrl $3,%ecx
-	jz .L_1b_cache_copy_entry	/* jump if count is 0 */
+	jz .L_4b_nocache_copy_entry	/* jump if count is 0 */
 
 	/* Perform 8-byte nocache loop-copy */
 .L_8b_nocache_copy_loop:
@@ -106,11 +107,33 @@ ENTRY(__copy_user_nocache)
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
@@ -134,6 +157,9 @@ ENTRY(__copy_user_nocache)
 .L_fixup_8b_copy:
 	lea (%rdx,%rcx,8),%rdx
 	jmp .L_fixup_handle_tail
+.L_fixup_4b_copy:
+	lea (%rdx,%rcx,4),%rdx
+	jmp .L_fixup_handle_tail
 .L_fixup_1b_copy:
 	movl %ecx,%edx
 .L_fixup_handle_tail:
@@ -159,6 +185,8 @@ ENTRY(__copy_user_nocache)
 	_ASM_EXTABLE(16b,.L_fixup_4x8b_copy)
 	_ASM_EXTABLE(20b,.L_fixup_8b_copy)
 	_ASM_EXTABLE(21b,.L_fixup_8b_copy)
+	_ASM_EXTABLE(30b,.L_fixup_4b_copy)
+	_ASM_EXTABLE(31b,.L_fixup_4b_copy)
 	_ASM_EXTABLE(40b,.L_fixup_1b_copy)
 	_ASM_EXTABLE(41b,.L_fixup_1b_copy)
 	CFI_ENDPROC

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
