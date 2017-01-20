Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1E3AE81E9F
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jan 2017 19:55:03 -0800 (PST)
Subject: [PATCH 08/13] x86, libnvdimm, dax: stop abusing __copy_user_nocache
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Jan 2017 19:50:56 -0800
Message-ID: <148488425640.37913.8286479292337338357.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

The pmem and nd_blk drivers both have need to copy data through the cpu
cache to persistent memory. To date they have been abusing
__copy_user_nocache through the memcpy_to_pmem abstraction, but this has
several problems:

* __copy_user_nocache does not guarantee that it will always avoid the
cache. While we have fixed the cases where the pmem usage might trigger
that behavior it's a fragile assumption and burdens the uaccess.h
implementation with worrying about the distinction between 'nocache' and
the stricter write-through semantic needed by pmem.

* It implements SMAP (supervisor mode access protection) which is only
meant for user copies.

__arch_memcpy_to_pmem() is a copy of __copy_user_nocache() minus SMAP,
unaligned support, and exception handling. The configuration symbol
ARCH_HAS_PMEM_API is also moved local to libnvdimm to be next to the
implementation.

Cc: <x86@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Brian Boylston <brian.boylston@hpe.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 MAINTAINERS                     |    2 -
 arch/x86/Kconfig                |    1 -
 arch/x86/include/asm/pmem.h     |   48 --------------------------
 drivers/acpi/nfit/core.c        |    3 +-
 drivers/nvdimm/Kconfig          |    4 ++
 drivers/nvdimm/Makefile         |    1 +
 drivers/nvdimm/claim.c          |    4 +-
 drivers/nvdimm/namespace_devs.c |    1 -
 drivers/nvdimm/pmem.c           |    4 +-
 drivers/nvdimm/region_devs.c    |    1 -
 drivers/nvdimm/x86-asm.S        |   71 +++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/x86.c            |   14 ++++++++
 fs/dax.c                        |    1 -
 include/linux/libnvdimm.h       |    9 +++++
 include/linux/pmem.h            |   59 --------------------------------
 lib/Kconfig                     |    3 --
 tools/testing/nvdimm/Kbuild     |    1 +
 17 files changed, 105 insertions(+), 122 deletions(-)
 delete mode 100644 arch/x86/include/asm/pmem.h
 create mode 100644 drivers/nvdimm/x86-asm.S
 delete mode 100644 include/linux/pmem.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 0277df881da4..f5854de3afab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7368,8 +7368,6 @@ L:	linux-nvdimm@lists.01.org
 Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
 S:	Supported
 F:	drivers/nvdimm/pmem.c
-F:	include/linux/pmem.h
-F:	arch/*/include/asm/pmem.h
 
 LIGHTNVM PLATFORM SUPPORT
 M:	Matias Bjorling <mb@lightnvm.io>
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e487493bbd47..db2d4601a02f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -52,7 +52,6 @@ config X86
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_KCOV			if X86_64
 	select ARCH_HAS_MMIO_FLUSH
-	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
deleted file mode 100644
index ded2541a7ba9..000000000000
--- a/arch/x86/include/asm/pmem.h
+++ /dev/null
@@ -1,48 +0,0 @@
-/*
- * Copyright(c) 2015 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-#ifndef __ASM_X86_PMEM_H__
-#define __ASM_X86_PMEM_H__
-
-#include <linux/uaccess.h>
-#include <asm/cacheflush.h>
-#include <asm/cpufeature.h>
-#include <asm/special_insns.h>
-
-#ifdef CONFIG_ARCH_HAS_PMEM_API
-/**
- * arch_memcpy_to_pmem - copy data to persistent memory
- * @dst: destination buffer for the copy
- * @src: source buffer for the copy
- * @n: length of the copy in bytes
- *
- * Copy data to persistent memory media via non-temporal stores so that
- * a subsequent pmem driver flush operation will drain posted write queues.
- */
-static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
-{
-	int rem;
-
-	/*
-	 * We are copying between two kernel buffers, if
-	 * __copy_from_user_inatomic_nocache() returns an error (page
-	 * fault) we would have already reported a general protection fault
-	 * before the WARN+BUG.
-	 */
-	rem = __copy_from_user_inatomic_nocache(dst, (void __user *) src, n);
-	if (WARN(rem, "%s: fault copying %p <- %p unwritten: %d\n",
-				__func__, dst, src, rem))
-		BUG();
-}
-
-#endif /* CONFIG_ARCH_HAS_PMEM_API */
-#endif /* __ASM_X86_PMEM_H__ */
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 2019de7b84e5..41fa3f46e6e3 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -20,7 +20,6 @@
 #include <linux/list.h>
 #include <linux/acpi.h>
 #include <linux/sort.h>
-#include <linux/pmem.h>
 #include <linux/io.h>
 #include <linux/nd.h>
 #include <asm/cacheflush.h>
@@ -1758,7 +1757,7 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
 		}
 
 		if (rw)
-			memcpy_to_pmem(mmio->addr.aperture + offset,
+			arch_memcpy_to_pmem(mmio->addr.aperture + offset,
 					iobuf + copied, c);
 		else {
 			if (nfit_blk->dimm_flags & NFIT_BLK_READ_FLUSH)
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 59e750183b7f..2b62c122e1e5 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -35,6 +35,10 @@ config BLK_DEV_PMEM
 
 	  Say Y if you want to use an NVDIMM
 
+config ARCH_HAS_PMEM_API
+	depends on X86_64
+	def_bool y
+
 config ND_BLK
 	tristate "BLK: Block data window (aperture) device support"
 	default LIBNVDIMM
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index 9eafb1dd2876..f7e735f7c330 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -25,3 +25,4 @@ libnvdimm-$(CONFIG_BTT) += btt_devs.o
 libnvdimm-$(CONFIG_NVDIMM_PFN) += pfn_devs.o
 libnvdimm-$(CONFIG_NVDIMM_DAX) += dax_devs.o
 libnvdimm-$(CONFIG_X86_64) += x86.o
+libnvdimm-$(CONFIG_X86_64) += x86-asm.o
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index dca2a15dc01d..4f26b3fa8c40 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -10,9 +10,9 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
+#include <linux/libnvdimm.h>
 #include <linux/device.h>
 #include <linux/sizes.h>
-#include <linux/pmem.h>
 #include "nd-core.h"
 #include "pmem.h"
 #include "pfn.h"
@@ -259,7 +259,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 			rc = -EIO;
 	}
 
-	memcpy_to_pmem(nsio->addr + offset, buf, size);
+	arch_memcpy_to_pmem(nsio->addr + offset, buf, size);
 	nvdimm_flush(to_nd_region(ndns->dev.parent));
 
 	return rc;
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 6307088b375f..eabfc46eb732 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -14,7 +14,6 @@
 #include <linux/device.h>
 #include <linux/sort.h>
 #include <linux/slab.h>
-#include <linux/pmem.h>
 #include <linux/list.h>
 #include <linux/nd.h>
 #include "nd-core.h"
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index d551bd2ef9dd..f971be271eac 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -27,7 +27,7 @@
 #include <linux/vmalloc.h>
 #include <linux/pfn_t.h>
 #include <linux/slab.h>
-#include <linux/pmem.h>
+#include <linux/uio.h>
 #include <linux/nd.h>
 #include "pmem.h"
 #include "pfn.h"
@@ -78,7 +78,7 @@ static void write_pmem(void *pmem_addr, struct page *page,
 {
 	void *mem = kmap_atomic(page);
 
-	memcpy_to_pmem(pmem_addr, mem + off, len);
+	arch_memcpy_to_pmem(pmem_addr, mem + off, len);
 	kunmap_atomic(mem);
 }
 
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 7cd705f3247c..c47cecc9358b 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -15,7 +15,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/hash.h>
-#include <linux/pmem.h>
 #include <linux/sort.h>
 #include <linux/io.h>
 #include <linux/nd.h>
diff --git a/drivers/nvdimm/x86-asm.S b/drivers/nvdimm/x86-asm.S
new file mode 100644
index 000000000000..23c5ec94e896
--- /dev/null
+++ b/drivers/nvdimm/x86-asm.S
@@ -0,0 +1,71 @@
+/*
+ * Copyright (c) 2017, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#include <linux/linkage.h>
+
+/*
+ * __arch_memcpy_to_pmem - non-temporal + unordered memory copy
+ *
+ * 8-byte alignment for destination, source, and len. The results of
+ * this transfer are not persistent or globally visible until a
+ * sub-sequent sfence (REQ_FLUSH) to the pmem driver.
+ *
+ * Derived from __copy_user_nocache.
+ */
+ENTRY(__arch_memcpy_to_pmem)
+	/* Set 4x8-byte copy count and remainder */
+	movl %edx,%ecx
+	andl $63,%edx
+	shrl $6,%ecx
+	jz .L_8b_pmem_copy_entry	/* jump if count is 0 */
+
+	/* Perform 4x8-byte pmem loop-copy */
+.L_4x8b_pmem_copy_loop:
+	movq (%rsi),%r8
+	movq 1*8(%rsi),%r9
+	movq 2*8(%rsi),%r10
+	movq 3*8(%rsi),%r11
+	movnti %r8,(%rdi)
+	movnti %r9,1*8(%rdi)
+	movnti %r10,2*8(%rdi)
+	movnti %r11,3*8(%rdi)
+	movq 4*8(%rsi),%r8
+	movq 5*8(%rsi),%r9
+	movq 6*8(%rsi),%r10
+	movq 7*8(%rsi),%r11
+	movnti %r8,4*8(%rdi)
+	movnti %r9,5*8(%rdi)
+	movnti %r10,6*8(%rdi)
+	movnti %r11,7*8(%rdi)
+	leaq 64(%rsi),%rsi
+	leaq 64(%rdi),%rdi
+	decl %ecx
+	jnz .L_4x8b_pmem_copy_loop
+
+	/* Set 8-byte copy count and remainder */
+.L_8b_pmem_copy_entry:
+	movl %edx,%ecx
+	andl $7,%edx
+	shrl $3,%ecx
+	jnz .L_8b_pmem_copy_loop /* continue if count non-zero */
+	ret
+
+	/* Perform 8-byte pmem loop-copy */
+.L_8b_pmem_copy_loop:
+	movq (%rsi),%r8
+	movnti %r8,(%rdi)
+	leaq 8(%rsi),%rsi
+	leaq 8(%rdi),%rdi
+	decl %ecx
+	jnz .L_8b_pmem_copy_loop
+	ret
+ENDPROC(__arch_memcpy_to_pmem)
diff --git a/drivers/nvdimm/x86.c b/drivers/nvdimm/x86.c
index 07478ed7ce97..0d0e2e5fadae 100644
--- a/drivers/nvdimm/x86.c
+++ b/drivers/nvdimm/x86.c
@@ -40,3 +40,17 @@ void arch_invalidate_pmem(void *addr, size_t size)
 	clflush_cache_range(addr, size);
 }
 EXPORT_SYMBOL_GPL(arch_invalidate_pmem);
+
+void __arch_memcpy_to_pmem(void *dst, void *src, unsigned size);
+
+void arch_memcpy_to_pmem(void *dst, void *src, unsigned size)
+{
+	if (((unsigned long) dst | (unsigned long) src | size) & 7) {
+		/* __arch_memcpy_to_pmem assumes 8-byte alignment */
+		memcpy(dst, src, size);
+		arch_wb_cache_pmem(dst, size);
+		return;
+	}
+	__arch_memcpy_to_pmem(dst, src, size);
+}
+EXPORT_SYMBOL_GPL(arch_memcpy_to_pmem);
diff --git a/fs/dax.c b/fs/dax.c
index 8883ce4d391e..49b81c251763 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -25,7 +25,6 @@
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/pagevec.h>
-#include <linux/pmem.h>
 #include <linux/sched.h>
 #include <linux/uio.h>
 #include <linux/vmstat.h>
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 8458c5351e56..bb7a81f469e1 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -160,4 +160,13 @@ void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane);
 u64 nd_fletcher64(void *addr, size_t len, bool le);
 void nvdimm_flush(struct nd_region *nd_region);
 int nvdimm_has_flush(struct nd_region *nd_region);
+#ifdef CONFIG_ARCH_HAS_PMEM_API
+void arch_memcpy_to_pmem(void *dst, void *src, unsigned size);
+#define ARCH_MEMREMAP_PMEM MEMREMAP_WB
+#else
+static inline void arch_memcpy_to_pmem(void *dst, void *src, unsigned size)
+{
+}
+#define ARCH_MEMREMAP_PMEM MEMREMAP_WT
+#endif /* CONFIG_ARCH_HAS_PMEM_API */
 #endif /* __LIBNVDIMM_H__ */
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
deleted file mode 100644
index 559c00848583..000000000000
--- a/include/linux/pmem.h
+++ /dev/null
@@ -1,59 +0,0 @@
-/*
- * Copyright(c) 2015 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-#ifndef __PMEM_H__
-#define __PMEM_H__
-
-#include <linux/io.h>
-#include <linux/uio.h>
-
-#ifdef CONFIG_ARCH_HAS_PMEM_API
-#define ARCH_MEMREMAP_PMEM MEMREMAP_WB
-#include <asm/pmem.h>
-#else
-#define ARCH_MEMREMAP_PMEM MEMREMAP_WT
-/*
- * These are simply here to enable compilation, all call sites gate
- * calling these symbols with arch_has_pmem_api() and redirect to the
- * implementation in asm/pmem.h.
- */
-static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
-{
-	BUG();
-}
-#endif
-
-static inline bool arch_has_pmem_api(void)
-{
-	return IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API);
-}
-
-/**
- * memcpy_to_pmem - copy data to persistent memory
- * @dst: destination buffer for the copy
- * @src: source buffer for the copy
- * @n: length of the copy in bytes
- *
- * Perform a memory copy that results in the destination of the copy
- * being effectively evicted from, or never written to, the processor
- * cache hierarchy after the copy completes.  After memcpy_to_pmem()
- * data may still reside in cpu or platform buffers, so this operation
- * must be followed by a blkdev_issue_flush() on the pmem block device.
- */
-static inline void memcpy_to_pmem(void *dst, const void *src, size_t n)
-{
-	if (arch_has_pmem_api())
-		arch_memcpy_to_pmem(dst, src, n);
-	else
-		memcpy(dst, src, n);
-}
-#endif /* __PMEM_H__ */
diff --git a/lib/Kconfig b/lib/Kconfig
index 260a80e313b9..006264ac768a 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -537,9 +537,6 @@ config SG_POOL
 config ARCH_HAS_SG_CHAIN
 	def_bool n
 
-config ARCH_HAS_PMEM_API
-	bool
-
 config ARCH_HAS_MMIO_FLUSH
 	bool
 
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 7488dfa1309a..a989ded70c18 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -67,6 +67,7 @@ libnvdimm-$(CONFIG_BTT) += $(NVDIMM_SRC)/btt_devs.o
 libnvdimm-$(CONFIG_NVDIMM_PFN) += $(NVDIMM_SRC)/pfn_devs.o
 libnvdimm-$(CONFIG_NVDIMM_DAX) += $(NVDIMM_SRC)/dax_devs.o
 libnvdimm-$(CONFIG_X86_64) += $(NVDIMM_SRC)/x86.o
+libnvdimm-$(CONFIG_X86_64) += $(NVDIMM_SRC)/x86-asm.o
 libnvdimm-y += config_check.o
 
 obj-m += test/

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
