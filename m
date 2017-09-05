Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A2D0621E11D39
 for <linux-nvdimm@lists.01.org>; Tue,  5 Sep 2017 15:33:26 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 3/9] xfs: validate bdev support for DAX inode flag
Date: Tue,  5 Sep 2017 16:35:35 -0600
Message-Id: <20170905223541.20594-4-ross.zwisler@linux.intel.com>
In-Reply-To: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Currently only the blocksize is checked, but we should really be calling
bdev_dax_supported() which also tests to make sure we can get a
struct dax_device and that the dax_direct_access() path is working.

This is the same check that we do for the "-o dax" mount option in
xfs_fs_fill_super().

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
CC: stable@vger.kernel.org
---
 fs/xfs/xfs_ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 8155ddc..dac195d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1075,6 +1075,7 @@ xfs_ioctl_setattr_dax_invalidate(
 	int			*join_flags)
 {
 	struct inode		*inode = VFS_I(ip);
+	struct super_block	*sb = inode->i_sb;
 	int			error;
 
 	*join_flags = 0;
@@ -1087,7 +1088,7 @@ xfs_ioctl_setattr_dax_invalidate(
 	if (fa->fsx_xflags & FS_XFLAG_DAX) {
 		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
 			return -EINVAL;
-		if (ip->i_mount->m_sb.sb_blocksize != PAGE_SIZE)
+		if (bdev_dax_supported(sb, sb->s_blocksize) < 0)
 			return -EINVAL;
 	}
 
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
