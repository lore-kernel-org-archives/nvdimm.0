Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B25E321E1DAEB
 for <linux-nvdimm@lists.01.org>; Wed,  2 Aug 2017 12:20:40 -0700 (PDT)
Subject: Re: [PATCH v2 5/5] libnvdimm: add DMA support for pmem blk-mq
References: <150169902310.59677.18062301799811367806.stgit@djiang5-desk3.ch.intel.com>
 <150169928551.59677.14690799553760064519.stgit@djiang5-desk3.ch.intel.com>
From: Sinan Kaya <okaya@codeaurora.org>
Message-ID: <f21abd33-f64c-909d-ec1a-ab0a1cf021e7@codeaurora.org>
Date: Wed, 2 Aug 2017 15:22:49 -0400
MIME-Version: 1.0
In-Reply-To: <150169928551.59677.14690799553760064519.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>, vinod.koul@intel.com, dan.j.williams@intel.com
Cc: dmaengine@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 8/2/2017 2:41 PM, Dave Jiang wrote:
>  	if (queue_mode == PMEM_Q_MQ) {
> +		chan = dma_find_channel(DMA_MEMCPY);
> +		if (!chan) {
> +			queue_mode = PMEM_Q_BIO;
> +			dev_warn(dev, "Forced back to PMEM_Q_BIO, no DMA\n");
> +		}

We can't expect all MEMCPY capable hardware to support this feature, right?

Do we need a new API / new function, or new capability?

> +	}


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
