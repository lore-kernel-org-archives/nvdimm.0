Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 8 Jan 2018 11:09:17 -0700
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 06/12] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
Message-ID: <20180108180917.GF11348@ziepe.ca>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-7-logang@deltatee.com>
 <20180104192225.GS11348@ziepe.ca>
 <1f8fb3fb-e3dc-94d3-e837-0cd942cf5b87@deltatee.com>
 <20180104221337.GV11348@ziepe.ca>
 <3e8391a9-8924-be6d-8c43-162a360d75b6@deltatee.com>
 <20180105045031.GX11348@ziepe.ca>
 <20180108145901.GA10743@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180108145901.GA10743@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 08, 2018 at 03:59:01PM +0100, Christoph Hellwig wrote:
> On Thu, Jan 04, 2018 at 09:50:31PM -0700, Jason Gunthorpe wrote:
> > Well that argument applies equally to the RDMA RW API wrappers around
> > the DMA API. I think it is fine if sgl are defined to only have P2P or
> > not, and that debugging support seemed reasonable to me..
> > 
> > > It's also very difficult to add similar functionality to dma_map_page seeing
> > > dma_unmap_page won't have any way to know what it's dealing with. It just
> > > seems confusing to support P2P in the SG version and not the page version.
> > 
> > Well, this proposal is to support P2P in only some RDMA APIs and not
> > others, so it seems about as confusing to me..
> 
> As usual we implement what actually has a consumer.  On top of that the
> R/W API is the only core RDMA API that actually does DMA mapping for the
> ULP at the moment.

Well again the same can be said for dma_map_page vs dma_map_sg...

> For SENDs and everything else dma maps are done by the ULP (I'd like
> to eventually change that, though - e.g. sends through that are
> inline to the workqueue don't need a dma map to start with).


> That's because the initial design was to let the ULPs do the DMA
> mappings, which fundamentally is wrong.  I've fixed it for the R/W
> API when adding it, but no one has started work on SENDs and atomics.

Well, you know why it is like this, and it is very complicated to
unwind - the HW driver does not have enough information during CQ
processing to properly do any unmaps, let alone serious error tear
down unmaps, so we'd need a bunch of new APIs developed first, like RW
did. :\

> > And on that topic, does this scheme work with HFI?
> 
> No, and I guess we need an opt-out.  HFI generally seems to be
> extremely weird.

This series needs some kind of fix so HFI, QIB, rxe, etc don't get
broken, and it shouldn't be 'fixed' at the RDMA level.

> > This is why P2P must fit in to the common DMA framework somehow, we
> > rely on these abstractions to work properly and fully in RDMA.
> 
> Moving P2P up to common RDMA code isn't going to fix this.  For that
> we need to stop preting that something that isn't DMA can abuse the
> dma mapping framework, and until then opt them out of behavior that
> assumes actual DMA like P2P.

It could, if we had a DMA op for p2p then the drivers that provide
their own ops can implement it appropriately or not at all.

Eg the correct implementation for rxe to support p2p memory is
probably somewhat straightfoward.

> > I think you should consider pushing this directly into the dma_ops
> > implementations. Add a p2p_supported flag to struct dma_map_ops, and
> > only if it is true can a caller pass a homogeneous SGL to ops->map_sg.
> > Only map_sg would be supported for P2P. Upgraded implementations can
> > call the helper function.
> 
> If at all it should be in the dma_map* wrappers, but for that we'd need
> a good identifier.  And it still would not solve the whole fake dma
> ops issue.

Very long term the IOMMUs under the ops will need to care about this,
so the wrapper is not an optimal place to put it - but I wouldn't
object if it gets it out of RDMA :)

Jason
