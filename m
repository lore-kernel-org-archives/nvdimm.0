Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 11A5F1A1EE0
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 18:26:56 -0700 (PDT)
Subject: [PATCH 06/13] libnvdimm, blk: use ->queuedata for driver private data
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Mar 2016 18:25:52 -0700
Message-ID: <20160324012552.21436.81489.stgit@dwillia2-desk3.jf.intel.com>
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

Save a pointer chase by storing the driver private data in the
request_queue rather than the gendisk.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/blk.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 27ff32a5e9cf..c8635b3d88a8 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -159,8 +159,6 @@ static int nd_blk_do_bvec(struct nd_blk_device *blk_dev,
 
 static blk_qc_t nd_blk_make_request(struct request_queue *q, struct bio *bio)
 {
-	struct block_device *bdev = bio->bi_bdev;
-	struct gendisk *disk = bdev->bd_disk;
 	struct bio_integrity_payload *bip;
 	struct nd_blk_device *blk_dev;
 	struct bvec_iter iter;
@@ -181,7 +179,7 @@ static blk_qc_t nd_blk_make_request(struct request_queue *q, struct bio *bio)
 	}
 
 	bip = bio_integrity(bio);
-	blk_dev = disk->private_data;
+	blk_dev = q->queuedata;
 	rw = bio_data_dir(bio);
 	do_acct = nd_iostat_start(bio, &start);
 	bio_for_each_segment(bvec, bio, iter) {
@@ -268,6 +266,7 @@ static int nd_blk_attach_disk(struct device *dev,
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
 	blk_queue_logical_block_size(q, blk_dev->sector_size);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
+	q->queuedata = blk_dev;
 
 	disk = alloc_disk(0);
 	if (!disk)
@@ -280,7 +279,6 @@ static int nd_blk_attach_disk(struct device *dev,
 	disk->driverfs_dev	= &ndns->dev;
 	disk->first_minor	= 0;
 	disk->fops		= &nd_blk_fops;
-	disk->private_data	= blk_dev;
 	disk->queue		= q;
 	disk->flags		= GENHD_FL_EXT_DEVT;
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
