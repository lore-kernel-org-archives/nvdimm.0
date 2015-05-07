Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 7 May 2015 21:11:07 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
Message-ID: <20150507191107.GB22952@gmail.com>
References: <CAPcyv4g=pWqWaU5eceaMYi+W4+JqS=dhwgsK5s+b1B-p4hv2PA@mail.gmail.com>
 <CA+55aFza6YzfPqy9pi+up-q5FC9Z2WjLkGoX4F6ZCSUYE-2a+Q@mail.gmail.com>
 <CAPcyv4ic-NY4KEtVknDQEdbF243aqdWdei2kTnn_tcw=7fUYyQ@mail.gmail.com>
 <CA+55aFwL321_xxcXwj5+G7q=rc8HmqMBpot5dK_AW2=-7xOn0g@mail.gmail.com>
 <CAPcyv4iY+2SKqSxNijhzgwBMDAbcd01kzWrVnW06yqtOinoSQg@mail.gmail.com>
 <CA+55aFyK==+bMHMdfaP4EHjUNseoTWu1-pp2M2WyLVN73ig+_g@mail.gmail.com>
 <CAPcyv4i5957h0PW5JL0rv4iurL=c7ppEFj3cDrrrMc4MQmJQGQ@mail.gmail.com>
 <20150507173641.GA21781@gmail.com>
 <CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com>
 <554BA748.9030804@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <554BA748.9030804@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Rik van Riel <riel@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


* Dave Hansen <dave.hansen@linux.intel.com> wrote:

> On 05/07/2015 10:42 AM, Dan Williams wrote:
> > On Thu, May 7, 2015 at 10:36 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >> * Dan Williams <dan.j.williams@intel.com> wrote:
> >>
> >> So is there anything fundamentally wrong about creating struct 
> >> page backing at mmap() time (and making sure aliased mmaps share 
> >> struct page arrays)?
> > 
> > Something like "get_user_pages() triggers memory hotplug for 
> > persistent memory", so they are actual real struct pages?  Can we 
> > do memory hotplug at that granularity?
> 
> We've traditionally limited them to SECTION_SIZE granularity, which 
> is 128MB IIRC.  There are also assumptions in places that you can do 
> page++ within a MAX_ORDER block if !CONFIG_HOLES_IN_ZONE.

I really don't think that's very practical: memory hotplug is slow, 
it's really not on the same abstraction level as mmap(), and the zone 
data structures are also fundamentally very coarse: not just because 
RAM ranges are huge, but also so that the pfn->page transformation 
stays relatively simple and fast.

> But, in all practicality, a lot of those places are in code like the 
> buddy allocator.  If your PTEs all have _PAGE_SPECIAL set and we're 
> not ever expecting these fake 'struct page's to hit these code 
> paths, it probably doesn't matter.
> 
> You can probably get away with just allocating PAGE_SIZE worth of 
> 'struct page' (which is 64) and mapping it in to vmemmap[].  The 
> worst case is that you'll eat 1 page of space for each outstanding 
> page of I/O.  That's a lot better than 2MB of temporary 'struct 
> page' space per page of I/O that it would take with a traditional 
> hotplug operation.

So I think the main value of struct page is if everyone on the system 
sees the same struct page for the same pfn - not just the temporary IO 
instance.

The idea of having very temporary struct page arrays misses the point 
I think: if struct page is used as essentially an IO sglist then most 
of the synchronization properties are lost: then we might as well use 
the real deal in that case and skip the dynamic allocation and use 
pfns directly and avoid the dynamic allocation overhead.

Stable, global page-struct descriptors are a given for real RAM, where 
we allocate a struct page for every page in nice, large, mostly linear 
arrays.

We'd really need that for pmem too, to get the full power of struct 
page: and that means allocating them in nice, large, predictable 
places - such as on the device itself ...

It might even be 'scattered' across the device, with 64 byte struct 
page size we can pack 64 descriptors into a single page, so every 65 
pages we could have a page-struct page.

Finding a pmem page's struct page would thus involve rounding it 
modulo 65 and reading that page.

The problem with that is fourfold:

 - that we now turn a very kernel internal API and data structure into 
   an ABI. If struct page grows beyond 64 bytes it's a problem.

 - on bootup (or device discovery time) we'd have to initialize all 
   the page structs. We could probably do this in a hierarchical way, 
   by dividing continuous pmem ranges into power-of-two groups of 
   blocks, and organizing them like the buddy allocator does.

 - 1.5% of storage space lost.

 - will wear-leveling properly migrate these 'hot' pages around?

The alternative would be some global interval-rbtree of struct page 
backed pmem ranges.

Beyond the synchronization problems of such a data structure (which 
looks like a nightmare) I don't think it's even feasible: especially 
if there's a filesystem on the pmem device then the block allocations 
could be physically fragmented (and there's no fundamental reason why 
they couldn't be fragmented), so a continuous mmap() of a file on it 
will yield wildly fragmented device-pfn ranges, exploding the rbtree. 
Think 1 million node interval-rbtree with an average depth of 20: 
cachemiss country for even simple lookups - not to mention the 
freeing/recycling complexity of unused struct pages to not allow it to 
grow too large.

I might be wrong though about all this :)

Thanks,

	Ingo
