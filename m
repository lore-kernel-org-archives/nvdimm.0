Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1426113739.18821.2.camel@theros.lm.intel.com>
Subject: Re: [PATCH] brd: Ensure that bio_vecs have size <= PAGE_SIZE
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Wed, 11 Mar 2015 16:42:19 -0600
In-Reply-To: <550078AB.5030203@plexistor.com>
References: <1426093353-23709-1-git-send-email-ross.zwisler@linux.intel.com>
	 <550078AB.5030203@plexistor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: linux-kernel@vger.kernel.org, "Roger C. Pao (Enmotus)" <rcpao.enmotus@gmail.com>, linux-nvdimm@lists.01.org, Nick Piggin <npiggin@kernel.dk>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2015-03-11 at 19:17 +0200, Boaz Harrosh wrote:
> On 03/11/2015 07:02 PM, Ross Zwisler wrote:
> > The functions copy_from_brd() and copy_to_brd() are written with an
> > assumption that the bio_vec they are given has size <= PAGE_SIZE.  This
> > assumption is not enforced in any way, and if the bio_vec has size
> > larger than PAGE_SIZE data will just be lost.
> > 
> > Such a situation can occur with I/Os generated from in-kernel sources,
> > or with coalesced bio_vecs.  
> 
> I wish you could show me where in Kernel this can happen.
> who "coalesced bio_vecs" ? what Kernel sources generate bio->b_size > PAGE_SIZE ?
> I did try to look and could not find any. Sorry for my slowness.

In truth I'm not certain I know of a place either. :)  In part I'm quoting the
original bug report:

https://lists.01.org/pipermail/linux-nvdimm/2015-February/000079.html

The pertinent lines, in case you don't want to follow the link:

" The biovec can present a size greater that PAGE_SIZE if an I/O buffer
  contains physically contiguous pages.  This may be unusual for user space
  pages, as the virtual to physical memory map gets fragmented.  But for
  buffers allocated by the kernel with kmalloc, physical memory will be
  contiguous.

  Even if a single I/O request does not contain two contiguous pages, the
  block layer may merge two requests that have contiguous pages.  It will then
  attempt to coalesce biovecs.  You probably won't see that if you avoid the
  I/O scheduler by capturing requests at make_request.  But it is still a good
  idea to declare your devices segment size limitation with
  blk_queue_max_segment_size.  There are a couple drivers in drivers/block/
  that do just that to limit segments to PAGE_SIZE. "

I wandered around a bit in the block code and I *think* that bvec coalescing
happens via the merge_bvec_fn() function pointers.  DM, for instance, sets
this to dm_merge_bvec() via the blk_queue_merge_bvec() function.  After that
it gets into lots of DM code.

> In fact I know of a couple of places that would break if this is true

Yep, PMEM and BRD both currently break because of this.

> > This bug was originally reported against
> > the pmem driver, where it was found using the Enmotus tiering engine.
> 
> This out-of-tree driver - none-gpl, with no source code - is the first I have
> heard of this.

It was hidden in the original bug report.  Same link as above, and here are
the relevant lines:

" We caught this because the Enmotus tiering engine issues rather large I/O
  requests to buffers that were allocated with kmalloc.  It is fairly common
  for the tiering engine to allocate I/O buffers of 64KB or greater.  If the
  underlying block device supports it, we will submit a bio with a biovec
  mapping many contiguous pages.  The entire buffer will possibly be mapped by
  a single biovec.  The tiering engine uses max_segment_size to determine how
  to build it's biovec list. "

I've never used it or heard of it before this either.

> > Instead we should have brd explicitly tell the block layer that it can
> > handle data segments of at most PAGE_SIZE.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Reported-by: Hugh Daschbach <hugh.daschbach@enmotus.com>
> > Cc: Roger C. Pao (Enmotus) <rcpao.enmotus@gmail.com>
> > Cc: Boaz Harrosh <boaz@plexistor.com>
> > Cc: linux-nvdimm@lists.01.org
> > Cc: Nick Piggin <npiggin@kernel.dk>
> > ---
> >  drivers/block/brd.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> > index 898b4f256782..7e4873361b64 100644
> > --- a/drivers/block/brd.c
> > +++ b/drivers/block/brd.c
> > @@ -490,6 +490,7 @@ static struct brd_device *brd_alloc(int i)
> >  	blk_queue_make_request(brd->brd_queue, brd_make_request);
> >  	blk_queue_max_hw_sectors(brd->brd_queue, 1024);
> >  	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
> > +	blk_queue_max_segment_size(brd->brd_queue, PAGE_SIZE);
> 
> The only place that I can find that uses _max_segment_size is
> when translating a bio list to an sg_list, where physical segments
> may coalesce. I have never seen it at the bio level
> 
> >  
> >  	brd->brd_queue->limits.discard_granularity = PAGE_SIZE;
> >  	brd->brd_queue->limits.max_discard_sectors = UINT_MAX;
> > 
> 
> Cheers
> Boaz

Anyway, I thought your response to the original bug report against PMEM was
that you were alright with this one line change since it didn't hurt anything,
and perhaps it helped someone.  Do you have the same stance for BRD, or do you
think we need to track down if or how bio_vecs can make it to the driver with
more than one page of data first?

- Ross


