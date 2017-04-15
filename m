From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Sat, 15 Apr 2017 15:09:08 -0700
Message-ID: <CAPcyv4jUeKzKDARp6Z35kdPLKnP-M6aF8X5KpOx55CLyjnj4dA@mail.gmail.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1491974532.7236.43.camel@kernel.crashing.org> <5ac22496-56ec-025d-f153-140001d2a7f9@deltatee.com>
 <1492034124.7236.77.camel@kernel.crashing.org> <81888a1e-eb0d-cbbc-dc66-0a09c32e4ea2@deltatee.com>
 <20170413232631.GB24910@bhelgaas-glaptop.roam.corp.google.com>
 <20170414041656.GA30694@obsidianresearch.com> <1492169849.25766.3.camel@kernel.crashing.org>
 <630c1c63-ff17-1116-e069-2b8f93e50fa2@deltatee.com> <20170414190452.GA15679@bhelgaas-glaptop.roam.corp.google.com>
 <1492207643.25766.18.camel@kernel.crashing.org> <bff1e503-95a9-e19f-bfd9-0ff962c63a81@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <bff1e503-95a9-e19f-bfd9-0ff962c63a81@deltatee.com>
Sender: linux-pci-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <helgaas@kernel.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Keith Busch <keith.busch@intel.com>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jerome Glisse <jglisse@redhat.com>
List-Id: linux-nvdimm@lists.01.org

On Sat, Apr 15, 2017 at 10:41 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
> Thanks, Benjamin, for the summary of some of the issues.
>
> On 14/04/17 04:07 PM, Benjamin Herrenschmidt wrote
>> So I assume the p2p code provides a way to address that too via special
>> dma_ops ? Or wrappers ?
>
> Not at this time. We will probably need a way to ensure the iommus do
> not attempt to remap these addresses. Though if it does, I'd expect
> everything would still work you just wouldn't get the performance or
> traffic flow you are looking for. We've been testing with the software
> iommu which doesn't have this problem.
>
>> The problem is that the latter while seemingly easier, is also slower
>> and not supported by all platforms and architectures (for example,
>> POWER currently won't allow it, or rather only allows a store-only
>> subset of it under special circumstances).
>
> Yes, I think situations where we have to cross host bridges will remain
> unsupported by this work for a long time. There are two many cases where
> it just doesn't work or it performs too poorly to be useful.
>
>> I don't fully understand how p2pmem "solves" that by creating struct
>> pages. The offset problem is one issue. But there's the iommu issue as
>> well, the driver cannot just use the normal dma_map ops.
>
> We are not using a proper iommu and we are dealing with systems that
> have zero offset. This case is also easily supported. I expect fixing
> the iommus to not map these addresses would also be reasonably achievable.

I'm wondering, since this is limited to support behind a single
switch, if you could have a software-iommu hanging off that switch
device object that knows how to catch and translate the non-zero
offset bus address case. We have something like this with VMD driver,
and I toyed with a soft pci bridge when trying to support AHCI+NVME
bar remapping. When the dma api looks up the iommu for its device it
hits this soft-iommu and that driver checks if the page is host memory
or device memory to do the dma translation. You wouldn't need a bit in
struct page, just a lookup to the hosting struct dev_pagemap in the
is_zone_device_page() case and that can point you to p2p details.
