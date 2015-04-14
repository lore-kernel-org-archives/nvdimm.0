Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <552D1A08.3000206@plexistor.com>
Date: Tue, 14 Apr 2015 16:45:44 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [GIT PULL] PMEM driver for v4.1
References: <20150413093309.GA30219@gmail.com> <20150413093541.GA5147@lst.de> <20150413104531.GB30556@gmail.com> <20150413171805.GA14243@lst.de> <20150414124157.GA28544@gmail.com>
In-Reply-To: <20150414124157.GA28544@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 04/14/2015 03:41 PM, Ingo Molnar wrote:
> 
> * Christoph Hellwig <hch@lst.de> wrote:
> 
>> On Mon, Apr 13, 2015 at 12:45:32PM +0200, Ingo Molnar wrote:
>>> Btw., what's the future design plan here? Enable struct page backing, 
>>> or provide special codepaths for all DAX uses like the special pte 
>>> based approach for mmap()s?
>>
>> There are a couple approaches proposed, but we don't have consensus which
>> way to go yet (to put it mildly).
>>
>>  - the old Intel patches just allocate pages for E820_PMEM regions.
>>    I think this is a good way forward for the "old-school" small
>>    pmem regions which usually are battery/capacitor + flash backed
>>    DRAM anyway.  This could easily be resurrected for the current code,
>>    but it couldn't be used for PCI backed pmem regions, and would work
>>    although waste a lot of resources for the gigantic pmem devices some
>>    Intel people talk about (400TB+ IIRC).
> 
> So here's how I calculate the various scenarios:
> 
> There are two main usecases visible currently for pmem devices: 'pmem 
> as storage' and 'pmem as memory', and they have rather distinct 
> characteristics.
> 
> 1) pmem devices as 'storage':
> 
> So the size of 'struct page' is 64 bytes currently.
> 
> So even if a pmem device is just 1 TB (small storage), for example to 
> replace storage on a system, we'd have to allocate 64 bytes per 4096 
> bytes of storage, which would use up 16 GB of main memory just for the 
> page struct arrays...
> 
> So in this case 'struct page' allocation is not acceptable even for 
> relatively small pmem device sizes.
> 
> For this usecase I think the current pmem driver is perfectly 
> acceptable and in fact ideal:
> 
>   - it double buffers, giving higher performance and also protecting
>     storage from wear (that is likely flash based)
> 
>   - the double buffering makes most struct page based APIs work just 
>     fine.
> 
>   - it offers the DAX APIs for those weird special cases that really 
>     want to do their own cache and memory management (databases and 
>     other crazy usecases)
> 
> 2) pmem devices as 'memory':
> 
> Battery backed and similar solutions of nv-dram, these are probably a 
> lot smaller (for cost reasons) and are also a lot more RAM-alike, so 
> the 'struct page' allocation in main RAM makes sense and possibly 
> people would want to avoid the double buffering as well.
> 
> Furthermore, in this case we could also do another trick:
> 
>>  - Intel has proposed changes that allow block I/O on regions that aren't
>>    page backed, by supporting PFN-based scatterlists which would have to be
>>    supported all over the I/O path. Reception of that code has been rather
>>    mediocre in general, although I wouldn't rule it out.
>>
>>  - Boaz has shown code that creates pages dynamically for pmem regions.
>>    Unlike the old Intel e820 code that would also work for PCI backed
>>    pmem regions.  Boaz says he has such a card, but until someone actually
>>    publishes specs and/or the trivial pci_driver for them I'm inclined to
>>    just ignore that option.
>>
>>  - There have been proposals for temporary struct page mappings, or
>>    variable sized pages, but as far as I can tell no code to actually
>>    implement these schemes.
> 
> None of this gives me warm fuzzy feelings...
> 
> ... has anyone explored the possibility of putting 'struct page' into 
> the pmem device itself, essentially using it as metadata?
> 

Is what I've been saying from the first time it was asked

Yes this works today.
With my patchset it can be done.

The way it works is through memory_hotplug. You can hotplug in a pmem range
as additional memory. This adds to the total amount of memory in the system.

you than load the pmem device with page-struct support that will allocate
from the regular memory pools, but which are now bigger.

What I thought is that one "partition" on the device can be used
as RAM, and its contents is re-initialized on boot.
(I'm saying "partition" because it is more a pre-defined range not
 a real block-layer partition)

That said, it should be very easy to build on my patchset and instruct
add_section to use a pre-allocated area for the page-structs.
(I will add an RFC patch that will do this)

> Since it's directly mapped it should just work for most things if it's 
> at least write-through cached (UC would be a horror), and it would 
> also solve all the size problems. With write-through caching it should 
> also be pretty OK performance-wise. The 64 bytes size is ideal as 
> well.
> 
> ( This would create a bit of a dependency with the kernel version, and 
>   would complicate things of how to acquire a fresh page array after 
>   bootup, but that could be solved relatively easily IMHO. )
> 
> This would eliminate all the negative effects dynamic allocation of 
> page structs or sg-lists brings.
> 
> Anyway:
> 
> Since both the 'pmem as storage' and 'pmem as memory' usecases will 
> likely be utilized in practice, IMHO we should hedge our bets by 
> supporting both equally well: we should start with the simpler one 
> (the current driver) and then support both in the end, with as much 
> end user flexibility as possible.
> 

I have a pending patch to let user specify the mapping used per pmem
device, (And default set at Kconfig). Including a per device use
of pages. pages just being one of the mapping modes.

So all this can just be under the same driver and each admin can
configure for his own needs.

I will send a new patchset once the merge window is over. And we
can then see how it all looks.

> Thanks,
> 	Ingo
> 

Thanks Ingo very much
Boaz

