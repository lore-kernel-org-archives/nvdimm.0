Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E17B81A1E1B
 for <linux-nvdimm@lists.01.org>; Mon, 29 Aug 2016 12:12:09 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v4 RESEND 1/2] thp,
 dax: add thp_get_unmapped_area for pmd mappings
Date: Mon, 29 Aug 2016 13:11:20 -0600
Message-Id: <1472497881-9323-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1472497881-9323-1-git-send-email-toshi.kani@hpe.com>
References: <1472497881-9323-1-git-send-email-toshi.kani@hpe.com>
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
To: akpm@linux-foundation.org
Cc: jack@suse.cz, mawilcox@microsoft.com, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org, tytso@mit.edu, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com
List-ID: <linux-nvdimm@lists.01.org>

When CONFIG_FS_DAX_PMD is set, DAX supports mmap() using pmd page
size.  This feature relies on both mmap virtual address and FS
block (i.e. physical address) to be aligned by the pmd page size.
Users can use mkfs options to specify FS to align block allocations.
However, aligning mmap address requires code changes to existing
applications for providing a pmd-aligned address to mmap().

For instance, fio with "ioengine=mmap" performs I/Os with mmap() [1].
It calls mmap() with a NULL address, which needs to be changed to
provide a pmd-aligned address for testing with DAX pmd mappings.
Changing all applications that call mmap() with NULL is undesirable.

Add thp_get_unmapped_area(), which can be called by filesystem's
get_unmapped_area to align an mmap address by the pmd size for
a DAX file.  It calls the default handler, mm->get_unmapped_area(),
to find a range and then aligns it for a DAX file.

The patch is based on Matthew Wilcox's change that allows adding
support of the pud page size easily.

[1]: https://github.com/axboe/fio/blob/master/engines/mmap.c
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
---
 include/linux/huge_mm.h |    7 +++++++
 mm/huge_memory.c        |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 6f14de4..4fca526 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -87,6 +87,10 @@ extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
 
 extern unsigned long transparent_hugepage_flags;
 
+extern unsigned long thp_get_unmapped_area(struct file *filp,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
+		unsigned long flags);
+
 extern void prep_transhuge_page(struct page *page);
 extern void free_transhuge_page(struct page *page);
 
@@ -169,6 +173,9 @@ void put_huge_zero_page(void);
 static inline void prep_transhuge_page(struct page *page) {}
 
 #define transparent_hugepage_flags 0UL
+
+#define thp_get_unmapped_area	NULL
+
 static inline int
 split_huge_page_to_list(struct page *page, struct list_head *list)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2db2112..883f0ee 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -469,6 +469,49 @@ void prep_transhuge_page(struct page *page)
 	set_compound_page_dtor(page, TRANSHUGE_PAGE_DTOR);
 }
 
+unsigned long __thp_get_unmapped_area(struct file *filp, unsigned long len,
+		loff_t off, unsigned long flags, unsigned long size)
+{
+	unsigned long addr;
+	loff_t off_end = off + len;
+	loff_t off_align = round_up(off, size);
+	unsigned long len_pad;
+
+	if (off_end <= off_align || (off_end - off_align) < size)
+		return 0;
+
+	len_pad = len + size;
+	if (len_pad < len || (off + len_pad) < off)
+		return 0;
+
+	addr = current->mm->get_unmapped_area(filp, 0, len_pad,
+					      off >> PAGE_SHIFT, flags);
+	if (IS_ERR_VALUE(addr))
+		return 0;
+
+	addr += (off - addr) & (size - 1);
+	return addr;
+}
+
+unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
+
+	if (addr)
+		goto out;
+	if (!IS_DAX(filp->f_mapping->host) || !IS_ENABLED(CONFIG_FS_DAX_PMD))
+		goto out;
+
+	addr = __thp_get_unmapped_area(filp, len, off, flags, PMD_SIZE);
+	if (addr)
+		return addr;
+
+ out:
+	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
+}
+EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
+
 static int __do_huge_pmd_anonymous_page(struct fault_env *fe, struct page *page,
 		gfp_t gfp)
 {
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
