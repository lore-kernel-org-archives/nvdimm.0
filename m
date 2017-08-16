Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1C5BC21CFA5FC
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 09:45:11 -0700 (PDT)
Date: Wed, 16 Aug 2017 22:20:46 +0530
From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH v2 5/5] libnvdimm: add DMA support for pmem blk-mq
Message-ID: <20170816165046.GS3053@localhost>
References: <220335ff-808c-e71a-7f8e-c62d698dadca@codeaurora.org>
 <5a5c415a-e354-20a7-c762-89dcf47032bb@intel.com>
 <20170803050154.GE3053@localhost>
 <423B07FD-31B3-424B-849E-FAC5C0AD8FAE@intel.com>
 <20170803052817.GF3053@localhost>
 <542773BA-C532-4125-BCE9-6E8889EBF272@intel.com>
 <20170803085941.GG3053@localhost>
 <6B9F6DC1-F9BC-4DF5-A09D-DA74B4953E57@intel.com>
 <20170803155554.GH3053@localhost>
 <CAPcyv4gO770F9_Dx1PtNq0Tk-79nhU=2O-jokuNT+pr0hXHUtg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gO770F9_Dx1PtNq0Tk-79nhU=2O-jokuNT+pr0hXHUtg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Sinan Kaya <okaya@codeaurora.org>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 03, 2017 at 09:14:13AM -0700, Dan Williams wrote:
> >> >>>>>>>>> Do we need a new API / new function, or new capability?
> >> >>>>>>>> Hmmm...you are right. I wonder if we need something like DMA_SG cap....
> >> >>>>>>>>
> >> >>>>>>>>
> >> >>>>>>>
> >> >>>>>>> Unfortunately, DMA_SG means something else. Maybe, we need DMA_MEMCPY_SG
> >> >>>>>>> to be similar with DMA_MEMSET_SG.
> >> >>>>>>
> >> >>>>>> I'm ok with that if Vinod is.
> >> >>>>>
> >> >>>>> So what exactly is the ask here, are you trying to do MEMCPY or SG or MEMSET
> >> >>>>> or all :). We should have done bitfields for this though...
> >> >>>>
> >> >>>> Add DMA_MEMCPY_SG to transaction type.
> >> >>>
> >> >>> Not MEMSET right, then why not use DMA_SG, DMA_SG is supposed for
> >> >>> scatterlist to scatterlist copy which is used to check for
> >> >>> device_prep_dma_sg() calls
> >> >>>
> >> >> Right. But we are doing flat buffer to/from scatterlist, not sg to sg. So
> >> >> we need something separate than what DMA_SG is used for.
> >> >
> >> > Hmm, its SG-buffer  and its memcpy, so should we call it DMA_SG_BUFFER,
> >> > since it is not memset (or is it) I would not call it memset, or maybe we
> >> > should also change DMA_SG to DMA_SG_SG to make it terribly clear :D
> >>
> >> I can create patches for both.
> >
> > Great, anyone who disagrees or can give better names :)
> 
> All my suggestions would involve a lot more work. If we had infinite
> time we'd stop with the per-operation-type entry points and make this
> look like a typical driver sub-system that takes commands like
> block-devices or usb, but perhaps that ship has sailed.

Can you elaborate on this :)

I have been thinking about the need to redo the API. So lets discuss :)

-- 
~Vinod
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
