Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EBAD521E1DB20
 for <linux-nvdimm@lists.01.org>; Sat, 29 Jul 2017 12:47:59 -0700 (PDT)
Subject: [PATCH 2/3] fs, xfs: introduce FALLOC_FL_SEAL_BLOCK_MAP
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 29 Jul 2017 12:43:40 -0700
Message-ID: <150135742076.35318.12884268722541769179.stgit@dwillia2-desk3.amr.corp.intel.com>
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

>>From falloc.h:

    FALLOC_FL_SEAL_BLOCK_MAP is used to seal (make immutable) all of the
    file logical-to-physical extent offset mappings in the file. The
    purpose is to allow an application to assume that there are no holes
    or shared extents in the file and that the metadata needed to find
    all the physical extents of the file is stable and can never be
    dirtied.

For now this patch only permits setting / clearing the in-memory state
of S_IOMAP_IMMMUTABLE, persisting the state is saved for a later patch.

The implementation is careful to not allow the immutable state to change
while any process might have any established mappings. It reuses the
existing xfs_reflink_unshare() and xfs_alloc_file_space() to unshare
extents and fill all holes in the file, or otherwise extend the file
size in the same operation that sets S_IOMAP_IMMUTABLE.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Suggested-by: Dave Chinner <david@fromorbit.com>
Suggested-by: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/open.c                   |   26 ++++++++++++-
 fs/xfs/xfs_bmap_util.c      |   86 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h      |    2 +
 fs/xfs/xfs_file.c           |   14 +++++--
 include/linux/falloc.h      |    3 +-
 include/uapi/linux/falloc.h |   19 ++++++++++
 6 files changed, 142 insertions(+), 8 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 7395860d7164..df075484fad5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -241,7 +241,11 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	struct inode *inode = file_inode(file);
 	long ret;
 
-	if (offset < 0 || len <= 0)
+	if (offset < 0 || len < 0)
+		return -EINVAL;
+
+	/* Allow zero len only for the unseal operation */
+	if (!(mode & FALLOC_FL_SEAL_BLOCK_MAP) && len == 0)
 		return -EINVAL;
 
 	/* Return error if mode is not supported */
@@ -273,6 +277,17 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	    (mode & ~(FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_KEEP_SIZE)))
 		return -EINVAL;
 
+	/*
+	 * Seal block map should only be used exclusively, and with
+	 * the IMMUTABLE capability.
+	 */
+	if (mode & FALLOC_FL_SEAL_BLOCK_MAP) {
+		if (mode & ~FALLOC_FL_SEAL_BLOCK_MAP)
+			return -EINVAL;
+		if (!capable(CAP_LINUX_IMMUTABLE))
+			return -EPERM;
+	}
+
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
 
@@ -292,9 +307,14 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -ETXTBSY;
 
 	/*
-	 * We cannot allow any allocation changes on an iomap immutable file
+	 * We cannot allow any allocation changes on an iomap immutable
+	 * file, however if the operation is FALLOC_FL_SEAL_BLOCK_MAP,
+	 * call down to ->fallocate() to determine if the operations is
+	 * allowed. ->fallocate() may either clear the flag when @len is
+	 * zero, or validate that the requested operation is already the
+	 * current state of the file.
 	 */
-	if (IS_IOMAP_IMMUTABLE(inode))
+	if (IS_IOMAP_IMMUTABLE(inode) && (!(mode & FALLOC_FL_SEAL_BLOCK_MAP)))
 		return -ETXTBSY;
 
 	/*
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 93e955262d07..c4fc79a0704f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1387,6 +1387,92 @@ xfs_zero_file_space(
 
 }
 
+int
+xfs_seal_file_space(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		len)
+{
+	struct inode		*inode = VFS_I(ip);
+	struct address_space	*mapping = inode->i_mapping;
+	int			error = 0;
+
+	if (offset)
+		return -EINVAL;
+
+	i_mmap_lock_read(mapping);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	if (len == 0) {
+		/*
+		 * Clear the immutable flag provided there are no active
+		 * mappings. The active mapping check prevents an
+		 * application that is assuming a static block map, for
+		 * DAX or peer-to-peer DMA, from having this state
+		 * silently change behind its back.
+		 */
+		if (RB_EMPTY_ROOT(&mapping->i_mmap))
+			inode->i_flags &= ~S_IOMAP_IMMUTABLE;
+		else
+			error = -EBUSY;
+	} else if (IS_IOMAP_IMMUTABLE(inode)) {
+		if (len == i_size_read(inode)) {
+			/*
+			 * The file is already in the correct state,
+			 * bail out without error below.
+			 */
+			len = 0;
+		} else {
+			/* too late to allocate more space */
+			error = -ETXTBSY;
+		}
+	} else {
+		if (len < i_size_read(inode)) {
+			/*
+			 * Since S_IOMAP_IMMUTABLE is inode global it
+			 * does not make sense to fallocate(immutable)
+			 * on a sub-range of the file.
+			 */
+			error = -EINVAL;
+		} else if (!RB_EMPTY_ROOT(&mapping->i_mmap)) {
+			/*
+			 * It's not strictly required to prevent setting
+			 * immutable while a file is already mapped, but
+			 * we do it for simplicity and symmetry with the
+			 * S_IOMAP_IMMUTABLE disable case.
+			 */
+			error = -EBUSY;
+		} else
+			inode->i_flags |= S_IOMAP_IMMUTABLE;
+	}
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	i_mmap_unlock_read(mapping);
+
+	if (error || len == 0)
+		return error;
+
+	/*
+	 * From here, the immutable flag is already set, so new
+	 * operations that would change the block map are prevented by
+	 * upper layer code paths. Wwe can proceed to unshare and
+	 * allocate zeroed / written extents.
+	 */
+	error = xfs_reflink_unshare(ip, offset, len);
+	if (error)
+		goto err;
+
+	error = xfs_alloc_file_space(ip, offset, len,
+			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
+	if (error)
+		goto err;
+
+	return 0;
+err:
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	inode->i_flags &= ~S_IOMAP_IMMUTABLE;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
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
index b075f601919b..629c9b20e49b 100644
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
+#define FALLOC_FL_SEAL_BLOCK_MAP	0x80
 #endif /* _UAPI_FALLOC_H_ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
