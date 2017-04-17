Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D43772194EB6E
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 12:15:44 -0700 (PDT)
Subject: [resend PATCH v2 13/33] ext2, ext4,
 xfs: retrieve dax_device for iomap operations
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Apr 2017 12:09:59 -0700
Message-ID: <149245619928.10206.4104560527846554979.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

In preparation for converting fs/dax.c to use dax_direct_access()
instead of bdev_direct_access(), add the plumbing to retrieve the
dax_device associated with a given block_device.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext2/inode.c       |    9 ++++++++-
 fs/ext4/inode.c       |    9 ++++++++-
 fs/xfs/xfs_iomap.c    |   10 ++++++++++
 include/linux/iomap.h |    1 +
 4 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 128cce540645..4c9d2d44e879 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -799,6 +799,7 @@ int ext2_get_block(struct inode *inode, sector_t iblock,
 static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned flags, struct iomap *iomap)
 {
+	struct block_device *bdev;
 	unsigned int blkbits = inode->i_blkbits;
 	unsigned long first_block = offset >> blkbits;
 	unsigned long max_blocks = (length + (1 << blkbits) - 1) >> blkbits;
@@ -812,8 +813,13 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		return ret;
 
 	iomap->flags = 0;
-	iomap->bdev = inode->i_sb->s_bdev;
+	bdev = inode->i_sb->s_bdev;
+	iomap->bdev = bdev;
 	iomap->offset = (u64)first_block << blkbits;
+	if (blk_queue_dax(bdev->bd_queue))
+		iomap->dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
+	else
+		iomap->dax_dev = NULL;
 
 	if (ret == 0) {
 		iomap->type = IOMAP_HOLE;
@@ -835,6 +841,7 @@ static int
 ext2_iomap_end(struct inode *inode, loff_t offset, loff_t length,
 		ssize_t written, unsigned flags, struct iomap *iomap)
 {
+	put_dax(iomap->dax_dev);
 	if (iomap->type == IOMAP_MAPPED &&
 	    written < length &&
 	    (flags & IOMAP_WRITE))
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4247d8d25687..2cb2634daa99 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3305,6 +3305,7 @@ static int ext4_releasepage(struct page *page, gfp_t wait)
 static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 			    unsigned flags, struct iomap *iomap)
 {
+	struct block_device *bdev;
 	unsigned int blkbits = inode->i_blkbits;
 	unsigned long first_block = offset >> blkbits;
 	unsigned long last_block = (offset + length - 1) >> blkbits;
@@ -3373,7 +3374,12 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	}
 
 	iomap->flags = 0;
-	iomap->bdev = inode->i_sb->s_bdev;
+	bdev = inode->i_sb->s_bdev;
+	iomap->bdev = bdev;
+	if (blk_queue_dax(bdev->bd_queue))
+		iomap->dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
+	else
+		iomap->dax_dev = NULL;
 	iomap->offset = first_block << blkbits;
 
 	if (ret == 0) {
@@ -3406,6 +3412,7 @@ static int ext4_iomap_end(struct inode *inode, loff_t offset, loff_t length,
 	int blkbits = inode->i_blkbits;
 	bool truncate = false;
 
+	put_dax(iomap->dax_dev);
 	if (!(flags & IOMAP_WRITE) || (flags & IOMAP_FAULT))
 		return 0;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 288ee5b840d7..4b47403f8089 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -976,6 +976,7 @@ xfs_file_iomap_begin(
 	int			nimaps = 1, error = 0;
 	bool			shared = false, trimmed = false;
 	unsigned		lockmode;
+	struct block_device	*bdev;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
@@ -1063,6 +1064,14 @@ xfs_file_iomap_begin(
 	}
 
 	xfs_bmbt_to_iomap(ip, iomap, &imap);
+
+	/* optionally associate a dax device with the iomap bdev */
+	bdev = iomap->bdev;
+	if (blk_queue_dax(bdev->bd_queue))
+		iomap->dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
+	else
+		iomap->dax_dev = NULL;
+
 	if (shared)
 		iomap->flags |= IOMAP_F_SHARED;
 	return 0;
@@ -1140,6 +1149,7 @@ xfs_file_iomap_end(
 	unsigned		flags,
 	struct iomap		*iomap)
 {
+	put_dax(iomap->dax_dev);
 	if ((flags & IOMAP_WRITE) && iomap->type == IOMAP_DELALLOC)
 		return xfs_file_iomap_end_delalloc(XFS_I(inode), offset,
 				length, written, iomap);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 7291810067eb..f753e788da31 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -41,6 +41,7 @@ struct iomap {
 	u16			type;	/* type of mapping */
 	u16			flags;	/* flags for mapping */
 	struct block_device	*bdev;	/* block device for I/O */
+	struct dax_device	*dax_dev; /* dax_dev for dax operations */
 };
 
 /*

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
