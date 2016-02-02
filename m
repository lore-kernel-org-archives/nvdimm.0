Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] dax: allow DAX to look up an inode's block device
Date: Tue,  2 Feb 2016 16:11:42 -0700
Message-Id: <1454454702-11889-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Jeff Layton <jlayton@poochiereds.net>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, xfs@oss.sgi.com
List-ID: <linux-nvdimm@lists.01.org>

There are a number of places in dax.c that look up the struct block_device
associated with an inode.  Previously this was done by just using
inode->i_sb->s_bdev.  This is correct in some cases, such as when using
ext2 and ext4.

However, for raw block devices and for XFS with a real-time device, the
value in inode->i_sb->s_bdev is not correct.  With the code as it is
currently written, an fsync or msync to a DAX enabled raw block device will
cause a NULL pointer dereference kernel BUG.  For this to work correctly we
need to ask the block device or filesystem what struct block_device is
appropriate for our inode.

To that end, add a get_bdev(struct inode *) entry point to struct
super_operations.  If this function pointer is non-NULL, this notifies DAX
that it needs to use it to look up the correct block_device.  If
i_sb->get_bdev() is NULL DAX will default to inode->i_sb->s_bdev.

I added the function to super_operations instead of another alternative
like inode_operations because the function pointer varies by filesystem or
block device, not per inode.  I believe that this will also save memory
because there is only one struct super_operations per mounted filesystem
but there could be many struct inode_operations and there is no need to
keep many copies of the same function pointer in memory.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/block_dev.c     |  6 ++++++
 fs/dax.c           | 20 ++++++++++++++------
 fs/xfs/xfs_aops.c  |  2 +-
 fs/xfs/xfs_aops.h  |  1 +
 fs/xfs/xfs_super.c |  1 +
 include/linux/fs.h |  1 +
 6 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index fa0507a..845b049 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -156,6 +156,11 @@ blkdev_get_block(struct inode *inode, sector_t iblock,
 	return 0;
 }
 
+static struct block_device *blkdev_get_bdev(struct inode *inode)
+{
+	return I_BDEV(inode);
+}
+
 static struct inode *bdev_file_inode(struct file *file)
 {
 	return file->f_mapping->host;
@@ -569,6 +574,7 @@ static const struct super_operations bdev_sops = {
 	.alloc_inode = bdev_alloc_inode,
 	.destroy_inode = bdev_destroy_inode,
 	.drop_inode = generic_delete_inode,
+	.get_bdev = blkdev_get_bdev,
 	.evict_inode = bdev_evict_inode,
 };
 
diff --git a/fs/dax.c b/fs/dax.c
index 227974a..c701ea4 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -32,6 +32,14 @@
 #include <linux/pfn_t.h>
 #include <linux/sizes.h>
 
+static struct block_device *dax_get_bdev(struct inode *inode)
+{
+	if (inode->i_sb->s_op->get_bdev)
+		return inode->i_sb->s_op->get_bdev(inode);
+	else
+		return inode->i_sb->s_bdev;
+}
+
 static long dax_map_atomic(struct block_device *bdev, struct blk_dax_ctl *dax)
 {
 	struct request_queue *q = bdev->bd_queue;
@@ -85,7 +93,7 @@ struct page *read_dax_sector(struct block_device *bdev, sector_t n)
  */
 int dax_clear_blocks(struct inode *inode, sector_t block, long _size)
 {
-	struct block_device *bdev = inode->i_sb->s_bdev;
+	struct block_device *bdev = dax_get_bdev(inode);
 	struct blk_dax_ctl dax = {
 		.sector = block << (inode->i_blkbits - 9),
 		.size = _size,
@@ -266,7 +274,7 @@ ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
 	loff_t end = pos + iov_iter_count(iter);
 
 	memset(&bh, 0, sizeof(bh));
-	bh.b_bdev = inode->i_sb->s_bdev;
+	bh.b_bdev = dax_get_bdev(inode);
 
 	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ) {
 		struct address_space *mapping = inode->i_mapping;
@@ -488,7 +496,7 @@ int dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
 		loff_t end)
 {
 	struct inode *inode = mapping->host;
-	struct block_device *bdev = inode->i_sb->s_bdev;
+	struct block_device *bdev = dax_get_bdev(inode);
 	pgoff_t start_index, end_index, pmd_index;
 	pgoff_t indices[PAGEVEC_SIZE];
 	struct pagevec pvec;
@@ -628,7 +636,7 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 
 	memset(&bh, 0, sizeof(bh));
 	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
-	bh.b_bdev = inode->i_sb->s_bdev;
+	bh.b_bdev = dax_get_bdev(inode);
 	bh.b_size = PAGE_SIZE;
 
  repeat:
@@ -847,7 +855,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	}
 
 	memset(&bh, 0, sizeof(bh));
-	bh.b_bdev = inode->i_sb->s_bdev;
+	bh.b_bdev = dax_get_bdev(inode);
 	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PMD_SIZE;
@@ -1100,7 +1108,7 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
 	BUG_ON((offset + length) > PAGE_CACHE_SIZE);
 
 	memset(&bh, 0, sizeof(bh));
-	bh.b_bdev = inode->i_sb->s_bdev;
+	bh.b_bdev = dax_get_bdev(inode);
 	bh.b_size = PAGE_CACHE_SIZE;
 	err = get_block(inode, index, &bh, 0);
 	if (err < 0)
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 379c089..fc20518 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -55,7 +55,7 @@ xfs_count_page_state(
 	} while ((bh = bh->b_this_page) != head);
 }
 
-STATIC struct block_device *
+struct block_device *
 xfs_find_bdev_for_inode(
 	struct inode		*inode)
 {
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index f6ffc9a..a4343c6 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -62,5 +62,6 @@ int	xfs_get_blocks_dax_fault(struct inode *inode, sector_t offset,
 			         struct buffer_head *map_bh, int create);
 
 extern void xfs_count_page_state(struct page *, int *, int *);
+extern struct block_device *xfs_find_bdev_for_inode(struct inode *);
 
 #endif /* __XFS_AOPS_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 59c9b7b..26e7051 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1623,6 +1623,7 @@ static const struct super_operations xfs_super_operations = {
 	.destroy_inode		= xfs_fs_destroy_inode,
 	.evict_inode		= xfs_fs_evict_inode,
 	.drop_inode		= xfs_fs_drop_inode,
+	.get_bdev		= xfs_find_bdev_for_inode,
 	.put_super		= xfs_fs_put_super,
 	.sync_fs		= xfs_fs_sync_fs,
 	.freeze_fs		= xfs_fs_freeze,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b10002d..5b636eb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1730,6 +1730,7 @@ struct super_operations {
 	int (*write_inode) (struct inode *, struct writeback_control *wbc);
 	int (*drop_inode) (struct inode *);
 	void (*evict_inode) (struct inode *);
+	struct block_device *(*get_bdev) (struct inode *);
 	void (*put_super) (struct super_block *);
 	int (*sync_fs)(struct super_block *sb, int wait);
 	int (*freeze_super) (struct super_block *);
-- 
2.5.0

