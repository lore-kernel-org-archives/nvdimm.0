Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 89E9321CE7491
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 16:30:20 -0700 (PDT)
Subject: [PATCH v3 8/8] libnvdimm: add DMA support for pmem blk-mq
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 03 Aug 2017 16:32:32 -0700
Message-ID: <150180315203.66052.12255427047469222345.stgit@djiang5-desk3.ch.intel.com>
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

Adding DMA support for pmem blk reads. This provides signficant CPU
reduction with large memory reads with good performance. DMAs are triggered
with test against bio_multiple_segment(), so the small I/Os (4k or less?)
are still performed by the CPU in order to reduce latency. By default
the pmem driver will be using blk-mq with DMA.

Numbers below are measured against pmem simulated via DRAM using
memmap=NN!SS.  DMA engine used is the ioatdma on Intel Skylake Xeon
platform.  Keep in mind the performance for actual persistent memory
will differ.
Fio 2.21 was used.

64k: 1 task queuedepth=1
CPU Read:  7631 MB/s  99.7% CPU    DMA Read: 2415 MB/s  54% CPU
CPU Write: 3552 MB/s  100% CPU     DMA Write 2173 MB/s  54% CPU

64k: 16 tasks queuedepth=16
CPU Read: 36800 MB/s  1593% CPU    DMA Read:  29100 MB/s  607% CPU
CPU Write 20900 MB/s  1589% CPU    DMA Write: 23400 MB/s  585% CPU

2M: 1 task queuedepth=1
CPU Read:  6013 MB/s  99.3% CPU    DMA Read:  7986 MB/s  59.3% CPU
CPU Write: 3579 MB/s  100% CPU     DMA Write: 5211 MB/s  58.3% CPU

2M: 16 tasks queuedepth=16
CPU Read:  18100 MB/s 1588% CPU    DMA Read:  21300 MB/s 180.9% CPU
CPU Write: 14100 MB/s 1594% CPU    DMA Write: 20400 MB/s 446.9% CPU

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/nvdimm/pmem.c |  214 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 204 insertions(+), 10 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 519b949..3ad78e3 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -32,6 +32,8 @@
 #include <linux/dax.h>
 #include <linux/nd.h>
 #include <linux/blk-mq.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
 #include "pmem.h"
 #include "pfn.h"
 #include "nd.h"
@@ -41,12 +43,24 @@ enum {
 	PMEM_Q_MQ = 1,
 };
 
-static int queue_mode = PMEM_Q_BIO;
+static int queue_mode = PMEM_Q_MQ;
 module_param(queue_mode, int, 0444);
-MODULE_PARM_DESC(queue_mode, "Pmem Queue Mode (0=BIO, 1=BLK-MQ)");
+MODULE_PARM_DESC(queue_mode, "Pmem Queue Mode (0=BIO, 1=BLK-MQ & DMA)");
+
+static int queue_depth = 128;
+module_param(queue_depth, int, 0444);
+MODULE_PARM_DESC(queue_depth, "I/O Queue Depth for multi queue mode");
+
+/* typically maps to number of DMA channels/devices per socket */
+static int q_per_node = 8;
+module_param(q_per_node, int, 0444);
+MODULE_PARM_DESC(q_per_node, "Hardware queues per node\n");
 
 struct pmem_cmd {
 	struct request *rq;
+	struct dma_chan *chan;
+	int sg_nents;
+	struct scatterlist sg[];
 };
 
 static struct device *to_dev(struct pmem_device *pmem)
@@ -298,6 +312,159 @@ static void pmem_release_disk(void *__pmem)
 	put_disk(pmem->disk);
 }
 
+static void nd_pmem_dma_callback(void *data,
+		const struct dmaengine_result *res)
+{
+	struct pmem_cmd *cmd = data;
+	struct request *req = cmd->rq;
+	struct request_queue *q = req->q;
+	struct pmem_device *pmem = q->queuedata;
+	struct nd_region *nd_region = to_region(pmem);
+	struct device *dev = to_dev(pmem);
+	int rc = 0;
+
+	if (res) {
+		enum dmaengine_tx_result dma_err = res->result;
+
+		switch (dma_err) {
+		case DMA_TRANS_READ_FAILED:
+		case DMA_TRANS_WRITE_FAILED:
+		case DMA_TRANS_ABORTED:
+			dev_dbg(dev, "bio failed\n");
+			rc = -ENXIO;
+			break;
+		case DMA_TRANS_NOERROR:
+		default:
+			break;
+		}
+	}
+
+	if (req->cmd_flags & REQ_FUA)
+		nvdimm_flush(nd_region);
+
+	blk_mq_end_request(cmd->rq, rc);
+}
+
+static int pmem_handle_cmd_dma(struct pmem_cmd *cmd, bool is_write)
+{
+	struct request *req = cmd->rq;
+	struct request_queue *q = req->q;
+	struct pmem_device *pmem = q->queuedata;
+	struct device *dev = to_dev(pmem);
+	phys_addr_t pmem_off = blk_rq_pos(req) * 512 + pmem->data_offset;
+	void *pmem_addr = pmem->virt_addr + pmem_off;
+	struct nd_region *nd_region = to_region(pmem);
+	size_t len;
+	struct dma_device *dma = cmd->chan->device;
+	struct dmaengine_unmap_data *unmap;
+	dma_cookie_t cookie;
+	struct dma_async_tx_descriptor *txd;
+	struct page *page;
+	unsigned int off;
+	int rc;
+	enum dma_data_direction dir;
+	dma_addr_t dma_addr;
+
+	if (req->cmd_flags & REQ_FLUSH)
+		nvdimm_flush(nd_region);
+
+	unmap = dmaengine_get_unmap_data(dma->dev, 2, GFP_NOWAIT);
+	if (!unmap) {
+		dev_dbg(dev, "failed to get dma unmap data\n");
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	/*
+	 * If reading from pmem, writing to scatterlist,
+	 * and if writing to pmem, reading from scatterlist.
+	 */
+	dir = is_write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	cmd->sg_nents = blk_rq_map_sg(req->q, req, cmd->sg);
+	if (cmd->sg_nents < 1) {
+		rc = -EINVAL;
+		goto err;
+	}
+
+	if (cmd->sg_nents > 128) {
+		rc = -ENOMEM;
+		dev_warn(dev, "Number of sg greater than allocated\n");
+		goto err;
+	}
+
+	rc = dma_map_sg(dma->dev, cmd->sg, cmd->sg_nents, dir);
+	if (rc < 1) {
+		rc = -ENXIO;
+		goto err;
+	}
+
+	len = blk_rq_payload_bytes(req);
+	page = virt_to_page(pmem_addr);
+	off = offset_in_page(pmem_addr);
+	dir = is_write ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+	dma_addr = dma_map_page(dma->dev, page, off, len, dir);
+	if (dma_mapping_error(dma->dev, unmap->addr[0])) {
+		dev_dbg(dma->dev, "src DMA mapping error\n");
+		rc = -ENXIO;
+		goto err_unmap_sg;
+	}
+
+	unmap->len = len;
+
+	if (is_write) {
+		unmap->addr[0] = dma_addr;
+		unmap->addr[1] = (dma_addr_t)cmd->sg;
+		unmap->to_cnt = 1;
+		unmap->from_cnt = 0;
+		dma_unmap_data_sg_from_nents(unmap, 2) = cmd->sg_nents;
+	} else {
+		unmap->addr[0] = (dma_addr_t)cmd->sg;
+		unmap->addr[1] = dma_addr;
+		unmap->from_cnt = 1;
+		unmap->to_cnt = 0;
+		dma_unmap_data_sg_to_nents(unmap, 2) = cmd->sg_nents;
+	}
+
+	txd = dma->device_prep_dma_memcpy_sg(cmd->chan,
+				cmd->sg, cmd->sg_nents, dma_addr,
+				!is_write, DMA_PREP_INTERRUPT);
+	if (!txd) {
+		dev_dbg(dma->dev, "dma prep failed\n");
+		rc = -ENXIO;
+		goto err_unmap_buffer;
+	}
+
+	txd->callback_result = nd_pmem_dma_callback;
+	txd->callback_param = cmd;
+	dma_set_unmap(txd, unmap);
+	cookie = dmaengine_submit(txd);
+	if (dma_submit_error(cookie)) {
+		dev_dbg(dma->dev, "dma submit error\n");
+		rc = -ENXIO;
+		goto err_set_unmap;
+	}
+
+	dmaengine_unmap_put(unmap);
+	dma_async_issue_pending(cmd->chan);
+
+	return 0;
+
+err_set_unmap:
+	dmaengine_unmap_put(unmap);
+err_unmap_buffer:
+	dma_unmap_page(dev, dma_addr, len, dir);
+err_unmap_sg:
+	if (dir == DMA_TO_DEVICE)
+		dir = DMA_FROM_DEVICE;
+	else
+		dir = DMA_TO_DEVICE;
+	dma_unmap_sg(dev, cmd->sg, cmd->sg_nents, dir);
+	dmaengine_unmap_put(unmap);
+err:
+	blk_mq_end_request(cmd->rq, rc);
+	return rc;
+}
+
 static int pmem_handle_cmd(struct pmem_cmd *cmd)
 {
 	struct request *req = cmd->rq;
@@ -331,12 +498,18 @@ static blk_status_t pmem_queue_rq(struct blk_mq_hw_ctx *hctx,
 		const struct blk_mq_queue_data *bd)
 {
 	struct pmem_cmd *cmd = blk_mq_rq_to_pdu(bd->rq);
+	struct request *req;
+	int rc;
 
-	cmd->rq = bd->rq;
-
-	blk_mq_start_request(bd->rq);
+	req = cmd->rq = bd->rq;
+	cmd->chan = dma_find_channel(DMA_MEMCPY_SG);
+	blk_mq_start_request(req);
 
-	if (pmem_handle_cmd(cmd) < 0)
+	if (cmd->chan && bio_multiple_segments(req->bio))
+		rc = pmem_handle_cmd_dma(cmd, op_is_write(req_op(req)));
+	else
+		rc = pmem_handle_cmd(cmd);
+	if (rc < 0)
 		return BLK_STS_IOERR;
 	else
 		return BLK_STS_OK;
@@ -363,6 +536,7 @@ static int pmem_attach_disk(struct device *dev,
 	struct gendisk *disk;
 	void *addr;
 	int rc;
+	struct dma_chan *chan;
 
 	/* while nsio_rw_bytes is active, parse a pfn info block if present */
 	if (is_nd_pfn(dev)) {
@@ -396,11 +570,20 @@ static int pmem_attach_disk(struct device *dev,
 	}
 
 	if (queue_mode == PMEM_Q_MQ) {
+		chan = dma_find_channel(DMA_MEMCPY_SG);
+		if (!chan) {
+			queue_mode = PMEM_Q_BIO;
+			dev_warn(dev, "Forced back to PMEM_Q_BIO, no DMA\n");
+		}
+	}
+
+	if (queue_mode == PMEM_Q_MQ) {
 		pmem->tag_set.ops = &pmem_mq_ops;
-		pmem->tag_set.nr_hw_queues = nr_online_nodes;
-		pmem->tag_set.queue_depth = 64;
+		pmem->tag_set.nr_hw_queues = nr_online_nodes * q_per_node;
+		pmem->tag_set.queue_depth = queue_depth;
 		pmem->tag_set.numa_node = dev_to_node(dev);
-		pmem->tag_set.cmd_size = sizeof(struct pmem_cmd);
+		pmem->tag_set.cmd_size = sizeof(struct pmem_cmd) +
+			sizeof(struct scatterlist) * 128;
 		pmem->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 		pmem->tag_set.driver_data = pmem;
 
@@ -466,7 +649,11 @@ static int pmem_attach_disk(struct device *dev,
 	blk_queue_write_cache(pmem->q, wbc, fua);
 	blk_queue_physical_block_size(pmem->q, PAGE_SIZE);
 	blk_queue_logical_block_size(pmem->q, pmem_sector_size(ndns));
-	blk_queue_max_hw_sectors(pmem->q, UINT_MAX);
+	if (queue_mode == PMEM_Q_MQ) {
+		blk_queue_max_hw_sectors(pmem->q, 0x200000);
+		blk_queue_max_segments(pmem->q, 128);
+	} else
+		blk_queue_max_hw_sectors(pmem->q, UINT_MAX);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, pmem->q);
 	queue_flag_set_unlocked(QUEUE_FLAG_DAX, pmem->q);
 	pmem->q->queuedata = pmem;
@@ -628,15 +815,22 @@ static struct nd_device_driver nd_pmem_driver = {
 
 static int __init pmem_init(void)
 {
+	if (queue_mode == PMEM_Q_MQ)
+		dmaengine_get();
+
 	return nd_driver_register(&nd_pmem_driver);
 }
 module_init(pmem_init);
 
 static void pmem_exit(void)
 {
+	if (queue_mode == PMEM_Q_MQ)
+		dmaengine_put();
+
 	driver_unregister(&nd_pmem_driver.drv);
 }
 module_exit(pmem_exit);
 
+MODULE_SOFTDEP("pre: dmaengine");
 MODULE_AUTHOR("Ross Zwisler <ross.zwisler@linux.intel.com>");
 MODULE_LICENSE("GPL v2");

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
