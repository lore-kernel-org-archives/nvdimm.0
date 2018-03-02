Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Fri, 2 Mar 2018 09:18:42 -0700
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 10/10] nvmet: Optionally use PCI P2P memory
Message-ID: <20180302161842.GB14861@ziepe.ca>
References: <20180228234006.21093-11-logang@deltatee.com>
 <749e3752-4349-0bdf-5243-3d510c2b26db@grimberg.me>
 <40d69074-31a8-d06a-ade9-90de7712c553@deltatee.com>
 <5649098f-b775-815b-8b9a-f34628873ff4@grimberg.me>
 <20180301184249.GI19007@ziepe.ca>
 <edaf476a-cfe9-0598-1aa5-14802a9a1477@deltatee.com>
 <20180301224540.GL19007@ziepe.ca>
 <77591162-4CCD-446E-A27C-1CDB4996ACB7@raithlin.com>
 <20180301234930.GG14799@localhost.localdomain>
 <CE2A5D93-E735-4414-8DC1-B308B74A1C5B@raithlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE2A5D93-E735-4414-8DC1-B308B74A1C5B@raithlin.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Bates <sbates@raithlin.com>
Cc: Keith Busch <keith.busch@intel.com>, Logan Gunthorpe <logang@deltatee.com>, Sagi Grimberg <sagi@grimberg.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Steve Wise <swise@opengridcomputing.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 01, 2018 at 11:57:43PM +0000, Stephen  Bates wrote:
> > We don't want to lump these all together without knowing which region you're allocating from, right?
> 
> In all seriousness I do agree with you on these Keith in the long
> term. We would consider adding property flags for the memory as it
> is added to the p2p core and then the allocator could evolve to
> intelligently dish it out. Attributes like endurance, latency and
> special write commit requirements could all become attributes in
> time. Perhaps one more reason for a central entity for p2p memory
> allocation so this code does not end up having to go into many
> different drivers?

I fear we will find that every kind of P2P memory has special
allocator requirements and dumping it all into one giant pool is not
going to be helpful.

This allocator is already seems not useful for the P2P target memory
on a Mellanox NIC due to the way it has a special allocation flow
(windowing) and special usage requirements..

Nor can it be usefull for the doorbell memory in the NIC.

Both of these are existing use cases for P2P with out of tree patches..

The allocator seems to only be able to solve the CMB problem, and I
think due to that it is better to put this allocator in the NVMe
driver and not the core code.. At least until we find a 2nd user that
needs the same allocation scheme...

Jason
