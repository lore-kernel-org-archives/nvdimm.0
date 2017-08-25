Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AE76F21DFC897
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 17:39:42 -0700 (PDT)
Subject: [PATCH 2/2] ext2, ext4: cache dax_device lookup result
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Aug 2017 17:35:53 -0700
Message-ID: <150362135374.39142.4099127163740487151.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150362134292.39142.1715377949592729029.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150362134292.39142.1715377949592729029.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The ->iomap_begin() operation is a hot path, so cache the
fs_dax_get_by_host() result to avoid the incurring the hash lookup
overhead.

Cc: Jan Kara <jack@suse.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext2/inode.c    |   11 +++++++----
 fs/ext4/inode.c    |   11 +++++++----
 include/linux/fs.h |    3 +++
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 30163d007b2f..910e6d502137 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -801,6 +801,7 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned flags, struct iomap *iomap)
 {
 	struct block_device *bdev;
+	struct dax_device *dax_dev;
 	unsigned int blkbits = inode->i_blkbits;
 	unsigned long first_block = offset >> blkbits;
 	unsigned long max_blocks = (length + (1 << blkbits) - 1) >> blkbits;
@@ -817,10 +818,12 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	bdev = inode->i_sb->s_bdev;
 	iomap->bdev = bdev;
 	iomap->offset = (u64)first_block << blkbits;
-	if (blk_queue_dax(bdev->bd_queue))
-		iomap->dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
-	else
-		iomap->dax_dev = NULL;
+	dax_dev = inode->i_sb->s_daxdev;
+	if (blk_queue_dax(bdev->bd_queue) && !dax_dev) {
+		dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
+		inode->i_sb->s_daxdev = dax_dev;
+	}
+	iomap->dax_dev = dax_dev;
 
 	if (ret == 0) {
 		iomap->type = IOMAP_HOLE;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c774bdc22759..36a4bcab9e0c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3405,6 +3405,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 			    unsigned flags, struct iomap *iomap)
 {
 	struct block_device *bdev;
+	struct dax_device *dax_dev;
 	unsigned int blkbits = inode->i_blkbits;
 	unsigned long first_block = offset >> blkbits;
 	unsigned long last_block = (offset + length - 1) >> blkbits;
@@ -3475,10 +3476,12 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	iomap->flags = 0;
 	bdev = inode->i_sb->s_bdev;
 	iomap->bdev = bdev;
-	if (blk_queue_dax(bdev->bd_queue))
-		iomap->dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
-	else
-		iomap->dax_dev = NULL;
+	dax_dev = inode->i_sb->s_daxdev;
+	if (blk_queue_dax(bdev->bd_queue) && !dax_dev) {
+		dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
+		inode->i_sb->s_daxdev = dax_dev;
+	}
+	iomap->dax_dev = dax_dev;
 	iomap->offset = first_block << blkbits;
 
 	if (ret == 0) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6e1fd5d21248..0594867a172a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1334,6 +1334,9 @@ struct super_block {
 	struct hlist_bl_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct list_head	s_mounts;	/* list of mounts; _not_ for fs use */
 	struct block_device	*s_bdev;
+#ifdef CONFIG_FS_DAX
+	struct dax_device	*s_daxdev;	/* cached dax_device */
+#endif
 	struct backing_dev_info *s_bdi;
 	struct mtd_info		*s_mtd;
 	struct hlist_node	s_instances;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
