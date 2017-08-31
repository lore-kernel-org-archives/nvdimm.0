Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id E429421EB5290
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 03:54:33 -0700 (PDT)
Subject: Re: [v6,2/8] dmaengine: Add DMA_MEMCPY_SG transaction op
References: <150369477557.6962.17597022285367797559.stgit@djiang5-desk3.ch.intel.com>
 <65af5215-0386-6ae3-904e-ea1f09760105@arm.com>
 <7a30f87e-bae7-f499-8fdf-80b849a78a58@intel.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <1cae628f-63ff-fab6-8402-efb6edaf5a53@arm.com>
Date: Thu, 31 Aug 2017 11:57:13 +0100
MIME-Version: 1.0
In-Reply-To: <7a30f87e-bae7-f499-8fdf-80b849a78a58@intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>, "Koul, Vinod" <vinod.koul@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 30/08/17 19:25, Dave Jiang wrote:
> On 08/30/2017 11:18 AM, Robin Murphy wrote:
>> On 25/08/17 21:59, Dave Jiang wrote:
>>> Adding a dmaengine transaction operation that allows copy to/from a
>>> scatterlist and a flat buffer.
>>
>> Apologies if I'm late to the party, but doesn't DMA_SG already cover
>> this use-case? As far as I can see, all this does is save the caller
>> from setting up a single-entry scatterlist to describe the buffer - even
>> if such a simplified interface is justified it seems like something that
>> could be implemented as a wrapper around dmaengine_prep_dma_sg() rather
>> than the providers having to implement a whole extra callback.
>>
> 
> DMA_SG is queued to be removed in 4.14. There is no in kernel consumer
> for the code.

Ah, I see, that's what I was missing. So we're effectively just
replacing that interface with a more pragmatic alternative - that makes
sense.

Thanks,
Robin.

>>>
>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>> ---
>>>  Documentation/dmaengine/provider.txt |    3 +++
>>>  drivers/dma/dmaengine.c              |    2 ++
>>>  include/linux/dmaengine.h            |   19 +++++++++++++++++++
>>>  3 files changed, 24 insertions(+)
>>>
>>> diff --git a/Documentation/dmaengine/provider.txt b/Documentation/dmaengine/provider.txt
>>> index a75f52f..6241e36 100644
>>> --- a/Documentation/dmaengine/provider.txt
>>> +++ b/Documentation/dmaengine/provider.txt
>>> @@ -181,6 +181,9 @@ Currently, the types available are:
>>>      - Used by the client drivers to register a callback that will be
>>>        called on a regular basis through the DMA controller interrupt
>>>  
>>> +  * DMA_MEMCPY_SG
>>> +    - The device supports scatterlist to/from memory.
>>> +
>>>    * DMA_PRIVATE
>>>      - The devices only supports slave transfers, and as such isn't
>>>        available for async transfers.
>>> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
>>> index 428b141..4d2c4e1 100644
>>> --- a/drivers/dma/dmaengine.c
>>> +++ b/drivers/dma/dmaengine.c
>>> @@ -937,6 +937,8 @@ int dma_async_device_register(struct dma_device *device)
>>>  		!device->device_prep_dma_memset);
>>>  	BUG_ON(dma_has_cap(DMA_INTERRUPT, device->cap_mask) &&
>>>  		!device->device_prep_dma_interrupt);
>>> +	BUG_ON(dma_has_cap(DMA_MEMCPY_SG, device->cap_mask) &&
>>> +		!device->device_prep_dma_memcpy_sg);
>>>  	BUG_ON(dma_has_cap(DMA_CYCLIC, device->cap_mask) &&
>>>  		!device->device_prep_dma_cyclic);
>>>  	BUG_ON(dma_has_cap(DMA_INTERLEAVE, device->cap_mask) &&
>>> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
>>> index 64fbd38..0c91411 100644
>>> --- a/include/linux/dmaengine.h
>>> +++ b/include/linux/dmaengine.h
>>> @@ -67,6 +67,7 @@ enum dma_transaction_type {
>>>  	DMA_PQ_VAL,
>>>  	DMA_MEMSET,
>>>  	DMA_MEMSET_SG,
>>> +	DMA_MEMCPY_SG,
>>>  	DMA_INTERRUPT,
>>>  	DMA_PRIVATE,
>>>  	DMA_ASYNC_TX,
>>> @@ -692,6 +693,7 @@ struct dma_filter {
>>>   * @device_prep_dma_pq_val: prepares a pqzero_sum operation
>>>   * @device_prep_dma_memset: prepares a memset operation
>>>   * @device_prep_dma_memset_sg: prepares a memset operation over a scatter list
>>> + * @device_prep_dma_memcpy_sg: prepares memcpy between scatterlist and buffer
>>>   * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
>>>   * @device_prep_slave_sg: prepares a slave dma operation
>>>   * @device_prep_dma_cyclic: prepare a cyclic dma operation suitable for audio.
>>> @@ -768,6 +770,10 @@ struct dma_device {
>>>  	struct dma_async_tx_descriptor *(*device_prep_dma_memset_sg)(
>>>  		struct dma_chan *chan, struct scatterlist *sg,
>>>  		unsigned int nents, int value, unsigned long flags);
>>> +	struct dma_async_tx_descriptor *(*device_prep_dma_memcpy_sg)(
>>> +		struct dma_chan *chan,
>>> +		struct scatterlist *sg, unsigned int sg_nents,
>>> +		dma_addr_t buf, bool to_sg, unsigned long flags);
>>>  	struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
>>>  		struct dma_chan *chan, unsigned long flags);
>>>  
>>> @@ -899,6 +905,19 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_memcpy(
>>>  						    len, flags);
>>>  }
>>>  
>>> +static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_memcpy_sg(
>>> +		struct dma_chan *chan, struct scatterlist *sg,
>>> +		unsigned int sg_nents, dma_addr_t buf, bool to_sg,
>>> +		unsigned long flags)
>>> +{
>>> +	if (!chan || !chan->device ||
>>> +			!chan->device->device_prep_dma_memcpy_sg)
>>> +		return NULL;
>>> +
>>> +	return chan->device->device_prep_dma_memcpy_sg(chan, sg, sg_nents,
>>> +						       buf, to_sg, flags);
>>> +}
>>> +
>>>  /**
>>>   * dmaengine_terminate_all() - Terminate all active DMA transfers
>>>   * @chan: The channel for which to terminate the transfers
>>>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
