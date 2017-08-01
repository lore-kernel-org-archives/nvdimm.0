Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E31D21D2DCF1
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 13:40:49 -0700 (PDT)
Date: Tue, 1 Aug 2017 14:42:53 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 5/5] libnvdimm: add DMA support for pmem blk-mq
Message-ID: <20170801204253.GE20061@linux.intel.com>
References: <150153948477.49768.5767882242140065474.stgit@djiang5-desk3.ch.intel.com>
 <150153988620.49768.12914164179718467335.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150153988620.49768.12914164179718467335.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, dmaengine@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 31, 2017 at 03:24:46PM -0700, Dave Jiang wrote:
> Adding DMA support for pmem blk reads. This provides signficant CPU
> reduction with large memory reads with good performance. DMAs are triggered
> with test against bio_multiple_segment(), so the small I/Os (4k or less?)
> are still performed by the CPU in order to reduce latency. By default
> the pmem driver will be using blk-mq with DMA.
> 
> Numbers below are measured against pmem simulated via DRAM using
> memmap=NN!SS.  DMA engine used is the ioatdma on Intel Skylake Xeon
> platform.  Keep in mind the performance for actual persistent memory
> will differ.
> Fio 2.21 was used.
> 
> 64k: 1 task queuedepth=1
> CPU Read:  7631 MB/s  99.7% CPU    DMA Read: 2415 MB/s  54% CPU
> CPU Write: 3552 MB/s  100% CPU     DMA Write 2173 MB/s  54% CPU
> 
> 64k: 16 tasks queuedepth=16
> CPU Read: 36800 MB/s  1593% CPU    DMA Read:  29100 MB/s  607% CPU
> CPU Write 20900 MB/s  1589% CPU    DMA Write: 23400 MB/s  585% CPU
> 
> 2M: 1 task queuedepth=1
> CPU Read:  6013 MB/s  99.3% CPU    DMA Read:  7986 MB/s  59.3% CPU
> CPU Write: 3579 MB/s  100% CPU     DMA Write: 5211 MB/s  58.3% CPU
> 
> 2M: 16 tasks queuedepth=16
> CPU Read:  18100 MB/s 1588% CPU    DMA Read:  21300 MB/s 180.9% CPU
> CPU Write: 14100 MB/s 1594% CPU    DMA Write: 20400 MB/s 446.9% CPU
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
<>
> +static void nd_pmem_dma_callback(void *data,
> +		const struct dmaengine_result *res)
> +{
> +	struct pmem_cmd *cmd = data;
> +	struct request *req = cmd->rq;
> +	struct request_queue *q = req->q;
> +	struct pmem_device *pmem = q->queuedata;
> +	struct nd_region *nd_region = to_region(pmem);
> +	struct device *dev = to_dev(pmem);
> +	int rc = 0;
> +
> +	dev_dbg(dev, "%s()\n", __func__);

Is this left-over debug, or did you mean to leave it in?

> +
> +	if (res) {
> +		enum dmaengine_tx_result dma_err = res->result;
> +
> +		switch (dma_err) {
> +		case DMA_TRANS_READ_FAILED:
> +		case DMA_TRANS_WRITE_FAILED:
> +		case DMA_TRANS_ABORTED:
> +			dev_dbg(dev, "bio failed\n");
> +			rc = -ENXIO;
> +			break;
> +		case DMA_TRANS_NOERROR:
> +		default:
> +			break;
> +		}
> +	}
> +
> +	if (req->cmd_flags & REQ_FUA)
> +		nvdimm_flush(nd_region);
> +
> +	dev_dbg(dev, "ending request\n");
> +	blk_mq_end_request(cmd->rq, rc);
> +}
> +
> +static int pmem_handle_cmd_dma(struct pmem_cmd *cmd, bool is_write)
> +{
> +	struct request *req = cmd->rq;
> +	struct request_queue *q = req->q;
> +	struct pmem_device *pmem = q->queuedata;
> +	struct device *dev = to_dev(pmem);
> +	phys_addr_t pmem_off = blk_rq_pos(req) * 512 + pmem->data_offset;
> +	void *pmem_addr = pmem->virt_addr + pmem_off;
> +	struct nd_region *nd_region = to_region(pmem);
> +	size_t len;
> +	struct dma_device *dma = cmd->chan->device;
> +	struct dmaengine_unmap_data *unmap;
> +	dma_cookie_t cookie;
> +	struct dma_async_tx_descriptor *txd;
> +	struct page *page;
> +	unsigned int off;
> +	int rc;
> +	enum dma_data_direction dir;
> +	dma_addr_t dma_addr;
> +
> +	if (req->cmd_flags & REQ_FLUSH)
> +		nvdimm_flush(nd_region);
> +
> +	unmap = dmaengine_get_unmap_data(dma->dev, 2, GFP_NOWAIT);
> +	if (!unmap) {
> +		dev_dbg(dev, "failed to get dma unmap data\n");
> +		rc = -ENOMEM;

The value of 'rc' isn't used at all in the error paths at the end of this
function.  Instead it ends the mq request with -ENXIO and returns -ENXIO
unconditionally.  That code should probably use 'rc' instead ... (continued in
next block)


> +		goto err;
> +	}
> +
> +	/*
> +	 * If reading from pmem, writing to scatterlist,
> +	 * and if writing to pmem, reading from scatterlist.
> +	 */
> +	dir = is_write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +	cmd->sg_nents = blk_rq_map_sg(req->q, req, cmd->sg);
> +	if (cmd->sg_nents < 1) {
> +		rc = -EINVAL;
> +		goto err;
> +	}
> +
> +	if (cmd->sg_nents > 128) {
> +		rc = -ENOMEM;
> +		dev_warn(dev, "Number of sg greater than allocated\n");
> +		goto err;
> +	}
> +
> +	rc = dma_map_sg(dma->dev, cmd->sg, cmd->sg_nents, dir);
> +	if (rc < 1) {
> +		rc = -ENXIO;
> +		goto err;
> +	}
> +
> +	len = blk_rq_payload_bytes(req);
> +	page = virt_to_page(pmem_addr);
> +	off = (u64)pmem_addr & ~PAGE_MASK;
> +	dir = is_write ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +	dma_addr = dma_map_page(dma->dev, page, off, len, dir);
> +	if (dma_mapping_error(dma->dev, unmap->addr[0])) {
> +		dev_dbg(dma->dev, "src DMA mapping error\n");
> +		goto err_unmap_sg;

... which means that these later gotos need to set 'rc'.  This applies to the
rest of the gotos in this function.

> +	}
> +
> +	unmap->len = len;
> +
> +	if (is_write) {
> +		unmap->addr[0] = dma_addr;
> +		unmap->addr[1] = (dma_addr_t)cmd->sg;
> +		unmap->to_cnt = 1;
> +		unmap->from_cnt = 0;
> +		dma_unmap_data_sg_from_nents(unmap, 2) = cmd->sg_nents;
> +		txd = dma->device_prep_dma_memcpy_from_sg(cmd->chan, dma_addr,
> +				cmd->sg, cmd->sg_nents, DMA_PREP_INTERRUPT);
> +	} else {
> +		unmap->addr[0] = (dma_addr_t)cmd->sg;
> +		unmap->addr[1] = dma_addr;
> +		unmap->from_cnt = 1;
> +		unmap->to_cnt = 0;
> +		dma_unmap_data_sg_to_nents(unmap, 2) = cmd->sg_nents;
> +		txd = dma->device_prep_dma_memcpy_to_sg(cmd->chan, cmd->sg,
> +			cmd->sg_nents, dma_addr, DMA_PREP_INTERRUPT);
> +	}
> +
> +	if (!txd) {
> +		dev_dbg(dma->dev, "dma prep failed\n");
> +		goto err_unmap_buffer;
> +	}
> +
> +	txd->callback_result = nd_pmem_dma_callback;
> +	txd->callback_param = cmd;
> +	dma_set_unmap(txd, unmap);
> +	cookie = dmaengine_submit(txd);
> +	if (dma_submit_error(cookie)) {
> +		dev_dbg(dma->dev, "dma submit error\n");
> +		goto err_set_unmap;
> +	}
> +
> +	dmaengine_unmap_put(unmap);
> +	dma_async_issue_pending(cmd->chan);
> +
> +	return 0;
> +
> +err_set_unmap:
> +	dmaengine_unmap_put(unmap);
> +err_unmap_buffer:
> +	dma_unmap_page(dev, dma_addr, len, dir);
> +err_unmap_sg:
> +	if (dir == DMA_TO_DEVICE)
> +		dir = DMA_FROM_DEVICE;
> +	else
> +		dir = DMA_TO_DEVICE;
> +	dma_unmap_sg(dev, cmd->sg, cmd->sg_nents, dir);
> +	dmaengine_unmap_put(unmap);
> +err:
> +	blk_mq_end_request(cmd->rq, -ENXIO);
> +	return -ENXIO;
> +}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
