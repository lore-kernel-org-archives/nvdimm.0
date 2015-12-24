Return-Path: <linux-ext4-owner@vger.kernel.org>
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH] ext2, ext4: include filesystem block size in error messages
Date: Wed, 23 Dec 2015 18:10:01 -0600
Message-Id: <1450915801-2320-1-git-send-email-elliott@hpe.com>
Sender: linux-ext4-owner@vger.kernel.org
To: jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca, dan.j.williams@intel.com, choleraehyq@gmail.com
Cc: david@fromorbit.com, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, Robert Elliott <elliott@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Print the problematic value in messages about the filesystem
block size.

Normalize all of the blocksize messages that use "blocksize" to
use "filesystem block size". This helps distinguish this block size
from the underlying block device's logical block size (i.e.,
sector size) and physical block size.

Example old messages:
	EXT2-fs (pmem0): unable to set blocksize
	EXT4-fs (pmem0): error: unsupported blocksize for dax
	EXT4-fs (pmem0): unsupported blocksize for fs encryption
	EXT2-fs (pmem0): bad blocksize %d

Example new message:
	EXT4-fs (pmem0): error: unsupported filesystem block size 2048 for dax

Signed-off-by: Robert Elliott <elliott@hpe.com>
---
 fs/ext2/super.c | 17 +++++++++++------
 fs/ext4/super.c | 33 ++++++++++++++++++++-------------
 2 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 748d35a..1186a5b 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -31,6 +31,7 @@
 #include <linux/mount.h>
 #include <linux/log2.h>
 #include <linux/quotaops.h>
+#include <linux/stringify.h>
 #include <asm/uaccess.h>
 #include "ext2.h"
 #include "xattr.h"
@@ -822,7 +823,9 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	 */
 	blocksize = sb_min_blocksize(sb, BLOCK_SIZE);
 	if (!blocksize) {
-		ext2_msg(sb, KERN_ERR, "error: unable to set blocksize");
+		ext2_msg(sb, KERN_ERR,
+			 "error: unable to set filesystem block size "
+			 __stringify(BLOCK_SIZE));
 		goto failed_sbi;
 	}
 
@@ -921,7 +924,8 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
 		if (blocksize != PAGE_SIZE) {
 			ext2_msg(sb, KERN_ERR,
-					"error: unsupported blocksize for dax");
+			 "error: unsupported filesystem block size %d for dax",
+				 blocksize);
 			goto failed_mount;
 		}
 		if (!sb->s_bdev->bd_disk->fops->direct_access) {
@@ -937,7 +941,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 
 		if (!sb_set_blocksize(sb, blocksize)) {
 			ext2_msg(sb, KERN_ERR,
-				"error: bad blocksize %d", blocksize);
+			 "error: bad filesystem block size %d", blocksize);
 			goto failed_sbi;
 		}
 
@@ -1007,14 +1011,15 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (sb->s_blocksize != bh->b_size) {
 		if (!silent)
-			ext2_msg(sb, KERN_ERR, "error: unsupported blocksize");
+			ext2_msg(sb, KERN_ERR,
+				 "error: unsupported filesystem block size %lu",
+				 sb->s_blocksize);
 		goto failed_mount;
 	}
 
 	if (sb->s_blocksize != sbi->s_frag_size) {
 		ext2_msg(sb, KERN_ERR,
-			"error: fragsize %lu != blocksize %lu"
-			"(not supported yet)",
+	 "error: fragsize %lu != filesystem block size %lu (not supported yet)",
 			sbi->s_frag_size, sb->s_blocksize);
 		goto failed_mount;
 	}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c9ab67d..9e1c049 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -42,6 +42,7 @@
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/stringify.h>
 
 #include "ext4.h"
 #include "ext4_extents.h"	/* Needed for trace points definition */
@@ -1750,8 +1751,9 @@ static int parse_options(char *options, struct super_block *sb,
 			BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
 
 		if (blocksize < PAGE_CACHE_SIZE) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "dioread_nolock if block size != PAGE_SIZE");
+			ext4_msg(sb, KERN_ERR,
+				"can't mount with dioread_nolock if filesystem block size %d != PAGE_SIZE",
+				blocksize);
 			return 0;
 		}
 	}
@@ -3147,7 +3149,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	ret = -EINVAL;
 	blocksize = sb_min_blocksize(sb, EXT4_MIN_BLOCK_SIZE);
 	if (!blocksize) {
-		ext4_msg(sb, KERN_ERR, "unable to set blocksize");
+		ext4_msg(sb, KERN_ERR,
+			 "unable to set filesystem block size "
+			 __stringify(EXT4_MIN_BLOCK_SIZE));
 		goto out_fail;
 	}
 
@@ -3367,14 +3371,15 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
 	    blocksize > EXT4_MAX_BLOCK_SIZE) {
 		ext4_msg(sb, KERN_ERR,
-		       "Unsupported filesystem blocksize %d", blocksize);
+			 "Unsupported filesystem block size %d", blocksize);
 		goto failed_mount;
 	}
 
 	if (sbi->s_mount_opt & EXT4_MOUNT_DAX) {
 		if (blocksize != PAGE_SIZE) {
 			ext4_msg(sb, KERN_ERR,
-					"error: unsupported blocksize for dax");
+			 "error: unsupported filesystem block size %d for dax",
+				 blocksize);
 			goto failed_mount;
 		}
 		if (!sb->s_bdev->bd_disk->fops->direct_access) {
@@ -3393,7 +3398,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (sb->s_blocksize != blocksize) {
 		/* Validate the filesystem blocksize */
 		if (!sb_set_blocksize(sb, blocksize)) {
-			ext4_msg(sb, KERN_ERR, "bad block size %d",
+			ext4_msg(sb, KERN_ERR, "bad filesystem block size %d",
 					blocksize);
 			goto failed_mount;
 		}
@@ -3495,8 +3500,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (has_bigalloc) {
 		if (clustersize < blocksize) {
 			ext4_msg(sb, KERN_ERR,
-				 "cluster size (%d) smaller than "
-				 "block size (%d)", clustersize, blocksize);
+		 "cluster size (%d) smaller than filesystem block size (%d)",
+				clustersize, blocksize);
 			goto failed_mount;
 		}
 		sbi->s_cluster_bits = le32_to_cpu(es->s_log_cluster_size) -
@@ -3519,9 +3524,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		}
 	} else {
 		if (clustersize != blocksize) {
-			ext4_warning(sb, "fragment/cluster size (%d) != "
-				     "block size (%d)", clustersize,
-				     blocksize);
+			ext4_warning(sb,
+		 "fragment/cluster size (%d) != filesystem block size (%d)",
+				     clustersize, blocksize);
 			clustersize = blocksize;
 		}
 		if (sbi->s_blocks_per_group > blocksize * 8) {
@@ -3769,7 +3774,8 @@ no_journal:
 	if ((DUMMY_ENCRYPTION_ENABLED(sbi) || ext4_has_feature_encrypt(sb)) &&
 	    (blocksize != PAGE_CACHE_SIZE)) {
 		ext4_msg(sb, KERN_ERR,
-			 "Unsupported blocksize for fs encryption");
+		 "Unsupported filesystem block size %d for fs encryption",
+			 blocksize);
 		goto failed_mount_wq;
 	}
 
@@ -4112,7 +4118,8 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 	hblock = bdev_logical_block_size(bdev);
 	if (blocksize < hblock) {
 		ext4_msg(sb, KERN_ERR,
-			"blocksize too small for journal device");
+			"filesystem block size %d too small for journal device",
+			blocksize);
 		goto out_bdev;
 	}
 
-- 
2.4.3

