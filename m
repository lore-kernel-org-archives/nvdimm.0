From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Tue, 18 Apr 2017 15:31:58 -0600
Message-ID: <9fc9352f-86fe-3a9e-e372-24b3346b518c@deltatee.com>
References: <CAPcyv4it56J8Voo6kV0bBcO3nHsOHYLENpAtONJZTGceDDwNPg@mail.gmail.com>
 <1492381396.25766.43.camel@kernel.crashing.org>
 <20170418164557.GA7181@obsidianresearch.com>
 <cce00131-1f28-27b3-40ab-04f8783f1e5a@deltatee.com>
 <20170418190138.GH7181@obsidianresearch.com>
 <df1351d8-b86c-2e21-1948-4688ece5dc2b@deltatee.com>
 <CAPcyv4gScx6A7vG9VEHpNF41GOy1Nxst7QQ3QC3uZ54bWoxbMg@mail.gmail.com>
 <20170418210339.GA24257@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170418210339.GA24257-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org



On 18/04/17 03:03 PM, Jason Gunthorpe wrote:
> What about something more incremental like this instead:
> - dma_ops will set map_sg_p2p == map_sg when they are updated to
>   support p2p, otherwise DMA on P2P pages will fail for those ops.
> - When all ops support p2p we remove the if and ops->map_sg then
>   just call map_sg_p2p
> - For now the scatterlist maintains a bit when pages are added indicating if
>   p2p memory might be present in the list.
> - Unmap for p2p and non-p2p is the same, the underlying ops driver has
>   to make it work.
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 0977317c6835c2..505ed7d502053d 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -103,6 +103,9 @@ struct dma_map_ops {
>  	int (*map_sg)(struct device *dev, struct scatterlist *sg,
>  		      int nents, enum dma_data_direction dir,
>  		      unsigned long attrs);
> +	int (*map_sg_p2p)(struct device *dev, struct scatterlist *sg,
> +			  int nents, enum dma_data_direction dir,
> +			  unsigned long attrs);
>  	void (*unmap_sg)(struct device *dev,
>  			 struct scatterlist *sg, int nents,
>  			 enum dma_data_direction dir,
> @@ -244,7 +247,15 @@ static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
>  	for_each_sg(sg, s, nents, i)
>  		kmemcheck_mark_initialized(sg_virt(s), s->length);
>  	BUG_ON(!valid_dma_direction(dir));
> -	ents = ops->map_sg(dev, sg, nents, dir, attrs);
> +
> +	if (sg_has_p2p(sg)) {
> +		if (ops->map_sg_p2p)
> +			ents = ops->map_sg_p2p(dev, sg, nents, dir, attrs);
> +		else
> +			return 0;
> +	} else
> +		ents = ops->map_sg(dev, sg, nents, dir, attrs);
> +
>  	BUG_ON(ents < 0);
>  	debug_dma_map_sg(dev, sg, nents, ents, dir);

I could get behind this. Though a couple of points:

1) It means that sg_has_p2p has to walk the entire sg and check every
page. Then map_sg_p2p/map_sg has to walk it again and repeat the check
then do some operation per page. If anyone is concerned about the
dma_map performance this could be an issue.

2) Without knowing exactly what the arch specific code may need to do
it's hard to say that this is exactly the right approach. If every
dma_ops provider has to do exactly this on every page it may lead to a
lot of duplicate code:

foreach_sg page:
   if (pci_page_is_p2p(page)) {
        dma_addr = pci_p2p_map_page(page)
	if (!dma_addr)
		return 0;
        continue
   }
   ...

The only thing I'm presently aware of is the segment check and applying
the offset to the physical address -- neither of which has much to do
with the specific dma_ops providers. It _may_ be that this needs to be
bus specific and not arch specific which I think is what Dan may be
getting at. So it may make sense to just have a pci_map_sg_p2p() which
takes a dma_ops struct it would use for any page that isn't a p2p page.

Logan
