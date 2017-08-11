Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5D56521D4910A
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 23:43:32 -0700 (PDT)
Subject: [PATCH v3 2/6] fs, xfs: introduce FALLOC_FL_SEAL_BLOCK_MAP
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 10 Aug 2017 23:39:28 -0700
Message-ID: <150243356799.8777.11625037981403766282.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150243355681.8777.14902834768886160223.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150243355681.8777.14902834768886160223.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

>>From falloc.h:

    FALLOC_FL_SEAL_BLOCK_MAP is used to seal (make immutable) all of the
    file logical-to-physical extent offset mappings in the file. The
    purpose is to allow an application to assume that there are no holes
    or shared extents in the file and that the metadata needed to find
    all the physical extents of the file is stable and can never be
    dirtied.

For now this patch only permits setting the in-memory state of
S_IOMAP_IMMMUTABLE. Support for clearing and persisting the state is
saved for later patches.

The implementation is careful to not allow the immutable state to change
while any process might have any established mappings. It reuses the
existing xfs_reflink_unshare() and xfs_alloc_file_space() to unshare
extents and fill all holes in the file. It then holds XFS_ILOCK_EXCL
while it validates the file is in the proper state and sets
S_IOMAP_IMMUTABLE.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Suggested-by: Dave Chinner <david@fromorbit.com>
Suggested-by: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/open.c                   |   16 ++++++++--
 fs/xfs/xfs_bmap_util.c      |   72 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h      |    2 +
 fs/xfs/xfs_file.c           |   14 ++++++--
 include/linux/falloc.h      |    3 +-
 include/uapi/linux/falloc.h |   17 ++++++++++
 6 files changed, 117 insertions(+), 7 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 7395860d7164..76f57f7465c4 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -273,6 +273,17 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	    (mode & ~(FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_KEEP_SIZE)))
 		return -EINVAL;
 
+	/*
+	 * Seal block map operation should only be used exclusively, and
+	 * with the IMMUTABLE capability.
+	 */
+	if (mode & FALLOC_FL_SEAL_BLOCK_MAP) {
+		if (!capable(CAP_LINUX_IMMUTABLE))
+			return -EPERM;
+		if (mode & ~FALLOC_FL_SEAL_BLOCK_MAP)
+			return -EINVAL;
+	}
+
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
 
@@ -292,9 +303,10 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -ETXTBSY;
 
 	/*
-	 * We cannot allow any allocation changes on an iomap immutable file
+	 * We cannot allow any allocation changes on an iomap immutable file,
+	 * but we can allow the fs to validate if this request is redundant.
 	 */
-	if (IS_IOMAP_IMMUTABLE(inode))
+	if (IS_IOMAP_IMMUTABLE(inode) && !(mode & FALLOC_FL_SEAL_BLOCK_MAP))
 		return -ETXTBSY;
 
 	/*
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8427b0003c79..2ac8f4ed5723 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1390,6 +1390,78 @@ xfs_zero_file_space(
 
 }
 
+int
+xfs_seal_file_space(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		len)
+{
+	struct inode		*inode = VFS_I(ip);
+	struct address_space	*mapping = inode->i_mapping;
+	struct xfs_mount	*mp = ip->i_mount;
+	uint			blksize;
+	int			error;
+
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL));
+
+	if (offset)
+		return -EINVAL;
+
+	/* Before we unshare + allocate, validate if there is any work to do. */
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	error = -EINVAL;
+	if (len != i_size_read(inode))
+		goto out_unlock;
+
+	error = 0;
+	if (IS_IOMAP_IMMUTABLE(inode))
+		goto out_unlock;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+
+	error = xfs_reflink_unshare(ip, offset, len);
+	if (error)
+		return error;
+
+	blksize = 1 << mp->m_sb.sb_blocklog;
+	error = xfs_alloc_file_space(ip, round_down(offset, blksize),
+			round_up(offset + len, blksize) -
+			round_down(offset, blksize),
+			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
+	if (error)
+		return error;
+
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	/*
+	 * Did we race a size change? Note that since we hold the mmap
+	 * and i/o locks we cannot race hole punch.
+	 */
+	error = -EINVAL;
+	if (len != i_size_read(inode))
+		goto out_unlock;
+
+	/*
+	 * Allow DAX path to assume that the state of S_IOMAP_IMMUTABLE
+	 * will never change while any mapping is established.
+	 */
+	error = -EBUSY;
+	if (mapping_mapped(mapping))
+		goto out_unlock;
+
+	/* Did we race someone attempting to share extents? */
+	if (xfs_is_reflink_inode(ip))
+		goto out_unlock;
+
+	error = 0;
+	inode->i_flags |= S_IOMAP_IMMUTABLE;
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	return error;
+}
+
 /*
  * @next_fsb will keep track of the extent currently undergoing shift.
  * @stop_fsb will keep track of the extent at which we have to stop.
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 0cede1043571..5115a32a2483 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -60,6 +60,8 @@ int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
 				xfs_off_t len);
 int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
 				xfs_off_t len);
+int	xfs_seal_file_space(struct xfs_inode *, xfs_off_t offset,
+				xfs_off_t len);
 
 /* EOF block manipulation functions */
 bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c4893e226fd8..e21121530a90 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -739,7 +739,8 @@ xfs_file_write_iter(
 #define	XFS_FALLOC_FL_SUPPORTED						\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
 		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
-		 FALLOC_FL_INSERT_RANGE | FALLOC_FL_UNSHARE_RANGE)
+		 FALLOC_FL_INSERT_RANGE | FALLOC_FL_UNSHARE_RANGE |	\
+		 FALLOC_FL_SEAL_BLOCK_MAP)
 
 STATIC long
 xfs_file_fallocate(
@@ -834,9 +835,14 @@ xfs_file_fallocate(
 				error = xfs_reflink_unshare(ip, offset, len);
 				if (error)
 					goto out_unlock;
-			}
-			error = xfs_alloc_file_space(ip, offset, len,
-						     XFS_BMAPI_PREALLOC);
+
+				error = xfs_alloc_file_space(ip, offset, len,
+						XFS_BMAPI_PREALLOC);
+			} else if (mode & FALLOC_FL_SEAL_BLOCK_MAP) {
+				error = xfs_seal_file_space(ip, offset, len);
+			} else
+				error = xfs_alloc_file_space(ip, offset, len,
+						XFS_BMAPI_PREALLOC);
 		}
 		if (error)
 			goto out_unlock;
diff --git a/include/linux/falloc.h b/include/linux/falloc.h
index 7494dc67c66f..48546c6fbec7 100644
--- a/include/linux/falloc.h
+++ b/include/linux/falloc.h
@@ -26,6 +26,7 @@ struct space_resv {
 					 FALLOC_FL_COLLAPSE_RANGE |	\
 					 FALLOC_FL_ZERO_RANGE |		\
 					 FALLOC_FL_INSERT_RANGE |	\
-					 FALLOC_FL_UNSHARE_RANGE)
+					 FALLOC_FL_UNSHARE_RANGE |	\
+					 FALLOC_FL_SEAL_BLOCK_MAP)
 
 #endif /* _FALLOC_H_ */
diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
index b075f601919b..e3867cfe31d5 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -76,4 +76,21 @@
  */
 #define FALLOC_FL_UNSHARE_RANGE		0x40
 
+/*
+ * FALLOC_FL_SEAL_BLOCK_MAP is used to seal (make immutable) all of the
+ * file logical-to-physical extent offset mappings in the file. The
+ * purpose is to allow an application to assume that there are no holes
+ * or shared extents in the file and that the metadata needed to find
+ * all the physical extents of the file is stable and can never be
+ * dirtied.
+ *
+ * The immutable property is in effect for the entire inode, so the
+ * range for this operation must start at offset 0 and len must be
+ * greater than or equal to the current size of the file. If greater,
+ * this operation allocates, unshares, and seals in one atomic step.
+ *
+ * This flag implies FALLOC_FL_UNSHARE_RANGE and as such cannot be used
+ * with the punch, zero, collapse, or insert range modes.
+ */
+#define FALLOC_FL_SEAL_BLOCK_MAP	0x080
 #endif /* _UAPI_FALLOC_H_ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
