Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 19CEA21DF8079
 for <linux-nvdimm@lists.01.org>; Sun, 27 Aug 2017 20:52:32 -0700 (PDT)
Subject: [PATCH v2 2/2] ext2, ext4: use the super_block dax_device
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 27 Aug 2017 20:48:46 -0700
Message-ID: <150389212595.25151.10721705529768874001.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150389211501.25151.6477753201827914462.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150389211501.25151.6477753201827914462.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The ->iomap_begin() operation is a hot path, and now that mount_bdev()
arranges for the dax_device to be populated in the super_block, we can
just reference that attribute directly rather than perform a new lookup.

Cc: Jan Kara <jack@suse.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext2/inode.c |   10 ++--------
 fs/ext4/inode.c |   10 ++--------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 30163d007b2f..7102b77a83c6 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -800,7 +800,6 @@ int ext2_get_block(struct inode *inode, sector_t iblock,
 static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned flags, struct iomap *iomap)
 {
-	struct block_device *bdev;
 	unsigned int blkbits = inode->i_blkbits;
 	unsigned long first_block = offset >> blkbits;
 	unsigned long max_blocks = (length + (1 << blkbits) - 1) >> blkbits;
@@ -814,13 +813,9 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
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
+	iomap->dax_dev = inode->i_sb->s_daxdev;
 
 	if (ret == 0) {
 		iomap->type = IOMAP_HOLE;
@@ -842,7 +837,6 @@ static int
 ext2_iomap_end(struct inode *inode, loff_t offset, loff_t length,
 		ssize_t written, unsigned flags, struct iomap *iomap)
 {
-	fs_put_dax(iomap->dax_dev);
 	if (iomap->type == IOMAP_MAPPED &&
 	    written < length &&
 	    (flags & IOMAP_WRITE))
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c774bdc22759..311690522366 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3404,7 +3404,6 @@ static int ext4_releasepage(struct page *page, gfp_t wait)
 static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 			    unsigned flags, struct iomap *iomap)
 {
-	struct block_device *bdev;
 	unsigned int blkbits = inode->i_blkbits;
 	unsigned long first_block = offset >> blkbits;
 	unsigned long last_block = (offset + length - 1) >> blkbits;
@@ -3473,12 +3472,8 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	}
 
 	iomap->flags = 0;
-	bdev = inode->i_sb->s_bdev;
-	iomap->bdev = bdev;
-	if (blk_queue_dax(bdev->bd_queue))
-		iomap->dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
-	else
-		iomap->dax_dev = NULL;
+	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->dax_dev = inode->i_sb->s_daxdev;
 	iomap->offset = first_block << blkbits;
 
 	if (ret == 0) {
@@ -3511,7 +3506,6 @@ static int ext4_iomap_end(struct inode *inode, loff_t offset, loff_t length,
 	int blkbits = inode->i_blkbits;
 	bool truncate = false;
 
-	fs_put_dax(iomap->dax_dev);
 	if (!(flags & IOMAP_WRITE) || (flags & IOMAP_FAULT))
 		return 0;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
