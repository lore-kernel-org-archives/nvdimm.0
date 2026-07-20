Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F9C427FBF
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576152; cv=none; b=FdpfS4Ah08Hn1QmfD1R8OawOdeqA/YNBv0QjgUWEeJnELOukcCUxMFiIB+Mz2Y3mMLld6XGkeAOuExZUIPIBamBHs8oc1YL8aY/LvC1ZiLU1PgZvK73PI8RP8toHtF0pL8LDq9v7EXZcgJ3hol5OpQKTVUqCl++hxrun5h0OU+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576152; c=relaxed/simple;
	bh=MF6HK8y8ZqLlSe/JUbwAjJuiKDLQb3nicgnVHHp//rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFU2Exb6Yb2k7ZUNCHjTG9TZOA+NB0uCJGAG1ib2j9PrhMvTZ1o+LFRt3/OPwfaUgsWCS28nryt+3jQ3FaB6yNbJAHGtNu9qGbQZmwzMrpbFwTYG/h3Izabekr+S/NQkJmf481nRHJgzlcQ1f2/aWogZUBGKx1IwDJ06EPRrjvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=ZE5/6GTu; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="ZE5/6GTu"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e4fd65b2bso559749385a.0
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576146; x=1785180946; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QHpzVxGbRu/ZqTXED4yNVWfOYMqPg+CutdBll3xnb/c=;
        b=ZE5/6GTus8PdzeDwsVW2B4vBSBzbiugOferquX0DfoHccqPk7eyNKN2T78cn3QjzRR
         fYClgOcRkjiaGlvDRWx4neuPmxPLFjw9OcJvhoasbw3hUQDGo+e9+jLPAiGWeDX8Usri
         UjoSg46ce491xbZDQxfQOqWpdW3Q6QxXkP1eK2gylzxBjrpboxR85xleEEo7Pt+pFWku
         ptj5AIjKAynI0izKoc/AnrkcvOUeznVs+/tWSjInh4QgDPRQyXVrSXLlYUDHW8FE6kSi
         9oAwXkgExZtY9R16fB4s/7H8fDzpkz6awOZqB+cMW5rWd5CHk6jJZVMwVNUPnEJrA4Iq
         Xm1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576146; x=1785180946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QHpzVxGbRu/ZqTXED4yNVWfOYMqPg+CutdBll3xnb/c=;
        b=TeMiFdyV11Z8LdJXQ4eeeuh2FGxWd6mVARCFlG56Ve+nzDfJ6Zf/J241rm8dUsq4HX
         qOqfhLGbyl5KeMvKbjRBLcChHWiOs9tsWhc3PuP8a1DAT/L5gTp3HlN+gg5GESUF+DVI
         JWVzSxC5rzMT7lvBLBtxs4WUBfVZlrlHWrNbG5II2fOcsOb0o1fxFHKiJEjpBs0nMj2i
         NJimKkBnUdrM8pW3iGJRcgQ6xr2KNbiX6KrZWDDdrmVdNjk3kQX9UIjmORmHjEg4FODm
         m/ntJ6/gXI8MPFK+24DU+jHFfsfRQaGKW3JQP1saFMqeJejBOugcan9bN9CpcGLb1TDj
         zxmw==
X-Forwarded-Encrypted: i=1; AHgh+RoIAOtM1TEP6diOdKhKbDmeDid8CQ8JWfdfLxPik6nK+mB4WJnt/nW+OooZJfDU2wV0PrGmGys=@lists.linux.dev
X-Gm-Message-State: AOJu0YxfsgDWxAZ/3Vs8IAySFKtV2wKVD9iFdBFfHEn9bY7tHaAuGPEm
	tiDSZ4VTlH6gmKmkesexNyI9BVs8N965nKzrANuVcHzyBb1/SVGeHY/x4FqjmqDP2n4=
X-Gm-Gg: AfdE7cl4Kh/cA+QNZy21v82kbo7SEIgtRMt4kMxGj9HRdHcR1jXIfykyq3aki4wHYUY
	do5tv9qlFr5NdYYzavqhJO1AtnkCq3mr9iL+eBivDFjtSIFN47NM4dBv2AhkV1eXuky/42Kcspn
	q/ogL34iJlUoB1UswVXuKz7bAlyEv8Avzco/A9dk3vNj0TeF+Ud4Mg91cBvcQt/apPSgY//ULTN
	6SjNgEWJCvxePRCHldnn9MLRVo/raLcp5eyqwapCi21zeEYc3HBbek3lmTwGQYRcqqA74hb7n4H
	7Jwf2znYH34farjwLLxHKkyBzuUUilbM3wxUGPcqX3Bj8ZYbyXp+KNISbIrj7xyKmNWIUcvq9qz
	sR/XI2SJmMVoALAEtTvnutKwC0tuTQWfw0BVyVdB8LEw+8KaupnO2owj/II3YEYw/hDavzza6JX
	obz3fNKtvb6/PP4yjbORodvDgRcvBlik2jkqixAG8Vi+4BBVw1gCCnONfL8ZlGS68=
X-Received: by 2002:a05:620a:27d5:b0:92e:5fe2:fd35 with SMTP id af79cd13be357-930b3f374aamr1435001285a.32.1784576146223;
        Mon, 20 Jul 2026 12:35:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:45 -0700 (PDT)
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
Subject: [PATCH v5 26/36] mm: add NODE_PRIVATE_CAP_RECLAIM for opted-in private node reclaim
Date: Mon, 20 Jul 2026 15:34:20 -0400
Message-ID: <20260720193431.3841992-27-gourry@gourry.net>
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

Provide a mechanism to opt private nodes into the reclaim process.

Reclaim as a "singular service" is actually made up of:

   - kswapd reclaim
   - direct reclaim
   - kcompactd compaction
   - direct compaction
   - both mglru / lru paths
   - madvise reclaim hints
   - damon reclaim operations

CAP_RECLAIM gates whether the kernel may do inter-node placement
(compaction) or swap for the folios on that private node.

node_allows_reclaim() encapsulates the policy as a whole.  Ordinary
nodes are always reclaimable, private nodes only when opted in.

With the exception of madvise and DAMON, reclaim operations are
highly integrated with one another, so they are opted in/out of
together - otherwise reclaim becomes unpredictable.

To prevent bisect debugging failures, this stays in a single commit.

For example: reclaim without compaction will OOM on high-order
allocation failure despite a large amount of free memory. Normally
compaction would (potentially) resolve this issue.

If a private node opts into reclaim, we create normal watermarks for
that node - otherwise pgdat_balanced() is always true and reclaim
thinks there is no work to do.

Cross-node operations (demotion, promotion, khugepaged) are NOT
included in CAP_RECLAIM because some workflows may desire different
behaviors for this kind of operation:

   - prefer direct-to-swap, do not demote
   - remain resident and OOM
   - __GFP_THISNODE: fail and let the driver augment reclaim

Normal swap-out is allowed because there are clear userland controls
(not registering swap, cgroup.swap, etc) to control that per-workload.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/node_private.h | 33 +++++++++++++++++++++++++
 mm/compaction.c              |  9 ++++---
 mm/damon/paddr.c             |  4 +--
 mm/huge_memory.c             |  2 +-
 mm/internal.h                | 13 ++++++++++
 mm/madvise.c                 |  6 ++---
 mm/memory_hotplug.c          |  3 +--
 mm/page_alloc.c              |  2 +-
 mm/vmscan.c                  | 48 ++++++++++++++++++++++++++++++------
 9 files changed, 100 insertions(+), 20 deletions(-)

diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 475496c84249f..f7cbae1309904 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -7,6 +7,13 @@
 
 struct page;
 
+/*
+ * Per-node service opt-ins (node_private.caps).  A private node is isolated
+ * from all general mm services by default; the registering driver sets these
+ * to let specific services operate on its node.
+ */
+#define NODE_PRIVATE_CAP_RECLAIM	(1UL << 0)	/* allow mm reclaim */
+
 /**
  * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
  *
@@ -41,6 +48,27 @@ static inline bool node_is_private(int nid)
 	return node_state(nid, N_MEMORY_PRIVATE);
 }
 
+/**
+ * node_allows_reclaim - may the mm reclaim from this node?
+ * @nid: the node to test
+ *
+ * Only a private node is ever excluded.  Every other node can safely
+ * be operated on by reclaim.
+ */
+static inline bool node_allows_reclaim(int nid)
+{
+	struct node_private *np;
+	bool ret;
+
+	if (!node_state(nid, N_MEMORY_PRIVATE))
+		return true;
+	rcu_read_lock();
+	np = rcu_dereference(NODE_DATA(nid)->node_private);
+	ret = np && (np->caps & NODE_PRIVATE_CAP_RECLAIM);
+	rcu_read_unlock();
+	return ret;
+}
+
 #else /* !CONFIG_NUMA */
 
 static inline bool folio_is_private_node(struct folio *folio)
@@ -58,6 +86,11 @@ static inline bool node_is_private(int nid)
 	return false;
 }
 
+static inline bool node_allows_reclaim(int nid)
+{
+	return true;
+}
+
 #endif /* CONFIG_NUMA */
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
diff --git a/mm/compaction.c b/mm/compaction.c
index 8c1351cce7bcc..b9c25c599732f 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -25,6 +25,7 @@
 #include <linux/psi.h>
 #include <linux/cpuset.h>
 #include "page_alloc.h"
+#include <linux/node_private.h>
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
@@ -2462,7 +2463,7 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 		    !__cpuset_zone_allowed(zone, gfp_mask))
 			continue;
 
-		if (node_is_private(zone_to_nid(zone)))
+		if (!node_allows_reclaim(zone_to_nid(zone)))
 			continue;
 
 		/*
@@ -2856,7 +2857,7 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 			!__cpuset_zone_allowed(zone, gfp_mask))
 				continue;
 
-		if (node_is_private(zone_to_nid(zone)))
+		if (!node_allows_reclaim(zone_to_nid(zone)))
 			continue;
 
 		if (prio > MIN_COMPACT_PRIORITY
@@ -2928,7 +2929,7 @@ static int compact_node(pg_data_t *pgdat, bool proactive)
 		.proactive_compaction = proactive,
 	};
 
-	if (node_is_private(pgdat->node_id))
+	if (!node_allows_reclaim(pgdat->node_id))
 		return 0;
 
 	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
@@ -3026,7 +3027,7 @@ static ssize_t compact_store(struct device *dev,
 {
 	int nid = dev->id;
 
-	if (node_is_private(nid))
+	if (!node_allows_reclaim(nid))
 		return -EINVAL;
 
 	if (nid >= 0 && nid < nr_node_ids && node_online(nid)) {
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index c741a94319750..b668cf55d1b67 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -251,8 +251,8 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 			continue;
 		}
 
-		/* private node memory is not reclaimable by default */
-		if (folio_is_private_node(folio))
+		/* DAMOS pageout is reclaim; gate a private node on CAP_RECLAIM */
+		if (!node_allows_reclaim(folio_nid(folio)))
 			goto put_folio;
 
 		if (damos_pa_filter_out(s, folio))
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1df91b4e5c2bc..cebc89eb0541f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2340,7 +2340,7 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	folio = pmd_folio(orig_pmd);
 
-	if (folio_is_private_node(folio))
+	if (!node_allows_reclaim(folio_nid(folio)))
 		goto out;
 
 	/*
diff --git a/mm/internal.h b/mm/internal.h
index 85c460296cea1..8329034ae561f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -110,6 +110,19 @@ static inline bool page_is_private_managed(struct page *page)
 	return folio_is_private_managed(page_folio(page));
 }
 
+/*
+ * folio_allows_madvise() - may madvise reclaim hints act on this folio?
+ *
+ * madvise reclaim hints (COLD/PAGEOUT/FREE) are userland-driven reclaim, so
+ * they follow reclaim opt-in: false for ZONE_DEVICE and for N_MEMORY_PRIVATE
+ * nodes without CAP_RECLAIM, true for all other normal folios.
+ */
+static inline bool folio_allows_madvise(struct folio *folio)
+{
+	return !folio_is_zone_device(folio) &&
+	       node_allows_reclaim(folio_nid(folio));
+}
+
 /*
  * folio_allows_longterm_pin() - may this folio be long-term GUP-pinned?
  *
diff --git a/mm/madvise.c b/mm/madvise.c
index 29f35a23919a0..56ca974542707 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -396,7 +396,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 
 		folio = pmd_folio(orig_pmd);
 
-		if (folio_is_private_node(folio))
+		if (!node_allows_reclaim(folio_nid(folio)))
 			goto huge_unlock;
 
 		/* Do not interfere with other mappings of this folio */
@@ -478,7 +478,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			continue;
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_private_managed(folio))
+		if (!folio || !folio_allows_madvise(folio))
 			continue;
 
 		/*
@@ -707,7 +707,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		}
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_private_managed(folio))
+		if (!folio || !folio_allows_madvise(folio))
 			continue;
 
 		/*
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index be230ac9efe5a..1f42ed303366c 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1237,8 +1237,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	/* reinitialise watermarks and update pcp limits */
 	init_per_zone_wmark_min();
 
-	/* Private nodes opt-out of reclaim/compaction by default */
-	if (!node_is_private(nid)) {
+	if (node_allows_reclaim(nid)) {
 		kswapd_run(nid);
 		kcompactd_run(nid);
 	}
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2b08bea2379a9..2667a4564b7ac 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6667,7 +6667,7 @@ static void __setup_per_zone_wmarks(void)
 		u64 tmp;
 
 		spin_lock_irqsave(&zone->lock, flags);
-		if (node_is_private(zone_to_nid(zone))) {
+		if (!node_allows_reclaim(zone_to_nid(zone))) {
 			zone->_watermark[WMARK_MIN] = 0;
 			zone->_watermark[WMARK_LOW] = 0;
 			zone->_watermark[WMARK_HIGH] = 0;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 86b2334c23b98..f1722693ac2db 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5396,6 +5396,21 @@ static const struct attribute_group lru_gen_attr_group = {
  *                          debugfs interface
  ******************************************************************************/
 
+/*
+ * Nodes the lru_gen debugfs interface lists: ordinary memory nodes plus any
+ * N_MEMORY_PRIVATE nodes opted into reclaim.  run_cmd() already accepts the
+ * latter, so keep the listing in sync with what it accepts.
+ */
+static void lru_gen_seq_nodes(nodemask_t *nodes)
+{
+	int nid;
+
+	*nodes = node_states[N_MEMORY];
+	for_each_node_state(nid, N_MEMORY_PRIVATE)
+		if (node_allows_reclaim(nid))
+			node_set(nid, *nodes);
+}
+
 static void *lru_gen_seq_start(struct seq_file *m, loff_t *pos)
 {
 	struct mem_cgroup *memcg;
@@ -5407,9 +5422,11 @@ static void *lru_gen_seq_start(struct seq_file *m, loff_t *pos)
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
+		nodemask_t nodes;
 		int nid;
 
-		for_each_node_state(nid, N_MEMORY) {
+		lru_gen_seq_nodes(&nodes);
+		for_each_node_mask(nid, nodes) {
 			if (!nr_to_skip--)
 				return get_lruvec(memcg, nid);
 		}
@@ -5431,16 +5448,18 @@ static void *lru_gen_seq_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	int nid = lruvec_pgdat(v)->node_id;
 	struct mem_cgroup *memcg = lruvec_memcg(v);
+	nodemask_t nodes;
 
 	++*pos;
 
-	nid = next_memory_node(nid);
+	lru_gen_seq_nodes(&nodes);
+	nid = next_node(nid, nodes);
 	if (nid == MAX_NUMNODES) {
 		memcg = mem_cgroup_iter(NULL, memcg, NULL);
 		if (!memcg)
 			return NULL;
 
-		nid = first_memory_node;
+		nid = first_node(nodes);
 	}
 
 	return get_lruvec(memcg, nid);
@@ -5509,10 +5528,12 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int nid = lruvec_pgdat(lruvec)->node_id;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	nodemask_t nodes;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
-	if (nid == first_memory_node) {
+	lru_gen_seq_nodes(&nodes);
+	if (nid == first_node(nodes)) {
 		const char *path = memcg ? m->private : "";
 
 #ifdef CONFIG_MEMCG
@@ -5612,7 +5633,9 @@ static int run_cmd(char cmd, u64 memcg_id, int nid, unsigned long seq,
 	int err = -EINVAL;
 	struct mem_cgroup *memcg = NULL;
 
-	if (nid < 0 || nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY))
+	if (nid < 0 || nid >= MAX_NUMNODES ||
+	    !(node_state(nid, N_MEMORY) ||
+	      (node_is_private(nid) && node_allows_reclaim(nid))))
 		return -EINVAL;
 
 	if (!mem_cgroup_disabled()) {
@@ -6145,7 +6168,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	 * Private nodes do not support reclaim by default, filtering here
 	 * captures all normal reclaim paths that may attempt eviction.
 	 */
-	if (node_is_private(pgdat->node_id))
+	if (!node_allows_reclaim(pgdat->node_id))
 		return;
 
 	if ((lru_gen_enabled() || lru_gen_switching()) && root_reclaim(sc)) {
@@ -6758,6 +6781,16 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 	return sc.nr_reclaimed;
 }
 
+static struct zonelist *memcg_reclaim_zonelist(int nid, gfp_t gfp_mask)
+{
+	unsigned int aflags = ALLOC_DEFAULT;
+
+	if (unlikely(!nodes_empty(node_states[N_MEMORY_PRIVATE])))
+		aflags = ALLOC_ZONELIST_PRIVATE;
+
+	return select_zonelist(nid, gfp_mask, aflags);
+}
+
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
@@ -6784,7 +6817,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 	 * equal pressure on all the nodes. This is based on the assumption that
 	 * the reclaim does not bail out early.
 	 */
-	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
+	struct zonelist *zonelist = memcg_reclaim_zonelist(numa_node_id(),
+							   sc.gfp_mask);
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
 	trace_mm_vmscan_memcg_reclaim_begin(sc.gfp_mask, 0, memcg);
-- 
2.53.0-Meta

