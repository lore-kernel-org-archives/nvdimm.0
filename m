Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 1 Mar 2018 16:20:38 -0700
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 10/10] nvmet: Optionally use PCI P2P memory
Message-ID: <20180301232038.GO19007@ziepe.ca>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-11-logang@deltatee.com>
 <749e3752-4349-0bdf-5243-3d510c2b26db@grimberg.me>
 <40d69074-31a8-d06a-ade9-90de7712c553@deltatee.com>
 <5649098f-b775-815b-8b9a-f34628873ff4@grimberg.me>
 <20180301184249.GI19007@ziepe.ca>
 <edaf476a-cfe9-0598-1aa5-14802a9a1477@deltatee.com>
 <20180301224540.GL19007@ziepe.ca>
 <77591162-4CCD-446E-A27C-1CDB4996ACB7@raithlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77591162-4CCD-446E-A27C-1CDB4996ACB7@raithlin.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Bates <sbates@raithlin.com>
Cc: Logan Gunthorpe <logang@deltatee.com>, Sagi Grimberg <sagi@grimberg.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Steve Wise <swise@opengridcomputing.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 01, 2018 at 11:00:51PM +0000, Stephen  Bates wrote:

> > Seems like a very subtle and hard to debug performance trap to leave
> > for the users, and pretty much the only reason to use P2P is
> > performance... So why have such a dangerous interface?
> 
> P2P is about offloading the memory and PCI subsystem of the host CPU
> and this is achieved no matter which p2p_dev is used.

No, locality matters. If you have a bunch of NICs and bunch of drives
and the allocator chooses to put all P2P memory on a single drive your
performance will suck horribly even if all the traffic is offloaded.

Performance will suck if you have speed differences between the PCI-E
devices. Eg a bunch of Gen 3 x8 NVMe cards paired with a Gen 4 x16 NIC
will not reach full performance unless the p2p buffers are properly
balanced between all cards.

This is why I think putting things in one big pool and pretending like
any P2P mem is interchangable with any other makes zero sense to me,
it is not how the system actually works. Proper locality matters a
lot.

Jason
