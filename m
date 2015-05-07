Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CA+55aFwL321_xxcXwj5+G7q=rc8HmqMBpot5dK_AW2=-7xOn0g@mail.gmail.com>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
	<CA+55aFzON9617c2_Amep0ngLq91kfrPiSccdZakxir82iekUiA@mail.gmail.com>
	<CAPcyv4g=pWqWaU5eceaMYi+W4+JqS=dhwgsK5s+b1B-p4hv2PA@mail.gmail.com>
	<CA+55aFza6YzfPqy9pi+up-q5FC9Z2WjLkGoX4F6ZCSUYE-2a+Q@mail.gmail.com>
	<CAPcyv4ic-NY4KEtVknDQEdbF243aqdWdei2kTnn_tcw=7fUYyQ@mail.gmail.com>
	<CA+55aFwL321_xxcXwj5+G7q=rc8HmqMBpot5dK_AW2=-7xOn0g@mail.gmail.com>
Date: Thu, 7 May 2015 08:40:33 -0700
Message-ID: <CAPcyv4iY+2SKqSxNijhzgwBMDAbcd01kzWrVnW06yqtOinoSQg@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Rik van Riel <riel@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 7, 2015 at 8:00 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, May 6, 2015 at 7:36 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> My pet concrete example is covered by __pfn_t.  Referencing persistent
>> memory in an md/dm hierarchical storage configuration.  Setting aside
>> the thrash to get existing block users to do "bvec_set_page(page)"
>> instead of "bvec->page = page" the onus is on that md/dm
>> implementation and backing storage device driver to operate on
>> __pfn_t.  That use case is simple because there is no use of page
>> locking or refcounting in that path, just dma_map_page() and
>> kmap_atomic().
>
> So clarify for me: are you trying to make the IO stack in general be
> able to use the persistent memory as a source (or destination) for IO
> to _other_ devices, or are you talking about just internally shuffling
> things around for something like RAID on top of persistent memory?
>
> Because I think those are two very different things.

Yes, they are, and I am referring to the former, persistent memory as
a source/destination to other devices.

> For example, one of the things I worry about is for people doing IO
> from persistent memory directly to some "slow stable storage" (aka
> disk). That was what I thought you were aiming for: infrastructure so
> that you can make a bio for a *disk* device contain a page list that
> is the persistent memory.
>
> And I think that is a very dangerous operation to do, because the
> persistent memory itself is going to have some filesystem on it, so
> anything that looks up the persistent memory pages is *not* going to
> have a stable pfn: the pfn will point to a fixed part of the
> persistent memory, but the file that was there may be deleted and the
> memory reassigned to something else.

Indeed, truncate() in the absence of struct page has been a major
hurdle for persistent memory enabling.  But it does not impact this
specific md/dm use case.  md/dm will have taken an exclusive claim on
an entire pmem block device (or partition), so there will be no
competing with a filesystem.

> That's the kind of thing that "struct page" helps with for normal IO
> devices. It's both a source of serialization and indirection, so that
> when somebody does a "truncate()" on a file, we don't end up doing IO
> to random stale locations on the disk that got reassigned to another
> file.
>
> So "struct page" is very fundamental. It's *not* just a "this is the
> physical source/drain of the data you are doing IO on".
>
> So if you are looking at some kind of "zero-copy IO", where you can do
> IO from a filesystem on persistent storage to *another* filesystem on
> (say, a big rotational disk used for long-term storage) by just doing
> a bo that targets the disk, but has the persistent memory as the
> source memory, I really want to understand how you are going to
> serialize this.
>
> So *that* is what I meant by "What is the primary thing that is
> driving this need? Do we have a very concrete example?"
>
> I abvsolutely do *not* want to teach the bio subsystem to just
> randomly be able to take the source/destination of the IO as being
> some random pfn without knowing what the actual uses are and how these
> IO's are generated in the first place.

blkdev_get(FMODE_EXCL) is the protection in this case.

> I was assuming that you wanted to do something where you mmap() the
> persistent memory, and then write it out to another device (possibly
> using aio_write()). But that really does require some kind of
> serialization at a higher level, because you can't just look up the
> pfn's in the page table and assume they are stable: they are *not*
> stable.

We want to get there eventually, but this patchset does not address that case.
