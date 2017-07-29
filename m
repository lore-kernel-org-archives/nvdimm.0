Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC5FE21E1DB20
 for <linux-nvdimm@lists.01.org>; Sat, 29 Jul 2017 12:48:04 -0700 (PDT)
Subject: [PATCH 3/3] xfs: persist S_IOMAP_IMMUTABLE in di_flags2
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 29 Jul 2017 12:43:46 -0700
Message-ID: <150135742595.35318.6882401569584241548.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150135740948.35318.10730072114996910905.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150135740948.35318.10730072114996910905.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: darrick.wong@oracle.com
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Record the immutable state in the on-disk inode so that on the next boot
the protections against reflink and hole punch etc are automatically
restored.

This deliberately does not add a FS_XFLAG_IOMAP_IMMUTABLE since
fallocate(2) is the path to toggle this flag.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Suggested-by: Dave Chinner <david@fromorbit.com>
Suggested-by: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/libxfs/xfs_format.h |    5 ++++-
 fs/xfs/xfs_bmap_util.c     |   14 +++++++++++---
 fs/xfs/xfs_bmap_util.h     |    2 +-
 fs/xfs/xfs_file.c          |    4 ++--
 fs/xfs/xfs_ioctl.c         |    4 ++--
 fs/xfs/xfs_iops.c          |    8 +++++---
 6 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d4d9bef20c3a..9e720e55776b 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1063,12 +1063,15 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_DAX_BIT	0	/* use DAX for this inode */
 #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
+#define XFS_DIFLAG2_IOMAP_IMMUTABLE_BIT 3 /* set S_IOMAP_IMMUTABLE for this inode */
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
+#define XFS_DIFLAG2_IOMAP_IMMUTABLE (1 << XFS_DIFLAG2_IOMAP_IMMUTABLE_BIT)
 
 #define XFS_DIFLAG2_ANY \
-	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)
+	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
+	 XFS_DIFLAG2_IOMAP_IMMUTABLE)
 
 /*
  * Inode number format:
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index c4fc79a0704f..1dcb521da456 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1021,7 +1021,8 @@ xfs_alloc_file_space(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
 	xfs_off_t		len,
-	int			alloc_type)
+	int			alloc_type,
+	uint64_t		di_flags2)
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_off_t		count;
@@ -1119,6 +1120,12 @@ xfs_alloc_file_space(
 			break;
 		}
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		if (di_flags2) {
+			/* fold inode attributes for this allocation */
+			ip->i_d.di_flags2 |= di_flags2;
+			di_flags2 = 0;
+		}
+
 		error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks,
 						      0, quota_flag);
 		if (error)
@@ -1381,7 +1388,7 @@ xfs_zero_file_space(
 	error = xfs_alloc_file_space(ip, round_down(offset, blksize),
 				     round_up(offset + len, blksize) -
 				     round_down(offset, blksize),
-				     XFS_BMAPI_PREALLOC);
+				     XFS_BMAPI_PREALLOC, 0);
 out:
 	return error;
 
@@ -1461,7 +1468,8 @@ xfs_seal_file_space(
 		goto err;
 
 	error = xfs_alloc_file_space(ip, offset, len,
-			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
+			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO,
+			XFS_DIFLAG2_IOMAP_IMMUTABLE);
 	if (error)
 		goto err;
 
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 5115a32a2483..1698e0c58b78 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -51,7 +51,7 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 
 /* preallocation and hole punch interface */
 int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
-			     xfs_off_t len, int alloc_type);
+			     xfs_off_t len, int alloc_type, uint64_t di_flags2);
 int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
 			    xfs_off_t len);
 int	xfs_zero_file_space(struct xfs_inode *ip, xfs_off_t offset,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e21121530a90..2d9ffa1773bd 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -837,12 +837,12 @@ xfs_file_fallocate(
 					goto out_unlock;
 
 				error = xfs_alloc_file_space(ip, offset, len,
-						XFS_BMAPI_PREALLOC);
+						XFS_BMAPI_PREALLOC, 0);
 			} else if (mode & FALLOC_FL_SEAL_BLOCK_MAP) {
 				error = xfs_seal_file_space(ip, offset, len);
 			} else
 				error = xfs_alloc_file_space(ip, offset, len,
-						XFS_BMAPI_PREALLOC);
+						XFS_BMAPI_PREALLOC, 0);
 		}
 		if (error)
 			goto out_unlock;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2e64488bc4de..c829f85bed99 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -703,7 +703,7 @@ xfs_ioc_space(
 	case XFS_IOC_RESVSP64:
 		flags |= XFS_PREALLOC_SET;
 		error = xfs_alloc_file_space(ip, bf->l_start, bf->l_len,
-						XFS_BMAPI_PREALLOC);
+						XFS_BMAPI_PREALLOC, 0);
 		break;
 	case XFS_IOC_UNRESVSP:
 	case XFS_IOC_UNRESVSP64:
@@ -716,7 +716,7 @@ xfs_ioc_space(
 		flags |= XFS_PREALLOC_CLEAR;
 		if (bf->l_start > XFS_ISIZE(ip)) {
 			error = xfs_alloc_file_space(ip, XFS_ISIZE(ip),
-					bf->l_start - XFS_ISIZE(ip), 0);
+					bf->l_start - XFS_ISIZE(ip), 0, 0);
 			if (error)
 				goto out_unlock;
 		}
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 469c9fa4c178..174ef95453f5 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1186,9 +1186,10 @@ xfs_diflags_to_iflags(
 	struct xfs_inode	*ip)
 {
 	uint16_t		flags = ip->i_d.di_flags;
+	uint64_t		flags2 = ip->i_d.di_flags2;
 
 	inode->i_flags &= ~(S_IMMUTABLE | S_APPEND | S_SYNC |
-			    S_NOATIME | S_DAX);
+			    S_NOATIME | S_DAX | S_IOMAP_IMMUTABLE);
 
 	if (flags & XFS_DIFLAG_IMMUTABLE)
 		inode->i_flags |= S_IMMUTABLE;
@@ -1201,9 +1202,10 @@ xfs_diflags_to_iflags(
 	if (S_ISREG(inode->i_mode) &&
 	    ip->i_mount->m_sb.sb_blocksize == PAGE_SIZE &&
 	    !xfs_is_reflink_inode(ip) &&
-	    (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
-	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
+	    (ip->i_mount->m_flags & XFS_MOUNT_DAX || flags2 & XFS_DIFLAG2_DAX))
 		inode->i_flags |= S_DAX;
+	if (flags2 & XFS_DIFLAG2_IOMAP_IMMUTABLE)
+		inode->i_flags |= S_IOMAP_IMMUTABLE;
 }
 
 /*

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
