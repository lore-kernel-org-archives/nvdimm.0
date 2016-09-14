From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/12] xfs: take the ilock shared if possible in xfs_file_iomap_begin
Date: Wed, 14 Sep 2016 12:01:27 +0200
Message-ID: <1473847291-18913-9-git-send-email-hch@lst.de>
References: <1473847291-18913-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1473847291-18913-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
Cc: ross.zwisler@linux.intel.com
List-Id: linux-nvdimm@lists.01.org

We always just read the extent first, and will later lock exlusively
after first dropping the lock in case we actually allocate blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 5d06a2d..c3cc175 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -955,6 +955,7 @@ xfs_file_iomap_begin(
 	struct xfs_bmbt_irec	imap;
 	xfs_fileoff_t		offset_fsb, end_fsb;
 	int			nimaps = 1, error = 0;
+	unsigned		lockmode;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
@@ -964,7 +965,7 @@ xfs_file_iomap_begin(
 				iomap);
 	}
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	lockmode = xfs_ilock_data_map_shared(ip);
 
 	ASSERT(offset <= mp->m_super->s_maxbytes);
 	if ((xfs_fsize_t)offset + length > mp->m_super->s_maxbytes)
@@ -975,7 +976,7 @@ xfs_file_iomap_begin(
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
 			       &nimaps, XFS_BMAPI_ENTIRE);
 	if (error) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_iunlock(ip, lockmode);
 		return error;
 	}
 
@@ -995,7 +996,8 @@ xfs_file_iomap_begin(
 		 * xfs_iomap_write_direct() expects the shared lock. It
 		 * is unlocked on return.
 		 */
-		xfs_ilock_demote(ip, XFS_ILOCK_EXCL);
+		if (lockmode == XFS_ILOCK_EXCL)
+			xfs_ilock_demote(ip, lockmode);
 		error = xfs_iomap_write_direct(ip, offset, length, &imap,
 				nimaps);
 		if (error)
@@ -1006,7 +1008,7 @@ xfs_file_iomap_begin(
 	} else {
 		ASSERT(nimaps);
 
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_iunlock(ip, lockmode);
 		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
 	}
 
-- 
2.1.4

