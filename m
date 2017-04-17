From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Mon, 17 Apr 2017 10:52:29 -0600
Message-ID: <ac643c73-43e9-1658-ffcb-d5628f80cbc1@deltatee.com>
References: <CAPcyv4it56J8Voo6kV0bBcO3nHsOHYLENpAtONJZTGceDDwNPg@mail.gmail.com>
 <6e732d6a-9baf-1768-3e9c-f6c887a836b2@deltatee.com>
 <1492381958.25766.50.camel@kernel.crashing.org>
 <6149ab5e-c981-6881-8c5a-22349561c3e8@deltatee.com>
 <1492413640.25766.52.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1492413640.25766.52.camel-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org



On 17/04/17 01:20 AM, Benjamin Herrenschmidt wrote:
> But is it ? For example take a GPU, does it, in your scheme, need an
> additional "p2pmem" child ? Why can't the GPU driver just use some
> helper to instantiate the necessary struct pages ? What does having an
> actual "struct device" child buys you ?

Yes, in this scheme, it needs an additional p2pmem child. Why is that an
issue? It certainly makes it a lot easier for the user to understand the
p2pmem memory in the system (through the sysfs tree) and reason about
the topology and when to use it. This is important.

> 
>> 2) In order to create the struct pages we use the ZONE_DEVICE
>> infrastructure which requires a struct device. (See
>> devm_memremap_pages.)
> 
> Yup, but you already have one in the actual pci_dev ... What is the
> benefit of adding a second one ?

But that would tie all of this very tightly to be pci only and may get
hard to differentiate if more users of ZONE_DEVICE crop up who happen to
be using a pci device. Having a specific class for this makes it very
clear how this memory would be handled. For example, although I haven't
looked into it, this could very well be a point of conflict with HMM. If
they were to use the pci device to populate the dev_pagemap then we
couldn't also use the pci device. I feel it's much better for users of
dev_pagemap to have their struct devices they own to avoid such conflicts.

> 
>>  This amazingly gets us the get_dev_pagemap
>> architecture which also uses a struct device. So by using a p2pmem
>> device we can go from struct page to struct device to p2pmem device
>> quickly and effortlessly.
> 
> Which isn't terribly useful in itself right ? What you care about is
> the "enclosing" pci_dev no ? Or am I missing something ?

Sure it is. What if we want to someday support p2pmem that's on another bus?

>> 3) You wouldn't want to use the pci's struct device because it doesn't
>> really describe what's going on. For example, there may be multiple
>> devices on the pci device in question: eg. an NVME card and some p2pmem.
> 
> What is "some p2pmem" ?
>> Or it could be a NIC with some p2pmem.
> 
> Again what is "some p2pmem" ?

Some device local memory intended for use as a DMA target from a
neighbour device or itself. On a PCI device, this would be a BAR, or a
portion of a BAR with memory behind it.

Keep in mind device classes tend to carve out common use cases and don't
have a one to one mapping with a physical pci card.

> That a device might have some memory-like buffer space is all well and
> good but does it need to be specifically distinguished at the device
> level ? It could be inherent to what the device is... for example again
> take the GPU example, why would you call the FB memory "p2pmem" ? 

Well if you are using it for p2p transactions why wouldn't you call it
p2pmem? There's no technical downside here except some vague argument
over naming. Once registered as p2pmem, that device will handle all the
dma map stuff for you and have a central obvious place to put code which
helps decide whether to use it or not based on topology.

I can certainly see an issue you'd have with the current RFC in that the
p2pmem device currently also handles memory allocation which a GPU would
 want to do itself. There are plenty of solutions to this though: we
could provide hooks for the parent device to override allocation or
something like that. However, the use cases I'm concerned with don't do
their own allocation so that is an important feature for them.

> Again I'm not sure why it needs to "instanciate a p2pmem" device. Maybe
> it's the term "p2pmem" that offputs me. If p2pmem allowed to have a
> standard way to lookup the various offsets etc... I mentioned earlier,
> then yes, it would make sense to have it as a staging point. As-is, I
> don't know. 

Well of course, at some point it would have a standard way to lookup
offsets and figure out what's necessary for a mapping. We wouldn't make
that separate from this, that would make no sense.

I also forgot:

4) We need someway in the kernel to configure drivers that use p2pmem.
That means it needs a unique name that the user can understand, lookup
and pass to other drivers. Then a way for those drivers to find it in
the system. A specific device class gets that for us in a very simple
fashion. We also don't want to have drivers like nvmet having to walk
every pci device to figure out where the p2p memory is and whether it
can use it.

IMO there are many clear benefits here and you haven't really offered an
alternative that provides the same features and potential for future use
cases.

Logan
