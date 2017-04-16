From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Sun, 16 Apr 2017 08:53:45 -0700
Message-ID: <CAPcyv4iqnz1B00Q3xG-nGrLXdOyB7ditxmwZyotksLFgUqr+jA@mail.gmail.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1491974532.7236.43.camel@kernel.crashing.org> <5ac22496-56ec-025d-f153-140001d2a7f9@deltatee.com>
 <1492034124.7236.77.camel@kernel.crashing.org> <81888a1e-eb0d-cbbc-dc66-0a09c32e4ea2@deltatee.com>
 <20170413232631.GB24910@bhelgaas-glaptop.roam.corp.google.com>
 <20170414041656.GA30694@obsidianresearch.com> <1492169849.25766.3.camel@kernel.crashing.org>
 <630c1c63-ff17-1116-e069-2b8f93e50fa2@deltatee.com> <20170414190452.GA15679@bhelgaas-glaptop.roam.corp.google.com>
 <1492207643.25766.18.camel@kernel.crashing.org> <bff1e503-95a9-e19f-bfd9-0ff962c63a81@deltatee.com>
 <CAPcyv4jUeKzKDARp6Z35kdPLKnP-M6aF8X5KpOx55CLyjnj4dA@mail.gmail.com> <1492311719.25766.37.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1492311719.25766.37.camel@kernel.crashing.org>
Sender: linux-scsi-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Logan Gunthorpe <logang@deltatee.com>, Bjorn Helgaas <helgaas@kernel.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Keith Busch <keith.busch@intel.com>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jerome Glisse <jglisse@redhat.com>
List-Id: linux-nvdimm@lists.01.org

On Sat, Apr 15, 2017 at 8:01 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Sat, 2017-04-15 at 15:09 -0700, Dan Williams wrote:
>> I'm wondering, since this is limited to support behind a single
>> switch, if you could have a software-iommu hanging off that switch
>> device object that knows how to catch and translate the non-zero
>> offset bus address case. We have something like this with VMD driver,
>> and I toyed with a soft pci bridge when trying to support AHCI+NVME
>> bar remapping. When the dma api looks up the iommu for its device it
>> hits this soft-iommu and that driver checks if the page is host memory
>> or device memory to do the dma translation. You wouldn't need a bit in
>> struct page, just a lookup to the hosting struct dev_pagemap in the
>> is_zone_device_page() case and that can point you to p2p details.
>
> I was thinking about a hook in the arch DMA ops but that kind of
> wrapper might work instead indeed. However I'm not sure what's the best
> way to "instantiate" it.
>
> The main issue is that the DMA ops are a function of the initiator,
> not the target (since the target is supposed to be memory) so things
> are a bit awkward.
>
> One (user ?) would have to know that a given device "intends" to DMA
> directly to another device.
>
> This is awkward because in the ideal scenario, this isn't something the
> device knows. For example, one could want to have an existing NIC DMA
> directly to/from NVME pages or GPU pages.
>
> The NIC itself doesn't know the characteristic of these pages, but
> *something* needs to insert itself in the DMA ops of that bridge to
> make it possible.
>
> That's why I wonder if it's the struct page of the target that should
> be "marked" in such a way that the arch dma'ops can immediately catch
> that they belong to a device and might require "wrapped" operations.
>
> Are ZONE_DEVICE pages identifiable based on the struct page alone ? (a
> flag ?)

Yes, is_zone_device_page(). However I think we're getting to the point
with pmem, hmm, cdm, and now p2p where ZONE_DEVICE is losing specific
meaning and we need to have explicit type checks like is_hmm_page()
is_p2p_page() that internally check is_zone_device_page() plus some
other specific type.

> That would allow us to keep a fast path for normal memory targets, but
> also have some kind of way to handle the special cases of such peer 2
> peer (or also handle other type of peer to peer that don't necessarily
> involve PCI address wrangling but could require additional iommu bits).
>
> Just thinking out loud ... I don't have a firm idea or a design. But
> peer to peer is definitely a problem we need to tackle generically, the
> demand for it keeps coming up.

ZONE_DEVICE allows you to redirect via get_dev_pagemap() to retrieve
context about the physical address in question. I'm thinking you can
hang bus address translation data off of that structure. This seems
vaguely similar to what HMM is doing.
