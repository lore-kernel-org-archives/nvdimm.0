Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 4 Jan 2018 21:50:31 -0700
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 06/12] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
Message-ID: <20180105045031.GX11348@ziepe.ca>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-7-logang@deltatee.com>
 <20180104192225.GS11348@ziepe.ca>
 <1f8fb3fb-e3dc-94d3-e837-0cd942cf5b87@deltatee.com>
 <20180104221337.GV11348@ziepe.ca>
 <3e8391a9-8924-be6d-8c43-162a360d75b6@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e8391a9-8924-be6d-8c43-162a360d75b6@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 04, 2018 at 04:44:00PM -0700, Logan Gunthorpe wrote:
> On 04/01/18 03:13 PM, Jason Gunthorpe wrote:
> >On Thu, Jan 04, 2018 at 12:52:24PM -0700, Logan Gunthorpe wrote:
> >>We tried things like this in an earlier iteration[1] which assumed the SG
> >>was homogenous (all P2P or all regular memory). This required serious
> >>ugliness to try and ensure SGs were in fact homogenous[2].
> >
> >I'm confused, these patches already assume the sg is homogenous,
> >right? Sure looks that way. So [2] is just debugging??
> 
> Yes, but it's a bit different to expect that someone calling
> pci_p2pmem_map_sg() will know what they're doing and provide a homogenous
> SG. It is relatively clear by convention that the entire SG must be
> homogenous given they're calling a pci_p2pmem function. Where as, allowing
> P2P SGs into the core DMA code means all we can do is hope that future
> developers don't screw it up and allow P2P pages to mix in with regular
> pages.

Well that argument applies equally to the RDMA RW API wrappers around
the DMA API. I think it is fine if sgl are defined to only have P2P or
not, and that debugging support seemed reasonable to me..

> It's also very difficult to add similar functionality to dma_map_page seeing
> dma_unmap_page won't have any way to know what it's dealing with. It just
> seems confusing to support P2P in the SG version and not the page version.

Well, this proposal is to support P2P in only some RDMA APIs and not
others, so it seems about as confusing to me..

> >Then we don't need to patch RDMA because RDMA is not special when it
> >comes to P2P. P2P should work with everything.
> 
> Yes, I agree this would be very nice.

Well, it is more than very nice. We have to keep RDMA working after
all, and if you make it even more special things become harder for us.

It is already the case that DMA in RDMA is very strange. We have
drivers that provide their own DMA ops, for instance.

And on that topic, does this scheme work with HFI?

On first glance, it looks like no. The PCI device the HFI device is
attached to may be able to do P2P, so it should be able to trigger the
support.

However, substituting the p2p_dma_map for the real device op dma_map
will cause a kernel crash when working with HFI. HFI uses a custom DMA
ops that returns CPU addreses in the dma_addr_t which the driver
handles in various special ways. One cannot just replace them with PCI
bus addresses.

So, this kinda looks to me like it causes bad breakage for some RDMA
drivers??

This is why P2P must fit in to the common DMA framework somehow, we
rely on these abstractions to work properly and fully in RDMA.

I think you should consider pushing this directly into the dma_ops
implementations. Add a p2p_supported flag to struct dma_map_ops, and
only if it is true can a caller pass a homogeneous SGL to ops->map_sg.
Only map_sg would be supported for P2P. Upgraded implementations can
call the helper function.

Jason
