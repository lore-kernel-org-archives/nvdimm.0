Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B8A3F8714;
	Tue,  4 Aug 2026 06:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785826464; cv=none; b=TiLAAiaL2FlU5rWlY8Di2BydzfTljNme6A3Gf4jLlAEc1T1rrG7n4q0lizhohezWoT6kP1cL9yMVbOO35bBI9P/gFFqJehEtPv8Ks0bTnlZQa9ZWbydOLaEGChridGP/Wb9GGxaZlSO52f5QQ4KYE2QFArRoldGkCeRsZo/JfIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785826464; c=relaxed/simple;
	bh=LGmf2KEi1vOYJnUZpZkGgA11jUahqBwgWVCT9Sl6bzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyT35DAmIoo90yH+0IvlSEjlbFsGWWaIQyDweHO9KlJ8O5mfjbvJ7MJo4iIEMGdpl5Ib7Wvki9jOtzsv81InoJVwTqZE9tevkf5+eiwvEtNxNdd82JyCuC5/O4ptr7bMuA6B4XwUQxY8TFmwEDL8s6/FK2Xvl3eIlPpXlv1ArBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EhpRjq1T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EhpRjq1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1950E1F00A3A;
	Tue,  4 Aug 2026 06:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785826462;
	bh=0W+d2BSTkxNT+SthfX82FpSr/h0ZeS2Jo82xnGDi01I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EhpRjq1T7kHiQezjtfNCoscixE9MILZKN5AQAeuLfpl0CdFGwVYQTGV+wNKnrHM1r
	 JrCkeWZ6d06vYOvkvnShsD053dLwqlqovCi8VdrTs6xOXSWs5xZyvvJv0+eeTuvsrr
	 UjxsnEfXKMZbAY4xrGUC1ZY81kkxGCs6MR03zQf4P0zM/zg8Ufripxogr4rVuRBK6o
	 J4vbWfQENrvlcBCqfeojeulJL4POIHcg1HvJbPr8DzbRolG6hlwUW458Nvj71gn44d
	 NxB5XhSONuT9fI07DPIJdGnu5q8FNDVjyU1hLJPrJ5um9XXuJiqETrmLraKLEI7cFj
	 xqC7LknjuY70A==
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
Subject: [RFC PATCH v1 3/3] blk-cgroup: move async bio punt state to blkcg
Date: Tue,  4 Aug 2026 14:53:13 +0800
Message-ID: <20260804065313.2092022-4-yukuai@kernel.org>
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

blkcg_punt_bio_submit() currently queues punted bios on blkg->async_bios,
so it has to call bio_blkg() to find or create a queue-local blkg.  Bios
now carry and pin the blkcg css, so punted bio lifetime no longer needs to
be anchored by a blkg.

Keeping the punt state in blkg can instantiate a blkg even when no blkcg
policy is enabled, just to bounce submission from a shared kthread.  Move
async_bio_lock, async_bios and async_bio_work to struct blkcg, and queue
punted bios on bio_blkcg() for non-root cgroups.  Root or unassociated bios
are submitted directly.

This preserves the priority-inversion avoidance while preventing
blkcg_punt_bio_submit() from creating blkgs that are not needed by any
policy.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 44 +++++++++++++++++++++-----------------------
 block/blk-cgroup.h | 14 ++++++--------
 2 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 93ab57e0a9f1..236220db8578 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -170,10 +170,6 @@ static void __blkg_release(struct rcu_head *rcu)
 {
 	struct blkcg_gq *blkg = container_of(rcu, struct blkcg_gq, rcu_head);
 
-#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
-	WARN_ON(!bio_list_empty(&blkg->async_bios));
-#endif
-
 	blkg_free(blkg);
 }
 
@@ -206,19 +202,18 @@ static void blkg_release(struct percpu_ref *ref)
 #ifdef CONFIG_BLK_CGROUP_PUNT_BIO
 static struct workqueue_struct *blkcg_punt_bio_wq;
 
-static void blkg_async_bio_workfn(struct work_struct *work)
+static void blkcg_async_bio_workfn(struct work_struct *work)
 {
-	struct blkcg_gq *blkg = container_of(work, struct blkcg_gq,
-					     async_bio_work);
+	struct blkcg *blkcg = container_of(work, struct blkcg, async_bio_work);
 	struct bio_list bios = BIO_EMPTY_LIST;
 	struct bio *bio;
 	struct blk_plug plug;
 	bool need_plug = false;
 
-	/* as long as there are pending bios, @blkg can't go away */
-	spin_lock(&blkg->async_bio_lock);
-	bio_list_merge_init(&bios, &blkg->async_bios);
-	spin_unlock(&blkg->async_bio_lock);
+	/* as long as there are pending bios, @blkcg can't go away */
+	spin_lock(&blkcg->async_bio_lock);
+	bio_list_merge_init(&bios, &blkcg->async_bios);
+	spin_unlock(&blkcg->async_bio_lock);
 
 	/* start plug only when bio_list contains at least 2 bios */
 	if (bios.head && bios.head->bi_next) {
@@ -239,15 +234,15 @@ static void blkg_async_bio_workfn(struct work_struct *work)
  */
 void blkcg_punt_bio_submit(struct bio *bio)
 {
-	struct blkcg_gq *blkg = bio_blkg(bio);
+	struct blkcg *blkcg = bio_blkcg(bio);
 
-	if (blkg && blkg->parent) {
-		spin_lock(&blkg->async_bio_lock);
-		bio_list_add(&blkg->async_bios, bio);
-		spin_unlock(&blkg->async_bio_lock);
-		queue_work(blkcg_punt_bio_wq, &blkg->async_bio_work);
+	if (blkcg && cgroup_parent(blkcg->css.cgroup)) {
+		spin_lock(&blkcg->async_bio_lock);
+		bio_list_add(&blkcg->async_bios, bio);
+		spin_unlock(&blkcg->async_bio_lock);
+		queue_work(blkcg_punt_bio_wq, &blkcg->async_bio_work);
 	} else {
-		/* Never bounce if there is no non-root blkg to queue on. */
+		/* Never bounce if there is no non-root blkcg to queue on. */
 		submit_bio(bio);
 	}
 }
@@ -325,11 +320,6 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 	INIT_LIST_HEAD(&blkg->q_node);
 	blkg->blkcg = blkcg;
 	blkg->iostat.blkg = blkg;
-#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
-	spin_lock_init(&blkg->async_bio_lock);
-	bio_list_init(&blkg->async_bios);
-	INIT_WORK(&blkg->async_bio_work, blkg_async_bio_workfn);
-#endif
 
 	u64_stats_init(&blkg->iostat.sync);
 	for_each_possible_cpu(cpu) {
@@ -1360,6 +1350,9 @@ static void blkcg_css_free(struct cgroup_subsys_state *css)
 
 	mutex_unlock(&blkcg_pol_mutex);
 
+#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
+	WARN_ON(!bio_list_empty(&blkcg->async_bios));
+#endif
 	free_percpu(blkcg->lhead);
 	kfree(blkcg);
 }
@@ -1409,6 +1402,11 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 	refcount_set(&blkcg->online_pin, 1);
 	INIT_RADIX_TREE(&blkcg->blkg_tree, GFP_NOWAIT);
 	INIT_HLIST_HEAD(&blkcg->blkg_list);
+#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
+	spin_lock_init(&blkcg->async_bio_lock);
+	bio_list_init(&blkcg->async_bios);
+	INIT_WORK(&blkcg->async_bio_work, blkcg_async_bio_workfn);
+#endif
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&blkcg->cgwb_list);
 #endif
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index b6fb85db4d3d..b457c2b4ac7c 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -73,14 +73,7 @@ struct blkcg_gq {
 	struct blkg_iostat_set		iostat;
 
 	struct blkg_policy_data		*pd[BLKCG_MAX_POLS];
-#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
-	spinlock_t			async_bio_lock;
-	struct bio_list			async_bios;
-#endif
-	union {
-		struct work_struct	async_bio_work;
-		struct work_struct	free_work;
-	};
+	struct work_struct		free_work;
 
 	atomic_t			use_delay;
 	atomic64_t			delay_nsec;
@@ -111,6 +104,11 @@ struct blkcg {
 	 */
 	struct llist_head __percpu	*lhead;
 
+#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
+	spinlock_t			async_bio_lock;
+	struct bio_list			async_bios;
+	struct work_struct		async_bio_work;
+#endif
 #ifdef CONFIG_BLK_CGROUP_FC_APPID
 	char                            fc_app_id[FC_APPID_LEN];
 #endif
-- 
2.51.0

