Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1369407CD6
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576097; cv=none; b=BbsGTemVmXe6pf6hxX7ttWgG1Gz6cbBlgfNR9WrtdozDd3F7rJxB7Z5AmMPo/203QXgdcaxttBfoFL/dbhcrpXSiY7RwLxNZU2WoqUG9yDfkl2/EweZDdY71ikulmu2uq2ittRzjbKyVZs+23DgSu65RzBl4ecSFDXAfWRjFaDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576097; c=relaxed/simple;
	bh=3loIybudyxrGrhfBqE2Ys1DCGFTX714uijfxpiRRqZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDxFjqjhtKUHXdQlONVffRn6MiPsJDpl+zT0vrwGQrHHGUX11KWK5ehLW8UvVcCs1rCNW5HlCg/4jwHJpk/KLxItLr6+T8vNEZjXi7UTjAr2oU/Q5snU8D9x2cKVa1KwxQjI+cg6C0IYu43/JM4hAGIJgy2Zux8KMAu0cx6XC/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Bng/ylQM; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Bng/ylQM"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e50c5d14cso756364985a.2
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576092; x=1785180892; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q409+JQ/uWnw6WpILbqdiAKa+RhnPorqknZtMcjhbGU=;
        b=Bng/ylQM7lofjoIpD8dEjDVqtOPTWzwGtt4Y8BV5cJW7pZv0YCn+qiZAPMBNaavO8V
         TWJFCaBusLMkW1x44RUVNSDyTzMQGJYs5HMdP+K5HUfNPI+A0F9eBcqvquQoAFkGBomr
         bPPSuRhBUayW3KY1ZPXxsi8WIGb3LERIOX34Vf/vjXGxZsNHnd7eHuCAUQtxYuuM4Rm9
         5gUwQs4r2ogOQv5CNad7hBtGtcRF+V9zdAZiZg+dhAnzJhBvTe23B0nKgXm7SYCLVasr
         FCy6CtUtEOCGBpvFxfxs1vPlI08AIoqrSK6oKejXtgRSvIL1ZHkp8GKRwrXdz4rVryhz
         72/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576092; x=1785180892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q409+JQ/uWnw6WpILbqdiAKa+RhnPorqknZtMcjhbGU=;
        b=azzdcRZWhfW1k6eEwNraumOFCxtziszlBIkltvKjuR3yLp6l5L0T5s9fZi+LzSKy10
         o1MBZdklOvO4YumpJrPy0bS34UI6Sg1nxl/mNkd8nn+/c6NUN8MXALBhdnpSOhzm+Da9
         5hxr9W522woCqfkjnR0f9NpZc19RNLLO0dWbnkdFwHq+/7XWK4jWfURfqtOuU7nML9t7
         YE+5hQsxtOiLKZSsA4XN1cYyifvej1L0u2e4e+BJ5x5p7gj6hjkpwtzgCC6kUt4kVHNH
         YQVp+l6ySt438D7BsZ0tJj03nxaixGx1TubMmqso0ZMabpgdxW7Qwl2ztjPOTWUEDrE2
         ZkXQ==
X-Forwarded-Encrypted: i=1; AHgh+RrDjQfeFefM/jAsrM4Ld5GDhkjAUOooz3ycbWC8W26t/mKZVvoYsBihN8BfnlaK2FGIcM9km1U=@lists.linux.dev
X-Gm-Message-State: AOJu0YzUCEK8v1Nyzkry4Hwb0RqI5cdLfUyldT6QYgGED+P13pxFQAfF
	yJvBZV7t4qkJmSXPXucE2Z8g7gUHqcsT4qj8VOwE006q6yR3k0oZCc4sCFKI2DRJV/I=
X-Gm-Gg: AfdE7cmdyomlg2qb0E72Z3KbgR9x4fny4nhVWibt6MQnbsYaGXFcULG4CnAcHkUlm/M
	NTPVVsz+c+8y0O/PN2xOdZtcRfhRPFQhm6xjYJf/pOxdXjTuYD1K9rORwb9RAL90mKLjUKkKnY/
	98/BFCON3FU50NajSEDTs7gWetRtToU+Xx+r7l41tVz4ue/hCH8lUOgNXeeUiST0qguGNy47Zgc
	9EtUEZA4eUA2hdcWJ9AINTVBj2WpGVM++cJcF45w+rgY2HvbzOVnIG6v7rJfRsztQyHjuNzUeFl
	2ND1kdMTJ0gxo10LxTfGtgeGqVkbmqEpKJ+293U02MOFemkd82SWXgiv4EzgIxpWLMmMwIujEwD
	tIudMzAzkQV4vBBwDNlFsViaInuLQhMO4gp/HC70Gs2Uekcuj3iOWggja3JS/m4RV0LyYPXDy3V
	cvVpX2+jAnjIR8PJXu4L5VtnkynufgtQuHNc0MFEpaioTqFryOwCozz3kOlL88VfvJ2X3A4zEZ4
	w==
X-Received: by 2002:a05:620a:2711:b0:930:a6ac:3a8f with SMTP id af79cd13be357-930b41e067cmr1638750885a.57.1784576091600;
        Mon, 20 Jul 2026 12:34:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:34:51 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 05/36] mm: add ZONELIST_PRIVATE(_NOFALLBACK) for N_MEMORY_PRIVATE nodes.
Date: Mon, 20 Jul 2026 15:33:59 -0400
Message-ID: <20260720193431.3841992-6-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

N_MEMORY_PRIVATE nodes must be invisible to ordinary allocation,
no allocations may reach one unless explicitly called for.

Make this isolation structural in the zonelists: N_MEMORY_PRIVATE
nodes are excluded from FALLBACK and NOFALLBACK entirely, making
them effectively invisible to all normal callers of page_alloc.

Add ZONELIST_PRIVATE, which spans (N_MEMORY | N_MEMORY_PRIVATE).
When !CONFIG_NUMA, it aliases ZONELIST_FALLBACK and compiles out.

Add ZONELIST_PRIVATE_NOFALLBACK as the __GFP_THISNODE target for
private node allocations.

Zonelist selection rides the allocator's alloc_flags.  Add
ALLOC_ZONELIST_PRIVATE and resolve it in select_zonelist(), which
prepare_alloc_pages() applies from ac->alloc_flags; the default
(ALLOC_DEFAULT) keeps node_zonelist()'s gfp-based selection.

Add explicit private-node alloc() functions to prevent open-coding
(both ride ALLOC_ZONELIST_PRIVATE through the alloc_flags-carrying
entry points):
   - alloc_pages_node_private_noprof()
   - folio_alloc_node_private_noprof()

alloc_contig_range adds an explicit node_is_private() guard because
it dervices its target zones from PFNs rather than zonelists. All
in-tree callers use N_MEMORY ranges, but the check prevents future
callers from violating node isolation.

Important note:  By design this zonelist isolates N_MEMORY_PRIVATE
from unintentional allocations, but does NOT isolate private-node
allocations from falling back to non-private nodes.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/gfp.h    | 11 ++++++++
 include/linux/mmzone.h | 11 +++++++-
 mm/mm_init.c           |  2 +-
 mm/page_alloc.c        | 64 ++++++++++++++++++++++++++++++++++++++++--
 mm/page_alloc.h        | 26 +++++++++++++++++
 5 files changed, 109 insertions(+), 5 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index a327e58c313f8..f3e867de744f6 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -204,6 +204,17 @@ static inline void arch_free_page(struct page *page, int order) { }
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
+/* Allocate from an N_MEMORY_PRIVATE node (selects the private zonelist). */
+struct page *alloc_pages_node_private_noprof(gfp_t gfp, unsigned int order,
+		int nid);
+#define alloc_pages_node_private(...)				\
+	alloc_hooks(alloc_pages_node_private_noprof(__VA_ARGS__))
+
+struct folio *folio_alloc_node_private_noprof(gfp_t gfp, unsigned int order,
+		int nid);
+#define folio_alloc_node_private(...)				\
+	alloc_hooks(folio_alloc_node_private_noprof(__VA_ARGS__))
+
 unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 				nodemask_t *nodemask, int nr_pages,
 				struct page **page_array);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9815e48c03b97..654c5111f7cec 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1392,13 +1392,22 @@ enum {
 #ifdef CONFIG_NUMA
 	/*
 	 * The NUMA zonelists are doubled because we need zonelists that
-	 * restrict the allocations to a single node for __GFP_THISNODE.
+	 * restrict the allocations to a single node for __GFP_THISNODE
+	 * and N_MEMORY_PRIVATE nodes (isolated from default lists).
 	 */
 	ZONELIST_NOFALLBACK,	/* zonelist without fallback (__GFP_THISNODE) */
+	ZONELIST_PRIVATE,	/* N_MEMORY_PRIVATE access, falls back to DRAM */
+	ZONELIST_PRIVATE_NOFALLBACK, /* N_MEMORY_PRIVATE access, __GFP_THISNODE */
 #endif
 	MAX_ZONELISTS
 };
 
+#ifndef CONFIG_NUMA
+/* Without NUMA only ZONELIST_FALLBACK exists so everything collapses there */
+#define ZONELIST_PRIVATE		ZONELIST_FALLBACK
+#define ZONELIST_PRIVATE_NOFALLBACK	ZONELIST_FALLBACK
+#endif
+
 /*
  * This struct contains information about a zone in a zonelist. It is stored
  * here to avoid dereferences into large structures and lookups of tables
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 711f821f7b3c7..adb50647d29ca 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2701,7 +2701,7 @@ void __init mm_core_init(void)
 	init_zero_page_pfn();
 
 	/* Initializations relying on SMP setup */
-	BUILD_BUG_ON(MAX_ZONELISTS > 2);
+	BUILD_BUG_ON(MAX_ZONELISTS > 4);
 	build_all_zonelists(NULL);
 	page_alloc_init_cpuhp();
 	alloc_tag_sec_init();
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index aa35bbe5d4c3e..78755a55b1540 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5040,7 +5040,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		unsigned int *alloc_flags)
 {
 	ac->highest_zoneidx = gfp_zone(gfp_mask);
-	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
+	ac->zonelist = select_zonelist(preferred_nid, gfp_mask, ac->alloc_flags);
 	ac->nodemask = nodemask;
 	ac->migratetype = gfp_migratetype(gfp_mask);
 
@@ -5346,7 +5346,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	unsigned int fastpath_alloc_flags = alloc_flags;
 
 	/* Other flags could be supported later if needed. */
-	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG)))
+	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG | ALLOC_ZONELIST_PRIVATE)))
 		return NULL;
 
 	if (!alloc_order_allowed(gfp, order, alloc_flags))
@@ -5457,6 +5457,22 @@ struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
 }
 EXPORT_SYMBOL(__folio_alloc_node_noprof);
 
+struct page *alloc_pages_node_private_noprof(gfp_t gfp, unsigned int order,
+		int nid)
+{
+	return __alloc_pages_noprof(gfp, order, nid, NULL,
+				   ALLOC_ZONELIST_PRIVATE);
+}
+EXPORT_SYMBOL_GPL(alloc_pages_node_private_noprof);
+
+struct folio *folio_alloc_node_private_noprof(gfp_t gfp, unsigned int order,
+		int nid)
+{
+	return __folio_alloc_noprof(gfp, order, nid, NULL,
+				   ALLOC_ZONELIST_PRIVATE);
+}
+EXPORT_SYMBOL_GPL(folio_alloc_node_private_noprof);
+
 /*
  * Common helper functions. Never use with __GFP_HIGHMEM because the returned
  * address cannot represent highmem pages. Use alloc_pages and then kmap if
@@ -5854,9 +5870,21 @@ static void build_zonelists_in_node_order(pg_data_t *pgdat, int *node_order,
 static void build_thisnode_zonelists(pg_data_t *pgdat)
 {
 	struct zoneref *zonerefs;
-	int nr_zones;
+	int nr_zones = 0;
 
+	/*
+	 * NOFALLBACK: the node's own zones. EMPTY for private nodes so a
+	 * stray __GFP_THISNODE allocation can't violate isolation.
+	 */
 	zonerefs = pgdat->node_zonelists[ZONELIST_NOFALLBACK]._zonerefs;
+	if (!node_is_private(pgdat->node_id))
+		nr_zones = build_zonerefs_node(pgdat, zonerefs);
+	zonerefs += nr_zones;
+	zonerefs->zone = NULL;
+	zonerefs->zone_idx = 0;
+
+	/* PRIVATE_NOFALLBACK: the node's own zones, private nodes included. */
+	zonerefs = pgdat->node_zonelists[ZONELIST_PRIVATE_NOFALLBACK]._zonerefs;
 	nr_zones = build_zonerefs_node(pgdat, zonerefs);
 	zonerefs += nr_zones;
 	zonerefs->zone = NULL;
@@ -5899,11 +5927,28 @@ static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *candidates,
 static void build_zonelists(pg_data_t *pgdat)
 {
 	static int node_order[MAX_NUMNODES];
+	nodemask_t tier_nodes;
 	int local_node = pgdat->node_id;
 	int node, nr_nodes = 0;
 
 	memset(node_order, 0, sizeof(node_order));
 
+	/*
+	 * Zonelists: FALLBACK, NOFALLBACK, PRIVATE
+	 *
+	 * FALLBACK:   Allocation order for all nodes.  Private nodes have lists
+	 *             but never appear as an entry in any list. Allocations
+	 *             targeting a private node w/ FALLBACK land on N_MEMORY.
+	 *
+	 * NOFALLBACK: A list for each node containing only itself.
+	 *             Allocations targeting a private node w/ NOFALLBACK
+	 *             will always fail (their NOFALLBACK is empty)
+	 *
+	 * PRIVATE:    (N_MEMORY | N_MEMORY_PRIVATE) - allows access to
+	 *             private nodes, and falls back to normal memory unless
+	 *             __GFP_THISNODE otherwise constrains it.
+	 */
+
 	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK,
 			    true, node_order, &nr_nodes);
 	build_thisnode_zonelists(pgdat);
@@ -5912,6 +5957,10 @@ static void build_zonelists(pg_data_t *pgdat)
 	for (node = 0; node < nr_nodes; node++)
 		pr_cont("%d ", node_order[node]);
 	pr_cont("\n");
+
+	nodes_or(tier_nodes, node_states[N_MEMORY], node_states[N_MEMORY_PRIVATE]);
+	build_node_zonelist(pgdat, &tier_nodes, ZONELIST_PRIVATE, false,
+			    node_order, &nr_nodes);
 }
 
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
@@ -7282,6 +7331,15 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
 		return -EINVAL;
 
+	/*
+	 * Private nodes are kept unreachable via the zonelists, but
+	 * alloc_contig works directly on a zone derived from the caller's
+	 * pfn range, bypassing that.  Reject this operation explicitly
+	 * rather than silently carving memory out of an isolated node.
+	 */
+	if (unlikely(node_is_private(zone_to_nid(cc.zone))))
+		return -EBUSY;
+
 	/*
 	 * What we do here is we mark all pageblocks in range as
 	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 23fc79ce97b60..741448d83ce77 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -57,6 +57,9 @@
  */
 #define ALLOC_NO_CODETAG       0x1000
 
+/* Select the N_MEMORY_PRIVATE zonelist family (see select_zonelist()). */
+#define ALLOC_ZONELIST_PRIVATE 0x2000
+
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
@@ -95,6 +98,29 @@ struct alloc_context {
 	unsigned int alloc_flags;
 };
 
+#ifdef CONFIG_NUMA
+static_assert(ZONELIST_PRIVATE + 1 == ZONELIST_PRIVATE_NOFALLBACK);
+#endif
+
+/*
+ * select_zonelist - resolve the zonelist for an allocation
+ *
+ * The default matches node_zonelist(); ALLOC_ZONELIST_PRIVATE selects the
+ * private-node family so an allocation may reach an N_MEMORY_PRIVATE node.
+ */
+static inline struct zonelist *
+select_zonelist(int nid, gfp_t gfp, unsigned int alloc_flags)
+{
+#ifdef CONFIG_NUMA
+	if (alloc_flags & ALLOC_ZONELIST_PRIVATE) {
+		int idx = ZONELIST_PRIVATE + !!(gfp & __GFP_THISNODE);
+
+		return &NODE_DATA(nid)->node_zonelists[idx];
+	}
+#endif
+	return node_zonelist(nid, gfp);
+}
+
 /*
  * This function returns the order of a free page in the buddy system. In
  * general, page_zone(page)->lock must be held by the caller to prevent the
-- 
2.53.0-Meta

