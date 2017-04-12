From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Wed, 12 Apr 2017 11:09:53 -0600
Message-ID: <5ac22496-56ec-025d-f153-140001d2a7f9@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1491974532.7236.43.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1491974532.7236.43.camel-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org



On 11/04/17 11:22 PM, Benjamin Herrenschmidt wrote:
> Another issue of course is that not all systems support P2P
> between host bridges :-) (Though almost all switches can enable it).

Yes, I'm either going to just let the user enable and test or limit it
to switches only to start. However, currently our bigger issue is
working on a way to not violate iomem safety.

> Ok. I suppose that's a reasonable starting point. Do I haven't looked
> at the patches in detail yet but it would be nice if that policy was in
> a well isolated component so it can potentially be affected by
> arch/platform code.

The policy is isolated in the new p2pmem driver. There's no reason the
policy couldn't become arbitrarily complex with specific arch
exceptions. It's just people would have to do the work to create those
exceptions.

> Do you handle funky address translation too ? IE. the fact that the PCI
> addresses aren't the same as the CPU physical addresses for a BAR ?

No, we use the CPU physical address of the BAR. If it's not mapped that
way we can't use it.

>> This will mean many setups that could likely
>> work well will not be supported so that we can be more confident it
>> will work and not place any responsibility on the user to understand
>> their topology. (We've chosen to go this route based on feedback we
>> received at LSF).
>>
>> In order to enable this functionality we introduce a new p2pmem device
>> which can be instantiated by PCI drivers. The device will register some
>> PCI memory as ZONE_DEVICE and provide an genalloc based allocator for
>> users of these devices to get buffers.
> 
> I don't completely understand this. This is actual memory on the PCI
> bus ? Where does it come from ? Or are you just trying to create struct
> pages that cover your PCIe DMA target ?

Yes, the memory is on the PCI bus in a BAR. For now we have a special
PCI card for this, but in the future it would likely be the CMB in an
NVMe card. These patches create struct pages to map these BAR addresses
using ZONE_DEVICE.


> So correct me if I'm wrong, you are trying to create struct page's that
> map a PCIe BAR right ? I'm trying to understand how that interacts with
> what Jerome is doing for HMM.

Yes, well we are using ZONE_DEVICE in the exact same way as the dax code
is. These patches use the existing API with no modifications. As I
understand it, HMM was using ZONE_DEVICE in a way that was quite
different to how it was originally designed.

> The reason is that the HMM currently creates the struct pages with
> "fake" PFNs pointing to a hole in the address space rather than
> covering the actual PCIe memory of the GPU. He does that to deal with
> the fact that some GPUs have a smaller aperture on PCIe than their
> total memory.

I'm aware of what HMM is trying to do and although I'm not familiar with
the intimate details, I saw it as fairly orthogonal to what we are
attempting to do.

> However, I have asked him to only apply that policy if the aperture is
> indeed smaller, and if not, create struct pages that directly cover the
> PCIe BAR of the GPU instead, which will work better on systems or
> architecture that don't have a "pinhole" window limitation.
> However he was under the impression that this was going to collide with
> what you guys are doing, so I'm trying to understand how. 

I'm not sure I understand how either. However, I suspect if you collide
with these patches then you'd also be breaking dax too.

Logan
