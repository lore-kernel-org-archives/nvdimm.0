Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8947B21B02B9D
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 10:58:34 -0700 (PDT)
Subject: [PATCH v4 08/16] x86, dax,
 libnvdimm: remove wb_cache_pmem() indirection
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Jun 2017 10:53:40 -0700
Message-ID: <149875882001.10031.6717822513722497095.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, hch@lst.de, Ingo Molnar <mingo@redhat.com>, viro@zeniv.linux.org.uk, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

With all handling of the CONFIG_ARCH_HAS_PMEM_API case being moved to
libnvdimm and the pmem driver directly we do not need to provide global
wrappers and fallbacks in the CONFIG_ARCH_HAS_PMEM_API=n case. The pmem
driver will simply not link to arch_wb_cache_pmem() in that case.  Same
as before, pmem flushing is only defined for x86_64, via
clean_cache_range(), but it is straightforward to add other archs in the
future.

arch_wb_cache_pmem() is an exported function since the pmem module needs
to find it, but it is privately declared in drivers/nvdimm/pmem.h because
there are no consumers outside of the pmem driver.

Cc: <x86@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oliver O'Halloran <oohall@gmail.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/pmem.h |   21 ---------------------
 arch/x86/lib/usercopy_64.c  |    6 ++++++
 drivers/nvdimm/pmem.c       |    2 +-
 drivers/nvdimm/pmem.h       |    8 ++++++++
 include/linux/pmem.h        |   19 -------------------
 5 files changed, 15 insertions(+), 41 deletions(-)

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
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index f42d2fd86ca3..75d3776123cc 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -97,6 +97,12 @@ static void clean_cache_range(void *addr, size_t size)
 		clwb(p);
 }
 
+void arch_wb_cache_pmem(void *addr, size_t size)
+{
+	clean_cache_range(addr, size);
+}
+EXPORT_SYMBOL_GPL(arch_wb_cache_pmem);
+
 long __copy_user_flushcache(void *dst, const void __user *src, unsigned size)
 {
 	unsigned long flushed, dest = (unsigned long) dst;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 823b07774244..3b87702d46bb 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -245,7 +245,7 @@ static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 static void pmem_dax_flush(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t size)
 {
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

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
