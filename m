Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D85378200A
 for <linux-nvdimm@lists.01.org>; Sat, 28 Jan 2017 00:40:52 -0800 (PST)
Subject: [RFC PATCH 08/17] dcssblk: add dax_operations support
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Jan 2017 00:36:47 -0800
Message-ID: <148559260698.11180.11351610034052668852.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Setup a dax_inode to have the same lifetime as the dcssblk block device
and add a ->direct_access() method that is equivalent to
dcssblk_direct_access(). Once fs/dax.c has been converted to use
dax_operations the old dcssblk_direct_access() will be removed.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/s390/block/Kconfig   |    1 +
 drivers/s390/block/dcssblk.c |   53 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/block/Kconfig b/drivers/s390/block/Kconfig
index 4a3b62326183..0acb8c2f9475 100644
--- a/drivers/s390/block/Kconfig
+++ b/drivers/s390/block/Kconfig
@@ -14,6 +14,7 @@ config BLK_DEV_XPRAM
 
 config DCSSBLK
 	def_tristate m
+	select DAX
 	prompt "DCSSBLK support"
 	depends on S390 && BLOCK
 	help
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 9d66b4fb174b..67b0885b4d12 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/pfn_t.h>
+#include <linux/dax.h>
 #include <asm/extmem.h>
 #include <asm/io.h>
 
@@ -30,8 +31,10 @@ static int dcssblk_open(struct block_device *bdev, fmode_t mode);
 static void dcssblk_release(struct gendisk *disk, fmode_t mode);
 static blk_qc_t dcssblk_make_request(struct request_queue *q,
 						struct bio *bio);
-static long dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
+static long dcssblk_blk_direct_access(struct block_device *bdev, sector_t secnum,
 			 void **kaddr, pfn_t *pfn, long size);
+static long dcssblk_dax_direct_access(struct dax_inode *dax_inode,
+		phys_addr_t dev_addr, void **kaddr, pfn_t *pfn, long size);
 
 static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
 
@@ -40,7 +43,11 @@ static const struct block_device_operations dcssblk_devops = {
 	.owner   	= THIS_MODULE,
 	.open    	= dcssblk_open,
 	.release 	= dcssblk_release,
-	.direct_access 	= dcssblk_direct_access,
+	.direct_access 	= dcssblk_blk_direct_access,
+};
+
+static const struct dax_operations dcssblk_dax_ops = {
+	.direct_access = dcssblk_dax_direct_access,
 };
 
 struct dcssblk_dev_info {
@@ -57,6 +64,7 @@ struct dcssblk_dev_info {
 	struct request_queue *dcssblk_queue;
 	int num_of_segments;
 	struct list_head seg_list;
+	struct dax_inode *dax_inode;
 };
 
 struct segment_info {
@@ -389,6 +397,8 @@ dcssblk_shared_store(struct device *dev, struct device_attribute *attr, const ch
 	}
 	list_del(&dev_info->lh);
 
+	kill_dax_inode(dev_info->dax_inode);
+	put_dax_inode(dev_info->dax_inode);
 	del_gendisk(dev_info->gd);
 	blk_cleanup_queue(dev_info->dcssblk_queue);
 	dev_info->gd->queue = NULL;
@@ -525,6 +535,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	int rc, i, j, num_of_segments;
 	struct dcssblk_dev_info *dev_info;
 	struct segment_info *seg_info, *temp;
+	struct dax_inode *dax_inode;
 	char *local_buf;
 	unsigned long seg_byte_size;
 
@@ -654,6 +665,11 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	if (rc)
 		goto put_dev;
 
+	dax_inode = alloc_dax_inode(dev_info, dev_info->gd->disk_name,
+			&dcssblk_dax_ops);
+	if (!dax_inode)
+		goto put_dev;
+
 	get_device(&dev_info->dev);
 	device_add_disk(&dev_info->dev, dev_info->gd);
 
@@ -752,6 +768,8 @@ dcssblk_remove_store(struct device *dev, struct device_attribute *attr, const ch
 	}
 
 	list_del(&dev_info->lh);
+	kill_dax_inode(dev_info->dax_inode);
+	put_dax_inode(dev_info->dax_inode);
 	del_gendisk(dev_info->gd);
 	blk_cleanup_queue(dev_info->dcssblk_queue);
 	dev_info->gd->queue = NULL;
@@ -883,21 +901,38 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
 }
 
 static long
-dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
+__dcssblk_direct_access(struct dcssblk_dev_info *dev_info, phys_addr_t offset,
+		void **kaddr, pfn_t *pfn, long size)
+{
+	unsigned long dev_sz;
+
+	dev_sz = dev_info->end - dev_info->start;
+	*kaddr = (void *) dev_info->start + offset;
+	*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset), PFN_DEV);
+
+	return dev_sz - offset;
+}
+
+static long
+dcssblk_blk_direct_access(struct block_device *bdev, sector_t secnum,
 			void **kaddr, pfn_t *pfn, long size)
 {
 	struct dcssblk_dev_info *dev_info;
-	unsigned long offset, dev_sz;
 
 	dev_info = bdev->bd_disk->private_data;
 	if (!dev_info)
 		return -ENODEV;
-	dev_sz = dev_info->end - dev_info->start;
-	offset = secnum * 512;
-	*kaddr = (void *) dev_info->start + offset;
-	*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset), PFN_DEV);
+	return __dcssblk_direct_access(dev_info, secnum * 512, kaddr, pfn,
+			size);
+}
 
-	return dev_sz - offset;
+static long
+dcssblk_dax_direct_access(struct dax_inode *dax_inode, phys_addr_t dev_addr,
+			void **kaddr, pfn_t *pfn, long size)
+{
+	struct dcssblk_dev_info *dev_info = dax_inode_get_private(dax_inode);
+
+	return __dcssblk_direct_access(dev_info, dev_addr, kaddr, pfn, size);
 }
 
 static void

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
