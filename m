Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D53121AE30D7
 for <linux-nvdimm@lists.01.org>; Sun, 11 Jun 2017 17:34:37 -0700 (PDT)
Subject: [PATCH v4 08/14] x86, dax,
 libnvdimm: move wb_cache_pmem() to libnvdimm
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 11 Jun 2017 17:29:22 -0700
Message-ID: <149722735182.16201.12649888866099961756.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149703986971.20620.10303247412197996310.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149703986971.20620.10303247412197996310.stgit@dwillia2-desk3.amr.corp.intel.com>
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

With all calls to this routine re-directed through the pmem driver, we can kill
the pmem api indirection. arch_wb_cache_pmem() is now optionally supplied by
the arch specific asm/pmem.h.  Same as before, pmem flushing is only defined
for x86_64, but it is straightforward to add other archs in the future.

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
Change since v3:
* move the asm/pmem.h include inside CONFIG_ARCH_HAS_PMEM_API ifdef
  guard

 arch/x86/include/asm/pmem.h       |   18 +-----------------
 arch/x86/include/asm/uaccess_64.h |    1 +
 arch/x86/lib/usercopy_64.c        |    3 ++-
 drivers/nvdimm/pmem.c             |    2 +-
 drivers/nvdimm/pmem.h             |    8 ++++++++
 include/linux/pmem.h              |   19 -------------------
 6 files changed, 13 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index f4c119d253f3..862be3a9275c 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -44,25 +44,9 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
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
 static inline void arch_wb_cache_pmem(void *addr, size_t size)
 {
-	u16 x86_clflush_size = boot_cpu_data.x86_clflush_size;
-	unsigned long clflush_mask = x86_clflush_size - 1;
-	void *vend = addr + size;
-	void *p;
-
-	for (p = (void *)((unsigned long)addr & ~clflush_mask);
-	     p < vend; p += x86_clflush_size)
-		clwb(p);
+	clean_cache_range(addr,size);
 }
 
 static inline void arch_invalidate_pmem(void *addr, size_t size)
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index b16f6a1d8b26..bdc4a2761525 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -174,6 +174,7 @@ extern long __copy_user_nocache(void *dst, const void __user *src,
 extern long __copy_user_flushcache(void *dst, const void __user *src, unsigned size);
 extern void memcpy_page_flushcache(char *to, struct page *page, size_t offset,
 			   size_t len);
+void clean_cache_range(void *addr, size_t size);
 
 static inline int
 __copy_from_user_inatomic_nocache(void *dst, const void __user *src,
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index f42d2fd86ca3..baa80ff29da8 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -85,7 +85,7 @@ copy_user_handle_tail(char *to, char *from, unsigned len)
  * instruction. Note that @size is internally rounded up to be cache
  * line size aligned.
  */
-static void clean_cache_range(void *addr, size_t size)
+void clean_cache_range(void *addr, size_t size)
 {
 	u16 x86_clflush_size = boot_cpu_data.x86_clflush_size;
 	unsigned long clflush_mask = x86_clflush_size - 1;
@@ -96,6 +96,7 @@ static void clean_cache_range(void *addr, size_t size)
 	     p < vend; p += x86_clflush_size)
 		clwb(p);
 }
+EXPORT_SYMBOL(clean_cache_range);
 
 long __copy_user_flushcache(void *dst, const void __user *src, unsigned size)
 {
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
index 7f4dbd72a90a..0169a0422b88 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -5,6 +5,14 @@
 #include <linux/pfn_t.h>
 #include <linux/fs.h>
 
+#ifdef CONFIG_ARCH_HAS_PMEM_API
+#include <asm/pmem.h>
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
