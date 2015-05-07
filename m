Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CA+55aFza6YzfPqy9pi+up-q5FC9Z2WjLkGoX4F6ZCSUYE-2a+Q@mail.gmail.com>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
	<CA+55aFzON9617c2_Amep0ngLq91kfrPiSccdZakxir82iekUiA@mail.gmail.com>
	<CAPcyv4g=pWqWaU5eceaMYi+W4+JqS=dhwgsK5s+b1B-p4hv2PA@mail.gmail.com>
	<CA+55aFza6YzfPqy9pi+up-q5FC9Z2WjLkGoX4F6ZCSUYE-2a+Q@mail.gmail.com>
Date: Wed, 6 May 2015 19:36:13 -0700
Message-ID: <CAPcyv4ic-NY4KEtVknDQEdbF243aqdWdei2kTnn_tcw=7fUYyQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Rik van Riel <riel@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 6, 2015 at 5:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, May 6, 2015 at 4:47 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> Conceptually better, but certainly more difficult to audit if the fake
>> struct page is initialized in a subtle way that breaks when/if it
>> leaks to some unwitting context.
>
> Maybe. It could go either way, though. In particular, with the
> "dynamically allocated struct page" approach, if somebody uses it past
> the supposed lifetime of the use, things like poisoning the temporary
> "struct page" could be fairly effective. You can't really poison the
> pfn - it's just a number, and if somebody uses it later than you think
> (and you have re-used that physical memory for something else), you'll
> never ever know.

True, but there's little need to poison a _pfn_t because it's
permanent once discovered via ->direct_access() on the hosting struct
block_device.  Sure, kmap_atomic_pfn_t() may fail when the pmem driver
unbinds from a device, but the __pfn_t is still valid.  Obviously, we
can only support atomic kmap(s) with this property, and it would be
nice to fault if someone continued to use the __pfn_t after the
hosting device was disabled.  To be clear, DAX has this same problem
today.  Nothing stops whomever called ->direct_access() to continue
using the pfn after the backing device has been disabled.

> I'd *assume* that most users of the dynamic "struct page" allocation
> have very clear lifetime rules. Those things would presumably normally
> get looked-up by some extended version of "get_user_pages()", and
> there's a clear use of the result, with no longer lifetime. Also, you
> do need to have some higher-level locking when you  do this, to make
> sure that the persistent pages don't magically get re-assigned. We're
> presumably talking about having a filesystem in that persistent
> memory, so we cannot be doing IO to the pages (from some other source
> - whether RDMA or some special zero-copy model) while the underlying
> filesystem is reassigning the storage because somebody deleted the
> file.
>
> IOW, there had better be other external rules about when - and how
> long - you can use a particular persistent page. No? So the whole
> "when/how to allocate the temporary 'struct page'" is just another
> detail in that whole thing.
>
> And yes, some uses may not ever actually see that. If the whole of
> persistent memory is just assigned to a database or something, and the
> DB just wants to do a "flush this range of persistent memory to
> long-term disk storage", then there may not be much of a "lifetime"
> issue for the persistent memory. But even then you're going to have IO
> completion callbacks etc to let the DB know that it has hit the disk,
> so..
>
> What is the primary thing that is driving this need? Do we have a very
> concrete example?

My pet concrete example is covered by __pfn_t.  Referencing persistent
memory in an md/dm hierarchical storage configuration.  Setting aside
the thrash to get existing block users to do "bvec_set_page(page)"
instead of "bvec->page = page" the onus is on that md/dm
implementation and backing storage device driver to operate on
__pfn_t.  That use case is simple because there is no use of page
locking or refcounting in that path, just dma_map_page() and
kmap_atomic().  The more difficult use case is precisely what Al
picked up on, O_DIRECT and RDMA.  This patchset does nothing to
address those use cases outside of not needing a struct page when they
eventually craft a bio.

I know Matthew Wilcox has explored the idea of "get_user_sg()" and let
the scatterlist hold the reference count and locks, but I'll let him
speak to that.

I still see __pfn_t as generally useful for the simple in-kernel
stacked-block-i/o use case.
