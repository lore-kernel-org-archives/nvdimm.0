Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C909381EA0
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jan 2017 19:54:51 -0800 (PST)
Subject: [PATCH 06/13] x86, dax, libnvdimm: move wb_cache_pmem() to libnvdimm
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Jan 2017 19:50:45 -0800
Message-ID: <148488424537.37913.11896267277639094978.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

With all calls to this routine re-directed through the pmem driver, we
can kill the pmem api indirection. arch_wb_cache_pmem() is now
optionally supplied by an arch specific extension to libnvdimm.  Same as
before, pmem flushing is only defined for x86_64, but it is
straightforward to add other archs in the future.

Cc: <x86@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/pmem.h |   20 --------------------
 drivers/nvdimm/Makefile     |    1 +
 drivers/nvdimm/pmem.c       |    4 ++--
 drivers/nvdimm/pmem.h       |    9 +++++++++
 drivers/nvdimm/x86.c        |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/pmem.h        |   19 -------------------
 tools/testing/nvdimm/Kbuild |    1 +
 7 files changed, 49 insertions(+), 41 deletions(-)
 create mode 100644 drivers/nvdimm/x86.c

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index ab4983df7bff..4759a179aa52 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -44,26 +44,6 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
 		BUG();
 }
 
-/**
- * arch_wb_cache_pmem - write back a cache range with CLWB
- * @vaddr:	virtual start address
- * @size:	number of bytes to write back
- *
- * Write back a cache range using the CLWB (cache line write back)
- * instruction.
- */
-static inline void arch_wb_cache_pmem(void *addr, size_t size)
-{
-	u16 x86_clflush_size = boot_cpu_data.x86_clflush_size;
-	unsigned long clflush_mask = x86_clflush_size - 1;
-	void *vend = addr + size;
-	void *p;
-
-	for (p = (void *)((unsigned long)addr & ~clflush_mask);
-	     p < vend; p += x86_clflush_size)
-		clwb(p);
-}
-
 static inline void arch_invalidate_pmem(void *addr, size_t size)
 {
 	clflush_cache_range(addr, size);
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index 909554c3f955..9eafb1dd2876 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -24,3 +24,4 @@ libnvdimm-$(CONFIG_ND_CLAIM) += claim.o
 libnvdimm-$(CONFIG_BTT) += btt_devs.o
 libnvdimm-$(CONFIG_NVDIMM_PFN) += pfn_devs.o
 libnvdimm-$(CONFIG_NVDIMM_DAX) += dax_devs.o
+libnvdimm-$(CONFIG_X86_64) += x86.o
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 68fc7599a053..838241bb31d1 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -222,14 +222,14 @@ static size_t pmem_copy_from_iter(void *addr, size_t bytes,
 {
 	size_t rc = copy_from_iter_nocache(addr, bytes, i);
 
-	wb_cache_pmem(addr, bytes);
+	arch_wb_cache_pmem(addr, bytes);
 	return rc;
 }
 
 static const struct dax_operations pmem_dax_ops = {
 	.direct_access = pmem_direct_access,
 	.copy_from_iter = pmem_copy_from_iter,
-	.flush = wb_cache_pmem,
+	.flush = arch_wb_cache_pmem,
 };
 
 static const struct block_device_operations pmem_fops = {
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index b4ee4f71b4a1..4faacff434ff 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -7,6 +7,15 @@
 
 long pmem_direct_access(struct block_device *bdev, sector_t sector,
 		      void **kaddr, pfn_t *pfn, long size);
+
+#ifdef CONFIG_ARCH_HAS_PMEM_API
+void arch_wb_cache_pmem(void *addr, size_t size);
+#else
+static inline void arch_wb_cache_pmem(void *addr, size_t size)
+{
+}
+#endif
+
 /* this definition is in it's own header for tools/testing/nvdimm to consume */
 struct pmem_device {
 	/* One contiguous memory region per device */
diff --git a/drivers/nvdimm/x86.c b/drivers/nvdimm/x86.c
new file mode 100644
index 000000000000..79d7267da4d2
--- /dev/null
+++ b/drivers/nvdimm/x86.c
@@ -0,0 +1,36 @@
+/*
+ * Copyright(c) 2015 - 2017 Intel Corporation. All rights reserved.
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
+#include <asm/cacheflush.h>
+#include <asm/cpufeature.h>
+#include <asm/special_insns.h>
+
+/**
+ * arch_wb_cache_pmem - write back a cache range with CLWB
+ * @vaddr:	virtual start address
+ * @size:	number of bytes to write back
+ *
+ * Write back a cache range using the CLWB (cache line write back)
+ * instruction.
+ */
+void arch_wb_cache_pmem(void *addr, size_t size)
+{
+	u16 x86_clflush_size = boot_cpu_data.x86_clflush_size;
+	unsigned long clflush_mask = x86_clflush_size - 1;
+	void *vend = addr + size;
+	void *p;
+
+	for (p = (void *)((unsigned long)addr & ~clflush_mask);
+	     p < vend; p += x86_clflush_size)
+		clwb(p);
+}
+EXPORT_SYMBOL_GPL(arch_wb_cache_pmem);
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index 772bd02a5b52..33ae761f010a 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -31,11 +31,6 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
 	BUG();
 }
 
-static inline void arch_wb_cache_pmem(void *addr, size_t size)
-{
-	BUG();
-}
-
 static inline void arch_invalidate_pmem(void *addr, size_t size)
 {
 	BUG();
@@ -80,18 +75,4 @@ static inline void invalidate_pmem(void *addr, size_t size)
 	if (arch_has_pmem_api())
 		arch_invalidate_pmem(addr, size);
 }
-
-/**
- * wb_cache_pmem - write back processor cache for PMEM memory range
- * @addr:	virtual start address
- * @size:	number of bytes to write back
- *
- * Write back the processor cache range starting at 'addr' for 'size' bytes.
- * See blkdev_issue_flush() note for memcpy_to_pmem().
- */
-static inline void wb_cache_pmem(void *addr, size_t size)
-{
-	if (arch_has_pmem_api())
-		arch_wb_cache_pmem(addr, size);
-}
 #endif /* __PMEM_H__ */
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 405212be044a..7488dfa1309a 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -66,6 +66,7 @@ libnvdimm-$(CONFIG_ND_CLAIM) += $(NVDIMM_SRC)/claim.o
 libnvdimm-$(CONFIG_BTT) += $(NVDIMM_SRC)/btt_devs.o
 libnvdimm-$(CONFIG_NVDIMM_PFN) += $(NVDIMM_SRC)/pfn_devs.o
 libnvdimm-$(CONFIG_NVDIMM_DAX) += $(NVDIMM_SRC)/dax_devs.o
+libnvdimm-$(CONFIG_X86_64) += $(NVDIMM_SRC)/x86.o
 libnvdimm-y += config_check.o
 
 obj-m += test/

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
