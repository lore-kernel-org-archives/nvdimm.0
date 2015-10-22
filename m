Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 5/5] block: enable dax for raw block devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Oct 2015 13:10:44 -0400
Message-ID: <20151022171044.38343.2553.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20151022171015.38343.72043.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151022171015.38343.72043.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.com>, david@fromorbit.com, linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, ross.zwisler@linux.intel.com, willy@linux.intel.com, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

If an application wants exclusive access to all of the persistent memory
provided by an NVDIMM namespace it can use this raw-block-dax facility
to forgo establishing a filesystem.  This capability is targeted
primarily to hypervisors wanting to provision persistent memory for
guests.

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/block_dev.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index c1f691859a56..210d05103657 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1687,13 +1687,71 @@ static const struct address_space_operations def_blk_aops = {
 	.is_dirty_writeback = buffer_check_dirty_writeback,
 };
 
+#ifdef CONFIG_FS_DAX
+/*
+ * In the raw block case we do not need to contend with truncation nor
+ * unwritten file extents.  Without those concerns there is no need for
+ * additional locking beyond the mmap_sem context that these routines
+ * are already executing under.
+ *
+ * Note, there is no protection if the block device is dynamically
+ * resized (partition grow/shrink) during a fault. A stable block device
+ * size is already not enforced in the blkdev_direct_IO path.
+ *
+ * For DAX, it is the responsibility of the block device driver to
+ * ensure the whole-disk device size is stable while requests are in
+ * flight.
+ *
+ * Finally, in contrast to the generic_file_mmap() path, there are no
+ * calls to sb_start_pagefault().  That is meant to synchronize write
+ * faults against requests to freeze the contents of the filesystem
+ * hosting vma->vm_file.  However, in the case of a block device special
+ * file, it is a 0-sized device node usually hosted on devtmpfs, i.e.
+ * nothing to do with the super_block for bdev_file_inode(vma->vm_file).
+ * We could call get_super() in this path to retrieve the right
+ * super_block, but the generic_file_mmap() path does not do this for
+ * the CONFIG_FS_DAX=n case.
+ */
+static int blkdev_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	return __dax_fault(vma, vmf, blkdev_get_block, NULL);
+}
+
+static int blkdev_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
+		pmd_t *pmd, unsigned int flags)
+{
+	return __dax_pmd_fault(vma, addr, pmd, flags, blkdev_get_block, NULL);
+}
+
+static const struct vm_operations_struct blkdev_dax_vm_ops = {
+	.page_mkwrite	= blkdev_dax_fault,
+	.fault		= blkdev_dax_fault,
+	.pmd_fault	= blkdev_dax_pmd_fault,
+};
+
+static int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct inode *bd_inode = bdev_file_inode(file);
+
+	if (!IS_DAX(bd_inode))
+		return generic_file_mmap(file, vma);
+
+	file_accessed(file);
+	vma->vm_ops = &blkdev_dax_vm_ops;
+	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+	return 0;
+}
+#else
+#define blkdev_mmap generic_file_mmap
+#endif
+
 const struct file_operations def_blk_fops = {
 	.open		= blkdev_open,
 	.release	= blkdev_close,
 	.llseek		= block_llseek,
 	.read_iter	= blkdev_read_iter,
 	.write_iter	= blkdev_write_iter,
-	.mmap		= generic_file_mmap,
+	.mmap		= blkdev_mmap,
 	.fsync		= blkdev_fsync,
 	.unlocked_ioctl	= block_ioctl,
 #ifdef CONFIG_COMPAT

