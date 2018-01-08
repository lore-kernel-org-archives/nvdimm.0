Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 8 Jan 2018 11:29:45 -0700
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 06/12] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
Message-ID: <20180108182945.GG11348@ziepe.ca>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-7-logang@deltatee.com>
 <20180104192225.GS11348@ziepe.ca>
 <1f8fb3fb-e3dc-94d3-e837-0cd942cf5b87@deltatee.com>
 <20180104221337.GV11348@ziepe.ca>
 <3e8391a9-8924-be6d-8c43-162a360d75b6@deltatee.com>
 <20180105045031.GX11348@ziepe.ca>
 <20180108145901.GA10743@lst.de>
 <20180108180917.GF11348@ziepe.ca>
 <3daea7fe-f64a-36a9-ca80-0cb4d9acf171@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3daea7fe-f64a-36a9-ca80-0cb4d9acf171@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 08, 2018 at 11:17:38AM -0700, Logan Gunthorpe wrote:
 
> >>If at all it should be in the dma_map* wrappers, but for that we'd need
> >>a good identifier.  And it still would not solve the whole fake dma
> >>ops issue.
> >
> >Very long term the IOMMUs under the ops will need to care about this,
> >so the wrapper is not an optimal place to put it - but I wouldn't
> >object if it gets it out of RDMA :)
> 
> Well, creating the extra op doesn't really change anything to the RDMA patch
> in this series.

Not fundamentally, but it lets us solve the bugs the patch introduces
with hfi/etc

> The point is, for the time being, we need to track whether we are
> doing a P2P or normal mapping using a side channel as we don't have
> a good way of tracking it in the SGL at this time.

Well, that is disappointing for now, but I'm OK with the flag in the
RW interface - as long as we all sort of agree it is not desirable and
the SG should self-identify in an ideal someday future world..

Jason
