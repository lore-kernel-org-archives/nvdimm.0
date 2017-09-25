Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D69A2095E513
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 16:11:18 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 5/7] xfs: introduce xfs_is_dax_state_changing
Date: Mon, 25 Sep 2017 17:14:02 -0600
Message-Id: <20170925231404.32723-6-ross.zwisler@linux.intel.com>
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

Pull this code out of xfs_ioctl_setattr_dax_invalidate() as it will be used
in multiple places soon.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/xfs/xfs_ioctl.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0433aef..386b437 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1020,6 +1020,27 @@ xfs_diflags_to_linux(
 #endif
 }
 
+static bool
+xfs_is_dax_state_changing(
+	unsigned int		xflags,
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	/*
+	 * If the DAX mount option was used we will update the DAX inode flag
+	 * as the user requested but we will continue to use DAX for I/O and
+	 * page faults regardless of how the inode flag is set.
+	 */
+	if (ip->i_mount->m_flags & XFS_MOUNT_DAX)
+		return false;
+	if ((xflags & FS_XFLAG_DAX) && IS_DAX(inode))
+		return false;
+	if (!(xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
+		return false;
+	return true;
+}
+
 static int
 xfs_ioctl_setattr_xflags(
 	struct xfs_trans	*tp,
@@ -1105,17 +1126,8 @@ xfs_ioctl_setattr_dax_invalidate(
 			return -EINVAL;
 	}
 
-	/*
-	 * If the DAX state is not changing, we have nothing to do here.  If
-	 * the DAX mount option was used we will update the DAX inode flag as
-	 * the user requested but we will continue to use DAX for I/O and page
-	 * faults regardless of how the inode flag is set.
-	 */
-	if (ip->i_mount->m_flags & XFS_MOUNT_DAX)
-		return 0;
-	if ((fa->fsx_xflags & FS_XFLAG_DAX) && IS_DAX(inode))
-		return 0;
-	if (!(fa->fsx_xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
+	/* If the DAX state is not changing, we have nothing to do here. */
+	if (!xfs_is_dax_state_changing(fa->fsx_xflags, ip))
 		return 0;
 
 	/* lock, flush and invalidate mapping in preparation for flag change */
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
