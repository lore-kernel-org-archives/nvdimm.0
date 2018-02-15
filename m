Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 94DFD21D49117
 for <linux-nvdimm@lists.01.org>; Thu, 15 Feb 2018 09:36:46 -0800 (PST)
Subject: [PATCH v4 2/3] dax: change bdev_dax_supported() to support boolean
 returns
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 15 Feb 2018 10:42:38 -0700
Message-ID: <151871655831.27617.969797567050409931.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151871644696.27617.4390718895806529377.stgit@djiang5-desk3.ch.intel.com>
References: <151871644696.27617.4390718895806529377.stgit@djiang5-desk3.ch.intel.com>
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

The function return values are confusing with the way the function is
named. We expect a true or false return value but it actually returns
0/-errno.  This makes the code very confusing. Changing the return values
to return a bool where if DAX is supported then return true and no DAX
support returns false.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/super.c |   20 ++++++++++----------
 fs/ext2/super.c     |    3 +--
 fs/ext4/super.c     |    3 +--
 fs/xfs/xfs_ioctl.c  |    4 ++--
 fs/xfs/xfs_super.c  |   10 +++++-----
 include/linux/dax.h |   12 ++++++------
 6 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 8a3a168a267f..42e58eea305e 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -81,9 +81,9 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
  * This is a library function for filesystems to check if the block device
  * can be mounted with dax option.
  *
- * Return: negative errno if unsupported, 0 if supported.
+ * Return: true if supported, false if unsupported
  */
-int bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
+bool bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
 		       int blocksize)
 {
 	struct dax_device *dax_dev;
@@ -96,21 +96,21 @@ int bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
 	if (blocksize != PAGE_SIZE) {
 		pr_debug("VFS (%s): error: unsupported blocksize for dax\n",
 				sb->s_id);
-		return -EINVAL;
+		return false;
 	}
 
 	err = bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff);
 	if (err) {
-		pr_debug("VFS (%s): error: unaligned partition for dax\n",
-				sb->s_id);
-		return err;
+		pr_debug("VFS (%s): error: unaligned partition for dax: %d\n",
+				sb->s_id, err);
+		return false;
 	}
 
 	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
 	if (!dax_dev) {
 		pr_debug("VFS (%s): error: device does not support dax\n",
 				sb->s_id);
-		return -EOPNOTSUPP;
+		return false;
 	}
 
 	id = dax_read_lock();
@@ -122,7 +122,7 @@ int bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
 	if (len < 1) {
 		pr_debug("VFS (%s): error: dax access failed (%ld)\n",
 				sb->s_id, len);
-		return len < 0 ? len : -EIO;
+		return false;
 	}
 
 	if ((IS_ENABLED(CONFIG_FS_DAX_LIMITED) && pfn_t_special(pfn))
@@ -131,10 +131,10 @@ int bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
 	else {
 		pr_debug("VFS (%s): error: dax support not enabled\n",
 				sb->s_id);
-		return -EOPNOTSUPP;
+		return false;
 	}
 
-	return 0;
+	return true;
 }
 EXPORT_SYMBOL_GPL(bdev_dax_supported);
 #endif
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 28ca694e9e92..6901ba1d65d1 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -961,8 +961,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
 
 	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
-		err = sb_dax_supported(sb, blocksize);
-		if (err) {
+		if(!sb_dax_supported(sb, blocksize)) {
 			ext2_msg(sb, KERN_ERR,
 				"DAX unsupported by block device. Turning off DAX.");
 			sbi->s_mount_opt &= ~EXT2_MOUNT_DAX;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a09f832aad35..8b4ee5f5c17b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3714,8 +3714,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 					" that may contain inline data");
 			sbi->s_mount_opt &= ~EXT4_MOUNT_DAX;
 		}
-		err = sb_dax_supported(sb, blocksize);
-		if (err) {
+		if (!sb_dax_supported(sb, blocksize)) {
 			ext4_msg(sb, KERN_ERR,
 				"DAX unsupported by block device. Turning off DAX.");
 			sbi->s_mount_opt &= ~EXT4_MOUNT_DAX;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 277355f5c084..a6a0efc35c76 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1103,8 +1103,8 @@ xfs_ioctl_setattr_dax_invalidate(
 	if (fa->fsx_xflags & FS_XFLAG_DAX) {
 		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
 			return -EINVAL;
-		if (bdev_dax_supported(sb, xfs_find_bdev_for_inode(VFS_I(ip)),
-				sb->s_blocksize) < 0)
+		if (!bdev_dax_supported(sb, xfs_find_bdev_for_inode(VFS_I(ip)),
+				sb->s_blocksize))
 			return -EINVAL;
 	}
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f6c74ef9722c..80658e0f01c2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1657,18 +1657,18 @@ xfs_fs_fill_super(
 		sb->s_flags |= SB_I_VERSION;
 
 	if (mp->m_flags & XFS_MOUNT_DAX) {
-		int	error2 = 0;
+		bool rtdev_is_dax, datadev_is_dax;
 
 		xfs_warn(mp,
 		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 
-		error = bdev_dax_supported(sb, mp->m_ddev_targp->bt_bdev,
-				sb->s_blocksize);
+		datadev_is_dax = bdev_dax_supported(sb,
+				mp->m_ddev_targp->bt_bdev, sb->s_blocksize);
 		if (mp->m_rtdev_targp)
-			error2 = bdev_dax_supported(sb,
+			rtdev_is_dax = bdev_dax_supported(sb,
 					mp->m_rtdev_targp->bt_bdev,
 					sb->s_blocksize);
-		if (error && error2) {
+		if (!rtdev_is_dax && !datadev_is_dax) {
 			xfs_alert(mp,
 			"DAX unsupported by block device. Turning off DAX.");
 			mp->m_flags &= ~XFS_MOUNT_DAX;
diff --git a/include/linux/dax.h b/include/linux/dax.h
index e640c8a19ec0..f733edd3a9dc 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -40,9 +40,9 @@ static inline void put_dax(struct dax_device *dax_dev)
 
 int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
 #if IS_ENABLED(CONFIG_FS_DAX)
-int bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
+bool bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
 		       int blocksize);
-static inline int sb_dax_supported(struct super_block *sb, int blocksize)
+static inline bool sb_dax_supported(struct super_block *sb, int blocksize)
 {
 	return bdev_dax_supported(sb, sb->s_bdev, blocksize);
 }
@@ -59,16 +59,16 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
 
 struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
 #else
-static inline int bdev_dax_supported(struct super_block *sb,
+static inline bool bdev_dax_supported(struct super_block *sb,
 				     struct block_device *bdev,
 				     int blocksize)
 {
-	return -EOPNOTSUPP;
+	return false;
 }
 
-static inline int sb_dax_supported(struct super_block *sb, int blocksize)
+static inline bool sb_dax_supported(struct super_block *sb, int blocksize)
 {
-	return -EOPNOTSUPP;
+	return false;
 }
 
 static inline struct dax_device *fs_dax_get_by_host(const char *host)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
