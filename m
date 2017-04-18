From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Tue, 18 Apr 2017 11:34:56 -0700
Message-ID: <CAPcyv4j16W_Q9m1X=GkgMYAyZ1JC3H_=+1CLxfB6CSqVEdWaMw@mail.gmail.com>
References: <CAPcyv4it56J8Voo6kV0bBcO3nHsOHYLENpAtONJZTGceDDwNPg@mail.gmail.com>
 <1492381396.25766.43.camel@kernel.crashing.org>
 <20170418164557.GA7181@obsidianresearch.com>
 <CAPcyv4izLa2vw12ysvVfd=ysaMKcASNFm+=CaqDKhnPY9B5OJg@mail.gmail.com>
 <20170418180020.GE7181@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170418180020.GE7181-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Tue, Apr 18, 2017 at 11:00 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Apr 18, 2017 at 10:27:47AM -0700, Dan Williams wrote:
>> > FWIW, RDMA probably wouldn't want to use a p2mem device either, we
>> > already have APIs that map BAR memory to user space, and would like to
>> > keep using them. A 'enable P2P for bar' helper function sounds better
>> > to me.
>>
>> ...and I think it's not a helper function as much as asking the bus
>> provider "can these two device dma to each other".
>
> What I mean I could write in a RDMA driver:
>
>   /* Allow the memory in BAR 1 to be the target of P2P transactions */
>   pci_enable_p2p_bar(dev, 1);
>
> And not require anything else..
>
>> The "helper" is the dma api redirecting through a software-iommu
>> that handles bus address translation differently than it would
>> handle host memory dma mapping.
>
> Not sure, until we see what arches actually need to do here it is hard
> to design common helpers.
>
> Here are a few obvious things that arches will need to implement to
> support this broadly:
>
> - Virtualization might need to do a hypervisor call to get the right
>   translation, or consult some hypervisor specific description table.
>
> - Anything using IOMMUs for virtualization will need to setup IOMMU
>   permissions to allow the P2P flow, this might require translation to
>   an address cookie.
>
> - Fail if the PCI devices are in different domains, or setup hardware to
>   do completion bus/device/function translation.
>
> - All platforms can succeed if the PCI devices are under the same
>   'segment', but where segments begin is somewhat platform specific
>   knowledge. (this is 'same switch' idea Logan has talked about)
>
> So, we can eventually design helpers for various common scenarios, but
> until we see what arch code actually needs to do it seems
> premature. Much of this seems to involve interaction with some kind of
> hardware, or consulation of some kind of currently platform specific
> data, so I'm not sure what a software-iommu would be doing??
>
> The main thing to agree on is that this code belongs under dma ops and
> that arches have to support struct page mapped BAR addresses in their
> dma ops inputs. Is that resonable?

I think we're saying the same thing by "software-iommu" and "custom
dma_ops", so yes.
