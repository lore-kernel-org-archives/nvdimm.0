Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 7 May 2015 15:36:37 -0400
From: Jerome Glisse <j.glisse@gmail.com>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
Message-ID: <20150507193635.GC5966@gmail.com>
References: <CA+55aFza6YzfPqy9pi+up-q5FC9Z2WjLkGoX4F6ZCSUYE-2a+Q@mail.gmail.com>
 <CAPcyv4ic-NY4KEtVknDQEdbF243aqdWdei2kTnn_tcw=7fUYyQ@mail.gmail.com>
 <CA+55aFwL321_xxcXwj5+G7q=rc8HmqMBpot5dK_AW2=-7xOn0g@mail.gmail.com>
 <CAPcyv4iY+2SKqSxNijhzgwBMDAbcd01kzWrVnW06yqtOinoSQg@mail.gmail.com>
 <CA+55aFyK==+bMHMdfaP4EHjUNseoTWu1-pp2M2WyLVN73ig+_g@mail.gmail.com>
 <CAPcyv4i5957h0PW5JL0rv4iurL=c7ppEFj3cDrrrMc4MQmJQGQ@mail.gmail.com>
 <20150507173641.GA21781@gmail.com>
 <CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com>
 <554BA748.9030804@linux.intel.com>
 <20150507191107.GB22952@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150507191107.GB22952@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Rik van Riel <riel@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, paulmck@linux.vnet.ibm.com
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 07, 2015 at 09:11:07PM +0200, Ingo Molnar wrote:
> 
> * Dave Hansen <dave.hansen@linux.intel.com> wrote:
> 
> > On 05/07/2015 10:42 AM, Dan Williams wrote:
> > > On Thu, May 7, 2015 at 10:36 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > >> * Dan Williams <dan.j.williams@intel.com> wrote:
> > >>
> > >> So is there anything fundamentally wrong about creating struct 
> > >> page backing at mmap() time (and making sure aliased mmaps share 
> > >> struct page arrays)?
> > > 
> > > Something like "get_user_pages() triggers memory hotplug for 
> > > persistent memory", so they are actual real struct pages?  Can we 
> > > do memory hotplug at that granularity?
> > 
> > We've traditionally limited them to SECTION_SIZE granularity, which 
> > is 128MB IIRC.  There are also assumptions in places that you can do 
> > page++ within a MAX_ORDER block if !CONFIG_HOLES_IN_ZONE.
> 
> I really don't think that's very practical: memory hotplug is slow, 
> it's really not on the same abstraction level as mmap(), and the zone 
> data structures are also fundamentally very coarse: not just because 
> RAM ranges are huge, but also so that the pfn->page transformation 
> stays relatively simple and fast.
> 
> > But, in all practicality, a lot of those places are in code like the 
> > buddy allocator.  If your PTEs all have _PAGE_SPECIAL set and we're 
> > not ever expecting these fake 'struct page's to hit these code 
> > paths, it probably doesn't matter.
> > 
> > You can probably get away with just allocating PAGE_SIZE worth of 
> > 'struct page' (which is 64) and mapping it in to vmemmap[].  The 
> > worst case is that you'll eat 1 page of space for each outstanding 
> > page of I/O.  That's a lot better than 2MB of temporary 'struct 
> > page' space per page of I/O that it would take with a traditional 
> > hotplug operation.
> 
> So I think the main value of struct page is if everyone on the system 
> sees the same struct page for the same pfn - not just the temporary IO 
> instance.
> 
> The idea of having very temporary struct page arrays misses the point 
> I think: if struct page is used as essentially an IO sglist then most 
> of the synchronization properties are lost: then we might as well use 
> the real deal in that case and skip the dynamic allocation and use 
> pfns directly and avoid the dynamic allocation overhead.
> 
> Stable, global page-struct descriptors are a given for real RAM, where 
> we allocate a struct page for every page in nice, large, mostly linear 
> arrays.
> 
> We'd really need that for pmem too, to get the full power of struct 
> page: and that means allocating them in nice, large, predictable 
> places - such as on the device itself ...

Is handling kernel pagefault on the vmemmap completely out of the
picture ? So we would carveout a chunck of kernel address space for
those pfn and use it for vmemmap and handle pagefault on it.

Again here i think that GPU folks would like a solution where they can
have a page struct but it would not be PMEM just device memory. So if
we can come up with something generic enough to server both purpose
that would be better in my view.

Cheers,
J�r�me
