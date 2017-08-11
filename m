Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F2D02095E012
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 10:16:32 -0700 (PDT)
Subject: Re: [PATCH v4 7/8] libnvdimm: Adding blk-mq support to the pmem driver
References: <150212381454.23722.1549806704988615279.stgit@djiang5-desk3.ch.intel.com>
 <150212399361.23722.13317531480320953298.stgit@djiang5-desk3.ch.intel.com>
 <20170811105723.GA25839@infradead.org>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <7e2ca119-d83d-f66f-a3a4-50f515b9c553@intel.com>
Date: Fri, 11 Aug 2017 10:18:51 -0700
MIME-Version: 1.0
In-Reply-To: <20170811105723.GA25839@infradead.org>
Content-Language: en-US
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "Koul, Vinod" <vinod.koul@intel.com>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 08/11/2017 03:57 AM, Christoph Hellwig wrote:
> On Mon, Aug 07, 2017 at 09:39:53AM -0700, Dave Jiang wrote:
>> Adding blk-mq support to the pmem driver in addition to the direct bio
>> support.
> 
> Can you explain why this is only done for pmem and not btt and nd_blk?

Only because I have not gotten to them yet. I can follow up once the
pmem implementation is sorted out.

> 
>> This allows for hardware offloading via DMA engines. By default
>> the bio method will be enabled. The blk-mq support can be turned on via
>> module parameter queue_mode=1.
> 
> Any way to auto-discovery the right mode?  Also I'd actually much
> prefer for this to be a separate driver instead of having two entirely
> different I/O paths in the same module.

Ok. I'll look into implementing a separate driver.

> 
>> +struct pmem_cmd {
>> +	struct request *rq;
>> +};
> 
> There is no point in having private data that just has a struct
> request backpointer.  Just pass the request along.

ok

> 
>>  
>> -static void pmem_release_queue(void *q)
>> +static void pmem_release_queue(void *data)
>>  {
>> -	blk_cleanup_queue(q);
>> +	struct pmem_device *pmem = (struct pmem_device *)data;
> 
> No need for the cast.

ok

> 
>> +static int pmem_handle_cmd(struct pmem_cmd *cmd)
> 
> Please merge this into the queue_rq handler.
> 
>> +	struct request *req = cmd->rq;
>> +	struct request_queue *q = req->q;
>> +	struct pmem_device *pmem = q->queuedata;
>> +	struct nd_region *nd_region = to_region(pmem);
>> +	struct bio_vec bvec;
>> +	struct req_iterator iter;
>> +	int rc = 0;
>> +
>> +	if (req->cmd_flags & REQ_FLUSH)
>> +		nvdimm_flush(nd_region);
> 
> For a blk-mq driver you need to check for REQ_OP_FLUSH, .e.g.
> 
> 	switch (req_op(req)) {
> 	case REQ_FLUSH:
> 		ret = nvdimm_flush(nd_region);
> 		break;
> 	case REQ_OP_READ:
> 		ret = pmem_do_io(req, false);
> 		break;
> 	case REQ_OP_WRITE:
> 		ret = pmem_do_io(req, true);
> 		if (req->cmd_flags & REQ_FUA)
> 			nvdimm_flush(nd_region);
> 		break;
> 	default:
> 		ret = BLK_STS_NOTSUPP;
> 		break;
> 	}

ok

> 
>> +		pmem->tag_set.queue_depth = 64;
> 
> Where does this magic number come from?

It's pretty much random and just a place holder really. It probably
should be 1 since CPU copy is sync I/O. If I'm doing a separate driver
I'll merge this patch into the next one and deal with that then.

Thanks for reviewing Christoph!

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
