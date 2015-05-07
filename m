Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150507144225.GA20491@gmail.com>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
	<CA+55aFzON9617c2_Amep0ngLq91kfrPiSccdZakxir82iekUiA@mail.gmail.com>
	<CAPcyv4g=pWqWaU5eceaMYi+W4+JqS=dhwgsK5s+b1B-p4hv2PA@mail.gmail.com>
	<CA+55aFza6YzfPqy9pi+up-q5FC9Z2WjLkGoX4F6ZCSUYE-2a+Q@mail.gmail.com>
	<CAPcyv4ic-NY4KEtVknDQEdbF243aqdWdei2kTnn_tcw=7fUYyQ@mail.gmail.com>
	<20150507090217.GA4467@gmail.com>
	<20150507144225.GA20491@gmail.com>
Date: Thu, 7 May 2015 08:52:15 -0700
Message-ID: <CAPcyv4jHUMFP4qif0UtY+2pO35vvz_qALLmM=bd9cw3vArK-PQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Rik van Riel <riel@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 7, 2015 at 7:42 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Ingo Molnar <mingo@kernel.org> wrote:
>
>> [...]
>>
>> For anything more complex, that maps any of this storage to
>> user-space, or exposes it to higher level struct page based APIs,
>> etc., where references matter and it's more of a cache with
>> potentially multiple users, not an IO space, the natural API is
>> struct page.
>
> Let me walk back on this:
>
>> I'd say that this particular series mostly addresses the 'pfn as
>> sector_t' side of the equation, where persistent memory is IO space,
>> not memory space, and as such it is the more natural and thus also
>> the cheaper/faster approach.
>
> ... but that does not appear to be the case: this series replaces a
> 'struct page' interface with a pure pfn interface for the express
> purpose of being able to DMA to/from 'memory areas' that are not
> struct page backed.
>
>> Linus probably disagrees? :-)
>
> [ and he'd disagree rightfully ;-) ]
>
> So what this patch set tries to achieve is (sector_t -> sector_t) IO
> between storage devices (i.e. a rare and somewhat weird usecase), and
> does it by squeezing one device's storage address into our formerly
> struct page backed descriptor, via a pfn.
>
> That looks like a layering violation and a mistake to me. If we want
> to do direct (sector_t -> sector_t) IO, with no serialization worries,
> it should have its own (simple) API - which things like hierarchical
> RAID or RDMA APIs could use.

I'm wrapped around the idea that __pfn_t *is* that simple api for the
tiered storage driver use case.  For RDMA I think we need struct page
because I assume that would be coordinated through a filesystem an
truncate() is back in play.

What does an alternative API look like?

> If what we want to do is to support say an mmap() of a file on
> persistent storage, and then read() into that file from another device
> via DMA, then I think we should have allocated struct page backing at
> mmap() time already, and all regular syscall APIs would 'just work'
> from that point on - far above what page-less, pfn-based APIs can do.
>
> The temporary struct page backing can then be freed at munmap() time.

Yes, passing around mmap()'d (DAX) persistent memory will need more
than a __pfn_t.
