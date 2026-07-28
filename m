Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65684746D2
	for <nvdimm@lists.linux.dev>; Tue, 28 Jul 2026 21:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274199; cv=none; b=omCvjlsGFKJ5D+xUl18FmF1+I5q/9fP0MOoap5R2pO7qcON7MwrUUQHdvxXDcP8VHwV5LDe2H5DeZ6mtfkvk8SYaFXpP8XHLwHZibl9FXOTs0iaEh6pqIcKERV5d2K9u3jSe/4KhDKnin2SQ9K15FvDYkUkdfaJMX/yPejg4RYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274199; c=relaxed/simple;
	bh=aY3CNWMc58bYzxxyOFJSJJSimVOo10PALBNiiMnlMxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUKJKgY8YcxRVAEfc7AOuaMJKST1Dxe+EmKIUjyFwf66AcmDn1+ODRV/6Ocmg00vOyt6VbpGCsVgnzp2/G2ZZNbVDwlkL2QAlXmRi4/NI8vWvpzF5caAtOI7K/fiu64Dt79VmbFW4Qlb44zxfhuyBX7yTN9H2/rFQlPLPAdqLTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qGFVKzZJ; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qGFVKzZJ"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47f6609c657so173967f8f.2
        for <nvdimm@lists.linux.dev>; Tue, 28 Jul 2026 14:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274194; x=1785878994; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xDZPkMbwSk/lf5c8/cMXuQv/8k90Wcurvg4IHgK0Syc=;
        b=qGFVKzZJyVTueb5DJ5KpuWESNGAPU2ybm4WPGxsfYYL9I38Al7G5oUa1K/FHz7zmGF
         HuEoiDSoZWhqkj37ZqsnB4wKtbsTbzxnd4fqoZMgRAFfF4APDroZtlHxMARtfxm5QD/S
         Q4kje2VGIPaGei159BbEWavaWg7/65a1XqNtaFU0iEusV8q57WXpsuHops9ZriWtR2A3
         PDOIFiysdYEYrnhPmpBWJsebejSx2twf3MqT/CwV5IQ4s4KTdT6tVLeEwURRb2s8JzL5
         fNMkq6YGhILbg7J3JTa9rdijrfEJtkHByPdUBP6xCeQHe2TiTYitBdrHHKP8QwNnQAUp
         Uk6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274194; x=1785878994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xDZPkMbwSk/lf5c8/cMXuQv/8k90Wcurvg4IHgK0Syc=;
        b=WePDWCcnhxhwuRPZyiqrUQ8D+SS6bMX5i6ak1U9OcGFTiIbn4lV4v2i1FwBv2f1WV9
         39k8dBsO70kjx03Zh4WTRA3RZvDroKqOQbJcWknVqX4sJbxTu++hQ9YavDk/6OxeqZT+
         RzYAXEX9+lRBX7CHJYL3utbuT/FjFukBWKF57YqLOGQlCVAua97XS4A+zKwQrlWJc5s7
         CIbY4ip6xISxzekmRov+G8LB9/orI9olXp7sfycAat8SjoWuLK/eO9IaGNJfBozRc2AI
         rfkicOJUUZBRARn/AZmXq653XvXazmwHIlFuZ5wunMEnFQdetxdO8U8Z6OsOq7UKv31g
         et4g==
X-Forwarded-Encrypted: i=1; AHgh+RpmogSxraJUWxraxkDrdy90LvKKTON2O8hSGZq1prbQmc5pJfYtb1Y6SjuUMuwSmfuIRXttRSk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yym4Rk3Le2eLYcfWXk71t9f57Z4Uzd2NITc+j8KVb1vTQu0Sx4p
	gfacFXxGqQ7pRxAs0qwuHa2edunZ3Sl/1PQ0s7dqEyZjDH7tm8JME0QK
X-Gm-Gg: AR+sD12YsQ6nm3OH5ionJqVH3565IjO+4FALpWCpidq9P5vtZ4Lmz0zvXwxuRm0wYa8
	zFNsrQ4tX+jtuNKlT2Dpmnn0xtljzS0mTIkstMElrZ5uAUtFwezskh7NLJN/ZuVZceyDA9qyiDR
	cT65a5PQqe6gJ8mHlevMIu9PtzVGyFLPAI/ao3c9Y/cV9VyaEJaML2QPit8YriPlwThBTSuerMk
	OcAwwvcPPEpXW6yJqAmcNvhAfTcwhKO20NkwiJv1BKJfykIsp1NGJW9kEmAN5Sz4bosTkZgYxjI
	4pFlzsLc9Jx94QhlEyFmUvwttNitfgF+bOUNs0qVRK8/aQ1LkuwTwcazSFCPg5MQwi9zQFGPCQu
	MQbriKqulhwUt1jQQBbpTw9+wXjCC12efVi+ytMZtD+DAqHaO2E4hbdS7GPPz7y1XJBu0MS7GSS
	KC08lVUX7ys3vtlvd7gaUKJIznGgRL1u9acTgoCGIUy0IiCKJTDwU7Dy/0rE3Pja3xG1ppaLNwm
	EpjyGMnkI/gRDgnaqb4Tjqs2QsU5T0FitAJxL5XU4aWEkHJxo9R4o/QH9jdgCnGmWQ=
X-Received: by 2002:a05:600c:4504:b0:496:c93d:e2f with SMTP id 5b1f17b1804b1-496c93d0e44mr30643425e9.15.1785274193855;
        Tue, 28 Jul 2026 14:29:53 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:29:52 -0700 (PDT)
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
Subject: [PATCH v4 06/14] block: introduce dma map backed bio type
Date: Tue, 28 Jul 2026 22:29:18 +0100
Message-ID: <f97985ac5cfff3d9f7777b93f11456af57e253e2.1785274111.git.asml.silence@gmail.com>
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

Premapped buffers don't require a generic bio_vec since these have
already been dma mapped. Repurpose the bi_io_vec space to strore dmabuf
maps as they are mutually exclusive.

Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c               | 23 ++++++++++++++++++++++-
 block/blk-merge.c         | 15 +++++++++++++++
 block/fops.c              |  2 ++
 include/linux/bio.h       | 10 ++++++----
 include/linux/blk-mq.h    |  7 +++++++
 include/linux/blk_types.h | 14 +++++++++++++-
 include/linux/bvec.h      |  3 ++-
 7 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 57c127aee116..cc2bb9183c1a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -860,7 +860,12 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 	bio->bi_write_hint = bio_src->bi_write_hint;
 	bio->bi_write_stream = bio_src->bi_write_stream;
 	bio->bi_iter = bio_src->bi_iter;
-	bio->bi_io_vec = bio_src->bi_io_vec;
+
+	if (op_is_dmabuf(bio->bi_opf)) {
+		bio->bi_dmabuf_map = bio_src->bi_dmabuf_map;
+	} else {
+		bio->bi_io_vec = bio_src->bi_io_vec;
+	}
 
 	if (bio->bi_bdev) {
 		if (bio->bi_bdev == bio_src->bi_bdev &&
@@ -1192,6 +1197,17 @@ void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter)
 	bio_set_flag(bio, BIO_CLONED);
 }
 
+void bio_dmabuf_map_set(struct bio *bio, struct iov_iter *iter)
+{
+	WARN_ON_ONCE(bio->bi_max_vecs);
+
+	bio->bi_dmabuf_map = iter->dmabuf_map;
+	bio->bi_vcnt = 0;
+	bio->bi_iter.bi_offset = iter->iov_offset;
+	bio->bi_iter.bi_size = iov_iter_count(iter);
+	bio->bi_opf |= REQ_NOMERGE | REQ_DMABUF;
+}
+
 /*
  * Aligns the bio size to the len_align_mask, releasing excessive bio vecs that
  * __bio_iov_iter_get_pages may have inserted, and reverts the trimmed length
@@ -1254,6 +1270,11 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
 		iov_iter_advance(iter, bio->bi_iter.bi_size);
 		return 0;
 	}
+	if (iov_iter_is_dmabuf_map(iter)) {
+		bio_dmabuf_map_set(bio, iter);
+		iov_iter_advance(iter, bio->bi_iter.bi_size);
+		return 0;
+	}
 
 	if (iov_iter_extract_will_pin(iter))
 		bio_set_flag(bio, BIO_PAGE_PINNED);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 258a726071d1..6f0cabfe25ef 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -346,6 +346,20 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 		len_align_mask |= (bc->bc_key->crypto_cfg.data_unit_size - 1);
 	}
 
+	if (op_is_dmabuf(bio->bi_opf)) {
+		/* single contiguous range into the dma-buf */
+		nsegs = 1;
+
+		if ((bio->bi_iter.bi_offset & start_align_mask) ||
+		    (bio->bi_iter.bi_size & len_align_mask))
+			return -EINVAL;
+		if (bio->bi_iter.bi_size > max_bytes) {
+			bytes = max_bytes;
+			goto split;
+		}
+		goto out;
+	}
+
 	bio_for_each_bvec(bv, bio, iter) {
 		if (bv.bv_offset & start_align_mask ||
 		    bv.bv_len & len_align_mask)
@@ -376,6 +390,7 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 		bvprvp = &bvprv;
 	}
 
+out:
 	*segs = nsegs;
 	bio->bi_bvec_gap_bit = ffs(gaps);
 	return 0;
diff --git a/block/fops.c b/block/fops.c
index 15783a6180de..37d491f45015 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -348,6 +348,8 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		 * bio_iov_iter_get_pages() and set the bvec directly.
 		 */
 		bio_iov_bvec_set(bio, iter);
+	} else if (iov_iter_is_dmabuf_map(iter)) {
+		bio_dmabuf_map_set(bio, iter);
 	} else {
 		ret = blkdev_iov_iter_get_pages(bio, iter, bdev);
 		if (unlikely(ret))
diff --git a/include/linux/bio.h b/include/linux/bio.h
index dea9f567379d..c053e9444514 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -80,7 +80,8 @@ static inline bool bio_no_advance_iter(const struct bio *bio)
 {
 	return bio_op(bio) == REQ_OP_DISCARD ||
 	       bio_op(bio) == REQ_OP_SECURE_ERASE ||
-	       bio_op(bio) == REQ_OP_WRITE_ZEROES;
+	       bio_op(bio) == REQ_OP_WRITE_ZEROES ||
+	       op_is_dmabuf(bio->bi_opf);
 }
 
 static inline void *bio_data(struct bio *bio)
@@ -399,12 +400,12 @@ static inline void bio_wouldblock_error(struct bio *bio)
 
 /*
  * Calculate number of bvec segments that should be allocated to fit data
- * pointed by @iter. If @iter is backed by bvec it's going to be reused
- * instead of allocating a new one.
+ * pointed by @iter. If @iter is backed by a bvec or a dmabuf, the bvec array /
+ * the dma map are going to be reused, and so no extra allocation is required.
  */
 static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_segs)
 {
-	if (iov_iter_is_bvec(iter))
+	if (iov_iter_is_bvec(iter) || iov_iter_is_dmabuf_map(iter))
 		return 0;
 	return iov_iter_npages(iter, max_segs);
 }
@@ -484,6 +485,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
 		unsigned len_align_mask);
 
 void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter);
+void bio_dmabuf_map_set(struct bio *bio, struct iov_iter *iter);
 void __bio_release_pages(struct bio *bio, bool mark_dirty);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index af878597afb8..7c7504c84e09 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -1017,6 +1017,13 @@ static inline void *blk_mq_rq_to_pdu(struct request *rq)
 	return rq + 1;
 }
 
+static inline bool blk_mq_rq_is_dmabuf(struct request *rq)
+{
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return false;
+	return rq->bio && op_is_dmabuf(rq->bio->bi_opf);
+}
+
 static inline struct blk_mq_hw_ctx *queue_hctx(struct request_queue *q, int id)
 {
 	struct blk_mq_hw_ctx *hctx;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c..d605e31712d4 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -233,7 +233,12 @@ struct bio {
 	atomic_t		__bi_remaining;
 
 	/* The actual vec list, preserved by bio_reset() */
-	struct bio_vec		*bi_io_vec;
+	union {
+		struct bio_vec		*bi_io_vec;
+		/* Driver specific dma map, valid IFF REQ_DMABUF is set */
+		struct dma_buf_io_map	*bi_dmabuf_map;
+	};
+
 	struct bvec_iter	bi_iter;
 
 	union {
@@ -401,6 +406,7 @@ enum req_flag_bits {
 	__REQ_DRV,		/* for driver use */
 	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
 	__REQ_ATOMIC,		/* for atomic write operations */
+	__REQ_DMABUF,		/* Using premmaped dma buffers */
 	/*
 	 * Command specific flags, keep last:
 	 */
@@ -433,6 +439,7 @@ enum req_flag_bits {
 #define REQ_DRV		(__force blk_opf_t)(1ULL << __REQ_DRV)
 #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
 #define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
+#define REQ_DMABUF	(__force blk_opf_t)(1ULL << __REQ_DMABUF)
 
 #define REQ_NOUNMAP	(__force blk_opf_t)(1ULL << __REQ_NOUNMAP)
 
@@ -486,6 +493,11 @@ static inline bool op_is_discard(blk_opf_t op)
 	return (op & REQ_OP_MASK) == REQ_OP_DISCARD;
 }
 
+static inline bool op_is_dmabuf(blk_opf_t op)
+{
+	return op & REQ_DMABUF;
+}
+
 /*
  * Check if a bio or request operation is a zone management operation.
  */
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index fc566ee1c1ff..b63914ff56e3 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -108,7 +108,8 @@ struct bvec_iter {
 	unsigned int		bi_idx;
 
 	/*
-	 * Current offset in the bvec entry pointed to by `bi_idx`.
+	 * Current offset in the bvec entry pointed to by `bi_idx` or into
+	 * a dma-buf map.
 	 */
 	unsigned int		bi_offset;
 } __packed __aligned(4);
-- 
2.54.0

