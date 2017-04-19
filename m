From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Wed, 19 Apr 2017 11:14:51 -0600
Message-ID: <20170419171451.GA10020@obsidianresearch.com>
References: <1492381396.25766.43.camel@kernel.crashing.org>
 <20170418164557.GA7181@obsidianresearch.com>
 <cce00131-1f28-27b3-40ab-04f8783f1e5a@deltatee.com>
 <20170418190138.GH7181@obsidianresearch.com>
 <df1351d8-b86c-2e21-1948-4688ece5dc2b@deltatee.com>
 <CAPcyv4gScx6A7vG9VEHpNF41GOy1Nxst7QQ3QC3uZ54bWoxbMg@mail.gmail.com>
 <20170418210339.GA24257@obsidianresearch.com>
 <1492564806.25766.124.camel@kernel.crashing.org>
 <20170419155557.GA8497@obsidianresearch.com>
 <4899b011-bdfb-18d8-ef00-33a1516216a6@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4899b011-bdfb-18d8-ef00-33a1516216a6-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Apr 19, 2017 at 10:48:51AM -0600, Logan Gunthorpe wrote:
> The pci_enable_p2p_bar function would then just need to call
> devm_memremap_pages with the dma_map callback set to a function that
> does the segment check and the offset calculation.

I don't see a use for the dma_map function pointer at this point..

It doesn't make alot of sense for the completor of the DMA to provide
a mapping op, the mapping process is *path* specific, not specific to
a completer/initiator.

So, I would suggest more like this:

static inline struct device *get_p2p_src(struct page *page)
{
        struct device *res;
	struct dev_pagemap *pgmap;

	if (!is_zone_device_page(page))
	     return NULL;
	
        pgmap = get_dev_pagemap(page_to_pfn(page), NULL);
        if (!pgmap || pgmap->type !=  MEMORY_DEVICE_P2P)
	        /* For now ZONE_DEVICE memory that is not P2P is
 		   assumed to be configured for DMA the same as CPU
		   memory. */
                return ERR_PTR(-EINVAL);
	res = pgmap->dev;
	device_get(res);
	put_dev_pagemap(pgmap);
	return res;
}

dma_addr_t pci_p2p_same_segment(struct device *initator,
                                struct device *completer,
				struct page *page)
{
   if (! PCI initiator & completer)
       return ERROR;
   if (!same segment initiator & completer)
       return ERROR;

   // Translate page directly to the value programmed into the BAR
   return (Completer's PCI BAR base address) + (offset of page within BAR);
}

// dma_sg_map

for (each sgl) {
    struct page *page = sg_page(s);
    struct device *p2p_src = get_p2p_src(page);

    if (IS_ERR(p2p_src))
        // fail dma_sg

    if (p2p_src) {
        bool needs_iommu = false;

        pa = pci_p2p_same_segment(dev, p2p_src, page);
	if (pa == ERROR)
	    pa = arch_p2p_cross_segment(dev, p2psrc, page, &needs_iommui);

        device_put(p2p_src);

        if (pa == ERROR)
	    // fail

	if (!needs_iommu) {      
	    // Insert PA directly into the result SGL
	    sg++;
	    continue;
	}
    }
    else
        // CPU memory
        pa = page_to_phys(page);


To me it looks like the code duplication across the iommu stuff comes
from just duplicating the basic iommu algorithm in every driver.

To clean that up I think someone would need to hoist the overall sgl
loop and use more ops callbacks eg allocate_iommu_range,
assign_page_to_rage, dealloc_range, etc. This is a problem p2p makes
worse, but isn't directly causing :\

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
