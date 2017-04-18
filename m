From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Tue, 18 Apr 2017 15:52:08 -0700
Message-ID: <CAPcyv4itqGu+YekHcJ+_kyDSDch43yRSqK8NnGUh2DYYMd=F1Q@mail.gmail.com>
References: <CAPcyv4it56J8Voo6kV0bBcO3nHsOHYLENpAtONJZTGceDDwNPg@mail.gmail.com>
 <1492381396.25766.43.camel@kernel.crashing.org> <20170418164557.GA7181@obsidianresearch.com>
 <CAPcyv4izLa2vw12ysvVfd=ysaMKcASNFm+=CaqDKhnPY9B5OJg@mail.gmail.com> <1492555569.25766.99.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1492555569.25766.99.camel@kernel.crashing.org>
Sender: linux-scsi-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Logan Gunthorpe <logang@deltatee.com>, Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Keith Busch <keith.busch@intel.com>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jerome Glisse <jglisse@redhat.com>
List-Id: linux-nvdimm@lists.01.org

On Tue, Apr 18, 2017 at 3:46 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Tue, 2017-04-18 at 10:27 -0700, Dan Williams wrote:
>> > FWIW, RDMA probably wouldn't want to use a p2mem device either, we
>> > already have APIs that map BAR memory to user space, and would like to
>> > keep using them. A 'enable P2P for bar' helper function sounds better
>> > to me.
>>
>> ...and I think it's not a helper function as much as asking the bus
>> provider "can these two device dma to each other". The "helper" is the
>> dma api redirecting through a software-iommu that handles bus address
>> translation differently than it would handle host memory dma mapping.
>
> Do we even need tat function ? The dma_ops have a dma_supported()
> call...
>
> If we have those override ops built into the "dma_target" object,
> then these things can make that decision knowing both the source
> and target device.
>

Yes.
