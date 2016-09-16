From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 10/12] xfs: use iomap to implement DAX
Date: Fri, 16 Sep 2016 13:27:12 +0200
Message-ID: <1474025234-13804-11-git-send-email-hch@lst.de>
References: <1474025234-13804-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1474025234-13804-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Another users of buffer_heads bytes the dust.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 fs/xfs/xfs_file.c  | 61 +++++++++++++++---------------------------------------
 fs/xfs/xfs_iomap.c | 11 ++++++----
 2 files changed, 24 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 62649cc..f99d7fa 100644
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
@@ -711,52 +704,32 @@ xfs_file_dax_write(
 	struct kiocb		*iocb,
 	struct iov_iter		*from)
 {
-	struct address_space	*mapping = iocb->ki_filp->f_mapping;
-	struct inode		*inode = mapping->host;
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
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
 
-	/*
-	 * Yes, even DAX files can have page cache attached to them:  A zeroed
-	 * page is inserted into the pagecache when we have to serve a write
-	 * fault on a hole.  It should never be dirtied and can simply be
-	 * dropped from the pagecache once we get real data for the page.
-	 *
-	 * XXX: This is racy against mmap, and there's nothing we can do about
-	 * it. dax_do_io() should really do this invalidation internally as
-	 * it will know if we've allocated over a holei for this specific IO and
-	 * if so it needs to update the mapping tree and invalidate existing
-	 * PTEs over the newly allocated range. Remove this invalidation when
-	 * dax_do_io() is fixed up.
-	 */
-	if (mapping->nrpages) {
-		loff_t end = iocb->ki_pos + iov_iter_count(from) - 1;
-
-		ret = invalidate_inode_pages2_range(mapping,
-						    iocb->ki_pos >> PAGE_SHIFT,
-						    end >> PAGE_SHIFT);
-		WARN_ON_ONCE(ret);
-	}
+	pos = iocb->ki_pos;
+	count = iov_iter_count(from);
 
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
+		error = xfs_setfilesize(ip, pos, ret);
 	}
+
 out:
 	xfs_rw_iunlock(ip, iolock);
-	return ret;
+	return error ? error : ret;
 }
 
 STATIC ssize_t
@@ -1495,7 +1468,7 @@ xfs_filemap_page_mkwrite(
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
 	if (IS_DAX(inode)) {
-		ret = dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault);
+		ret = iomap_dax_fault(vma, vmf, &xfs_iomap_ops);
 	} else {
 		ret = iomap_page_mkwrite(vma, vmf, &xfs_iomap_ops);
 		ret = block_page_mkwrite_return(ret);
@@ -1529,7 +1502,7 @@ xfs_filemap_fault(
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
