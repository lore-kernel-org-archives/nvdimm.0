Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x243.google.com (mail-pg0-x243.google.com
 [IPv6:2607:f8b0:400e:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7841F219428A0
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 10:43:21 -0700 (PDT)
Received: by mail-pg0-x243.google.com with SMTP id 79so697881pgf.0
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 10:43:21 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH 9/9] powerpc: Add pmem API support
Date: Wed, 12 Apr 2017 03:42:33 +1000
Message-Id: <20170411174233.21902-10-oohall@gmail.com>
In-Reply-To: <20170411174233.21902-1-oohall@gmail.com>
References: <20170411174233.21902-1-oohall@gmail.com>
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
To: linuxppc-dev@lists.ozlabs.org
Cc: bsingharora@gmail.com, arbab@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Initial powerpc support for the arch-specific bit of the persistent
memory API. Nothing fancy here.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 arch/powerpc/Kconfig            |   1 +
 arch/powerpc/include/asm/pmem.h | 109 ++++++++++++++++++++++++++++++++++++++++
 arch/powerpc/kernel/misc_64.S   |   2 +-
 3 files changed, 111 insertions(+), 1 deletion(-)
 create mode 100644 arch/powerpc/include/asm/pmem.h

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index d7413ed700b8..cf84d0db49ab 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -87,6 +87,7 @@ config PPC
 	select ARCH_HAS_DMA_SET_COHERENT_MASK
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
+	select ARCH_HAS_PMEM_API
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
diff --git a/arch/powerpc/include/asm/pmem.h b/arch/powerpc/include/asm/pmem.h
new file mode 100644
index 000000000000..27da9594040f
--- /dev/null
+++ b/arch/powerpc/include/asm/pmem.h
@@ -0,0 +1,109 @@
+/*
+ * Copyright(c) 2017 IBM Corporation. All rights reserved.
+ *
+ * Based on the x86 version.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __ASM_POWERPC_PMEM_H__
+#define __ASM_POWERPC_PMEM_H__
+
+#include <linux/uio.h>
+#include <linux/uaccess.h>
+#include <asm/cacheflush.h>
+
+/*
+ * See include/linux/pmem.h for API documentation
+ *
+ * PPC specific notes:
+ *
+ * 1. PPC has no non-temporal (cache bypassing) stores so we're stuck with
+ *    doing cache writebacks.
+ *
+ * 2. DCBST is a suggestion. DCBF *will* force a writeback.
+ *
+ */
+
+static inline void arch_wb_cache_pmem(void *addr, size_t size)
+{
+	unsigned long iaddr = (unsigned long) addr;
+
+	/* NB: contains a barrier */
+	flush_inval_dcache_range(iaddr, iaddr + size);
+}
+
+/* invalidate and writeback are functionally identical */
+#define arch_invalidate_pmem arch_wb_cache_pmem
+
+static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
+{
+	int unwritten;
+
+	/*
+	 * We are copying between two kernel buffers, if
+	 * __copy_from_user_inatomic_nocache() returns an error (page
+	 * fault) we would have already reported a general protection fault
+	 * before the WARN+BUG.
+	 *
+	 * XXX: replace this with a hand-rolled memcpy+dcbf
+	 */
+	unwritten = __copy_from_user_inatomic(dst, (void __user *) src, n);
+	if (WARN(unwritten, "%s: fault copying %p <- %p unwritten: %d\n",
+				__func__, dst, src, unwritten))
+		BUG();
+
+	arch_wb_cache_pmem(dst, n);
+}
+
+static inline int arch_memcpy_from_pmem(void *dst, const void *src, size_t n)
+{
+	/*
+	 * TODO: We should have most of the infrastructure for MCE handling
+	 *       but it needs to be made slightly smarter.
+	 */
+	memcpy(dst, src, n);
+	return 0;
+}
+
+static inline size_t arch_copy_from_iter_pmem(void *addr, size_t bytes,
+		struct iov_iter *i)
+{
+	size_t len;
+
+	/* XXX: under what conditions would this return len < size? */
+	len = copy_from_iter(addr, bytes, i);
+	arch_wb_cache_pmem(addr, bytes - len);
+
+	return len;
+}
+
+static inline void arch_clear_pmem(void *addr, size_t size)
+{
+	void *start = addr;
+
+	/*
+	 * XXX: A hand rolled dcbz+dcbf loop would probably be better.
+	 */
+
+	if (((uintptr_t) addr & ~PAGE_MASK) == 0) {
+		while (size >= PAGE_SIZE) {
+			clear_page(addr);
+			addr += PAGE_SIZE;
+			size -= PAGE_SIZE;
+		}
+	}
+
+	if (size)
+		memset(addr, 0, size);
+
+	arch_wb_cache_pmem(start, size);
+}
+
+#endif /* __ASM_POWERPC_PMEM_H__ */
diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
index c119044cad0d..1378a8d61faf 100644
--- a/arch/powerpc/kernel/misc_64.S
+++ b/arch/powerpc/kernel/misc_64.S
@@ -182,7 +182,7 @@ _GLOBAL(flush_dcache_phys_range)
 	isync
 	blr
 
-_GLOBAL(flush_inval_dcache_range)
+_GLOBAL_TOC(flush_inval_dcache_range)
  	ld	r10,PPC64_CACHES@toc(r2)
 	lwz	r7,DCACHEL1BLOCKSIZE(r10)	/* Get dcache block size */
 	addi	r5,r7,-1
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
