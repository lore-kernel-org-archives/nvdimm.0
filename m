Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 34039209589C8
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 13:02:39 -0700 (PDT)
Date: Thu, 3 Aug 2017 14:04:50 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 4/5] libnvdimm: Adding blk-mq support to the pmem driver
Message-ID: <20170803200450.GA18341@linux.intel.com>
References: <150169902310.59677.18062301799811367806.stgit@djiang5-desk3.ch.intel.com>
 <150169927933.59677.7382159914302175097.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150169927933.59677.7382159914302175097.stgit@djiang5-desk3.ch.intel.com>
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

On Wed, Aug 02, 2017 at 11:41:19AM -0700, Dave Jiang wrote:
> Adding blk-mq support to the pmem driver in addition to the direct bio
> support. This allows for hardware offloading via DMA engines. By default
> the bio method will be enabled. The blk-mq support can be turned on via
> module parameter queue_mode=1.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

One small nit with error handling.  With that addressed you can add:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

> @@ -303,17 +369,47 @@ static int pmem_attach_disk(struct device *dev,
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

In the failure case for both this devm_add_action_or_reset() and the one a few
lines down in the PMEM_Q_BIO case, I think you should manually call
pmem_release_queue() instead of calling blk_mq_free_tag_set().  This will free
the tag set and it will clean up the queue you just set up with
blk_mq_init_queue() or blk_alloc_queue_node().

> +			blk_mq_free_tag_set(&pmem->tag_set);
> +			return -ENOMEM;
> +		}
> +	} else if (queue_mode == PMEM_Q_BIO) {
> +		pmem->q = blk_alloc_queue_node(GFP_KERNEL, dev_to_node(dev));
> +		if (!pmem->q)
> +			return -ENOMEM;
> +
> +		if (devm_add_action_or_reset(dev, pmem_release_queue, pmem))

The 2nd case.  This one was like this in the previous code, but should be
fixed unless I'm missing something.

> +			return -ENOMEM;
> +
> +		blk_queue_make_request(pmem->q, pmem_make_request);
> +	} else {
> +		dev_warn(dev, "Invalid queue mode: %d\n", queue_mode);
> +		return -EINVAL;
> +	}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
