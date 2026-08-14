Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F48E344DAE;
	Fri, 14 Aug 2026 06:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786689947; cv=none; b=PjUkBlOaNPr/BzJjCcL6mu3C3KOa+TKmzXBMYtyguzLX90KGtI/n6IS5NNxr+QoexhXvZRiCaSDndmuMb11LsdKOeFYebisJJy9JQxc6ykNDOV0rSfB4OfF2y1nwSiSmDPSpiI7typn534EpRtPYUryd4PbSH8fHcYgZbu014j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786689947; c=relaxed/simple;
	bh=zduZt5Yh8aK/cbqDe9szF+IP3dE7uqQwAz10EKTvkpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VTUrimSUQYBw8tSAxhgJIqMWrE+hZooS75hgNOIr63ixyxFpfDvzu9t/rYL6mYC6PB9CmSk1sYpb9xMBUDROGzz1S8PBYsSW/pfmtAXdxsYGQT0lh8PeufFfKHMWHg+wwl2xEPnZnZsz/UFwKwXLz6swjcN42kEym7fHC5uEvMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 61FB168BFE; Fri, 14 Aug 2026 08:45:37 +0200 (CEST)
Date: Fri, 14 Aug 2026 08:45:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Yu Kuai <yukuai@fygo.io>, Christoph Hellwig <hch@lst.de>,
	Tao Cui <cui.tao@linux.dev>, Jan Kara <jack@suse.cz>,
	Ming Lei <ming.lei@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 0/4] blk-cgroup: store blkcg in bio before
 blkcg_mutex conversion
Message-ID: <20260814064537.GA9355@lst.de>
References: <20260811064744.1139446-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811064744.1139446-1-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

What tree does this apply to?  I get failures both for Jens'
for-7.3/block and for-next trees in bfq-cgroups.c and bio.c

On Tue, Aug 11, 2026 at 02:47:40PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai@fygo.io>
> 
> This RFC remains a preparatory series for the blkcg_mutex conversion
> proposed in the related blkcg_mutex RFC v2 series [1].  That conversion
> moves queue-local blkg topology synchronization from q->queue_lock to
> q->blkcg_mutex, which is awkward while bios directly store queue-local
> blkg references.
> 
> v1 made the stored bio association queue-independent by replacing bi_blkg
> with bi_blkcg, but a bio-owned blkg reference still had to be recovered by
> looking up the bio's blkcg and current request_queue.  Tao Cui reported that
> cgroup removal deletes a dying blkg from the per-blkcg radix tree before a
> throttled bio drops its reference.  A later lookup for that pinned blkg then
> fails, triggers the warning in bio_pinned_blkg(), and leaks the reference.
> 
> v2 makes request_queue the authoritative lookup owner before converting the
> bio association.  A queue-owned rhashtable, keyed by the blkcg CSS ID, keeps
> dying blkgs discoverable until their references drain while q->blkg_list
> remains available for ordered walks.  The bio conversion then stores and
> pins the blkcg CSS, lazily creates a blkg only for users which need one, and
> uses lookup-only access for completion and accounting paths which already
> own a blkg reference.  Async bio punt state is finally moved from blkg to
> blkcg so punting alone does not instantiate a queue-local blkg.
> 
> Changes since v1:
> 
>   - Add patch 1 to wait for every old blkg to leave q->blkg_list before a
>     shared request_queue is rebound, instead of treating root_blkg == NULL
>     as completion of asynchronous blkg teardown.
>   - Add patch 2 to replace the per-blkcg radix tree and lookup hint with a
>     request_queue rhashtable keyed by blkcg->css.id, as suggested by
>     Christoph Hellwig.  Keep dying pinned blkgs in the hash until
>     blkg_release() so bio-owned references remain discoverable.
>   - Fold the v1 helper-only patch into patch 3, as suggested by Jan Kara and
>     Christoph Hellwig, and make bio_blkcg() naturally return NULL for an
>     unassociated bio.
>   - Rework patch 3 so blkg_lookup_create() acquires the bio-owned reference,
>     falls back to a live parent when creation or tryget fails, and updates
>     bi_blkcg when the returned blkg belongs to an ancestor.
>   - Make bio_blkg_lookup() lookup-only: it returns NULL unless BIO_BLKG_REF
>     is already set.  Use bio_blkg() in the BFQ and IOCOST merge paths which
>     may need to create a blkg, while keeping blk_cgroup_bio_start() and
>     completion paths lookup-only.
>   - Move CSS online-reference handling into
>     bio_associate_blkcg_from_css(), including fallback to the root blkcg, so
>     bio_associate_blkcg() does not take a redundant reference.
>   - Keep the v1 async bio punt conversion as patch 4 and document that
>     async_bio_lock protects async_bios.
> 
> Previous versions:
>   v1: https://lore.kernel.org/r/20260804065313.2092022-1-yukuai@kernel.org
> 
> Related series:
>   [1] RFC v2 blk-cgroup: protect blkgs with blkcg_mutex
>       https://lore.kernel.org/r/20260724123037.3004560-1-yukuai@kernel.org
> 
> Yu Kuai (4):
>   blk-cgroup: wait for old blkgs to leave queue before disk rebind
>   blk-cgroup: use a request_queue rhashtable for blkg lookup
>   blk-cgroup: store blkcg in bio instead of blkg
>   blk-cgroup: move async bio punt state to blkcg
> 
>  Documentation/admin-guide/cgroup-v2.rst |   2 +-
>  block/bfq-cgroup.c                      |  16 +-
>  block/bfq-iosched.c                     |  19 +-
>  block/bio.c                             |  22 +-
>  block/blk-cgroup-fc-appid.c             |  10 +-
>  block/blk-cgroup.c                      | 348 ++++++++++++++----------
>  block/blk-cgroup.h                      |  82 ++++--
>  block/blk-core.c                        |   9 +-
>  block/blk-crypto-fallback.c             |   2 +-
>  block/blk-iocost.c                      |  12 +-
>  block/blk-iolatency.c                   |  11 +-
>  block/blk-ioprio.c                      |   2 +-
>  block/blk-throttle.c                    |   2 +-
>  block/blk-throttle.h                    |   2 +-
>  drivers/md/bcache/request.c             |   2 +-
>  drivers/md/dm.c                         |   2 +-
>  drivers/md/md.c                         |   2 +-
>  drivers/nvdimm/nd_virtio.c              |   2 +-
>  fs/gfs2/lops.c                          |   3 +-
>  include/linux/bio.h                     |  26 +-
>  include/linux/blk_types.h               |   9 +-
>  include/linux/blkdev.h                  |   2 +
>  include/linux/writeback.h               |   2 +-
>  mm/page_io.c                            |  13 +-
>  24 files changed, 357 insertions(+), 245 deletions(-)
> 
> 
> base-commit: f2690679ecf3a3151688ebef766dd2512ff95854
> -- 
> 2.51.0
---end quoted text---
