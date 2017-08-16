Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x232.google.com (mail-yw0-x232.google.com
 [IPv6:2607:f8b0:4002:c05::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A749E21D18253
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 10:03:41 -0700 (PDT)
Received: by mail-yw0-x232.google.com with SMTP id p68so26505694ywg.0
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 10:06:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170816165046.GS3053@localhost>
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
 <20170816165046.GS3053@localhost>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Aug 2017 10:06:06 -0700
Message-ID: <CAPcyv4iZ+TaqLVmgreRCvbAFBZOmNaUDC4jm4WKzOGj0UrZS7A@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] libnvdimm: add DMA support for pmem blk-mq
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
To: Vinod Koul <vinod.koul@intel.com>
Cc: Sinan Kaya <okaya@codeaurora.org>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 16, 2017 at 9:50 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Thu, Aug 03, 2017 at 09:14:13AM -0700, Dan Williams wrote:
>> >> >>>>>>>>> Do we need a new API / new function, or new capability?
>> >> >>>>>>>> Hmmm...you are right. I wonder if we need something like DMA_SG cap....
>> >> >>>>>>>>
>> >> >>>>>>>>
>> >> >>>>>>>
>> >> >>>>>>> Unfortunately, DMA_SG means something else. Maybe, we need DMA_MEMCPY_SG
>> >> >>>>>>> to be similar with DMA_MEMSET_SG.
>> >> >>>>>>
>> >> >>>>>> I'm ok with that if Vinod is.
>> >> >>>>>
>> >> >>>>> So what exactly is the ask here, are you trying to do MEMCPY or SG or MEMSET
>> >> >>>>> or all :). We should have done bitfields for this though...
>> >> >>>>
>> >> >>>> Add DMA_MEMCPY_SG to transaction type.
>> >> >>>
>> >> >>> Not MEMSET right, then why not use DMA_SG, DMA_SG is supposed for
>> >> >>> scatterlist to scatterlist copy which is used to check for
>> >> >>> device_prep_dma_sg() calls
>> >> >>>
>> >> >> Right. But we are doing flat buffer to/from scatterlist, not sg to sg. So
>> >> >> we need something separate than what DMA_SG is used for.
>> >> >
>> >> > Hmm, its SG-buffer  and its memcpy, so should we call it DMA_SG_BUFFER,
>> >> > since it is not memset (or is it) I would not call it memset, or maybe we
>> >> > should also change DMA_SG to DMA_SG_SG to make it terribly clear :D
>> >>
>> >> I can create patches for both.
>> >
>> > Great, anyone who disagrees or can give better names :)
>>
>> All my suggestions would involve a lot more work. If we had infinite
>> time we'd stop with the per-operation-type entry points and make this
>> look like a typical driver sub-system that takes commands like
>> block-devices or usb, but perhaps that ship has sailed.
>
> Can you elaborate on this :)
>
> I have been thinking about the need to redo the API. So lets discuss :)

The high level is straightforward, the devil is in the details. Define
a generic dma command object, perhaps 'struct dma_io' certainly not
'struct dma_async_tx_descriptor', and have just one entry point
per-driver. That 'struct dma_io' would carry a generic command number
a target address and a scatterlist. The driver entry point would then
convert and build the command to the hardware command format plus
submission queue. The basic driving design principle is convert all
the current function pointer complexity with the prep_* routines into
data structure complexity in the common command format.

This trades off some efficiency because now you need to write the
generic command and write the descriptor, but I think if the operation
is worth offloading those conversion costs must already be in the
noise.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
