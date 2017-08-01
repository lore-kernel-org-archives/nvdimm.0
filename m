Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 156C521E1DAC5
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 12:00:38 -0700 (PDT)
Date: Tue, 1 Aug 2017 13:02:01 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 4/5] libnvdimm: Adding blk-mq support to the pmem driver
Message-ID: <20170801190201.GD20061@linux.intel.com>
References: <150153948477.49768.5767882242140065474.stgit@djiang5-desk3.ch.intel.com>
 <150153988056.49768.18093169977231724535.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150153988056.49768.18093169977231724535.stgit@djiang5-desk3.ch.intel.com>
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

On Mon, Jul 31, 2017 at 03:24:40PM -0700, Dave Jiang wrote:
> Adding blk-mq support to the pmem driver in addition to the direct bio
> support. This allows for hardware offloading via DMA engines. By default
> the bio method will be enabled. The blk-mq support can be turned on via
> module parameter queue_mode=1.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/pmem.c |  131 +++++++++++++++++++++++++++++++++++++++++++++----
>  drivers/nvdimm/pmem.h |    3 +
>  2 files changed, 122 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index c544d46..347835b 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -31,10 +31,24 @@
>  #include <linux/pmem.h>
>  #include <linux/dax.h>
>  #include <linux/nd.h>
> +#include <linux/blk-mq.h>
>  #include "pmem.h"
>  #include "pfn.h"
>  #include "nd.h"
>  
> +enum {
> +	PMEM_Q_BIO = 0,
> +	PMEM_Q_MQ = 1,
> +};
> +
> +static int queue_mode = PMEM_Q_BIO;
> +module_param(queue_mode, int, 0444);
> +MODULE_PARM_DESC(queue_mode, "Pmem Queue Mode");

Maybe in the parameter description we can give the user a hint as to what the
settings are?  i.e. "PMEM queue mode (0=BIO, 1=MQ+DMA)" or something?

> +
> +struct pmem_cmd {
> +	struct request *rq;
> +};
> +
>  static struct device *to_dev(struct pmem_device *pmem)
>  {
>  	/*
> @@ -239,9 +253,12 @@ static const struct dax_operations pmem_dax_ops = {
>  	.direct_access = pmem_dax_direct_access,
>  };
>  
> -static void pmem_release_queue(void *q)
> +static void pmem_release_queue(void *pmem)
>  {
> -	blk_cleanup_queue(q);
> +

Unneeded whitespace.  Also, a nit, can we maybe add a local pmem with type
"struct pmem_device *" so we don't have to cast twice?

> +	blk_cleanup_queue(((struct pmem_device *)pmem)->q);
> +	if (queue_mode == PMEM_Q_MQ)
> +		blk_mq_free_tag_set(&((struct pmem_device *)pmem)->tag_set);
>  }
>  
>  static void pmem_freeze_queue(void *q)
> @@ -259,6 +276,65 @@ static void pmem_release_disk(void *__pmem)
>  	put_disk(pmem->disk);
>  }
>  
> +static int pmem_handle_cmd(struct pmem_cmd *cmd)
> +{
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
> +
> +	rq_for_each_segment(bvec, req, iter) {
> +		rc = pmem_do_bvec(pmem, bvec.bv_page, bvec.bv_len,
> +				bvec.bv_offset, op_is_write(req_op(req)),
> +				iter.iter.bi_sector);
> +		if (rc < 0)
> +			break;
> +	}
> +
> +	if (req->cmd_flags & REQ_FUA)
> +		nvdimm_flush(nd_region);
> +
> +	blk_mq_end_request(cmd->rq, rc);
> +
> +	return 0;

	return rc;
?

> +}
> +
> +static int pmem_queue_rq(struct blk_mq_hw_ctx *hctx,
> +		const struct blk_mq_queue_data *bd)
> +{
> +	struct pmem_cmd *cmd = blk_mq_rq_to_pdu(bd->rq);
> +	int rc;
> +
> +	cmd->rq = bd->rq;
> +
> +	blk_mq_start_request(bd->rq);
> +
> +	rc = pmem_handle_cmd(cmd);
> +	if (rc < 0)
> +		rc = BLK_MQ_RQ_QUEUE_ERROR;
> +	else
> +		rc = BLK_MQ_RQ_QUEUE_OK;
> +
> +	return rc;
> +}

You can get rid of 'rc' altogether and simplify this to:

static int pmem_queue_rq(struct blk_mq_hw_ctx *hctx,
                const struct blk_mq_queue_data *bd)
{
        struct pmem_cmd *cmd = blk_mq_rq_to_pdu(bd->rq);

        cmd->rq = bd->rq;
        blk_mq_start_request(bd->rq);

        if (pmem_handle_cmd(cmd) < 0)
                return BLK_MQ_RQ_QUEUE_ERROR;
        else
                return BLK_MQ_RQ_QUEUE_OK;
}

> +static int pmem_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
> +		unsigned int index)
> +{
> +	return 0;
> +}

I'm pretty sure you don't need a dummy implementation of .init_hctx.  All
callers check to make sure it's defined before calling, so if you just leave
the OP NULL it'll do the same thing.  scsi_mq_ops for example does this.

> @@ -303,17 +380,47 @@ static int pmem_attach_disk(struct device *dev,
>  		return -EBUSY;
>  	}
>  
> -	q = blk_alloc_queue_node(GFP_KERNEL, dev_to_node(dev));
> -	if (!q)
> -		return -ENOMEM;
> +	if (queue_mode == PMEM_Q_MQ) {
> +		pmem->tag_set.ops = &pmem_mq_ops;
> +		pmem->tag_set.nr_hw_queues = nr_online_nodes;
> +		pmem->tag_set.queue_depth = 64;
> +		pmem->tag_set.numa_node = dev_to_node(dev);
> +		pmem->tag_set.cmd_size = sizeof(struct pmem_cmd);
> +		pmem->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
> +		pmem->tag_set.driver_data = pmem;
> +
> +		rc = blk_mq_alloc_tag_set(&pmem->tag_set);
> +		if (rc < 0)
> +			return rc;
> +
> +		pmem->q = blk_mq_init_queue(&pmem->tag_set);
> +		if (IS_ERR(pmem->q)) {
> +			blk_mq_free_tag_set(&pmem->tag_set);
> +			return -ENOMEM;
> +		}
>  
> -	if (devm_add_action_or_reset(dev, pmem_release_queue, q))
> -		return -ENOMEM;
> +		if (devm_add_action_or_reset(dev, pmem_release_queue, pmem)) {
> +			blk_mq_free_tag_set(&pmem->tag_set);
> +			return -ENOMEM;
> +		}
> +	} else if (queue_mode == PMEM_Q_BIO) {
> +		pmem->q = blk_alloc_queue_node(GFP_KERNEL, dev_to_node(dev));
> +		if (!pmem->q)
> +			return -ENOMEM;
> +
> +		if (devm_add_action_or_reset(dev, pmem_release_queue, pmem))
> +			return -ENOMEM;
> +
> +		blk_queue_make_request(pmem->q, pmem_make_request);

Later on in this function there is a big block that is still manipulating 'q'
instead of pmem->q:

	blk_queue_write_cache(q, true, true);
	blk_queue_make_request(q, pmem_make_request);
	blk_queue_physical_block_size(q, PAGE_SIZE);
	blk_queue_max_hw_sectors(q, UINT_MAX);
	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
	queue_flag_set_unlocked(QUEUE_FLAG_DAX, q);
	q->queuedata = pmem;

I'm pretty sure this all needs to be looking at pmem->q instead, and we may
just end up killing the local 'q'.

Also, this block duplicates the blk_queue_make_request() call, which we
manually make happen in the PMEM_Q_BIO case above.  Not sure if this needs to
be common for both that and the PMEM_Q_MQ case, but we probably don't want it
in both places.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
