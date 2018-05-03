Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 45BD42063E2F1
 for <linux-nvdimm@lists.01.org>; Wed,  2 May 2018 22:08:59 -0700 (PDT)
Subject: [PATCH v2 4/9] x86, memcpy_mcsafe: add write-protection-fault handling
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 02 May 2018 21:59:02 -0700
Message-ID: <152532354268.17218.11923624861859552990.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for using memcpy_mcsafe() to handle user copies it needs
to be to handle write-protection faults while writing user pages. Add
MMU-fault handlers alongside the machine-check exception handlers.

Note that the machine check fault exception handling makes assumptions
about source buffer alignment and poison alignment. In the write fault
case, given the destination buffer is arbitrarily aligned, it needs a
separate / additional fault handling approach. The mcsafe_handle_tail()
helper is reused. The @limit argument is set to @len since there is no
safety concern about retriggering an MMU fault, and this simplifies the
assembly.

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
 arch/x86/include/asm/uaccess_64.h |    3 +++
 arch/x86/lib/memcpy_64.S          |   14 ++++++++++++++
 arch/x86/lib/usercopy_64.c        |   17 +++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 62546b3a398e..c63efc07891f 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -194,4 +194,7 @@ __copy_from_user_flushcache(void *dst, const void __user *src, unsigned size)
 unsigned long
 copy_user_handle_tail(char *to, char *from, unsigned len);
 
+unsigned long
+mcsafe_handle_tail(char *to, char *from, unsigned len);
+
 #endif /* _ASM_X86_UACCESS_64_H */
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index f01a88391c98..c3b527a9f95d 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -265,9 +265,23 @@ EXPORT_SYMBOL_GPL(__memcpy_mcsafe)
 	mov	%ecx, %eax
 	ret
 
+	/*
+	 * For write fault handling, given the destination is unaligned,
+	 * we handle faults on multi-byte writes with a byte-by-byte
+	 * copy up to the write-protected page.
+	 */
+.E_write_words:
+	shll	$3, %ecx
+	addl	%edx, %ecx
+	movl	%ecx, %edx
+	jmp mcsafe_handle_tail
+
 	.previous
 
 	_ASM_EXTABLE_FAULT(.L_read_leading_bytes, .E_leading_bytes)
 	_ASM_EXTABLE_FAULT(.L_read_words, .E_read_words)
 	_ASM_EXTABLE_FAULT(.L_read_trailing_bytes, .E_trailing_bytes)
+	_ASM_EXTABLE(.L_write_leading_bytes, .E_leading_bytes)
+	_ASM_EXTABLE(.L_write_words, .E_write_words)
+	_ASM_EXTABLE(.L_write_trailing_bytes, .E_trailing_bytes)
 #endif
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 75d3776123cc..9787f5ee0cf9 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -75,6 +75,23 @@ copy_user_handle_tail(char *to, char *from, unsigned len)
 	return len;
 }
 
+/*
+ * Similar to copy_user_handle_tail, probe for the write fault point,
+ * but reuse __memcpy_mcsafe in case a new read error is encountered.
+ * clac() is handled in _copy_to_iter_mcsafe().
+ */
+__visible unsigned long
+mcsafe_handle_tail(char *to, char *from, unsigned len)
+{
+	for (; len; --len, to++) {
+		unsigned long rem = memcpy_mcsafe(to, from, 1);
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

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
