Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 12/15] block: enable dax for raw block devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 01 Nov 2015 23:30:47 -0500
Message-ID: <20151102043047.6610.59544.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, hch@lst.de, Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.com>, ross.zwisler@linux.intel.com, kbuild test robot <fengguang.wu@intel.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

If an application wants exclusive access to all of the persistent memory
provided by an NVDIMM namespace it can use this raw-block-dax facility
to forgo establishing a filesystem.  This capability is targeted
primarily to hypervisors wanting to provision persistent memory for
guests.  It can be disabled / enabled dynamically via the new BLKDAXSET
ioctl.

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Reviewed-by: Jan Kara <jack@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/ioctl.c           |   43 ++++++++++++++++++++++
 fs/block_dev.c          |   90 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/fs.h      |    3 ++
 include/uapi/linux/fs.h |    2 +
 4 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 8061eba42887..205d57612fbd 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -295,6 +295,35 @@ static inline int is_unrecognized_ioctl(int ret)
 		ret == -ENOIOCTLCMD;
 }
 
+#ifdef CONFIG_FS_DAX
+static int blkdev_set_dax(struct block_device *bdev, int n)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	int rc = 0;
+
+	if (n)
+		n = S_DAX;
+
+	if (n && !disk->fops->direct_access)
+		return -ENOTTY;
+
+	mutex_lock(&bdev->bd_inode->i_mutex);
+	if (bdev->bd_map_count == 0)
+		inode_set_flags(bdev->bd_inode, n, S_DAX);
+	else
+		rc = -EBUSY;
+	mutex_unlock(&bdev->bd_inode->i_mutex);
+	return rc;
+}
+#else
+static int blkdev_set_dax(struct block_device *bdev, int n)
+{
+	if (n)
+		return -ENOTTY;
+	return 0;
+}
+#endif
+
 /*
  * always keep this in sync with compat_blkdev_ioctl()
  */
@@ -449,6 +478,20 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKTRACETEARDOWN:
 		ret = blk_trace_ioctl(bdev, cmd, (char __user *) arg);
 		break;
+	case BLKDAXSET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+
+		if (get_user(n, (int __user *)(arg)))
+			return -EFAULT;
+		n = !!n;
+		if (n == !!(bdev->bd_inode->i_flags & S_DAX))
+			return 0;
+
+		return blkdev_set_dax(bdev, n);
+	case BLKDAXGET:
+		return put_int(arg, !!(bdev->bd_inode->i_flags & S_DAX));
+		break;
 	default:
 		ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 	}
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 29cd1eb0765d..13ce6d0ff7f6 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1687,13 +1687,101 @@ static const struct address_space_operations def_blk_aops = {
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
+ * Finally, unlike the filemap_page_mkwrite() case there is no
+ * filesystem superblock to sync against freezing.  We still include a
+ * pfn_mkwrite callback for dax drivers to receive write fault
+ * notifications.
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
+static void blkdev_vm_open(struct vm_area_struct *vma)
+{
+	struct inode *bd_inode = bdev_file_inode(vma->vm_file);
+	struct block_device *bdev = I_BDEV(bd_inode);
+
+	mutex_lock(&bd_inode->i_mutex);
+	bdev->bd_map_count++;
+	mutex_unlock(&bd_inode->i_mutex);
+}
+
+static void blkdev_vm_close(struct vm_area_struct *vma)
+{
+	struct inode *bd_inode = bdev_file_inode(vma->vm_file);
+	struct block_device *bdev = I_BDEV(bd_inode);
+
+	mutex_lock(&bd_inode->i_mutex);
+	bdev->bd_map_count--;
+	mutex_unlock(&bd_inode->i_mutex);
+}
+
+static const struct vm_operations_struct blkdev_dax_vm_ops = {
+	.open		= blkdev_vm_open,
+	.close		= blkdev_vm_close,
+	.fault		= blkdev_dax_fault,
+	.pmd_fault	= blkdev_dax_pmd_fault,
+	.pfn_mkwrite	= blkdev_dax_fault,
+};
+
+static const struct vm_operations_struct blkdev_default_vm_ops = {
+	.open		= blkdev_vm_open,
+	.close		= blkdev_vm_close,
+	.fault		= filemap_fault,
+	.map_pages	= filemap_map_pages,
+};
+
+static int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct inode *bd_inode = bdev_file_inode(file);
+	struct block_device *bdev = I_BDEV(bd_inode);
+
+	file_accessed(file);
+	mutex_lock(&bd_inode->i_mutex);
+	bdev->bd_map_count++;
+	if (IS_DAX(bd_inode)) {
+		vma->vm_ops = &blkdev_dax_vm_ops;
+		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+	} else {
+		vma->vm_ops = &blkdev_default_vm_ops;
+	}
+	mutex_unlock(&bd_inode->i_mutex);
+
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 72d8a844c692..8fb2d4b848bf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -482,6 +482,9 @@ struct block_device {
 	int			bd_fsfreeze_count;
 	/* Mutex for freeze */
 	struct mutex		bd_fsfreeze_mutex;
+#ifdef CONFIG_FS_DAX
+	int			bd_map_count;
+#endif
 };
 
 /*
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 9b964a5920af..cc2f0fdae707 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -152,6 +152,8 @@ struct inodes_stat_t {
 #define BLKSECDISCARD _IO(0x12,125)
 #define BLKROTATIONAL _IO(0x12,126)
 #define BLKZEROOUT _IO(0x12,127)
+#define BLKDAXSET _IO(0x12,128)
+#define BLKDAXGET _IO(0x12,129)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */

