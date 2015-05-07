Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 7 May 2015 11:02:17 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
Message-ID: <20150507090217.GA4467@gmail.com>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzON9617c2_Amep0ngLq91kfrPiSccdZakxir82iekUiA@mail.gmail.com>
 <CAPcyv4g=pWqWaU5eceaMYi+W4+JqS=dhwgsK5s+b1B-p4hv2PA@mail.gmail.com>
 <CA+55aFza6YzfPqy9pi+up-q5FC9Z2WjLkGoX4F6ZCSUYE-2a+Q@mail.gmail.com>
 <CAPcyv4ic-NY4KEtVknDQEdbF243aqdWdei2kTnn_tcw=7fUYyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4ic-NY4KEtVknDQEdbF243aqdWdei2kTnn_tcw=7fUYyQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Rik van Riel <riel@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


* Dan Williams <dan.j.williams@intel.com> wrote:

> > What is the primary thing that is driving this need? Do we have a 
> > very concrete example?
> 
> My pet concrete example is covered by __pfn_t.  Referencing 
> persistent memory in an md/dm hierarchical storage configuration.  
> Setting aside the thrash to get existing block users to do 
> "bvec_set_page(page)" instead of "bvec->page = page" the onus is on 
> that md/dm implementation and backing storage device driver to 
> operate on __pfn_t.  That use case is simple because there is no use 
> of page locking or refcounting in that path, just dma_map_page() and 
> kmap_atomic().  The more difficult use case is precisely what Al 
> picked up on, O_DIRECT and RDMA.  This patchset does nothing to 
> address those use cases outside of not needing a struct page when 
> they eventually craft a bio.

So why not do a dual approach?

There are code paths where the 'pfn' of a persistent device is mostly 
used as a sector_t equivalent of terabytes of storage, not as an index 
of a memory object.

It's not an address to a cache, it's an index into a huge storage 
space - which happens to be (flash) RAM. For them using pfn_t seems 
natural and using struct page * is a strained (not to mention 
expensive) model.

For more complex facilities, where persistent memory is used as a 
memory object, especially where the underlying device is true, 
unfinitely writable RAM (not flash), treating it as a memory zone, or 
setting up dynamic struct page would be the natural approach. (with 
the inevitable cost of setup/teardown in the latter case)

I'd say that for anything where the dynamic struct page is torn down 
unconditionally after completion of only a single use, the natural API 
is probably pfn_t, not struct page. Any synchronization is already 
handled at the block request layer already, and it's storage op 
synchronization, not memory access synchronization really.

For anything more complex, that maps any of this storage to 
user-space, or exposes it to higher level struct page based APIs, 
etc., where references matter and it's more of a cache with 
potentially multiple users, not an IO space, the natural API is struct 
page.

I'd say that this particular series mostly addresses the 'pfn as 
sector_t' side of the equation, where persistent memory is IO space, 
not memory space, and as such it is the more natural and thus also the 
cheaper/faster approach.

Linus probably disagrees? :-)

Thanks,

	Ingo
