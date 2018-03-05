Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C7052228353F
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 15:50:16 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] libnvdimm, {btt, blk}: do integrity setup before add_disk()
Date: Mon,  5 Mar 2018 16:56:13 -0700
Message-Id: <20180305235613.9688-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Dariusz Dokupil <dariusz.dokupil@intel.com>, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Prior to 25520d55cdb6 ("block: Inline blk_integrity in struct gendisk")
we needed to temporarily add a zero-capacity disk before registering for
blk-integrity. But adding a zero-capacity disk caused the partition
table scanning to bail early, and this resulted in partitions not coming
up after a probe of the BTT or blk namespaces.

We can now register for integrity before the disk has been added, and
this fixes the rescan problems.

Fixes: 25520d55cdb6 ("block: Inline blk_integrity in struct gendisk")
Reported-by: Dariusz Dokupil <dariusz.dokupil@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/blk.c | 3 +--
 drivers/nvdimm/btt.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 345acca576b3..1bd7b3734751 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -278,8 +278,6 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 	disk->queue		= q;
 	disk->flags		= GENHD_FL_EXT_DEVT;
 	nvdimm_namespace_disk_name(&nsblk->common, disk->disk_name);
-	set_capacity(disk, 0);
-	device_add_disk(dev, disk);
 
 	if (devm_add_action_or_reset(dev, nd_blk_release_disk, disk))
 		return -ENOMEM;
@@ -292,6 +290,7 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 	}
 
 	set_capacity(disk, available_disk_size >> SECTOR_SHIFT);
+	device_add_disk(dev, disk);
 	revalidate_disk(disk);
 	return 0;
 }
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 2ef544f10ec8..4b95ac513de2 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1545,8 +1545,6 @@ static int btt_blk_init(struct btt *btt)
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, btt->btt_queue);
 	btt->btt_queue->queuedata = btt;
 
-	set_capacity(btt->btt_disk, 0);
-	device_add_disk(&btt->nd_btt->dev, btt->btt_disk);
 	if (btt_meta_size(btt)) {
 		int rc = nd_integrity_init(btt->btt_disk, btt_meta_size(btt));
 
@@ -1558,6 +1556,7 @@ static int btt_blk_init(struct btt *btt)
 		}
 	}
 	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
+	device_add_disk(&btt->nd_btt->dev, btt->btt_disk);
 	btt->nd_btt->size = btt->nlba * (u64)btt->sector_size;
 	revalidate_disk(btt->btt_disk);
 
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
