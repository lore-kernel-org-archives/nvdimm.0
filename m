Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9BB7621A04830
 for <linux-nvdimm@lists.01.org>; Wed, 19 Apr 2017 15:38:22 -0700 (PDT)
Subject: [PATCH v3] dcssblk: add dax_operations support
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Apr 2017 15:32:38 -0700
Message-ID: <149264113824.36586.1220609927071019352.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

Setup a dax_dev to have the same lifetime as the dcssblk block device
and add a ->direct_access() method that is equivalent to
dcssblk_direct_access(). Once fs/dax.c has been converted to use
dax_operations the old dcssblk_direct_access() will be removed.

Reported-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v2:
* fix return code in the alloc_dax() failure case (Gerald)
* assign dax_dev to dev_info and kill local variable (Gerald)

 drivers/s390/block/Kconfig   |    1 +
 drivers/s390/block/dcssblk.c |   55 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 47 insertions(+), 9 deletions(-)

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
index 415d10a67b7a..dc84cfd4e438 100644
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
+static long dcssblk_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn);
 
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
+	struct dax_device *dax_dev;
 };
 
 struct segment_info {
@@ -389,6 +397,8 @@ dcssblk_shared_store(struct device *dev, struct device_attribute *attr, const ch
 	}
 	list_del(&dev_info->lh);
 
+	kill_dax(dev_info->dax_dev);
+	put_dax(dev_info->dax_dev);
 	del_gendisk(dev_info->gd);
 	blk_cleanup_queue(dev_info->dcssblk_queue);
 	dev_info->gd->queue = NULL;
@@ -654,6 +664,13 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	if (rc)
 		goto put_dev;
 
+	dev_info->dax_dev = alloc_dax(dev_info, dev_info->gd->disk_name,
+			&dcssblk_dax_ops);
+	if (!dev_info->dax_dev) {
+		rc = -ENOMEM;
+		goto put_dev;
+	}
+
 	get_device(&dev_info->dev);
 	device_add_disk(&dev_info->dev, dev_info->gd);
 
@@ -752,6 +769,8 @@ dcssblk_remove_store(struct device *dev, struct device_attribute *attr, const ch
 	}
 
 	list_del(&dev_info->lh);
+	kill_dax(dev_info->dax_dev);
+	put_dax(dev_info->dax_dev);
 	del_gendisk(dev_info->gd);
 	blk_cleanup_queue(dev_info->dcssblk_queue);
 	dev_info->gd->queue = NULL;
@@ -883,21 +902,39 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
 }
 
 static long
-dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
+__dcssblk_direct_access(struct dcssblk_dev_info *dev_info, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn)
+{
+	resource_size_t offset = pgoff * PAGE_SIZE;
+	unsigned long dev_sz;
+
+	dev_sz = dev_info->end - dev_info->start + 1;
+	*kaddr = (void *) dev_info->start + offset;
+	*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset), PFN_DEV);
+
+	return (dev_sz - offset) / PAGE_SIZE;
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
-	dev_sz = dev_info->end - dev_info->start + 1;
-	offset = secnum * 512;
-	*kaddr = (void *) dev_info->start + offset;
-	*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset), PFN_DEV);
+	return __dcssblk_direct_access(dev_info, PHYS_PFN(secnum * 512),
+			PHYS_PFN(size), kaddr, pfn) * PAGE_SIZE;
+}
+
+static long
+dcssblk_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn)
+{
+	struct dcssblk_dev_info *dev_info = dax_get_private(dax_dev);
 
-	return dev_sz - offset;
+	return __dcssblk_direct_access(dev_info, pgoff, nr_pages, kaddr, pfn);
 }
 
 static void

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
