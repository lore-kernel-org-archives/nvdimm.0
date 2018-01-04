Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 4 Jan 2018 15:13:37 -0700
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 06/12] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
Message-ID: <20180104221337.GV11348@ziepe.ca>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-7-logang@deltatee.com>
 <20180104192225.GS11348@ziepe.ca>
 <1f8fb3fb-e3dc-94d3-e837-0cd942cf5b87@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f8fb3fb-e3dc-94d3-e837-0cd942cf5b87@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 04, 2018 at 12:52:24PM -0700, Logan Gunthorpe wrote:
> >I'd be much happier if dma_map_sg can tell the memory is P2P or not
> >from the scatterlist or dir arguments and not require the callers to
> >have this.
> 
> We tried things like this in an earlier iteration[1] which assumed the SG
> was homogenous (all P2P or all regular memory). This required serious
> ugliness to try and ensure SGs were in fact homogenous[2].

I'm confused, these patches already assume the sg is homogenous,
right? Sure looks that way. So [2] is just debugging??

What I meant is to rely on the fact it is already homogenous and
create a function like this:

static inline bool sg_is_table_p2p(struct scatterlist *sg)
{
    return is_pci_p2p_page(sg_page(sg));
}

And then insert

  if (sg_is_table_p2p(sg))
       return pci_p2pmem_map_sg(...);

At the top of dma_map_sg_attrs() (and similar for unmap)

Then we don't need to patch RDMA because RDMA is not special when it
comes to P2P. P2P should work with everything.

This has been my objection to every P2P iteration so far, for
years. RDMA is not special, P2P should not be patching RDMA's DMA
path. This an issue between the DMA and PCI subsystems, not for RDMA.

> >The signature of pci_p2pmem_map_sg also doesn't look very good, it
> >should mirror the usual dma_map_sg, otherwise it needs more revision
> >to extend this to do P2P through a root complex.
> 
> Generally, the feedback that I get is to not make changes that try to
> anticipate the future. It would be easy enough to add those arguments when
> the code for going through the RC is made (which I expect will be very
> involved anyway).

Yes, but DMA mapping fundamentally requires the arguments to
dma_map_sg, so it is hard to accept an API called dma_map without
them.. Maybe just a naming issue.

[2] https://github.com/sbates130272/linux-p2pmem/commit/61ec04fa63c79dab14570ea0e97432d9325ad127
