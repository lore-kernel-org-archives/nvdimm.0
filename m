Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/2] dax: fix bdev NULL pointer dereferences
Date: Thu, 28 Jan 2016 12:35:04 -0700
Message-Id: <1454009704-25959-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1454009704-25959-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1454009704-25959-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

There are a number of places in dax.c that look up the struct block_device
associated with an inode.  Previously this was done by just using
inode->i_sb->s_bdev.  This is correct for inodes that exist within the
filesystems supported by DAX (ext2, ext4 & XFS), but when running DAX
against raw block devices this value is NULL.  This causes NULL pointer
dereferences when these block_device pointers are used.

Instead, for raw block devices we need to look up the struct block_device
using I_BDEV().  This patch fixes all the block_device lookups in dax.c so
that they work properly for both filesystems and raw block devices.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4fd6b0c..e60a5a7 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -32,6 +32,9 @@
 #include <linux/pfn_t.h>
 #include <linux/sizes.h>
 
+#define DAX_BDEV(inode) (S_ISBLK(inode->i_mode) ? I_BDEV(inode) \
+				: inode->i_sb->s_bdev)
+
 static long dax_map_atomic(struct block_device *bdev, struct blk_dax_ctl *dax)
 {
 	struct request_queue *q = bdev->bd_queue;
@@ -65,7 +68,7 @@ static void dax_unmap_atomic(struct block_device *bdev,
  */
 int dax_clear_blocks(struct inode *inode, sector_t block, long _size)
 {
-	struct block_device *bdev = inode->i_sb->s_bdev;
+	struct block_device *bdev = DAX_BDEV(inode);
 	struct blk_dax_ctl dax = {
 		.sector = block << (inode->i_blkbits - 9),
 		.size = _size,
@@ -246,7 +249,7 @@ ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
 	loff_t end = pos + iov_iter_count(iter);
 
 	memset(&bh, 0, sizeof(bh));
-	bh.b_bdev = inode->i_sb->s_bdev;
+	bh.b_bdev = DAX_BDEV(inode);
 
 	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ) {
 		struct address_space *mapping = inode->i_mapping;
@@ -468,7 +471,7 @@ int dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
 		loff_t end)
 {
 	struct inode *inode = mapping->host;
-	struct block_device *bdev = inode->i_sb->s_bdev;
+	struct block_device *bdev = DAX_BDEV(inode);
 	pgoff_t start_index, end_index, pmd_index;
 	pgoff_t indices[PAGEVEC_SIZE];
 	struct pagevec pvec;
@@ -608,7 +611,7 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 
 	memset(&bh, 0, sizeof(bh));
 	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
-	bh.b_bdev = inode->i_sb->s_bdev;
+	bh.b_bdev = DAX_BDEV(inode);
 	bh.b_size = PAGE_SIZE;
 
  repeat:
@@ -827,7 +830,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	}
 
 	memset(&bh, 0, sizeof(bh));
-	bh.b_bdev = inode->i_sb->s_bdev;
+	bh.b_bdev = DAX_BDEV(inode);
 	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PMD_SIZE;
@@ -1080,7 +1083,7 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
 	BUG_ON((offset + length) > PAGE_CACHE_SIZE);
 
 	memset(&bh, 0, sizeof(bh));
-	bh.b_bdev = inode->i_sb->s_bdev;
+	bh.b_bdev = DAX_BDEV(inode);
 	bh.b_size = PAGE_CACHE_SIZE;
 	err = get_block(inode, index, &bh, 0);
 	if (err < 0)
-- 
2.5.0
