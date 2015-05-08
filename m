Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <554CBE17.4070904@redhat.com>
Date: Fri, 08 May 2015 09:45:59 -0400
From: Rik van Riel <riel@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer, introduce
 __pfn_t
References: <CAPcyv4g=pWqWaU5eceaMYi+W4+JqS=dhwgsK5s+b1B-p4hv2PA@mail.gmail.com> <CA+55aFza6YzfPqy9pi+up-q5FC9Z2WjLkGoX4F6ZCSUYE-2a+Q@mail.gmail.com> <CAPcyv4ic-NY4KEtVknDQEdbF243aqdWdei2kTnn_tcw=7fUYyQ@mail.gmail.com> <CA+55aFwL321_xxcXwj5+G7q=rc8HmqMBpot5dK_AW2=-7xOn0g@mail.gmail.com> <CAPcyv4iY+2SKqSxNijhzgwBMDAbcd01kzWrVnW06yqtOinoSQg@mail.gmail.com> <CA+55aFyK==+bMHMdfaP4EHjUNseoTWu1-pp2M2WyLVN73ig+_g@mail.gmail.com> <CAPcyv4i5957h0PW5JL0rv4iurL=c7ppEFj3cDrrrMc4MQmJQGQ@mail.gmail.com> <20150507173641.GA21781@gmail.com> <CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com> <554BA748.9030804@linux.intel.com> <20150507191107.GB22952@gmail.com>
In-Reply-To: <20150507191107.GB22952@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 05/07/2015 03:11 PM, Ingo Molnar wrote:

> Stable, global page-struct descriptors are a given for real RAM, where 
> we allocate a struct page for every page in nice, large, mostly linear 
> arrays.
> 
> We'd really need that for pmem too, to get the full power of struct 
> page: and that means allocating them in nice, large, predictable 
> places - such as on the device itself ...
> 
> It might even be 'scattered' across the device, with 64 byte struct 
> page size we can pack 64 descriptors into a single page, so every 65 
> pages we could have a page-struct page.
> 
> Finding a pmem page's struct page would thus involve rounding it 
> modulo 65 and reading that page.
> 
> The problem with that is fourfold:
> 
>  - that we now turn a very kernel internal API and data structure into 
>    an ABI. If struct page grows beyond 64 bytes it's a problem.
> 
>  - on bootup (or device discovery time) we'd have to initialize all 
>    the page structs. We could probably do this in a hierarchical way, 
>    by dividing continuous pmem ranges into power-of-two groups of 
>    blocks, and organizing them like the buddy allocator does.
> 
>  - 1.5% of storage space lost.
> 
>  - will wear-leveling properly migrate these 'hot' pages around?

MST and I have been doing some thinking about how to address some of
the issues above.

One way could be to invert the PG_compound logic we have today, by
allocating one struct page for every PMD / THP sized area (2MB on
x86), and dynamically allocating struct pages for the 4kB pages
inside only if the area gets split. They can be freed again when
the area is not being accessed in 4kB chunks.

That way we would always look at the struct page for the 2MB area
first, and if the PG_split bit is set, we look at the array of
dynamically allocated struct pages for this area.

The advantages are obvious: boot time memory overhead and
initialization time are reduced by a factor 512. CPUs could also
take a whole 2MB area in order to do CPU-local 4kB allocations,
defragmentation policies may become a little clearer, etc...

The disadvantage is pretty obvious too: 4kB pages would no longer
be the fast case, with an indirection. I do not know how much of
an issue that would be, or whether it even makes sense for 4kB
pages to continue being the fast case going forward.

Memory trends point in one direction, file size trends in another.

For persistent memory, we would not need 4kB page struct pages unless
memory from a particular area was in small files AND those files were
being actively accessed. Large files (mapped in 2MB chunks) or inactive
small files would not need the 4kB page structs around.

-- 
All rights reversed
