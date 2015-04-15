Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 15 Apr 2015 10:45:00 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL] PMEM driver for v4.1
Message-ID: <20150415084500.GB14700@gmail.com>
References: <20150413093309.GA30219@gmail.com>
 <20150413093541.GA5147@lst.de>
 <20150413104531.GB30556@gmail.com>
 <20150413171805.GA14243@lst.de>
 <20150414124157.GA28544@gmail.com>
 <CAPcyv4hwdQr-i2wdyOfzBoz41EvW7orBjPZepjDX6BNHpwhukA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hwdQr-i2wdyOfzBoz41EvW7orBjPZepjDX6BNHpwhukA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Boaz Harrosh <boaz@plexistor.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>


* Dan Williams <dan.j.williams@intel.com> wrote:

> > None of this gives me warm fuzzy feelings...
> >
> > ... has anyone explored the possibility of putting 'struct page' 
> > into the pmem device itself, essentially using it as metadata?
> 
> Yes, the impetus for proposing the pfn conversion of the block layer 
> was the consideration that persistent memory may have less write 
> endurance than DRAM.  The kernel preserving write endurance 
> exclusively for user data and the elimination of struct page 
> overhead motivated the patchset [1].
> 
> [1]: https://lwn.net/Articles/636968/

(Is there a Git URL where I could take a look at these patches?)

But, I think the usage of pfn's in the block layer is relatively 
independent of the question whether a pmem region should be 
permanently struct page backed or not.

I think the main confusion comes from the fact that 'pfn' can have two 
roles with sufficiently advanced MMIO interfaces: describing main RAM 
page (struct page), but also describing essentially sectors on a 
large, MMIO-accessible storage device, directly visible to the CPU but 
otherwise not RAM.

So for that reason I think pmem devices should be both struct page 
backed and not struct page backed, depending on their physical 
characteristics:

------------

1)

If a pmem device is in any way expected to be write-unreliable (i.e. 
it's not DRAM but flash) then it's going to be potentially large and 
we simply cannot use struct page backing for it, full stop.

Users very likely want a filesystem on it, with double buffering that 
both reduces wear and makes better use of main RAM and CPU caches.

In this case the pmem device is a simple storage device that has a 
refreshlingly clean hardware ABI that exposes all of its contents in a 
large, directly mapped MMIO region in essence.

We don't back mass storage with struct page, we never did with any of 
the other storage devices either.

I'd expect this to be the 90% dominant 'pmem usecase' in the future.

In this case any 'direct mapping' system calls, DIO or 
non-double-buffering mmaps() and DAX on the other hand will stay a 
'weird' secondary usecases for user-space operating systems like 
databases that want to take caching out of the hands of the kernel.
 
The majority of users will use it as storage, with a filesystem on it 
and regular RAM caching it for everyone's gain. All the struct page 
based APIs and system calls will work just fine, and the rare usecases 
will be served by DAX.

------------

2)

But if a pmem device is RAM, with no write unreliability, then we 
obviously want it to have struct page backing, and we probably want to 
think about it more in terms of hot-pluggable memory, than a storage 
device.

This scenario will be less common than the mass-storage scenario.

Note that this is similar to how GPU memory is categorized: it's 
essentially RAM-alike, which naturally results in struct page backing.

------------

Note that scenarios 1) and 2) are not under our control, they are 
essentially a physical property, with some user policy influencing it 
as well. So we have to support both and we have no 'opinion' about 
which one is right, as it's simply physical reality as-is.

In that sense I think this driver does the right thing as a first 
step: it exposes pmem regions in the more conservative fashion, as a 
block storage device, assuming write unreliability.

Patches that would turn the pmem driver into unconditionally struct 
page backed would be misguided for this usecase. Allocating and 
freeing struct page arrays on the fly would be similarly misguided.

But patches that allow pmem regions that declare themselves true RAM 
to be inserted as hotplug memory would be the right approach IMHO - 
while still preserving the pmem block device and the non-struct-page 
backed approach for other pmem devices.

Note how in this picture the question of how IO scatter-gather lists 
are constructed is an implementational detail that does not impact the 
main design: they are essentially DMA abstractions for storage 
devices, implemented efficiently via memcpy() in the pmem case, and 
both pfn lists and struct page lists are pretty equivalent approaches 
for most usages.

The only exception are the 'weird' usecases like DAX, DIO and RDMA: 
these have to be pfn driven, due to the lack of struct page 
descriptors for storage devices in general. In that case the 'pfn' 
isn't really memory, but a sector_t equivalent, for this new type of 
storage DMA that is implemented via a memcpy().

In that sense the special DAX page fault handler looks like a natural 
approach as well: the pfn's in the page table aren't really describing 
memory pages, but 'sectors' on an IO device - with special rules, 
limited APIs and ongoing complications to be expected.

At least that's how I see it.

Thanks,

	Ingo
