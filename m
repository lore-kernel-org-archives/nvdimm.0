Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E6124501D;
	Sun, 23 Aug 2026 13:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787491949; cv=none; b=Ue5xnc9J2v/sIKwcpfgko4SoHF1BM7kRQrb8WYp7mjHktL/ehRb+c9/5pIgWTvulCrs9N/JVHAXfg67k9fwjMPJS32GA5FNqnF8l23GubtqwkdxeHXQVKt1hR7ihk47hTnm9btyDZhq7LR0tgRglGAyq6+ZwvfuNDUnh1GtUqrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787491949; c=relaxed/simple;
	bh=sGAeuwop68iSRNccwm4xy7cz53H/ou2YME6mAF6IeEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rA3wNOTaFCyc0qItKkGLgGV2nAXY2W1SXt93O8rpZezRJZDYBGOMSZ6entde+iTOZT9xv6zpWpJVzgeFDaKVpyrlT/ispUCeMBmWuVPc6FhMVzU5Kk5JHjx8o88XYFcHm3c5kodRj0o1eeYdINBtRlKZvdgxTb5tdcqxtOjyoS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gX1L0FWZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gX1L0FWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2461F00A3A;
	Sun, 23 Aug 2026 13:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787491946;
	bh=GKlGF/KH9Cah8vWXA7MF5Td6HKFvPpxfCS139QvygZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gX1L0FWZqz7AGAHsnx51w9SISWS5ZZuw6qBzoje7UqCOyWPw+qO4TCFcmV4Ckdatg
	 ruATpJWXUm+n6uu+IpqtiNMQtw95im1oWFXkAcInFiw3Kd3JvhCGjZsc1oXtWaZsPB
	 k2jdaW76KaLE0gEG+6zIk23l2LN/GR8ycyv3pXyoRB0Aqp2o33oAIc1MYfZUTobdpY
	 EbMpJNfRRLtDRWYkXLuj6R/941pWSVLlP96hqDhR941b6YKlxeM6theTORAjSyZRGx
	 krNCRisk4tv5tVjabkWYUgA9xV+esl5e7efeBb1qNB4GDoCF/ylG7K1/vMTKVI4eNS
	 P45CJ+WQ9zJxg==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>,
	Tao Cui <cui.tao@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
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
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] blk-cgroup: store blkcg in bio instead of blkg
Date: Sun, 23 Aug 2026 21:30:44 +0800
Message-ID: <20260823133045.970199-3-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260823133045.970199-1-yukuai@kernel.org>
References: <20260823133045.970199-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

A bio currently stores and pins a queue-local blkg. This forces bio
association and remap paths to look up or create a blkg even when no
blkcg policy will use the bio, and ties the stored state to the current
block device.

Store and reference the queue-independent blkcg in the bio instead. Add
helpers that lazily look up or create the queue-local blkg when a policy
needs it, and pin the result until the bio changes devices or releases
its cgroup state.

If blkg creation fails while walking down the hierarchy, use the closest
available ancestor and update the bio's blkcg association before recording
the blkg reference. This keeps later CSS ID hash lookups matched with the
pinned blkg.

Keep lookup-only users from creating missing blkgs. A pinned blkg remains
in the queue hash until the bio drops its reference, so allow the bio to
recover it from the hash after the blkg starts dying. Rename the bio
association helpers to describe the blkcg state they now store.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst |   2 +-
 block/bfq-cgroup.c                      |  16 +-
 block/bfq-iosched.c                     |  19 +-
 block/bio.c                             |  22 +--
 block/blk-cgroup-fc-appid.c             |  10 +-
 block/blk-cgroup.c                      | 237 +++++++++++++++---------
 block/blk-cgroup.h                      |  35 +++-
 block/blk-crypto-fallback.c             |   2 +-
 block/blk-iocost.c                      |  12 +-
 block/blk-iolatency.c                   |  11 +-
 block/blk-ioprio.c                      |   2 +-
 block/blk-throttle.c                    |   2 +-
 block/blk-throttle.h                    |   2 +-
 drivers/md/bcache/request.c             |   2 +-
 drivers/md/dm.c                         |   2 +-
 drivers/md/md.c                         |   2 +-
 drivers/nvdimm/nd_virtio.c              |   2 +-
 fs/gfs2/lops.c                          |   3 +-
 include/linux/bio.h                     |  26 +--
 include/linux/blk_types.h               |   9 +-
 include/linux/writeback.h               |   2 +-
 mm/page_io.c                            |  13 +-
 22 files changed, 271 insertions(+), 162 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 14b8c571c0d1..bbd79931d5ab 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -3233,11 +3233,11 @@ incompatible.
 wbc_init_bio() binds the specified bio to its cgroup.  Depending on
 the configuration, the bio may be executed at a lower priority and if
 the writeback session is holding shared resources, e.g. a journal
 entry, may lead to priority inversion.  There is no one easy solution
 for the problem.  Filesystems can try to work around specific problem
-cases by skipping wbc_init_bio() and using bio_associate_blkg()
+cases by skipping wbc_init_bio() and using bio_associate_blkcg()
 directly.
 
 
 Deprecated v1 Core Features
 ===========================
diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index ef9d63e8542e..4a3975f9ff74 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -361,15 +361,17 @@ void bfqg_and_blkg_put(struct bfq_group *bfqg)
 	bfqg_put(bfqg);
 }
 
 void bfqg_stats_update_legacy_io(struct request_queue *q, struct request *rq)
 {
-	struct bfq_group *bfqg = blkg_to_bfqg(rq->bio->bi_blkg);
+	struct blkcg_gq *blkg = bio_blkg_lookup(rq->bio);
+	struct bfq_group *bfqg;
 
-	if (!bfqg)
+	if (!blkg)
 		return;
 
+	bfqg = blkg_to_bfqg(blkg);
 	blkg_rwstat_add(&bfqg->stats.bytes, rq->cmd_flags, blk_rq_bytes(rq));
 	blkg_rwstat_add(&bfqg->stats.ios, rq->cmd_flags, 1);
 }
 
 /* @stats = 0 */
@@ -604,27 +606,29 @@ static void bfq_link_bfqg(struct bfq_data *bfqd, struct bfq_group *bfqg)
 	}
 }
 
 struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
 {
-	struct blkcg_gq *blkg = bio->bi_blkg;
+	struct blkcg_gq *blkg = bio_blkg_lookup(bio);
 	struct bfq_group *bfqg;
 
 	while (blkg) {
 		if (!data_race(blkg->online)) {
 			blkg = blkg->parent;
 			continue;
 		}
+
 		bfqg = blkg_to_bfqg(blkg);
 		if (bfqg->pd.online) {
-			bio_associate_blkg_from_css(bio, &blkg->blkcg->css);
+			bio_associate_blkcg_from_css(bio, &blkg->blkcg->css);
 			return bfqg;
 		}
 		blkg = blkg->parent;
 	}
-	bio_associate_blkg_from_css(bio,
-				&bfqg_to_blkg(bfqd->root_group)->blkcg->css);
+
+	blkg = bfqg_to_blkg(bfqd->root_group);
+	bio_associate_blkcg_from_css(bio, &blkg->blkcg->css);
 	return bfqd->root_group;
 }
 
 /**
  * bfq_bfqq_move - migrate @bfqq to @bfqg.
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 0f75301b3115..d4f657bc7a4e 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -126,10 +126,11 @@
 
 #include <trace/events/block.h>
 
 #include "elevator.h"
 #include "blk.h"
+#include "blk-cgroup.h"
 #include "blk-mq.h"
 #include "blk-mq-sched.h"
 #include "bfq-iosched.h"
 #include "blk-wbt.h"
 
@@ -2450,19 +2451,20 @@ static bool bfq_bio_merge(struct request_queue *q, struct bio *bio,
 	struct bfq_data *bfqd = q->elevator->elevator_data;
 	struct bfq_io_cq *bic = bfq_bic_lookup(q);
 	struct request *free = NULL;
 	bool ret;
 
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	/* blkg creation takes q->queue_lock, so do it before bfqd->lock. */
+	if (bic)
+		bio_blkg(bio);
+#endif
+
 	spin_lock_irq(&bfqd->lock);
 
 	if (bic) {
-		/*
-		 * Make sure cgroup info is uptodate for current process before
-		 * considering the merge.
-		 */
 		bfq_bic_update_cgroup(bic, bio);
-
 		bfqd->bio_bfqq = bic_to_bfqq(bic, op_is_sync(bio->bi_opf),
 					     bfq_actuator_index(bfqd, bio));
 	} else {
 		bfqd->bio_bfqq = NULL;
 	}
@@ -6243,10 +6245,17 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	bool idle_timer_disabled = false;
 	blk_opf_t cmd_flags;
 	LIST_HEAD(free);
 
 #ifdef CONFIG_BFQ_GROUP_IOSCHED
+	/*
+	 * Pin the blkg used to look up bfqg.  If this is the first IO for
+	 * the blkcg on this queue, create the bfqg before holding bfqd->lock.
+	 */
+	if (rq->bio && !bio_flagged(rq->bio, BIO_BLKG_REF))
+		bio_blkg(rq->bio);
+
 	if (!cgroup_subsys_on_dfl(io_cgrp_subsys) && rq->bio)
 		bfqg_stats_update_legacy_io(q, rq);
 #endif
 	spin_lock_irq(&bfqd->lock);
 	bfqq = bfq_init_rq(rq);
diff --git a/block/bio.c b/block/bio.c
index 898b2f5ef8c8..6c84042adf5d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -177,16 +177,11 @@ static inline gfp_t try_alloc_gfp(gfp_t gfp)
 		__GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
 }
 
 void bio_uninit(struct bio *bio)
 {
-#ifdef CONFIG_BLK_CGROUP
-	if (bio->bi_blkg) {
-		blkg_put(bio->bi_blkg);
-		bio->bi_blkg = NULL;
-	}
-#endif
+	bio_clear_blkcg(bio);
 	if (bio_integrity(bio))
 		bio_integrity_free(bio);
 
 	bio_crypt_free_ctx(bio);
 }
@@ -231,14 +226,14 @@ void bio_init(struct bio *bio, struct block_device *bdev, struct bio_vec *table,
 	bio->bi_iter.bi_idx = 0;
 	bio->bi_iter.bi_offset = 0;
 	bio->bi_end_io = NULL;
 	bio->bi_private = NULL;
 #ifdef CONFIG_BLK_CGROUP
-	bio->bi_blkg = NULL;
+	bio->bi_blkcg = NULL;
 	bio->issue_time_ns = 0;
 	if (bdev)
-		bio_associate_blkg(bio);
+		bio_associate_blkcg(bio);
 #ifdef CONFIG_BLK_CGROUP_IOCOST
 	bio->bi_iocost_cost = 0;
 #endif
 #endif
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
@@ -279,11 +274,11 @@ void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf)
 	memset(bio, 0, BIO_RESET_BYTES);
 	atomic_set(&bio->__bi_remaining, 1);
 	bio->bi_io_vec = bv;
 	bio->bi_bdev = bdev;
 	if (bio->bi_bdev)
-		bio_associate_blkg(bio);
+		bio_associate_blkcg(bio);
 	bio->bi_opf = opf;
 }
 EXPORT_SYMBOL(bio_reset);
 
 /**
@@ -864,11 +859,11 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 
 	if (bio->bi_bdev) {
 		if (bio->bi_bdev == bio_src->bi_bdev &&
 		    bio_flagged(bio_src, BIO_REMAPPED))
 			bio_set_flag(bio, BIO_REMAPPED);
-		bio_clone_blkg_association(bio, bio_src);
+		bio_clone_blkcg_association(bio, bio_src);
 	}
 
 	if (bio_crypt_clone(bio, bio_src, gfp) < 0)
 		return -ENOMEM;
 	if (bio_integrity(bio_src) &&
@@ -1908,21 +1903,16 @@ void bio_endio(struct bio *bio)
 	if (bio->bi_end_io == bio_chain_endio) {
 		bio = __bio_chain_endio(bio);
 		goto again;
 	}
 
-#ifdef CONFIG_BLK_CGROUP
 	/*
 	 * Release cgroup info.  We shouldn't have to do this here, but quite
 	 * a few callers of bio_init fail to call bio_uninit, so we cover up
 	 * for that here at least for now.
 	 */
-	if (bio->bi_blkg) {
-		blkg_put(bio->bi_blkg);
-		bio->bi_blkg = NULL;
-	}
-#endif
+	bio_clear_blkcg(bio);
 
 	if (bio_flagged(bio, BIO_COMPLETE_IN_TASK) && bio_in_atomic())
 		__bio_complete_in_task(bio);
 	else if (bio->bi_end_io)
 		bio->bi_end_io(bio);
diff --git a/block/blk-cgroup-fc-appid.c b/block/blk-cgroup-fc-appid.c
index 3ec21333f393..7589c6209989 100644
--- a/block/blk-cgroup-fc-appid.c
+++ b/block/blk-cgroup-fc-appid.c
@@ -48,10 +48,16 @@ EXPORT_SYMBOL_GPL(blkcg_set_fc_appid);
  *
  * On success return the fc_app_id, on failure return NULL
  */
 char *blkcg_get_fc_appid(struct bio *bio)
 {
-	if (!bio->bi_blkg || bio->bi_blkg->blkcg->fc_app_id[0] == '\0')
+	struct blkcg *blkcg = bio_blkcg(bio);
+
+	if (!blkcg)
+		return NULL;
+
+	if (blkcg->fc_app_id[0] == '\0')
 		return NULL;
-	return bio->bi_blkg->blkcg->fc_app_id;
+
+	return blkcg->fc_app_id;
 }
 EXPORT_SYMBOL_GPL(blkcg_get_fc_appid);
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 7245e316e0f9..b23f1e2d568d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -259,19 +259,19 @@ static void blkg_async_bio_workfn(struct work_struct *work)
  * cgroup.  Use this helper instead of submit_bio to punt the actual issuing to
  * a dedicated per-blkcg work item to avoid such priority inversions.
  */
 void blkcg_punt_bio_submit(struct bio *bio)
 {
-	struct blkcg_gq *blkg = bio->bi_blkg;
+	struct blkcg_gq *blkg = bio_blkg(bio);
 
-	if (blkg->parent) {
+	if (blkg && blkg->parent) {
 		spin_lock(&blkg->async_bio_lock);
 		bio_list_add(&blkg->async_bios, bio);
 		spin_unlock(&blkg->async_bio_lock);
 		queue_work(blkcg_punt_bio_wq, &blkg->async_bio_work);
 	} else {
-		/* never bounce for the root cgroup */
+		/* Never bounce if there is no non-root blkg to queue on. */
 		submit_bio(bio);
 	}
 }
 EXPORT_SYMBOL_GPL(blkcg_punt_bio_submit);
 
@@ -295,13 +295,17 @@ subsys_initcall(blkcg_punt_bio_init);
  * associated. Callers are expected to either handle %NULL or know association
  * has been done prior to calling this.
  */
 struct cgroup_subsys_state *bio_blkcg_css(struct bio *bio)
 {
-	if (!bio || !bio->bi_blkg)
+	struct blkcg *blkcg;
+
+	if (!bio)
 		return NULL;
-	return &bio->bi_blkg->blkcg->css;
+
+	blkcg = bio_blkcg(bio);
+	return blkcg ? &blkcg->css : NULL;
 }
 EXPORT_SYMBOL_GPL(bio_blkcg_css);
 
 /**
  * blkcg_parent - get the parent of a blkcg
@@ -473,32 +477,48 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 	if (new_blkg)
 		blkg_free(new_blkg);
 	return ERR_PTR(ret);
 }
 
+/*
+ * The root blkg holds a live reference while the disk is active, so walking
+ * the parent chain always finds a blkg which can be pinned.
+ */
+static struct blkcg_gq *blkg_lookup_tryget(struct blkcg_gq *blkg)
+{
+	while (!blkg_tryget(blkg))
+		blkg = blkg->parent;
+	return blkg;
+}
+
 /**
  * blkg_lookup_create - lookup blkg, try to create one if not there
  * @blkcg: blkcg of interest
  * @disk: gendisk of interest
  *
  * Lookup blkg for the @blkcg - @disk pair.  If it doesn't exist, try to
  * create one.  blkg creation is performed recursively from blkcg_root such
- * that all non-root blkg's have access to the parent blkg.  This function
- * should be called under RCU read lock and takes @disk->queue->queue_lock.
+ * that all non-root blkg's have access to the parent blkg.
+ *
+ * Must be called with @disk->queue->queue_lock held.
  *
- * Returns the blkg or the closest blkg if blkg_create() fails as it walks
- * down from root.
+ * Returns the closest blkg with an extra reference acquired.  If
+ * blkg_create() fails while walking down from root, the returned blkg may
+ * belong to an ancestor of @blkcg.  This function never returns %NULL.
  */
 static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 		struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
 	struct blkcg_gq *blkg;
 
+	lockdep_assert_held(&q->queue_lock);
+
 	rcu_read_lock();
 	blkg = blkg_lookup(blkcg, q);
 	if (blkg) {
+		blkg = blkg_lookup_tryget(blkg);
 		rcu_read_unlock();
 		return blkg;
 	}
 	rcu_read_unlock();
 
@@ -530,11 +550,11 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 		}
 		if (pos == blkcg)
 			break;
 	}
 
-	return blkg;
+	return blkg_lookup_tryget(blkg);
 }
 
 static void blkg_destroy(struct blkcg_gq *blkg)
 {
 	struct blkcg *blkcg = blkg->blkcg;
@@ -2052,133 +2072,169 @@ void blkcg_add_delay(struct blkcg_gq *blkg, u64 now, u64 delta)
 		return;
 	blkcg_scale_delay(blkg, now);
 	atomic64_add(delta, &blkg->delay_nsec);
 }
 
-static inline struct blkcg_gq *blkg_lookup_tryget(struct blkcg_gq *blkg)
+/*
+ * Return the blkg pinned by @bio through BIO_BLKG_REF.  The returned blkg is
+ * already owned by @bio and no extra reference is acquired.
+ */
+static struct blkcg_gq *bio_pinned_blkg(struct bio *bio)
 {
-retry:
-	if (blkg_tryget(blkg))
-		return blkg;
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+	struct blkcg_gq *blkg;
 
-	blkg = blkg->parent;
-	if (blkg)
-		goto retry;
+	rcu_read_lock();
+	blkg = blkg_lookup_any(bio_blkcg(bio), q);
+	rcu_read_unlock();
 
-	return NULL;
+	WARN_ON_ONCE(!blkg);
+	return blkg;
 }
+
+static void bio_set_blkg_ref(struct bio *bio, struct blkcg_gq *blkg)
+{
+	if (bio_blkcg(bio) != blkg->blkcg) {
+		css_get(&blkg->blkcg->css);
+		bio_clear_blkcg(bio);
+		bio->bi_blkcg = blkg->blkcg;
+	}
+	bio_set_flag(bio, BIO_BLKG_REF);
+}
+
 /**
- * blkg_tryget_closest - try and get a blkg ref on the closet blkg
+ * bio_blkg_lookup - look up a blkg associated with a bio
  * @bio: target bio
- * @css: target css
  *
- * As the failure mode here is to walk up the blkg tree, this ensure that the
- * blkg->parent pointers are always valid.  This returns the blkg that it ended
- * up taking a reference on or %NULL if no reference was taken.
+ * Return the blkg already pinned by @bio, or %NULL if @bio doesn't own a blkg
+ * reference.  Call bio_blkg() instead when a missing blkg should be created.
  */
-static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
-		struct cgroup_subsys_state *css)
+struct blkcg_gq *bio_blkg_lookup(struct bio *bio)
 {
-	struct request_queue *q = bio->bi_bdev->bd_queue;
-	struct blkcg *blkcg = css_to_blkcg(css);
+	if (!bio_flagged(bio, BIO_BLKG_REF))
+		return NULL;
+	return bio_pinned_blkg(bio);
+}
+EXPORT_SYMBOL_GPL(bio_blkg_lookup);
+
+/**
+ * bio_put_blkg_ref - drop the blkg reference pinned by a bio
+ * @bio: target bio
+ *
+ * Drop the bio-owned blkg reference acquired by bio_blkg(), if any.
+ */
+void bio_put_blkg_ref(struct bio *bio)
+{
+	if (bio_flagged(bio, BIO_BLKG_REF)) {
+		struct blkcg_gq *blkg = bio_pinned_blkg(bio);
+
+		if (blkg)
+			blkg_put(blkg);
+		bio_clear_flag(bio, BIO_BLKG_REF);
+	}
+}
+EXPORT_SYMBOL_GPL(bio_put_blkg_ref);
+
+/**
+ * bio_blkg - look up the blkg associated with a bio
+ * @bio: target bio
+ *
+ * Look up the queue-local blkg for @bio's current device and blkcg.  If this
+ * is the first policy use of @bio, create the missing blkg hierarchy if
+ * necessary, pin the closest available blkg, and update @bio's blkcg
+ * association if allocation falls back to an ancestor.
+ */
+struct blkcg_gq *bio_blkg(struct bio *bio)
+{
+	struct blkcg *blkcg = bio_blkcg(bio);
+	struct gendisk *disk;
+	struct request_queue *q;
 	struct blkcg_gq *blkg;
 
-	rcu_read_lock();
-	blkg = blkg_lookup(blkcg, q);
-	if (likely(blkg))
-		blkg = blkg_lookup_tryget(blkg);
-	rcu_read_unlock();
+	if (!blkcg || !bio->bi_bdev)
+		return NULL;
 
-	if (blkg)
-		return blkg;
+	if (bio_flagged(bio, BIO_BLKG_REF))
+		return bio_pinned_blkg(bio);
+
+	disk = bio->bi_bdev->bd_disk;
+	q = disk->queue;
 
-	/*
-	 * Fast path failed, we're probably issuing IO in this cgroup the first
-	 * time, hold lock to create new blkg.
-	 */
 	spin_lock_irq(&q->queue_lock);
-	blkg = blkg_lookup_create(blkcg, bio->bi_bdev->bd_disk);
-	if (blkg)
-		blkg = blkg_lookup_tryget(blkg);
+	blkg = blkg_lookup_create(blkcg, disk);
 	spin_unlock_irq(&q->queue_lock);
 
+	bio_set_blkg_ref(bio, blkg);
 	return blkg;
 }
+EXPORT_SYMBOL_GPL(bio_blkg);
 
 /**
- * bio_associate_blkg_from_css - associate a bio with a specified css
+ * bio_associate_blkcg_from_css - associate a bio with a specified css
  * @bio: target bio
  * @css: target css
  *
- * Associate @bio with the blkg found by combining the css's blkg and the
- * request_queue of the @bio.  An association failure is handled by walking up
- * the blkg tree.  Therefore, the blkg associated can be anything between @blkg
- * and q->root_blkg.  This situation only happens when a cgroup is dying and
- * then the remaining bios will spill to the closest alive blkg.
+ * Associate @bio with the blkcg found from @css.  The queue-local blkg is
+ * created and pinned by bio_blkg() when blkcg policies need it.  If @css
+ * can't be referenced online, associate @bio with the root blkcg instead.
  *
- * A reference will be taken on the blkg and will be released when @bio is
+ * A reference will be taken on the blkcg and will be released when @bio is
  * freed.
  */
-void bio_associate_blkg_from_css(struct bio *bio,
-				 struct cgroup_subsys_state *css)
+void bio_associate_blkcg_from_css(struct bio *bio,
+				  struct cgroup_subsys_state *css)
 {
-	if (bio->bi_blkg)
-		blkg_put(bio->bi_blkg);
+	struct blkcg *blkcg;
 
-	if (css && css->parent) {
-		bio->bi_blkg = blkg_tryget_closest(bio, css);
-	} else {
-		blkg_get(bdev_get_queue(bio->bi_bdev)->root_blkg);
-		bio->bi_blkg = bdev_get_queue(bio->bi_bdev)->root_blkg;
+	if (!css || !css_tryget_online(css)) {
+		css = &blkcg_root.css;
+		css_get(css);
+	}
+
+	blkcg = css_to_blkcg(css);
+	if (bio_blkcg(bio) == blkcg) {
+		css_put(css);
+		return;
 	}
+
+	bio_clear_blkcg(bio);
+	bio->bi_blkcg = blkcg;
 }
-EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
+EXPORT_SYMBOL_GPL(bio_associate_blkcg_from_css);
 
 /**
- * bio_associate_blkg - associate a bio with a blkg
+ * bio_associate_blkcg - associate a bio with a blkcg
  * @bio: target bio
  *
- * Associate @bio with the blkg found from the bio's css and request_queue.
- * If one is not found, bio_lookup_blkg() creates the blkg.  If a blkg is
- * already associated, the css is reused and association redone as the
- * request_queue may have changed.
+ * Associate @bio with the blkcg found from the bio's css.  If a blkcg is
+ * already associated, keep it as blkcg association is not queue-local.
  */
-void bio_associate_blkg(struct bio *bio)
+void bio_associate_blkcg(struct bio *bio)
 {
-	struct cgroup_subsys_state *css;
-
 	if (blk_op_is_passthrough(bio->bi_opf))
 		return;
 
-	if (bio->bi_blkg) {
-		css = bio_blkcg_css(bio);
-		bio_associate_blkg_from_css(bio, css);
-	} else {
-		rcu_read_lock();
-		css = blkcg_css();
-		if (!css_tryget_online(css))
-			css = NULL;
-		rcu_read_unlock();
+	if (bio_blkcg(bio))
+		return;
 
-		bio_associate_blkg_from_css(bio, css);
-		if (css)
-			css_put(css);
-	}
+	rcu_read_lock();
+	bio_associate_blkcg_from_css(bio, blkcg_css());
+	rcu_read_unlock();
 }
-EXPORT_SYMBOL_GPL(bio_associate_blkg);
+EXPORT_SYMBOL_GPL(bio_associate_blkcg);
 
 /**
- * bio_clone_blkg_association - clone blkg association from src to dst bio
+ * bio_clone_blkcg_association - clone blkcg association from src to dst bio
  * @dst: destination bio
  * @src: source bio
  */
-void bio_clone_blkg_association(struct bio *dst, struct bio *src)
+void bio_clone_blkcg_association(struct bio *dst, struct bio *src)
 {
-	if (src->bi_blkg)
-		bio_associate_blkg_from_css(dst, bio_blkcg_css(src));
+	if (bio_blkcg(src))
+		bio_associate_blkcg_from_css(dst, bio_blkcg_css(src));
 }
-EXPORT_SYMBOL_GPL(bio_clone_blkg_association);
+EXPORT_SYMBOL_GPL(bio_clone_blkcg_association);
 
 static int blk_cgroup_io_type(struct bio *bio)
 {
 	if (op_is_discard(bio->bi_opf))
 		return BLKG_IOSTAT_DISCARD;
@@ -2187,24 +2243,31 @@ static int blk_cgroup_io_type(struct bio *bio)
 	return BLKG_IOSTAT_READ;
 }
 
 void blk_cgroup_bio_start(struct bio *bio)
 {
-	struct blkcg *blkcg = bio->bi_blkg->blkcg;
+	struct blkcg *blkcg = bio_blkcg(bio);
+	struct blkcg_gq *blkg;
 	int rwd = blk_cgroup_io_type(bio), cpu;
 	struct blkg_iostat_set *bis;
 	unsigned long flags;
 
 	if (!cgroup_subsys_on_dfl(io_cgrp_subsys))
 		return;
+	if (!blkcg)
+		return;
 
 	/* Root-level stats are sourced from system-wide IO stats */
 	if (!cgroup_parent(blkcg->css.cgroup))
 		return;
 
+	blkg = bio_blkg_lookup(bio);
+	if (!blkg)
+		return;
+
 	cpu = get_cpu();
-	bis = per_cpu_ptr(bio->bi_blkg->iostat_cpu, cpu);
+	bis = per_cpu_ptr(blkg->iostat_cpu, cpu);
 	flags = u64_stats_update_begin_irqsave(&bis->sync);
 
 	/*
 	 * If the bio is flagged with BIO_CGROUP_ACCT it means this is a split
 	 * bio and we would have already accounted for the size of the bio.
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 7278a8817a49..8d0df8ed5813 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -124,10 +124,15 @@ struct blkcg {
 static inline struct blkcg *css_to_blkcg(struct cgroup_subsys_state *css)
 {
 	return css ? container_of(css, struct blkcg, css) : NULL;
 }
 
+static inline struct blkcg *bio_blkcg(struct bio *bio)
+{
+	return bio->bi_blkcg;
+}
+
 /*
  * A blkcg_gq (blkg) is association between a block cgroup (blkcg) and a
  * request_queue (q).  This is used by blkcg policies which need to track
  * information per blkcg - q pair.
  *
@@ -257,20 +262,21 @@ static inline bool bio_issue_as_root_blkg(struct bio *bio)
  * @blkcg: blkcg of interest
  * @q: request_queue of interest
  *
  * Lookup a blkg for the @blkcg - @q pair, whether it is online or dying.
  *
- * Must be called in a RCU critical section.
+ * Must be called with either RCU read lock or queue_lock held.
  *
  * This does not acquire a reference.  The caller must already hold one, or
  * have the blkg pinned by I/O.
  */
 static inline struct blkcg_gq *blkg_lookup_any(struct blkcg *blkcg,
 					       struct request_queue *q)
 {
-	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
-			 "blkg_lookup_any() requires an RCU read lock");
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
+			 !lockdep_is_held(&q->queue_lock),
+			 "blkg_lookup_any() requires an RCU read lock or queue_lock");
 
 	return rhashtable_lookup(&q->blkg_hash, &blkcg->css.id,
 				 blkg_hash_params);
 }
 
@@ -279,11 +285,11 @@ static inline struct blkcg_gq *blkg_lookup_any(struct blkcg *blkcg,
  * @blkcg: blkcg of interest
  * @q: request_queue of interest
  *
  * Lookup an online blkg for the @blkcg - @q pair.
  *
- * Must be called in a RCU critical section.
+ * Must be called with either RCU read lock or queue_lock held.
  */
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
 					   struct request_queue *q)
 {
 	struct blkcg_gq *blkg;
@@ -295,10 +301,13 @@ static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
 	if (blkg && !READ_ONCE(blkg->online))
 		blkg = NULL;
 	return blkg;
 }
 
+struct blkcg_gq *bio_blkg_lookup(struct bio *bio);
+struct blkcg_gq *bio_blkg(struct bio *bio);
+
 /**
  * blkg_to_pd - get policy private data
  * @blkg: blkg of interest
  * @pol: policy of interest
  *
@@ -362,10 +371,22 @@ static inline bool blkg_tryget(struct blkcg_gq *blkg)
 static inline void blkg_put(struct blkcg_gq *blkg)
 {
 	percpu_ref_put(&blkg->refcnt);
 }
 
+static inline void bio_clear_blkcg(struct bio *bio)
+{
+	struct blkcg *blkcg = bio_blkcg(bio);
+
+	bio_put_blkg_ref(bio);
+
+	if (blkcg) {
+		css_put(&blkcg->css);
+		bio->bi_blkcg = NULL;
+	}
+}
+
 /**
  * blkg_for_each_descendant_pre - pre-order walk of a blkg's descendants
  * @d_blkg: loop cursor pointing to the current descendant
  * @pos_css: used for iteration
  * @p_blkg: target blkg to walk descendants of
@@ -491,11 +512,11 @@ static inline void blkcg_clear_delay(struct blkcg_gq *blkg)
  * match. The latter is necessary as we don't want to throttle e.g. a metadata
  * update because it happens to be next to a regular IO.
  */
 static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio)
 {
-	return rq->bio->bi_blkg == bio->bi_blkg &&
+	return bio_blkcg(rq->bio) == bio_blkcg(bio) &&
 		bio_issue_as_root_blkg(rq->bio) == bio_issue_as_root_blkg(bio);
 }
 
 static inline bool blkcg_policy_enabled(struct request_queue *q,
 				const struct blkcg_policy *pol)
@@ -517,10 +538,13 @@ struct blkcg_policy {
 };
 
 struct blkcg {
 };
 
+static inline struct blkcg *bio_blkcg(struct bio *bio) { return NULL; }
+static inline struct blkcg_gq *bio_blkg_lookup(struct bio *bio) { return NULL; }
+static inline struct blkcg_gq *bio_blkg(struct bio *bio) { return NULL; }
 static inline struct blkcg_gq *blkg_lookup_any(struct blkcg *blkcg, void *key) { return NULL; }
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { return NULL; }
 static inline int blkg_init_queue(struct request_queue *q) { return 0; }
 static inline void blkg_exit_queue(struct request_queue *q) { }
 static inline int blkcg_init_disk(struct gendisk *disk) { return 0; }
@@ -535,10 +559,11 @@ static inline void blkcg_deactivate_policy(struct gendisk *disk,
 static inline struct blkg_policy_data *blkg_to_pd(struct blkcg_gq *blkg,
 						  const struct blkcg_policy *pol) { return NULL; }
 static inline struct blkcg_gq *pd_to_blkg(struct blkg_policy_data *pd) { return NULL; }
 static inline void blkg_get(struct blkcg_gq *blkg) { }
 static inline void blkg_put(struct blkcg_gq *blkg) { }
+static inline void bio_clear_blkcg(struct bio *bio) { }
 static inline void blk_cgroup_bio_start(struct bio *bio) { }
 static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio) { return true; }
 
 #define blk_queue_for_each_rl(rl, q)	\
 	for ((rl) = &(q)->root_rl; (rl); (rl) = NULL)
diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 2a5c52ab74b4..5ef4baab444b 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -185,11 +185,11 @@ static struct bio *blk_crypto_alloc_enc_bio(struct bio *bio_src,
 	bio->bi_end_io		= blk_crypto_fallback_encrypt_endio;
 	bio->bi_ioprio		= bio_src->bi_ioprio;
 	bio->bi_write_hint	= bio_src->bi_write_hint;
 	bio->bi_write_stream	= bio_src->bi_write_stream;
 	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
-	bio_clone_blkg_association(bio, bio_src);
+	bio_clone_blkcg_association(bio, bio_src);
 
 	/*
 	 * Move page array up in the allocated memory for the bio vecs as far as
 	 * possible so that we can start filling biovecs from the beginning
 	 * without overwriting the temporary page array.
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 2745bffcd5ee..57f2b4d4af20 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2684,11 +2684,11 @@ iocg_handle_over_budget(struct rq_qos *rqos, struct ioc_gq *iocg,
 	return action_wait;
 }
 
 static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 {
-	struct blkcg_gq *blkg = bio->bi_blkg;
+	struct blkcg_gq *blkg = bio_blkg(bio);
 	struct ioc *ioc = rqos_to_ioc(rqos);
 	struct ioc_gq *iocg = blkg_to_iocg(blkg);
 	struct ioc_now now;
 	struct iocg_wait wait;
 	u64 abs_cost, cost, vtime;
@@ -2773,11 +2773,11 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 }
 
 static void ioc_rqos_merge(struct rq_qos *rqos, struct request *rq,
 			   struct bio *bio)
 {
-	struct ioc_gq *iocg = blkg_to_iocg(bio->bi_blkg);
+	struct ioc_gq *iocg = blkg_to_iocg(bio_blkg(bio));
 	struct ioc *ioc = rqos_to_ioc(rqos);
 	sector_t bio_end = bio_end_sector(bio);
 	struct ioc_now now;
 	u64 vtime, abs_cost, cost;
 	unsigned long flags;
@@ -2831,13 +2831,17 @@ static void ioc_rqos_merge(struct rq_qos *rqos, struct request *rq,
 	spin_unlock_irqrestore(&ioc->lock, flags);
 }
 
 static void ioc_rqos_done_bio(struct rq_qos *rqos, struct bio *bio)
 {
-	struct ioc_gq *iocg = blkg_to_iocg(bio->bi_blkg);
+	struct ioc_gq *iocg;
+
+	if (!bio->bi_iocost_cost)
+		return;
 
-	if (iocg && bio->bi_iocost_cost)
+	iocg = blkg_to_iocg(bio_blkg_lookup(bio));
+	if (iocg)
 		atomic64_add(bio->bi_iocost_cost, &iocg->done_vtime);
 }
 
 static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 {
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 2caa79a008ad..7220edafd72b 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -461,11 +461,11 @@ static void check_scale_change(struct iolatency_grp *iolat)
 }
 
 static void blkcg_iolatency_throttle(struct rq_qos *rqos, struct bio *bio)
 {
 	struct blk_iolatency *blkiolat = BLKIOLATENCY(rqos);
-	struct blkcg_gq *blkg = bio->bi_blkg;
+	struct blkcg_gq *blkg = bio_blkg(bio);
 	bool issue_as_root = bio_issue_as_root_blkg(bio);
 
 	if (!blkiolat->enabled)
 		return;
 
@@ -588,15 +588,18 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 	u64 window_start;
 	u64 now;
 	bool issue_as_root = bio_issue_as_root_blkg(bio);
 	int inflight = 0;
 
-	blkg = bio->bi_blkg;
-	if (!blkg || !bio_flagged(bio, BIO_QOS_THROTTLED))
+	if (!bio_flagged(bio, BIO_QOS_THROTTLED))
 		return;
 
-	iolat = blkg_to_lat(bio->bi_blkg);
+	blkg = bio_blkg_lookup(bio);
+	if (!blkg)
+		return;
+
+	iolat = blkg_to_lat(blkg);
 	if (!iolat)
 		return;
 
 	if (!iolat->blkiolat->enabled)
 		return;
diff --git a/block/blk-ioprio.c b/block/blk-ioprio.c
index 8fa8bca35062..5e3f8e49550d 100644
--- a/block/blk-ioprio.c
+++ b/block/blk-ioprio.c
@@ -130,11 +130,11 @@ static struct blkcg_policy ioprio_policy = {
 	.cpd_free_fn	= ioprio_free_cpd,
 };
 
 void blkcg_set_ioprio(struct bio *bio)
 {
-	struct ioprio_blkcg *blkcg = blkcg_to_ioprio_blkcg(bio->bi_blkg->blkcg);
+	struct ioprio_blkcg *blkcg = blkcg_to_ioprio_blkcg(bio_blkcg(bio));
 	u16 prio;
 
 	if (!blkcg || blkcg->prio_policy == POLICY_NO_CHANGE)
 		return;
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index ffc3b70065d4..3828c3857900 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1790,11 +1790,11 @@ static bool tg_within_limit(struct throtl_grp *tg, struct bio *bio, bool rw)
 }
 
 bool __blk_throtl_bio(struct bio *bio)
 {
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	struct blkcg_gq *blkg = bio->bi_blkg;
+	struct blkcg_gq *blkg = bio_blkg(bio);
 	struct throtl_qnode *qn = NULL;
 	struct throtl_grp *tg = blkg_to_tg(blkg);
 	struct throtl_service_queue *sq;
 	bool rw = bio_data_dir(bio);
 	bool throttled = false;
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index 1b5775771e07..45f30179fd9c 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -169,11 +169,11 @@ static inline bool blk_should_throtl(struct bio *bio)
 	int rw = bio_data_dir(bio);
 
 	if (!blk_throtl_activated(bio->bi_bdev->bd_queue))
 		return false;
 
-	tg = blkg_to_tg(bio->bi_blkg);
+	tg = blkg_to_tg(bio_blkg(bio));
 	if (!cgroup_subsys_on_dfl(io_cgrp_subsys)) {
 		if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
 			bio_set_flag(bio, BIO_CGROUP_ACCT);
 			blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
 					bio->bi_iter.bi_size);
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 3fa3b13a410f..c0f945b8d941 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -846,11 +846,11 @@ static CLOSURE_CALLBACK(cached_dev_read_done)
 	if (s->iop.bio) {
 		bio_reset(s->iop.bio, s->cache_miss->bi_bdev, REQ_OP_READ);
 		s->iop.bio->bi_iter.bi_sector =
 			s->cache_miss->bi_iter.bi_sector;
 		s->iop.bio->bi_iter.bi_size = s->insert_bio_sectors << 9;
-		bio_clone_blkg_association(s->iop.bio, s->cache_miss);
+		bio_clone_blkcg_association(s->iop.bio, s->cache_miss);
 		bch_bio_map(s->iop.bio, NULL);
 
 		bio_copy_data(s->cache_miss, s->iop.bio);
 
 		bio_put(s->cache_miss);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d413bfaf3527..cd68eec77f5a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1371,11 +1371,11 @@ void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone)
 
 	/* establish bio that will get submitted */
 	if (!tgt_clone)
 		tgt_clone = clone;
 
-	bio_clone_blkg_association(tgt_clone, io->orig_bio);
+	bio_clone_blkcg_association(tgt_clone, io->orig_bio);
 
 	/*
 	 * Account io->origin_bio to DM dev on behalf of target
 	 * that took ownership of IO with DM_MAPIO_SUBMITTED.
 	 */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..fd78d6cc8da1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9384,11 +9384,11 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 	__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO, &discard_bio);
 	if (!discard_bio)
 		return;
 
 	bio_chain(discard_bio, bio);
-	bio_clone_blkg_association(discard_bio, bio);
+	bio_clone_blkcg_association(discard_bio, bio);
 	mddev_trace_remap(mddev, discard_bio, bio->bi_iter.bi_sector);
 	submit_bio_noacct(discard_bio);
 }
 EXPORT_SYMBOL_GPL(md_submit_discard_bio);
 
diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 4176046627be..54e4adb0ccb7 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -119,11 +119,11 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
 					      REQ_OP_WRITE | REQ_PREFLUSH,
 					      GFP_ATOMIC);
 
 		if (!child)
 			return -ENOMEM;
-		bio_clone_blkg_association(child, bio);
+		bio_clone_blkcg_association(child, bio);
 		child->bi_iter.bi_sector = -1;
 		bio_chain(child, bio);
 		submit_bio(child);
 		return 0;
 	}
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 6dabe73ad790..6512dbd9516f 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -482,11 +482,11 @@ static struct bio *gfs2_chain_bio(struct bio *prev, unsigned int nr_iovecs,
 				  sector_t sector, blk_opf_t opf)
 {
 	struct bio *new;
 
 	new = bio_alloc(prev->bi_bdev, nr_iovecs, opf, GFP_NOIO);
-	bio_clone_blkg_association(new, prev);
+	bio_clone_blkcg_association(new, prev);
 	new->bi_iter.bi_sector = sector;
 	bio_chain(new, prev);
 	submit_bio(prev);
 	return new;
 }
@@ -1112,6 +1112,5 @@ const struct gfs2_log_operations *gfs2_log_ops[] = {
 	&gfs2_databuf_lops,
 	&gfs2_buf_lops,
 	&gfs2_revoke_lops,
 	NULL,
 };
-
diff --git a/include/linux/bio.h b/include/linux/bio.h
index bb3235497e67..11637f85c38d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -540,35 +540,39 @@ static inline void bio_release_pages(struct bio *bio, bool mark_dirty)
 
 #define bio_dev(bio) \
 	disk_devt((bio)->bi_bdev->bd_disk)
 
 #ifdef CONFIG_BLK_CGROUP
-void bio_associate_blkg(struct bio *bio);
-void bio_associate_blkg_from_css(struct bio *bio,
-				 struct cgroup_subsys_state *css);
-void bio_clone_blkg_association(struct bio *dst, struct bio *src);
+void bio_associate_blkcg(struct bio *bio);
+void bio_associate_blkcg_from_css(struct bio *bio,
+				  struct cgroup_subsys_state *css);
+void bio_clone_blkcg_association(struct bio *dst, struct bio *src);
+void bio_put_blkg_ref(struct bio *bio);
 void blkcg_punt_bio_submit(struct bio *bio);
 #else	/* CONFIG_BLK_CGROUP */
-static inline void bio_associate_blkg(struct bio *bio) { }
-static inline void bio_associate_blkg_from_css(struct bio *bio,
-					       struct cgroup_subsys_state *css)
+static inline void bio_associate_blkcg(struct bio *bio) { }
+static inline void bio_associate_blkcg_from_css(struct bio *bio,
+						struct cgroup_subsys_state *css)
 { }
-static inline void bio_clone_blkg_association(struct bio *dst,
-					      struct bio *src) { }
+static inline void bio_clone_blkcg_association(struct bio *dst,
+					       struct bio *src) { }
+static inline void bio_put_blkg_ref(struct bio *bio) { }
 static inline void blkcg_punt_bio_submit(struct bio *bio)
 {
 	submit_bio(bio);
 }
 #endif	/* CONFIG_BLK_CGROUP */
 
 static inline void bio_set_dev(struct bio *bio, struct block_device *bdev)
 {
 	bio_clear_flag(bio, BIO_REMAPPED);
-	if (bio->bi_bdev != bdev)
+	if (bio->bi_bdev != bdev) {
+		bio_put_blkg_ref(bio);
 		bio_clear_flag(bio, BIO_BPS_THROTTLED);
+	}
 	bio->bi_bdev = bdev;
-	bio_associate_blkg(bio);
+	bio_associate_blkcg(bio);
 }
 
 /*
  * BIO list management for use by remapping drivers (e.g. DM or MD) and loop.
  *
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d49d97a050d0..53ba307b91cb 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -244,16 +244,14 @@ struct bio {
 	};
 	bio_end_io_t		*bi_end_io;
 	void			*bi_private;
 #ifdef CONFIG_BLK_CGROUP
 	/*
-	 * Represents the association of the css and request_queue for the bio.
-	 * If a bio goes direct to device, it will not have a blkg as it will
-	 * not have a request_queue associated with it.  The reference is put
-	 * on release of the bio.
+	 * Represents the blkcg css association for the bio.  The reference is
+	 * put on release of the bio.
 	 */
-	struct blkcg_gq		*bi_blkg;
+	struct blkcg		*bi_blkcg;
 	/* Time that this bio was issued. */
 	u64			issue_time_ns;
 #ifdef CONFIG_BLK_CGROUP_IOCOST
 	u64			bi_iocost_cost;
 #endif
@@ -307,10 +305,11 @@ enum {
 	BIO_BPS_THROTTLED,	/* This bio has already been subjected to
 				 * throttling rules. Don't do it again. */
 	BIO_TRACE_COMPLETION,	/* bio_endio() should trace the final completion
 				 * of this bio. */
 	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
+	BIO_BLKG_REF,		/* bio pins the associated blkg */
 	BIO_QOS_THROTTLED,	/* bio went through rq_qos throttle path */
 	/*
 	 * This bio has completed bps throttling at the single tg granularity,
 	 * which is different from BIO_BPS_THROTTLED. When the bio is enqueued
 	 * into the sq->queued of the upper tg, or is about to be dispatched,
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 62552a2ce5b9..4f869fe9cc90 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -260,11 +260,11 @@ static inline void wbc_init_bio(struct writeback_control *wbc, struct bio *bio)
 	 * out.  This is intentional as we don't want the function to block
 	 * behind a slow cgroup.  Ultimately, we want pageout() to kick off
 	 * regular writeback instead of writing things out itself.
 	 */
 	if (wbc->wb)
-		bio_associate_blkg_from_css(bio, wbc->wb->blkcg_css);
+		bio_associate_blkcg_from_css(bio, wbc->wb->blkcg_css);
 }
 
 void inode_switch_wbs_work_fn(struct work_struct *work);
 
 #else	/* CONFIG_CGROUP_WRITEBACK */
diff --git a/mm/page_io.c b/mm/page_io.c
index b23f494fcc83..a4a1b8a8a0e3 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -314,11 +314,11 @@ static inline void count_swpout_vm_event(struct folio *folio)
 	count_memcg_folio_events(folio, PSWPOUT, folio_nr_pages(folio));
 	count_vm_events(PSWPOUT, folio_nr_pages(folio));
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
+static void bio_associate_blkcg_from_page(struct bio *bio, struct folio *folio)
 {
 	struct cgroup_subsys_state *css;
 	struct mem_cgroup *memcg;
 
 	if (!folio_memcg_charged(folio))
@@ -329,16 +329,19 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 	css = cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
 	if (!css || !css_tryget(css))
 		css = NULL;
 	rcu_read_unlock();
 
-	bio_associate_blkg_from_css(bio, css);
+	bio_associate_blkcg_from_css(bio, css);
 	if (css)
 		css_put(css);
 }
 #else
-#define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
+static inline void bio_associate_blkcg_from_page(struct bio *bio,
+						 struct folio *folio)
+{
+}
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
 
 struct swap_iocb {
 	struct kiocb		iocb;
 	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
@@ -434,11 +437,11 @@ static void swap_writepage_bdev_sync(struct folio *folio,
 
 	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_WRITE | REQ_SWAP);
 	bio.bi_iter.bi_sector = swap_folio_sector(folio);
 	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
 
-	bio_associate_blkg_from_page(&bio, folio);
+	bio_associate_blkcg_from_page(&bio, folio);
 	count_swpout_vm_event(folio);
 
 	folio_start_writeback(folio);
 	folio_unlock(folio);
 
@@ -454,11 +457,11 @@ static void swap_writepage_bdev_async(struct folio *folio,
 	bio = bio_alloc(sis->bdev, 1, REQ_OP_WRITE | REQ_SWAP, GFP_NOIO);
 	bio->bi_iter.bi_sector = swap_folio_sector(folio);
 	bio->bi_end_io = end_swap_bio_write;
 	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
 
-	bio_associate_blkg_from_page(bio, folio);
+	bio_associate_blkcg_from_page(bio, folio);
 	count_swpout_vm_event(folio);
 	folio_start_writeback(folio);
 	folio_unlock(folio);
 	submit_bio(bio);
 }
-- 
2.51.0

