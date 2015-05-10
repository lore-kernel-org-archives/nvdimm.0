Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Sun, 10 May 2015 12:07:26 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: "Directly mapped persistent memory page cache"
Message-ID: <20150510100725.GB15198@gmail.com>
References: <CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com>
 <554BA748.9030804@linux.intel.com>
 <20150507191107.GB22952@gmail.com>
 <554CBE17.4070904@redhat.com>
 <20150508140556.GA2185@gmail.com>
 <21836.51957.715473.780762@quad.stoffel.home>
 <CA+55aFw70B=mDXVpvsJez6p=YTGBXknNgMHHqB54pKk+Eook9w@mail.gmail.com>
 <554CEB5D.90209@redhat.com>
 <20150509084510.GA10587@gmail.com>
 <87r3qpyciy.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r3qpyciy.fsf@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rik van Riel <riel@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, John Stoffel <john@stoffel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> > What do you think?
> 
> The tricky bit is what happens when you reboot and run a different 
> version of the kernel, especially a kernel with things debugging 
> features like kmemcheck that increase the size of struct page.

Yes - but I think that's relatively easy to handle, as most 'weird' 
page struct usages can be cordoned off:

I.e. we could define a 64-bit "core" struct page, denote it with a 
single PG_ flag and stick with it: the only ABI is its size 
essentially, as we (lazily) re-initialize it after every bootup.

The 'extended' (often debug) part of a struct page, such as 
page->shadow on kmemcheck, can simply be handled in a special way 
based on the PG_ flag:

 - for example in the kmemcheck case no page->shadow means no leak 
   tracking: that's perfectly fine as these pages aren't part of the 
   buddy allocator and kmalloc() anyway.

 - or NUMA_BALANCING's page->_last_cpupid can be 0 as well, as these
   pages aren't (normally) NUMA-migrated.

The extended fields would have to be accessed via small wrappers, 
which return 0 if the extended part is not present, but that's pretty 
much all.

> I don't think we could have persistent struct page entries, as the 
> exact contents of the struct page entries is too volatile and too 
> different between architectures. [...]

Especially with the 2MB (and 1GB) granular lazy initialization 
approach persisting them across reboots does not seem necessary 
either.

Even main RAM is already doing lazy initialization: Mel's patches that 
do that just went into -mm.

> [...] Especially architecture changes that a pmem store is likely to 
> see such as switching between a 32bit and a 64bit kernel.

We'd not want to ABI-restrict the layout of struct page. But to say 
that there's a core 64-byte descriptor per 4K page is not an overly 
strict promise to keep.

> Further I think where in the persistent memory the struct page 
> arrays live is something we could leave up to the filesystem.  We 
> could have some reasonable constraints to make it fast but I think 
> whoever decides where things live on the persistent memory can make 
> that choice.

So the beauty of the scheme is that in its initial incarnation it's 
filesystem independent: you can create any filesystem on top of it 
seemlessly, the filesystem simply sees a linear block device that is 
1.5% smaller than the underlying storage. It won't even (normally) 
have access to the struct page areas. This kind of data space 
separation also protects against filesystem originated data 
corruption.

Now in theory a filesystem might be aware of it, but I think it's far 
more important to keep this scheme simple, robust, fast and 
predictable.

> For small persistent memories it probably make sense to allocate the 
> struct page array describing them out of ordinary ram.  For small 
> memories I don't think we are talking enough memory to worry about. 
> For TB+ persistent memories where you need 16GiB per TiB it makes 
> sense to allocate a one or several regions to store your struct page 
> arrays, as you can't count on ordinary ram having enough capacity, 
> and you may not even be talking about a system that actually has 
> ordinary ram at that point.

Correct - if there's no ordinary page cache in main DRAM then for many 
appliances ordinary RAM could be something like SRAM: really fast and 
not wasted on dirty state and IO caches - a huge, directly mapped L4 
or L5 CPU cache in essence.

Thanks,

	Ingo
