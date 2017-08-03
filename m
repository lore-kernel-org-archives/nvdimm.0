Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2A83321AEB0CD
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 16:30:15 -0700 (PDT)
Subject: [PATCH v3 7/8] libnvdimm: Adding blk-mq support to the pmem driver
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 03 Aug 2017 16:32:26 -0700
Message-ID: <150180314661.66052.16918796412994404933.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <150180288552.66052.13066621908903037900.stgit@djiang5-desk3.ch.intel.com>
References: <150180288552.66052.13066621908903037900.stgit@djiang5-desk3.ch.intel.com>
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
To: vinod.koul@intel.com, dan.j.williams@intel.com
Cc: dmaengine@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding blk-mq support to the pmem driver in addition to the direct bio
support. This allows for hardware offloading via DMA engines. By default
the bio method will be enabled. The blk-mq support can be turned on via
module parameter queue_mode=1.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/nvdimm/pmem.c |  139 ++++++++++++++++++++++++++++++++++++++++++-------
 drivers/nvdimm/pmem.h |    3 +
 2 files changed, 121 insertions(+), 21 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index f7099ada..519b949 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -31,10 +31,24 @@
 #include <linux/uio.h>
 #include <linux/dax.h>
 #include <linux/nd.h>
+#include <linux/blk-mq.h>
 #include "pmem.h"
 #include "pfn.h"
 #include "nd.h"
 
+enum {
+	PMEM_Q_BIO = 0,
+	PMEM_Q_MQ = 1,
+};
+
+static int queue_mode = PMEM_Q_BIO;
+module_param(queue_mode, int, 0444);
+MODULE_PARM_DESC(queue_mode, "Pmem Queue Mode (0=BIO, 1=BLK-MQ)");
+
+struct pmem_cmd {
+	struct request *rq;
+};
+
 static struct device *to_dev(struct pmem_device *pmem)
 {
 	/*
@@ -260,9 +274,13 @@ static const struct attribute_group *pmem_attribute_groups[] = {
 	NULL,
 };
 
-static void pmem_release_queue(void *q)
+static void pmem_release_queue(void *data)
 {
-	blk_cleanup_queue(q);
+	struct pmem_device *pmem = (struct pmem_device *)data;
+
+	blk_cleanup_queue(pmem->q);
+	if (queue_mode == PMEM_Q_MQ)
+		blk_mq_free_tag_set(&pmem->tag_set);
 }
 
 static void pmem_freeze_queue(void *q)
@@ -280,6 +298,54 @@ static void pmem_release_disk(void *__pmem)
 	put_disk(pmem->disk);
 }
 
+static int pmem_handle_cmd(struct pmem_cmd *cmd)
+{
+	struct request *req = cmd->rq;
+	struct request_queue *q = req->q;
+	struct pmem_device *pmem = q->queuedata;
+	struct nd_region *nd_region = to_region(pmem);
+	struct bio_vec bvec;
+	struct req_iterator iter;
+	int rc = 0;
+
+	if (req->cmd_flags & REQ_FLUSH)
+		nvdimm_flush(nd_region);
+
+	rq_for_each_segment(bvec, req, iter) {
+		rc = pmem_do_bvec(pmem, bvec.bv_page, bvec.bv_len,
+				bvec.bv_offset, op_is_write(req_op(req)),
+				iter.iter.bi_sector);
+		if (rc < 0)
+			break;
+	}
+
+	if (req->cmd_flags & REQ_FUA)
+		nvdimm_flush(nd_region);
+
+	blk_mq_end_request(cmd->rq, rc);
+
+	return rc;
+}
+
+static blk_status_t pmem_queue_rq(struct blk_mq_hw_ctx *hctx,
+		const struct blk_mq_queue_data *bd)
+{
+	struct pmem_cmd *cmd = blk_mq_rq_to_pdu(bd->rq);
+
+	cmd->rq = bd->rq;
+
+	blk_mq_start_request(bd->rq);
+
+	if (pmem_handle_cmd(cmd) < 0)
+		return BLK_STS_IOERR;
+	else
+		return BLK_STS_OK;
+}
+
+static const struct blk_mq_ops pmem_mq_ops = {
+	.queue_rq	= pmem_queue_rq,
+};
+
 static int pmem_attach_disk(struct device *dev,
 		struct nd_namespace_common *ndns)
 {
@@ -293,10 +359,10 @@ static int pmem_attach_disk(struct device *dev,
 	struct nd_pfn_sb *pfn_sb;
 	struct pmem_device *pmem;
 	struct resource pfn_res;
-	struct request_queue *q;
 	struct device *gendev;
 	struct gendisk *disk;
 	void *addr;
+	int rc;
 
 	/* while nsio_rw_bytes is active, parse a pfn info block if present */
 	if (is_nd_pfn(dev)) {
@@ -329,17 +395,49 @@ static int pmem_attach_disk(struct device *dev,
 		return -EBUSY;
 	}
 
-	q = blk_alloc_queue_node(GFP_KERNEL, dev_to_node(dev));
-	if (!q)
-		return -ENOMEM;
+	if (queue_mode == PMEM_Q_MQ) {
+		pmem->tag_set.ops = &pmem_mq_ops;
+		pmem->tag_set.nr_hw_queues = nr_online_nodes;
+		pmem->tag_set.queue_depth = 64;
+		pmem->tag_set.numa_node = dev_to_node(dev);
+		pmem->tag_set.cmd_size = sizeof(struct pmem_cmd);
+		pmem->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
+		pmem->tag_set.driver_data = pmem;
+
+		rc = blk_mq_alloc_tag_set(&pmem->tag_set);
+		if (rc < 0)
+			return rc;
+
+		pmem->q = blk_mq_init_queue(&pmem->tag_set);
+		if (IS_ERR(pmem->q)) {
+			blk_mq_free_tag_set(&pmem->tag_set);
+			return -ENOMEM;
+		}
 
-	if (devm_add_action_or_reset(dev, pmem_release_queue, q))
-		return -ENOMEM;
+		if (devm_add_action_or_reset(dev, pmem_release_queue, pmem)) {
+			pmem_release_queue(pmem);
+			return -ENOMEM;
+		}
+	} else if (queue_mode == PMEM_Q_BIO) {
+		pmem->q = blk_alloc_queue_node(GFP_KERNEL, dev_to_node(dev));
+		if (!pmem->q)
+			return -ENOMEM;
+
+		if (devm_add_action_or_reset(dev, pmem_release_queue, pmem)) {
+			pmem_release_queue(pmem);
+			return -ENOMEM;
+		}
+
+		blk_queue_make_request(pmem->q, pmem_make_request);
+	} else {
+		dev_warn(dev, "Invalid queue mode: %d\n", queue_mode);
+		return -EINVAL;
+	}
 
 	pmem->pfn_flags = PFN_DEV;
 	if (is_nd_pfn(dev)) {
-		addr = devm_memremap_pages(dev, &pfn_res, &q->q_usage_counter,
-				altmap);
+		addr = devm_memremap_pages(dev, &pfn_res,
+				&pmem->q->q_usage_counter, altmap);
 		pfn_sb = nd_pfn->pfn_sb;
 		pmem->data_offset = le64_to_cpu(pfn_sb->dataoff);
 		pmem->pfn_pad = resource_size(res) - resource_size(&pfn_res);
@@ -348,7 +446,7 @@ static int pmem_attach_disk(struct device *dev,
 		res->start += pmem->data_offset;
 	} else if (pmem_should_map_pages(dev)) {
 		addr = devm_memremap_pages(dev, &nsio->res,
-				&q->q_usage_counter, NULL);
+				&pmem->q->q_usage_counter, NULL);
 		pmem->pfn_flags |= PFN_MAP;
 	} else
 		addr = devm_memremap(dev, pmem->phys_addr,
@@ -358,21 +456,20 @@ static int pmem_attach_disk(struct device *dev,
 	 * At release time the queue must be frozen before
 	 * devm_memremap_pages is unwound
 	 */
-	if (devm_add_action_or_reset(dev, pmem_freeze_queue, q))
+	if (devm_add_action_or_reset(dev, pmem_freeze_queue, pmem->q))
 		return -ENOMEM;
 
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
 	pmem->virt_addr = addr;
 
-	blk_queue_write_cache(q, wbc, fua);
-	blk_queue_make_request(q, pmem_make_request);
-	blk_queue_physical_block_size(q, PAGE_SIZE);
-	blk_queue_logical_block_size(q, pmem_sector_size(ndns));
-	blk_queue_max_hw_sectors(q, UINT_MAX);
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
-	queue_flag_set_unlocked(QUEUE_FLAG_DAX, q);
-	q->queuedata = pmem;
+	blk_queue_write_cache(pmem->q, wbc, fua);
+	blk_queue_physical_block_size(pmem->q, PAGE_SIZE);
+	blk_queue_logical_block_size(pmem->q, pmem_sector_size(ndns));
+	blk_queue_max_hw_sectors(pmem->q, UINT_MAX);
+	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, pmem->q);
+	queue_flag_set_unlocked(QUEUE_FLAG_DAX, pmem->q);
+	pmem->q->queuedata = pmem;
 
 	disk = alloc_disk_node(0, nid);
 	if (!disk)
@@ -380,7 +477,7 @@ static int pmem_attach_disk(struct device *dev,
 	pmem->disk = disk;
 
 	disk->fops		= &pmem_fops;
-	disk->queue		= q;
+	disk->queue		= pmem->q;
 	disk->flags		= GENHD_FL_EXT_DEVT;
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index 5434321..bbbe982 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <linux/pfn_t.h>
 #include <linux/fs.h>
+#include <linux/blk-mq.h>
 
 #ifdef CONFIG_ARCH_HAS_PMEM_API
 #define ARCH_MEMREMAP_PMEM MEMREMAP_WB
@@ -35,6 +36,8 @@ struct pmem_device {
 	struct badblocks	bb;
 	struct dax_device	*dax_dev;
 	struct gendisk		*disk;
+	struct blk_mq_tag_set	tag_set;
+	struct request_queue	*q;
 };
 
 long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
