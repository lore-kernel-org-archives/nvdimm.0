Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6FE30208F7A8B
 for <linux-nvdimm@lists.01.org>; Wed,  2 Aug 2017 21:56:42 -0700 (PDT)
Date: Thu, 3 Aug 2017 10:31:54 +0530
From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH v2 5/5] libnvdimm: add DMA support for pmem blk-mq
Message-ID: <20170803050154.GE3053@localhost>
References: <150169902310.59677.18062301799811367806.stgit@djiang5-desk3.ch.intel.com>
 <150169928551.59677.14690799553760064519.stgit@djiang5-desk3.ch.intel.com>
 <f21abd33-f64c-909d-ec1a-ab0a1cf021e7@codeaurora.org>
 <245fbb9a-d841-2c70-481b-19a0483c3872@intel.com>
 <220335ff-808c-e71a-7f8e-c62d698dadca@codeaurora.org>
 <5a5c415a-e354-20a7-c762-89dcf47032bb@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5a5c415a-e354-20a7-c762-89dcf47032bb@intel.com>
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
Cc: Sinan Kaya <okaya@codeaurora.org>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 02, 2017 at 02:13:56PM -0700, Dave Jiang wrote:
> 
> 
> On 08/02/2017 02:10 PM, Sinan Kaya wrote:
> > On 8/2/2017 4:52 PM, Dave Jiang wrote:
> >>> Do we need a new API / new function, or new capability?
> >> Hmmm...you are right. I wonder if we need something like DMA_SG cap....
> >>
> >>
> > 
> > Unfortunately, DMA_SG means something else. Maybe, we need DMA_MEMCPY_SG
> > to be similar with DMA_MEMSET_SG.
> 
> I'm ok with that if Vinod is.

So what exactly is the ask here, are you trying to do MEMCPY or SG or MEMSET
or all :). We should have done bitfields for this though...

> 
> > 
> > enum dma_transaction_type {
> > 	DMA_MEMCPY,
> > 	DMA_XOR,
> > 	DMA_PQ,
> > 	DMA_XOR_VAL,
> > 	DMA_PQ_VAL,
> > 	DMA_MEMSET,
> > 	DMA_MEMSET_SG,
> > 	DMA_INTERRUPT,
> > 	DMA_SG,
> > 	DMA_PRIVATE,
> > 	DMA_ASYNC_TX,
> > 	DMA_SLAVE,
> > 	DMA_CYCLIC,
> > 	DMA_INTERLEAVE,
> > /* last transaction type for creation of the capabilities mask */
> > 	DMA_TX_TYPE_END,
> > };
> > 

-- 
~Vinod
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
