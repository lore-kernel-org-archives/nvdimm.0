Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Sun, 4 Oct 2015 08:40:13 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] block: generic request_queue reference counting
Message-ID: <20151004064013.GC13199@lst.de>
References: <20150930002927.37133.331.stgit@dwillia2-desk3.jf.intel.com> <20150930004130.37133.73852.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150930004130.37133.73852.stgit@dwillia2-desk3.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@kernel.dk, Keith Busch <keith.busch@intel.com>, ross.zwisler@linux.intel.com, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 29, 2015 at 08:41:31PM -0400, Dan Williams wrote:
> Allow pmem, and other synchronous/bio-based block drivers, to fallback
> on a per-cpu reference count managed by the core for tracking queue
> live/dead state.
> 
> The existing per-cpu reference count for the blk_mq case is promoted to
> be used in all block i/o scenarios.  This involves initializing it by
> default, waiting for it to drop to zero at exit, and holding a live
> reference over the invocation of q->make_request_fn() in
> generic_make_request().  The blk_mq code continues to take its own
> reference per blk_mq request and retains the ability to freeze the
> queue, but the check that the queue is frozen is moved to
> generic_make_request().
> 
> This fixes crash signatures like the following:
> 
>  BUG: unable to handle kernel paging request at ffff880140000000
>  [..]
>  Call Trace:
>   [<ffffffff8145e8bf>] ? copy_user_handle_tail+0x5f/0x70
>   [<ffffffffa004e1e0>] pmem_do_bvec.isra.11+0x70/0xf0 [nd_pmem]
>   [<ffffffffa004e331>] pmem_make_request+0xd1/0x200 [nd_pmem]
>   [<ffffffff811c3162>] ? mempool_alloc+0x72/0x1a0
>   [<ffffffff8141f8b6>] generic_make_request+0xd6/0x110
>   [<ffffffff8141f966>] submit_bio+0x76/0x170
>   [<ffffffff81286dff>] submit_bh_wbc+0x12f/0x160
>   [<ffffffff81286e62>] submit_bh+0x12/0x20
>   [<ffffffff813395bd>] jbd2_write_superblock+0x8d/0x170
>   [<ffffffff8133974d>] jbd2_mark_journal_empty+0x5d/0x90
>   [<ffffffff813399cb>] jbd2_journal_destroy+0x24b/0x270
>   [<ffffffff810bc4ca>] ? put_pwq_unlocked+0x2a/0x30
>   [<ffffffff810bc6f5>] ? destroy_workqueue+0x225/0x250
>   [<ffffffff81303494>] ext4_put_super+0x64/0x360
>   [<ffffffff8124ab1a>] generic_shutdown_super+0x6a/0xf0
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  block/blk-core.c       |   71 +++++++++++++++++++++++++++++++++++++------
>  block/blk-mq-sysfs.c   |    6 ----
>  block/blk-mq.c         |   80 ++++++++++++++----------------------------------
>  block/blk-sysfs.c      |    3 +-
>  block/blk.h            |   14 ++++++++
>  include/linux/blk-mq.h |    1 -
>  include/linux/blkdev.h |    2 +
>  7 files changed, 102 insertions(+), 75 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 2eb722d48773..6062550baaef 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -554,19 +554,17 @@ void blk_cleanup_queue(struct request_queue *q)
>  	 * Drain all requests queued before DYING marking. Set DEAD flag to
>  	 * prevent that q->request_fn() gets invoked after draining finished.
>  	 */
> -	if (q->mq_ops) {
> -		blk_mq_freeze_queue(q);
> -		spin_lock_irq(lock);
> -	} else {
> -		spin_lock_irq(lock);
> +	blk_freeze_queue(q);
> +	spin_lock_irq(lock);
> +	if (!q->mq_ops)
>  		__blk_drain_queue(q, true);
> -	}

__blk_drain_queue really ought to be moved into blk_freeze_queue so it
has equivlaent functionality for mq vs !mq.  But maybe that can be a
separate patch.
