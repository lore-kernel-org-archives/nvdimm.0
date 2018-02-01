Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2472A223CCEEC
 for <linux-nvdimm@lists.01.org>; Thu,  1 Feb 2018 12:27:22 -0800 (PST)
Subject: [PATCH 2 1/2] dax: change bdev_dax_supported() to take a
 block_device as input
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 01 Feb 2018 13:32:59 -0700
Message-ID: <151751717968.69886.6978962571680635420.stgit@djiang5-desk3.ch.intel.com>
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
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This is in preparation to support DAX for realtime device on XFS.
bdev_dax_supported() will be taking a block_device as input instead of
a superblock. The only place a super_block is used in this function is
providing the id for debug outputs. Also __bdev_dax_supported()
will be removed since it just directly calls bdev_dax_supported()
and is not reference by any other code.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/super.c |   33 ++++++++++++++++-----------------
 fs/ext2/super.c     |    2 +-
 fs/ext4/super.c     |    2 +-
 fs/xfs/xfs_ioctl.c  |    2 +-
 fs/xfs/xfs_super.c  |    2 +-
 include/linux/dax.h |    8 ++------
 6 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 473af694ad1c..3bdf6787b6df 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -70,11 +70,10 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
 	return fs_dax_get_by_host(bdev->bd_disk->disk_name);
 }
 EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
-#endif
 
 /**
- * __bdev_dax_supported() - Check if the device supports dax for filesystem
- * @sb: The superblock of the device
+ * bdev_dax_supported() - Check if the device supports dax for filesystem
+ * @sb: The block_device of the device
  * @blocksize: The block size of the device
  *
  * This is a library function for filesystems to check if the block device
@@ -82,9 +81,8 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
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
@@ -93,22 +91,22 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
 	long len;
 
 	if (blocksize != PAGE_SIZE) {
-		pr_debug("VFS (%s): error: unsupported blocksize for dax\n",
-				sb->s_id);
+		pr_debug("bdev (%d:%d): error: unsupported blocksize for dax\n",
+				MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
 		return -EINVAL;
 	}
 
 	err = bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff);
 	if (err) {
-		pr_debug("VFS (%s): error: unaligned partition for dax\n",
-				sb->s_id);
+		pr_debug("bdev (%d:%d): error: unaligned partition for dax\n",
+				MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
 		return err;
 	}
 
 	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
 	if (!dax_dev) {
-		pr_debug("VFS (%s): error: device does not support dax\n",
-				sb->s_id);
+		pr_debug("bdev (%d:%d): error: device does not support dax\n",
+				MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
 		return -EOPNOTSUPP;
 	}
 
@@ -119,8 +117,8 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
 	put_dax(dax_dev);
 
 	if (len < 1) {
-		pr_debug("VFS (%s): error: dax access failed (%ld)\n",
-				sb->s_id, len);
+		pr_debug("bdev (%d:%d): error: dax access failed (%ld)\n",
+				MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev), len);
 		return len < 0 ? len : -EIO;
 	}
 
@@ -128,15 +126,16 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
 			|| pfn_t_devmap(pfn))
 		/* pass */;
 	else {
-		pr_debug("VFS (%s): error: dax support not enabled\n",
-				sb->s_id);
+		pr_debug("bdev (%d:%d): error: dax support not enabled\n",
+				MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
 		return -EOPNOTSUPP;
 	}
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(__bdev_dax_supported);
-#endif
+EXPORT_SYMBOL_GPL(bdev_dax_supported);
+#endif /* CONFIG_FS_DAX */
+#endif /* CONFIG_BLOCK */
 
 enum dax_device_flags {
 	/* !alive + rcu grace period == no new operations / mappings */
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 38f9222606ee..a0de090b18d5 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -958,7 +958,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
 
 	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
-		err = bdev_dax_supported(sb, blocksize);
+		err = bdev_dax_supported(sb->s_bdev, blocksize);
 		if (err) {
 			ext2_msg(sb, KERN_ERR,
 				"DAX unsupported by block device. Turning off DAX.");
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 18873ea89e08..7ebc8d5cab8c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3712,7 +3712,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 					" that may contain inline data");
 			sbi->s_mount_opt &= ~EXT4_MOUNT_DAX;
 		}
-		err = bdev_dax_supported(sb, blocksize);
+		err = bdev_dax_supported(sb->s_bdev, blocksize);
 		if (err) {
 			ext4_msg(sb, KERN_ERR,
 				"DAX unsupported by block device. Turning off DAX.");
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 20dc65fef6a4..5fd4d50eb1c6 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1102,7 +1102,7 @@ xfs_ioctl_setattr_dax_invalidate(
 	if (fa->fsx_xflags & FS_XFLAG_DAX) {
 		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
 			return -EINVAL;
-		if (bdev_dax_supported(sb, sb->s_blocksize) < 0)
+		if (bdev_dax_supported(sb->s_bdev, sb->s_blocksize) < 0)
 			return -EINVAL;
 	}
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1dacccc367f8..e8a687232614 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1652,7 +1652,7 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
 		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 
-		error = bdev_dax_supported(sb, sb->s_blocksize);
+		error = bdev_dax_supported(sb->s_bdev, sb->s_blocksize);
 		if (error) {
 			xfs_alert(mp,
 			"DAX unsupported by block device. Turning off DAX.");
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 5258346c558c..a31a7e3f929b 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -40,11 +40,7 @@ static inline void put_dax(struct dax_device *dax_dev)
 
 int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
 #if IS_ENABLED(CONFIG_FS_DAX)
-int __bdev_dax_supported(struct super_block *sb, int blocksize);
-static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
-{
-	return __bdev_dax_supported(sb, blocksize);
-}
+int bdev_dax_supported(struct block_device *bdev, int blocksize);
 
 static inline struct dax_device *fs_dax_get_by_host(const char *host)
 {
@@ -58,7 +54,7 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
 
 struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
 #else
-static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
+static inline int bdev_dax_supported(struct block_device *bdev, int blocksize)
 {
 	return -EOPNOTSUPP;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
