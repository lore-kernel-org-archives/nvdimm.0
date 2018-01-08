Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 8 Jan 2018 12:01:16 -0700
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 06/12] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
Message-ID: <20180108190116.GI11348@ziepe.ca>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-7-logang@deltatee.com>
 <20180104192225.GS11348@ziepe.ca>
 <1f8fb3fb-e3dc-94d3-e837-0cd942cf5b87@deltatee.com>
 <20180104221337.GV11348@ziepe.ca>
 <3e8391a9-8924-be6d-8c43-162a360d75b6@deltatee.com>
 <20180105045031.GX11348@ziepe.ca>
 <20180108145901.GA10743@lst.de>
 <20180108180917.GF11348@ziepe.ca>
 <20180108183434.GA15549@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180108183434.GA15549@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 08, 2018 at 07:34:34PM +0100, Christoph Hellwig wrote:
> > > > And on that topic, does this scheme work with HFI?
> > > 
> > > No, and I guess we need an opt-out.  HFI generally seems to be
> > > extremely weird.
> > 
> > This series needs some kind of fix so HFI, QIB, rxe, etc don't get
> > broken, and it shouldn't be 'fixed' at the RDMA level.
> 
> I don't think rxe is a problem as it won't show up a pci device.

Right today's restrictions save us..

> HFI and QIB do show as PCI devices, and could be used for P2P transfers
> from the PCI point of view.  It's just that they have a layer of
> software indirection between their hardware and what is exposed at
> the RDMA layer.
> 
> So I very much disagree about where to place that workaround - the
> RDMA code is exactly the right place.

But why? RDMA is using core code to do this. It uses dma_ops in struct
device and it uses normal dma_map SG. How is it RDMA's problem that
some PCI drivers provide strange DMA ops?

Admittedly they are RDMA drivers, but it is a core mechanism they
(ab)use these days..

> > It could, if we had a DMA op for p2p then the drivers that provide
> > their own ops can implement it appropriately or not at all.
> > 
> > Eg the correct implementation for rxe to support p2p memory is
> > probably somewhat straightfoward.
> 
> But P2P is _not_ a factor of the dma_ops implementation at all,
> it is something that happens behind the dma_map implementation.

Only as long as the !ACS and switch limitations are present.

Those limitations are fine to get things started, but there is going
to a be a push improve the system to remove them.

> > Very long term the IOMMUs under the ops will need to care about this,
> > so the wrapper is not an optimal place to put it - but I wouldn't
> > object if it gets it out of RDMA :)
> 
> Unless you have an IOMMU on your PCIe switch and not before/inside
> the root complex that is not correct.

I understand the proposed patches restrict things to require a switch
and not transit the IOMMU.

But *very long term* P2P will need to work with paths that transit the
system IOMMU and root complex.

This already exists as out-of-tree funtionality that has been deployed
in production for years and years that does P2P through the root
complex with the IOMMU turned off.

Jason
