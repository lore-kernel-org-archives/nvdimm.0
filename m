Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 9 Jan 2018 10:10:08 -0700
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 06/12] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
Message-ID: <20180109171008.GB4518@ziepe.ca>
References: <20180104221337.GV11348@ziepe.ca>
 <3e8391a9-8924-be6d-8c43-162a360d75b6@deltatee.com>
 <20180105045031.GX11348@ziepe.ca>
 <20180108145901.GA10743@lst.de>
 <20180108180917.GF11348@ziepe.ca>
 <20180108183434.GA15549@lst.de>
 <cffacbee-477a-fbe9-19cc-373cd2ec6fef@deltatee.com>
 <20180108185743.GA15936@lst.de>
 <20180108194950.GK11348@ziepe.ca>
 <20180109164640.GA12159@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180109164640.GA12159@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Logan Gunthorpe <logang@deltatee.com>, open list <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma <linux-rdma@vger.kernel.org>, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 09, 2018 at 05:46:40PM +0100, Christoph Hellwig wrote:
> On Mon, Jan 08, 2018 at 12:49:50PM -0700, Jason Gunthorpe wrote:
> > Pretty sure P2P capable IOMMU hardware exists.
> > 
> > With SOC's we also have the scenario that an DMA originated from an
> > on-die device wishes to target an off-die PCI BAR (through the IOMMU),
> > that definitely exists today, and people care about it :)
> 
> Then people will have to help and contribute support for it.

Sure. But my point was all this will have to migrate under the dma_ops
for that to work, so why the resistance to using dma_ops right away?

Jason
