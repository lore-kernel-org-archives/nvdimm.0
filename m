Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6C6F121D4910C
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 23:43:48 -0700 (PDT)
Subject: [PATCH v3 5/6] xfs: toggle XFS_DIFLAG2_IOMAP_IMMUTABLE in response
 to fallocate
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 10 Aug 2017 23:39:44 -0700
Message-ID: <150243358393.8777.4927964880763134327.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, luto@kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

After validating the state of the file as not having holes, shared
extents, or active mappings try to commit the
XFS_DIFLAG2_IOMAP_IMMUTABLE flag to the on-disk inode metadata. If that
succeeds then allow the S_IOMAP_IMMUTABLE to be set on the vfs inode.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Suggested-by: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_bmap_util.c |   38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 888bae801961..26289d553760 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1401,6 +1401,7 @@ xfs_seal_file_space(
 	struct xfs_mount	*mp = ip->i_mount;
 	uint			blksize;
 	int			error;
+	struct xfs_trans	*tp;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL));
 
@@ -1431,6 +1432,10 @@ xfs_seal_file_space(
 	if (error)
 		return error;
 
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	/*
@@ -1439,7 +1444,7 @@ xfs_seal_file_space(
 	 */
 	error = -EINVAL;
 	if (len != i_size_read(inode))
-		goto out_unlock;
+		goto out_cancel;
 
 	/*
 	 * Allow DAX path to assume that the state of S_IOMAP_IMMUTABLE
@@ -1447,15 +1452,20 @@ xfs_seal_file_space(
 	 */
 	error = -EBUSY;
 	if (mapping_mapped(mapping))
-		goto out_unlock;
+		goto out_cancel;
 
 	/* Did we race someone attempting to share extents? */
 	if (xfs_is_reflink_inode(ip))
-		goto out_unlock;
+		goto out_cancel;
 
-	error = 0;
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	ip->i_d.di_flags2 |= XFS_DIFLAG2_IOMAP_IMMUTABLE;
 	inode->i_flags |= S_IOMAP_IMMUTABLE;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return xfs_trans_commit(tp);
 
+out_cancel:
+	xfs_trans_cancel(tp);
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
@@ -1468,15 +1478,21 @@ xfs_unseal_file_space(
 	xfs_off_t		offset,
 	xfs_off_t		len)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
 	struct address_space	*mapping = inode->i_mapping;
 	int			error;
+	struct xfs_trans	*tp;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL));
 
 	if (offset)
 		return -EINVAL;
 
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	/*
 	 * It does not make sense to unseal less than the full range of
@@ -1484,12 +1500,12 @@ xfs_unseal_file_space(
 	 */
 	error = -EINVAL;
 	if (len != i_size_read(inode))
-		goto out_unlock;
+		goto out_cancel;
 
 	/* Are we already unsealed? */
 	error = 0;
 	if (!IS_IOMAP_IMMUTABLE(inode))
-		goto out_unlock;
+		goto out_cancel;
 
 	/*
 	 * Provide safety against one thread changing the policy of not
@@ -1498,12 +1514,16 @@ xfs_unseal_file_space(
 	 */
 	error = -EBUSY;
 	if (mapping_mapped(mapping))
-		goto out_unlock;
+		goto out_cancel;
 
-	error = 0;
+	xfs_trans_ijoin(tp, ip, 0);
+	ip->i_d.di_flags2 &= ~XFS_DIFLAG2_IOMAP_IMMUTABLE;
 	inode->i_flags &= ~S_IOMAP_IMMUTABLE;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return xfs_trans_commit(tp);
 
-out_unlock:
+out_cancel:
+	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	return error;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
