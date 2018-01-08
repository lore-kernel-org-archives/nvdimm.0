Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B680B222275AA
 for <linux-nvdimm@lists.01.org>; Mon,  8 Jan 2018 06:53:54 -0800 (PST)
Date: Mon, 8 Jan 2018 15:59:01 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/12] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
Message-ID: <20180108145901.GA10743@lst.de>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-7-logang@deltatee.com> <20180104192225.GS11348@ziepe.ca>
 <1f8fb3fb-e3dc-94d3-e837-0cd942cf5b87@deltatee.com>
 <20180104221337.GV11348@ziepe.ca>
 <3e8391a9-8924-be6d-8c43-162a360d75b6@deltatee.com>
 <20180105045031.GX11348@ziepe.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180105045031.GX11348@ziepe.ca>
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

On Thu, Jan 04, 2018 at 09:50:31PM -0700, Jason Gunthorpe wrote:
> Well that argument applies equally to the RDMA RW API wrappers around
> the DMA API. I think it is fine if sgl are defined to only have P2P or
> not, and that debugging support seemed reasonable to me..
> 
> > It's also very difficult to add similar functionality to dma_map_page seeing
> > dma_unmap_page won't have any way to know what it's dealing with. It just
> > seems confusing to support P2P in the SG version and not the page version.
> 
> Well, this proposal is to support P2P in only some RDMA APIs and not
> others, so it seems about as confusing to me..

As usual we implement what actually has a consumer.  On top of that the
R/W API is the only core RDMA API that actually does DMA mapping for the
ULP at the moment.  For SENDs and everything else dma maps are done by
the ULP (I'd like to eventually change that, though - e.g. sends through
that are inline to the workqueue don't need a dma map to start with).

> Well, it is more than very nice. We have to keep RDMA working after
> all, and if you make it even more special things become harder for us.
> 
> It is already the case that DMA in RDMA is very strange. We have
> drivers that provide their own DMA ops, for instance.

That's because the initial design was to let the ULPs do the DMA
mappings, which fundamentally is wrong.  I've fixed it for the R/W
API when adding it, but no one has started work on SENDs and atomics.

> And on that topic, does this scheme work with HFI?

No, and I guess we need an opt-out.  HFI generally seems to be
extremely weird.

> This is why P2P must fit in to the common DMA framework somehow, we
> rely on these abstractions to work properly and fully in RDMA.

Moving P2P up to common RDMA code isn't going to fix this.  For that
we need to stop preting that something that isn't DMA can abuse the
dma mapping framework, and until then opt them out of behavior that
assumes actual DMA like P2P.

> I think you should consider pushing this directly into the dma_ops
> implementations. Add a p2p_supported flag to struct dma_map_ops, and
> only if it is true can a caller pass a homogeneous SGL to ops->map_sg.
> Only map_sg would be supported for P2P. Upgraded implementations can
> call the helper function.

If at all it should be in the dma_map* wrappers, but for that we'd need
a good identifier.  And it still would not solve the whole fake dma
ops issue.

So for now I'd much prefer to let the drivers handle it, and once usage
grows and we know usage patterns better (and I make progress refactoring
both the dma-mapping subsystem itself and the RDMA dma map code to not
be a complete mess) we can move it to the core.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
