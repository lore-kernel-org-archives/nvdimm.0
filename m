Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 520301A1ED4
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 18:27:01 -0700 (PDT)
Subject: [PATCH 07/13] libnvdimm, pmem: use ->queuedata for driver private data
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Mar 2016 18:25:58 -0700
Message-ID: <20160324012558.21436.93381.stgit@dwillia2-desk3.jf.intel.com>
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
 drivers/nvdimm/pmem.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 1e492c66d105..ff336dd26064 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -121,8 +121,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 	unsigned long start;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
-	struct block_device *bdev = bio->bi_bdev;
-	struct pmem_device *pmem = bdev->bd_disk->private_data;
+	struct pmem_device *pmem = q->queuedata;
 
 	do_acct = nd_iostat_start(bio, &start);
 	bio_for_each_segment(bvec, bio, iter) {
@@ -147,7 +146,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 		       struct page *page, int rw)
 {
-	struct pmem_device *pmem = bdev->bd_disk->private_data;
+	struct pmem_device *pmem = bdev->bd_queue->queuedata;
 	int rc;
 
 	rc = pmem_do_bvec(pmem, page, PAGE_CACHE_SIZE, 0, rw, sector);
@@ -169,7 +168,7 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 static long pmem_direct_access(struct block_device *bdev, sector_t sector,
 		      void __pmem **kaddr, pfn_t *pfn)
 {
-	struct pmem_device *pmem = bdev->bd_disk->private_data;
+	struct pmem_device *pmem = bdev->bd_queue->queuedata;
 	resource_size_t offset = sector * 512 + pmem->data_offset;
 
 	*kaddr = pmem->virt_addr + offset;
@@ -253,6 +252,7 @@ static int pmem_attach_disk(struct device *dev,
 	blk_queue_max_hw_sectors(pmem->pmem_queue, UINT_MAX);
 	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, pmem->pmem_queue);
+	pmem->pmem_queue->queuedata = pmem;
 
 	disk = alloc_disk_node(0, nid);
 	if (!disk) {
@@ -261,7 +261,6 @@ static int pmem_attach_disk(struct device *dev,
 	}
 
 	disk->fops		= &pmem_fops;
-	disk->private_data	= pmem;
 	disk->queue		= pmem->pmem_queue;
 	disk->flags		= GENHD_FL_EXT_DEVT;
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
