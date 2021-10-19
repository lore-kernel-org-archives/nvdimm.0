Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D329F72
	for <nvdimm@lists.linux.dev>; Tue, 19 Oct 2021 07:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CYNxRQ01pKOwVYHa06L+8e98u7Vn+1wScPdYwItVY+s=; b=19fOJrqxoRvezDB5PLNjHendDt
	UMLV7KEq8MwKXqQGhk9dtI+aDHgNd24RrxO9B6eXd84yuaRPBXm/JPcGxqtfgD8+MnFSACtKiP0NA
	WAxjX6e8ruk/h0XtBmwwwJvDK7uqoLoblrP/mNC3mCPeenmwEepQsRrUjKF79NfIYCLttqx434QN4
	DyRddrLV1Bq6FougUkDPddZtVxzCvJ6Bxns31bnb8cn+YPStkkJ4XZu/lKu56HUHtJIZG0cPjRl7p
	VDH11mcl4QvbIV/PziL/g5GF4R2GVD48/Xt3hgig/X80GKehiS4xYHywHWhHPojviTKwkRiVzpuQc
	mSLdFnWQ==;
Received: from 089144192247.atnat0001.highway.a1.net ([89.144.192.247] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mcjg5-000QWr-CW; Tue, 19 Oct 2021 07:36:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jens Axboe <axboe@kernel.dk>,
	Yi Zhang <yi.zhang@redhat.com>,
	linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 2/2] memremap: remove support for external pgmap refcounts
Date: Tue, 19 Oct 2021 09:36:41 +0200
Message-Id: <20211019073641.2323410-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211019073641.2323410-1-hch@lst.de>
References: <20211019073641.2323410-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

No driver is left using the external pgmap refcount, so remove the
code to support it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/memremap.h          | 18 ++--------
 mm/memremap.c                     | 59 +++++++------------------------
 tools/testing/nvdimm/test/iomap.c | 43 +++++++---------------
 3 files changed, 27 insertions(+), 93 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index c0e9d35889e8d..a8bc588fe7aa8 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -72,16 +72,6 @@ struct dev_pagemap_ops {
 	 */
 	void (*page_free)(struct page *page);
 
-	/*
-	 * Transition the refcount in struct dev_pagemap to the dead state.
-	 */
-	void (*kill)(struct dev_pagemap *pgmap);
-
-	/*
-	 * Wait for refcount in struct dev_pagemap to be idle and reap it.
-	 */
-	void (*cleanup)(struct dev_pagemap *pgmap);
-
 	/*
 	 * Used for private (un-addressable) device memory only.  Must migrate
 	 * the page back to a CPU accessible page.
@@ -95,8 +85,7 @@ struct dev_pagemap_ops {
  * struct dev_pagemap - metadata for ZONE_DEVICE mappings
  * @altmap: pre-allocated/reserved memory for vmemmap allocations
  * @ref: reference count that pins the devm_memremap_pages() mapping
- * @internal_ref: internal reference if @ref is not provided by the caller
- * @done: completion for @internal_ref
+ * @done: completion for @ref
  * @type: memory type: see MEMORY_* in memory_hotplug.h
  * @flags: PGMAP_* flags to specify defailed behavior
  * @ops: method table
@@ -109,8 +98,7 @@ struct dev_pagemap_ops {
  */
 struct dev_pagemap {
 	struct vmem_altmap altmap;
-	struct percpu_ref *ref;
-	struct percpu_ref internal_ref;
+	struct percpu_ref ref;
 	struct completion done;
 	enum memory_type type;
 	unsigned int flags;
@@ -191,7 +179,7 @@ static inline unsigned long memremap_compat_align(void)
 static inline void put_dev_pagemap(struct dev_pagemap *pgmap)
 {
 	if (pgmap)
-		percpu_ref_put(pgmap->ref);
+		percpu_ref_put(&pgmap->ref);
 }
 
 #endif /* _LINUX_MEMREMAP_H_ */
diff --git a/mm/memremap.c b/mm/memremap.c
index ed593bf87109a..d7034c55d0a24 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -112,30 +112,6 @@ static unsigned long pfn_next(unsigned long pfn)
 #define for_each_device_pfn(pfn, map, i) \
 	for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(pfn))
 
-static void dev_pagemap_kill(struct dev_pagemap *pgmap)
-{
-	if (pgmap->ops && pgmap->ops->kill)
-		pgmap->ops->kill(pgmap);
-	else
-		percpu_ref_kill(pgmap->ref);
-}
-
-static void dev_pagemap_cleanup(struct dev_pagemap *pgmap)
-{
-	if (pgmap->ops && pgmap->ops->cleanup) {
-		pgmap->ops->cleanup(pgmap);
-	} else {
-		wait_for_completion(&pgmap->done);
-		percpu_ref_exit(pgmap->ref);
-	}
-	/*
-	 * Undo the pgmap ref assignment for the internal case as the
-	 * caller may re-enable the same pgmap.
-	 */
-	if (pgmap->ref == &pgmap->internal_ref)
-		pgmap->ref = NULL;
-}
-
 static void pageunmap_range(struct dev_pagemap *pgmap, int range_id)
 {
 	struct range *range = &pgmap->ranges[range_id];
@@ -167,11 +143,12 @@ void memunmap_pages(struct dev_pagemap *pgmap)
 	unsigned long pfn;
 	int i;
 
-	dev_pagemap_kill(pgmap);
+	percpu_ref_kill(&pgmap->ref);
 	for (i = 0; i < pgmap->nr_range; i++)
 		for_each_device_pfn(pfn, pgmap, i)
 			put_page(pfn_to_page(pfn));
-	dev_pagemap_cleanup(pgmap);
+	wait_for_completion(&pgmap->done);
+	percpu_ref_exit(&pgmap->ref);
 
 	for (i = 0; i < pgmap->nr_range; i++)
 		pageunmap_range(pgmap, i);
@@ -188,8 +165,7 @@ static void devm_memremap_pages_release(void *data)
 
 static void dev_pagemap_percpu_release(struct percpu_ref *ref)
 {
-	struct dev_pagemap *pgmap =
-		container_of(ref, struct dev_pagemap, internal_ref);
+	struct dev_pagemap *pgmap = container_of(ref, struct dev_pagemap, ref);
 
 	complete(&pgmap->done);
 }
@@ -295,8 +271,8 @@ static int pagemap_range(struct dev_pagemap *pgmap, struct mhp_params *params,
 	memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
 				PHYS_PFN(range->start),
 				PHYS_PFN(range_len(range)), pgmap);
-	percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
-			- pfn_first(pgmap, range_id));
+	percpu_ref_get_many(&pgmap->ref,
+		pfn_end(pgmap, range_id) - pfn_first(pgmap, range_id));
 	return 0;
 
 err_add_memory:
@@ -362,22 +338,11 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 		break;
 	}
 
-	if (!pgmap->ref) {
-		if (pgmap->ops && (pgmap->ops->kill || pgmap->ops->cleanup))
-			return ERR_PTR(-EINVAL);
-
-		init_completion(&pgmap->done);
-		error = percpu_ref_init(&pgmap->internal_ref,
-				dev_pagemap_percpu_release, 0, GFP_KERNEL);
-		if (error)
-			return ERR_PTR(error);
-		pgmap->ref = &pgmap->internal_ref;
-	} else {
-		if (!pgmap->ops || !pgmap->ops->kill || !pgmap->ops->cleanup) {
-			WARN(1, "Missing reference count teardown definition\n");
-			return ERR_PTR(-EINVAL);
-		}
-	}
+	init_completion(&pgmap->done);
+	error = percpu_ref_init(&pgmap->ref, dev_pagemap_percpu_release, 0,
+				GFP_KERNEL);
+	if (error)
+		return ERR_PTR(error);
 
 	devmap_managed_enable_get(pgmap);
 
@@ -486,7 +451,7 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 	/* fall back to slow path lookup */
 	rcu_read_lock();
 	pgmap = xa_load(&pgmap_array, PHYS_PFN(phys));
-	if (pgmap && !percpu_ref_tryget_live(pgmap->ref))
+	if (pgmap && !percpu_ref_tryget_live(&pgmap->ref))
 		pgmap = NULL;
 	rcu_read_unlock();
 
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index ed563bdd88f39..b752ce47ead3c 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -100,25 +100,17 @@ static void nfit_test_kill(void *_pgmap)
 {
 	struct dev_pagemap *pgmap = _pgmap;
 
-	WARN_ON(!pgmap || !pgmap->ref);
-
-	if (pgmap->ops && pgmap->ops->kill)
-		pgmap->ops->kill(pgmap);
-	else
-		percpu_ref_kill(pgmap->ref);
-
-	if (pgmap->ops && pgmap->ops->cleanup) {
-		pgmap->ops->cleanup(pgmap);
-	} else {
-		wait_for_completion(&pgmap->done);
-		percpu_ref_exit(pgmap->ref);
-	}
+	WARN_ON(!pgmap);
+
+	percpu_ref_kill(&pgmap->ref);
+
+	wait_for_completion(&pgmap->done);
+	percpu_ref_exit(&pgmap->ref);
 }
 
 static void dev_pagemap_percpu_release(struct percpu_ref *ref)
 {
-	struct dev_pagemap *pgmap =
-		container_of(ref, struct dev_pagemap, internal_ref);
+	struct dev_pagemap *pgmap = container_of(ref, struct dev_pagemap, ref);
 
 	complete(&pgmap->done);
 }
@@ -132,22 +124,11 @@ void *__wrap_devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 	if (!nfit_res)
 		return devm_memremap_pages(dev, pgmap);
 
-	if (!pgmap->ref) {
-		if (pgmap->ops && (pgmap->ops->kill || pgmap->ops->cleanup))
-			return ERR_PTR(-EINVAL);
-
-		init_completion(&pgmap->done);
-		error = percpu_ref_init(&pgmap->internal_ref,
-				dev_pagemap_percpu_release, 0, GFP_KERNEL);
-		if (error)
-			return ERR_PTR(error);
-		pgmap->ref = &pgmap->internal_ref;
-	} else {
-		if (!pgmap->ops || !pgmap->ops->kill || !pgmap->ops->cleanup) {
-			WARN(1, "Missing reference count teardown definition\n");
-			return ERR_PTR(-EINVAL);
-		}
-	}
+	init_completion(&pgmap->done);
+	error = percpu_ref_init(&pgmap->ref, dev_pagemap_percpu_release, 0,
+				GFP_KERNEL);
+	if (error)
+		return ERR_PTR(error);
 
 	error = devm_add_action_or_reset(dev, nfit_test_kill, pgmap);
 	if (error)
-- 
2.30.2

