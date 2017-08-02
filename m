Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 50DBD21AEB0A3
 for <linux-nvdimm@lists.01.org>; Wed,  2 Aug 2017 14:08:05 -0700 (PDT)
Subject: Re: [PATCH v2 5/5] libnvdimm: add DMA support for pmem blk-mq
References: <150169902310.59677.18062301799811367806.stgit@djiang5-desk3.ch.intel.com>
 <150169928551.59677.14690799553760064519.stgit@djiang5-desk3.ch.intel.com>
 <f21abd33-f64c-909d-ec1a-ab0a1cf021e7@codeaurora.org>
 <245fbb9a-d841-2c70-481b-19a0483c3872@intel.com>
From: Sinan Kaya <okaya@codeaurora.org>
Message-ID: <220335ff-808c-e71a-7f8e-c62d698dadca@codeaurora.org>
Date: Wed, 2 Aug 2017 17:10:14 -0400
MIME-Version: 1.0
In-Reply-To: <245fbb9a-d841-2c70-481b-19a0483c3872@intel.com>
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
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 8/2/2017 4:52 PM, Dave Jiang wrote:
>> Do we need a new API / new function, or new capability?
> Hmmm...you are right. I wonder if we need something like DMA_SG cap....
> 
> 

Unfortunately, DMA_SG means something else. Maybe, we need DMA_MEMCPY_SG
to be similar with DMA_MEMSET_SG.

enum dma_transaction_type {
	DMA_MEMCPY,
	DMA_XOR,
	DMA_PQ,
	DMA_XOR_VAL,
	DMA_PQ_VAL,
	DMA_MEMSET,
	DMA_MEMSET_SG,
	DMA_INTERRUPT,
	DMA_SG,
	DMA_PRIVATE,
	DMA_ASYNC_TX,
	DMA_SLAVE,
	DMA_CYCLIC,
	DMA_INTERLEAVE,
/* last transaction type for creation of the capabilities mask */
	DMA_TX_TYPE_END,
};

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
