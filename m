Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 82A1821E1DAEB
 for <linux-nvdimm@lists.01.org>; Wed,  2 Aug 2017 13:50:37 -0700 (PDT)
Subject: Re: [PATCH v2 5/5] libnvdimm: add DMA support for pmem blk-mq
References: <150169902310.59677.18062301799811367806.stgit@djiang5-desk3.ch.intel.com>
 <150169928551.59677.14690799553760064519.stgit@djiang5-desk3.ch.intel.com>
 <f21abd33-f64c-909d-ec1a-ab0a1cf021e7@codeaurora.org>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <245fbb9a-d841-2c70-481b-19a0483c3872@intel.com>
Date: Wed, 2 Aug 2017 13:52:46 -0700
MIME-Version: 1.0
In-Reply-To: <f21abd33-f64c-909d-ec1a-ab0a1cf021e7@codeaurora.org>
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
To: Sinan Kaya <okaya@codeaurora.org>, "Koul, Vinod" <vinod.koul@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 08/02/2017 12:22 PM, Sinan Kaya wrote:
> On 8/2/2017 2:41 PM, Dave Jiang wrote:
>>  	if (queue_mode == PMEM_Q_MQ) {
>> +		chan = dma_find_channel(DMA_MEMCPY);
>> +		if (!chan) {
>> +			queue_mode = PMEM_Q_BIO;
>> +			dev_warn(dev, "Forced back to PMEM_Q_BIO, no DMA\n");
>> +		}
> 
> We can't expect all MEMCPY capable hardware to support this feature, right?
> 
> Do we need a new API / new function, or new capability?

Hmmm...you are right. I wonder if we need something like DMA_SG cap....


> 
>> +	}
> 
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
