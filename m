Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1E4C321D490E2
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 03:55:04 -0700 (PDT)
Date: Fri, 11 Aug 2017 03:57:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 7/8] libnvdimm: Adding blk-mq support to the pmem driver
Message-ID: <20170811105723.GA25839@infradead.org>
References: <150212381454.23722.1549806704988615279.stgit@djiang5-desk3.ch.intel.com>
 <150212399361.23722.13317531480320953298.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150212399361.23722.13317531480320953298.stgit@djiang5-desk3.ch.intel.com>
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

On Mon, Aug 07, 2017 at 09:39:53AM -0700, Dave Jiang wrote:
> Adding blk-mq support to the pmem driver in addition to the direct bio
> support.

Can you explain why this is only done for pmem and not btt and nd_blk?

> This allows for hardware offloading via DMA engines. By default
> the bio method will be enabled. The blk-mq support can be turned on via
> module parameter queue_mode=1.

Any way to auto-discovery the right mode?  Also I'd actually much
prefer for this to be a separate driver instead of having two entirely
different I/O paths in the same module.

> +struct pmem_cmd {
> +	struct request *rq;
> +};

There is no point in having private data that just has a struct
request backpointer.  Just pass the request along.

>  
> -static void pmem_release_queue(void *q)
> +static void pmem_release_queue(void *data)
>  {
> -	blk_cleanup_queue(q);
> +	struct pmem_device *pmem = (struct pmem_device *)data;

No need for the cast.

> +static int pmem_handle_cmd(struct pmem_cmd *cmd)

Please merge this into the queue_rq handler.

> +	struct request *req = cmd->rq;
> +	struct request_queue *q = req->q;
> +	struct pmem_device *pmem = q->queuedata;
> +	struct nd_region *nd_region = to_region(pmem);
> +	struct bio_vec bvec;
> +	struct req_iterator iter;
> +	int rc = 0;
> +
> +	if (req->cmd_flags & REQ_FLUSH)
> +		nvdimm_flush(nd_region);

For a blk-mq driver you need to check for REQ_OP_FLUSH, .e.g.

	switch (req_op(req)) {
	case REQ_FLUSH:
		ret = nvdimm_flush(nd_region);
		break;
	case REQ_OP_READ:
		ret = pmem_do_io(req, false);
		break;
	case REQ_OP_WRITE:
		ret = pmem_do_io(req, true);
		if (req->cmd_flags & REQ_FUA)
			nvdimm_flush(nd_region);
		break;
	default:
		ret = BLK_STS_NOTSUPP;
		break;
	}

> +		pmem->tag_set.queue_depth = 64;

Where does this magic number come from?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
