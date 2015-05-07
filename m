Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 7 May 2015 21:48:32 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
Message-ID: <20150507194832.GB23511@gmail.com>
References: <CAPcyv4ic-NY4KEtVknDQEdbF243aqdWdei2kTnn_tcw=7fUYyQ@mail.gmail.com>
 <CA+55aFwL321_xxcXwj5+G7q=rc8HmqMBpot5dK_AW2=-7xOn0g@mail.gmail.com>
 <CAPcyv4iY+2SKqSxNijhzgwBMDAbcd01kzWrVnW06yqtOinoSQg@mail.gmail.com>
 <CA+55aFyK==+bMHMdfaP4EHjUNseoTWu1-pp2M2WyLVN73ig+_g@mail.gmail.com>
 <CAPcyv4i5957h0PW5JL0rv4iurL=c7ppEFj3cDrrrMc4MQmJQGQ@mail.gmail.com>
 <20150507173641.GA21781@gmail.com>
 <CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com>
 <554BA748.9030804@linux.intel.com>
 <20150507191107.GB22952@gmail.com>
 <20150507193635.GC5966@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150507193635.GC5966@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Rik van Riel <riel@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, paulmck@linux.vnet.ibm.com
List-ID: <linux-nvdimm@lists.01.org>


* Jerome Glisse <j.glisse@gmail.com> wrote:

> > So I think the main value of struct page is if everyone on the 
> > system sees the same struct page for the same pfn - not just the 
> > temporary IO instance.
> > 
> > The idea of having very temporary struct page arrays misses the 
> > point I think: if struct page is used as essentially an IO sglist 
> > then most of the synchronization properties are lost: then we 
> > might as well use the real deal in that case and skip the dynamic 
> > allocation and use pfns directly and avoid the dynamic allocation 
> > overhead.
> > 
> > Stable, global page-struct descriptors are a given for real RAM, 
> > where we allocate a struct page for every page in nice, large, 
> > mostly linear arrays.
> > 
> > We'd really need that for pmem too, to get the full power of 
> > struct page: and that means allocating them in nice, large, 
> > predictable places - such as on the device itself ...
> 
> Is handling kernel pagefault on the vmemmap completely out of the 
> picture ? So we would carveout a chunck of kernel address space for 
> those pfn and use it for vmemmap and handle pagefault on it.

That's pretty clever. The page fault doesn't even have to do remote 
TLB shootdown, because it only establishes mappings - so it's pretty 
atomic, a bit like the minor vmalloc() area faults we are doing.

Some sort of LRA (least recently allocated) scheme could unmap the 
area in chunks if it's beyond a certain size, to keep a limit on size. 
Done from the same context and would use remote TLB shootdown.

The only limitation I can see is that such faults would have to be 
able to sleep, to do the allocation. So pfn_to_page() could not be 
used in arbitrary contexts.

> Again here i think that GPU folks would like a solution where they 
> can have a page struct but it would not be PMEM just device memory. 
> So if we can come up with something generic enough to server both 
> purpose that would be better in my view.

Yes.

Thanks,

	Ingo
