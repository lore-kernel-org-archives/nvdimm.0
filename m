Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E93C3222DE126
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 16:32:39 -0800 (PST)
Subject: [PATCH v3 3/3] xfs: reject removal of realtime flag when datadev
 doesn't support DAX
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 08 Feb 2018 17:38:24 -0700
Message-ID: <151813670468.15926.3966047346830424677.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151813659955.15926.8922476613392258086.stgit@djiang5-desk3.ch.intel.com>
References: <151813659955.15926.8922476613392258086.stgit@djiang5-desk3.ch.intel.com>
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
Cc: linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In a situation where the rt_dev is DAX and data_dev is not DAX, if the user
requests to remove the realtime flag via ioctl we can no longer support DAX
for that file. Dynamic changing of S_DAX on the inode is not supported due
to various complications in the existing implementation. Therefore until we
address the dynamic S_DAX change issues, we must disallow realtime flag
being removed.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 fs/xfs/xfs_ioctl.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index e440d789ed1b..cd5a5c61da39 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1029,6 +1029,21 @@ xfs_ioctl_setattr_xflags(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	uint64_t		di_flags2;
+	struct inode		*inode = VFS_I(ip);
+	struct super_block	*sb = inode->i_sb;
+
+	/*
+	 * In the case that the inode is realtime, and we are trying to remove
+	 * the realtime flag, and the rtdev supports DAX but the datadev does
+	 * not support DAX, we can't allow the realtime flag to be removed
+	 * since we do not support dynamic S_DAX flag removal yet.
+	 */
+	if ((XFS_IS_REALTIME_INODE(ip)) &&
+	    !(fa->fsx_xflags & FS_XFLAG_REALTIME) &&
+	    bdev_dax_supported(sb, mp->m_rtdev_targp->bt_bdev,
+		    sb->s_blocksize) &&
+	    !bdev_dax_supported(sb, mp->m_ddev_targp->bt_bdev, sb->s_blocksize))
+		return -ENOTSUPP;
 
 	/* Can't change realtime flag if any extents are allocated. */
 	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
