Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 1 Oct 2015 09:35:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] block, dax: fix lifetime of in-kernel dax mappings
Message-ID: <20150930233529.GE3902@dastard>
References: <20150930002927.37133.331.stgit@dwillia2-desk3.jf.intel.com>
 <20150930004136.37133.66059.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150930004136.37133.66059.stgit@dwillia2-desk3.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@kernel.dk, Boaz Harrosh <boaz@plexistor.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, ross.zwisler@linux.intel.com, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 29, 2015 at 08:41:36PM -0400, Dan Williams wrote:
> The DAX implementation needs to protect new calls to ->direct_access()
> and usage of its return value against unbind of the underlying block
> device.  Use blk_queue_enter()/blk_queue_exit() to either prevent
> blk_cleanup_queue() from proceeding, or fail the dax_map_bh() if the
> request_queue is being torn down.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Boaz Harrosh <boaz@plexistor.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  block/blk.h            |    2 -
>  fs/dax.c               |  130 +++++++++++++++++++++++++++++++-----------------
>  include/linux/blkdev.h |    2 +
>  3 files changed, 85 insertions(+), 49 deletions(-)
> 
> diff --git a/block/blk.h b/block/blk.h
> index 5b2cd393afbe..0f8de0dda768 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -72,8 +72,6 @@ void blk_dequeue_request(struct request *rq);
>  void __blk_queue_free_tags(struct request_queue *q);
>  bool __blk_end_bidi_request(struct request *rq, int error,
>  			    unsigned int nr_bytes, unsigned int bidi_bytes);
> -int blk_queue_enter(struct request_queue *q, gfp_t gfp);
> -void blk_queue_exit(struct request_queue *q);
>  void blk_freeze_queue(struct request_queue *q);
>  
>  static inline void blk_queue_enter_live(struct request_queue *q)
> diff --git a/fs/dax.c b/fs/dax.c
> index bcfb14bfc1e4..7ce002bb60d0 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -63,12 +63,42 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
>  }
>  EXPORT_SYMBOL_GPL(dax_clear_blocks);
>  
> -static long dax_get_addr(struct buffer_head *bh, void __pmem **addr,
> -		unsigned blkbits)
> +static void __pmem *__dax_map_bh(const struct buffer_head *bh, unsigned blkbits,
> +		unsigned long *pfn, long *len)

Please don't use bufferheads for this. Please pass an inode, the
block and length to map, similar to dax_clear_blocks().

Why? Because dax_clear_blocks() needs to do this "mapping" too,
and it is called from contexts where there are no bufferheads.
There's a good chance we'll need more mapping contexts like this in
future, so lets not propagate bufferheads deeper into this code
than we absilutely need to.

We should be trying to limit/remove bufferheads in the DAX code, not
propagating them deeper into the code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
