Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id DBD8F1A1EDC
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 18:26:50 -0700 (PDT)
Subject: [PATCH 05/13] libnvdimm,
 blk: use devm_add_action to release bdev resources
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Mar 2016 18:25:47 -0700
Message-ID: <20160324012547.21436.51123.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
References: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Register a callback to clean up the request_queue and put the gendisk at
driver disable time.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/blk.c |   77 +++++++++++++++++++++++---------------------------
 1 file changed, 36 insertions(+), 41 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index c8215dc356cc..27ff32a5e9cf 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -22,8 +22,6 @@
 #include "nd.h"
 
 struct nd_blk_device {
-	struct request_queue *queue;
-	struct gendisk *disk;
 	struct nd_namespace_blk *nsblk;
 	struct nd_blk_region *ndbr;
 	size_t disk_size;
@@ -235,29 +233,47 @@ static const struct block_device_operations nd_blk_fops = {
 	.revalidate_disk = nvdimm_revalidate_disk,
 };
 
-static int nd_blk_attach_disk(struct nd_namespace_common *ndns,
-		struct nd_blk_device *blk_dev)
+static void nd_blk_release_queue(void *q)
+{
+	blk_cleanup_queue(q);
+}
+
+static void nd_blk_release_disk(void *disk)
+{
+	del_gendisk(disk);
+	put_disk(disk);
+}
+
+static int nd_blk_attach_disk(struct device *dev,
+		struct nd_namespace_common *ndns, struct nd_blk_device *blk_dev)
 {
 	resource_size_t available_disk_size;
+	struct request_queue *q;
 	struct gendisk *disk;
 	u64 internal_nlba;
 
 	internal_nlba = div_u64(blk_dev->disk_size, blk_dev->internal_lbasize);
 	available_disk_size = internal_nlba * blk_dev->sector_size;
 
-	blk_dev->queue = blk_alloc_queue(GFP_KERNEL);
-	if (!blk_dev->queue)
+	q = blk_alloc_queue(GFP_KERNEL);
+	if (!q)
+		return -ENOMEM;
+	if (devm_add_action(dev, nd_blk_release_queue, q)) {
+		blk_cleanup_queue(q);
 		return -ENOMEM;
+	}
 
-	blk_queue_make_request(blk_dev->queue, nd_blk_make_request);
-	blk_queue_max_hw_sectors(blk_dev->queue, UINT_MAX);
-	blk_queue_bounce_limit(blk_dev->queue, BLK_BOUNCE_ANY);
-	blk_queue_logical_block_size(blk_dev->queue, blk_dev->sector_size);
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, blk_dev->queue);
+	blk_queue_make_request(q, nd_blk_make_request);
+	blk_queue_max_hw_sectors(q, UINT_MAX);
+	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
+	blk_queue_logical_block_size(q, blk_dev->sector_size);
+	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
 
-	disk = blk_dev->disk = alloc_disk(0);
-	if (!disk) {
-		blk_cleanup_queue(blk_dev->queue);
+	disk = alloc_disk(0);
+	if (!disk)
+		return -ENOMEM;
+	if (devm_add_action(dev, nd_blk_release_disk, disk)) {
+		put_disk(disk);
 		return -ENOMEM;
 	}
 
@@ -265,7 +281,7 @@ static int nd_blk_attach_disk(struct nd_namespace_common *ndns,
 	disk->first_minor	= 0;
 	disk->fops		= &nd_blk_fops;
 	disk->private_data	= blk_dev;
-	disk->queue		= blk_dev->queue;
+	disk->queue		= q;
 	disk->flags		= GENHD_FL_EXT_DEVT;
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, 0);
@@ -274,12 +290,8 @@ static int nd_blk_attach_disk(struct nd_namespace_common *ndns,
 	if (nd_blk_meta_size(blk_dev)) {
 		int rc = nd_integrity_init(disk, nd_blk_meta_size(blk_dev));
 
-		if (rc) {
-			del_gendisk(disk);
-			put_disk(disk);
-			blk_cleanup_queue(blk_dev->queue);
+		if (rc)
 			return rc;
-		}
 	}
 
 	set_capacity(disk, available_disk_size >> SECTOR_SHIFT);
@@ -292,13 +304,12 @@ static int nd_blk_probe(struct device *dev)
 	struct nd_namespace_common *ndns;
 	struct nd_namespace_blk *nsblk;
 	struct nd_blk_device *blk_dev;
-	int rc;
 
 	ndns = nvdimm_namespace_common_probe(dev);
 	if (IS_ERR(ndns))
 		return PTR_ERR(ndns);
 
-	blk_dev = kzalloc(sizeof(*blk_dev), GFP_KERNEL);
+	blk_dev = devm_kzalloc(dev, sizeof(*blk_dev), GFP_KERNEL);
 	if (!blk_dev)
 		return -ENOMEM;
 
@@ -313,34 +324,18 @@ static int nd_blk_probe(struct device *dev)
 
 	ndns->rw_bytes = nd_blk_rw_bytes;
 	if (is_nd_btt(dev))
-		rc = nvdimm_namespace_attach_btt(ndns);
+		return nvdimm_namespace_attach_btt(ndns);
 	else if (nd_btt_probe(dev, ndns, blk_dev) == 0) {
 		/* we'll come back as btt-blk */
-		rc = -ENXIO;
+		return -ENXIO;
 	} else
-		rc = nd_blk_attach_disk(ndns, blk_dev);
-	if (rc)
-		kfree(blk_dev);
-	return rc;
-}
-
-static void nd_blk_detach_disk(struct nd_blk_device *blk_dev)
-{
-	del_gendisk(blk_dev->disk);
-	put_disk(blk_dev->disk);
-	blk_cleanup_queue(blk_dev->queue);
+		return nd_blk_attach_disk(dev, ndns, blk_dev);
 }
 
 static int nd_blk_remove(struct device *dev)
 {
-	struct nd_blk_device *blk_dev = dev_get_drvdata(dev);
-
 	if (is_nd_btt(dev))
 		nvdimm_namespace_detach_btt(to_nd_btt(dev));
-	else
-		nd_blk_detach_disk(blk_dev);
-	kfree(blk_dev);
-
 	return 0;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
