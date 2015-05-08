Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150506200505.40425.22693.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150506200505.40425.22693.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Fri, 8 May 2015 08:59:10 -0700
Message-ID: <CAPcyv4h0zVb6HV89=AhST+o3Ckabxv+p+p4M1Us5A1oigSp4VQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/10] block: add helpers for accessing a bio_vec page
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <boaz@plexistor.com>, Rik van Riel <riel@redhat.com>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Chris Mason <clm@fb.com>, Neil Brown <neilb@suse.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Julia Lawall <Julia.Lawall@lip6.fr>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 6, 2015 at 1:05 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> In preparation for converting struct bio_vec to carry a __pfn_t instead
> of struct page.
>
> This change is prompted by the desire to add in-kernel DMA support
> (O_DIRECT, hierarchical storage, RDMA, etc) for persistent memory which
> lacks struct page coverage.
>
> Alternatives:
>
> 1/ Provide struct page coverage for persistent memory in DRAM.  The
>    expectation is that persistent memory capacities make this untenable
>    in the long term.
>
> 2/ Provide struct page coverage for persistent memory with persistent
>    memory.  While persistent memory may have near DRAM performance
>    characteristics it may not have the same write-endurance of DRAM.
>    Given the update frequency of struct page objects it may not be
>    suitable for persistent memory.
>
> 3/ Dynamically allocate struct page.  This appears to be on the order
>    of the complexity of converting code paths to use __pfn_t references
>    instead of struct page, and the amount of setup required to establish
>    a valid struct page reference is mostly wasted when the only usage in
>    the block stack is to perform a page_to_pfn() conversion for
>    dma-mapping.  Instances of kmap() / kmap_atomic() usage appear to be
>    the only occasions in the block stack where struct page is
>    non-trivially used.  A new kmap_atomic_pfn_t() is proposed to handle
>    those cases.
>
> Generated with the following semantic patch:
>
> // bv_page.cocci: convert usage of ->bv_page to use set/get helpers
> // usage: make coccicheck COCCI=bv_page.cocci MODE=patch

Now that it looks like this patchset can move forward, what do about
this one?  Run the Coccinelle script late in the merge window to catch
all the new bv_page usages targeted for 4.2-rc1?
