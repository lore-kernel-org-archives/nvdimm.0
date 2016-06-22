From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 2/8] xfs: kill ioflags
Date: Wed, 22 Jun 2016 17:27:10 +0200
Message-ID: <1466609236-23801-3-git-send-email-hch@lst.de>
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

Now that we have the direct I/O kiocb flag there is no real need to sample
the value inside of XFS, and the invis flag was always just partially used
and isn't worth keeping this infrastructure around for.   This also splits
the read tracepoint into buffered vs direct as we've done for writes a long
time ago.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/xfs/xfs_file.c  | 26 +++++++++-----------------
 fs/xfs/xfs_inode.h | 10 ----------
 fs/xfs/xfs_trace.h | 19 ++++++++-----------
 3 files changed, 17 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 713991c..b32e6b0 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -249,18 +249,12 @@ xfs_file_read_iter(
 	struct xfs_mount	*mp = ip->i_mount;
 	size_t			size = iov_iter_count(to);
 	ssize_t			ret = 0;
-	int			ioflags = 0;
 	xfs_fsize_t		n;
 	loff_t			pos = iocb->ki_pos;
 
 	XFS_STATS_INC(mp, xs_read_calls);
 
-	if (unlikely(iocb->ki_flags & IOCB_DIRECT))
-		ioflags |= XFS_IO_ISDIRECT;
-	if (file->f_mode & FMODE_NOCMTIME)
-		ioflags |= XFS_IO_INVIS;
-
-	if ((ioflags & XFS_IO_ISDIRECT) && !IS_DAX(inode)) {
+	if ((iocb->ki_flags & IOCB_DIRECT) && !IS_DAX(inode)) {
 		xfs_buftarg_t	*target =
 			XFS_IS_REALTIME_INODE(ip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp;
@@ -293,7 +287,7 @@ xfs_file_read_iter(
 	 * serialisation.
 	 */
 	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
-	if ((ioflags & XFS_IO_ISDIRECT) && inode->i_mapping->nrpages) {
+	if ((iocb->ki_flags & IOCB_DIRECT) && inode->i_mapping->nrpages) {
 		xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
 
@@ -327,7 +321,10 @@ xfs_file_read_iter(
 		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
 	}
 
-	trace_xfs_file_read(ip, size, pos, ioflags);
+	if (iocb->ki_flags & IOCB_DIRECT)
+		trace_xfs_file_direct_read(ip, size, pos);
+	else
+		trace_xfs_file_buffered_read(ip, size, pos);
 
 	ret = generic_file_read_iter(iocb, to);
 	if (ret > 0)
@@ -346,18 +343,14 @@ xfs_file_splice_read(
 	unsigned int		flags)
 {
 	struct xfs_inode	*ip = XFS_I(infilp->f_mapping->host);
-	int			ioflags = 0;
 	ssize_t			ret;
 
 	XFS_STATS_INC(ip->i_mount, xs_read_calls);
 
-	if (infilp->f_mode & FMODE_NOCMTIME)
-		ioflags |= XFS_IO_INVIS;
-
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	trace_xfs_file_splice_read(ip, count, *ppos, ioflags);
+	trace_xfs_file_splice_read(ip, count, *ppos);
 
 	/*
 	 * DAX inodes cannot ues the page cache for splice, so we have to push
@@ -620,7 +613,7 @@ xfs_file_dio_aio_write(
 		iolock = XFS_IOLOCK_SHARED;
 	}
 
-	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
+	trace_xfs_file_direct_write(ip, count, iocb->ki_pos);
 
 	data = *from;
 	ret = mapping->a_ops->direct_IO(iocb, &data);
@@ -670,8 +663,7 @@ xfs_file_buffered_aio_write(
 	current->backing_dev_info = inode_to_bdi(inode);
 
 write_retry:
-	trace_xfs_file_buffered_write(ip, iov_iter_count(from),
-				      iocb->ki_pos, 0);
+	trace_xfs_file_buffered_write(ip, iov_iter_count(from), iocb->ki_pos);
 	ret = iomap_file_buffered_write(iocb, from, &xfs_iomap_ops);
 	if (likely(ret >= 0))
 		iocb->ki_pos += ret;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0c19d3d..8eb78ec 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -473,14 +473,4 @@ do { \
 
 extern struct kmem_zone	*xfs_inode_zone;
 
-/*
- * Flags for read/write calls
- */
-#define XFS_IO_ISDIRECT	0x00001		/* bypass page cache */
-#define XFS_IO_INVIS	0x00002		/* don't update inode timestamps */
-
-#define XFS_IO_FLAGS \
-	{ XFS_IO_ISDIRECT,	"DIRECT" }, \
-	{ XFS_IO_INVIS,		"INVIS"}
-
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6787a9f..2504f94 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1135,15 +1135,14 @@ TRACE_EVENT(xfs_log_assign_tail_lsn,
 )
 
 DECLARE_EVENT_CLASS(xfs_file_class,
-	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset, int flags),
-	TP_ARGS(ip, count, offset, flags),
+	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset),
+	TP_ARGS(ip, count, offset),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(xfs_fsize_t, size)
 		__field(loff_t, offset)
 		__field(size_t, count)
-		__field(int, flags)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
@@ -1151,23 +1150,21 @@ DECLARE_EVENT_CLASS(xfs_file_class,
 		__entry->size = ip->i_d.di_size;
 		__entry->offset = offset;
 		__entry->count = count;
-		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx "
-		  "offset 0x%llx count 0x%zx ioflags %s",
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx offset 0x%llx count 0x%zx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
 		  __entry->offset,
-		  __entry->count,
-		  __print_flags(__entry->flags, "|", XFS_IO_FLAGS))
+		  __entry->count)
 )
 
 #define DEFINE_RW_EVENT(name)		\
 DEFINE_EVENT(xfs_file_class, name,	\
-	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset, int flags),	\
-	TP_ARGS(ip, count, offset, flags))
-DEFINE_RW_EVENT(xfs_file_read);
+	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset),	\
+	TP_ARGS(ip, count, offset))
+DEFINE_RW_EVENT(xfs_file_buffered_read);
+DEFINE_RW_EVENT(xfs_file_direct_read);
 DEFINE_RW_EVENT(xfs_file_buffered_write);
 DEFINE_RW_EVENT(xfs_file_direct_write);
 DEFINE_RW_EVENT(xfs_file_splice_read);
-- 
2.1.4
