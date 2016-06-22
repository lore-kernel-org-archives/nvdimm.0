From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 4/8] xfs: split xfs_file_read_iter into buffered and direct
 I/O helpers
Date: Wed, 22 Jun 2016 17:27:12 +0200
Message-ID: <1466609236-23801-5-git-send-email-hch@lst.de>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1466609236-23801-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Similar to what we did on the write side a while ago.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/xfs/xfs_file.c | 83 ++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 57 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 09a5a78..e584333 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -239,35 +239,33 @@ xfs_file_fsync(
 }
 
 STATIC ssize_t
-xfs_file_read_iter(
+xfs_file_dio_aio_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct file		*file = iocb->ki_filp;
-	struct inode		*inode = file->f_mapping->host;
+	struct address_space	*mapping = iocb->ki_filp->f_mapping;
+	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	size_t			size = iov_iter_count(to);
+	size_t			count = iov_iter_count(to);
+	struct xfs_buftarg	*target;
 	ssize_t			ret = 0;
-	loff_t			pos = iocb->ki_pos;
 
-	XFS_STATS_INC(mp, xs_read_calls);
+	trace_xfs_file_direct_read(ip, count, iocb->ki_pos);
 
-	if ((iocb->ki_flags & IOCB_DIRECT) && !IS_DAX(inode)) {
-		xfs_buftarg_t	*target =
-			XFS_IS_REALTIME_INODE(ip) ?
-				mp->m_rtdev_targp : mp->m_ddev_targp;
+	if (XFS_IS_REALTIME_INODE(ip))
+		target = ip->i_mount->m_rtdev_targp;
+	else
+		target = ip->i_mount->m_ddev_targp;
+
+	if (!IS_DAX(inode)) {
 		/* DIO must be aligned to device logical sector size */
-		if ((pos | size) & target->bt_logical_sectormask) {
-			if (pos == i_size_read(inode))
+		if ((iocb->ki_pos | count) & target->bt_logical_sectormask) {
+			if (iocb->ki_pos == i_size_read(inode))
 				return 0;
 			return -EINVAL;
 		}
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -EIO;
-
 	/*
 	 * Locking is a bit tricky here. If we take an exclusive lock for direct
 	 * IO, we effectively serialise all new concurrent read IO to this file
@@ -279,7 +277,7 @@ xfs_file_read_iter(
 	 * serialisation.
 	 */
 	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
-	if ((iocb->ki_flags & IOCB_DIRECT) && inode->i_mapping->nrpages) {
+	if (mapping->nrpages) {
 		xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
 
@@ -294,8 +292,8 @@ xfs_file_read_iter(
 		 * flush and reduce the chances of repeated iolock cycles going
 		 * forward.
 		 */
-		if (inode->i_mapping->nrpages) {
-			ret = filemap_write_and_wait(VFS_I(ip)->i_mapping);
+		if (mapping->nrpages) {
+			ret = filemap_write_and_wait(mapping);
 			if (ret) {
 				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
 				return ret;
@@ -306,23 +304,56 @@ xfs_file_read_iter(
 			 * we fail to invalidate a page, but this should never
 			 * happen on XFS. Warn if it does fail.
 			 */
-			ret = invalidate_inode_pages2(VFS_I(ip)->i_mapping);
+			ret = invalidate_inode_pages2(mapping);
 			WARN_ON_ONCE(ret);
 			ret = 0;
 		}
 		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
 	}
 
+	ret = generic_file_read_iter(iocb, to);
+	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
+
+	return ret;
+}
+
+STATIC ssize_t
+xfs_file_buffered_aio_read(
+	struct kiocb		*iocb,
+	struct iov_iter		*to)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
+	ssize_t			ret;
+
+	trace_xfs_file_buffered_read(ip, iov_iter_count(to), iocb->ki_pos);
+
+	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	ret = generic_file_read_iter(iocb, to);
+	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
+
+	return ret;
+}
+
+STATIC ssize_t
+xfs_file_read_iter(
+	struct kiocb		*iocb,
+	struct iov_iter		*to)
+{
+	struct xfs_mount	*mp = XFS_I(file_inode(iocb->ki_filp))->i_mount;
+	ssize_t			ret = 0;
+
+	XFS_STATS_INC(mp, xs_read_calls);
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
 	if (iocb->ki_flags & IOCB_DIRECT)
-		trace_xfs_file_direct_read(ip, size, pos);
+		ret = xfs_file_dio_aio_read(iocb, to);
 	else
-		trace_xfs_file_buffered_read(ip, size, pos);
+		ret = xfs_file_buffered_aio_read(iocb, to);
 
-	ret = generic_file_read_iter(iocb, to);
 	if (ret > 0)
 		XFS_STATS_ADD(mp, xs_read_bytes, ret);
-
-	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 	return ret;
 }
 
@@ -578,7 +609,7 @@ xfs_file_dio_aio_write(
 	end = iocb->ki_pos + count - 1;
 
 	/*
-	 * See xfs_file_read_iter() for why we do a full-file flush here.
+	 * See xfs_file_dio_aio_read() for why we do a full-file flush here.
 	 */
 	if (mapping->nrpages) {
 		ret = filemap_write_and_wait(VFS_I(ip)->i_mapping);
-- 
2.1.4
