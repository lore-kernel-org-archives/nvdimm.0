From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Tue, 18 Apr 2017 00:14:16 -0600
Message-ID: <39af53d6-a1c1-83d4-e4d6-c1da3b8f95c7@deltatee.com>
References: <CAPcyv4it56J8Voo6kV0bBcO3nHsOHYLENpAtONJZTGceDDwNPg@mail.gmail.com>
 <6e732d6a-9baf-1768-3e9c-f6c887a836b2@deltatee.com>
 <1492381958.25766.50.camel@kernel.crashing.org>
 <6149ab5e-c981-6881-8c5a-22349561c3e8@deltatee.com>
 <1492413640.25766.52.camel@kernel.crashing.org>
 <ac643c73-43e9-1658-ffcb-d5628f80cbc1@deltatee.com>
 <20170417180421.GA6015@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170417180421.GA6015-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org



On 17/04/17 12:04 PM, Jerome Glisse wrote:
> I disagree here. I would rather see Peer-to-Peer mapping as a form
> of helper so that device driver can opt-in for multiple mecanisms
> concurrently. Like HMM and p2p.

I'm not against moving some of the common stuff into a library. It
sounds like the problems p2pmem solves don't overlap much with the
problems of the GPU and moving the stuff we have in common somewhere
else seems sensible.

> Also it seems you are having a static vision for p2p. For GPU and
> network the use case is you move some buffer into the device memory
> and then you create mapping for some network adapter while the buffer
> is in device memory. But this is only temporary and buffer might
> move to different device memory. So usecase is highly dynamic (well
> mapping lifetime is still probably few second/minutes).

I feel like you will need to pin the memory while it's the target of a
DMA transaction. If some network peer is sending you data and you just
invalidated the memory it is headed to then you are just going to break
applications. But really this isn't our concern: the memory we are using
with this work will be static and not prone to disappearing.

> I see no reason for exposing sysfs tree to userspace for all this.
> This isn't too dynamic, either 2 devices can access each others
> memory, either they can't. This can be hidden through the device
> kernel API. Again for GPU the idea is that it is always do-able
> in the sense that when it is not you fallback to using system
> memory.

The user has to make a decision to use it or not. This is an
optimization with significant trade-offs that may differ significantly
based on system design.

> Yes this could conflict and that's why i would rather see this as a set
> of helper like HMM is doing. So device driver can opt-in HMM and p2pmem
> at the same time.

I don't understand how that addresses the conflict. We need to each be
using unique and identifiable struct devices in the ZONE_DEVICE
dev_pagemap so we don't apply p2p dma mappings to hmm memory and vice-versa.

> This seems to duplicate things that already exist in each individual
> driver. If a device has memory than device driver already have some
> form of memory management and most likely expose some API to userspace
> to allow program to use that memory.

> Peer to peer DMA mapping is orthogonal to memory management, it is
> an optimization ie you have some buffer allocated through some device
> driver specific IOCTL and now you want some other device to directly
> access it. Having to first do another allocation in a different device
> driver for that to happen seems overkill.

The devices we are working with are adding memory specifically for
enabling p2p applications. The memory is new and there are no allocators
for any of it yet.

Also note: we've gotten _significant_ push back against exposing any of
this memory to userspace. Letting the user unknowingly have to deal with
the issues of iomem is not anything anyone wants to see. Thus we are
dealing with in-kernel users only and they need a common interface to
get the memory from.

> What you really want from device driver point of view is an helper to
> first tell you if 2 device can access each other and second an helper
> that allow the second device to import the other device memory to allow
> direct access.

Well, actually it's a bit more complicated than that but essentially
correct: There can be N devices in the mix and quite likely another
driver completely separate from all N devices. (eg. for our main use
case we have N nvme cards being talked to through an RDMA NIC with it
all being coordinated by the nvme-target driver).


> Discovering possible peer is a onetime only thing and designing around
> that is wrong in my view. There is already existing hierarchy in kernel
> for that in the form of the bus hierarchy (i am thinking pci bus here).
> So there is already existing way to discover this and you are just
> duplicating informations here.

I really don't see the solution you are proposing here. Have the user
specify a pci device name and just have them guess which ones have
suitable memory? Or do they have to walk the entire pci tree to find
ones that have such memory? There was no "duplicate" information created
by our patch set.

Logan
