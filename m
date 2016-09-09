From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/10] xfs: use iomap to implement DAX
Date: Fri,  9 Sep 2016 18:34:44 +0200
Message-ID: <1473438884-674-11-git-send-email-hch@lst.de>
References: <1473438884-674-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1473438884-674-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

Another users of buffer_heads bytes the dust.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c  | 44 +++++++++++++++++++-------------------------
 fs/xfs/xfs_iomap.c | 11 +++++++----
 2 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 62649cc..b5aef20 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -332,10 +332,7 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct address_space	*mapping = iocb->ki_filp->f_mapping;
-	struct inode		*inode = mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct iov_iter		data = *to;
+	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
 	size_t			count = iov_iter_count(to);
 	ssize_t			ret = 0;
 
@@ -345,11 +342,7 @@ xfs_file_dax_read(
 		return 0; /* skip atime */
 
 	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
-	ret = dax_do_io(iocb, inode, &data, xfs_get_blocks_direct, NULL, 0);
-	if (ret > 0) {
-		iocb->ki_pos += ret;
-		iov_iter_advance(to, ret);
-	}
+	ret = iomap_dax_rw(iocb, to, &xfs_iomap_ops);
 	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	file_accessed(iocb->ki_filp);
@@ -714,15 +707,19 @@ xfs_file_dax_write(
 	struct address_space	*mapping = iocb->ki_filp->f_mapping;
 	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
-	ssize_t			ret = 0;
 	int			iolock = XFS_IOLOCK_EXCL;
-	struct iov_iter		data;
+	ssize_t			ret, error = 0;
+	size_t			count;
+	loff_t			pos;
 
 	xfs_rw_ilock(ip, iolock);
 	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
 	if (ret)
 		goto out;
 
+	pos = iocb->ki_pos;
+	count = iov_iter_count(from);
+
 	/*
 	 * Yes, even DAX files can have page cache attached to them:  A zeroed
 	 * page is inserted into the pagecache when we have to serve a write
@@ -737,26 +734,23 @@ xfs_file_dax_write(
 	 * dax_do_io() is fixed up.
 	 */
 	if (mapping->nrpages) {
-		loff_t end = iocb->ki_pos + iov_iter_count(from) - 1;
-
 		ret = invalidate_inode_pages2_range(mapping,
-						    iocb->ki_pos >> PAGE_SHIFT,
-						    end >> PAGE_SHIFT);
+				pos >> PAGE_SHIFT,
+				(pos + count - 1) >> PAGE_SHIFT);
 		WARN_ON_ONCE(ret);
 	}
 
-	trace_xfs_file_dax_write(ip, iov_iter_count(from), iocb->ki_pos);
+	trace_xfs_file_dax_write(ip, count, pos);
 
-	data = *from;
-	ret = dax_do_io(iocb, inode, &data, xfs_get_blocks_direct,
-			xfs_end_io_direct_write, 0);
-	if (ret > 0) {
-		iocb->ki_pos += ret;
-		iov_iter_advance(from, ret);
+	ret = iomap_dax_rw(iocb, from, &xfs_iomap_ops);
+	if (ret > 0 && iocb->ki_pos > i_size_read(inode)) {
+		i_size_write(inode, iocb->ki_pos);
+		error = xfs_setfilesize(ip, pos, count);
 	}
+
 out:
 	xfs_rw_iunlock(ip, iolock);
-	return ret;
+	return error ? error : ret;
 }
 
 STATIC ssize_t
@@ -1495,7 +1489,7 @@ xfs_filemap_page_mkwrite(
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
 	if (IS_DAX(inode)) {
-		ret = dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault);
+		ret = iomap_dax_fault(vma, vmf, &xfs_iomap_ops);
 	} else {
 		ret = iomap_page_mkwrite(vma, vmf, &xfs_iomap_ops);
 		ret = block_page_mkwrite_return(ret);
@@ -1529,7 +1523,7 @@ xfs_filemap_fault(
 		 * changes to xfs_get_blocks_direct() to map unwritten extent
 		 * ioend for conversion on read-only mappings.
 		 */
-		ret = dax_fault(vma, vmf, xfs_get_blocks_dax_fault);
+		ret = iomap_dax_fault(vma, vmf, &xfs_iomap_ops);
 	} else
 		ret = filemap_fault(vma, vmf);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c3cc175..23f7811 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -935,11 +935,13 @@ error_on_bmapi_transaction:
 	return error;
 }
 
-static inline bool imap_needs_alloc(struct xfs_bmbt_irec *imap, int nimaps)
+static inline bool imap_needs_alloc(struct inode *inode,
+		struct xfs_bmbt_irec *imap, int nimaps)
 {
 	return !nimaps ||
 		imap->br_startblock == HOLESTARTBLOCK ||
-		imap->br_startblock == DELAYSTARTBLOCK;
+		imap->br_startblock == DELAYSTARTBLOCK ||
+		(IS_DAX(inode) && ISUNWRITTEN(imap));
 }
 
 static int
@@ -960,7 +962,8 @@ xfs_file_iomap_begin(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	if ((flags & IOMAP_WRITE) && !xfs_get_extsz_hint(ip)) {
+	if ((flags & IOMAP_WRITE) &&
+	    !IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
 		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
 				iomap);
 	}
@@ -980,7 +983,7 @@ xfs_file_iomap_begin(
 		return error;
 	}
 
-	if ((flags & IOMAP_WRITE) && imap_needs_alloc(&imap, nimaps)) {
+	if ((flags & IOMAP_WRITE) && imap_needs_alloc(inode, &imap, nimaps)) {
 		/*
 		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
 		 * pages to keep the chunks of work done where somewhat symmetric
-- 
2.1.4

