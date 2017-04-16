From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Sat, 15 Apr 2017 23:36:34 -0600
Message-ID: <3bf6ea2a-a480-0df9-de35-ee9aca64940e@deltatee.com>
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
 <1492294628.25766.33.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1492294628.25766.33.camel-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org



On 15/04/17 04:17 PM, Benjamin Herrenschmidt wrote:
> You can't. If the iommu is on, everything is remapped. Or do you mean
> to have dma_map_* not do a remapping ?

Well, yes, you'd have to change the code so that iomem pages do not get
remapped and the raw BAR address is passed to the DMA engine. I said
specifically we haven't done this at this time but it really doesn't
seem like an unsolvable problem. It is something we will need to address
before a proper patch set is posted though.

> That's the problem again, same as before, for that to work, the
> dma_map_* ops would have to do something special that depends on *both*
> the source and target device.

No, I don't think you have to do things different based on the source.
Have the p2pmem device layer restrict allocating p2pmem based on the
devices in use (similar to how the RFC code works now) and when the dma
mapping code sees iomem pages it just needs to leave the address alone
so it's used directly by the dma in question.

It's much better to make the decision on which memory to use when you
allocate it. If you wait until you map it, it would be a pain to fall
back to system memory if it doesn't look like it will work. So, if when
you allocate it, you know everything will work you just need the dma
mapping layer to stay out of the way.

> The dma_ops today are architecture specific and have no way to
> differenciate between normal and those special P2P DMA pages.

Correct, unless Dan's idea works (which will need some investigation),
we'd need a flag in struct page or some other similar method to
determine that these are special iomem pages.

>> Though if it does, I'd expect
>> everything would still work you just wouldn't get the performance or
>> traffic flow you are looking for. We've been testing with the software
>> iommu which doesn't have this problem.
> 
> So first, no, it's more than "you wouldn't get the performance". On
> some systems it may also just not work. Also what do you mean by "the
> SW iommu doesn't have this problem" ? It catches the fact that
> addresses don't point to RAM and maps differently ?

I haven't tested it but I can't imagine why an iommu would not correctly
map the memory in the bar. But that's _way_ beside the point. We
_really_ want to avoid that situation anyway. If the iommu maps the
memory it defeats what we are trying to accomplish.

I believe the sotfware iommu only uses bounce buffers if the DMA engine
in use cannot address the memory. So in most cases, with modern
hardware, it just passes the BAR's address to the DMA engine and
everything works. The code posted in the RFC does in fact work without
needing to do any of this fussing.

>>> The problem is that the latter while seemingly easier, is also slower
>>> and not supported by all platforms and architectures (for example,
>>> POWER currently won't allow it, or rather only allows a store-only
>>> subset of it under special circumstances).
>>
>> Yes, I think situations where we have to cross host bridges will remain
>> unsupported by this work for a long time. There are two many cases where
>> it just doesn't work or it performs too poorly to be useful.
> 
> And the situation where you don't cross bridges is the one where you
> need to also take into account the offsets.

I think for the first incarnation we will just not support systems that
have offsets. This makes things much easier and still supports all the
use cases we are interested in.

> So you are designing something that is built from scratch to only work
> on a specific limited category of systems and is also incompatible with
> virtualization.

Yes, we are starting with support for specific use cases. Almost all
technology starts that way. Dax has been in the kernel for years and
only recently has someone submitted patches for it to support pmem on
powerpc. This is not unusual. If you had forced the pmem developers to
support all architectures in existence before allowing them upstream
they couldn't possibly be as far as they are today.

Virtualization specifically would be a _lot_ more difficult than simply
supporting offsets. The actual topology of the bus will probably be lost
on the guest OS and it would therefor have a difficult time figuring out
when it's acceptable to use p2pmem. I also have a difficult time seeing
a use case for it and thus I have a hard time with the argument that we
can't support use cases that do want it because use cases that don't
want it (perhaps yet) won't work.

> This is an interesting experiement to look at I suppose, but if you
> ever want this upstream I would like at least for you to develop a
> strategy to support the wider case, if not an actual implementation.

I think there are plenty of avenues forward to support offsets, etc.
It's just work. Nothing we'd be proposing would be incompatible with it.
We just don't want to have to do it all upfront especially when no one
really knows how well various architecture's hardware supports this or
if anyone even wants to run it on systems such as those. (Keep in mind
this is a pretty specific optimization that mostly helps systems
designed in specific ways -- not a general "everybody gets faster" type
situation.) Get the cases working we know will work, can easily support
and people actually want.  Then expand it to support others as people
come around with hardware to test and use cases for it.

Logan
