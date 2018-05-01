Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A786E203B9000
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 13:55:21 -0700 (PDT)
Subject: [PATCH 3/6] x86, memcpy_mcsafe: add write-protection-fault handling
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 01 May 2018 13:45:24 -0700
Message-ID: <152520752472.36522.6229986239583637697.stgit@dwillia2-desk3.amr.corp.intel.com>
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
 arch/x86/lib/memcpy_64.S |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 97b772fcf62f..fc9c1f594c71 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -345,6 +345,16 @@ EXPORT_SYMBOL_GPL(memcpy_mcsafe_unrolled)
 	mov	%ecx, %eax
 	ret
 
+.E_write_cache_X:
+	shll	$6, %ecx
+	jmp	.E_handle_tail
+.E_write_trailing_words:
+	shll	$3, %ecx
+.E_handle_tail:
+	addl	%edx, %ecx
+	movl	%ecx, %edx
+	jmp mcsafe_handle_tail
+
 	.previous
 
 	_ASM_EXTABLE_FAULT(.L_read_leading_bytes, .E_leading_bytes)
@@ -358,4 +368,15 @@ EXPORT_SYMBOL_GPL(memcpy_mcsafe_unrolled)
 	_ASM_EXTABLE_FAULT(.L_cache_r7, .E_cache_7)
 	_ASM_EXTABLE_FAULT(.L_read_trailing_words, .E_trailing_words)
 	_ASM_EXTABLE_FAULT(.L_read_trailing_bytes, .E_trailing_bytes)
+	_ASM_EXTABLE(.L_write_leading_bytes, .E_leading_bytes)
+	_ASM_EXTABLE(.L_cache_w0, .E_write_cache_X)
+	_ASM_EXTABLE(.L_cache_w1, .E_write_cache_X)
+	_ASM_EXTABLE(.L_cache_w2, .E_write_cache_X)
+	_ASM_EXTABLE(.L_cache_w3, .E_write_cache_X)
+	_ASM_EXTABLE(.L_cache_w4, .E_write_cache_X)
+	_ASM_EXTABLE(.L_cache_w5, .E_write_cache_X)
+	_ASM_EXTABLE(.L_cache_w6, .E_write_cache_X)
+	_ASM_EXTABLE(.L_cache_w7, .E_write_cache_X)
+	_ASM_EXTABLE(.L_write_trailing_words, .E_write_trailing_words)
+	_ASM_EXTABLE(.L_write_trailing_bytes, .E_trailing_bytes)
 #endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
