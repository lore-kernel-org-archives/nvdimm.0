Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 1 Mar 2018 15:45:40 -0700
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 10/10] nvmet: Optionally use PCI P2P memory
Message-ID: <20180301224540.GL19007@ziepe.ca>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-11-logang@deltatee.com>
 <749e3752-4349-0bdf-5243-3d510c2b26db@grimberg.me>
 <40d69074-31a8-d06a-ade9-90de7712c553@deltatee.com>
 <5649098f-b775-815b-8b9a-f34628873ff4@grimberg.me>
 <20180301184249.GI19007@ziepe.ca>
 <edaf476a-cfe9-0598-1aa5-14802a9a1477@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edaf476a-cfe9-0598-1aa5-14802a9a1477@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Steve Wise <swise@opengridcomputing.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 01, 2018 at 12:27:03PM -0700, Logan Gunthorpe wrote:
> 
> 
> On 01/03/18 11:42 AM, Jason Gunthorpe wrote:
> >On Thu, Mar 01, 2018 at 08:35:55PM +0200, Sagi Grimberg wrote:
> >This is also why I don't entirely understand why this series has a
> >generic allocator for p2p mem, it makes little sense to me.
> 
> >Why wouldn't the nmve driver just claim the entire CMB of its local
> >device for its own use? Why involve p2p core code in this?
> 
> We'd prefer to have a generic way to get p2pmem instead of restricting
> ourselves to only using CMBs. We did work in the past where the P2P memory
> was part of an IB adapter and not the NVMe card. So this won't work if it's
> an NVMe only interface.

It just seems like it it making it too complicated.

In 99% of cases locality is important and you don't want to accidently
use a buffer in a 3rd device that has no relation to the two doing the
transfer just because it happened to be returned by the generic
allocator.

I can appreciate you might have some special use case for that, but it
absolutely should require special configuration and not just magically
happen.

You bring up IB adaptor memory - if we put that into the allocator
then what is to stop the NMVe driver just using it instead of the CMB
buffer? That would be totally wrong in almost all cases.

Seems like a very subtle and hard to debug performance trap to leave
for the users, and pretty much the only reason to use P2P is
performance... So why have such a dangerous interface?

Jason
