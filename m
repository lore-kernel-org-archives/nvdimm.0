Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH 10/15] libnvdimm: fix up max_hw_sectors
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:55:41 -0400
Message-ID: <20150617235541.12943.86562.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-nvdimm@lists.01.org
Cc: boaz@plexistor.com, toshi.kani@hp.com, Vishal Verma <vishal.l.verma@linux.intel.com>, linux-kernel@vger.kernel.org, hch@lst.de, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

There is no hardware limit to enforce on the size of the i/o that can be
passed to nd block device, so set it to UINT_MAX.  Do this centrally for
all nd block devices in nd_blk_queue_init();

Reviewed-by: Vishal Verma <vishal.l.verma@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/blk.c  |    3 +--
 drivers/nvdimm/btt.c  |    3 +--
 drivers/nvdimm/core.c |    7 +++++++
 drivers/nvdimm/nd.h   |    1 +
 drivers/nvdimm/pmem.c |    3 +--
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index feddad325f97..8a6345797a71 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -272,9 +272,8 @@ static int nd_blk_probe(struct device *dev)
 	}
 
 	blk_queue_make_request(blk_dev->queue, nd_blk_make_request);
-	blk_queue_max_hw_sectors(blk_dev->queue, 1024);
-	blk_queue_bounce_limit(blk_dev->queue, BLK_BOUNCE_ANY);
 	blk_queue_logical_block_size(blk_dev->queue, blk_dev->sector_size);
+	nd_blk_queue_init(blk_dev->queue);
 
 	disk = blk_dev->disk = alloc_disk(0);
 	if (!disk) {
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index c337b7abfb43..380e01cedd24 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1285,9 +1285,8 @@ static int btt_blk_init(struct btt *btt)
 	btt->btt_disk->flags = GENHD_FL_EXT_DEVT;
 
 	blk_queue_make_request(btt->btt_queue, btt_make_request);
-	blk_queue_max_hw_sectors(btt->btt_queue, 1024);
-	blk_queue_bounce_limit(btt->btt_queue, BLK_BOUNCE_ANY);
 	blk_queue_logical_block_size(btt->btt_queue, btt->sector_size);
+	nd_blk_queue_init(btt->btt_queue);
 	btt->btt_queue->queuedata = btt;
 
 	set_capacity(btt->btt_disk, 0);
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 8f466c384b30..d27b13357873 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -214,6 +214,13 @@ ssize_t nd_sector_size_store(struct device *dev, const char *buf,
 	}
 }
 
+void nd_blk_queue_init(struct request_queue *q)
+{
+	blk_queue_max_hw_sectors(q, UINT_MAX);
+	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
+}
+EXPORT_SYMBOL(nd_blk_queue_init);
+
 static ssize_t commands_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 9b5fdb2215b1..2f20d5dca028 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -171,5 +171,6 @@ struct resource *nvdimm_allocate_dpa(struct nvdimm_drvdata *ndd,
 		struct nd_label_id *label_id, resource_size_t start,
 		resource_size_t n);
 int nd_blk_region_init(struct nd_region *nd_region);
+void nd_blk_queue_init(struct request_queue *q);
 resource_size_t nd_namespace_blk_validate(struct nd_namespace_blk *nsblk);
 #endif /* __ND_H__ */
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 1f4767150975..b825a2201aa8 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -172,8 +172,7 @@ static struct pmem_device *pmem_alloc(struct device *dev,
 		goto out_unmap;
 
 	blk_queue_make_request(pmem->pmem_queue, pmem_make_request);
-	blk_queue_max_hw_sectors(pmem->pmem_queue, 1024);
-	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
+	nd_blk_queue_init(pmem->pmem_queue);
 
 	disk = alloc_disk(0);
 	if (!disk)

