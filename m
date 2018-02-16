Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E488D223230D7
 for <linux-nvdimm@lists.01.org>; Fri, 16 Feb 2018 08:58:21 -0800 (PST)
Subject: [PATCH v6 1/3] fs: allow per-device dax status checking for
 filesystems
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 16 Feb 2018 10:04:15 -0700
Message-ID: <151880065504.43131.6695118308172421769.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151880058592.43131.558230052922233871.stgit@djiang5-desk3.ch.intel.com>
References: <151880058592.43131.558230052922233871.stgit@djiang5-desk3.ch.intel.com>
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

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove __bdev_dax_supported and change to bdev_dax_supported that takes a
bdev parameter.  This enables multi-device filesystems like xfs to check
that a dax device can work for the particular filesystem.  Once that's
in place, actually fix all the parts of XFS where we need to be able to
distinguish between datadev and rtdev.

This patch fixes the problem where we screw up the dax support checking
in xfs if the datadev and rtdev have different dax capabilities.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/dax/super.c |   30 +++++++++++++++---------------
 fs/ext2/super.c     |    2 +-
 fs/ext4/super.c     |    2 +-
 fs/xfs/xfs_ioctl.c  |    3 ++-
 fs/xfs/xfs_iops.c   |   30 +++++++++++++++++++++++++-----
 fs/xfs/xfs_super.c  |   10 ++++++++--
 include/linux/dax.h |   10 +++-------
 7 files changed, 55 insertions(+), 32 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 473af694ad1c..f037458600aa 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -73,8 +73,8 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
 #endif
 
 /**
- * __bdev_dax_supported() - Check if the device supports dax for filesystem
- * @sb: The superblock of the device
+ * bdev_dax_supported() - Check if the device supports dax for filesystem
+ * @bdev: block device to check
  * @blocksize: The block size of the device
  *
  * This is a library function for filesystems to check if the block device
@@ -82,33 +82,33 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
  *
  * Return: negative errno if unsupported, 0 if supported.
  */
-int __bdev_dax_supported(struct super_block *sb, int blocksize)
+int bdev_dax_supported(struct block_device *bdev, int blocksize)
 {
-	struct block_device *bdev = sb->s_bdev;
 	struct dax_device *dax_dev;
 	pgoff_t pgoff;
 	int err, id;
 	void *kaddr;
 	pfn_t pfn;
 	long len;
+	char buf[BDEVNAME_SIZE];
 
 	if (blocksize != PAGE_SIZE) {
-		pr_debug("VFS (%s): error: unsupported blocksize for dax\n",
-				sb->s_id);
+		pr_debug("%s: error: unsupported blocksize for dax\n",
+				bdevname(bdev, buf));
 		return -EINVAL;
 	}
 
 	err = bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff);
 	if (err) {
-		pr_debug("VFS (%s): error: unaligned partition for dax\n",
-				sb->s_id);
+		pr_debug("%s: error: unaligned partition for dax\n",
+				bdevname(bdev, buf));
 		return err;
 	}
 
 	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
 	if (!dax_dev) {
-		pr_debug("VFS (%s): error: device does not support dax\n",
-				sb->s_id);
+		pr_debug("%s: error: device does not support dax\n",
+				bdevname(bdev, buf));
 		return -EOPNOTSUPP;
 	}
 
@@ -119,8 +119,8 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
 	put_dax(dax_dev);
 
 	if (len < 1) {
-		pr_debug("VFS (%s): error: dax access failed (%ld)\n",
-				sb->s_id, len);
+		pr_debug("%s: error: dax access failed (%ld)\n",
+				bdevname(bdev, buf), len);
 		return len < 0 ? len : -EIO;
 	}
 
@@ -128,14 +128,14 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
 			|| pfn_t_devmap(pfn))
 		/* pass */;
 	else {
-		pr_debug("VFS (%s): error: dax support not enabled\n",
-				sb->s_id);
+		pr_debug("%s: error: dax support not enabled\n",
+				bdevname(bdev, buf));
 		return -EOPNOTSUPP;
 	}
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(__bdev_dax_supported);
+EXPORT_SYMBOL_GPL(bdev_dax_supported);
 #endif
 
 enum dax_device_flags {
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 7666c065b96f..b8063b640ec1 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -961,7 +961,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
 
 	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
-		err = bdev_dax_supported(sb, blocksize);
+		err = bdev_dax_supported(sb->s_bdev, blocksize);
 		if (err) {
 			ext2_msg(sb, KERN_ERR,
 				"DAX unsupported by block device. Turning off DAX.");
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 39bf464c35f1..911eca771853 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3714,7 +3714,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 					" that may contain inline data");
 			sbi->s_mount_opt &= ~EXT4_MOUNT_DAX;
 		}
-		err = bdev_dax_supported(sb, blocksize);
+		err = bdev_dax_supported(sb->s_bdev, blocksize);
 		if (err) {
 			ext4_msg(sb, KERN_ERR,
 				"DAX unsupported by block device. Turning off DAX.");
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 89fb1eb80aae..0effd46b965f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1103,7 +1103,8 @@ xfs_ioctl_setattr_dax_invalidate(
 	if (fa->fsx_xflags & FS_XFLAG_DAX) {
 		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
 			return -EINVAL;
-		if (bdev_dax_supported(sb, sb->s_blocksize) < 0)
+		if (bdev_dax_supported(xfs_find_bdev_for_inode(VFS_I(ip)),
+				sb->s_blocksize) < 0)
 			return -EINVAL;
 	}
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 56475fcd76f2..66cd61c172af 100644
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
index 7aba628dc527..aaaba6e604c4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1657,11 +1657,17 @@ xfs_fs_fill_super(
 		sb->s_flags |= SB_I_VERSION;
 
 	if (mp->m_flags & XFS_MOUNT_DAX) {
+		int	error2 = 0;
+
 		xfs_warn(mp,
 		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 
-		error = bdev_dax_supported(sb, sb->s_blocksize);
-		if (error) {
+		error = bdev_dax_supported(mp->m_ddev_targp->bt_bdev,
+				sb->s_blocksize);
+		if (mp->m_rtdev_targp)
+			error2 = bdev_dax_supported(mp->m_rtdev_targp->bt_bdev,
+					sb->s_blocksize);
+		if (error && error2) {
 			xfs_alert(mp,
 			"DAX unsupported by block device. Turning off DAX.");
 			mp->m_flags &= ~XFS_MOUNT_DAX;
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 0185ecdae135..8eb3a359df95 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -40,12 +40,7 @@ static inline void put_dax(struct dax_device *dax_dev)
 
 int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
 #if IS_ENABLED(CONFIG_FS_DAX)
-int __bdev_dax_supported(struct super_block *sb, int blocksize);
-static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
-{
-	return __bdev_dax_supported(sb, blocksize);
-}
-
+int bdev_dax_supported(struct block_device *bdev, int blocksize);
 static inline struct dax_device *fs_dax_get_by_host(const char *host)
 {
 	return dax_get_by_host(host);
@@ -58,7 +53,8 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
 
 struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
 #else
-static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
+static inline int bdev_dax_supported(struct block_device *bdev,
+		int blocksize)
 {
 	return -EOPNOTSUPP;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
