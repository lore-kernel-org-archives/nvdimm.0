From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [RFC 6/8] nvmet: Be careful about using iomem accesses when
 dealing with p2pmem
Date: Thu, 6 Apr 2017 10:35:21 -0600
Message-ID: <20170406163520.GA7657@obsidianresearch.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-7-git-send-email-logang@deltatee.com>
 <080b68b4-eba3-861c-4f29-5d829425b5e7@grimberg.me>
 <20170404154629.GA13552@obsidianresearch.com>
 <4df229d8-8124-664a-9bc4-6401bc034be1@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4df229d8-8124-664a-9bc4-6401bc034be1@grimberg.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Logan Gunthorpe <logang@deltatee.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@ml01.01.org, linux-kernel@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

On Thu, Apr 06, 2017 at 08:33:38AM +0300, Sagi Grimberg wrote:
> 
> >>Note that the nvme completion queues are still on the host memory, so
> >>this means we have lost the ordering between data and completions as
> >>they go to different pcie targets.
> >
> >Hmm, in this simple up/down case with a switch, I think it might
> >actually be OK.
> >
> >Transactions might not complete at the NVMe device before the CPU
> >processes the RDMA completion, however due to the PCI-E ordering rules
> >new TLPs directed to the NVMe will complete after the RMDA TLPs and
> >thus observe the new data. (eg order preserving)
> >
> >It would be very hard to use P2P if fabric ordering is not preserved..
> 
> I think it still can race if the p2p device is connected with more than
> a single port to the switch.
> 
> Say it's connected via 2 legs, the bar is accessed from leg A and the
> data from the disk comes via leg B. In this case, the data is heading
> towards the p2p device via leg B (might be congested), the completion
> goes directly to the RC, and then the host issues a read from the
> bar via leg A. I don't understand what can guarantee ordering here.

Right, this is why I qualified my statement with 'simple up/down case'

Make it any more complex and it clearly stops working sanely, but I
wouldn't worry about unusual PCI-E fabrics at this point..

> Stephen told me that this still guarantees ordering, but I honestly
> can't understand how, perhaps someone can explain to me in a simple
> way that I can understand.

AFAIK PCI-E ordering is explicitly per link, so things that need order
must always traverse the same link.

Jason
