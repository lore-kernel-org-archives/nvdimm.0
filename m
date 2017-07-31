Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E60A321D4919D
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 15:22:32 -0700 (PDT)
Subject: [PATCH 4/5] libnvdimm: Adding blk-mq support to the pmem driver
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 31 Jul 2017 15:24:40 -0700
Message-ID: <150153988056.49768.18093169977231724535.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <150153948477.49768.5767882242140065474.stgit@djiang5-desk3.ch.intel.com>
References: <150153948477.49768.5767882242140065474.stgit@djiang5-desk3.ch.intel.com>
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
---
 drivers/nvdimm/pmem.c |  131 +++++++++++++++++++++++++++++++++++++++++++++----
 drivers/nvdimm/pmem.h |    3 +
 2 files changed, 122 insertions(+), 12 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index c544d46..347835b 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -31,10 +31,24 @@
 #include <linux/pmem.h>
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
+MODULE_PARM_DESC(queue_mode, "Pmem Queue Mode");
+
+struct pmem_cmd {
+	struct request *rq;
+};
+
 static struct device *to_dev(struct pmem_device *pmem)
 {
 	/*
@@ -239,9 +253,12 @@ static const struct dax_operations pmem_dax_ops = {
 	.direct_access = pmem_dax_direct_access,
 };
 
-static void pmem_release_queue(void *q)
+static void pmem_release_queue(void *pmem)
 {
-	blk_cleanup_queue(q);
+
+	blk_cleanup_queue(((struct pmem_device *)pmem)->q);
+	if (queue_mode == PMEM_Q_MQ)
+		blk_mq_free_tag_set(&((struct pmem_device *)pmem)->tag_set);
 }
 
 static void pmem_freeze_queue(void *q)
@@ -259,6 +276,65 @@ static void pmem_release_disk(void *__pmem)
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
+	return 0;
+}
+
+static int pmem_queue_rq(struct blk_mq_hw_ctx *hctx,
+		const struct blk_mq_queue_data *bd)
+{
+	struct pmem_cmd *cmd = blk_mq_rq_to_pdu(bd->rq);
+	int rc;
+
+	cmd->rq = bd->rq;
+
+	blk_mq_start_request(bd->rq);
+
+	rc = pmem_handle_cmd(cmd);
+	if (rc < 0)
+		rc = BLK_MQ_RQ_QUEUE_ERROR;
+	else
+		rc = BLK_MQ_RQ_QUEUE_OK;
+
+	return rc;
+}
+
+static int pmem_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
+		unsigned int index)
+{
+	return 0;
+}
+
+static const struct blk_mq_ops pmem_mq_ops = {
+	.queue_rq	= pmem_queue_rq,
+	.init_hctx	= pmem_init_hctx,
+};
+
 static int pmem_attach_disk(struct device *dev,
 		struct nd_namespace_common *ndns)
 {
@@ -275,6 +351,7 @@ static int pmem_attach_disk(struct device *dev,
 	struct request_queue *q;
 	struct gendisk *disk;
 	void *addr;
+	int rc;
 
 	/* while nsio_rw_bytes is active, parse a pfn info block if present */
 	if (is_nd_pfn(dev)) {
@@ -303,17 +380,47 @@ static int pmem_attach_disk(struct device *dev,
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
+			blk_mq_free_tag_set(&pmem->tag_set);
+			return -ENOMEM;
+		}
+	} else if (queue_mode == PMEM_Q_BIO) {
+		pmem->q = blk_alloc_queue_node(GFP_KERNEL, dev_to_node(dev));
+		if (!pmem->q)
+			return -ENOMEM;
+
+		if (devm_add_action_or_reset(dev, pmem_release_queue, pmem))
+			return -ENOMEM;
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
@@ -322,7 +429,7 @@ static int pmem_attach_disk(struct device *dev,
 		res->start += pmem->data_offset;
 	} else if (pmem_should_map_pages(dev)) {
 		addr = devm_memremap_pages(dev, &nsio->res,
-				&q->q_usage_counter, NULL);
+				&pmem->q->q_usage_counter, NULL);
 		pmem->pfn_flags |= PFN_MAP;
 	} else
 		addr = devm_memremap(dev, pmem->phys_addr,
@@ -332,7 +439,7 @@ static int pmem_attach_disk(struct device *dev,
 	 * At release time the queue must be frozen before
 	 * devm_memremap_pages is unwound
 	 */
-	if (devm_add_action_or_reset(dev, pmem_freeze_queue, q))
+	if (devm_add_action_or_reset(dev, pmem_freeze_queue, pmem->q))
 		return -ENOMEM;
 
 	if (IS_ERR(addr))
@@ -354,7 +461,7 @@ static int pmem_attach_disk(struct device *dev,
 	pmem->disk = disk;
 
 	disk->fops		= &pmem_fops;
-	disk->queue		= q;
+	disk->queue		= pmem->q;
 	disk->flags		= GENHD_FL_EXT_DEVT;
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index 7f4dbd7..1836c7b 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <linux/pfn_t.h>
 #include <linux/fs.h>
+#include <linux/blk-mq.h>
 
 /* this definition is in it's own header for tools/testing/nvdimm to consume */
 struct pmem_device {
@@ -20,6 +21,8 @@ struct pmem_device {
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
