Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5A5272215BDB2
 for <linux-nvdimm@lists.01.org>; Thu,  1 Feb 2018 15:23:07 -0800 (PST)
Date: Thu, 1 Feb 2018 15:28:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2 2/2] xfs: fix rt_dev usage for DAX
Message-ID: <20180201232839.GX4849@magnolia>
References: <151751717968.69886.6978962571680635420.stgit@djiang5-desk3.ch.intel.com>
 <151751718516.69886.135497175511444689.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151751718516.69886.135497175511444689.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

> [PATCH 2 2/2] xfs: fix rt_dev usage for DAX

"[PATCH v2 2/2]" to distinguish the version number from the patch number
more explicitly.

On Thu, Feb 01, 2018 at 01:33:05PM -0700, Dave Jiang wrote:
> When using realtime device (rtdev) with xfs where the data device is not
> DAX capable, two issues arise. One is when data device is not DAX but the
> realtime device is DAX capable, we currently disable DAX.
> After passing this check, we are also not marking the inode as DAX capable.
> This change will allow DAX enabled if the data device or the realtime
> device is DAX capable. S_DAX will be marked for the inode if the file is
> residing on a DAX capable device. This will prevent the case of rtdev is not
> DAX and data device is DAX to create realtime files.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reported-by: Darrick Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_iops.c  |    3 ++-
>  fs/xfs/xfs_super.c |    9 ++++++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 56475fcd76f2..ab352c325301 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1204,7 +1204,8 @@ xfs_diflags_to_iflags(
>  	    ip->i_mount->m_sb.sb_blocksize == PAGE_SIZE &&
>  	    !xfs_is_reflink_inode(ip) &&
>  	    (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
> -	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
> +	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX) &&
> +	    blk_queue_dax(bdev_get_queue(inode->i_sb->s_bdev)))

inode->i_sb->s_bdev is the data device bdev, so if the inode is a
realtime file, we're checking the wrong device for daxiness, I think.

Maybe this whole ugly switch statement should get turned into a helper
function?

xfs_ioctl_setattr_dax_invalidate needs to pick the right bdev to check.

>  		inode->i_flags |= S_DAX;
>  }
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e8a687232614..5ac478924dce 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1649,11 +1649,18 @@ xfs_fs_fill_super(
>  		sb->s_flags |= SB_I_VERSION;
>  
>  	if (mp->m_flags & XFS_MOUNT_DAX) {
> +		bool rtdev_is_dax = false;
> +
>  		xfs_warn(mp,
>  		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>  
> +		if (mp->m_rtdev_targp->bt_daxdev)
> +			if (bdev_dax_supported(mp->m_rtdev_targp->bt_bdev,
> +					      sb->s_blocksize) == 0)
> +				rtdev_is_dax = true;
> +
>  		error = bdev_dax_supported(sb->s_bdev, sb->s_blocksize);
> -		if (error) {
> +		if (error && !rtdev_is_dax) {
>  			xfs_alert(mp,
>  			"DAX unsupported by block device. Turning off DAX.");
>  			mp->m_flags &= ~XFS_MOUNT_DAX;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Does the following patch fix everything for you?

(Note that we can't switch S_DAX on a running fs so you have to remount
the whole fs after setting the dax flag...)

--D

--------------------

fs: allow per-device dax status checking for filesystems

Refactor __bdev_dax_supported into a sb_dax_supported helper for
single-bdev filesystems and a regular bdev_dax_supported that takes a
bdev parameter.  This enables multi-device filesystems like xfs to check
that a dax device can work for the particular filesystem.  Once that's
in place, actually fix all the parts of XFS where we need to be able to
distinguish between datadev and rtdev.

This patch fixes the problem where we screw up the dax support checking
in xfs if the datadev and rtdev have different dax capabilities.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 drivers/dax/super.c |    9 +++++----
 fs/ext2/super.c     |    2 +-
 fs/ext4/super.c     |    2 +-
 fs/xfs/xfs_ioctl.c  |    3 ++-
 fs/xfs/xfs_iops.c   |   30 +++++++++++++++++++++++++-----
 fs/xfs/xfs_super.c  |   11 +++++++++--
 include/linux/dax.h |   16 ++++++++++++----
 7 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 3ec8046..c4db84f 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -72,8 +72,9 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
 #endif
 
 /**
- * __bdev_dax_supported() - Check if the device supports dax for filesystem
+ * bdev_dax_supported() - Check if the device supports dax for filesystem
  * @sb: The superblock of the device
+ * @bdev: block device to check
  * @blocksize: The block size of the device
  *
  * This is a library function for filesystems to check if the block device
@@ -81,9 +82,9 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
  *
  * Return: negative errno if unsupported, 0 if supported.
  */
-int __bdev_dax_supported(struct super_block *sb, int blocksize)
+int bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
+		       int blocksize)
 {
-	struct block_device *bdev = sb->s_bdev;
 	struct dax_device *dax_dev;
 	pgoff_t pgoff;
 	int err, id;
@@ -125,7 +126,7 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(__bdev_dax_supported);
+EXPORT_SYMBOL_GPL(bdev_dax_supported);
 #endif
 
 enum dax_device_flags {
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 7646818..6556993 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -958,7 +958,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
 
 	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
-		err = bdev_dax_supported(sb, blocksize);
+		err = sb_dax_supported(sb, blocksize);
 		if (err)
 			goto failed_mount;
 	}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7c46693..804a2d6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3712,7 +3712,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 					" that may contain inline data");
 			goto failed_mount;
 		}
-		err = bdev_dax_supported(sb, blocksize);
+		err = sb_dax_supported(sb, blocksize);
 		if (err)
 			goto failed_mount;
 	}
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 89fb1eb..277355f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1103,7 +1103,8 @@ xfs_ioctl_setattr_dax_invalidate(
 	if (fa->fsx_xflags & FS_XFLAG_DAX) {
 		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
 			return -EINVAL;
-		if (bdev_dax_supported(sb, sb->s_blocksize) < 0)
+		if (bdev_dax_supported(sb, xfs_find_bdev_for_inode(VFS_I(ip)),
+				sb->s_blocksize) < 0)
 			return -EINVAL;
 	}
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 56475fc..66cd61c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1182,6 +1182,30 @@ static const struct inode_operations xfs_inline_symlink_inode_operations = {
 	.update_time		= xfs_vn_update_time,
 };
 
+/* Figure out if this file actually supports DAX. */
+static bool
+xfs_inode_supports_dax(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	/* Only supported on non-reflinked files. */
+	if (!S_ISREG(VFS_I(ip)->i_mode) || xfs_is_reflink_inode(ip))
+		return false;
+
+	/* DAX mount option or DAX iflag must be set. */
+	if (!(mp->m_flags & XFS_MOUNT_DAX) &&
+	    !(ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
+		return false;
+
+	/* Block size must match page size */
+	if (mp->m_sb.sb_blocksize != PAGE_SIZE)
+		return false;
+
+	/* Device has to support DAX too. */
+	return xfs_find_daxdev_for_inode(VFS_I(ip)) != NULL;
+}
+
 STATIC void
 xfs_diflags_to_iflags(
 	struct inode		*inode,
@@ -1200,11 +1224,7 @@ xfs_diflags_to_iflags(
 		inode->i_flags |= S_SYNC;
 	if (flags & XFS_DIFLAG_NOATIME)
 		inode->i_flags |= S_NOATIME;
-	if (S_ISREG(inode->i_mode) &&
-	    ip->i_mount->m_sb.sb_blocksize == PAGE_SIZE &&
-	    !xfs_is_reflink_inode(ip) &&
-	    (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
-	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
+	if (xfs_inode_supports_dax(ip))
 		inode->i_flags |= S_DAX;
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6f1b917..c115bc7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1692,11 +1692,18 @@ xfs_fs_fill_super(
 		sb->s_flags |= SB_I_VERSION;
 
 	if (mp->m_flags & XFS_MOUNT_DAX) {
+		int	error2 = 0;
+
 		xfs_warn(mp,
 		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 
-		error = bdev_dax_supported(sb, sb->s_blocksize);
-		if (error) {
+		error = bdev_dax_supported(sb, mp->m_ddev_targp->bt_bdev,
+				sb->s_blocksize);
+		if (mp->m_rtdev_targp)
+			error2 = bdev_dax_supported(sb,
+					mp->m_rtdev_targp->bt_bdev,
+					sb->s_blocksize);
+		if (error && error2) {
 			xfs_alert(mp,
 			"DAX unsupported by block device. Turning off DAX.");
 			mp->m_flags &= ~XFS_MOUNT_DAX;
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 5258346..1107a98 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -40,10 +40,11 @@ static inline void put_dax(struct dax_device *dax_dev)
 
 int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
 #if IS_ENABLED(CONFIG_FS_DAX)
-int __bdev_dax_supported(struct super_block *sb, int blocksize);
-static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
+int bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
+		       int blocksize);
+static inline int sb_dax_supported(struct super_block *sb, int blocksize)
 {
-	return __bdev_dax_supported(sb, blocksize);
+	return bdev_dax_supported(sb, sb->s_bdev, blocksize);
 }
 
 static inline struct dax_device *fs_dax_get_by_host(const char *host)
@@ -58,7 +59,14 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
 
 struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
 #else
-static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
+static inline int bdev_dax_supported(struct super_block *sb,
+				     struct block_device *bdev,
+				     int blocksize)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int sb_dax_supported(struct super_block *sb, int blocksize)
 {
 	return -EOPNOTSUPP;
 }
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
