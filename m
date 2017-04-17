From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Mon, 17 Apr 2017 10:04:31 -0700
Message-ID: <CAPcyv4guU68waLZ1XBT9GPq1b1iZFDhTpsAven18jhr2JU6ScQ@mail.gmail.com>
References: <CAPcyv4it56J8Voo6kV0bBcO3nHsOHYLENpAtONJZTGceDDwNPg@mail.gmail.com>
 <6e732d6a-9baf-1768-3e9c-f6c887a836b2@deltatee.com>
 <1492381958.25766.50.camel@kernel.crashing.org>
 <6149ab5e-c981-6881-8c5a-22349561c3e8@deltatee.com>
 <1492413640.25766.52.camel@kernel.crashing.org>
 <ac643c73-43e9-1658-ffcb-d5628f80cbc1@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <ac643c73-43e9-1658-ffcb-d5628f80cbc1-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Mon, Apr 17, 2017 at 9:52 AM, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:
>
>
> On 17/04/17 01:20 AM, Benjamin Herrenschmidt wrote:
>> But is it ? For example take a GPU, does it, in your scheme, need an
>> additional "p2pmem" child ? Why can't the GPU driver just use some
>> helper to instantiate the necessary struct pages ? What does having an
>> actual "struct device" child buys you ?
>
> Yes, in this scheme, it needs an additional p2pmem child. Why is that an
> issue? It certainly makes it a lot easier for the user to understand the
> p2pmem memory in the system (through the sysfs tree) and reason about
> the topology and when to use it. This is important.

I think you want to go the other way in the hierarchy and find a
shared *parent* to land the p2pmem capability. Because that same agent
is going to be responsible handling address translation for the peers.

>>> 2) In order to create the struct pages we use the ZONE_DEVICE
>>> infrastructure which requires a struct device. (See
>>> devm_memremap_pages.)
>>
>> Yup, but you already have one in the actual pci_dev ... What is the
>> benefit of adding a second one ?
>
> But that would tie all of this very tightly to be pci only and may get
> hard to differentiate if more users of ZONE_DEVICE crop up who happen to
> be using a pci device. Having a specific class for this makes it very
> clear how this memory would be handled. For example, although I haven't
> looked into it, this could very well be a point of conflict with HMM. If
> they were to use the pci device to populate the dev_pagemap then we
> couldn't also use the pci device. I feel it's much better for users of
> dev_pagemap to have their struct devices they own to avoid such conflicts.

Peer-dma is always going to be a property of the bus and not the end
devices. Requiring each bus implementation to explicitly enable
peer-to-peer support is a feature not a bug.

>>>  This amazingly gets us the get_dev_pagemap
>>> architecture which also uses a struct device. So by using a p2pmem
>>> device we can go from struct page to struct device to p2pmem device
>>> quickly and effortlessly.
>>
>> Which isn't terribly useful in itself right ? What you care about is
>> the "enclosing" pci_dev no ? Or am I missing something ?
>
> Sure it is. What if we want to someday support p2pmem that's on another bus?

We shouldn't design for some future possible use case. Solve it for
pci and when / if another bus comes along then look at a more generic
abstraction.
