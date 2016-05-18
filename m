Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 0E8CA1A1FCC
 for <linux-nvdimm@lists.01.org>; Wed, 18 May 2016 13:57:20 -0700 (PDT)
Subject: [PATCH v3 4/5] Revert "block: enable dax for raw block devices"
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 May 2016 13:56:27 -0700
Message-ID: <146360498783.37439.985952081949861861.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146360496572.37439.6497663679891935585.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146360496572.37439.6497663679891935585.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, hch@lst.de, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

This reverts commit 5a023cdba50c5f5f2bc351783b3131699deb3937.

The functionality is superseded by the new "Device DAX" facility.

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/ioctl.c           |   32 ----------------
 fs/block_dev.c          |   96 ++++++++++++++---------------------------------
 include/linux/fs.h      |    8 ----
 include/uapi/linux/fs.h |    1 
 4 files changed, 29 insertions(+), 108 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 4ff1f92f89ca..698c7933d582 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -407,35 +407,6 @@ static inline int is_unrecognized_ioctl(int ret)
 		ret == -ENOIOCTLCMD;
 }
 
-#ifdef CONFIG_FS_DAX
-bool blkdev_dax_capable(struct block_device *bdev)
-{
-	struct gendisk *disk = bdev->bd_disk;
-
-	if (!disk->fops->direct_access)
-		return false;
-
-	/*
-	 * If the partition is not aligned on a page boundary, we can't
-	 * do dax I/O to it.
-	 */
-	if ((bdev->bd_part->start_sect % (PAGE_SIZE / 512))
-			|| (bdev->bd_part->nr_sects % (PAGE_SIZE / 512)))
-		return false;
-
-	/*
-	 * If the device has known bad blocks, force all I/O through the
-	 * driver / page cache.
-	 *
-	 * TODO: support finer grained dax error handling
-	 */
-	if (disk->bb && disk->bb->count)
-		return false;
-
-	return true;
-}
-#endif
-
 static int blkdev_flushbuf(struct block_device *bdev, fmode_t mode,
 		unsigned cmd, unsigned long arg)
 {
@@ -598,9 +569,6 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKTRACESETUP:
 	case BLKTRACETEARDOWN:
 		return blk_trace_ioctl(bdev, cmd, argp);
-	case BLKDAXGET:
-		return put_int(arg, !!(bdev->bd_inode->i_flags & S_DAX));
-		break;
 	case IOC_PR_REGISTER:
 		return blkdev_pr_register(bdev, argp);
 	case IOC_PR_RESERVE:
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 20a2c02b77c4..36ee10ca503e 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -29,6 +29,7 @@
 #include <linux/log2.h>
 #include <linux/cleancache.h>
 #include <linux/dax.h>
+#include <linux/badblocks.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -1159,6 +1160,33 @@ void bd_set_size(struct block_device *bdev, loff_t size)
 }
 EXPORT_SYMBOL(bd_set_size);
 
+static bool blkdev_dax_capable(struct block_device *bdev)
+{
+	struct gendisk *disk = bdev->bd_disk;
+
+	if (!disk->fops->direct_access || !IS_ENABLED(CONFIG_FS_DAX))
+		return false;
+
+	/*
+	 * If the partition is not aligned on a page boundary, we can't
+	 * do dax I/O to it.
+	 */
+	if ((bdev->bd_part->start_sect % (PAGE_SIZE / 512))
+			|| (bdev->bd_part->nr_sects % (PAGE_SIZE / 512)))
+		return false;
+
+	/*
+	 * If the device has known bad blocks, force all I/O through the
+	 * driver / page cache.
+	 *
+	 * TODO: support finer grained dax error handling
+	 */
+	if (disk->bb && disk->bb->count)
+		return false;
+
+	return true;
+}
+
 static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part);
 
 /*
@@ -1724,79 +1752,13 @@ static const struct address_space_operations def_blk_aops = {
 	.is_dirty_writeback = buffer_check_dirty_writeback,
 };
 
-#ifdef CONFIG_FS_DAX
-/*
- * In the raw block case we do not need to contend with truncation nor
- * unwritten file extents.  Without those concerns there is no need for
- * additional locking beyond the mmap_sem context that these routines
- * are already executing under.
- *
- * Note, there is no protection if the block device is dynamically
- * resized (partition grow/shrink) during a fault. A stable block device
- * size is already not enforced in the blkdev_direct_IO path.
- *
- * For DAX, it is the responsibility of the block device driver to
- * ensure the whole-disk device size is stable while requests are in
- * flight.
- *
- * Finally, unlike the filemap_page_mkwrite() case there is no
- * filesystem superblock to sync against freezing.  We still include a
- * pfn_mkwrite callback for dax drivers to receive write fault
- * notifications.
- */
-static int blkdev_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
-{
-	return __dax_fault(vma, vmf, blkdev_get_block, NULL);
-}
-
-static int blkdev_dax_pfn_mkwrite(struct vm_area_struct *vma,
-		struct vm_fault *vmf)
-{
-	return dax_pfn_mkwrite(vma, vmf);
-}
-
-static int blkdev_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
-		pmd_t *pmd, unsigned int flags)
-{
-	return __dax_pmd_fault(vma, addr, pmd, flags, blkdev_get_block, NULL);
-}
-
-static const struct vm_operations_struct blkdev_dax_vm_ops = {
-	.fault		= blkdev_dax_fault,
-	.pmd_fault	= blkdev_dax_pmd_fault,
-	.pfn_mkwrite	= blkdev_dax_pfn_mkwrite,
-};
-
-static const struct vm_operations_struct blkdev_default_vm_ops = {
-	.fault		= filemap_fault,
-	.map_pages	= filemap_map_pages,
-};
-
-static int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct inode *bd_inode = bdev_file_inode(file);
-
-	file_accessed(file);
-	if (IS_DAX(bd_inode)) {
-		vma->vm_ops = &blkdev_dax_vm_ops;
-		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
-	} else {
-		vma->vm_ops = &blkdev_default_vm_ops;
-	}
-
-	return 0;
-}
-#else
-#define blkdev_mmap generic_file_mmap
-#endif
-
 const struct file_operations def_blk_fops = {
 	.open		= blkdev_open,
 	.release	= blkdev_close,
 	.llseek		= block_llseek,
 	.read_iter	= blkdev_read_iter,
 	.write_iter	= blkdev_write_iter,
-	.mmap		= blkdev_mmap,
+	.mmap		= generic_file_mmap,
 	.fsync		= blkdev_fsync,
 	.unlocked_ioctl	= block_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 70e61b58baaf..8363a10660f6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2320,14 +2320,6 @@ extern struct super_block *freeze_bdev(struct block_device *);
 extern void emergency_thaw_all(void);
 extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
 extern int fsync_bdev(struct block_device *);
-#ifdef CONFIG_FS_DAX
-extern bool blkdev_dax_capable(struct block_device *bdev);
-#else
-static inline bool blkdev_dax_capable(struct block_device *bdev)
-{
-	return false;
-}
-#endif
 
 extern struct super_block *blockdev_superblock;
 
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index a079d50376e1..fbff8b28aa35 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -222,7 +222,6 @@ struct fsxattr {
 #define BLKSECDISCARD _IO(0x12,125)
 #define BLKROTATIONAL _IO(0x12,126)
 #define BLKZEROOUT _IO(0x12,127)
-#define BLKDAXGET _IO(0x12,129)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
