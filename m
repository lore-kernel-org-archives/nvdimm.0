Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <550078AB.5030203@plexistor.com>
Date: Wed, 11 Mar 2015 19:17:31 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH] brd: Ensure that bio_vecs have size <= PAGE_SIZE
References: <1426093353-23709-1-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1426093353-23709-1-git-send-email-ross.zwisler@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: "Roger C. Pao (Enmotus)" <rcpao.enmotus@gmail.com>, linux-nvdimm@lists.01.org, Nick Piggin <npiggin@kernel.dk>
List-ID: <linux-nvdimm@lists.01.org>

On 03/11/2015 07:02 PM, Ross Zwisler wrote:
> The functions copy_from_brd() and copy_to_brd() are written with an
> assumption that the bio_vec they are given has size <= PAGE_SIZE.  This
> assumption is not enforced in any way, and if the bio_vec has size
> larger than PAGE_SIZE data will just be lost.
> 
> Such a situation can occur with I/Os generated from in-kernel sources,
> or with coalesced bio_vecs.  

I wish you could show me where in Kernel this can happen.
who "coalesced bio_vecs" ? what Kernel sources generate bio->b_size > PAGE_SIZE ?
I did try to look and could not find any. Sorry for my slowness.

In fact I know of a couple of places that would break if this is true

> This bug was originally reported against
> the pmem driver, where it was found using the Enmotus tiering engine.
> 

This out-of-tree driver - none-gpl, with no source code - is the first I have
heard of this.

> Instead we should have brd explicitly tell the block layer that it can
> handle data segments of at most PAGE_SIZE.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reported-by: Hugh Daschbach <hugh.daschbach@enmotus.com>
> Cc: Roger C. Pao (Enmotus) <rcpao.enmotus@gmail.com>
> Cc: Boaz Harrosh <boaz@plexistor.com>
> Cc: linux-nvdimm@lists.01.org
> Cc: Nick Piggin <npiggin@kernel.dk>
> ---
>  drivers/block/brd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index 898b4f256782..7e4873361b64 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -490,6 +490,7 @@ static struct brd_device *brd_alloc(int i)
>  	blk_queue_make_request(brd->brd_queue, brd_make_request);
>  	blk_queue_max_hw_sectors(brd->brd_queue, 1024);
>  	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
> +	blk_queue_max_segment_size(brd->brd_queue, PAGE_SIZE);

The only place that I can find that uses _max_segment_size is
when translating a bio list to an sg_list, where physical segments
may coalesce. I have never seen it at the bio level

>  
>  	brd->brd_queue->limits.discard_granularity = PAGE_SIZE;
>  	brd->brd_queue->limits.max_discard_sectors = UINT_MAX;
> 

Cheers
Boaz

