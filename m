Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C785B4749D7;
	Tue,  4 Aug 2026 16:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785860651; cv=none; b=p6dnbERCDfmrrK/VMvl9Zzoh/V2ePHGWdA4hmDEuiiXGL0lKfoNztNMWZj+gSWxsLxMm9Uk3lO6uXuYHfT4wO7hGJARB28vWBL/FoipMvJYhKl8xC/7vUFaNOuc7cITK8QDiYB2+JGXaVHBJRHsjx98MgWf92EhjbgvHwbnTCGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785860651; c=relaxed/simple;
	bh=28YYmga+DL8MFMBNozmj0/yjaVXYhbpGPYxfPoAVA5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oEurcube8O8RQElZQJmeZjJfZlg59zT86krX4sbUWjJm+zs+xjIhdRBMojQhbKIqTHtFAUgqz3vWL5rtftjI5YFrPSzAoItL66I0CMuBkEjk0zifQFgeCso3hmxhK/OwsnwQaPvpAH+5udCK5mi3rPkAd+T0E2nCUflDAEH9pV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 344876732A; Tue,  4 Aug 2026 18:24:03 +0200 (CEST)
Date: Tue, 4 Aug 2026 18:24:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>, Ilya Dryomov <idryomov@gmail.com>,
	dm-devel@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v5 01/16] dma-buf: introduce initial file I/O
 infrastructure
Message-ID: <20260804162402.GA12292@lst.de>
References: <cover.1785596451.git.asml.silence@gmail.com> <ff5dccf71e8c03d62797352c4bb5fbb7c6c759c8.1785596451.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff5dccf71e8c03d62797352c4bb5fbb7c6c759c8.1785596451.git.asml.silence@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Aug 01, 2026 at 04:46:13PM +0100, Pavel Begunkov wrote:
> The goal is to be able to natively use dma-buf in the read-write / IO
> path. This patch adds basic building blocks serving as a glue and API
> between drivers and upper layer subsystems providing the uAPI. Later
> patches implement it for NVMe raw block devices and expose it to the
> user space via io_uring.
> 
> There are two main objects. struct dma_buf_io_ctx and struct
> dma_buf_io_map. The ctx is used during initial registration and serves
> as an interface between the upper layer user like io_uring and to the
> importer subsystem / driver. The map represents the actual dma map
> established for the target device[s] with dma_buf_map_attachment() and
> stored in a device specific format. The context is created via a new
> file operation ->init_dma_buf_io_ctx.
> 
> The ctx-map separation exists to support map invalidation (see
> dma_buf_io_invalidate_mappings()). A ctx can create
> multiple maps during its lifetime, but there can only be no more than
> one (active) map attached to it. Invalidation drops the active map
> if present, and the next map will only be attempted to be created
> once there is a new request that wants to use the dma-buf IO ctx.
> 
> The primary task of the dma_buf_io_map object is to count requests
> using it and to wait for their completion when we want to destroy the
> DMA map. Invalidation is delayed by inserting a dma fence, which is
> signaled when all flight requests are completed.
> 
> [un]mapping and any work with dma addresses is delegated to the
> importer driver via an ops table stored in the ctx, see struct
> dma_buf_io_ops. Only the target driver / subsystem knows about devices
> it wants to use the dma-buf with, especially in case of multi-device
> filesystems or stacking in the future.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  drivers/dma-buf/Makefile     |   2 +-
>  drivers/dma-buf/dma-buf-io.c | 278 +++++++++++++++++++++++++++++++++++
>  include/linux/dma-buf-io.h   |  92 ++++++++++++
>  include/linux/fs.h           |   2 +
>  4 files changed, 373 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/dma-buf/dma-buf-io.c
>  create mode 100644 include/linux/dma-buf-io.h
> 
> diff --git a/drivers/dma-buf/Makefile b/drivers/dma-buf/Makefile
> index b25d7550bacf..523731b0f83e 100644
> --- a/drivers/dma-buf/Makefile
> +++ b/drivers/dma-buf/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-y := dma-buf.o dma-fence.o dma-fence-array.o dma-fence-chain.o \
> -	 dma-fence-unwrap.o dma-resv.o dma-buf-mapping.o
> +	 dma-fence-unwrap.o dma-resv.o dma-buf-mapping.o dma-buf-io.o
>  obj-$(CONFIG_DMABUF_HEAPS)	+= dma-heap.o
>  obj-$(CONFIG_DMABUF_HEAPS)	+= heaps/
>  obj-$(CONFIG_SYNC_FILE)		+= sync_file.o
> diff --git a/drivers/dma-buf/dma-buf-io.c b/drivers/dma-buf/dma-buf-io.c
> new file mode 100644
> index 000000000000..24f58f80c45c
> --- /dev/null
> +++ b/drivers/dma-buf/dma-buf-io.c
> @@ -0,0 +1,278 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Common infrastructure for supporing dma-buf in the I/O path.
> + *
> + * Copyright (C) 2026 Pavel Begunkov <asml.silence@gmail.com>
> + */
> +#include <linux/dma-buf-io.h>
> +#include <linux/dma-resv.h>
> +
> +struct dma_buf_io_fence {
> +	struct dma_fence base;
> +	spinlock_t lock;
> +};
> +
> +static const char *dma_buf_io_fence_drv_name(struct dma_fence *fence)
> +{
> +	/* default fence release kfree's the base pointer */
> +	BUILD_BUG_ON(offsetof(struct dma_buf_io_fence, base));
> +
> +	return "dma-buf-io-ctx";
> +}
> +
> +static const char *dma_buf_io_fence_timeline_name(struct dma_fence *fence)
> +{
> +	return "dma-buf-io-ctx";
> +}
> +
> +const struct dma_fence_ops dma_buf_io_fence_ops = {
> +	.get_driver_name = dma_buf_io_fence_drv_name,
> +	.get_timeline_name = dma_buf_io_fence_timeline_name,
> +};
> +
> +static void dma_buf_io_ctx_destroy_work(struct work_struct *work)
> +{
> +	struct dma_buf_io_ctx *ctx = container_of(work, struct dma_buf_io_ctx,
> +						  release_work);
> +
> +	if (WARN_ON_ONCE(refcount_read(&ctx->refs)))
> +		return;
> +
> +	ctx->dev_ops->release(ctx);
> +	dma_buf_put(ctx->dmabuf);
> +	kfree(ctx);
> +}
> +
> +static void dma_buf_io_map_release_work(struct work_struct *work)
> +{
> +	struct dma_buf_io_map *map = container_of(work, struct dma_buf_io_map,
> +						  release_work);
> +	struct dma_buf_io_fence *fence = map->fence;
> +	struct dma_buf_io_ctx *ctx = map->ctx;
> +	struct dma_buf *dmabuf = ctx->dmabuf;
> +
> +	/* the release path must wait for fences */
> +	if (WARN_ON_ONCE(refcount_read(&ctx->refs) == 0))
> +		return;
> +
> +	/* Prevent from destoying the ctx while unmapping */
> +	refcount_inc(&ctx->refs);
> +
> +	/*
> +	 * There are no more requests using the map, we can signal the fence.
> +	 * It should be done before taking the resv lock as someone could be
> +	 * waiting for the fence while holding the lock.
> +	 */
> +	dma_fence_signal(&fence->base);
> +
> +	dma_resv_lock(dmabuf->resv, NULL);
> +	ctx->dev_ops->unmap(ctx, map);
> +	dma_resv_unlock(dmabuf->resv);
> +
> +	dma_fence_put(&fence->base);
> +	percpu_ref_exit(&map->refs);
> +	kfree(map);
> +
> +	if (refcount_dec_and_test(&ctx->refs)) {
> +		/*
> +		 * Destruction needs to wait for I/O and dma fences. Defer it to
> +		 * simplify locking.
> +		 */
> +		INIT_WORK(&ctx->release_work, dma_buf_io_ctx_destroy_work);
> +		queue_work(system_wq, &ctx->release_work);
> +	}
> +}
> +
> +static void dma_buf_io_map_refs_release(struct percpu_ref *ref)
> +{
> +	struct dma_buf_io_map *map = container_of(ref, struct dma_buf_io_map, refs);
> +
> +	/* might sleep, use a worker */
> +	INIT_WORK(&map->release_work, dma_buf_io_map_release_work);
> +	queue_work(system_wq, &map->release_work);
> +}
> +
> +int dma_buf_io_init_map(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map)
> +{
> +	struct dma_buf_io_fence *fence = NULL;
> +	int ret;
> +
> +	fence = kzalloc(sizeof(*fence), GFP_KERNEL);
> +	if (!fence)
> +		return -ENOMEM;
> +
> +	ret = percpu_ref_init(&map->refs, dma_buf_io_map_refs_release, 0, GFP_KERNEL);
> +	if (ret) {
> +		kfree(fence);
> +		return ret;
> +	}
> +
> +	spin_lock_init(&fence->lock);
> +	dma_fence_init(&fence->base, &dma_buf_io_fence_ops, &fence->lock,
> +			ctx->fence_ctx, atomic_inc_return(&ctx->fence_seq));
> +	map->fence = fence;
> +	map->ctx = ctx;
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_io_init_map, "DMA_BUF");
> +
> +struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx)
> +{
> +	struct dma_buf *dmabuf = ctx->dmabuf;
> +	struct dma_buf_io_map *map;
> +	long ret;
> +
> +retry:
> +	/*
> +	 * ->dmabuf_map() will be calling dma_buf_map_attachment(), for which
> +	 * we'll need to wait for fences. Do a bit nicer and try to wait
> +	 * without the resv lock first.
> +	 */
> +	ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
> +				    true, MAX_SCHEDULE_TIMEOUT);
> +	if (!ret)
> +		ret = -EAGAIN;
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +
> +	ret = dma_resv_lock_interruptible(dmabuf->resv, NULL);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	map = dma_buf_io_get_map(ctx);
> +	if (map) {
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	if (dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
> +				  true, 0) < 0) {
> +		dma_resv_unlock(dmabuf->resv);
> +		goto retry;
> +	}
> +
> +	map = ctx->dev_ops->map(ctx);
> +	if (IS_ERR(map)) {
> +		ret = PTR_ERR(map);
> +		goto out;
> +	}
> +
> +	if (WARN_ON_ONCE(!map->seg_shift))
> +		return ERR_PTR(-EFAULT);
> +
> +	percpu_ref_get(&map->refs);
> +	rcu_assign_pointer(ctx->map, map);
> +out:
> +	dma_resv_unlock(dmabuf->resv);
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +	return map;
> +}
> +
> +static void dma_buf_io_drop_map(struct dma_buf_io_ctx *ctx)
> +{
> +	struct dma_buf *dmabuf = ctx->dmabuf;
> +	struct dma_buf_io_map *map;
> +	int ret;
> +
> +	dma_resv_assert_held(dmabuf->resv);
> +
> +	map = rcu_dereference_protected(ctx->map,
> +					dma_resv_held(dmabuf->resv));
> +	if (!map)
> +		return;
> +	rcu_assign_pointer(ctx->map, NULL);
> +
> +	ret = dma_resv_reserve_fences(dmabuf->resv, 1);
> +	if (WARN_ON_ONCE(ret)) {
> +		struct dma_fence *fence = &map->fence->base;
> +
> +		dma_fence_get(fence);
> +		percpu_ref_kill(&map->refs);
> +		dma_fence_wait(fence, false);
> +		dma_fence_put(fence);
> +		return;
> +	}
> +
> +	dma_resv_add_fence(dmabuf->resv, &map->fence->base,
> +			   DMA_RESV_USAGE_KERNEL);
> +	/*
> +	 * Delay destruction until all inflight requests using the map are
> +	 * gone. It'll also signal the fence then.
> +	 */
> +	percpu_ref_kill(&map->refs);
> +}
> +
> +void dma_buf_io_invalidate_mappings(struct dma_buf_io_ctx *ctx)
> +{
> +	dma_buf_io_drop_map(ctx);
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_io_invalidate_mappings, "DMA_BUF");
> +
> +static void dma_buf_io_ctx_release_work(struct work_struct *work)
> +{
> +	struct dma_buf_io_ctx *ctx = container_of(work, struct dma_buf_io_ctx,
> +						  release_work);
> +	struct dma_buf *dmabuf = ctx->dmabuf;
> +	long ret;
> +
> +	dma_resv_lock(dmabuf->resv, NULL);
> +	/* Remove the last map, there should be no new ones going forward. */
> +	dma_buf_io_drop_map(ctx);
> +	dma_resv_unlock(dmabuf->resv);
> +
> +	/* Wait until all maps are destroyed. */
> +	ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
> +				    false, MAX_SCHEDULE_TIMEOUT);
> +
> +	if (WARN_ON_ONCE(ret <= 0))
> +		return;
> +	if (WARN_ON_ONCE(rcu_dereference_protected(ctx->map, true)))
> +		return;
> +
> +	if (refcount_dec_and_test(&ctx->refs))
> +		dma_buf_io_ctx_destroy_work(&ctx->release_work);
> +}
> +
> +void dma_buf_io_ctx_release(struct dma_buf_io_ctx *ctx)
> +{
> +	/*
> +	 * Destruction needs to wait for I/O and dma fences. Defer it to
> +	 * simplify locking.
> +	 */
> +	INIT_WORK(&ctx->release_work, dma_buf_io_ctx_release_work);
> +	queue_work(system_wq, &ctx->release_work);
> +}
> +
> +int dma_buf_io_ctx_create(struct file *file,
> +			   struct dma_buf_io_ctx *ctx,
> +			   struct dma_buf *dmabuf,
> +			   enum dma_data_direction dir)
> +{
> +	int ret;
> +
> +	if (!file->f_op->init_dma_buf_io_ctx)
> +		return -EOPNOTSUPP;
> +
> +	memset(ctx, 0, sizeof(*ctx));
> +	ctx->fence_ctx = dma_fence_context_alloc(1);
> +	ctx->dir = dir;
> +	ctx->dmabuf = dmabuf;
> +	refcount_set(&ctx->refs, 1);
> +	get_dma_buf(dmabuf);
> +
> +	ret = file->f_op->init_dma_buf_io_ctx(file, ctx);
> +	if (ret) {
> +		memset(ctx, 0, sizeof(*ctx));
> +		dma_buf_put(dmabuf);
> +		return ret;
> +	}
> +
> +	if (WARN_ON_ONCE(!ctx->dev_ops ||
> +			 !ctx->dev_ops->map ||
> +			 !ctx->dev_ops->unmap ||
> +			 !ctx->dev_ops->release))
> +		return -EINVAL;
> +
> +	return ret;
> +}
> diff --git a/include/linux/dma-buf-io.h b/include/linux/dma-buf-io.h
> new file mode 100644
> index 000000000000..f31c7375ae91
> --- /dev/null
> +++ b/include/linux/dma-buf-io.h
> @@ -0,0 +1,92 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __DMA_BUF_IO_H__
> +#define __DMA_BUF_IO_H__
> +
> +#include <linux/dma-buf.h>
> +
> +struct dma_buf_io_fence;
> +struct dma_buf_io_ctx;
> +struct dma_buf_io_map;
> +
> +struct dma_buf_io_ops {
> +	/*
> +	 * Create a new map for the given ctx. Called with the reservation
> +	 * lock held.
> +	 */
> +	struct dma_buf_io_map *(*map)(struct dma_buf_io_ctx *ctx);
> +
> +	/*
> +	 * Clean up device specific parts of the @map. Called with the
> +	 * reservation lock held.
> +	 */
> +	void (*unmap)(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map);
> +
> +	/*
> +	 * The user tries to destroy the ctx. Release all device specific
> +	 * parts of the token.
> +	 */
> +	void (*release)(struct dma_buf_io_ctx *);
> +};
> +
> +struct dma_buf_io_map {
> +	/*
> +	 * Counts attached requests and other users. Device specific unmapping
> +	 * is deferred until all refs are dropped.
> +	 */
> +	struct percpu_ref		refs;

> +	unsigned			seg_shift;

Can you add a big fat comment explaining how seg_shift works here?
I'm looking at the later patch using it for splitting and am very
confused about it.

