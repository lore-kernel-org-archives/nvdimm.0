Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5FBC82094561A
 for <linux-nvdimm@lists.01.org>; Mon,  8 Jan 2018 10:29:25 -0800 (PST)
Date: Mon, 8 Jan 2018 19:34:34 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/12] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
Message-ID: <20180108183434.GA15549@lst.de>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-7-logang@deltatee.com> <20180104192225.GS11348@ziepe.ca>
 <1f8fb3fb-e3dc-94d3-e837-0cd942cf5b87@deltatee.com>
 <20180104221337.GV11348@ziepe.ca>
 <3e8391a9-8924-be6d-8c43-162a360d75b6@deltatee.com>
 <20180105045031.GX11348@ziepe.ca> <20180108145901.GA10743@lst.de>
 <20180108180917.GF11348@ziepe.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180108180917.GF11348@ziepe.ca>
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
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 08, 2018 at 11:09:17AM -0700, Jason Gunthorpe wrote:
> > As usual we implement what actually has a consumer.  On top of that the
> > R/W API is the only core RDMA API that actually does DMA mapping for the
> > ULP at the moment.
> 
> Well again the same can be said for dma_map_page vs dma_map_sg...

I don't understand this comment.

> 
> > For SENDs and everything else dma maps are done by the ULP (I'd like
> > to eventually change that, though - e.g. sends through that are
> > inline to the workqueue don't need a dma map to start with).
> 
> 
> > That's because the initial design was to let the ULPs do the DMA
> > mappings, which fundamentally is wrong.  I've fixed it for the R/W
> > API when adding it, but no one has started work on SENDs and atomics.
> 
> Well, you know why it is like this, and it is very complicated to
> unwind - the HW driver does not have enough information during CQ
> processing to properly do any unmaps, let alone serious error tear
> down unmaps, so we'd need a bunch of new APIs developed first, like RW
> did. :\

Yes, if it was trivial we would have done it already.

> > > And on that topic, does this scheme work with HFI?
> > 
> > No, and I guess we need an opt-out.  HFI generally seems to be
> > extremely weird.
> 
> This series needs some kind of fix so HFI, QIB, rxe, etc don't get
> broken, and it shouldn't be 'fixed' at the RDMA level.

I don't think rxe is a problem as it won't show up a pci device.
HFI and QIB do show as PCI devices, and could be used for P2P transfers
from the PCI point of view.  It's just that they have a layer of
software indirection between their hardware and what is exposed at
the RDMA layer.

So I very much disagree about where to place that workaround - the
RDMA code is exactly the right place.

> > > This is why P2P must fit in to the common DMA framework somehow, we
> > > rely on these abstractions to work properly and fully in RDMA.
> > 
> > Moving P2P up to common RDMA code isn't going to fix this.  For that
> > we need to stop preting that something that isn't DMA can abuse the
> > dma mapping framework, and until then opt them out of behavior that
> > assumes actual DMA like P2P.
> 
> It could, if we had a DMA op for p2p then the drivers that provide
> their own ops can implement it appropriately or not at all.
> 
> Eg the correct implementation for rxe to support p2p memory is
> probably somewhat straightfoward.

But P2P is _not_ a factor of the dma_ops implementation at all,
it is something that happens behind the dma_map implementation.

Think about what the dma mapping routines do:

 (a) translate from host address to bus addresses

and

 (b) flush caches (in non-coherent architectures)

Both are obviously not needed for P2P transfers, as they never reach
the host.

> Very long term the IOMMUs under the ops will need to care about this,
> so the wrapper is not an optimal place to put it - but I wouldn't
> object if it gets it out of RDMA :)

Unless you have an IOMMU on your PCIe switch and not before/inside
the root complex that is not correct.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
