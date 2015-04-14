Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150414124157.GA28544@gmail.com>
References: <20150413093309.GA30219@gmail.com>
	<20150413093541.GA5147@lst.de>
	<20150413104531.GB30556@gmail.com>
	<20150413171805.GA14243@lst.de>
	<20150414124157.GA28544@gmail.com>
Date: Tue, 14 Apr 2015 09:04:41 -0700
Message-ID: <CAPcyv4hwdQr-i2wdyOfzBoz41EvW7orBjPZepjDX6BNHpwhukA@mail.gmail.com>
Subject: Re: [GIT PULL] PMEM driver for v4.1
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Boaz Harrosh <boaz@plexistor.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 14, 2015 at 5:41 AM, Ingo Molnar <mingo@kernel.org> wrote:
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

Yes, the impetus for proposing the pfn conversion of the block layer
was the consideration that persistent memory may have less write
endurance than DRAM.  The kernel preserving write endurance
exclusively for user data and the elimination of struct page overhead
motivated the patchset [1].

[1]: https://lwn.net/Articles/636968/
