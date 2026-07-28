Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D4247FB1C
	for <nvdimm@lists.linux.dev>; Tue, 28 Jul 2026 21:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274217; cv=none; b=iYUldRKG3GlBj3rLls6HdZZPbWN7qnfuLW88jpid4zTVwDwdsPhkv7MDRb1sVwHQNnqYALirLQVyEq31rOrmbM9veYMqiZFd8BTuOzCWDYiSB+DMnH3N3vw3eWHSbnNjR9ZMdSN7eybItNGJ16LlqjrE0sb+xIAOx6weknl0zI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274217; c=relaxed/simple;
	bh=rd/AmBpbmKqj+156AKnJfNtSMPtgc6wewE914z4k3k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRckPEUfnRG1rxhGWZZrw24slZKoSwImr6Of4uEf9IcaZx0KtAY6Eap4i0u1w4y/7nhjvdO5aYB8ODgmEAKtZHYESWz88cILQ5od6nY5tIwz91uB3YYEDDxa9wztdVMwBqfIRtec89NzT156P5psO0rfgxNZ8SeHcbLszGKPRjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rl/15IXO; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rl/15IXO"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-493b966dd74so1666165e9.3
        for <nvdimm@lists.linux.dev>; Tue, 28 Jul 2026 14:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274213; x=1785879013; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h4lFfo5ZGoFgQzeJsrKlXRAyOLh0g5mqIoi0J3evNaQ=;
        b=rl/15IXOTpHRNYwUr7z6WWVpTJCIStjMLIYksXofPmsSMZlHmKbw46rGkZHsvAzV0y
         OK2J+9b/uwAh8cuG7a0Xk3/zlyC3/6B3++pPHfac7piwzF4greTUr9NpCHvF9yzHbc9M
         ua8G1UwOdx1zYOtIiOAEbBZGHVuIbVAao0alJ1jYijTBPew+NsFKKc+sPIKGwfw5Fg8T
         7c+Og0CuZASWGgk0QYUgOtWCLEsfdP1VD3FAWsE5zI4gGRQ7xqMrBuB8WkG5MiXNYfdR
         2LekV6rgcjZqN3iJdPaBU2nki25frhVXbjxgdorWO2gkAPBmHLSGKFNBZddH6d1aayxC
         4qYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274213; x=1785879013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=h4lFfo5ZGoFgQzeJsrKlXRAyOLh0g5mqIoi0J3evNaQ=;
        b=UYh7Xs6qP7P5xRTuOtTsO4LXRzvL57QmazZ2zy2NYvo36jc0ft4DWcyhoXapdERn2N
         JjDCAQ7IG9+xgEDqjI6YWtAe6KFxcKa8+MZNvWnkn3d/R8coYkUMeyzeuFfURpXshMbC
         yUtGxJzkJuK1Ka0Pw9jxZjzpP+d8eKB9wKdKX2udZHeqpWtIPo9foYTOl/3Eh3/dHiPD
         dP1e8cWptIX2/pekeSm56ms6Pkd75d1z24HnIKwK22dF4RyLwC+K4v/3QKaCnand9Ald
         lo7Q2WymVa58wGGQQLDEdV60vkr2Vi/MHJawOXMpnntV4Ftn7KOgqldEKvTJGIwAQT5p
         +Rdg==
X-Forwarded-Encrypted: i=1; AHgh+Rp9N0mIoe2sdVhoIRefy2f1wF+Bkq7vMgOmjS5oHHVoDsbaoyWxji0oBHgjkDY/s5t99vmzYHk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwtiUDFKzG/GNDm2NEf7FTmrdqb2tHqEmuPUKsYJxyu91fKnYFZ
	yulFSqH8iKXkQ6282iMdozuD74HXMsVNFfuz7x9z8IjI5wNcctz9RpK1
X-Gm-Gg: AR+sD12HuXT/wOb26jtVhtwLsmL9JDArIMx3o9pEb7StzKbwJT79vJ7np+V4oFmreF0
	No0FOaznSRnVL2BDSfzkG5nfAZttSFfVWPY69zgeELABIlT9Q+Z6iN6Tu7tfiS+/K+jS7MQ1Ds5
	li8m7Jm74euuPvayTrG1JEcxpH6N+ZJiNAouxvTg6R8dAYXbCwNY6nAqLdhbSSLoZJlEX7urAPN
	1ZBlBOL5EWMpVIk44ZI1kkYIEBV15dpE7E+p3xTj2DzjzJ55b5y280s40bk2bgbZdG5phl9ITjV
	gzkbtF1ehGDl5CEafqJ12M08/uBH8ixL/KpN+w1vEbh8iNl42u1Zbnjvc2FFIYF6t0c4tya4F81
	G6wcL78DNBhmyG/kmhyAy6UVUaPa57orUzBFBuac91MiFHfxeYGfwPvnmqfRKAvDJAHqDiGhVM4
	pMLpyVZqgugxlM6Evs8iRR5Oid0MY00d/znhmrtD3/VAWyq2v6arbKDeaZhrwZAt4tn5ZHX03KH
	ZHJxczaNZkKRWDsiIL8ssZ5MN3yFHR4TqBrtKlJkcgHQ1qeYIrvCcWoSx4U8tIcY8g=
X-Received: by 2002:a05:600c:4755:b0:495:3fe8:880f with SMTP id 5b1f17b1804b1-496c6414fe3mr44424285e9.4.1785274212668;
        Tue, 28 Jul 2026 14:30:12 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:30:11 -0700 (PDT)
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
Subject: [PATCH v4 14/14] io_uring/rsrc: add dmabuf backed registered buffers
Date: Tue, 28 Jul 2026 22:29:26 +0100
Message-ID: <26dcd0ae5c87a3ada5710b14b6894ef343cec6fe.1785274111.git.asml.silence@gmail.com>
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

Implement dmabuf backed registered buffers. To register them, the user
should specify IO_REGBUF_TYPE_DMABUF for the regitration and pass the
desired dmabuf fd and a file for which it should be registered.

From there, it can be used with io_uring read/write requests
IORING_OP_{READ,WRITE}_FIXED) as normal. The requests should be issued
against the file specified during registration, and otherwise they'll be
failed. The user should also be prepared to handle spurious -EAGAIN by
reissuing the request.

Internally, dmabuf registered buffers is an optin feature for io_uring
request opcodes and they should pass a special flag on import to use it.

Suggested-by: David Wei <dw@davidwei.uk>
Suggested-by: Vishal Verma <vishal1.verma@intel.com>
Suggested-by: Tushar Gohad <tushar.gohad@intel.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |   5 +
 include/uapi/linux/io_uring.h  |   6 +-
 io_uring/io_uring.c            |   3 +-
 io_uring/rsrc.c                | 168 ++++++++++++++++++++++++++++++++-
 io_uring/rsrc.h                |  18 ++++
 io_uring/rw.c                  |   6 +-
 6 files changed, 198 insertions(+), 8 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index a2c623a67a25..f90586d353c1 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -10,6 +10,7 @@
 
 struct iou_loop_params;
 struct io_uring_bpf_ops;
+struct dma_buf_io_map;
 
 enum {
 	/*
@@ -594,6 +595,7 @@ enum {
 	REQ_F_IMPORT_BUFFER_BIT,
 	REQ_F_SQE_COPIED_BIT,
 	REQ_F_IOPOLL_BIT,
+	REQ_F_DROP_DMABUF_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -689,6 +691,8 @@ enum {
 	REQ_F_SQE_COPIED	= IO_REQ_FLAG(REQ_F_SQE_COPIED_BIT),
 	/* request must be iopolled to completion (set in ->issue()) */
 	REQ_F_IOPOLL		= IO_REQ_FLAG(REQ_F_IOPOLL_BIT),
+	/* there is a dma map attached to request that needs to be dropped */
+	REQ_F_DROP_DMABUF	= IO_REQ_FLAG(REQ_F_DROP_DMABUF_BIT),
 };
 
 struct io_tw_req {
@@ -811,6 +815,7 @@ struct io_kiocb {
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	const struct cred		*creds;
 	struct io_wq_work		work;
+	struct dma_buf_io_map		*dmabuf_map;
 
 	struct io_big_cqe {
 		u64			extra1;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 98b259901185..c39297e8beb6 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -810,6 +810,7 @@ enum io_uring_rsrc_reg_flags {
 enum io_uring_regbuf_type {
 	IO_REGBUF_TYPE_EMPTY,
 	IO_REGBUF_TYPE_UADDR,
+	IO_REGBUF_TYPE_DMABUF,
 
 	__IO_REGBUF_TYPE_MAX,
 };
@@ -819,7 +820,10 @@ struct io_uring_regbuf_desc {
 	__u32 flags;
 	__u64 size;
 	__u64 uaddr;
-	__u64 __resv[7];
+
+	__s32 dmabuf_fd;
+	__s32 target_fd;
+	__u64 __resv[6];
 };
 
 /* Skip updating fd indexes set to this value in the fd table */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1279e27c2c6d..cb88d19c8fb2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -109,7 +109,7 @@
 
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | IO_REQ_LINK_FLAGS | \
 				 REQ_F_REISSUE | REQ_F_POLLED | \
-				 IO_REQ_CLEAN_FLAGS)
+				 IO_REQ_CLEAN_FLAGS | REQ_F_DROP_DMABUF)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
@@ -1125,6 +1125,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 				io_queue_next(req);
 			if (unlikely(req->flags & IO_REQ_CLEAN_FLAGS))
 				io_clean_op(req);
+			io_req_drop_dmabuf(req);
 		}
 		io_put_file(req);
 		io_req_put_rsrc_nodes(req);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 05877b4c0ee5..d23dbb0dd6b8 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -10,6 +10,7 @@
 #include <linux/compat.h>
 #include <linux/io_uring.h>
 #include <linux/io_uring/cmd.h>
+#include <linux/dma-buf-io.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -881,6 +882,95 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 	return true;
 }
 
+struct io_regbuf_dma {
+	struct dma_buf_io_ctx		ctx;
+	struct file			*target_file;
+};
+
+static void io_release_reg_dmabuf(void *priv)
+{
+	struct io_regbuf_dma *db = priv;
+
+	fput(db->target_file);
+	dma_buf_io_ctx_release(&db->ctx);
+}
+
+static struct io_rsrc_node *io_register_dmabuf(struct io_ring_ctx *ctx,
+						struct io_uring_regbuf_desc *desc)
+{
+	struct io_rsrc_node *node = NULL;
+	struct io_mapped_ubuf *imu = NULL;
+	struct io_regbuf_dma *regbuf = NULL;
+	struct file *target_file = NULL;
+	struct dma_buf *dmabuf = NULL;
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return ERR_PTR(-EOPNOTSUPP);
+	if (ctx->flags & IORING_SETUP_IOPOLL)
+		return ERR_PTR(-EOPNOTSUPP);
+	if (desc->uaddr || desc->size)
+		return ERR_PTR(-EINVAL);
+
+	ret = -ENOMEM;
+	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
+	if (!node)
+		return ERR_PTR(-ENOMEM);
+	imu = io_alloc_imu(ctx, 0);
+	if (!imu)
+		goto err;
+	regbuf = kzalloc(sizeof(*regbuf), GFP_KERNEL);
+	if (!regbuf)
+		goto err;
+
+	ret = -EBADF;
+	target_file = fget(desc->target_fd);
+	if (!target_file)
+		goto err;
+
+	dmabuf = dma_buf_get(desc->dmabuf_fd);
+	if (IS_ERR(dmabuf)) {
+		ret = PTR_ERR(dmabuf);
+		dmabuf = NULL;
+		goto err;
+	}
+	if (dmabuf->size > SZ_1G) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = dma_buf_io_ctx_create(target_file, &regbuf->ctx, dmabuf,
+				    DMA_BIDIRECTIONAL);
+	if (ret)
+		goto err;
+
+	regbuf->target_file = target_file;
+	imu->nr_bvecs = 1;
+	imu->ubuf = 0;
+	imu->len = dmabuf->size;
+	imu->folio_shift = 0;
+	imu->release = io_release_reg_dmabuf;
+	imu->priv = regbuf;
+	imu->flags = IO_REGBUF_F_DMABUF;
+	imu->dir = IO_IMU_DEST | IO_IMU_SOURCE;
+	refcount_set(&imu->refs, 1);
+	node->buf = imu;
+	dma_buf_put(dmabuf);
+	return node;
+err:
+	kfree(regbuf);
+	if (imu)
+		io_free_imu(ctx, imu);
+	if (node)
+		io_cache_free(&ctx->node_cache, node);
+	if (target_file)
+		fput(target_file);
+	if (dmabuf)
+		dma_buf_put(dmabuf);
+	return ERR_PTR(ret);
+}
+
+
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 						   struct io_uring_regbuf_desc *desc)
 {
@@ -899,6 +989,12 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	if (!mem_is_zero(&desc->__resv, sizeof(desc->__resv)))
 		return ERR_PTR(-EINVAL);
 
+	if (desc->type == IO_REGBUF_TYPE_DMABUF)
+		return io_register_dmabuf(ctx, desc);
+
+	if (desc->dmabuf_fd || desc->target_fd)
+		return ERR_PTR(-EINVAL);
+
 	if (desc->type == IO_REGBUF_TYPE_EMPTY) {
 		if (uaddr || size)
 			return ERR_PTR(-EFAULT);
@@ -1170,9 +1266,64 @@ static int io_import_kbuf(int ddir, struct iov_iter *iter,
 	return 0;
 }
 
-static int io_import_fixed(int ddir, struct iov_iter *iter,
+void io_drop_dmabuf_node(struct io_kiocb *req)
+{
+	struct io_mapped_ubuf *imu;
+
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return;
+	if (WARN_ON_ONCE(req->buf_node->type != IORING_RSRC_BUFFER))
+		return;
+	imu = req->buf_node->buf;
+	if (WARN_ON_ONCE(!(imu->flags & IO_REGBUF_F_DMABUF)))
+		return;
+	dma_buf_io_map_drop(req->dmabuf_map);
+	req->flags &= ~REQ_F_DROP_DMABUF;
+}
+
+static int io_import_dmabuf(struct io_kiocb *req,
+			   int ddir, struct iov_iter *iter,
+			   struct io_mapped_ubuf *imu,
+			   size_t len, size_t offset,
+			   unsigned issue_flags)
+{
+	struct io_regbuf_dma *db = imu->priv;
+	struct dma_buf_io_map *map;
+
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return -EOPNOTSUPP;
+	if (!len)
+		return -EFAULT;
+	if (req->file != db->target_file)
+		return -EBADF;
+
+	if (req->flags & REQ_F_DROP_DMABUF) {
+		map = req->dmabuf_map;
+		goto init_iter;
+	}
+
+	map = dma_buf_io_get_map(&db->ctx);
+	if (unlikely(!map)) {
+		if (!(issue_flags & IO_URING_F_IOWQ))
+			return -EAGAIN;
+		map = dma_buf_io_create_map(&db->ctx);
+		if (IS_ERR(map))
+			return PTR_ERR(map);
+	}
+
+	req->dmabuf_map = map;
+	req->flags |= REQ_F_DROP_DMABUF;
+init_iter:
+	iov_iter_dmabuf_map(iter, ddir, map, offset, len);
+	return 0;
+}
+
+static int io_import_fixed(struct io_kiocb *req,
+			   int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
-			   u64 buf_addr, size_t len)
+			   u64 buf_addr, size_t len,
+			   unsigned issue_flags,
+			   unsigned import_flags)
 {
 	const struct bio_vec *bvec;
 	size_t folio_mask;
@@ -1192,6 +1343,12 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 
 	offset = buf_addr - imu->ubuf;
 
+	if (imu->flags & IO_REGBUF_F_DMABUF) {
+		if (!(import_flags & IO_REGBUF_IMPORT_ALLOW_DMABUF))
+			return -EFAULT;
+		return io_import_dmabuf(req, ddir, iter, imu, len, offset,
+					issue_flags);
+	}
 	if (imu->flags & IO_REGBUF_F_KBUF)
 		return io_import_kbuf(ddir, iter, imu, len, offset);
 
@@ -1254,7 +1411,8 @@ int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 	node = io_find_buf_node(req, issue_flags);
 	if (!node)
 		return -EFAULT;
-	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
+	return io_import_fixed(req, ddir, iter, node->buf, buf_addr, len,
+				issue_flags, import_flags);
 }
 
 static int io_buffer_acct_cloned_hpages(struct io_ring_ctx *ctx,
@@ -1676,7 +1834,9 @@ int __io_import_reg_vec(int ddir, struct iov_iter *iter,
 	iovec_off = vec->nr - nr_iovs;
 	iov = vec->iovec + iovec_off;
 
-	if (imu->flags & IO_REGBUF_F_KBUF) {
+	if (imu->flags & IO_REGBUF_F_DMABUF) {
+		return -EOPNOTSUPP;
+	} else if (imu->flags & IO_REGBUF_F_KBUF) {
 		int ret = io_kern_bvec_size(iov, nr_iovs, imu, &nr_segs);
 
 		if (unlikely(ret))
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index f12abaf63270..3cb9b57f159b 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -31,6 +31,11 @@ enum {
 enum {
 	IO_REGBUF_F_KBUF		= 1 << 0,
 	IO_REGBUF_F_UNCLONEABLE		= 1 << 1,
+	IO_REGBUF_F_DMABUF		= 1 << 3,
+};
+
+enum {
+	IO_REGBUF_IMPORT_ALLOW_DMABUF		= 1 << 1,
 };
 
 struct io_mapped_ubuf {
@@ -173,4 +178,17 @@ static inline void io_alloc_cache_vec_kasan(struct iou_vec *iv)
 		io_vec_free(iv);
 }
 
+void io_drop_dmabuf_node(struct io_kiocb *req);
+
+static inline void io_req_drop_dmabuf(struct io_kiocb *req)
+{
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return;
+	if (!(req->flags & REQ_F_DROP_DMABUF))
+		return;
+	if (WARN_ON_ONCE(!(req->flags & REQ_F_BUF_NODE)))
+		return;
+	io_drop_dmabuf_node(req);
+}
+
 #endif
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 95038cfda615..11ff7b5a1164 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -380,8 +380,8 @@ static int io_init_rw_fixed(struct io_kiocb *req, unsigned int issue_flags,
 	if (io->bytes_done)
 		return 0;
 
-	ret = io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir,
-				issue_flags);
+	ret = __io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir,
+				  issue_flags, IO_REGBUF_IMPORT_ALLOW_DMABUF);
 	iov_iter_save_state(&io->iter, &io->iter_state);
 	return ret;
 }
@@ -591,6 +591,8 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 
+	io_req_drop_dmabuf(req);
+
 	__io_complete_rw_common(req, res);
 	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
 	req->io_task_work.func = io_req_rw_complete;
-- 
2.54.0

