Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 4/5] block: introduce bdev_file_inode()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Oct 2015 13:10:38 -0400
Message-ID: <20151022171038.38343.65589.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20151022171015.38343.72043.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151022171015.38343.72043.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, ross.zwisler@linux.intel.com, willy@linux.intel.com, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Similar to the file_inode() helper, provide a helper to lookup the inode for a
raw block device itself.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/block_dev.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 0a793c7930eb..c1f691859a56 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -147,11 +147,16 @@ blkdev_get_block(struct inode *inode, sector_t iblock,
 	return 0;
 }
 
+static struct inode *bdev_file_inode(struct file *file)
+{
+	return file->f_mapping->host;
+}
+
 static ssize_t
 blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = bdev_file_inode(file);
 
 	if (IS_DAX(inode))
 		return dax_do_io(iocb, inode, iter, offset, blkdev_get_block,
@@ -329,7 +334,7 @@ static int blkdev_write_end(struct file *file, struct address_space *mapping,
  */
 static loff_t block_llseek(struct file *file, loff_t offset, int whence)
 {
-	struct inode *bd_inode = file->f_mapping->host;
+	struct inode *bd_inode = bdev_file_inode(file);
 	loff_t retval;
 
 	mutex_lock(&bd_inode->i_mutex);
@@ -340,7 +345,7 @@ static loff_t block_llseek(struct file *file, loff_t offset, int whence)
 	
 int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 {
-	struct inode *bd_inode = filp->f_mapping->host;
+	struct inode *bd_inode = bdev_file_inode(filp);
 	struct block_device *bdev = I_BDEV(bd_inode);
 	int error;
 	
@@ -1579,14 +1584,14 @@ EXPORT_SYMBOL(blkdev_put);
 
 static int blkdev_close(struct inode * inode, struct file * filp)
 {
-	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
+	struct block_device *bdev = I_BDEV(bdev_file_inode(filp));
 	blkdev_put(bdev, filp->f_mode);
 	return 0;
 }
 
 static long block_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 {
-	struct block_device *bdev = I_BDEV(file->f_mapping->host);
+	struct block_device *bdev = I_BDEV(bdev_file_inode(file));
 	fmode_t mode = file->f_mode;
 
 	/*
@@ -1611,7 +1616,7 @@ static long block_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
-	struct inode *bd_inode = file->f_mapping->host;
+	struct inode *bd_inode = bdev_file_inode(file);
 	loff_t size = i_size_read(bd_inode);
 	struct blk_plug plug;
 	ssize_t ret;
@@ -1643,7 +1648,7 @@ EXPORT_SYMBOL_GPL(blkdev_write_iter);
 ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
-	struct inode *bd_inode = file->f_mapping->host;
+	struct inode *bd_inode = bdev_file_inode(file);
 	loff_t size = i_size_read(bd_inode);
 	loff_t pos = iocb->ki_pos;
 

