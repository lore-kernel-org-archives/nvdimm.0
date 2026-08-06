Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53B14734E4
	for <nvdimm@lists.linux.dev>; Thu,  6 Aug 2026 12:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786018773; cv=none; b=XJnvoUROQJHr3dB5unJqs8gjtHdNOxeokt6cVgEGOjr4Cpzwqn+qKL93EDM9Z3fmZSYNJipQuQGiaPCxiZMx7Oq2+h1RZWiVw1ZoKm1CCFSdzvj5k2xCsO2n4NX9IF9O5Z2I8xYAIjUBfb2XIswObyBCpoDXMapsJbvxY4ujiBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786018773; c=relaxed/simple;
	bh=Bzt9rHxzAvaipHEkJlqGAiX1z5f5ogvjmdms2lFk8zE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VGYaU2/S/udrvLC8kGOtGIPPQ0yqMioN7j2y2queHsAFFndIVJSERqKQ+1jvj94BT5L6SsWOwCu4fng47GAi+mBaEhJ7yIwW2XMOxZeuLKctlPtw0vxQX1CniRCQzwnjHIeurJR2ViyCEBTLlprAYWsLfxvj6SjQX4o6Jm47sNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SFD6th5k; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SFD6th5k"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so17586215e9.0
        for <nvdimm@lists.linux.dev>; Thu, 06 Aug 2026 05:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786018769; x=1786623569; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CmiuwiCBxj43pnL6F4PU+TmqwE1tdFiaUXEdM+UwrCk=;
        b=SFD6th5k65GF/zVzyAy5Wu5c0LroLZy+o80W/MB55fbG9hwHTe4YHvAVs3iN/EfQn1
         PA3fX/qRToT+/7Aw2cA05v9++xztoNgz12+sYZnM03gwTdoQCDwq11S5ezd3WH91K6Og
         zZ8afM/JJFfR2iP0tJ5sLT814S7Jh6y5iKjyfWEZmBgzrYm4GnfQ1vCKHNyqnC/tysKO
         imywk+AO5A6T0JIihKPeYJTAViJIAsPCqjqeGMJoKzU2ATlQSo576nEZ9w1mlAtGzlVj
         AK8FTIzmK8igkh0dtj24RJ1xIU1twKRIjbmxF5IIjFMa7z7SSX1WulBxPOCXchY0dU0D
         pONg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786018769; x=1786623569;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CmiuwiCBxj43pnL6F4PU+TmqwE1tdFiaUXEdM+UwrCk=;
        b=snHeO9llC3s5Jwro3Bx2xSV8CcQBft+WM8XI8t2YjTWVroPM8e93QuFmUFJoDNJVug
         cbz6eTNMojcyXXCwB0bjUZXi0CWVAWjuDFId9JIb07tq+uj+p6LC4j3CkSHXhDmAZ0tI
         MoJmlAaoci3dfwSQIK1fKWNH1gaF/aocFyUYcBYFE8JS5L93TOKyNCJfNC1lrSZGtjJu
         0uo4q26ZAOP/WX/vMPzdxD6UNFzrhM/M7RdfuYdc7bs5PAAhMfWmCTdrIljRChsCdedA
         PZzDRnvKJ2KKNWSCTxIKiQupqiIPA3X+pE7cPScG9kUFtb9EsXt3eV+GGbP/gmHcR50R
         aMFw==
X-Forwarded-Encrypted: i=1; AHgh+Rp0EC4Rb+fD548nez0SXjedYZEyESUpKUhlD/q+TzICtNmhJNFPQLve+BVfNlNxDDPV0ZTK5+c=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTOHdxakxb6e2ekecmksEBSxj62YxHTpfJ5/CPuSsoiBLNPwgv
	lbf102YlE647fVVctpo/S3son0ZzeDJ07jr6luRkAYONiEeX+1hERgja
X-Gm-Gg: AR+sD10Y+t+g8/EW7NYCVF+FBAeKnYTYKDb5oU1RCc6q42Ih3wCexTNij7KJClHLV2q
	Kx4ubmlZvJm6kWFnuBMU3FhoVTMb1RUSLc1tp1AAG7z46tr71AO9DeCdE1Xb9RlwFGIQ5dlH9O7
	PZlcZQm0sOCE0lyZWbaUphVwo/rBqv82Zv0nsVCrZgzdjXFyBM/Mpk+Bfk7rgMze3qNQlUMQ2bu
	X+JtSJr9CLGegthG/vjCKEFLgah4BUf95DBOLfXrtxQtOYNdrHVVI+n9BoWvF+g6axFl0q2y80A
	bAFgJJi4VbA24Wlp5yWV36pfLLXcbsh2++FYE2WWuu6pIv4uSiHT3F1VBSKZjQ093gOJbAAB0lw
	WitPIq0sbs+1+qgDf+8GgslqfNOiyvLi0SHqUCihTJArB6w+PTgWpgYdYJXvrwRDh61ZmRi9aQM
	QDxtzuVdoeNGicimZD80EljVZuyaTXhJGckgUh2gt8ZePSzfvVIDbesCzZ8lu3npv6hjj1oLj2q
	QMxNxauhSjgvhDrCw69GANaJIeenbbCCYg5MMMbukuK9fxpdKuJy0owefQ+ziz/dg==
X-Received: by 2002:a05:600c:c046:b0:499:491e:4b0d with SMTP id 5b1f17b1804b1-4994e7d1ccdmr159730335e9.19.1786018768810;
        Thu, 06 Aug 2026 05:19:28 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49952dda992sm32751305e9.2.2026.08.06.05.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 05:19:27 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: linux-block@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Hannes Reinecke <hare@kernel.org>,
	linux-doc@vger.kernel.org,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	ceph-devel@vger.kernel.org
Subject: [PATCH 1/1] block: rename bi_bvec_done
Date: Thu,  6 Aug 2026 13:19:27 +0100
Message-ID: <4e4c21858705a200bd8848ffe4080522e3eb5c1c.1786018753.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct bvec_iter::bi_bvec_done is used an offset in the current bvec,
let's rename it accordingly for better clarity. I also plan to use it
for non-bvec based iteration in the future like dma-buf, so drop the
"bvec" part.

Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 Documentation/block/biovecs.rst |  8 ++++----
 block/bio.c                     |  4 ++--
 block/blk-merge.c               |  8 ++++----
 block/blk-mq-dma.c              |  2 +-
 block/blk.h                     |  2 +-
 drivers/block/loop.c            |  2 +-
 drivers/block/zloop.c           |  2 +-
 drivers/md/dm-io-rewind.c       | 10 +++++-----
 drivers/md/dm-pcache/segment.c  |  4 ++--
 drivers/nvdimm/btt.c            |  2 +-
 drivers/nvme/host/tcp.c         |  2 +-
 fs/btrfs/misc.h                 |  2 +-
 include/linux/bvec.h            | 14 +++++++-------
 io_uring/net.c                  |  4 ++--
 lib/iov_iter.c                  |  2 +-
 net/ceph/messenger.c            |  4 ++--
 16 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/Documentation/block/biovecs.rst b/Documentation/block/biovecs.rst
index 11126ed6f40f..49da2147b7d8 100644
--- a/Documentation/block/biovecs.rst
+++ b/Documentation/block/biovecs.rst
@@ -16,16 +16,16 @@ bv_len by the number of bytes completed in that biovec.
 In the new scheme of things, everything that must be mutated in order to
 partially complete a bio is segregated into struct bvec_iter: bi_sector,
 bi_size and bi_idx have been moved there; and instead of modifying bv_offset
-and bv_len, struct bvec_iter has bi_bvec_done, which represents the number of
+and bv_len, struct bvec_iter has bi_offset, which represents the number of
 bytes completed in the current bvec.
 
 There are a bunch of new helper macros for hiding the gory details - in
 particular, presenting the illusion of partially completed biovecs so that
-normal code doesn't have to deal with bi_bvec_done.
+normal code doesn't have to deal with bi_offset.
 
  * Driver code should no longer refer to biovecs directly; we now have
    bio_iovec() and bio_iter_iovec() macros that return literal struct biovecs,
-   constructed from the raw biovecs but taking into account bi_bvec_done and
+   constructed from the raw biovecs but taking into account bi_offset and
    bi_size.
 
    bio_for_each_segment() has been updated to take a bvec_iter argument
@@ -101,7 +101,7 @@ Other implications:
    I.e. instead of using bio_iovec_idx() (or bio->bi_iovec[bio->bi_idx]), you
    now use bio_iter_iovec(), which takes a bvec_iter and returns a
    literal struct bio_vec - constructed on the fly from the raw biovec but
-   taking into account bi_bvec_done (and bi_size).
+   taking into account bi_offset (and bi_size).
 
  * bi_vcnt can't be trusted or relied upon by driver code - i.e. anything that
    doesn't actually own the bio. The reason is twofold: firstly, it's not
diff --git a/block/bio.c b/block/bio.c
index 500389f332d9..4074a0496b93 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -229,7 +229,7 @@ void bio_init(struct bio *bio, struct block_device *bdev, struct bio_vec *table,
 	bio->bi_iter.bi_sector = 0;
 	bio->bi_iter.bi_size = 0;
 	bio->bi_iter.bi_idx = 0;
-	bio->bi_iter.bi_bvec_done = 0;
+	bio->bi_iter.bi_offset = 0;
 	bio->bi_end_io = NULL;
 	bio->bi_private = NULL;
 #ifdef CONFIG_BLK_CGROUP
@@ -1188,7 +1188,7 @@ void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter)
 
 	bio->bi_io_vec = (struct bio_vec *)iter->bvec;
 	bio->bi_iter.bi_idx = 0;
-	bio->bi_iter.bi_bvec_done = iter->iov_offset;
+	bio->bi_iter.bi_offset = iter->iov_offset;
 	bio->bi_iter.bi_size = iov_iter_count(iter);
 	bio_set_flag(bio, BIO_CLONED);
 }
diff --git a/block/blk-merge.c b/block/blk-merge.c
index ab1161ca69f1..258a726071d1 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -33,7 +33,7 @@ static inline void bio_get_last_bvec(struct bio *bio, struct bio_vec *bv)
 
 	bio_advance_iter(bio, &iter, iter.bi_size);
 
-	if (!iter.bi_bvec_done)
+	if (!iter.bi_offset)
 		idx = iter.bi_idx - 1;
 	else	/* in the middle of bvec */
 		idx = iter.bi_idx;
@@ -41,11 +41,11 @@ static inline void bio_get_last_bvec(struct bio *bio, struct bio_vec *bv)
 	*bv = bio->bi_io_vec[idx];
 
 	/*
-	 * iter.bi_bvec_done records actual length of the last bvec
+	 * iter.bi_offset records actual length of the last bvec
 	 * if this bio ends in the middle of one io vector
 	 */
-	if (iter.bi_bvec_done)
-		bv->bv_len = iter.bi_bvec_done;
+	if (iter.bi_offset)
+		bv->bv_len = iter.bi_offset;
 }
 
 static inline bool bio_will_gap(struct request_queue *q,
diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index bfdb9ed70741..88fd9cbc951f 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -44,7 +44,7 @@ static bool blk_map_iter_next(struct request *req, struct blk_map_iter *iter,
 	 * one could be merged into it.  This typically happens when moving to
 	 * the next bio, but some callers also don't pack bvecs tight.
 	 */
-	while (!iter->iter.bi_size || !iter->iter.bi_bvec_done) {
+	while (!iter->iter.bi_size || !iter->iter.bi_offset) {
 		struct bio_vec next;
 
 		if (!__blk_map_iter_next(iter))
diff --git a/block/blk.h b/block/blk.h
index eaac05815cb0..50abfd932886 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -406,7 +406,7 @@ static inline bool bio_may_need_split(struct bio *bio,
 		return true;
 
 	bv = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
-	if (bio->bi_iter.bi_size > bv->bv_len - bio->bi_iter.bi_bvec_done)
+	if (bio->bi_iter.bi_size > bv->bv_len - bio->bi_iter.bi_offset)
 		return true;
 	if ((bv->bv_offset | bv->bv_len) & lim->dma_alignment)
 		return true;
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 26d7130c3f55..8639fa34b847 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -379,7 +379,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 		iov_iter_bvec(&iter, rw,
 			__bvec_iter_bvec(rq->bio->bi_io_vec, rq->bio->bi_iter),
 			nr_bvec, blk_rq_bytes(rq));
-		iter.iov_offset = rq->bio->bi_iter.bi_bvec_done;
+		iter.iov_offset = rq->bio->bi_iter.bi_offset;
 	}
 	atomic_set(&cmd->ref, 2);
 
diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 58ec8161b7e2..4323ac108cae 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -555,7 +555,7 @@ static int zloop_do_rw(struct zloop_cmd *cmd)
 		iov_iter_bvec(&iter, rw,
 			__bvec_iter_bvec(rq->bio->bi_io_vec, rq->bio->bi_iter),
 					nr_bvec, blk_rq_bytes(rq));
-		iter.iov_offset = rq->bio->bi_iter.bi_bvec_done;
+		iter.iov_offset = rq->bio->bi_iter.bi_offset;
 	}
 
 	cmd->iocb.ki_pos = (cmd->sector - zone->start) << SECTOR_SHIFT;
diff --git a/drivers/md/dm-io-rewind.c b/drivers/md/dm-io-rewind.c
index 6155b0117c9d..04f3fc8aeb6f 100644
--- a/drivers/md/dm-io-rewind.c
+++ b/drivers/md/dm-io-rewind.c
@@ -16,12 +16,12 @@ static inline bool dm_bvec_iter_rewind(const struct bio_vec *bv,
 	int idx;
 
 	iter->bi_size += bytes;
-	if (bytes <= iter->bi_bvec_done) {
-		iter->bi_bvec_done -= bytes;
+	if (bytes <= iter->bi_offset) {
+		iter->bi_offset -= bytes;
 		return true;
 	}
 
-	bytes -= iter->bi_bvec_done;
+	bytes -= iter->bi_offset;
 	idx = iter->bi_idx - 1;
 
 	while (idx >= 0 && bytes && bytes > bv[idx].bv_len) {
@@ -32,13 +32,13 @@ static inline bool dm_bvec_iter_rewind(const struct bio_vec *bv,
 	if (WARN_ONCE(idx < 0 && bytes,
 		      "Attempted to rewind iter beyond bvec's boundaries\n")) {
 		iter->bi_size -= bytes;
-		iter->bi_bvec_done = 0;
+		iter->bi_offset = 0;
 		iter->bi_idx = 0;
 		return false;
 	}
 
 	iter->bi_idx = idx;
-	iter->bi_bvec_done = bv[idx].bv_len - bytes;
+	iter->bi_offset = bv[idx].bv_len - bytes;
 	return true;
 }
 
diff --git a/drivers/md/dm-pcache/segment.c b/drivers/md/dm-pcache/segment.c
index 7e9818701445..8f8816e1c539 100644
--- a/drivers/md/dm-pcache/segment.c
+++ b/drivers/md/dm-pcache/segment.c
@@ -14,7 +14,7 @@ int segment_copy_to_bio(struct pcache_segment *segment,
 
 	iov_iter_bvec(&iter, ITER_DEST, &bio->bi_io_vec[bio->bi_iter.bi_idx],
 			bio_segments(bio), bio->bi_iter.bi_size);
-	iter.iov_offset = bio->bi_iter.bi_bvec_done;
+	iter.iov_offset = bio->bi_iter.bi_offset;
 	if (bio_off)
 		iov_iter_advance(&iter, bio_off);
 
@@ -35,7 +35,7 @@ int segment_copy_from_bio(struct pcache_segment *segment,
 
 	iov_iter_bvec(&iter, ITER_SOURCE, &bio->bi_io_vec[bio->bi_iter.bi_idx],
 			bio_segments(bio), bio->bi_iter.bi_size);
-	iter.iov_offset = bio->bi_iter.bi_bvec_done;
+	iter.iov_offset = bio->bi_iter.bi_offset;
 	if (bio_off)
 		iov_iter_advance(&iter, bio_off);
 
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 7e1112960d7f..5d910a64503d 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1155,7 +1155,7 @@ static int btt_rw_integrity(struct btt *btt, struct bio_integrity_payload *bip,
 		bv = bvec_iter_bvec(bip->bip_vec, bip->bip_iter);
 		/*
 		 * The 'bv' obtained from bvec_iter_bvec has its .bv_len and
-		 * .bv_offset already adjusted for iter->bi_bvec_done, and we
+		 * .bv_offset already adjusted for iter->bi_offset, and we
 		 * can use those directly
 		 */
 
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index ba5c7b3e2a7c..ce03a0ea4ded 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -357,7 +357,7 @@ static void nvme_tcp_init_iter(struct nvme_tcp_request *req,
 		iov_iter_bvec(&req->iter, dir,
 			__bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter), nr_bvec,
 			bio->bi_iter.bi_size);
-		req->iter.iov_offset = bio->bi_iter.bi_bvec_done;
+		req->iter.iov_offset = bio->bi_iter.bi_offset;
 	}
 }
 
diff --git a/fs/btrfs/misc.h b/fs/btrfs/misc.h
index 694be6d0562a..802060943180 100644
--- a/fs/btrfs/misc.h
+++ b/fs/btrfs/misc.h
@@ -74,7 +74,7 @@ static inline struct bvec_iter init_bvec_iter_for_bio(struct bio *bio)
 		.bi_sector = 0,
 		.bi_size = bio_size,
 		.bi_idx = 0,
-		.bi_bvec_done = 0,
+		.bi_offset = 0,
 	};
 }
 
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 92837e2743f1..fc566ee1c1ff 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -110,7 +110,7 @@ struct bvec_iter {
 	/*
 	 * Current offset in the bvec entry pointed to by `bi_idx`.
 	 */
-	unsigned int		bi_bvec_done;
+	unsigned int		bi_offset;
 } __packed __aligned(4);
 
 struct bvec_iter_all {
@@ -135,14 +135,14 @@ mp_bvec_iter_page(const struct bio_vec *bvecs, const struct bvec_iter iter)
 static __always_inline unsigned int
 mp_bvec_iter_len(const struct bio_vec *bvecs, const struct bvec_iter iter)
 {
-	return min(__bvec_iter_bvec(bvecs, iter)->bv_len - iter.bi_bvec_done,
+	return min(__bvec_iter_bvec(bvecs, iter)->bv_len - iter.bi_offset,
 			iter.bi_size);
 }
 
 static __always_inline unsigned int
 mp_bvec_iter_offset(const struct bio_vec *bvecs, const struct bvec_iter iter)
 {
-	return __bvec_iter_bvec(bvecs, iter)->bv_offset + iter.bi_bvec_done;
+	return __bvec_iter_bvec(bvecs, iter)->bv_offset + iter.bi_offset;
 }
 
 static __always_inline unsigned int
@@ -204,7 +204,7 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
 	}
 
 	iter->bi_size -= bytes;
-	bytes += iter->bi_bvec_done;
+	bytes += iter->bi_offset;
 
 	while (bytes && bytes >= bv[idx].bv_len) {
 		bytes -= bv[idx].bv_len;
@@ -212,7 +212,7 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
 	}
 
 	iter->bi_idx = idx;
-	iter->bi_bvec_done = bytes;
+	iter->bi_offset = bytes;
 	return true;
 }
 
@@ -223,13 +223,13 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
 static inline void bvec_iter_advance_single(const struct bio_vec *bv,
 				struct bvec_iter *iter, unsigned int bytes)
 {
-	unsigned int done = iter->bi_bvec_done + bytes;
+	unsigned int done = iter->bi_offset + bytes;
 
 	if (done == bv[iter->bi_idx].bv_len) {
 		done = 0;
 		iter->bi_idx++;
 	}
-	iter->bi_bvec_done = done;
+	iter->bi_offset = done;
 	iter->bi_size -= bytes;
 }
 
diff --git a/io_uring/net.c b/io_uring/net.c
index a74d15f7b7d2..439c99ad1884 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1471,7 +1471,7 @@ static int io_sg_from_iter(struct sk_buff *skb,
 		return zerocopy_fill_skb_from_iter(skb, from, length);
 
 	bi.bi_size = min(from->count, length);
-	bi.bi_bvec_done = from->iov_offset;
+	bi.bi_offset = from->iov_offset;
 	bi.bi_idx = 0;
 
 	while (bi.bi_size && frag < MAX_SKB_FRAGS) {
@@ -1490,7 +1490,7 @@ static int io_sg_from_iter(struct sk_buff *skb,
 	from->bvec += bi.bi_idx;
 	from->nr_segs -= bi.bi_idx;
 	from->count -= copied;
-	from->iov_offset = bi.bi_bvec_done;
+	from->iov_offset = bi.bi_offset;
 
 	skb->data_len += copied;
 	skb->len += copied;
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 34a52e9ba9e1..81e5c5e5121f 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1634,7 +1634,7 @@ static ssize_t iov_iter_extract_bvec_pages(struct iov_iter *i,
 	}
 	bi.bi_idx = 0;
 	bi.bi_size = maxsize;
-	bi.bi_bvec_done = skip;
+	bi.bi_offset = skip;
 
 	maxpages = want_pages_array(pages, maxsize, skip, maxpages);
 	if (!maxpages)
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 34b3097b4c7b..9c1b6cf8c36f 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -762,7 +762,7 @@ static bool ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
 	if (!cursor->resid)
 		return false;   /* no more data */
 
-	if (!bytes || (it->iter.bi_size && it->iter.bi_bvec_done &&
+	if (!bytes || (it->iter.bi_size && it->iter.bi_offset &&
 		       page == bio_iter_page(it->bio, it->iter)))
 		return false;	/* more bytes to process in this segment */
 
@@ -817,7 +817,7 @@ static bool ceph_msg_data_bvecs_advance(struct ceph_msg_data_cursor *cursor,
 	if (!cursor->resid)
 		return false;   /* no more data */
 
-	if (!bytes || (cursor->bvec_iter.bi_bvec_done &&
+	if (!bytes || (cursor->bvec_iter.bi_offset &&
 		       page == bvec_iter_page(bvecs, cursor->bvec_iter)))
 		return false;	/* more bytes to process in this segment */
 
-- 
2.54.0

