Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF3E3128D9;
	Tue,  4 Aug 2026 06:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785826432; cv=none; b=WkEtYX/EVnZNiyfFaq6gbaOzyoARjzCOCscxjOpHmtTGpqXVbIBmdtZgMR2c5fOkxngU+Wn/pm/27dIjBuoZWni4e5JD7BIoP2ogC6pkflRRGzVtTkfLzrnJJgpEeZBkBWhRBwxhhtXbdcLbCP13zy4eFwiAirSUf9BazTgNj0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785826432; c=relaxed/simple;
	bh=6ktP5g+m6fZwS2nBQas1Y3Vp8ODAtg9LuSW0Od/w7NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADRLZPYQuENGhJtdhYiuYWYon14htnH+IX6m/rBwGcbdlT2/NqdD0f9qUEyt5d9vUQI74DR9BpbmHUg+uRARQ7wxTGOyXeLLTBa8kgmWhsmODAr83qKEQulm1Xg+jVk3CR7m9JXFXr1tpGIDk13wJ2qZmkvAu/9wXIy2ohkgPik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YSr1DG8h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSr1DG8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D8F1F00A3A;
	Tue,  4 Aug 2026 06:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785826430;
	bh=3ikR+jaOP+v8a0i8d+lZkMdQtKeVSnS18koPO57INZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSr1DG8hVF4pQdkDHS7LCxgbsxsVCvFRBUsjgo3Db8n7uFJyplwAkALeMcFvmWzk1
	 +13wyQA/LAUsZMuRo4eH7Z0tNi7CdmNj9zjAT14JbbglkURPFnRI45aaIyVNf1SBW5
	 nXr6m5KniRl07ybPsZL6efAEsuvu3EmqgLu9yYcbY3/tSJ69UzKc67Sdek49skf0V4
	 smyBic7YC8M16wy3X9KqauwmPmBNQNwm3tBv8VBeujwQI1xEuhJFu/8jxeDwaHw/yD
	 AuRkDT4IAZb+PGr3fjM72Y0TrcXbxdlKWhAyLcbZb50Zkc0+ukfw3GZWRc86Kk4s2w
	 wGlt/BoilTG+g==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Yu Kuai <yukuai@fygo.io>,
	Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cui.tao@linux.dev>,
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
Subject: [RFC PATCH v1 1/3] blk-cgroup: add helpers for bio cgroup state
Date: Tue,  4 Aug 2026 14:53:11 +0800
Message-ID: <20260804065313.2092022-2-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260804065313.2092022-1-yukuai@kernel.org>
References: <20260804065313.2092022-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

blk-cgroup users open-code bio->bi_blkg throughout the policy and
accounting paths.  Some users need the blkg itself, while others
immediately dereference it to get the associated blkcg.  The bio release
paths also open-code the CONFIG_BLK_CGROUP guarded blkg reference drop
and field clear.

Add bio_blkg(), bio_blkcg() and bio_clear_blkg() helpers.  Convert the
read-side users to use the accessors, and use bio_clear_blkg() from
bio_uninit() and bio_endio() so the release path no longer needs to know
about CONFIG_BLK_CGROUP.  Keep the direct bio->bi_blkg stores in the
association and initialization paths, as those paths still assign the
stored association.

This keeps the current behavior unchanged while preparing for changing
what cgroup state a bio stores internally.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/bfq-cgroup.c          |  4 ++--
 block/bio.c                 | 14 ++------------
 block/blk-cgroup-fc-appid.c | 11 +++++++++--
 block/blk-cgroup.c          | 19 ++++++++++---------
 block/blk-cgroup.h          | 19 ++++++++++++++++++-
 block/blk-iocost.c          |  6 +++---
 block/blk-iolatency.c       |  6 +++---
 block/blk-ioprio.c          |  2 +-
 block/blk-throttle.c        |  2 +-
 block/blk-throttle.h        |  2 +-
 include/linux/bio.h         | 10 ++++++++++
 11 files changed, 60 insertions(+), 35 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index e82ff03bda02..7e65fe6844ee 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -363,7 +363,7 @@ void bfqg_and_blkg_put(struct bfq_group *bfqg)
 
 void bfqg_stats_update_legacy_io(struct request_queue *q, struct request *rq)
 {
-	struct bfq_group *bfqg = blkg_to_bfqg(rq->bio->bi_blkg);
+	struct bfq_group *bfqg = blkg_to_bfqg(bio_blkg(rq->bio));
 
 	if (!bfqg)
 		return;
@@ -606,7 +606,7 @@ static void bfq_link_bfqg(struct bfq_data *bfqd, struct bfq_group *bfqg)
 
 struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
 {
-	struct blkcg_gq *blkg = bio->bi_blkg;
+	struct blkcg_gq *blkg = bio_blkg(bio);
 	struct bfq_group *bfqg;
 
 	while (blkg) {
diff --git a/block/bio.c b/block/bio.c
index 6a2f6fc3413e..c207b248edba 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -179,12 +179,7 @@ static inline gfp_t try_alloc_gfp(gfp_t gfp)
 
 void bio_uninit(struct bio *bio)
 {
-#ifdef CONFIG_BLK_CGROUP
-	if (bio->bi_blkg) {
-		blkg_put(bio->bi_blkg);
-		bio->bi_blkg = NULL;
-	}
-#endif
+	bio_clear_blkg(bio);
 	if (bio_integrity(bio))
 		bio_integrity_free(bio);
 
@@ -1803,17 +1798,12 @@ void bio_endio(struct bio *bio)
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
+	bio_clear_blkg(bio);
 
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio);
diff --git a/block/blk-cgroup-fc-appid.c b/block/blk-cgroup-fc-appid.c
index 3ec21333f393..b2e16e9a7a6c 100644
--- a/block/blk-cgroup-fc-appid.c
+++ b/block/blk-cgroup-fc-appid.c
@@ -50,8 +50,15 @@ EXPORT_SYMBOL_GPL(blkcg_set_fc_appid);
  */
 char *blkcg_get_fc_appid(struct bio *bio)
 {
-	if (!bio->bi_blkg || bio->bi_blkg->blkcg->fc_app_id[0] == '\0')
+	struct blkcg *blkcg;
+
+	if (!bio_blkg(bio))
 		return NULL;
-	return bio->bi_blkg->blkcg->fc_app_id;
+
+	blkcg = bio_blkcg(bio);
+	if (blkcg->fc_app_id[0] == '\0')
+		return NULL;
+
+	return blkcg->fc_app_id;
 }
 EXPORT_SYMBOL_GPL(blkcg_get_fc_appid);
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 354637f3b158..753a3bdd0e8c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -239,7 +239,7 @@ static void blkg_async_bio_workfn(struct work_struct *work)
  */
 void blkcg_punt_bio_submit(struct bio *bio)
 {
-	struct blkcg_gq *blkg = bio->bi_blkg;
+	struct blkcg_gq *blkg = bio_blkg(bio);
 
 	if (blkg->parent) {
 		spin_lock(&blkg->async_bio_lock);
@@ -275,9 +275,9 @@ subsys_initcall(blkcg_punt_bio_init);
  */
 struct cgroup_subsys_state *bio_blkcg_css(struct bio *bio)
 {
-	if (!bio || !bio->bi_blkg)
+	if (!bio || !bio_blkg(bio))
 		return NULL;
-	return &bio->bi_blkg->blkcg->css;
+	return &bio_blkcg(bio)->css;
 }
 EXPORT_SYMBOL_GPL(bio_blkcg_css);
 
@@ -2118,8 +2118,8 @@ static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
 void bio_associate_blkg_from_css(struct bio *bio,
 				 struct cgroup_subsys_state *css)
 {
-	if (bio->bi_blkg)
-		blkg_put(bio->bi_blkg);
+	if (bio_blkg(bio))
+		blkg_put(bio_blkg(bio));
 
 	if (css && css->parent) {
 		bio->bi_blkg = blkg_tryget_closest(bio, css);
@@ -2146,7 +2146,7 @@ void bio_associate_blkg(struct bio *bio)
 	if (blk_op_is_passthrough(bio->bi_opf))
 		return;
 
-	if (bio->bi_blkg) {
+	if (bio_blkg(bio)) {
 		css = bio_blkcg_css(bio);
 		bio_associate_blkg_from_css(bio, css);
 	} else {
@@ -2170,7 +2170,7 @@ EXPORT_SYMBOL_GPL(bio_associate_blkg);
  */
 void bio_clone_blkg_association(struct bio *dst, struct bio *src)
 {
-	if (src->bi_blkg)
+	if (bio_blkg(src))
 		bio_associate_blkg_from_css(dst, bio_blkcg_css(src));
 }
 EXPORT_SYMBOL_GPL(bio_clone_blkg_association);
@@ -2186,7 +2186,8 @@ static int blk_cgroup_io_type(struct bio *bio)
 
 void blk_cgroup_bio_start(struct bio *bio)
 {
-	struct blkcg *blkcg = bio->bi_blkg->blkcg;
+	struct blkcg_gq *blkg = bio_blkg(bio);
+	struct blkcg *blkcg = bio_blkcg(bio);
 	int rwd = blk_cgroup_io_type(bio), cpu;
 	struct blkg_iostat_set *bis;
 	unsigned long flags;
@@ -2199,7 +2200,7 @@ void blk_cgroup_bio_start(struct bio *bio)
 		return;
 
 	cpu = get_cpu();
-	bis = per_cpu_ptr(bio->bi_blkg->iostat_cpu, cpu);
+	bis = per_cpu_ptr(blkg->iostat_cpu, cpu);
 	flags = u64_stats_update_begin_irqsave(&bis->sync);
 
 	/*
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 615390f751aa..1e80b0a73233 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -124,6 +124,11 @@ static inline struct blkcg *css_to_blkcg(struct cgroup_subsys_state *css)
 	return css ? container_of(css, struct blkcg, css) : NULL;
 }
 
+static inline struct blkcg *bio_blkcg(struct bio *bio)
+{
+	return bio_blkg(bio)->blkcg;
+}
+
 /*
  * A blkcg_gq (blkg) is association between a block cgroup (blkcg) and a
  * request_queue (q).  This is used by blkcg policies which need to track
@@ -343,6 +348,16 @@ static inline void blkg_put(struct blkcg_gq *blkg)
 	percpu_ref_put(&blkg->refcnt);
 }
 
+static inline void bio_clear_blkg(struct bio *bio)
+{
+	struct blkcg_gq *blkg = bio_blkg(bio);
+
+	if (blkg) {
+		blkg_put(blkg);
+		bio->bi_blkg = NULL;
+	}
+}
+
 /**
  * blkg_for_each_descendant_pre - pre-order walk of a blkg's descendants
  * @d_blkg: loop cursor pointing to the current descendant
@@ -455,7 +470,7 @@ static inline void blkcg_clear_delay(struct blkcg_gq *blkg)
  */
 static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio)
 {
-	return rq->bio->bi_blkg == bio->bi_blkg &&
+	return bio_blkg(rq->bio) == bio_blkg(bio) &&
 		bio_issue_as_root_blkg(rq->bio) == bio_issue_as_root_blkg(bio);
 }
 
@@ -481,6 +496,7 @@ struct blkcg_policy {
 struct blkcg {
 };
 
+static inline struct blkcg *bio_blkcg(struct bio *bio) { return NULL; }
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { return NULL; }
 static inline void blkg_init_queue(struct request_queue *q) { }
 static inline int blkcg_init_disk(struct gendisk *disk) { return 0; }
@@ -497,6 +513,7 @@ static inline struct blkg_policy_data *blkg_to_pd(struct blkcg_gq *blkg,
 static inline struct blkcg_gq *pd_to_blkg(struct blkg_policy_data *pd) { return NULL; }
 static inline void blkg_get(struct blkcg_gq *blkg) { }
 static inline void blkg_put(struct blkcg_gq *blkg) { }
+static inline void bio_clear_blkg(struct bio *bio) { }
 static inline void blk_cgroup_bio_start(struct bio *bio) { }
 static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio) { return true; }
 
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 8b2aeba2e1e3..d4470476bcd0 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2686,7 +2686,7 @@ iocg_handle_over_budget(struct rq_qos *rqos, struct ioc_gq *iocg,
 
 static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 {
-	struct blkcg_gq *blkg = bio->bi_blkg;
+	struct blkcg_gq *blkg = bio_blkg(bio);
 	struct ioc *ioc = rqos_to_ioc(rqos);
 	struct ioc_gq *iocg = blkg_to_iocg(blkg);
 	struct ioc_now now;
@@ -2775,7 +2775,7 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 static void ioc_rqos_merge(struct rq_qos *rqos, struct request *rq,
 			   struct bio *bio)
 {
-	struct ioc_gq *iocg = blkg_to_iocg(bio->bi_blkg);
+	struct ioc_gq *iocg = blkg_to_iocg(bio_blkg(bio));
 	struct ioc *ioc = rqos_to_ioc(rqos);
 	sector_t bio_end = bio_end_sector(bio);
 	struct ioc_now now;
@@ -2833,7 +2833,7 @@ static void ioc_rqos_merge(struct rq_qos *rqos, struct request *rq,
 
 static void ioc_rqos_done_bio(struct rq_qos *rqos, struct bio *bio)
 {
-	struct ioc_gq *iocg = blkg_to_iocg(bio->bi_blkg);
+	struct ioc_gq *iocg = blkg_to_iocg(bio_blkg(bio));
 
 	if (iocg && bio->bi_iocost_cost)
 		atomic64_add(bio->bi_iocost_cost, &iocg->done_vtime);
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index cef02b6c5fa9..c0d8d5f6bdba 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -463,7 +463,7 @@ static void check_scale_change(struct iolatency_grp *iolat)
 static void blkcg_iolatency_throttle(struct rq_qos *rqos, struct bio *bio)
 {
 	struct blk_iolatency *blkiolat = BLKIOLATENCY(rqos);
-	struct blkcg_gq *blkg = bio->bi_blkg;
+	struct blkcg_gq *blkg = bio_blkg(bio);
 	bool issue_as_root = bio_issue_as_root_blkg(bio);
 
 	if (!blkiolat->enabled)
@@ -590,11 +590,11 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 	bool issue_as_root = bio_issue_as_root_blkg(bio);
 	int inflight = 0;
 
-	blkg = bio->bi_blkg;
+	blkg = bio_blkg(bio);
 	if (!blkg || !bio_flagged(bio, BIO_QOS_THROTTLED))
 		return;
 
-	iolat = blkg_to_lat(bio->bi_blkg);
+	iolat = blkg_to_lat(blkg);
 	if (!iolat)
 		return;
 
diff --git a/block/blk-ioprio.c b/block/blk-ioprio.c
index 8fa8bca35062..5e3f8e49550d 100644
--- a/block/blk-ioprio.c
+++ b/block/blk-ioprio.c
@@ -132,7 +132,7 @@ static struct blkcg_policy ioprio_policy = {
 
 void blkcg_set_ioprio(struct bio *bio)
 {
-	struct ioprio_blkcg *blkcg = blkcg_to_ioprio_blkcg(bio->bi_blkg->blkcg);
+	struct ioprio_blkcg *blkcg = blkcg_to_ioprio_blkcg(bio_blkcg(bio));
 	u16 prio;
 
 	if (!blkcg || blkcg->prio_policy == POLICY_NO_CHANGE)
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index ffc3b70065d4..3828c3857900 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1792,7 +1792,7 @@ static bool tg_within_limit(struct throtl_grp *tg, struct bio *bio, bool rw)
 bool __blk_throtl_bio(struct bio *bio)
 {
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	struct blkcg_gq *blkg = bio->bi_blkg;
+	struct blkcg_gq *blkg = bio_blkg(bio);
 	struct throtl_qnode *qn = NULL;
 	struct throtl_grp *tg = blkg_to_tg(blkg);
 	struct throtl_service_queue *sq;
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index 9d7a42c039a1..609a126c7ccb 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -173,7 +173,7 @@ static inline bool blk_should_throtl(struct bio *bio)
 	if (!blk_throtl_activated(bio->bi_bdev->bd_queue))
 		return false;
 
-	tg = blkg_to_tg(bio->bi_blkg);
+	tg = blkg_to_tg(bio_blkg(bio));
 	if (!cgroup_subsys_on_dfl(io_cgrp_subsys)) {
 		if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
 			bio_set_flag(bio, BIO_CGROUP_ACCT);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8f33f717b14f..dc4baa3602b7 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -503,12 +503,22 @@ static inline void bio_release_pages(struct bio *bio, bool mark_dirty)
 	disk_devt((bio)->bi_bdev->bd_disk)
 
 #ifdef CONFIG_BLK_CGROUP
+static inline struct blkcg_gq *bio_blkg(struct bio *bio)
+{
+	return bio->bi_blkg;
+}
+
 void bio_associate_blkg(struct bio *bio);
 void bio_associate_blkg_from_css(struct bio *bio,
 				 struct cgroup_subsys_state *css);
 void bio_clone_blkg_association(struct bio *dst, struct bio *src);
 void blkcg_punt_bio_submit(struct bio *bio);
 #else	/* CONFIG_BLK_CGROUP */
+static inline struct blkcg_gq *bio_blkg(struct bio *bio)
+{
+	return NULL;
+}
+
 static inline void bio_associate_blkg(struct bio *bio) { }
 static inline void bio_associate_blkg_from_css(struct bio *bio,
 					       struct cgroup_subsys_state *css)
-- 
2.51.0

