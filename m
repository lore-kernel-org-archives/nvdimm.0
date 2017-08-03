Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa4.dell-outbound.iphmx.com (esa4.dell-outbound.iphmx.com
 [68.232.149.214])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BB18C21C9126D
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 11:33:58 -0700 (PDT)
From: "Allen Hubbe" <Allen.Hubbe@dell.com>
References: <f21abd33-f64c-909d-ec1a-ab0a1cf021e7@codeaurora.org>
 <245fbb9a-d841-2c70-481b-19a0483c3872@intel.com>
 <220335ff-808c-e71a-7f8e-c62d698dadca@codeaurora.org>
 <5a5c415a-e354-20a7-c762-89dcf47032bb@intel.com>
 <20170803050154.GE3053@localhost>
 <423B07FD-31B3-424B-849E-FAC5C0AD8FAE@intel.com>
 <20170803052817.GF3053@localhost>
 <542773BA-C532-4125-BCE9-6E8889EBF272@intel.com>
 <20170803085941.GG3053@localhost>
 <6B9F6DC1-F9BC-4DF5-A09D-DA74B4953E57@intel.com>
 <20170803155554.GH3053@localhost>
 <CAPcyv4gO770F9_Dx1PtNq0Tk-79nhU=2O-jokuNT+pr0hXHUtg@mail.gmail.com>
 <8406619e-8b95-5c23-6a15-816af0805bf5@intel.com>
In-Reply-To: <8406619e-8b95-5c23-6a15-816af0805bf5@intel.com>
Subject: RE: [PATCH v2 5/5] libnvdimm: add DMA support for pmem blk-mq
Date: Thu, 3 Aug 2017 14:35:53 -0400
Message-ID: <000001d30c87$57679200$0636b600$@dell.com>
MIME-Version: 1.0
Content-Language: en-us
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
To: 'Dave Jiang' <dave.jiang@intel.com>, 'Dan Williams' <dan.j.williams@intel.com>, "'Koul, Vinod'" <vinod.koul@intel.com>
Cc: 'Sinan Kaya' <okaya@codeaurora.org>, dmaengine@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Dave Jiang
> On 08/03/2017 09:14 AM, Dan Williams wrote:
> > On Thu, Aug 3, 2017 at 8:55 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> >> On Thu, Aug 03, 2017 at 08:06:07PM +0530, Jiang, Dave wrote:
> >>>> On Aug 3, 2017, at 1:56 AM, Koul, Vinod <vinod.koul@intel.com> wrote:
> >>>>> On Thu, Aug 03, 2017 at 11:06:13AM +0530, Jiang, Dave wrote:
> >>>>>>> On Aug 2, 2017, at 10:25 PM, Koul, Vinod <vinod.koul@intel.com> wrote:
> >>>>>>> On Thu, Aug 03, 2017 at 10:41:51AM +0530, Jiang, Dave wrote:
> >>>>>>>>> On Aug 2, 2017, at 9:58 PM, Koul, Vinod <vinod.koul@intel.com> wrote:
> >>>>>>>>> On Wed, Aug 02, 2017 at 02:13:56PM -0700, Dave Jiang wrote:
> >>>>>>>>>> On 08/02/2017 02:10 PM, Sinan Kaya wrote:
> >>>>>>>>>> On 8/2/2017 4:52 PM, Dave Jiang wrote:
> >>>>>>>>>>>> Do we need a new API / new function, or new capability?
> >>>>>>>>>>> Hmmm...you are right. I wonder if we need something like DMA_SG cap....
> >>>>>>>>>>
> >>>>>>>>>> Unfortunately, DMA_SG means something else. Maybe, we need DMA_MEMCPY_SG
> >>>>>>>>>> to be similar with DMA_MEMSET_SG.
> >>>>>>>>>
> >>>>>>>>> I'm ok with that if Vinod is.
> >>>>>>>>
> >>>>>>>> So what exactly is the ask here, are you trying to do MEMCPY or SG or MEMSET
> >>>>>>>> or all :). We should have done bitfields for this though...
> >>>>>>>
> >>>>>>> Add DMA_MEMCPY_SG to transaction type.
> >>>>>>
> >>>>>> Not MEMSET right, then why not use DMA_SG, DMA_SG is supposed for
> >>>>>> scatterlist to scatterlist copy which is used to check for
> >>>>>> device_prep_dma_sg() calls
> >>>>>>
> >>>>> Right. But we are doing flat buffer to/from scatterlist, not sg to sg. So
> >>>>> we need something separate than what DMA_SG is used for.
> >>>>
> >>>> Hmm, its SG-buffer  and its memcpy, so should we call it DMA_SG_BUFFER,
> >>>> since it is not memset (or is it) I would not call it memset, or maybe we
> >>>> should also change DMA_SG to DMA_SG_SG to make it terribly clear :D
> >>>
> >>> I can create patches for both.
> >>
> >> Great, anyone who disagrees or can give better names :)
> >
> > All my suggestions would involve a lot more work. If we had infinite
> > time we'd stop with the per-operation-type entry points and make this
> > look like a typical driver sub-system that takes commands like
> > block-devices or usb, but perhaps that ship has sailed.
> 
> Allen, isn't this what we were just talking about on IRC yesterday?
> 
> <allenbh> I dislike prep_tx grabbing a device-specific descriptor.  The
> device really only needs as many device-specific descriptors will keep
> the hw busy, and just let the logical layer queue up logical descriptors
> until hw descriptors become available.  Let the client allocate
> descriptors to submit, and hw driver can translate to a
> hardware-specific descriptor at the last moment before notifying the hw.

Yeah, that last part, "like a typical driver sub-system that takes commands" +1!

Especially if the client can submit a list of commands.  I have an rdma driver using the dmaengine api, but it would be more natural to build up a list of dma operations, just using my driver's own memory and the struct definition of some abstract dma descriptor, not calling any functions of the dmaengine api.  After building the list of descriptors, submit the entire list all at once to the hardware driver, or not at all.  Instead, in perf I see a lot of heat on that spinlock for each individual dma prep in ioat (sorry for picking on you, Dave, this is the only dma engine hw and driver that I am familiar with).

Also, I think we could glean some more efficiency if the dma completion path took a hint from napi_schedule() and napi->poll(), instead of scheduling a tasklet directly in the dmaengine hw driver.  For one thing, it could reduce the number of interrupts.  Also, coordinating the servicing of dma completions with the posting of new work, with the schedule determined from the top of the stack down, could further reduce contention on that lock between dma prep and cleanup/complete.

http://elixir.free-electrons.com/linux/v4.12.4/source/drivers/dma/ioat/dma.c#L448
http://elixir.free-electrons.com/linux/v4.12.4/source/drivers/dma/ioat/dma.c#L652

Also, I apologize for not offering to do all this work.  If I was ready to jump in do it, I would have spoken up earlier.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
