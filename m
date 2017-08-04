Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B89162095DB87
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 19:32:29 -0700 (PDT)
Subject: [PATCH v2 2/5] fs, xfs: introduce FALLOC_FL_SEAL_BLOCK_MAP
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 03 Aug 2017 19:28:17 -0700
Message-ID: <150181369754.32119.7390149918955188408.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
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
 fs/open.c                   |   11 +++++
 fs/xfs/xfs_bmap_util.c      |  101 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h      |    2 +
 fs/xfs/xfs_file.c           |   14 ++++--
 include/linux/falloc.h      |    3 +
 include/uapi/linux/falloc.h |   19 ++++++++
 6 files changed, 145 insertions(+), 5 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 7395860d7164..e3aae59785ae 100644
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
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fe0f8f7f4bb7..46d8eb9e19fc 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1393,6 +1393,107 @@ xfs_zero_file_space(
 
 }
 
+/* Return 1 if hole detected, 0 if not, and < 0 if fail to determine */
+STATIC int
+xfs_file_has_holes(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_bmbt_irec	*map;
+	const int		map_size = 10;	/* constrain memory overhead */
+	int			i, nmaps;
+	int			error = 0;
+	xfs_fileoff_t		lblkno = 0;
+	xfs_filblks_t		maxlblkcnt;
+
+	map = kmem_alloc(map_size * sizeof(*map), KM_SLEEP);
+
+	maxlblkcnt = XFS_B_TO_FSB(mp, i_size_read(VFS_I(ip)));
+	do {
+		nmaps = map_size;
+		error = xfs_bmapi_read(ip, lblkno, maxlblkcnt - lblkno,
+				       map, &nmaps, 0);
+		if (error)
+			break;
+
+		ASSERT(nmaps <= map_size);
+		for (i = 0; i < nmaps; i++) {
+			lblkno += map[i].br_blockcount;
+			if (map[i].br_startblock == HOLESTARTBLOCK) {
+				error = 1;
+				break;
+			}
+		}
+	} while (nmaps > 0 && error == 0);
+
+	kmem_free(map);
+	return error;
+}
+
+int
+xfs_seal_file_space(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		len)
+{
+	struct inode		*inode = VFS_I(ip);
+	struct address_space	*mapping = inode->i_mapping;
+	int			error;
+
+	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
+
+	if (offset)
+		return -EINVAL;
+
+	error = xfs_reflink_unshare(ip, offset, len);
+	if (error)
+		return error;
+
+	error = xfs_alloc_file_space(ip, offset, len,
+			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	/*
+	 * Either the size changed after we performed allocation /
+	 * unsharing, or the request was too small to begin with.
+	 */
+	error = -EINVAL;
+	if (len < i_size_read(inode))
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
+	/* Did we race a hole punch? */
+	error = xfs_file_has_holes(ip);
+	if (error == 1) {
+		error = -EBUSY;
+		goto out_unlock;
+	}
+
+	/* Abort on an error reading the block map */
+	if (error < 0)
+		goto out_unlock;
+
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
index b075f601919b..39076975bf6f 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -76,4 +76,23 @@
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
+ * this operation allocates, unshares, hole fills, and seals in one
+ * atomic step. If len is zero then the immutable state is cleared for
+ * the inode.
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
