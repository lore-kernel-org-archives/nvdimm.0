From: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Sun, 16 Apr 2017 08:17:08 +1000
Message-ID: <1492294628.25766.33.camel@kernel.crashing.org>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1491974532.7236.43.camel@kernel.crashing.org>
 <5ac22496-56ec-025d-f153-140001d2a7f9@deltatee.com>
 <1492034124.7236.77.camel@kernel.crashing.org>
 <81888a1e-eb0d-cbbc-dc66-0a09c32e4ea2@deltatee.com>
 <20170413232631.GB24910@bhelgaas-glaptop.roam.corp.google.com>
 <20170414041656.GA30694@obsidianresearch.com>
 <1492169849.25766.3.camel@kernel.crashing.org>
 <630c1c63-ff17-1116-e069-2b8f93e50fa2@deltatee.com>
 <20170414190452.GA15679@bhelgaas-glaptop.roam.corp.google.com>
 <1492207643.25766.18.camel@kernel.crashing.org>
 <bff1e503-95a9-e19f-bfd9-0ff962c63a81@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <bff1e503-95a9-e19f-bfd9-0ff962c63a81-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Sat, 2017-04-15 at 11:41 -0600, Logan Gunthorpe wrote:
> Thanks, Benjamin, for the summary of some of the issues.
> 
> On 14/04/17 04:07 PM, Benjamin Herrenschmidt wrote
> > So I assume the p2p code provides a way to address that too via special
> > dma_ops ? Or wrappers ?
> 
> Not at this time. We will probably need a way to ensure the iommus do
> not attempt to remap these addresses.

You can't. If the iommu is on, everything is remapped. Or do you mean
to have dma_map_* not do a remapping ?

That's the problem again, same as before, for that to work, the
dma_map_* ops would have to do something special that depends on *both*
the source and target device.

The current DMA infrastructure doesn't have anything like that. It's a
rather fundamental issue to your design that you need to address.

The dma_ops today are architecture specific and have no way to
differenciate between normal and those special P2P DMA pages.

> Though if it does, I'd expect
> everything would still work you just wouldn't get the performance or
> traffic flow you are looking for. We've been testing with the software
> iommu which doesn't have this problem.

So first, no, it's more than "you wouldn't get the performance". On
some systems it may also just not work. Also what do you mean by "the
SW iommu doesn't have this problem" ? It catches the fact that
addresses don't point to RAM and maps differently ?

> > The problem is that the latter while seemingly easier, is also slower
> > and not supported by all platforms and architectures (for example,
> > POWER currently won't allow it, or rather only allows a store-only
> > subset of it under special circumstances).
> 
> Yes, I think situations where we have to cross host bridges will remain
> unsupported by this work for a long time. There are two many cases where
> it just doesn't work or it performs too poorly to be useful.

And the situation where you don't cross bridges is the one where you
need to also take into account the offsets.

*both* cases mean that you need somewhat to intervene at the dma_ops
level to handle this. Which means having a way to identify your special
struct pages or PFNs to allow the arch to add a special case to the
dma_ops.

> > I don't fully understand how p2pmem "solves" that by creating struct
> > pages. The offset problem is one issue. But there's the iommu issue as
> > well, the driver cannot just use the normal dma_map ops.
> 
> We are not using a proper iommu and we are dealing with systems that
> have zero offset. This case is also easily supported. I expect fixing
> the iommus to not map these addresses would also be reasonably achievable.

So you are designing something that is built from scratch to only work
on a specific limited category of systems and is also incompatible with
virtualization.

This is an interesting experiement to look at I suppose, but if you
ever want this upstream I would like at least for you to develop a
strategy to support the wider case, if not an actual implementation.

Cheers,
Ben.
