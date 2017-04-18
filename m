From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Tue, 18 Apr 2017 10:27:47 -0700
Message-ID: <CAPcyv4izLa2vw12ysvVfd=ysaMKcASNFm+=CaqDKhnPY9B5OJg@mail.gmail.com>
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
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, Apr 18, 2017 at 9:45 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Apr 17, 2017 at 08:23:16AM +1000, Benjamin Herrenschmidt wrote:
>
>> Thanks :-) There's a reason why I'm insisting on this. We have constant
>> requests for this today. We have hacks in the GPU drivers to do it for
>> GPUs behind a switch, but those are just that, ad-hoc hacks in the
>> drivers. We have similar grossness around the corner with some CAPI
>> NICs trying to DMA to GPUs. I have people trying to use PLX DMA engines
>> to whack nVME devices.
>
> A lot of people feel this way in the RDMA community too. We have had
> vendors shipping out of tree code to enable P2P for RDMA with GPU
> years and years now. :(
>
> Attempts to get things in mainline have always run into the same sort
> of road blocks you've identified in this thread..
>
> FWIW, I read this discussion and it sounds closer to an agreement than
> I've ever seen in the past.
>
> From Ben's comments, I would think that the 'first class' support that
> is needed here is simply a function to return the 'struct device'
> backing a CPU address range.
>
> This is the minimal required information for the arch or IOMMU code
> under the dma ops to figure out the fabric source/dest, compute the
> traffic path, determine if P2P is even possible, what translation
> hardware is crossed, and what DMA address should be used.
>
> If there is going to be more core support for this stuff I think it
> will be under the topic of more robustly describing the fabric to the
> core and core helpers to extract data from the description: eg compute
> the path, check if the path crosses translation, etc
>
> But that isn't really related to P2P, and is probably better left to
> the arch authors to figure out where they need to enhance the existing
> topology data..
>
> I think the key agreement to get out of Logan's series is that P2P DMA
> means:
>  - The BAR will be backed by struct pages
>  - Passing the CPU __iomem address of the BAR to the DMA API is
>    valid and, long term, dma ops providers are expected to fail
>    or return the right DMA address
>  - Mapping BAR memory into userspace and back to the kernel via
>    get_user_pages works transparently, and with the DMA API above
>  - The dma ops provider must be able to tell if source memory is bar
>    mapped and recover the pci device backing the mapping.
>
> At least this is what we'd like in RDMA :)
>
> FWIW, RDMA probably wouldn't want to use a p2mem device either, we
> already have APIs that map BAR memory to user space, and would like to
> keep using them. A 'enable P2P for bar' helper function sounds better
> to me.

...and I think it's not a helper function as much as asking the bus
provider "can these two device dma to each other". The "helper" is the
dma api redirecting through a software-iommu that handles bus address
translation differently than it would handle host memory dma mapping.
