Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Wed, 6 May 2015 15:10:07 -0700
Message-ID: <CA+55aFzON9617c2_Amep0ngLq91kfrPiSccdZakxir82iekUiA@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Rik van Riel <riel@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 6, 2015 at 1:04 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>
> The motivation for this change is persistent memory and the desire to
> use it not only via the pmem driver, but also as a memory target for I/O
> (DAX, O_DIRECT, DMA, RDMA, etc) in other parts of the kernel.

I detest this approach.

I'd much rather go exactly the other way around, and do the dynamic
"struct page" instead.

Add a flag to "struct page" to mark it as a fake entry and teach
"page_to_pfn()" to look up the actual pfn some way (that union tha
contains "index" looks like a good target to also contain 'pfn', for
example).

Especially if this is mainly for persistent storage, we'll never have
issues with worrying about writing it back under memory pressure, so
allocating a "struct page" for these things shouldn't be a problem.
There's likely only a few paths that actually generate IO for those
things.

In other words, I'd really like our basic infrastructure to be for the
*normal* case, and the "struct page" is about so much more than just
"what's the target for IO". For normal IO, "struct page" is also what
serializes the IO so that you have a consistent view of the end
result, and there's obviously the reference count there too. So I
really *really* think that "struct page" is the better entity for
describing the actual IO, because it's the common and the generic
thing, while a "pfn" is not actually *enough* for IO in general, and
you now end up having to look up the "struct page" for the locking and
refcounting etc.

If you go the other way, and instead generate a "struct page" from the
pfn for the few cases that need it, you put the onus on odd behavior
where it belongs.

Yes, it might not be any simpler in the end, but I think it would be
conceptually much better.

                    Linus
