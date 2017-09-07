Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B8B721E62BB3
 for <linux-nvdimm@lists.01.org>; Thu,  7 Sep 2017 14:06:12 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/2] xfs: always use DAX if mount option is used
Date: Thu,  7 Sep 2017 15:08:31 -0600
Message-Id: <20170907210832.17969-2-ross.zwisler@linux.intel.com>
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

Before support for the per-inode DAX flag was disabled the XFS the code had
an issue where the user couldn't reliably tell whether or not DAX was being
used to service page faults and I/O when the DAX mount option was used.  In
this case each inode within the mounted filesystem started with S_DAX set
due to the mount option, but it could be cleared if someone touched the
individual inode flag.

For example (v4.13 and before):

  # mount | grep dax
  /dev/pmem0 on /mnt type xfs
  (rw,relatime,seclabel,attr2,dax,inode64,sunit=4096,swidth=4096,noquota)

  # touch /mnt/a /mnt/b   # both files currently use DAX

  # xfs_io -c "lsattr" /mnt/*  # neither has the DAX inode option set
  ----------e----- /mnt/a
  ----------e----- /mnt/b

  # xfs_io -c "chattr -x" /mnt/a  # this clears S_DAX for /mnt/a

  # xfs_io -c "lsattr" /mnt/*
  ----------e----- /mnt/a
  ----------e----- /mnt/b

We end up with both /mnt/a and /mnt/b looking identical from the point of
view of the mount option and from lsattr, but one is using DAX and the
other is not.

Fix this by always doing DAX I/O when either the mount option is set or
when the DAX inode flag is set.  This means that DAX will always be used
for all inodes on a filesystem mounted with -o dax, making the usage
reliable and detectable.

This does not fix the race issues that caused the XFS DAX inode option to
be disabled, so that option will still be disabled.  If/when we re-enable
it, though, I think we will want this issue to have been fixed.  I also do
think that we want to fix this in stable kernels.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
CC: stable@vger.kernel.org
---
 fs/xfs/xfs_ioctl.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5049e8a..26faeb9 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1013,7 +1013,7 @@ xfs_diflags_to_linux(
 	else
 		inode->i_flags &= ~S_NOATIME;
 #if 0	/* disabled until the flag switching races are sorted out */
-	if (xflags & FS_XFLAG_DAX)
+	if ((xflags & FS_XFLAG_DAX) || (ip->i_mount->m_flags & XFS_MOUNT_DAX))
 		inode->i_flags |= S_DAX;
 	else
 		inode->i_flags &= ~S_DAX;
@@ -1104,7 +1104,14 @@ xfs_ioctl_setattr_dax_invalidate(
 			return -EINVAL;
 	}
 
-	/* If the DAX state is not changing, we have nothing to do here. */
+	/*
+	 * If the DAX state is not changing, we have nothing to do here.  If
+	 * the DAX mount option was used we will update the DAX inode flag as
+	 * the user requested but we will continue to use DAX for I/O and page
+	 * faults regardless of how the inode flag is set.
+	 */
+	if (ip->i_mount->m_flags & XFS_MOUNT_DAX)
+		return 0;
 	if ((fa->fsx_xflags & FS_XFLAG_DAX) && IS_DAX(inode))
 		return 0;
 	if (!(fa->fsx_xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
