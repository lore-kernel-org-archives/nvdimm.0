Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5424.austin.hp.com (g1t5424.austin.hp.com [15.216.225.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 67F0E1A2110
 for <linux-nvdimm@lists.01.org>; Tue, 12 Apr 2016 13:47:58 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 1/5] dax: add dax_get_unmapped_area for pmd mappings
Date: Tue, 12 Apr 2016 14:39:15 -0600
Message-Id: <1460493555-31611-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1460493555-31611-1-git-send-email-toshi.kani@hpe.com>
References: <1460493555-31611-1-git-send-email-toshi.kani@hpe.com>
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
To: akpm@linux-foundation.org, dan.j.williams@intel.com
Cc: tytso@mit.edu, jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, kirill.shutemov@linux.intel.com
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

Add dax_get_unmapped_area(), which can be called by filesystem's
get_unmapped_area to align an mmap address by the pmd size for
a DAX file.  It calls the default handler, mm->get_unmapped_area(),
to find a range and then aligns it for a DAX file.

[1]: https://github.com/axboe/fio/blob/master/engines/mmap.c
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
---
 fs/dax.c            |   45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dax.h |    2 ++
 2 files changed, 47 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 75ba46d..b54fdb9 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1158,3 +1158,48 @@ int dax_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
 	return dax_zero_page_range(inode, from, length, get_block);
 }
 EXPORT_SYMBOL_GPL(dax_truncate_page);
+
+/**
+ * dax_get_unmapped_area - handle get_unmapped_area for a DAX file
+ * @filp: The file being mmap'd, if not NULL
+ * @addr: The mmap address. If NULL, the kernel assigns the address
+ * @len: The mmap size in bytes
+ * @pgoff: The page offset in the file where the mapping starts from.
+ * @flags: The mmap flags
+ *
+ * This function can be called by a filesystem for get_unmapped_area().
+ * When a target file is a DAX file, it aligns the mmap address at the
+ * beginning of the file by the pmd size.
+ *
+ * When the target file is not a DAX file, @addr is specified, the
+ * request is not suitable for pmd mappings, or mm->get_unmapped_area()
+ * failed with extended @len, it simply calls the default handler,
+ * mm->get_unmapped_area(), with the original arguments.
+ */
+unsigned long dax_get_unmapped_area(struct file *filp, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	unsigned long off, off_end, off_pmd, len_pmd, addr_pmd;
+
+	if (IS_ENABLED(CONFIG_FS_DAX_PMD) &&
+	    filp && !addr && IS_DAX(filp->f_mapping->host)) {
+		off = pgoff << PAGE_SHIFT;
+		off_end = off + len;
+		off_pmd = round_up(off, PMD_SIZE);
+
+		if ((off_end > off_pmd) && ((off_end - off_pmd) >= PMD_SIZE)) {
+			len_pmd = len + PMD_SIZE;
+
+			addr_pmd = current->mm->get_unmapped_area(
+					filp, addr, len_pmd, pgoff, flags);
+
+			if (!IS_ERR_VALUE(addr_pmd)) {
+				addr_pmd += (off - addr_pmd) & (PMD_SIZE - 1);
+				return addr_pmd;
+			}
+		}
+	}
+
+	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
+}
+EXPORT_SYMBOL_GPL(dax_get_unmapped_area);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 636dd59..9d52de0 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -10,6 +10,8 @@ ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *, loff_t,
 int dax_clear_sectors(struct block_device *bdev, sector_t _sector, long _size);
 int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
 int dax_truncate_page(struct inode *, loff_t from, get_block_t);
+unsigned long dax_get_unmapped_area(struct file *filp, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags);
 int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
 		dax_iodone_t);
 int __dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
