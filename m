Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 567771A1F01
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 16:18:32 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 5/5] dax: handle media errors in dax_do_io
Date: Thu, 24 Mar 2016 17:17:30 -0600
Message-Id: <1458861450-17705-6-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
References: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-nvdimm@lists.01.org>

dax_do_io (called for read() or write() for a dax file system) may fail
in the presence of bad blocks or media errors. Since we expect that a
write should clear media errors on nvdimms, make dax_do_io fall back to
the direct_IO path, which will send down a bio to the driver, which can
then attempt to clear the error.

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 fs/block_dev.c      |  5 +++--
 fs/dax.c            | 34 ++++++++++++++++++++++++++++++++--
 fs/ext2/inode.c     |  5 +++--
 fs/ext4/indirect.c  | 11 +++++++----
 fs/ext4/inode.c     |  5 +++--
 fs/xfs/xfs_aops.c   |  7 ++++---
 include/linux/dax.h |  6 +++++-
 7 files changed, 57 insertions(+), 16 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9c0765b..f3873ab 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -168,8 +168,9 @@ blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 	struct inode *inode = bdev_file_inode(file);
 
 	if (IS_DAX(inode))
-		return dax_do_io(iocb, inode, iter, offset, blkdev_get_block,
-				NULL, DIO_SKIP_DIO_COUNT);
+		return dax_do_io(iocb, inode, I_BDEV(inode), iter, offset,
+				blkdev_get_block, blkdev_get_block,
+				NULL, NULL, DIO_SKIP_DIO_COUNT);
 	return __blockdev_direct_IO(iocb, inode, I_BDEV(inode), iter, offset,
 				    blkdev_get_block, NULL, NULL,
 				    DIO_SKIP_DIO_COUNT);
diff --git a/fs/dax.c b/fs/dax.c
index a30481e..b90c8e9 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -208,7 +208,7 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 }
 
 /**
- * dax_do_io - Perform I/O to a DAX file
+ * __dax_do_io - Perform I/O to a DAX file
  * @iocb: The control block for this I/O
  * @inode: The file which the I/O is directed at
  * @iter: The addresses to do I/O from or to
@@ -224,7 +224,7 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
  * As with do_blockdev_direct_IO(), we increment i_dio_count while the I/O
  * is in progress.
  */
-ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
+ssize_t __dax_do_io(struct kiocb *iocb, struct inode *inode,
 		  struct iov_iter *iter, loff_t pos, get_block_t get_block,
 		  dio_iodone_t end_io, int flags)
 {
@@ -262,8 +262,38 @@ ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
  out:
 	return retval;
 }
+EXPORT_SYMBOL_GPL(__dax_do_io);
+
+/*
+ * This is a library function for use by file systems. It will perform a
+ * fallback to direct_io semantics if the dax_io fails due to a media error.
+ */
+ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
+		  struct block_device *bdev, struct iov_iter *iter, loff_t pos,
+		  get_block_t dax_get_block, get_block_t dio_get_block,
+		  dio_iodone_t end_io, dio_submit_t submit_io, int flags)
+{
+	ssize_t retval;
+
+	retval = __dax_do_io(iocb, inode, iter, pos, dax_get_block, end_io,
+				flags);
+	if (iov_iter_rw(iter) == WRITE && retval == -EIO) {
+		/*
+		 * __dax_do_io may have failed a write due to a bad block.
+		 * Retry with direct_io, and if the direct_IO also fails,
+		 * return -EIO as that was the original error that led us
+		 * down the direct_IO path.
+		 */
+		retval = __blockdev_direct_IO(iocb, inode, bdev, iter, pos,
+				dio_get_block, end_io, submit_io, flags);
+		if (retval < 0)
+			return -EIO;
+	}
+	return retval;
+}
 EXPORT_SYMBOL_GPL(dax_do_io);
 
+
 /*
  * The user has performed a load from a hole in the file.  Allocating
  * a new page in the file would cause excessive storage usage for
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 824f249..8a307cf 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -862,8 +862,9 @@ ext2_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 	ssize_t ret;
 
 	if (IS_DAX(inode))
-		ret = dax_do_io(iocb, inode, iter, offset, ext2_get_block, NULL,
-				DIO_LOCKING);
+		ret = dax_do_io(iocb, inode, inode->i_sb->s_bdev, iter,
+				offset, ext2_get_block, ext2_get_block,
+				NULL, NULL, DIO_LOCKING | DIO_SKIP_HOLES);
 	else
 		ret = blockdev_direct_IO(iocb, inode, iter, offset,
 					 ext2_get_block);
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 355ef9c..4b087b7 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -692,8 +692,9 @@ retry:
 			goto locked;
 		}
 		if (IS_DAX(inode))
-			ret = dax_do_io(iocb, inode, iter, offset,
-					ext4_get_block, NULL, 0);
+			ret = dax_do_io(iocb, inode, inode->i_sb->s_bdev, iter,
+					offset, ext4_get_block, ext4_get_block,
+					NULL, NULL, 0);
 		else
 			ret = __blockdev_direct_IO(iocb, inode,
 						   inode->i_sb->s_bdev, iter,
@@ -703,8 +704,10 @@ retry:
 	} else {
 locked:
 		if (IS_DAX(inode))
-			ret = dax_do_io(iocb, inode, iter, offset,
-					ext4_get_block, NULL, DIO_LOCKING);
+			ret = dax_do_io(iocb, inode, inode->i_sb->s_bdev, iter,
+					offset, ext4_get_block, ext4_get_block,
+					NULL, NULL, DIO_LOCKING |
+					DIO_SKIP_HOLES);
 		else
 			ret = blockdev_direct_IO(iocb, inode, iter, offset,
 						 ext4_get_block);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index aee960b..4220dac 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3315,8 +3315,9 @@ static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	BUG_ON(ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode));
 #endif
 	if (IS_DAX(inode))
-		ret = dax_do_io(iocb, inode, iter, offset, get_block_func,
-				ext4_end_io_dio, dio_flags);
+		ret = dax_do_io(iocb, inode, inode->i_sb->s_bdev, iter, offset,
+				get_block_func, get_block_func,
+				ext4_end_io_dio, NULL, dio_flags);
 	else
 		ret = __blockdev_direct_IO(iocb, inode,
 					   inode->i_sb->s_bdev, iter, offset,
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a9ebabfe..dc4e088 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1682,11 +1682,12 @@ xfs_vm_do_dio(
 					 void		*private),
 	int			flags)
 {
-	struct block_device	*bdev;
+	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
 
 	if (IS_DAX(inode))
-		return dax_do_io(iocb, inode, iter, offset,
-				 xfs_get_blocks_direct, endio, 0);
+		return dax_do_io(iocb, inode, bdev, iter, offset,
+				 xfs_get_blocks_direct, xfs_get_blocks_direct,
+				 endio, NULL, flags);
 
 	bdev = xfs_find_bdev_for_inode(inode);
 	return  __blockdev_direct_IO(iocb, inode, bdev, iter, offset,
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 933198a..6981076 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -5,8 +5,12 @@
 #include <linux/mm.h>
 #include <asm/pgtable.h>
 
-ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *, loff_t,
+ssize_t __dax_do_io(struct kiocb *, struct inode *, struct iov_iter *, loff_t,
 		  get_block_t, dio_iodone_t, int flags);
+ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
+		  struct block_device *bdev, struct iov_iter *iter, loff_t pos,
+		  get_block_t dax_get_block, get_block_t dio_get_block,
+		  dio_iodone_t end_io, dio_submit_t submit_io, int flags);
 int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
 int dax_truncate_page(struct inode *, loff_t from, get_block_t);
 int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
