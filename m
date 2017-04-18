From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Tue, 18 Apr 2017 15:51:27 -0700
Message-ID: <CAPcyv4gQxifHcKLv0CZZoXJWz=rtzv-vGoofkek6NxRABd4XyA@mail.gmail.com>
References: <cce00131-1f28-27b3-40ab-04f8783f1e5a@deltatee.com>
 <20170418190138.GH7181@obsidianresearch.com> <df1351d8-b86c-2e21-1948-4688ece5dc2b@deltatee.com>
 <CAPcyv4gScx6A7vG9VEHpNF41GOy1Nxst7QQ3QC3uZ54bWoxbMg@mail.gmail.com>
 <20170418210339.GA24257@obsidianresearch.com> <CAPcyv4h9n9Uzq4FAXR0ufieqvx5_txEwtnaaBWdxe-jF_XfTLg@mail.gmail.com>
 <20170418212258.GA26838@obsidianresearch.com> <CAPcyv4g5ifbpukthMXMro8qKdfoXAhftDpiwWWFCLZ4dK8JnnA@mail.gmail.com>
 <96198489-1af5-abcf-f23f-9a7e41aa17f7@deltatee.com> <CAPcyv4haUUs1Eew1PZTZkoGU4YFiHOuU93G+kG+CqfKzjz1gpw@mail.gmail.com>
 <20170418224225.GB27113@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170418224225.GB27113-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, Apr 18, 2017 at 3:42 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Apr 18, 2017 at 03:28:17PM -0700, Dan Williams wrote:
>
>> Unlike the pci bus address offset case which I think is fundamental to
>> support since shipping archs do this toda
>
> But we can support this by modifying those arch's unique dma_ops
> directly.
>
> Eg as I explained, my p2p_same_segment_map_page() helper concept would
> do the offset adjustment for same-segement DMA.
>
> If PPC calls that in their IOMMU drivers then they will have proper
> support for this basic p2p, and the right framework to move on to more
> advanced cases of p2p.
>
> This really seems like much less trouble than trying to wrapper all
> the arch's dma ops, and doesn't have the wonky restrictions.

I don't think the root bus iommu drivers have any business knowing or
caring about dma happening between devices lower in the hierarchy.

>> I think it is ok to say p2p is restricted to a single sgl that gets
>> to talk to host memory or a single device.
>
> RDMA and GPU would be sad with this restriction...
>
>> That said, what's wrong with a p2p aware map_sg implementation
>> calling up to the host memory map_sg implementation on a per sgl
>> basis?
>
> Setting up the iommu is fairly expensive, so getting rid of the
> batching would kill performance..

When we're crossing device and host memory boundaries how much
batching is possible? As far as I can see you'll always be splitting
the sgl on these dma mapping boundaries.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
