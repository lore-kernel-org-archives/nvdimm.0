Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3864F21EA35DD
 for <linux-nvdimm@lists.01.org>; Thu,  7 Sep 2017 14:06:13 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/2] xfs: validate bdev support for DAX inode flag
Date: Thu,  7 Sep 2017 15:08:32 -0600
Message-Id: <20170907210832.17969-3-ross.zwisler@linux.intel.com>
In-Reply-To: <20170907210832.17969-1-ross.zwisler@linux.intel.com>
References: <20170907210832.17969-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Currently only the blocksize is checked, but we should really be calling
bdev_dax_supported() which also tests to make sure we can get a
struct dax_device and that the dax_direct_access() path is working.

This is the same check that we do for the "-o dax" mount option in
xfs_fs_fill_super().

This does not fix the race issues that caused the XFS DAX inode option to
be disabled, so that option will still be disabled.  If/when we re-enable
it, though, I think we will want this issue to have been fixed.  I also do
think that we want to fix this in stable kernels.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
CC: stable@vger.kernel.org
---
 fs/xfs/xfs_ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 26faeb9..0433aef 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1088,6 +1088,7 @@ xfs_ioctl_setattr_dax_invalidate(
 	int			*join_flags)
 {
 	struct inode		*inode = VFS_I(ip);
+	struct super_block	*sb = inode->i_sb;
 	int			error;
 
 	*join_flags = 0;
@@ -1100,7 +1101,7 @@ xfs_ioctl_setattr_dax_invalidate(
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
