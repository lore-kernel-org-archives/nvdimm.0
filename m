From: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Mon, 17 Apr 2017 17:20:40 +1000
Message-ID: <1492413640.25766.52.camel@kernel.crashing.org>
References: <CAPcyv4it56J8Voo6kV0bBcO3nHsOHYLENpAtONJZTGceDDwNPg@mail.gmail.com>
 <6e732d6a-9baf-1768-3e9c-f6c887a836b2@deltatee.com>
 <1492381958.25766.50.camel@kernel.crashing.org>
 <6149ab5e-c981-6881-8c5a-22349561c3e8@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <6149ab5e-c981-6881-8c5a-22349561c3e8-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Sun, 2017-04-16 at 23:13 -0600, Logan Gunthorpe wrote:
> 
> > 
> > I'm still not 100% why do you need a "p2mem device" mind you ...
> 
> Well, you don't "need" it but it is a design choice that I think makes a
> lot of sense for the following reasons:
> 
> 1) p2pmem is in fact a device on the pci bus. A pci driver will need to
> set it up and create the device and thus it will have a natural parent
> pci device. Instantiating a struct device for it means it will appear in
> the device hierarchy and one can use that to reason about its position
> in the topology.

But is it ? For example take a GPU, does it, in your scheme, need an
additional "p2pmem" child ? Why can't the GPU driver just use some
helper to instantiate the necessary struct pages ? What does having an
actual "struct device" child buys you ?

> 2) In order to create the struct pages we use the ZONE_DEVICE
> infrastructure which requires a struct device. (See
> devm_memremap_pages.)

Yup, but you already have one in the actual pci_dev ... What is the
benefit of adding a second one ?

>  This amazingly gets us the get_dev_pagemap
> architecture which also uses a struct device. So by using a p2pmem
> device we can go from struct page to struct device to p2pmem device
> quickly and effortlessly.

Which isn't terribly useful in itself right ? What you care about is
the "enclosing" pci_dev no ? Or am I missing something ?

> 3) You wouldn't want to use the pci's struct device because it doesn't
> really describe what's going on. For example, there may be multiple
> devices on the pci device in question: eg. an NVME card and some p2pmem.

What is "some p2pmem" ?

> Or it could be a NIC with some p2pmem.

Again what is "some p2pmem" ?

That a device might have some memory-like buffer space is all well and
good but does it need to be specifically distinguished at the device
level ? It could be inherent to what the device is... for example again
take the GPU example, why would you call the FB memory "p2pmem" ? 

>  Or it could just be p2pmem by itself. And the logic to figure out what
>  memory is available and where
> the address is will be non-standard so it's really straightforward to
> have any pci driver just instantiate a p2pmem device.

Again I'm not sure why it needs to "instanciate a p2pmem" device. Maybe
it's the term "p2pmem" that offputs me. If p2pmem allowed to have a
standard way to lookup the various offsets etc... I mentioned earlier,
then yes, it would make sense to have it as a staging point. As-is, I
don't know. 

> It is probably worth you reading the RFC patches at this point to get a
> better feel for this.

Yup, I'll have another look a bit more in depth.

Cheers,
Ben.


> Logan
