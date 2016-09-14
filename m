From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/12] xfs: fix locking for DAX writes
Date: Wed, 14 Sep 2016 12:01:26 +0200
Message-ID: <1473847291-18913-8-git-send-email-hch@lst.de>
References: <1473847291-18913-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1473847291-18913-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
Cc: ross.zwisler@linux.intel.com
List-Id: linux-nvdimm@lists.01.org

So far DAX writes inherited the locking from direct I/O writes, but the direct
I/O model of using shared locks for writes is actually wrong for DAX.  For
direct I/O we're out of any standards and don't have to provide the Posix
required exclusion between writers, but for DAX which gets transparently
enable on applications without any knowledge of it we can't simply drop the
requirement.  Even worse this only happens for aligned writes and thus
doesn't show up for many typical use cases.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e612a02..62649cc 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -714,24 +714,11 @@ xfs_file_dax_write(
 	struct address_space	*mapping = iocb->ki_filp->f_mapping;
 	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			ret = 0;
-	int			unaligned_io = 0;
-	int			iolock;
+	int			iolock = XFS_IOLOCK_EXCL;
 	struct iov_iter		data;
 
-	/* "unaligned" here means not aligned to a filesystem block */
-	if ((iocb->ki_pos & mp->m_blockmask) ||
-	    ((iocb->ki_pos + iov_iter_count(from)) & mp->m_blockmask)) {
-		unaligned_io = 1;
-		iolock = XFS_IOLOCK_EXCL;
-	} else if (mapping->nrpages) {
-		iolock = XFS_IOLOCK_EXCL;
-	} else {
-		iolock = XFS_IOLOCK_SHARED;
-	}
 	xfs_rw_ilock(ip, iolock);
-
 	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
 	if (ret)
 		goto out;
@@ -758,11 +745,6 @@ xfs_file_dax_write(
 		WARN_ON_ONCE(ret);
 	}
 
-	if (iolock == XFS_IOLOCK_EXCL && !unaligned_io) {
-		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
-		iolock = XFS_IOLOCK_SHARED;
-	}
-
 	trace_xfs_file_dax_write(ip, iov_iter_count(from), iocb->ki_pos);
 
 	data = *from;
-- 
2.1.4

