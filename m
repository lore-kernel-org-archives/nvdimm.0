Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.mailbox.org (mx1.mailbox.org [80.241.60.212])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DDDA320349DAC
 for <linux-nvdimm@lists.01.org>; Mon, 13 Nov 2017 00:24:50 -0800 (PST)
Subject: Re: [v6,2/8] dmaengine: Add DMA_MEMCPY_SG transaction op
References: <150369477557.6962.17597022285367797559.stgit@djiang5-desk3.ch.intel.com>
 <65af5215-0386-6ae3-904e-ea1f09760105@arm.com>
 <7a30f87e-bae7-f499-8fdf-80b849a78a58@intel.com>
 <1cae628f-63ff-fab6-8402-efb6edaf5a53@arm.com>
From: Stefan Roese <sr@denx.de>
Message-ID: <e1d4c401-c96f-0a07-bc85-669329d1f618@denx.de>
Date: Mon, 13 Nov 2017 09:28:46 +0100
MIME-Version: 1.0
In-Reply-To: <1cae628f-63ff-fab6-8402-efb6edaf5a53@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Koul, Vinod" <vinod.koul@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "hch@infradead.org" <hch@infradead.org>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Vinod,

On 31.08.2017 12:57, Robin Murphy wrote:
> On 30/08/17 19:25, Dave Jiang wrote:
>> On 08/30/2017 11:18 AM, Robin Murphy wrote:
>>> On 25/08/17 21:59, Dave Jiang wrote:
>>>> Adding a dmaengine transaction operation that allows copy to/from a
>>>> scatterlist and a flat buffer.
>>>
>>> Apologies if I'm late to the party, but doesn't DMA_SG already cover
>>> this use-case? As far as I can see, all this does is save the caller
>>> from setting up a single-entry scatterlist to describe the buffer - even
>>> if such a simplified interface is justified it seems like something that
>>> could be implemented as a wrapper around dmaengine_prep_dma_sg() rather
>>> than the providers having to implement a whole extra callback.
>>>
>>
>> DMA_SG is queued to be removed in 4.14. There is no in kernel consumer
>> for the code.
> 
> Ah, I see, that's what I was missing. So we're effectively just
> replacing that interface with a more pragmatic alternative - that makes
> sense.

What are the plans with this new DMA_MEMCPY_SG interface? When will it
hit mainline or is something missing?

Thanks,
Stefan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
