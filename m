Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 729482095E513
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 16:11:15 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 3/7] xfs: protect S_DAX transitions in XFS read path
Date: Mon, 25 Sep 2017 17:14:00 -0600
Message-Id: <20170925231404.32723-4-ross.zwisler@linux.intel.com>
In-Reply-To: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jeff Layton <jlayton@poochiereds.net>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In the current XFS read I/O path we check IS_DAX() in xfs_file_read_iter()
to decide whether to do DAX I/O, direct I/O or buffered I/O.  This check is
done without holding the XFS_IOLOCK, though, which means that if we allow
S_DAX to be manipulated via the inode flag we can run into this race:

CPU 0				CPU 1
-----				-----
xfs_file_read_iter()
  IS_DAX() << returns false
  				xfs_ioctl_setattr()
				  xfs_ioctl_setattr_dax_invalidate()
				   xfs_ilock(XFS_MMAPLOCK|XFS_IOLOCK)
				  sets S_DAX
				  releases XFS_MMAPLOCK and XFS_IOLOCK
  xfs_file_buffered_aio_read()
  does buffered I/O to DAX inode, death

Fix this by ensuring that we only check S_DAX when we hold the XFS_IOLOCK
in the read path.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/xfs/xfs_file.c | 42 +++++++++++++-----------------------------
 1 file changed, 13 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ebdd0bd..ca4c8fd 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -207,7 +207,6 @@ xfs_file_dio_aio_read(
 {
 	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
 	size_t			count = iov_iter_count(to);
-	ssize_t			ret;
 
 	trace_xfs_file_direct_read(ip, count, iocb->ki_pos);
 
@@ -215,12 +214,7 @@ xfs_file_dio_aio_read(
 		return 0; /* skip atime */
 
 	file_accessed(iocb->ki_filp);
-
-	xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	ret = iomap_dio_rw(iocb, to, &xfs_iomap_ops, NULL);
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-
-	return ret;
+	return iomap_dio_rw(iocb, to, &xfs_iomap_ops, NULL);
 }
 
 static noinline ssize_t
@@ -230,23 +224,14 @@ xfs_file_dax_read(
 {
 	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
 	size_t			count = iov_iter_count(to);
-	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(ip, count, iocb->ki_pos);
 
 	if (!count)
 		return 0; /* skip atime */
 
-	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
-		if (iocb->ki_flags & IOCB_NOWAIT)
-			return -EAGAIN;
-		xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	}
-	ret = dax_iomap_rw(iocb, to, &xfs_iomap_ops);
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-
 	file_accessed(iocb->ki_filp);
-	return ret;
+	return dax_iomap_rw(iocb, to, &xfs_iomap_ops);
 }
 
 STATIC ssize_t
@@ -255,19 +240,9 @@ xfs_file_buffered_aio_read(
 	struct iov_iter		*to)
 {
 	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
-	ssize_t			ret;
 
 	trace_xfs_file_buffered_read(ip, iov_iter_count(to), iocb->ki_pos);
-
-	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
-		if (iocb->ki_flags & IOCB_NOWAIT)
-			return -EAGAIN;
-		xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	}
-	ret = generic_file_read_iter(iocb, to);
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-
-	return ret;
+	return generic_file_read_iter(iocb, to);
 }
 
 STATIC ssize_t
@@ -276,7 +251,8 @@ xfs_file_read_iter(
 	struct iov_iter		*to)
 {
 	struct inode		*inode = file_inode(iocb->ki_filp);
-	struct xfs_mount	*mp = XFS_I(inode)->i_mount;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			ret = 0;
 
 	XFS_STATS_INC(mp, xs_read_calls);
@@ -284,6 +260,12 @@ xfs_file_read_iter(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return -EAGAIN;
+		xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	}
+
 	if (IS_DAX(inode))
 		ret = xfs_file_dax_read(iocb, to);
 	else if (iocb->ki_flags & IOCB_DIRECT)
@@ -291,6 +273,8 @@ xfs_file_read_iter(
 	else
 		ret = xfs_file_buffered_aio_read(iocb, to);
 
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+
 	if (ret > 0)
 		XFS_STATS_ADD(mp, xs_read_bytes, ret);
 	return ret;
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
