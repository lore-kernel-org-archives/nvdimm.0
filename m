From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Wed, 19 Apr 2017 12:32:47 -0600
Message-ID: <20170419183247.GA13716@obsidianresearch.com>
References: <cce00131-1f28-27b3-40ab-04f8783f1e5a@deltatee.com>
 <20170418190138.GH7181@obsidianresearch.com>
 <df1351d8-b86c-2e21-1948-4688ece5dc2b@deltatee.com>
 <CAPcyv4gScx6A7vG9VEHpNF41GOy1Nxst7QQ3QC3uZ54bWoxbMg@mail.gmail.com>
 <20170418210339.GA24257@obsidianresearch.com>
 <1492564806.25766.124.camel@kernel.crashing.org>
 <20170419155557.GA8497@obsidianresearch.com>
 <4899b011-bdfb-18d8-ef00-33a1516216a6@deltatee.com>
 <20170419171451.GA10020@obsidianresearch.com>
 <b0234176-e86b-6e7c-686d-b4fef719aad7@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b0234176-e86b-6e7c-686d-b4fef719aad7-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
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
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Apr 19, 2017 at 12:01:39PM -0600, Logan Gunthorpe wrote:

> I'm just spit balling here but if HMM wanted to use unaddressable memory
> as a DMA target, it could set that function to create a window ine gpu
> memory, then call the pci_p2p_same_segment and return the result as the
> dma address.

Not entirely, it would have to call through the whole process
including the arch_p2p_cross_segment()..

Maybe we can start down the road of using ops for more iommu steps
with something like this as the helper:

dma_addr_t dma_map_pa(struct device *initiator, struct page *page,
                      void *data)
{
         struct device *completer = get_p2p_completer(page);
	 dma_addr_t pa;

         if (IS_ERR(completer))
	       return SYSTEM_MEMORY;
	       // Or maybe ?
	       return init_ops->dma_map_pa(..);

	 // Try the generic method
	 pa = pci_p2p_same_segment(dev, p2p_src, page);
	 if (pa != ERROR)
	       goto out;

         // Try the arch specific helper
	 const struct dma_map_ops *comp_ops = get_dma_ops(completer);
	 const struct dma_map_ops *init_ops = get_dma_ops(initiator);

         /* FUTURE: Let something translate a HMM page into a DMA'ble
   	    page, eg by mapping it into a GPU window. Maybe this
	    callback lives in devmap ? */
	 page = comp_ops->translate_dma_page(completer, page);

         /* New dma_map_op is the same as arch_p2p_cross_segment in
	    prior version. Any arch specific data needed to program
	    the iommu flows through data */
	 pa = init_ops->p2p_cross_segment_map(completer, inititator, page, data);

out:
	 device_put(completer);
	 return pa;
}

// map_sg op:
for (each sgl) {
    struct page *page = sg_page(s);
    struct arch_iommu_data data = {}; // pass through to ops->p2p_cross_segment
    dma_addr_t pa;

    pa = dma_map_pa(dev, page, &data)
    if (pa == ERROR)
        // fail

    if (!data.needs_iommu) {
        // Insert PA directly into the result SGL
        sg++;
        continue;
    }

    // Else pa & data describe how to setup the iommu
}

> > dma_addr_t pci_p2p_same_segment(struct device *initator,
> >                                 struct device *completer,
> > 				struct page *page)
> 
> I'm not sure I like the name pci_p2p_same_segment. It reads as though
> it's only checking if the devices are not the same segment.

Well, that is exactly what it is doing. If it succeeds then the caller
knows the DMA will not flow outside the segment and no iommu setup/etc
is required.

That function cannot be expanded to include generic cross-segment
traffic, a new function would be needed..

Jason
