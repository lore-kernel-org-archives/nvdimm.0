Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 7 May 2015 19:52:30 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
Message-ID: <20150507175230.GB21781@gmail.com>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzON9617c2_Amep0ngLq91kfrPiSccdZakxir82iekUiA@mail.gmail.com>
 <CAPcyv4g=pWqWaU5eceaMYi+W4+JqS=dhwgsK5s+b1B-p4hv2PA@mail.gmail.com>
 <CA+55aFza6YzfPqy9pi+up-q5FC9Z2WjLkGoX4F6ZCSUYE-2a+Q@mail.gmail.com>
 <CAPcyv4ic-NY4KEtVknDQEdbF243aqdWdei2kTnn_tcw=7fUYyQ@mail.gmail.com>
 <20150507090217.GA4467@gmail.com>
 <20150507144225.GA20491@gmail.com>
 <CAPcyv4jHUMFP4qif0UtY+2pO35vvz_qALLmM=bd9cw3vArK-PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jHUMFP4qif0UtY+2pO35vvz_qALLmM=bd9cw3vArK-PQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Rik van Riel <riel@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


* Dan Williams <dan.j.williams@intel.com> wrote:

> > That looks like a layering violation and a mistake to me. If we 
> > want to do direct (sector_t -> sector_t) IO, with no serialization 
> > worries, it should have its own (simple) API - which things like 
> > hierarchical RAID or RDMA APIs could use.
> 
> I'm wrapped around the idea that __pfn_t *is* that simple api for 
> the tiered storage driver use case. [...]

I agree. (see my previous mail)

> [...] For RDMA I think we need struct page because I assume that 
> would be coordinated through a filesystem an truncate() is back in 
> play.

So I don't think RDMA is necessarily special, it's just a weirdly 
programmed DMA request:

 - If it is used internally by an exclusively managed complex storage
   driver, then it can use low level block APIs and pfn_t.

 - If RDMA is exposed all the way to user-space (do we have such 
   APIs?), allowing users to initiate RDMA IO into user buffers, then 
   (the user visible) buffer needs struct page backing. (which in turn 
   will then at some lower level convert to pfns.)

   That's true for both regular RAM pages and mmap()-ed persistent RAM 
   pages as well.

Thanks,

	Ingo
