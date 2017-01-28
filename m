Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69A258200F
 for <linux-nvdimm@lists.01.org>; Sat, 28 Jan 2017 00:40:47 -0800 (PST)
Subject: [RFC PATCH 07/17] brd: add dax_operations support
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Jan 2017 00:36:41 -0800
Message-ID: <148559260182.11180.12359489023506043402.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: snitzer@redhat.com, mawilcox@microsoft.com, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Setup a dax_inode to have the same lifetime as the brd block device and
add a ->direct_access() method that is equivalent to
brd_direct_access(). Once fs/dax.c has been converted to use
dax_operations the old brd_direct_access() will be removed.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/Kconfig |    1 +
 drivers/block/brd.c   |   57 +++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 223ff2fcae7e..604b51a884b6 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -337,6 +337,7 @@ config BLK_DEV_SX8
 
 config BLK_DEV_RAM
 	tristate "RAM block device support"
+	select DAX if BLK_DEV_RAM_DAX
 	---help---
 	  Saying Y here will allow you to use a portion of your RAM memory as
 	  a block device, so that you can make file systems on it, read and
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 3adc32a3153b..1279df4dc07c 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #ifdef CONFIG_BLK_DEV_RAM_DAX
 #include <linux/pfn_t.h>
+#include <linux/dax.h>
 #endif
 
 #include <linux/uaccess.h>
@@ -41,6 +42,9 @@ struct brd_device {
 
 	struct request_queue	*brd_queue;
 	struct gendisk		*brd_disk;
+#ifdef CONFIG_BLK_DEV_RAM_DAX
+	struct dax_inode	*dax_inode;
+#endif
 	struct list_head	brd_list;
 
 	/*
@@ -375,15 +379,14 @@ static int brd_rw_page(struct block_device *bdev, sector_t sector,
 }
 
 #ifdef CONFIG_BLK_DEV_RAM_DAX
-static long brd_direct_access(struct block_device *bdev, sector_t sector,
+static long __brd_direct_access(struct brd_device *brd, phys_addr_t dev_addr,
 			void **kaddr, pfn_t *pfn, long size)
 {
-	struct brd_device *brd = bdev->bd_disk->private_data;
 	struct page *page;
 
 	if (!brd)
 		return -ENODEV;
-	page = brd_insert_page(brd, sector);
+	page = brd_insert_page(brd, dev_addr / 512);
 	if (!page)
 		return -ENOSPC;
 	*kaddr = page_address(page);
@@ -391,14 +394,34 @@ static long brd_direct_access(struct block_device *bdev, sector_t sector,
 
 	return PAGE_SIZE;
 }
+
+static long brd_blk_direct_access(struct block_device *bdev, sector_t sector,
+			void **kaddr, pfn_t *pfn, long size)
+{
+	struct brd_device *brd = bdev->bd_disk->private_data;
+
+	return __brd_direct_access(brd, sector * 512, kaddr, pfn, size);
+}
+
+static long brd_dax_direct_access(struct dax_inode *dax_inode,
+		phys_addr_t dev_addr, void **kaddr, pfn_t *pfn, long size)
+{
+	struct brd_device *brd = dax_inode_get_private(dax_inode);
+
+	return __brd_direct_access(brd, dev_addr, kaddr, pfn, size);
+}
+
+static const struct dax_operations brd_dax_ops = {
+	.direct_access = brd_dax_direct_access,
+};
 #else
-#define brd_direct_access NULL
+#define brd_blk_direct_access NULL
 #endif
 
 static const struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		brd_rw_page,
-	.direct_access =	brd_direct_access,
+	.direct_access =	brd_blk_direct_access,
 };
 
 /*
@@ -441,7 +464,9 @@ static struct brd_device *brd_alloc(int i)
 {
 	struct brd_device *brd;
 	struct gendisk *disk;
-
+#ifdef CONFIG_BLK_DEV_RAM_DAX
+	struct dax_inode *dax_inode;
+#endif
 	brd = kzalloc(sizeof(*brd), GFP_KERNEL);
 	if (!brd)
 		goto out;
@@ -469,9 +494,6 @@ static struct brd_device *brd_alloc(int i)
 	blk_queue_max_discard_sectors(brd->brd_queue, UINT_MAX);
 	brd->brd_queue->limits.discard_zeroes_data = 1;
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, brd->brd_queue);
-#ifdef CONFIG_BLK_DEV_RAM_DAX
-	queue_flag_set_unlocked(QUEUE_FLAG_DAX, brd->brd_queue);
-#endif
 	disk = brd->brd_disk = alloc_disk(max_part);
 	if (!disk)
 		goto out_free_queue;
@@ -484,8 +506,21 @@ static struct brd_device *brd_alloc(int i)
 	sprintf(disk->disk_name, "ram%d", i);
 	set_capacity(disk, rd_size * 2);
 
+#ifdef CONFIG_BLK_DEV_RAM_DAX
+	queue_flag_set_unlocked(QUEUE_FLAG_DAX, brd->brd_queue);
+	dax_inode = alloc_dax_inode(brd, disk->disk_name, &brd_dax_ops);
+	if (!dax_inode)
+		goto out_free_inode;
+#endif
+
+
 	return brd;
 
+#ifdef CONFIG_BLK_DEV_RAM_DAX
+out_free_inode:
+	kill_dax_inode(dax_inode);
+	put_dax_inode(dax_inode);
+#endif
 out_free_queue:
 	blk_cleanup_queue(brd->brd_queue);
 out_free_dev:
@@ -525,6 +560,10 @@ static struct brd_device *brd_init_one(int i, bool *new)
 static void brd_del_one(struct brd_device *brd)
 {
 	list_del(&brd->brd_list);
+#ifdef CONFIG_BLK_DEV_RAM_DAX
+	kill_dax_inode(brd->dax_inode);
+	put_dax_inode(brd->dax_inode);
+#endif
 	del_gendisk(brd->brd_disk);
 	brd_free(brd);
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
