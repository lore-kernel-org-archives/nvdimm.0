Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 303D3209589FF
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 21:51:52 -0700 (PDT)
Date: Wed, 2 Aug 2017 10:27:02 +0530
From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 2/5] dmaengine: ioatdma: dma_prep_memcpy_to/from_sg support
Message-ID: <20170802045702.GV3053@localhost>
References: <150153948477.49768.5767882242140065474.stgit@djiang5-desk3.ch.intel.com>
 <150153986963.49768.7407643931348757530.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4h7ZbKATEMHs-SpOXoVk8qY3KU-21VR042BeB-ovV2hKg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4h7ZbKATEMHs-SpOXoVk8qY3KU-21VR042BeB-ovV2hKg@mail.gmail.com>
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
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 31, 2017 at 07:14:10PM -0700, Dan Williams wrote:
> >  static struct dma_async_tx_descriptor *
> >  __ioat_prep_xor_lock(struct dma_chan *c, enum sum_check_flags *result,
> > diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> > index 5336808..6202e7c 100644
> > --- a/include/linux/dmaengine.h
> > +++ b/include/linux/dmaengine.h
> > @@ -694,6 +694,8 @@ struct dma_filter {
> >   * @device_prep_dma_memset: prepares a memset operation
> >   * @device_prep_dma_memset_sg: prepares a memset operation over a scatter list
> >   * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
> > + * @device_prep_dma_memcpy_to_sg: prepares memcpy from buffer to scatterlist
> > + * @device_prep_dma_memcpy_from_sg: prepares memcpy from scatterlist to buffer
> >   * @device_prep_slave_sg: prepares a slave dma operation
> >   * @device_prep_dma_cyclic: prepare a cyclic dma operation suitable for audio.
> >   *     The function takes a buffer of size buf_len. The callback function will
> > @@ -776,6 +778,14 @@ struct dma_device {
> >                 struct scatterlist *dst_sg, unsigned int dst_nents,
> >                 struct scatterlist *src_sg, unsigned int src_nents,
> >                 unsigned long flags);
> > +       struct dma_async_tx_descriptor *(*device_prep_dma_memcpy_to_sg)(
> > +               struct dma_chan *chan,
> > +               struct scatterlist *dst_sg, unsigned int dst_nents,
> > +               dma_addr_t src, unsigned long flags);
> > +       struct dma_async_tx_descriptor *(*device_prep_dma_memcpy_from_sg)(
> > +               struct dma_chan *chan, dma_addr_t dst,
> > +               struct scatterlist *dst_sg, unsigned int dst_nents,
> > +               unsigned long flags);
> >
> >         struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
> >                 struct dma_chan *chan, struct scatterlist *sgl,
> >
> 
> Can we get away with just adding one new operation with a flag to
> indicate whether it is the 'to' or' 'from' sg case?

Yeah that would be better..

-- 
~Vinod
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
