From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Wed, 19 Apr 2017 13:31:54 -0600
Message-ID: <20170419193154.GA14340@obsidianresearch.com>
References: <df1351d8-b86c-2e21-1948-4688ece5dc2b@deltatee.com>
 <CAPcyv4gScx6A7vG9VEHpNF41GOy1Nxst7QQ3QC3uZ54bWoxbMg@mail.gmail.com>
 <20170418210339.GA24257@obsidianresearch.com>
 <1492564806.25766.124.camel@kernel.crashing.org>
 <20170419155557.GA8497@obsidianresearch.com>
 <4899b011-bdfb-18d8-ef00-33a1516216a6@deltatee.com>
 <20170419171451.GA10020@obsidianresearch.com>
 <b0234176-e86b-6e7c-686d-b4fef719aad7@deltatee.com>
 <20170419183247.GA13716@obsidianresearch.com>
 <21e8099a-d19d-7df0-682d-627d8b81dfde@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <21e8099a-d19d-7df0-682d-627d8b81dfde-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
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

On Wed, Apr 19, 2017 at 01:02:49PM -0600, Logan Gunthorpe wrote:
> 
> 
> On 19/04/17 12:32 PM, Jason Gunthorpe wrote:
> > On Wed, Apr 19, 2017 at 12:01:39PM -0600, Logan Gunthorpe wrote:
> > Not entirely, it would have to call through the whole process
> > including the arch_p2p_cross_segment()..
> 
> Hmm, yes. Though it's still not clear what, if anything,
> arch_p2p_cross_segment would be doing.

Sets up the iommu for arches that place a iommu between the pci root
port and other pci root ports.

> In my experience, if you are going between host bridges, the CPU
> address (or PCI address -- I'm not sure which seeing they are the
> same on my system) would still work fine

Try it with VT-D turned on. It shouldn't work or there is a notable
security hole in your platform..

> > 	 const struct dma_map_ops *comp_ops = get_dma_ops(completer);
> > 	 const struct dma_map_ops *init_ops = get_dma_ops(initiator);
>
> So, in this case, what device does the completer point to? The PCI
> device or a more specific GPU device? If it's the former, who's
> responsible for setting the new dma_ops? Typically the dma_ops are arch
> specific but now you'd be adding ones that are tied to hmm or the gpu.

Donno, that is for GPU folks to figure out :)

But.. it could point to a GPU and the GPU struct device could have a
proxy dma_ops like Dan pointed out.

> >> I'm not sure I like the name pci_p2p_same_segment. It reads as though
> >> it's only checking if the devices are not the same segment.
> > 
> > Well, that is exactly what it is doing. If it succeeds then the caller
> > knows the DMA will not flow outside the segment and no iommu setup/etc
> > is required.
> 
> It appears to me like it's calculating the DMA address, and the check is
> just a side requirement. It reads as though it's only doing the check.

pci_p2p_same_segment_get_pa() then?

Jason
