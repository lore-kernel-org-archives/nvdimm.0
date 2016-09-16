From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/12] xfs: refactor xfs_setfilesize
Date: Fri, 16 Sep 2016 13:27:11 +0200
Message-ID: <1474025234-13804-10-git-send-email-hch@lst.de>
References: <1474025234-13804-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1474025234-13804-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
Cc: ross.zwisler@linux.intel.com
List-Id: linux-nvdimm@lists.01.org

Rename the current function to __xfs_setfilesize and add a non-static
wrapper that also takes care of creating the transaction.  This new
helper will be used by the new iomap-based DAX path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 31 +++++++++++++++++++++----------
 fs/xfs/xfs_aops.h |  1 +
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 7575cfc..4a28fa9 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -200,7 +200,7 @@ xfs_setfilesize_trans_alloc(
  * Update on-disk file size now that data has been written to disk.
  */
 STATIC int
-xfs_setfilesize(
+__xfs_setfilesize(
 	struct xfs_inode	*ip,
 	struct xfs_trans	*tp,
 	xfs_off_t		offset,
@@ -225,6 +225,23 @@ xfs_setfilesize(
 	return xfs_trans_commit(tp);
 }
 
+int
+xfs_setfilesize(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	size_t			size)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
+	return __xfs_setfilesize(ip, tp, offset, size);
+}
+
 STATIC int
 xfs_setfilesize_ioend(
 	struct xfs_ioend	*ioend,
@@ -247,7 +264,7 @@ xfs_setfilesize_ioend(
 		return error;
 	}
 
-	return xfs_setfilesize(ip, tp, ioend->io_offset, ioend->io_size);
+	return __xfs_setfilesize(ip, tp, ioend->io_offset, ioend->io_size);
 }
 
 /*
@@ -1336,13 +1353,12 @@ xfs_end_io_direct_write(
 {
 	struct inode		*inode = file_inode(iocb->ki_filp);
 	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
 	uintptr_t		flags = (uintptr_t)private;
 	int			error = 0;
 
 	trace_xfs_end_io_direct_write(ip, offset, size);
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
 	if (size <= 0)
@@ -1380,14 +1396,9 @@ xfs_end_io_direct_write(
 
 		error = xfs_iomap_write_unwritten(ip, offset, size);
 	} else if (flags & XFS_DIO_FLAG_APPEND) {
-		struct xfs_trans *tp;
-
 		trace_xfs_end_io_direct_write_append(ip, offset, size);
 
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0,
-				&tp);
-		if (!error)
-			error = xfs_setfilesize(ip, tp, offset, size);
+		error = xfs_setfilesize(ip, offset, size);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index bf2d9a1..1950e3b 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -62,6 +62,7 @@ int	xfs_get_blocks_dax_fault(struct inode *inode, sector_t offset,
 
 int	xfs_end_io_direct_write(struct kiocb *iocb, loff_t offset,
 		ssize_t size, void *private);
+int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
 
 extern void xfs_count_page_state(struct page *, int *, int *);
 extern struct block_device *xfs_find_bdev_for_inode(struct inode *);
-- 
2.1.4

