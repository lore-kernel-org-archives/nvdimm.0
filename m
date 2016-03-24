Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 856711A1E04
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 18:27:32 -0700 (PDT)
Subject: [PATCH 13/13] libnvdimm, pmem: kill ->pmem_queue and ->pmem_disk
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Mar 2016 18:26:29 -0700
Message-ID: <20160324012629.21436.58603.stgit@dwillia2-desk3.jf.intel.com>
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

The devm conversion obviates the need to continue to remember the queue
and disk locally in the driver.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 616a16cd655b..0cd7c6529497 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -33,9 +33,6 @@
 #include "nd.h"
 
 struct pmem_device {
-	struct request_queue	*pmem_queue;
-	struct gendisk		*pmem_disk;
-
 	/* One contiguous memory region per device */
 	phys_addr_t		phys_addr;
 	/* when non-zero this device is hosting a 'pfn' instance */
@@ -52,7 +49,7 @@ struct pmem_device {
 static void pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 		unsigned int len)
 {
-	struct device *dev = disk_to_dev(pmem->pmem_disk);
+	struct device *dev = pmem->bb.dev;
 	sector_t sector;
 	long cleared;
 
@@ -227,7 +224,6 @@ static int pmem_attach_disk(struct device *dev,
 	q = blk_alloc_queue_node(GFP_KERNEL, dev_to_node(dev));
 	if (!q)
 		return -ENOMEM;
-	pmem->pmem_queue = q;
 
 	pmem->pfn_flags = PFN_DEV;
 	if (is_nd_pfn(dev)) {
@@ -260,12 +256,12 @@ static int pmem_attach_disk(struct device *dev,
 		return PTR_ERR(addr);
 	pmem->virt_addr = (void __pmem *) addr;
 
-	blk_queue_make_request(pmem->pmem_queue, pmem_make_request);
-	blk_queue_physical_block_size(pmem->pmem_queue, PAGE_SIZE);
-	blk_queue_max_hw_sectors(pmem->pmem_queue, UINT_MAX);
-	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, pmem->pmem_queue);
-	pmem->pmem_queue->queuedata = pmem;
+	blk_queue_make_request(q, pmem_make_request);
+	blk_queue_physical_block_size(q, PAGE_SIZE);
+	blk_queue_max_hw_sectors(q, UINT_MAX);
+	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
+	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
+	q->queuedata = pmem;
 
 	disk = alloc_disk_node(0, nid);
 	if (!disk)
@@ -276,13 +272,12 @@ static int pmem_attach_disk(struct device *dev,
 	}
 
 	disk->fops		= &pmem_fops;
-	disk->queue		= pmem->pmem_queue;
+	disk->queue		= q;
 	disk->flags		= GENHD_FL_EXT_DEVT;
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	disk->driverfs_dev = dev;
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
 			/ 512);
-	pmem->pmem_disk = disk;
 	if (devm_init_badblocks(dev, &pmem->bb))
 		return -ENOMEM;
 	nvdimm_badblocks_populate(to_nd_region(dev->parent), &pmem->bb, res);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
