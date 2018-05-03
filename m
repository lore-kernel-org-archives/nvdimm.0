Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 921CF2063E2FD
 for <linux-nvdimm@lists.01.org>; Wed,  2 May 2018 22:09:30 -0700 (PDT)
Subject: [PATCH v2 9/9] x86, nfit_test: unit test for memcpy_mcsafe()
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 02 May 2018 21:59:33 -0700
Message-ID: <152532357367.17218.12583776735022853270.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Given the fact that the ACPI "EINJ" (error injection) facility is not
universally available, implement software infrastructure to validate the
memcpy_mcsafe() exception handling implementation.

For each potential read exception point in memcpy_mcsafe(), inject a
emulated exception point at the address identified by 'mcsafe_inject'
variable. With this infrastructure implement a test to validate that the
'bytes remaining' calculation is correct for a range of various source
buffer alignments.

This code is compiled out by default. The CONFIG_MCSAFE_DEBUG
configuration symbol needs to be manually enabled by editing
Kconfig.debug. I.e. this functionality can not be accidentally enabled
by a user / distro, it's only for development.

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
Reported-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/Kconfig.debug              |    3 ++
 arch/x86/include/asm/mcsafe_debug.h |   50 +++++++++++++++++++++++++++++++++++
 arch/x86/lib/memcpy_64.S            |    7 +++++
 tools/testing/nvdimm/test/nfit.c    |   48 ++++++++++++++++++++++++++++++++++
 4 files changed, 108 insertions(+)
 create mode 100644 arch/x86/include/asm/mcsafe_debug.h

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 192e4d2f9efc..8bdec78a405f 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -72,6 +72,9 @@ config EARLY_PRINTK_USB_XDBC
 	  You should normally say N here, unless you want to debug early
 	  crashes or need a very simple printk logging facility.
 
+config MCSAFE_DEBUG
+	def_bool n
+
 config X86_PTDUMP_CORE
 	def_bool n
 
diff --git a/arch/x86/include/asm/mcsafe_debug.h b/arch/x86/include/asm/mcsafe_debug.h
new file mode 100644
index 000000000000..0f85d24b46c5
--- /dev/null
+++ b/arch/x86/include/asm/mcsafe_debug.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _MCSAFE_DEBUG_H_
+#define _MCSAFE_DEBUG_H_
+
+#ifndef __ASSEMBLY__
+#ifdef CONFIG_MCSAFE_DEBUG
+extern unsigned long mcsafe_inject;
+
+static inline void set_mcsafe_inject(void *addr)
+{
+	if (addr)
+		mcsafe_inject = (unsigned long) addr;
+	else
+		mcsafe_inject = ~0UL;
+}
+#else /* CONFIG_MCSAFE_DEBUG */
+static inline void set_mcsafe_inject(void *addr)
+{
+}
+#endif /* CONFIG_MCSAFE_DEBUG */
+
+#else /* __ASSEMBLY__ */
+#include <asm/export.h>
+
+#ifdef CONFIG_MCSAFE_DEBUG
+.macro MCSAFE_DEBUG_CTL
+	.pushsection .data
+	.align 8
+	.globl mcsafe_inject
+	mcsafe_inject:
+		.quad 0
+	EXPORT_SYMBOL_GPL(mcsafe_inject)
+	.popsection
+.endm
+
+.macro MCSAFE_DEBUG offset reg count target
+	leaq \offset(\reg), %r9
+	addq \count, %r9
+	cmp mcsafe_inject, %r9
+	jg \target
+.endm
+#else
+.macro MCSAFE_DEBUG_CTL
+.endm
+
+.macro MCSAFE_DEBUG offset reg count target
+.endm
+#endif /* CONFIG_MCSAFE_DEBUG */
+#endif /* __ASSEMBLY__ */
+#endif /* _MCSAFE_DEBUG_H_ */
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index c3b527a9f95d..e5f489b2c6ea 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -3,6 +3,7 @@
 #include <linux/linkage.h>
 #include <asm/errno.h>
 #include <asm/cpufeatures.h>
+#include <asm/mcsafe_debug.h>
 #include <asm/alternative-asm.h>
 #include <asm/export.h>
 
@@ -183,6 +184,9 @@ ENTRY(memcpy_orig)
 ENDPROC(memcpy_orig)
 
 #ifndef CONFIG_UML
+
+MCSAFE_DEBUG_CTL
+
 /*
  * __memcpy_mcsafe - memory copy with machine check exception handling
  * Note that we only catch machine checks when reading the source addresses.
@@ -205,6 +209,7 @@ ENTRY(__memcpy_mcsafe)
 	negl %ecx
 	subl %ecx, %edx
 .L_read_leading_bytes:
+	MCSAFE_DEBUG 0 %rsi $1 .E_leading_bytes
 	movb (%rsi), %al
 .L_write_leading_bytes:
 	movb %al, (%rdi)
@@ -220,6 +225,7 @@ ENTRY(__memcpy_mcsafe)
 	jz .L_no_whole_words
 
 .L_read_words:
+	MCSAFE_DEBUG 0 %rsi $8 .E_read_words
 	movq (%rsi), %r8
 .L_write_words:
 	movq %r8, (%rdi)
@@ -236,6 +242,7 @@ ENTRY(__memcpy_mcsafe)
 	/* Copy trailing bytes */
 	movl %edx, %ecx
 .L_read_trailing_bytes:
+	MCSAFE_DEBUG 0 %rsi $1 .E_trailing_bytes
 	movb (%rsi), %al
 .L_write_trailing_bytes:
 	movb %al, (%rdi)
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 4ea385be528f..db04ff658971 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -29,6 +29,8 @@
 #include "nfit_test.h"
 #include "../watermark.h"
 
+#include <asm/mcsafe_debug.h>
+
 /*
  * Generate an NFIT table to describe the following topology:
  *
@@ -2681,6 +2683,51 @@ static struct platform_driver nfit_test_driver = {
 	.id_table = nfit_test_id,
 };
 
+static char mcsafe_buf[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
+
+void mcsafe_test(void)
+{
+	bool do_inject = false;
+	int i;
+
+	if (IS_ENABLED(CONFIG_MCSAFE_DEBUG)) {
+		pr_info("%s: run...\n", __func__);
+	} else {
+		pr_info("%s: disabled, skip.\n", __func__);
+		return;
+	}
+
+retry:
+	for (i = 0; i < 512; i++) {
+		unsigned long expect, rem;
+		void *src, *dst;
+
+		if (do_inject) {
+			set_mcsafe_inject(&mcsafe_buf[1024]);
+			expect = 512 - i;
+		} else {
+			set_mcsafe_inject(NULL);
+			expect = 0;
+		}
+
+		dst = &mcsafe_buf[2048];
+		src = &mcsafe_buf[1024 - i];
+		rem = __memcpy_mcsafe(dst, src, 512);
+		if (rem == expect)
+			continue;
+		pr_info("%s: copy(%#lx, %#lx, %d) offset: %d got: %ld expect: %ld\n",
+				__func__, ((unsigned long) dst) & ~PAGE_MASK,
+				((unsigned long ) src) & ~PAGE_MASK,
+				512, i, rem, expect);
+	}
+
+	if (!do_inject) {
+		do_inject = true;
+		goto retry;
+	}
+	set_mcsafe_inject(NULL);
+}
+
 static __init int nfit_test_init(void)
 {
 	int rc, i;
@@ -2689,6 +2736,7 @@ static __init int nfit_test_init(void)
 	libnvdimm_test();
 	acpi_nfit_test();
 	device_dax_test();
+	mcsafe_test();
 
 	nfit_test_setup(nfit_test_lookup, nfit_test_evaluate_dsm);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
