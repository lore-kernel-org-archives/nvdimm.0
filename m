Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA1D4749D6
	for <nvdimm@lists.linux.dev>; Tue, 28 Jul 2026 21:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274189; cv=none; b=QWBDyiFxBaWkZRpSKstx84RqEsw8DGEUUNBWnQem78T2toV9G1ENMaJy0nKkSDUiV4gfI9xNmQhj6T7lysQqE6A8gYBfiePWLOM9nN4bGXkiky7tgTQ68zv/bk2hVx3b0dssF7bfFpfYOcpqAREy7VvlRS13Wk+RbLnEkPd7vvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274189; c=relaxed/simple;
	bh=8yRbEO++iTcA/G8BwhiTKliLJ96XVYkzIbVjtqXOKAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nk/SIi9V0M+gKzUb5zGIIc/K+0Phw35MLD5JQtI4mD9uS2/cvH/A76oze/KRtzx2xFaEPz+6PV2FRzzxkJvMfKV0t9PXzD4HVakjrpRXGmIFDJ+w2oEX/fmkEKJQl4yaIKteCkj1RSITuN14Id0J3veexvB87rdnnc24Q/pPwZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PdzVrmr8; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PdzVrmr8"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47f93b2fe4cso251188f8f.0
        for <nvdimm@lists.linux.dev>; Tue, 28 Jul 2026 14:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274184; x=1785878984; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iBN3SQvgAk1mGu4ez/R3TV3miu7aixLGLTkcg4qPyXo=;
        b=PdzVrmr8bluW0k2lADNcL2a3DOVar/rcEjFZWXb1u6irBcyB6ZJffiosZCvUfX6Yf6
         deSkIK7ftz1c+iI3JzoQR3WNSCofTqdh9NqKAgHgESP7GY3XToOSNFsjURtUHF/h1gY0
         1zIMgb32VNBSPD5UG3BoS8PgQcrp2mwvljzx8OYFt/0lqfdVGzF81wnKEete0tIlBgeG
         Hdm077uGgV5n7liPw8CztluFPAmXQG8rUmWSl54TQ2qEkviz117NC2CgTYvUotrL7Cjx
         FbSWa18TaYXkFwY4cBXl9YvaUvvaMK8OdT2ZVlHwBE6e7Q92hhhnI8meLUAy7D81pjeI
         5Y3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274184; x=1785878984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iBN3SQvgAk1mGu4ez/R3TV3miu7aixLGLTkcg4qPyXo=;
        b=jOV/y2ZgcPOTNWMQY2p2ciiKH1N51WcRmaMogfBdFLzhzMgE59VEHeS+Oh51raWEhf
         c8zRvbZ4p2C4+gKO9W/uzgUlZQvLY98vlXpCRixCP9K6voz428qHI4X/kBgFu6q5TGdx
         H3qXKOgDAziEZJJECzEHnVj+VHgP0gf0MqCg4AAkuDNxi1/ze4ZYRxkUbYl344jTv4Cr
         X+x8tsGTZzIhQYACYBFNPU4k7x9TDPIAJ0CTuFjzt1U0q/VdjzF/bnvbz+G+LgokkIRe
         t2tWiKZ0lIQtanREMNzy8Uqyjgu8YKqJz26RHJHqlNH81je7ptlYj0zeYlqbgmBjZwlj
         KRSw==
X-Forwarded-Encrypted: i=1; AHgh+RqRGfIclZ0ivUDAWDjozm4f5CvDVtbrDLnh/twppAyI3ho7jGvgbd6yi3ca1YvSGawdQBVGpDY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqpZhzwctbAYPXW350aiyYverm6l8lkmA5IAd1aol0ys3SfF0F
	9bvVdYxI/eIOMWr0G9QejY1UIlbpYDZ63A+wGigeTdFU7Kgw0DUscYC+
X-Gm-Gg: AR+sD136Wg1wf0OZ6lOl1EnmCk0EnWwdBlxBbH4ybiLSFsOtXG/RXZXmnE0qyjSEZNL
	+egjn0LPhXP9VL58AaJNsXY17lPbekpzFEYMIdaui1qUp1ZBhU86MhoBuYuyez7izgWKLSV5S5F
	u5Soh/XFKieoBLYk17dihH4oHCO+5GgUGbCEgWrT1P945J5F0+wUfwW4QUKo+n4WcQraYhuOS1J
	hL2SulFtzHtkP35s8+iyMEgexloaqbg3mnRJ/8Z3Gl2lluj0hUzYeHzPc2Uby8t6+uDJxOwghq2
	w1SsAWpkrhT/SSRDDkdEC5tAbAwMfTjeNROU0aaVHFgNu3OJjprt85mdDg1Hl7qZuC9hinQtg7R
	BDNJmvC0ccg43UueBN8E6ic00TOm+Ti0WDqGgi6XIn25f/xmqnFqDO2RY2BcJDuhhUHFq0/sUPH
	ZJ5S0Dd8g/2jL0RrfuZuWP4cahmlF6RdJLB0j1jOS2id3NpzV3ODesOdaa9FFXdstlw2s1cgg+s
	Hp2pAwH
X-Received: by 2002:a5d:6f13:0:b0:47f:6f6a:6a7f with SMTP id ffacd0b85a97d-47fb1e87620mr4179911f8f.8.1785274184387;
        Tue, 28 Jul 2026 14:29:44 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:29:42 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
Subject: [PATCH v4 01/14] dma-buf: introduce initial file I/O infrastructure
Date: Tue, 28 Jul 2026 22:29:13 +0100
Message-ID: <bc20381e8daf85ac58811c344325d8192cde9d1e.1785274111.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785274111.git.asml.silence@gmail.com>
References: <cover.1785274111.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The goal is to be able to natively use dma-buf in the read-write / IO
path. This patch adds basic building blocks serving as a glue and API
between drivers and upper layer subsystems providing the uAPI. Later
patches implement it for NVMe raw block devices and expose it to the
user space via io_uring.

There are two main objects. struct dma_buf_io_ctx and struct
dma_buf_io_map. The ctx is used during initial registration and serves
as an interface between the upper layer user like io_uring and to the
importer subsystem / driver. The map represents the actual dma map
established for the target device[s] with dma_buf_map_attachment() and
stored in a device specific format. The context is created via a new
file operation ->init_dma_buf_io_ctx.

The ctx-map separation exists to support map invalidation (see
dma_buf_io_invalidate_mappings()). A ctx can create
multiple maps during its lifetime, but there can only be no more than
one (active) map attached to it. Invalidation drops the active map
if present, and the next map will only be attempted to be created
once there is a new request that wants to use the dma-buf IO ctx.

The primary task of the dma_buf_io_map object is to count requests
using it and to wait for their completion when we want to destroy the
DMA map. Invalidation is delayed by inserting a dma fence, which is
signaled when all flight requests are completed.

[un]mapping and any work with dma addresses is delegated to the
importer driver via an ops table stored in the ctx, see struct
dma_buf_io_ops. Only the target driver / subsystem knows about devices
it wants to use the dma-buf with, especially in case of multi-device
filesystems or stacking in the future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/dma-buf/Makefile     |   2 +-
 drivers/dma-buf/dma-buf-io.c | 275 +++++++++++++++++++++++++++++++++++
 include/linux/dma-buf-io.h   |  91 ++++++++++++
 include/linux/fs.h           |   2 +
 4 files changed, 369 insertions(+), 1 deletion(-)
 create mode 100644 drivers/dma-buf/dma-buf-io.c
 create mode 100644 include/linux/dma-buf-io.h

diff --git a/drivers/dma-buf/Makefile b/drivers/dma-buf/Makefile
index b25d7550bacf..523731b0f83e 100644
--- a/drivers/dma-buf/Makefile
+++ b/drivers/dma-buf/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-y := dma-buf.o dma-fence.o dma-fence-array.o dma-fence-chain.o \
-	 dma-fence-unwrap.o dma-resv.o dma-buf-mapping.o
+	 dma-fence-unwrap.o dma-resv.o dma-buf-mapping.o dma-buf-io.o
 obj-$(CONFIG_DMABUF_HEAPS)	+= dma-heap.o
 obj-$(CONFIG_DMABUF_HEAPS)	+= heaps/
 obj-$(CONFIG_SYNC_FILE)		+= sync_file.o
diff --git a/drivers/dma-buf/dma-buf-io.c b/drivers/dma-buf/dma-buf-io.c
new file mode 100644
index 000000000000..5f545a1bcf32
--- /dev/null
+++ b/drivers/dma-buf/dma-buf-io.c
@@ -0,0 +1,275 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Common infrastructure for supporing dma-buf in the I/O path.
+ *
+ * Copyright (C) 2026 Pavel Begunkov <asml.silence@gmail.com>
+ */
+#include <linux/dma-buf-io.h>
+#include <linux/dma-resv.h>
+
+struct dma_buf_io_fence {
+	struct dma_fence base;
+	spinlock_t lock;
+};
+
+static const char *dma_buf_io_fence_drv_name(struct dma_fence *fence)
+{
+	/* default fence release kfree's the base pointer */
+	BUILD_BUG_ON(offsetof(struct dma_buf_io_fence, base));
+
+	return "dma-buf-io-ctx";
+}
+
+static const char *dma_buf_io_fence_timeline_name(struct dma_fence *fence)
+{
+	return "dma-buf-io-ctx";
+}
+
+const struct dma_fence_ops dma_buf_io_fence_ops = {
+	.get_driver_name = dma_buf_io_fence_drv_name,
+	.get_timeline_name = dma_buf_io_fence_timeline_name,
+};
+
+static void dma_buf_io_ctx_destroy_work(struct work_struct *work)
+{
+	struct dma_buf_io_ctx *ctx = container_of(work, struct dma_buf_io_ctx,
+						  release_work);
+
+	if (WARN_ON_ONCE(refcount_read(&ctx->refs)))
+		return;
+
+	ctx->dev_ops->release(ctx);
+	dma_buf_put(ctx->dmabuf);
+	kfree(ctx);
+}
+
+static void dma_buf_io_map_release_work(struct work_struct *work)
+{
+	struct dma_buf_io_map *map = container_of(work, struct dma_buf_io_map,
+						  release_work);
+	struct dma_buf_io_fence *fence = map->fence;
+	struct dma_buf_io_ctx *ctx = map->ctx;
+	struct dma_buf *dmabuf = ctx->dmabuf;
+
+	/* the release path must wait for fences */
+	if (WARN_ON_ONCE(refcount_read(&ctx->refs) == 0))
+		return;
+
+	/* Prevent from destoying the ctx while unmapping */
+	refcount_inc(&ctx->refs);
+
+	/*
+	 * There are no more requests using the map, we can signal the fence.
+	 * It should be done before taking the resv lock as someone could be
+	 * waiting for the fence while holding the lock.
+	 */
+	dma_fence_signal(&fence->base);
+
+	dma_resv_lock(dmabuf->resv, NULL);
+	ctx->dev_ops->unmap(ctx, map);
+	dma_resv_unlock(dmabuf->resv);
+
+	dma_fence_put(&fence->base);
+	percpu_ref_exit(&map->refs);
+	kfree(map);
+
+	if (refcount_dec_and_test(&ctx->refs)) {
+		/*
+		 * Destruction needs to wait for I/O and dma fences. Defer it to
+		 * simplify locking.
+		 */
+		INIT_WORK(&ctx->release_work, dma_buf_io_ctx_destroy_work);
+		queue_work(system_wq, &ctx->release_work);
+	}
+}
+
+static void dma_buf_io_map_refs_release(struct percpu_ref *ref)
+{
+	struct dma_buf_io_map *map = container_of(ref, struct dma_buf_io_map, refs);
+
+	/* might sleep, use a worker */
+	INIT_WORK(&map->release_work, dma_buf_io_map_release_work);
+	queue_work(system_wq, &map->release_work);
+}
+
+int dma_buf_io_init_map(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map)
+{
+	struct dma_buf_io_fence *fence = NULL;
+	int ret;
+
+	fence = kzalloc(sizeof(*fence), GFP_KERNEL);
+	if (!fence)
+		return -ENOMEM;
+
+	ret = percpu_ref_init(&map->refs, dma_buf_io_map_refs_release, 0, GFP_KERNEL);
+	if (ret) {
+		kfree(fence);
+		return ret;
+	}
+
+	spin_lock_init(&fence->lock);
+	dma_fence_init(&fence->base, &dma_buf_io_fence_ops, &fence->lock,
+			ctx->fence_ctx, atomic_inc_return(&ctx->fence_seq));
+	map->fence = fence;
+	map->ctx = ctx;
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_io_init_map, "DMA_BUF");
+
+struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx)
+{
+	struct dma_buf *dmabuf = ctx->dmabuf;
+	struct dma_buf_io_map *map;
+	long ret;
+
+retry:
+	/*
+	 * ->dmabuf_map() will be calling dma_buf_map_attachment(), for which
+	 * we'll need to wait for fences. Do a bit nicer and try to wait
+	 * without the resv lock first.
+	 */
+	ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
+				    true, MAX_SCHEDULE_TIMEOUT);
+	if (!ret)
+		ret = -EAGAIN;
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	ret = dma_resv_lock_interruptible(dmabuf->resv, NULL);
+	if (ret)
+		return ERR_PTR(ret);
+
+	map = dma_buf_io_get_map(ctx);
+	if (map) {
+		ret = 0;
+		goto out;
+	}
+
+	if (dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
+				  true, 0) < 0) {
+		dma_resv_unlock(dmabuf->resv);
+		goto retry;
+	}
+
+	map = ctx->dev_ops->map(ctx);
+	if (IS_ERR(map)) {
+		ret = PTR_ERR(map);
+		goto out;
+	}
+
+	percpu_ref_get(&map->refs);
+	rcu_assign_pointer(ctx->map, map);
+out:
+	dma_resv_unlock(dmabuf->resv);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	return map;
+}
+
+static void dma_buf_io_drop_map(struct dma_buf_io_ctx *ctx)
+{
+	struct dma_buf *dmabuf = ctx->dmabuf;
+	struct dma_buf_io_map *map;
+	int ret;
+
+	dma_resv_assert_held(dmabuf->resv);
+
+	map = rcu_dereference_protected(ctx->map,
+					dma_resv_held(dmabuf->resv));
+	if (!map)
+		return;
+	rcu_assign_pointer(ctx->map, NULL);
+
+	ret = dma_resv_reserve_fences(dmabuf->resv, 1);
+	if (WARN_ON_ONCE(ret)) {
+		struct dma_fence *fence = &map->fence->base;
+
+		dma_fence_get(fence);
+		percpu_ref_kill(&map->refs);
+		dma_fence_wait(fence, false);
+		dma_fence_put(fence);
+		return;
+	}
+
+	dma_resv_add_fence(dmabuf->resv, &map->fence->base,
+			   DMA_RESV_USAGE_KERNEL);
+	/*
+	 * Delay destruction until all inflight requests using the map are
+	 * gone. It'll also signal the fence then.
+	 */
+	percpu_ref_kill(&map->refs);
+}
+
+void dma_buf_io_invalidate_mappings(struct dma_buf_io_ctx *ctx)
+{
+	dma_buf_io_drop_map(ctx);
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_io_invalidate_mappings, "DMA_BUF");
+
+static void dma_buf_io_ctx_release_work(struct work_struct *work)
+{
+	struct dma_buf_io_ctx *ctx = container_of(work, struct dma_buf_io_ctx,
+						  release_work);
+	struct dma_buf *dmabuf = ctx->dmabuf;
+	long ret;
+
+	dma_resv_lock(dmabuf->resv, NULL);
+	/* Remove the last map, there should be no new ones going forward. */
+	dma_buf_io_drop_map(ctx);
+	dma_resv_unlock(dmabuf->resv);
+
+	/* Wait until all maps are destroyed. */
+	ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
+				    false, MAX_SCHEDULE_TIMEOUT);
+
+	if (WARN_ON_ONCE(ret <= 0))
+		return;
+	if (WARN_ON_ONCE(rcu_dereference_protected(ctx->map, true)))
+		return;
+
+	if (refcount_dec_and_test(&ctx->refs))
+		dma_buf_io_ctx_destroy_work(&ctx->release_work);
+}
+
+void dma_buf_io_ctx_release(struct dma_buf_io_ctx *ctx)
+{
+	/*
+	 * Destruction needs to wait for I/O and dma fences. Defer it to
+	 * simplify locking.
+	 */
+	INIT_WORK(&ctx->release_work, dma_buf_io_ctx_release_work);
+	queue_work(system_wq, &ctx->release_work);
+}
+
+int dma_buf_io_ctx_create(struct file *file,
+			   struct dma_buf_io_ctx *ctx,
+			   struct dma_buf *dmabuf,
+			   enum dma_data_direction dir)
+{
+	int ret;
+
+	if (!file->f_op->init_dma_buf_io_ctx)
+		return -EOPNOTSUPP;
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->fence_ctx = dma_fence_context_alloc(1);
+	ctx->dir = dir;
+	ctx->dmabuf = dmabuf;
+	refcount_set(&ctx->refs, 1);
+	get_dma_buf(dmabuf);
+
+	ret = file->f_op->init_dma_buf_io_ctx(file, ctx);
+	if (ret) {
+		memset(ctx, 0, sizeof(*ctx));
+		dma_buf_put(dmabuf);
+		return ret;
+	}
+
+	if (WARN_ON_ONCE(!ctx->dev_ops ||
+			 !ctx->dev_ops->map ||
+			 !ctx->dev_ops->unmap ||
+			 !ctx->dev_ops->release))
+		return -EINVAL;
+
+	return ret;
+}
diff --git a/include/linux/dma-buf-io.h b/include/linux/dma-buf-io.h
new file mode 100644
index 000000000000..bcffc6202556
--- /dev/null
+++ b/include/linux/dma-buf-io.h
@@ -0,0 +1,91 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __DMA_BUF_IO_H__
+#define __DMA_BUF_IO_H__
+
+#include <linux/dma-buf.h>
+
+struct dma_buf_io_fence;
+struct dma_buf_io_ctx;
+struct dma_buf_io_map;
+
+struct dma_buf_io_ops {
+	/*
+	 * Create a new map for the given ctx. Called with the reservation
+	 * lock held.
+	 */
+	struct dma_buf_io_map *(*map)(struct dma_buf_io_ctx *ctx);
+
+	/*
+	 * Clean up device specific parts of the @map. Called with the
+	 * reservation lock held.
+	 */
+	void (*unmap)(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map);
+
+	/*
+	 * The user tries to destroy the ctx. Release all device specific
+	 * parts of the token.
+	 */
+	void (*release)(struct dma_buf_io_ctx *);
+};
+
+struct dma_buf_io_map {
+	/*
+	 * Counts attached requests and other users. Device specific unmapping
+	 * is deferred until all refs are dropped.
+	 */
+	struct percpu_ref		refs;
+
+	struct work_struct		release_work;
+	struct dma_buf_io_fence		*fence;
+	struct dma_buf_io_ctx		*ctx;
+};
+
+struct dma_buf_io_ctx {
+	struct dma_buf_io_map __rcu		*map;
+	struct dma_buf				*dmabuf;
+	enum dma_data_direction			dir;
+
+	atomic_t				fence_seq;
+	u64					fence_ctx;
+	struct work_struct			release_work;
+	refcount_t				refs;
+
+	void					*dev_priv;
+	const struct dma_buf_io_ops		*dev_ops;
+};
+
+int dma_buf_io_ctx_create(struct file *file,
+			   struct dma_buf_io_ctx *ctx,
+			   struct dma_buf *dmabuf,
+			   enum dma_data_direction dir);
+void dma_buf_io_ctx_release(struct dma_buf_io_ctx *ctx);
+
+struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx);
+
+static inline struct dma_buf_io_map *
+dma_buf_io_get_map(struct dma_buf_io_ctx *ctx)
+{
+	struct dma_buf_io_map *map;
+
+	guard(rcu)();
+
+	map = rcu_dereference(ctx->map);
+	if (unlikely(!map || !percpu_ref_tryget_live_rcu(&map->refs)))
+		return NULL;
+
+	return map;
+}
+
+static inline void dma_buf_io_map_drop(struct dma_buf_io_map *map)
+{
+	percpu_ref_put(&map->refs);
+}
+
+/*
+ * Device API
+ */
+
+void dma_buf_io_invalidate_mappings(struct dma_buf_io_ctx *ctx);
+int dma_buf_io_init_map(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map);
+
+#endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d10897b3a1e3..9fe349a279c7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1914,6 +1914,7 @@ struct dir_context {
 #define COPY_FILE_SPLICE		(1 << 0)
 
 struct io_uring_cmd;
+struct dma_buf_io_ctx;
 struct offset_ctx;
 
 typedef unsigned int __bitwise fop_flags_t;
@@ -1962,6 +1963,7 @@ struct file_operations {
 	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
 				unsigned int poll_flags);
 	int (*mmap_prepare)(struct vm_area_desc *);
+	int (*init_dma_buf_io_ctx)(struct file *, struct dma_buf_io_ctx *);
 } __randomize_layout;
 
 /* Supports async buffered reads */
-- 
2.54.0

