Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 163F0222DE126
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 16:32:34 -0800 (PST)
Subject: [PATCH v3 2/3] dax: change bdev_dax_supported() to support boolean
 returns
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 08 Feb 2018 17:38:19 -0700
Message-ID: <151813669915.15926.5489252461577531.stgit@djiang5-desk3.ch.intel.com>
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

The function return values are confusing with the way the function is
named. We expect a true or false return value but it actually returns
0/-errno.  This makes the code very confusing. Changing the return values
to return a bool where if DAX is supported then return true and no DAX
support returns false.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/super.c |   18 +++++++++---------
 fs/ext2/super.c     |    5 +++--
 fs/ext4/super.c     |    5 +++--
 fs/xfs/xfs_ioctl.c  |    4 ++--
 fs/xfs/xfs_super.c  |   10 +++++-----
 include/linux/dax.h |   12 ++++++------
 6 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index c4db84f26c0f..ef008e384042 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -80,9 +80,9 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
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
@@ -95,21 +95,21 @@ int bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
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
@@ -121,10 +121,10 @@ int bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
 	if (len < 1) {
 		pr_debug("VFS (%s): error: dax access failed (%ld)\n",
 				sb->s_id, len);
-		return len < 0 ? len : -EIO;
+		return false;
 	}
 
-	return 0;
+	return true;
 }
 EXPORT_SYMBOL_GPL(bdev_dax_supported);
 #endif
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 655699321c45..636b9c5e1bff 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -958,9 +958,10 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
 
 	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
-		err = sb_dax_supported(sb, blocksize);
-		if (err)
+		if(!sb_dax_supported(sb, blocksize)) {
+			err = -EIO;
 			goto failed_mount;
+		}
 	}
 
 	/* If the blocksize doesn't match, re-read the thing.. */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 804a2d6729af..7b7650ac9c53 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3712,9 +3712,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 					" that may contain inline data");
 			goto failed_mount;
 		}
-		err = sb_dax_supported(sb, blocksize);
-		if (err)
+		if (!sb_dax_supported(sb, blocksize)) {
+			err = -EIO;
 			goto failed_mount;
+		}
 	}
 
 	if (ext4_has_feature_encrypt(sb) && es->s_encryption_level) {
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f9d3f4314f7c..e440d789ed1b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1102,8 +1102,8 @@ xfs_ioctl_setattr_dax_invalidate(
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
index 5fd60c1fa9db..39b2295bf646 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1649,18 +1649,18 @@ xfs_fs_fill_super(
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
index 1107a980f5c3..ee962705fffb 100644
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
