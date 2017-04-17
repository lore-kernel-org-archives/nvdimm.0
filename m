Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BBA3621939248
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 12:16:54 -0700 (PDT)
Subject: [resend PATCH v2 26/33] x86, dax,
 libnvdimm: move wb_cache_pmem() to libnvdimm
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Apr 2017 12:11:10 -0700
Message-ID: <149245627028.10206.369315439901964176.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, hch@lst.de
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
Cc: Oliver O'Halloran <oohall@gmail.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/pmem.h |   21 ---------------------
 drivers/nvdimm/Makefile     |    1 +
 drivers/nvdimm/pmem.c       |   14 +++++---------
 drivers/nvdimm/pmem.h       |    8 ++++++++
 drivers/nvdimm/x86.c        |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/pmem.h        |   19 -------------------
 tools/testing/nvdimm/Kbuild |    1 +
 7 files changed, 51 insertions(+), 49 deletions(-)
 create mode 100644 drivers/nvdimm/x86.c

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index f4c119d253f3..4759a179aa52 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -44,27 +44,6 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
 		BUG();
 }
 
-/**
- * arch_wb_cache_pmem - write back a cache range with CLWB
- * @vaddr:	virtual start address
- * @size:	number of bytes to write back
- *
- * Write back a cache range using the CLWB (cache line write back)
- * instruction. Note that @size is internally rounded up to be cache
- * line size aligned.
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
index 822b85fb3365..c77a3a757729 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -245,19 +245,19 @@ static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 
 		if (bytes < 8) {
 			if (!IS_ALIGNED(dest, 4) || (bytes != 4))
-				wb_cache_pmem(addr, 1);
+				arch_wb_cache_pmem(addr, 1);
 		} else {
 			if (!IS_ALIGNED(dest, 8)) {
 				dest = ALIGN(dest, boot_cpu_data.x86_clflush_size);
-				wb_cache_pmem(addr, 1);
+				arch_wb_cache_pmem(addr, 1);
 			}
 
 			flushed = dest - (unsigned long) addr;
 			if (bytes > flushed && !IS_ALIGNED(bytes - flushed, 8))
-				wb_cache_pmem(addr + bytes - 1, 1);
+				arch_wb_cache_pmem(addr + bytes - 1, 1);
 		}
 	} else
-		wb_cache_pmem(addr, bytes);
+		arch_wb_cache_pmem(addr, bytes);
 
 	return len;
 }
@@ -279,11 +279,7 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
 static void pmem_dax_flush(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t size)
 {
-	/*
-	 * TODO: move arch specific cache management into the driver
-	 * directly.
-	 */
-	wb_cache_pmem(addr, size);
+	arch_wb_cache_pmem(addr, size);
 }
 
 static const struct dax_operations pmem_dax_ops = {
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index 7f4dbd72a90a..c4b3371c7f88 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -5,6 +5,14 @@
 #include <linux/pfn_t.h>
 #include <linux/fs.h>
 
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
index 2033ad03b8cd..0e0c444737e9 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -72,6 +72,7 @@ libnvdimm-$(CONFIG_ND_CLAIM) += $(NVDIMM_SRC)/claim.o
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
