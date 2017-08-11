Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1E01821D490E6
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 04:02:06 -0700 (PDT)
Date: Fri, 11 Aug 2017 04:04:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 8/8] libnvdimm: add DMA support for pmem blk-mq
Message-ID: <20170811110424.GB25839@infradead.org>
References: <150212381454.23722.1549806704988615279.stgit@djiang5-desk3.ch.intel.com>
 <150212399902.23722.5878783372576979990.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150212399902.23722.5878783372576979990.stgit@djiang5-desk3.ch.intel.com>
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

On Mon, Aug 07, 2017 at 09:39:59AM -0700, Dave Jiang wrote:
> +static int queue_mode = PMEM_Q_MQ;

So this changes the default for everyone.  How about those systems
without dma engine?

>  module_param(queue_mode, int, 0444);
> -MODULE_PARM_DESC(queue_mode, "Pmem Queue Mode (0=BIO, 1=BLK-MQ)");
> +MODULE_PARM_DESC(queue_mode, "Pmem Queue Mode (0=BIO, 1=BLK-MQ & DMA)");
> +
> +static int queue_depth = 128;
> +module_param(queue_depth, int, 0444);
> +MODULE_PARM_DESC(queue_depth, "I/O Queue Depth for multi queue mode");

This changes the default from the previous patch, why not introduce
this parameter and default there.  And an explanation of the magic
value would still be nice.

> +/* typically maps to number of DMA channels/devices per socket */
> +static int q_per_node = 8;
> +module_param(q_per_node, int, 0444);
> +MODULE_PARM_DESC(q_per_node, "Hardware queues per node\n");

How can a fixed constant "typically map" to a hardware dependent
resource?

> +	if (res) {

unlikely?

> +		enum dmaengine_tx_result dma_err = res->result;
> +
> +		switch (dma_err) {

do you really need the local variable for a single check of it?

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
> +	blk_mq_end_request(cmd->rq, rc);

blk_mq_end_request takes a blk_status_t.  Note that sparse would
have caught that, so please run your code through sparse.

> +	if (cmd->sg_nents > 128) {

WARN_ON_ONCE as this should not happen.

> +	if (queue_mode == PMEM_Q_MQ) {
>  		pmem->tag_set.ops = &pmem_mq_ops;
> -		pmem->tag_set.nr_hw_queues = nr_online_nodes;
> -		pmem->tag_set.queue_depth = 64;
> +		pmem->tag_set.nr_hw_queues = nr_online_nodes * q_per_node;
> +		pmem->tag_set.queue_depth = queue_depth;

please use present nodes - we don't remap on cpu soft online/offline.

>  		pmem->tag_set.numa_node = dev_to_node(dev);
> -		pmem->tag_set.cmd_size = sizeof(struct pmem_cmd);
> +		pmem->tag_set.cmd_size = sizeof(struct pmem_cmd) +
> +			sizeof(struct scatterlist) * 128;

s/128/queue_depth/

>  		pmem->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
>  		pmem->tag_set.driver_data = pmem;
>  
> @@ -466,7 +649,11 @@ static int pmem_attach_disk(struct device *dev,
>  	blk_queue_write_cache(pmem->q, wbc, fua);
>  	blk_queue_physical_block_size(pmem->q, PAGE_SIZE);
>  	blk_queue_logical_block_size(pmem->q, pmem_sector_size(ndns));
> -	blk_queue_max_hw_sectors(pmem->q, UINT_MAX);
> +	if (queue_mode == PMEM_Q_MQ) {
> +		blk_queue_max_hw_sectors(pmem->q, 0x200000);
> +		blk_queue_max_segments(pmem->q, 128);

Where do these magic numbers come from?

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
