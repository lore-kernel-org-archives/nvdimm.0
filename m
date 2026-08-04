Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8126D30C606;
	Tue,  4 Aug 2026 09:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785835218; cv=none; b=gKzJiB9A2b01+LsIUoURhCLZcVduDt/yjLqHUZzPlmMrQU1gRpo7ZZ2k4sraQmt0eGRdUDxAcD3pWIFXDxPNa6mrwmeuZlKGKLwwMF2lvJxJiWzzJGGuxMOdImEXPdS9AAMiwLtfI9JeEuAYYdLsOQDuV0A+8JLtpoPjq+OF070=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785835218; c=relaxed/simple;
	bh=PVo1OFtrqnqAVkO7yEjqPVQODoT6J/DRZsWMMHMlrkY=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lgdiG41gUA1NhnGH47JNvPbXW6QmURpUxQ7LdnVWfuc5T6i+qAtprD1D5yuzQ1O8L+f22uQK0TmI+gIqBHJgOqsEqu2QrIC1p4K1/bU8uCKQMNLpfwifPZoGljz6/u7LDtXm2t8hpc3Je8+H1TAHBOnLkTkr5iDqSYfpAiwBVAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xfxE/iDH; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xfxE/iDH"
Message-ID: <a677f581-344b-4d99-846d-a00801e26033@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785835202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pGcoNPEKNf39GDbuhHsUaJ0Tu/EDqyYRpJ8rGi+p9zg=;
	b=xfxE/iDHMlRenFHP1OUGWuZxGZNoMwJ3zOV5xGZpl33A15DJ3ko/b/80atoch//yKNLjaR
	LtjU1vEsFLdDmgdE+bfIiCGwGsHgJJ5nBHCsKlJbrw6Sm7U1OlxtcHb9DK7w9QY837CBev
	kTxet2U+UPnIVpJtYCHYttTpE+COu14=
Date: Tue, 4 Aug 2026 17:19:24 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Yu Kuai <yukuai@fygo.io>, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@fygo.io>, Kent Overstreet <kent.overstreet@linux.dev>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
 Andreas Gruenbacher <agruenba@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Christoph Hellwig <hch@lst.de>,
 Nilay Shroff <nilay@linux.ibm.com>, cgroups@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
 gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of blkg
To: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <20260804065313.2092022-1-yukuai@kernel.org>
 <20260804065313.2092022-3-yukuai@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260804065313.2092022-3-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


Hi Kuai,
在 2026/8/4 14:53, Yu Kuai 写道:
> From: Yu Kuai <yukuai@fygo.io>
> 
> A bio currently stores a queue-local blkg reference.  This forces bio
> association and remap paths to look up or create a blkg even when the bio
> will never enter a blkcg policy.
> 
> Store the blkcg css association in the bio instead, and derive the blkg
> from the bio's blkcg and current bdev when a policy needs it.  The first
> successful policy lookup pins the blkg, records the pin with BIO_BLKG_REF,
> and drops it from bio_clear_blkcg() or when bio_set_dev() changes the
> lookup key.
> 
> Keep lookup-only users from creating missing blkgs by using
> bio_blkg_lookup(), and rename the bio cgroup association helpers to match
> the stored blkcg state.
> 
> Signed-off-by: Yu Kuai <yukuai@fygo.io>
> ---
>  Documentation/admin-guide/cgroup-v2.rst |   2 +-
>  block/bfq-cgroup.c                      |  14 +-
>  block/bfq-iosched.c                     |  18 ++-
>  block/bio.c                             |  12 +-
>  block/blk-cgroup-fc-appid.c             |   5 +-
>  block/blk-cgroup.c                      | 206 +++++++++++++++---------
>  block/blk-cgroup.h                      |  23 ++-
>  block/blk-crypto-fallback.c             |   2 +-
>  block/blk-iocost.c                      |  10 +-
>  block/blk-iolatency.c                   |   7 +-
>  drivers/md/bcache/request.c             |   2 +-
>  drivers/md/dm.c                         |   2 +-
>  drivers/md/md.c                         |   2 +-
>  drivers/nvdimm/nd_virtio.c              |   2 +-
>  fs/gfs2/lops.c                          |   3 +-
>  include/linux/bio.h                     |  30 ++--
>  include/linux/blk_types.h               |   9 +-
>  include/linux/writeback.h               |   2 +-
>  mm/page_io.c                            |  10 +-
>  19 files changed, 218 insertions(+), 143 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 14b8c571c0d1..bbd79931d5ab 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -3235,7 +3235,7 @@ the configuration, the bio may be executed at a lower priority and if
>  the writeback session is holding shared resources, e.g. a journal
>  entry, may lead to priority inversion.  There is no one easy solution
>  for the problem.  Filesystems can try to work around specific problem
> -cases by skipping wbc_init_bio() and using bio_associate_blkg()
> +cases by skipping wbc_init_bio() and using bio_associate_blkcg()
>  directly.
>  
>  
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index 7e65fe6844ee..3ac3b4c05402 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -363,11 +363,13 @@ void bfqg_and_blkg_put(struct bfq_group *bfqg)
>  
>  void bfqg_stats_update_legacy_io(struct request_queue *q, struct request *rq)
>  {
> -	struct bfq_group *bfqg = blkg_to_bfqg(bio_blkg(rq->bio));
> +	struct blkcg_gq *blkg = bio_blkg_lookup(rq->bio);
> +	struct bfq_group *bfqg;
>  
> -	if (!bfqg)
> +	if (!blkg)
>  		return;
>  
> +	bfqg = blkg_to_bfqg(blkg);
>  	blkg_rwstat_add(&bfqg->stats.bytes, rq->cmd_flags, blk_rq_bytes(rq));
>  	blkg_rwstat_add(&bfqg->stats.ios, rq->cmd_flags, 1);
>  }
> @@ -606,7 +608,7 @@ static void bfq_link_bfqg(struct bfq_data *bfqd, struct bfq_group *bfqg)
>  
>  struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
>  {
> -	struct blkcg_gq *blkg = bio_blkg(bio);
> +	struct blkcg_gq *blkg = bio_blkg_lookup(bio);
>  	struct bfq_group *bfqg;
>  
>  	while (blkg) {
> @@ -614,14 +616,16 @@ struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
>  			blkg = blkg->parent;
>  			continue;
>  		}
> +
>  		bfqg = blkg_to_bfqg(blkg);
>  		if (bfqg->pd.online) {
> -			bio_associate_blkg_from_css(bio, &blkg->blkcg->css);
> +			bio_associate_blkcg_from_css(bio, &blkg->blkcg->css);
>  			return bfqg;
>  		}
>  		blkg = blkg->parent;
>  	}
> -	bio_associate_blkg_from_css(bio,
> +
> +	bio_associate_blkcg_from_css(bio,
>  				&bfqg_to_blkg(bfqd->root_group)->blkcg->css);
>  	return bfqd->root_group;
>  }
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 0f75301b3115..3d51d743552c 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -128,6 +128,7 @@
>  
>  #include "elevator.h"
>  #include "blk.h"
> +#include "blk-cgroup.h"
>  #include "blk-mq.h"
>  #include "blk-mq-sched.h"
>  #include "bfq-iosched.h"
> @@ -2452,15 +2453,15 @@ static bool bfq_bio_merge(struct request_queue *q, struct bio *bio,
>  	struct request *free = NULL;
>  	bool ret;
>  
> +#ifdef CONFIG_BFQ_GROUP_IOSCHED
> +	if (bic && bio_blkg_lookup(bio) == NULL)
> +		return false;
> +#endif
> +
>  	spin_lock_irq(&bfqd->lock);
>  
>  	if (bic) {
> -		/*
> -		 * Make sure cgroup info is uptodate for current process before
> -		 * considering the merge.
> -		 */
>  		bfq_bic_update_cgroup(bic, bio);
> -
>  		bfqd->bio_bfqq = bic_to_bfqq(bic, op_is_sync(bio->bi_opf),
>  					     bfq_actuator_index(bfqd, bio));
>  	} else {
> @@ -6245,6 +6246,13 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
>  	LIST_HEAD(free);
>  
>  #ifdef CONFIG_BFQ_GROUP_IOSCHED
> +	/*
> +	 * Pin the blkg used to look up bfqg.  If this is the first IO for
> +	 * the blkcg on this queue, create the bfqg before holding bfqd->lock.
> +	 */
> +	if (rq->bio && !bio_flagged(rq->bio, BIO_BLKG_REF))
> +		bio_blkg(rq->bio);
> +
>  	if (!cgroup_subsys_on_dfl(io_cgrp_subsys) && rq->bio)
>  		bfqg_stats_update_legacy_io(q, rq);
>  #endif
> diff --git a/block/bio.c b/block/bio.c
> index c207b248edba..db33c993c296 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -179,7 +179,7 @@ static inline gfp_t try_alloc_gfp(gfp_t gfp)
>  
>  void bio_uninit(struct bio *bio)
>  {
> -	bio_clear_blkg(bio);
> +	bio_clear_blkcg(bio);
>  	if (bio_integrity(bio))
>  		bio_integrity_free(bio);
>  
> @@ -228,10 +228,10 @@ void bio_init(struct bio *bio, struct block_device *bdev, struct bio_vec *table,
>  	bio->bi_end_io = NULL;
>  	bio->bi_private = NULL;
>  #ifdef CONFIG_BLK_CGROUP
> -	bio->bi_blkg = NULL;
> +	bio->bi_blkcg = NULL;
>  	bio->issue_time_ns = 0;
>  	if (bdev)
> -		bio_associate_blkg(bio);
> +		bio_associate_blkcg(bio);
>  #ifdef CONFIG_BLK_CGROUP_IOCOST
>  	bio->bi_iocost_cost = 0;
>  #endif
> @@ -276,7 +276,7 @@ void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf)
>  	bio->bi_io_vec = bv;
>  	bio->bi_bdev = bdev;
>  	if (bio->bi_bdev)
> -		bio_associate_blkg(bio);
> +		bio_associate_blkcg(bio);
>  	bio->bi_opf = opf;
>  }
>  EXPORT_SYMBOL(bio_reset);
> @@ -860,7 +860,7 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
>  		if (bio->bi_bdev == bio_src->bi_bdev &&
>  		    bio_flagged(bio_src, BIO_REMAPPED))
>  			bio_set_flag(bio, BIO_REMAPPED);
> -		bio_clone_blkg_association(bio, bio_src);
> +		bio_clone_blkcg_association(bio, bio_src);
>  	}
>  
>  	if (bio_crypt_clone(bio, bio_src, gfp) < 0)
> @@ -1803,7 +1803,7 @@ void bio_endio(struct bio *bio)
>  	 * a few callers of bio_init fail to call bio_uninit, so we cover up
>  	 * for that here at least for now.
>  	 */
> -	bio_clear_blkg(bio);
> +	bio_clear_blkcg(bio);
>  
>  	if (bio->bi_end_io)
>  		bio->bi_end_io(bio);
> diff --git a/block/blk-cgroup-fc-appid.c b/block/blk-cgroup-fc-appid.c
> index b2e16e9a7a6c..7589c6209989 100644
> --- a/block/blk-cgroup-fc-appid.c
> +++ b/block/blk-cgroup-fc-appid.c
> @@ -50,12 +50,11 @@ EXPORT_SYMBOL_GPL(blkcg_set_fc_appid);
>   */
>  char *blkcg_get_fc_appid(struct bio *bio)
>  {
> -	struct blkcg *blkcg;
> +	struct blkcg *blkcg = bio_blkcg(bio);
>  
> -	if (!bio_blkg(bio))
> +	if (!blkcg)
>  		return NULL;
>  
> -	blkcg = bio_blkcg(bio);
>  	if (blkcg->fc_app_id[0] == '\0')
>  		return NULL;
>  
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 753a3bdd0e8c..93ab57e0a9f1 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -241,13 +241,13 @@ void blkcg_punt_bio_submit(struct bio *bio)
>  {
>  	struct blkcg_gq *blkg = bio_blkg(bio);
>  
> -	if (blkg->parent) {
> +	if (blkg && blkg->parent) {
>  		spin_lock(&blkg->async_bio_lock);
>  		bio_list_add(&blkg->async_bios, bio);
>  		spin_unlock(&blkg->async_bio_lock);
>  		queue_work(blkcg_punt_bio_wq, &blkg->async_bio_work);
>  	} else {
> -		/* never bounce for the root cgroup */
> +		/* Never bounce if there is no non-root blkg to queue on. */
>  		submit_bio(bio);
>  	}
>  }
> @@ -275,7 +275,7 @@ subsys_initcall(blkcg_punt_bio_init);
>   */
>  struct cgroup_subsys_state *bio_blkcg_css(struct bio *bio)
>  {
> -	if (!bio || !bio_blkg(bio))
> +	if (!bio || !bio_blkcg(bio))
>  		return NULL;
>  	return &bio_blkcg(bio)->css;
>  }
> @@ -2051,129 +2051,181 @@ void blkcg_add_delay(struct blkcg_gq *blkg, u64 now, u64 delta)
>  	atomic64_add(delta, &blkg->delay_nsec);
>  }
>  
> -static inline struct blkcg_gq *blkg_lookup_tryget(struct blkcg_gq *blkg)
> +/*
> + * Return the blkg pinned by @bio through BIO_BLKG_REF.  The returned blkg is
> + * already owned by @bio and no extra reference is acquired.  If the pinned
> + * blkg can't be found, fall back to the root blkg.
> + */
> +static struct blkcg_gq *bio_pinned_blkg(struct bio *bio)
>  {
> -retry:
> -	if (blkg_tryget(blkg))
> -		return blkg;
> +	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> +	struct blkcg_gq *blkg;
>  
> -	blkg = blkg->parent;
> -	if (blkg)
> -		goto retry;
> +	rcu_read_lock();
> +	blkg = blkg_lookup(bio_blkcg(bio), q);
> +	rcu_read_unlock();
>  
> -	return NULL;
> +	if (WARN_ON_ONCE(!blkg))
> +		return q->root_blkg;
> +	return blkg;
>  }

While reading 2/3, one spot in bio_pinned_blkg() made me wonder, so I
gave it a try — and the WARN_ON_ONCE triggers every time for me.

I may well be missing something, but my worry is that the bio's ref on
the blkg keeps the object alive, not its entry in the radix tree.
blkg_destroy() runs throtl_pd_offline (which only schedules an async
flush) before radix_tree_delete(), so the queued bio ends up dispatched
(blk_throtl_dispatch_work_fn -> blk_cgroup_bio_start ->
bio_pinned_blkg) after the blkg is already gone from the tree, and
blkg_lookup() returns NULL.

I applied the series and wrote a small reproducer:

  - null_blk, cgroup v2, a child cgroup with io.max rbps=4096;
  - a read issued in the child cgroup gets throttled and queued, pinning
    the blkg;
  - migrate the reader out and rmdir the cgroup; the queued bio is then
    flushed after the blkg has left the tree.

Reproduces on boot:

  WARNING: CPU: 0 PID: 11 at block/blk-cgroup.c:2061 bio_pinned_blkg+0x65/0xa0
  Workqueue: kthrotld blk_throtl_dispatch_work_fn
  Call Trace:
   blk_cgroup_bio_start+0x49/0xe0
   submit_bio_noacct_nocheck+0x2f/0x350
   blk_throtl_dispatch_work_fn+0xd2/0x110
   process_one_work+0x1a2/0x3f0
   worker_thread+0x172/0x2e0
   kthread+0xdd/0x110
   ret_from_fork+0x1bd/0x220

Maybe keeping the pinned blkg pointer in the bio would sidestep this, so
the lookup can't miss?

Thanks,
Tao

> +
>  /**
> - * blkg_tryget_closest - try and get a blkg ref on the closet blkg
> + * bio_blkg_lookup - look up a blkg associated with a bio
>   * @bio: target bio
> - * @css: target css
>   *
> - * As the failure mode here is to walk up the blkg tree, this ensure that the
> - * blkg->parent pointers are always valid.  This returns the blkg that it ended
> - * up taking a reference on or %NULL if no reference was taken.
> + * Look up the queue-local blkg for @bio's current device and blkcg without
> + * creating a missing blkg.  The first successful lookup pins the blkg to @bio;
> + * later lookups reuse the bio-owned reference.
>   */
> -static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
> -		struct cgroup_subsys_state *css)
> +struct blkcg_gq *bio_blkg_lookup(struct bio *bio)
>  {
> -	struct request_queue *q = bio->bi_bdev->bd_queue;
> -	struct blkcg *blkcg = css_to_blkcg(css);
> +	struct blkcg *blkcg = bio_blkcg(bio);
> +	struct request_queue *q;
>  	struct blkcg_gq *blkg;
>  
> +	if (bio_flagged(bio, BIO_BLKG_REF))
> +		return bio_pinned_blkg(bio);
> +
> +	if (!blkcg || !bio->bi_bdev)
> +		return NULL;
> +
> +	q = bdev_get_queue(bio->bi_bdev);
>  	rcu_read_lock();
>  	blkg = blkg_lookup(blkcg, q);
> -	if (likely(blkg))
> -		blkg = blkg_lookup_tryget(blkg);
> +	if (blkg && blkg_tryget(blkg))
> +		bio_set_flag(bio, BIO_BLKG_REF);
> +	else
> +		blkg = NULL;
>  	rcu_read_unlock();
>  
> -	if (blkg)
> -		return blkg;
> +	return blkg;
> +}
> +EXPORT_SYMBOL_GPL(bio_blkg_lookup);
> +
> +/**
> + * bio_put_blkg_ref - drop the blkg reference pinned by a bio
> + * @bio: target bio
> + *
> + * Drop the bio-owned blkg reference acquired by bio_blkg(), if any.
> + */
> +void bio_put_blkg_ref(struct bio *bio)
> +{
> +	if (bio_flagged(bio, BIO_BLKG_REF)) {
> +		struct blkcg_gq *blkg = bio_pinned_blkg(bio);
> +
> +		blkg_put(blkg);
> +		bio_clear_flag(bio, BIO_BLKG_REF);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(bio_put_blkg_ref);
> +
> +/**
> + * bio_blkg - look up the blkg associated with a bio
> + * @bio: target bio
> + *
> + * Look up the queue-local blkg for @bio's current device and blkcg.  If this
> + * is the first policy use of @bio, create the missing blkg hierarchy if
> + * necessary, pin the exact blkg, and mark @bio so bio_clear_blkcg() can drop
> + * the reference when the bio completes.
> + */
> +struct blkcg_gq *bio_blkg(struct bio *bio)
> +{
> +	struct blkcg *blkcg = bio_blkcg(bio);
> +	struct gendisk *disk;
> +	struct request_queue *q;
> +	struct blkcg_gq *blkg;
> +
> +	if (!blkcg || !bio->bi_bdev)
> +		return NULL;
> +
> +	if (bio_flagged(bio, BIO_BLKG_REF))
> +		return bio_pinned_blkg(bio);
> +
> +	disk = bio->bi_bdev->bd_disk;
> +	q = disk->queue;
>  
> -	/*
> -	 * Fast path failed, we're probably issuing IO in this cgroup the first
> -	 * time, hold lock to create new blkg.
> -	 */
>  	spin_lock_irq(&q->queue_lock);
> -	blkg = blkg_lookup_create(blkcg, bio->bi_bdev->bd_disk);
> -	if (blkg)
> -		blkg = blkg_lookup_tryget(blkg);
> +	blkg = blkg_lookup_create(blkcg, disk);
> +	if (blkg && blkg->blkcg == blkcg && blkg_tryget(blkg))
> +		bio_set_flag(bio, BIO_BLKG_REF);
> +	else
> +		blkg = NULL;
>  	spin_unlock_irq(&q->queue_lock);
>  
>  	return blkg;
>  }
> +EXPORT_SYMBOL_GPL(bio_blkg);
>  
>  /**
> - * bio_associate_blkg_from_css - associate a bio with a specified css
> + * bio_associate_blkcg_from_css - associate a bio with a specified css
>   * @bio: target bio
>   * @css: target css
>   *
> - * Associate @bio with the blkg found by combining the css's blkg and the
> - * request_queue of the @bio.  An association failure is handled by walking up
> - * the blkg tree.  Therefore, the blkg associated can be anything between @blkg
> - * and q->root_blkg.  This situation only happens when a cgroup is dying and
> - * then the remaining bios will spill to the closest alive blkg.
> + * Associate @bio with the blkcg found from @css.  The queue-local blkg is
> + * created and pinned by bio_blkg() when blkcg policies need it.
>   *
> - * A reference will be taken on the blkg and will be released when @bio is
> + * A reference will be taken on the blkcg and will be released when @bio is
>   * freed.
>   */
> -void bio_associate_blkg_from_css(struct bio *bio,
> +void bio_associate_blkcg_from_css(struct bio *bio,
>  				 struct cgroup_subsys_state *css)
>  {
> -	if (bio_blkg(bio))
> -		blkg_put(bio_blkg(bio));
> +	struct blkcg *blkcg;
>  
> -	if (css && css->parent) {
> -		bio->bi_blkg = blkg_tryget_closest(bio, css);
> -	} else {
> -		blkg_get(bdev_get_queue(bio->bi_bdev)->root_blkg);
> -		bio->bi_blkg = bdev_get_queue(bio->bi_bdev)->root_blkg;
> -	}
> +	if (!css || !css->parent)
> +		css = &blkcg_root.css;
> +
> +	blkcg = css_to_blkcg(css);
> +	if (bio_blkcg(bio) == blkcg)
> +		return;
> +
> +	css_get(css);
> +	bio_clear_blkcg(bio);
> +	bio->bi_blkcg = blkcg;
>  }
> -EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
> +EXPORT_SYMBOL_GPL(bio_associate_blkcg_from_css);
>  
>  /**
> - * bio_associate_blkg - associate a bio with a blkg
> + * bio_associate_blkcg - associate a bio with a blkcg
>   * @bio: target bio
>   *
> - * Associate @bio with the blkg found from the bio's css and request_queue.
> - * If one is not found, bio_lookup_blkg() creates the blkg.  If a blkg is
> - * already associated, the css is reused and association redone as the
> - * request_queue may have changed.
> + * Associate @bio with the blkcg found from the bio's css.  If a blkcg is
> + * already associated, keep it as blkcg association is not queue-local.
>   */
> -void bio_associate_blkg(struct bio *bio)
> +void bio_associate_blkcg(struct bio *bio)
>  {
>  	struct cgroup_subsys_state *css;
>  
>  	if (blk_op_is_passthrough(bio->bi_opf))
>  		return;
>  
> -	if (bio_blkg(bio)) {
> -		css = bio_blkcg_css(bio);
> -		bio_associate_blkg_from_css(bio, css);
> -	} else {
> -		rcu_read_lock();
> -		css = blkcg_css();
> -		if (!css_tryget_online(css))
> -			css = NULL;
> -		rcu_read_unlock();
> +	if (bio_blkcg(bio))
> +		return;
>  
> -		bio_associate_blkg_from_css(bio, css);
> -		if (css)
> -			css_put(css);
> -	}
> +	rcu_read_lock();
> +	css = blkcg_css();
> +	if (!css_tryget_online(css))
> +		css = NULL;
> +	rcu_read_unlock();
> +
> +	bio_associate_blkcg_from_css(bio, css);
> +	if (css)
> +		css_put(css);
>  }
> -EXPORT_SYMBOL_GPL(bio_associate_blkg);
> +EXPORT_SYMBOL_GPL(bio_associate_blkcg);
>  
>  /**
> - * bio_clone_blkg_association - clone blkg association from src to dst bio
> + * bio_clone_blkcg_association - clone blkcg association from src to dst bio
>   * @dst: destination bio
>   * @src: source bio
>   */
> -void bio_clone_blkg_association(struct bio *dst, struct bio *src)
> +void bio_clone_blkcg_association(struct bio *dst, struct bio *src)
>  {
> -	if (bio_blkg(src))
> -		bio_associate_blkg_from_css(dst, bio_blkcg_css(src));
> +	if (bio_blkcg(src))
> +		bio_associate_blkcg_from_css(dst, bio_blkcg_css(src));
>  }
> -EXPORT_SYMBOL_GPL(bio_clone_blkg_association);
> +EXPORT_SYMBOL_GPL(bio_clone_blkcg_association);
>  
>  static int blk_cgroup_io_type(struct bio *bio)
>  {
> @@ -2186,19 +2238,25 @@ static int blk_cgroup_io_type(struct bio *bio)
>  
>  void blk_cgroup_bio_start(struct bio *bio)
>  {
> -	struct blkcg_gq *blkg = bio_blkg(bio);
>  	struct blkcg *blkcg = bio_blkcg(bio);
> +	struct blkcg_gq *blkg;
>  	int rwd = blk_cgroup_io_type(bio), cpu;
>  	struct blkg_iostat_set *bis;
>  	unsigned long flags;
>  
>  	if (!cgroup_subsys_on_dfl(io_cgrp_subsys))
>  		return;
> +	if (!blkcg)
> +		return;
>  
>  	/* Root-level stats are sourced from system-wide IO stats */
>  	if (!cgroup_parent(blkcg->css.cgroup))
>  		return;
>  
> +	blkg = bio_blkg_lookup(bio);
> +	if (!blkg)
> +		return;
> +
>  	cpu = get_cpu();
>  	bis = per_cpu_ptr(blkg->iostat_cpu, cpu);
>  	flags = u64_stats_update_begin_irqsave(&bis->sync);
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index 1e80b0a73233..b6fb85db4d3d 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -126,7 +126,7 @@ static inline struct blkcg *css_to_blkcg(struct cgroup_subsys_state *css)
>  
>  static inline struct blkcg *bio_blkcg(struct bio *bio)
>  {
> -	return bio_blkg(bio)->blkcg;
> +	return bio->bi_blkcg;
>  }
>  
>  /*
> @@ -281,6 +281,9 @@ static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
>  	return blkg;
>  }
>  
> +struct blkcg_gq *bio_blkg_lookup(struct bio *bio);
> +struct blkcg_gq *bio_blkg(struct bio *bio);
> +
>  /**
>   * blkg_to_pd - get policy private data
>   * @blkg: blkg of interest
> @@ -348,13 +351,15 @@ static inline void blkg_put(struct blkcg_gq *blkg)
>  	percpu_ref_put(&blkg->refcnt);
>  }
>  
> -static inline void bio_clear_blkg(struct bio *bio)
> +static inline void bio_clear_blkcg(struct bio *bio)
>  {
> -	struct blkcg_gq *blkg = bio_blkg(bio);
> +	struct blkcg *blkcg = bio_blkcg(bio);
> +
> +	bio_put_blkg_ref(bio);
>  
> -	if (blkg) {
> -		blkg_put(blkg);
> -		bio->bi_blkg = NULL;
> +	if (blkcg) {
> +		css_put(&blkcg->css);
> +		bio->bi_blkcg = NULL;
>  	}
>  }
>  
> @@ -470,7 +475,7 @@ static inline void blkcg_clear_delay(struct blkcg_gq *blkg)
>   */
>  static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio)
>  {
> -	return bio_blkg(rq->bio) == bio_blkg(bio) &&
> +	return bio_blkcg(rq->bio) == bio_blkcg(bio) &&
>  		bio_issue_as_root_blkg(rq->bio) == bio_issue_as_root_blkg(bio);
>  }
>  
> @@ -497,6 +502,8 @@ struct blkcg {
>  };
>  
>  static inline struct blkcg *bio_blkcg(struct bio *bio) { return NULL; }
> +static inline struct blkcg_gq *bio_blkg_lookup(struct bio *bio) { return NULL; }
> +static inline struct blkcg_gq *bio_blkg(struct bio *bio) { return NULL; }
>  static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { return NULL; }
>  static inline void blkg_init_queue(struct request_queue *q) { }
>  static inline int blkcg_init_disk(struct gendisk *disk) { return 0; }
> @@ -513,7 +520,7 @@ static inline struct blkg_policy_data *blkg_to_pd(struct blkcg_gq *blkg,
>  static inline struct blkcg_gq *pd_to_blkg(struct blkg_policy_data *pd) { return NULL; }
>  static inline void blkg_get(struct blkcg_gq *blkg) { }
>  static inline void blkg_put(struct blkcg_gq *blkg) { }
> -static inline void bio_clear_blkg(struct bio *bio) { }
> +static inline void bio_clear_blkcg(struct bio *bio) { }
>  static inline void blk_cgroup_bio_start(struct bio *bio) { }
>  static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio) { return true; }
>  
> diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
> index 2a5c52ab74b4..5ef4baab444b 100644
> --- a/block/blk-crypto-fallback.c
> +++ b/block/blk-crypto-fallback.c
> @@ -187,7 +187,7 @@ static struct bio *blk_crypto_alloc_enc_bio(struct bio *bio_src,
>  	bio->bi_write_hint	= bio_src->bi_write_hint;
>  	bio->bi_write_stream	= bio_src->bi_write_stream;
>  	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
> -	bio_clone_blkg_association(bio, bio_src);
> +	bio_clone_blkcg_association(bio, bio_src);
>  
>  	/*
>  	 * Move page array up in the allocated memory for the bio vecs as far as
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index d4470476bcd0..62ffd759bb95 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -2775,7 +2775,7 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
>  static void ioc_rqos_merge(struct rq_qos *rqos, struct request *rq,
>  			   struct bio *bio)
>  {
> -	struct ioc_gq *iocg = blkg_to_iocg(bio_blkg(bio));
> +	struct ioc_gq *iocg = blkg_to_iocg(bio_blkg_lookup(bio));
>  	struct ioc *ioc = rqos_to_ioc(rqos);
>  	sector_t bio_end = bio_end_sector(bio);
>  	struct ioc_now now;
> @@ -2833,9 +2833,13 @@ static void ioc_rqos_merge(struct rq_qos *rqos, struct request *rq,
>  
>  static void ioc_rqos_done_bio(struct rq_qos *rqos, struct bio *bio)
>  {
> -	struct ioc_gq *iocg = blkg_to_iocg(bio_blkg(bio));
> +	struct ioc_gq *iocg;
> +
> +	if (!bio->bi_iocost_cost)
> +		return;
>  
> -	if (iocg && bio->bi_iocost_cost)
> +	iocg = blkg_to_iocg(bio_blkg_lookup(bio));
> +	if (iocg)
>  		atomic64_add(bio->bi_iocost_cost, &iocg->done_vtime);
>  }
>  
> diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
> index c0d8d5f6bdba..7ad18a538d7e 100644
> --- a/block/blk-iolatency.c
> +++ b/block/blk-iolatency.c
> @@ -590,8 +590,11 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
>  	bool issue_as_root = bio_issue_as_root_blkg(bio);
>  	int inflight = 0;
>  
> -	blkg = bio_blkg(bio);
> -	if (!blkg || !bio_flagged(bio, BIO_QOS_THROTTLED))
> +	if (!bio_flagged(bio, BIO_QOS_THROTTLED))
> +		return;
> +
> +	blkg = bio_blkg_lookup(bio);
> +	if (!blkg)
>  		return;
>  
>  	iolat = blkg_to_lat(blkg);
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 3fa3b13a410f..c0f945b8d941 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -848,7 +848,7 @@ static CLOSURE_CALLBACK(cached_dev_read_done)
>  		s->iop.bio->bi_iter.bi_sector =
>  			s->cache_miss->bi_iter.bi_sector;
>  		s->iop.bio->bi_iter.bi_size = s->insert_bio_sectors << 9;
> -		bio_clone_blkg_association(s->iop.bio, s->cache_miss);
> +		bio_clone_blkcg_association(s->iop.bio, s->cache_miss);
>  		bch_bio_map(s->iop.bio, NULL);
>  
>  		bio_copy_data(s->cache_miss, s->iop.bio);
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index d413bfaf3527..cd68eec77f5a 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1373,7 +1373,7 @@ void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone)
>  	if (!tgt_clone)
>  		tgt_clone = clone;
>  
> -	bio_clone_blkg_association(tgt_clone, io->orig_bio);
> +	bio_clone_blkcg_association(tgt_clone, io->orig_bio);
>  
>  	/*
>  	 * Account io->origin_bio to DM dev on behalf of target
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d1465bcd86c8..af55f8efa46b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9355,7 +9355,7 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>  		return;
>  
>  	bio_chain(discard_bio, bio);
> -	bio_clone_blkg_association(discard_bio, bio);
> +	bio_clone_blkcg_association(discard_bio, bio);
>  	mddev_trace_remap(mddev, discard_bio, bio->bi_iter.bi_sector);
>  	submit_bio_noacct(discard_bio);
>  }
> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index 4176046627be..54e4adb0ccb7 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
> @@ -121,7 +121,7 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
>  
>  		if (!child)
>  			return -ENOMEM;
> -		bio_clone_blkg_association(child, bio);
> +		bio_clone_blkcg_association(child, bio);
>  		child->bi_iter.bi_sector = -1;
>  		bio_chain(child, bio);
>  		submit_bio(child);
> diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
> index 6dabe73ad790..6512dbd9516f 100644
> --- a/fs/gfs2/lops.c
> +++ b/fs/gfs2/lops.c
> @@ -484,7 +484,7 @@ static struct bio *gfs2_chain_bio(struct bio *prev, unsigned int nr_iovecs,
>  	struct bio *new;
>  
>  	new = bio_alloc(prev->bi_bdev, nr_iovecs, opf, GFP_NOIO);
> -	bio_clone_blkg_association(new, prev);
> +	bio_clone_blkcg_association(new, prev);
>  	new->bi_iter.bi_sector = sector;
>  	bio_chain(new, prev);
>  	submit_bio(prev);
> @@ -1114,4 +1114,3 @@ const struct gfs2_log_operations *gfs2_log_ops[] = {
>  	&gfs2_revoke_lops,
>  	NULL,
>  };
> -
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index dc4baa3602b7..e5799fdf431d 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -503,28 +503,20 @@ static inline void bio_release_pages(struct bio *bio, bool mark_dirty)
>  	disk_devt((bio)->bi_bdev->bd_disk)
>  
>  #ifdef CONFIG_BLK_CGROUP
> -static inline struct blkcg_gq *bio_blkg(struct bio *bio)
> -{
> -	return bio->bi_blkg;
> -}
> -
> -void bio_associate_blkg(struct bio *bio);
> -void bio_associate_blkg_from_css(struct bio *bio,
> +void bio_associate_blkcg(struct bio *bio);
> +void bio_associate_blkcg_from_css(struct bio *bio,
>  				 struct cgroup_subsys_state *css);
> -void bio_clone_blkg_association(struct bio *dst, struct bio *src);
> +void bio_clone_blkcg_association(struct bio *dst, struct bio *src);
> +void bio_put_blkg_ref(struct bio *bio);
>  void blkcg_punt_bio_submit(struct bio *bio);
>  #else	/* CONFIG_BLK_CGROUP */
> -static inline struct blkcg_gq *bio_blkg(struct bio *bio)
> -{
> -	return NULL;
> -}
> -
> -static inline void bio_associate_blkg(struct bio *bio) { }
> -static inline void bio_associate_blkg_from_css(struct bio *bio,
> +static inline void bio_associate_blkcg(struct bio *bio) { }
> +static inline void bio_associate_blkcg_from_css(struct bio *bio,
>  					       struct cgroup_subsys_state *css)
>  { }
> -static inline void bio_clone_blkg_association(struct bio *dst,
> +static inline void bio_clone_blkcg_association(struct bio *dst,
>  					      struct bio *src) { }
> +static inline void bio_put_blkg_ref(struct bio *bio) { }
>  static inline void blkcg_punt_bio_submit(struct bio *bio)
>  {
>  	submit_bio(bio);
> @@ -534,10 +526,12 @@ static inline void blkcg_punt_bio_submit(struct bio *bio)
>  static inline void bio_set_dev(struct bio *bio, struct block_device *bdev)
>  {
>  	bio_clear_flag(bio, BIO_REMAPPED);
> -	if (bio->bi_bdev != bdev)
> +	if (bio->bi_bdev != bdev) {
> +		bio_put_blkg_ref(bio);
>  		bio_clear_flag(bio, BIO_BPS_THROTTLED);
> +	}
>  	bio->bi_bdev = bdev;
> -	bio_associate_blkg(bio);
> +	bio_associate_blkcg(bio);
>  }
>  
>  /*
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 8808ee76e73c..5f95c2e0e90b 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -246,12 +246,10 @@ struct bio {
>  	void			*bi_private;
>  #ifdef CONFIG_BLK_CGROUP
>  	/*
> -	 * Represents the association of the css and request_queue for the bio.
> -	 * If a bio goes direct to device, it will not have a blkg as it will
> -	 * not have a request_queue associated with it.  The reference is put
> -	 * on release of the bio.
> +	 * Represents the blkcg css association for the bio.  The reference is
> +	 * put on release of the bio.
>  	 */
> -	struct blkcg_gq		*bi_blkg;
> +	struct blkcg		*bi_blkcg;
>  	/* Time that this bio was issued. */
>  	u64			issue_time_ns;
>  #ifdef CONFIG_BLK_CGROUP_IOCOST
> @@ -309,6 +307,7 @@ enum {
>  	BIO_TRACE_COMPLETION,	/* bio_endio() should trace the final completion
>  				 * of this bio. */
>  	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
> +	BIO_BLKG_REF,		/* bio pins the associated blkg */
>  	BIO_QOS_THROTTLED,	/* bio went through rq_qos throttle path */
>  	/*
>  	 * This bio has completed bps throttling at the single tg granularity,
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index 62552a2ce5b9..4f869fe9cc90 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -262,7 +262,7 @@ static inline void wbc_init_bio(struct writeback_control *wbc, struct bio *bio)
>  	 * regular writeback instead of writing things out itself.
>  	 */
>  	if (wbc->wb)
> -		bio_associate_blkg_from_css(bio, wbc->wb->blkcg_css);
> +		bio_associate_blkcg_from_css(bio, wbc->wb->blkcg_css);
>  }
>  
>  void inode_switch_wbs_work_fn(struct work_struct *work);
> diff --git a/mm/page_io.c b/mm/page_io.c
> index b23f494fcc83..112e50475605 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -316,7 +316,7 @@ static inline void count_swpout_vm_event(struct folio *folio)
>  }
>  
>  #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
> -static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
> +static void bio_associate_blkcg_from_page(struct bio *bio, struct folio *folio)
>  {
>  	struct cgroup_subsys_state *css;
>  	struct mem_cgroup *memcg;
> @@ -331,12 +331,12 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
>  		css = NULL;
>  	rcu_read_unlock();
>  
> -	bio_associate_blkg_from_css(bio, css);
> +	bio_associate_blkcg_from_css(bio, css);
>  	if (css)
>  		css_put(css);
>  }
>  #else
> -#define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
> +#define bio_associate_blkcg_from_page(bio, folio)	do { } while (0)
>  #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
>  
>  struct swap_iocb {
> @@ -436,7 +436,7 @@ static void swap_writepage_bdev_sync(struct folio *folio,
>  	bio.bi_iter.bi_sector = swap_folio_sector(folio);
>  	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
>  
> -	bio_associate_blkg_from_page(&bio, folio);
> +	bio_associate_blkcg_from_page(&bio, folio);
>  	count_swpout_vm_event(folio);
>  
>  	folio_start_writeback(folio);
> @@ -456,7 +456,7 @@ static void swap_writepage_bdev_async(struct folio *folio,
>  	bio->bi_end_io = end_swap_bio_write;
>  	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
>  
> -	bio_associate_blkg_from_page(bio, folio);
> +	bio_associate_blkcg_from_page(bio, folio);
>  	count_swpout_vm_event(folio);
>  	folio_start_writeback(folio);
>  	folio_unlock(folio);

