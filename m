Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E6C22095BB86
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 12:50:23 -0700 (PDT)
Subject: [PATCH v3 3/4] ext2: perform dax_device lookup at mount
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 30 Aug 2017 12:44:03 -0700
Message-ID: <150412224334.10177.12994820445044936627.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150412222686.10177.8031279869867070772.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150412222686.10177.8031279869867070772.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The ->iomap_begin() operation is a hot path, so cache the
fs_dax_get_by_host() result at mount time to avoid the incurring the
hash lookup overhead on a per-i/o basis.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext2/ext2.h  |    1 +
 fs/ext2/inode.c |   11 +++--------
 fs/ext2/super.c |    5 +++++
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 23ebb92484c6..28de3edd4f4d 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -114,6 +114,7 @@ struct ext2_sb_info {
 	 */
 	spinlock_t s_lock;
 	struct mb_cache *s_ea_block_cache;
+	struct dax_device *s_daxdev;
 };
 
 static inline spinlock_t *
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 30163d007b2f..4dca6f348714 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -800,10 +800,10 @@ int ext2_get_block(struct inode *inode, sector_t iblock,
 static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned flags, struct iomap *iomap)
 {
-	struct block_device *bdev;
 	unsigned int blkbits = inode->i_blkbits;
 	unsigned long first_block = offset >> blkbits;
 	unsigned long max_blocks = (length + (1 << blkbits) - 1) >> blkbits;
+	struct ext2_sb_info *sbi = EXT2_SB(inode->i_sb);
 	bool new = false, boundary = false;
 	u32 bno;
 	int ret;
@@ -814,13 +814,9 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		return ret;
 
 	iomap->flags = 0;
-	bdev = inode->i_sb->s_bdev;
-	iomap->bdev = bdev;
+	iomap->bdev = inode->i_sb->s_bdev;
 	iomap->offset = (u64)first_block << blkbits;
-	if (blk_queue_dax(bdev->bd_queue))
-		iomap->dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
-	else
-		iomap->dax_dev = NULL;
+	iomap->dax_dev = sbi->s_daxdev;
 
 	if (ret == 0) {
 		iomap->type = IOMAP_HOLE;
@@ -842,7 +838,6 @@ static int
 ext2_iomap_end(struct inode *inode, loff_t offset, loff_t length,
 		ssize_t written, unsigned flags, struct iomap *iomap)
 {
-	fs_put_dax(iomap->dax_dev);
 	if (iomap->type == IOMAP_MAPPED &&
 	    written < length &&
 	    (flags & IOMAP_WRITE))
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 7b1bc9059863..d9dd999568c2 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -144,6 +144,7 @@ static void ext2_put_super (struct super_block * sb)
 	int db_count;
 	int i;
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
+	struct dax_device *dax_dev = sbi->s_daxdev;
 
 	ext2_quota_off_umount(sb);
 
@@ -172,6 +173,7 @@ static void ext2_put_super (struct super_block * sb)
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
+	fs_put_dax(dax_dev);
 }
 
 static struct kmem_cache * ext2_inode_cachep;
@@ -813,6 +815,7 @@ static unsigned long descriptor_loc(struct super_block *sb,
 
 static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 {
+	struct dax_device *dax_dev = fs_dax_get_by_bdev(sb->s_bdev);
 	struct buffer_head * bh;
 	struct ext2_sb_info * sbi;
 	struct ext2_super_block * es;
@@ -842,6 +845,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	sb->s_fs_info = sbi;
 	sbi->s_sb_block = sb_block;
+	sbi->s_daxdev = dax_dev;
 
 	spin_lock_init(&sbi->s_lock);
 
@@ -1200,6 +1204,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 failed:
+	fs_put_dax(dax_dev);
 	return ret;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
