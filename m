From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Tue, 18 Apr 2017 12:30:59 -0600
Message-ID: <cce00131-1f28-27b3-40ab-04f8783f1e5a@deltatee.com>
References: <CAPcyv4it56J8Voo6kV0bBcO3nHsOHYLENpAtONJZTGceDDwNPg@mail.gmail.com>
 <1492381396.25766.43.camel@kernel.crashing.org>
 <20170418164557.GA7181@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170418164557.GA7181-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org



On 18/04/17 10:45 AM, Jason Gunthorpe wrote:
> From Ben's comments, I would think that the 'first class' support that
> is needed here is simply a function to return the 'struct device'
> backing a CPU address range.

Yes, and Dan's get_dev_pagemap suggestion gets us 90% of the way there.
It's just a disagreement as to what struct device is inside the pagemap.
Care needs to be taken to ensure that struct device doesn't conflict
with hmm and doesn't limit other potential future users of ZONE_DEVICE.

> If there is going to be more core support for this stuff I think it
> will be under the topic of more robustly describing the fabric to the
> core and core helpers to extract data from the description: eg compute
> the path, check if the path crosses translation, etc

Agreed, those helpers would be useful to everyone.

> I think the key agreement to get out of Logan's series is that P2P DMA
> means:
>  - The BAR will be backed by struct pages
>  - Passing the CPU __iomem address of the BAR to the DMA API is
>    valid and, long term, dma ops providers are expected to fail
>    or return the right DMA address

Well, yes but we have a _lot_ of work to do to make it safe to pass
around struct pages backed with __iomem. That's where our next focus
will be. I've already taken very initial steps toward this with my
scatterlist map patchset.

>  - Mapping BAR memory into userspace and back to the kernel via
>    get_user_pages works transparently, and with the DMA API above

Again, we've had a lot of push back for the memory to go to userspace at
all. It does work, but people expect userspace to screw it up in a lot
of ways. Among the people pushing back on that: Christoph Hellwig has
specifically said he wants to see this stay with in-kernel users only
until the apis can be worked out. This is one of the reasons we decided
to go with enabling nvme-fabrics as everything remains in the kernel.
And with that decision we needed a common in-kernel allocation
infrastructure: this is what p2pmem really is at this point.

>  - The dma ops provider must be able to tell if source memory is bar
>    mapped and recover the pci device backing the mapping.

Do you mean to say that every dma-ops provider needs to be taught about
p2p backed pages? I was hoping we could have dma_map_* just use special
p2p dma-ops if it was passed p2p pages (though there are some
complications to this too).

> At least this is what we'd like in RDMA :)
> 
> FWIW, RDMA probably wouldn't want to use a p2mem device either, we
> already have APIs that map BAR memory to user space, and would like to
> keep using them. A 'enable P2P for bar' helper function sounds better
> to me.

Well, in the end that will likely come down to just devm_memremap_pages
with some (presently undecided) struct device that can be used to get
special p2p dma-ops for the bus.

Logan
