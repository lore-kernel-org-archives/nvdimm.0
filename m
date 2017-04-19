From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Wed, 19 Apr 2017 10:41:42 -0700
Message-ID: <CAPcyv4gxBgVsbSez7_dZYkZojUWU0X0txs7FxiJ+Z3xsMt6TqQ@mail.gmail.com>
References: <20170418164557.GA7181@obsidianresearch.com>
 <cce00131-1f28-27b3-40ab-04f8783f1e5a@deltatee.com>
 <20170418190138.GH7181@obsidianresearch.com>
 <df1351d8-b86c-2e21-1948-4688ece5dc2b@deltatee.com>
 <CAPcyv4gScx6A7vG9VEHpNF41GOy1Nxst7QQ3QC3uZ54bWoxbMg@mail.gmail.com>
 <20170418210339.GA24257@obsidianresearch.com>
 <1492564806.25766.124.camel@kernel.crashing.org>
 <20170419155557.GA8497@obsidianresearch.com>
 <4899b011-bdfb-18d8-ef00-33a1516216a6@deltatee.com>
 <CAPcyv4iJ9H8Ykwnjqa2R_D1qG6PsSQmi=QxYH-rKLF_ihrsWyw@mail.gmail.com>
 <20170419173225.GA11255@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170419173225.GA11255-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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

On Wed, Apr 19, 2017 at 10:32 AM, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, Apr 19, 2017 at 10:01:23AM -0700, Dan Williams wrote:
>> On Wed, Apr 19, 2017 at 9:48 AM, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:
>> >
>> >
>> > On 19/04/17 09:55 AM, Jason Gunthorpe wrote:
>> >> I was thinking only this one would be supported with a core code
>> >> helper..
>> >
>> > Pivoting slightly: I was looking at how HMM uses ZONE_DEVICE. They add a
>> > type flag to the dev_pagemap structure which would be very useful to us.
>> > We could add another MEMORY_DEVICE_P2P type to distinguish p2p pages.
>> > Then, potentially, we could add a dma_map callback to the structure
>> > (possibly unioned with an hmm field). The dev_ops providers would then
>> > just need to do something like this (enclosed in a helper):
>> >
>> > if (is_zone_device_page(page)) {
>> >         pgmap = get_dev_pagemap(page_to_pfn(page));
>> >         if (!pgmap || pgmap->type !=  MEMORY_DEVICE_P2P ||
>> >             !pgmap->dma_map)
>> >                 return 0;
>> >
>> >         dma_addr = pgmap->dma_map(dev, pgmap->dev, page);
>> >         put_dev_pagemap(pgmap);
>> >         if (!dma_addr)
>> >                 return 0;
>> >         ...
>> > }
>> >
>> > The pci_enable_p2p_bar function would then just need to call
>> > devm_memremap_pages with the dma_map callback set to a function that
>> > does the segment check and the offset calculation.
>> >
>> > Thoughts?
>> >
>> > @Jerome: my feedback to you would be that your patch assumes all users
>> > of devm_memremap_pages are MEMORY_DEVICE_PERSISTENT. It would be more
>> > useful if it was generic. My suggestion would be to have the caller
>> > allocate the dev_pagemap structure, populate it and pass it into
>> > devm_memremap_pages. Given that pretty much everything in that structure
>> > are already arguments to that function, I feel like this makes sense.
>> > This should also help to unify hmm_devmem_pages_create and
>> > devm_memremap_pages which look very similar to each other.
>>
>> I like that change. Also the types should describe the memory relative
>> to its relationship to struct page, not whether it is persistent or
>> not. I would consider volatile and persistent memory that is attached
>> to the cpu memory controller and i/o coherent as the same type of
>> memory. DMA incoherent ranges like P2P and HMM should get their own
>> types.
>
> Dan you asked me to not use devm_memremap_pages() because you didn't
> want to have HMM memory in the pgmap_radix, did you change opinion
> on that ? :)

No, not quite ;-). I still don't think we should require the non-HMM
to pass NULL for all the HMM arguments. What I like about Logan's
proposal is to have a separate create and register steps dev_pagemap.
That way call paths that don't care about HMM specifics can just turn
around and register the vanilla dev_pagemap.

> Note i won't make any change now on that front but if it make sense
> i am happy to do it as separate patchset on top of HMM.
>
> Also i don't want p2pmem to be an exclusive or with HMM, we will want
> GPU to do peer to peer DMA and thus HMM ZONE_DEVICE pages to support
> this too.

Yes, this makes sense I think we really just want to distinguish host
memory or not in terms of the dev_pagemap type.
