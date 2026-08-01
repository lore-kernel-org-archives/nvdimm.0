Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC6C2D7DE9
	for <nvdimm@lists.linux.dev>; Sat,  1 Aug 2026 15:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599242; cv=none; b=m2Y1NOIByXVC6Ij2oAd40ayNmBdUAfXoye916iQ+UgkguEtaR3xLWdzgwGl/uvd4k9JFsb9xGpDkqoYafsbz8de5JsU5AQSYa/cFuyTX+DVtBytqtu2o+Gq2lybnWshkxYC02Lv3hHP8gEmWDZi73h8hgn9R669b8dY14ejiegA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599242; c=relaxed/simple;
	bh=7PmUGqqIa6T1WmPU+PO3EGT6SBBf7drQLdetG/fPGS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JoccJTdacS4pdJtII4WvJsRP38Eyikg20e2AnRr5UGIQAW5BoVn+vj+d9/C3/+FuYAFhX4mehlqIaTCzaTZXdjpdECqWniteQMgcV+Zi7bmbUcOidyNDuqCDCRqIDpIW1u+J4Q/mojlWTP9PSEWbG1Z1UnvNVcCX2Cmq1xll724=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fKy+oFgX; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fKy+oFgX"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cace91f112so21794955ad.0
        for <nvdimm@lists.linux.dev>; Sat, 01 Aug 2026 08:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599234; x=1786204034; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zDHMc8aFblNi/hrooe3cgS0zDU46LdNoPkDB9yiNAnQ=;
        b=fKy+oFgXcPNA+To3Ss4ThmA3hmwHMiPnUb8HQtk/fZIeqR6MbUvKKMNyIoK8XhsCBZ
         F7Y0V0xG31RTsLJCu20i+zd1WmUG+S+rsdA/p7kiMLqlg2lnle89CRXV/AeucB4v/SL7
         mxfAMlQkWfHmYpiTbzEoa9Eddpnq1V1RaFl/DGGOUL0h+cSsIctxatB1km+peA9Xv8Ii
         SzFlClLWaN7zGgi1Uwz9nCh+CK9fB8r+ZQbfOybbczul1zRR4k+z3eOU0irp06giSQvn
         YBk+GNCk9VJkMeM0LISf6ug+cjvRaSCQ873c5yALpBszve+8KXQERBHO65B3lz2oz20Z
         5HdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599234; x=1786204034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zDHMc8aFblNi/hrooe3cgS0zDU46LdNoPkDB9yiNAnQ=;
        b=cnvUF3sDsDr3ie4fWoXYxmlST1xhKmQGbbHQWjfAv/J9Cps+QUmDGejeu/TWS7gb1W
         E50bJCW2lI/SBIwrtTVm6QvgvNVzXTv0RdA6dtarXExLl1RVlRcKrwesvKGdP3D2/Z8U
         HjsvufjQnVvN7pp1ZzzcUojjHqgSRuL0Cb/R72oSq7H/V4jDaOmf4TnGXZ6hz6g6V1dL
         vOtKa4h6nXoKoAKO15u8y2s5IKkCWyxgD555GK+CTLLsqaPcMcGhVNszK7xdbE3ahwIW
         RiW6S5M/XLqSNzrPQbpslGGH8QLdnCpCk4ui9Z293IHre9uOMr6GK/eNDekWTFcfs31N
         SCcQ==
X-Forwarded-Encrypted: i=1; AHgh+RrhQC9vU0qx+TMnCz5H3uYJFxYAEFoupMgPe3ysvC3isG17cAG0FQRlGcS5UCzjktT4YCtAFQY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQTMJKO9WGiyharwGW04iQ4sry/d9vZaJIPv3O9PFVrL8TWEva
	Jkp4HwFIebvQlhHxnNZViLU21ga9x1tJBu2LZNKVejdIB7iUavrE8BbK
X-Gm-Gg: AR+sD12N3+F/I/hWy8AE6rVtykprFRblnfy1TjkRm4Asa/De8rxwuhkl8GD7JonWlvT
	3LgouTyO5O/VsGZxq2mk3/WYTxgtCog0A3ce1YgweBmF6x7rjaFQUDyjakGUTRhbgePLBLAxmSd
	wbHiuEr1eo+6cuhMIPC/P3HJQhtVHCPPyF8p8q7Zu8XORkjIfvHecxYufEKoBGi+ErOn6wqXkMK
	R/9a7QcOhXldFqufJvL1FqUdj8RrnwBwTx0yKKZs8wME6ViQHNb5GKl1C96OeM9+s8YbhJ41hrH
	tMrGDHhPEpQAggx1AJqZMRZNEaNFGUM3sUWkpz9jITIVKt9d5j922EkAjpRCCagIVjFV86GtE7F
	4g+RbjrT6N1AiOqByF24wKuIMs/YigNczXkeQJf6rhoD5PHPbeQ+lT5mWGwLj06SqA3kJgmEyUL
	o4Q3lbdQLh5z/ZWcFz8MXMobYnVolUSQQLAbiCx0DCnccR2z8z3++aYAJXu0J/MdD+04dNVExU3
	x1rcBW9PntlP3oAZF3DINZxYQdeJh4O/mj9a7bFMjvMtMQ=
X-Received: by 2002:a17:903:1a67:b0:2cf:7e56:22c4 with SMTP id d9443c01a7336-2d0523e1c85mr42035155ad.30.1785599233638;
        Sat, 01 Aug 2026 08:47:13 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:47:12 -0700 (PDT)
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
Subject: [PATCH v5 01/16] dma-buf: introduce initial file I/O infrastructure
Date: Sat,  1 Aug 2026 16:46:13 +0100
Message-ID: <ff5dccf71e8c03d62797352c4bb5fbb7c6c759c8.1785596451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785596451.git.asml.silence@gmail.com>
References: <cover.1785596451.git.asml.silence@gmail.com>
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
 drivers/dma-buf/dma-buf-io.c | 278 +++++++++++++++++++++++++++++++++++
 include/linux/dma-buf-io.h   |  92 ++++++++++++
 include/linux/fs.h           |   2 +
 4 files changed, 373 insertions(+), 1 deletion(-)
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
index 000000000000..24f58f80c45c
--- /dev/null
+++ b/drivers/dma-buf/dma-buf-io.c
@@ -0,0 +1,278 @@
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
+	if (WARN_ON_ONCE(!map->seg_shift))
+		return ERR_PTR(-EFAULT);
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
index 000000000000..f31c7375ae91
--- /dev/null
+++ b/include/linux/dma-buf-io.h
@@ -0,0 +1,92 @@
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
+	unsigned			seg_shift;
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
index 50ce731a2b78..e62fa653e148 100644
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

