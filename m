Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECE53B8959
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576091; cv=none; b=UauakkVEo8AvFtjMKaTI/3g1afT/69dndsEdIPudXAlJ3XZd2M8Qx1cigG9LpMwZzRS4oQmThlRsS/e2v7YDGWkJevYX0wVFfnMyyhr0qQ0XDQSJND/zdYJuy4YtdQ+XRdpNr4cj5vUGrEG0mOoincKfEwGC4IT3FkTiNrnub64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576091; c=relaxed/simple;
	bh=s8N6ij9YzlqwJM+1Bik+LPbU80jwh2BdJJ4iGqocVBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aoutx+NAohKuMvy3j1vHCg6/VTnzL/5K/mnXfv6naNEp54VMp+txGM0BBi3qqDLuTyugfCIdYlYw4kqOf6mP/a5/CCaNoO4HVpgLYAkh7+EDF0kxuT4946LUwnUdXUm+eXobvDZi3XliibiUcpkMhKa64YCFH4hI5Uf21Ze3zV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=CnjQANCi; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="CnjQANCi"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8f29ec73064so104740286d6.1
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576087; x=1785180887; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O4ZbFLqrZPbRYYHVyM+GUe32g3SELymPp/g2pETaCC4=;
        b=CnjQANCidzrIFPcPnHkJVjPdT0l+Vj1DUlnq1YBwQXn+/34azZAjoAuEfLUlIB7dPn
         N9KtaMAloYWV9cCjw0/mcXl57wf0rkF98FNhjD0NEoldyGGyx1TpqrDVZPZyMX9WRcj7
         Ftn0H+vF+gabhYrVxTnrvhMOOhs/iWaSu4ZXvy4GMsy89wTkvbPb0zLiXREWk/HuSENU
         s+SQ7xxsMeo06AqgkVfOJG14lsApKvxhzI6Lz1pGgQKHmwp5taqbQytqwPS4gJgW/kjw
         zBvA6REJOaacGO6IYP29cnSMbqu80d7pa0Rbl7cOx9cXJhhz6X6dDFPQok35m/T0iZda
         KMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576087; x=1785180887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O4ZbFLqrZPbRYYHVyM+GUe32g3SELymPp/g2pETaCC4=;
        b=Kb2f3sxGzUjCr1mvKPYsn1FuuIE3eIl7hScyNBNiNRVvaegsAG77Ljna5SAPD8126Z
         uh2sGHYisTGaXn75bl6P/+KYeZ4fcYeSL2kf52ev0xconKbcmOKEf5xFgOIAbEV31if4
         GK7t/9G8W3q0YlXMZlOXB8TZI2GEM2IeThR1OvH7SV0FV5dYlKw2zQS8f0+rEs852t55
         wjR8gYyk3Xo8zW5eTML45oW5FI2npsI2u7Gh/701W0h/CcdIdzb8EbrOBF3Mk6WzuKTD
         9ySYMszgkl5tODBGcPH0HIrPUPjwjcuhd35tCxm/Kg6/YjzH/lbvDissQShtB48QjoZV
         pahA==
X-Forwarded-Encrypted: i=1; AHgh+RrZjh1lJMMvJsXDtLL9nyz7hJl6RNMBIRfAXKdbMrZwL+hcdKpjUDIX0KrlXFvXYdGtvMZnKDI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8Zs4n1xJF48X3bJVq6dODGPpMohO8D9yLrDxtOk0a89cvoAxr
	sRc+89GMV2T6Guv/DhpqfC9GgJCx+ZsuaYljzQ7BOPzBRhr8OMNCrJyUjKmAZ0cFOlA=
X-Gm-Gg: AfdE7cn7wGloAVRb/KphaZ35CJYYAQhDlb/P/cHoMJCsVSHyZXxTg/5fYXNgXhiqdEG
	9e79rmnClXFYBvC3lUFZXnQKtedo/qOlZ3lqvMX7QqlpbCDfqc7/qPeeeEUsv46D0d04w8+a04S
	SLXntnbnpcy9ROWUuk/go7UuxVswjw8W4OfWMD95ucg1IgAS5ZP9xcv7ctMk1MuXqoxA+WatY9L
	N8GSeeW/yeopdCjwztI5bbUInNv/vO/+ZuEgXaoi6r7LBlvM6HJTIe70U2bkxCK37iZ+AD/aenL
	IRQcrNA2UVh88KB8NVw4tgz0qvF6t0CzcT6fUZnbKy42PF2IRUHt1hk/Ob6JLpIN5vOdP0TxzJO
	3fdxW3dFFfgMT6W83dasKEkJ3jEG5ob0Ymjiq1qqEEKcuuVtRrmjHMfI/YuxuGbMGLsFTJUEPWv
	Vd6LUvLdiS0DDMvKOuOcPGohwboL2DLcl2Na4E01qaXvq2ApjlfgkClzkFHrFQoBI=
X-Received: by 2002:a05:620a:4713:b0:92b:67e6:4b66 with SMTP id af79cd13be357-930b416d8f5mr1564037585a.61.1784576086371;
        Mon, 20 Jul 2026 12:34:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:34:45 -0700 (PDT)
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
Subject: [PATCH v5 03/36] mm/page_alloc: let the bulk and folio allocators carry alloc_flags
Date: Mon, 20 Jul 2026 15:33:57 -0400
Message-ID: <20260720193431.3841992-4-gourry@gourry.net>
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

__alloc_pages_noprof() takes an explicit alloc_flags, but the bulk and
folio entry points do not, so callers cannot select allocator behaviour
(e.g. an alternate zonelist) through them.

Thread alloc_flags through both, matching __alloc_pages_noprof(), and
keep the flag-carrying primitives mm-internal (page_alloc.h) so the
public gfp.h wrappers stay flag-free:

 - add __alloc_pages_bulk_noprof(gfp, alloc_flags, ...) in page_alloc.h
   alloc_pages_bulk_noprof() becomes a wrapper passing ALLOC_DEFAULT

 - give __folio_alloc_noprof() an alloc_flags parameter and moves
   __folio_alloc_node_noprof() moves into page_alloc.c
   __folio_alloc_noprof() is no longer exported

No functional change: every caller passes ALLOC_DEFAULT.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/gfp.h | 13 +------------
 mm/khugepaged.c     |  2 +-
 mm/migrate.c        |  2 +-
 mm/page_alloc.c     | 46 ++++++++++++++++++++++++++++++---------------
 mm/page_alloc.h     |  8 ++++++++
 5 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 872bc53f32ec8..a327e58c313f8 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -204,10 +204,6 @@ static inline void arch_free_page(struct page *page, int order) { }
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
-struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask);
-#define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
-
 unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 				nodemask_t *nodemask, int nr_pages,
 				struct page **page_array);
@@ -252,14 +248,7 @@ static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
 	dump_stack();
 }
 
-static inline
-struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
-{
-	warn_if_node_offline(nid, gfp);
-
-	return __folio_alloc_noprof(gfp, order, nid, NULL);
-}
-
+struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid);
 #define  __folio_alloc_node(...)		alloc_hooks(__folio_alloc_node_noprof(__VA_ARGS__))
 
 /*
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 27e8f3077e80f..89ce6bcbc376b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1243,7 +1243,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
-	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask);
+	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask, ALLOC_DEFAULT);
 	if (!folio) {
 		*foliop = NULL;
 		if (is_pmd_order(order))
diff --git a/mm/migrate.c b/mm/migrate.c
index 60355be9f652c..a8a86141dbb54 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2231,7 +2231,7 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
 	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
 		gfp_mask |= __GFP_HIGHMEM;
 
-	return __folio_alloc(gfp_mask, order, nid, mtc->nmask);
+	return __folio_alloc(gfp_mask, order, nid, mtc->nmask, ALLOC_DEFAULT);
 }
 
 #ifdef CONFIG_NUMA_MIGRATION
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4c1ef84c02a3d..aa35bbe5d4c3e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5103,8 +5103,8 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
  * @page_array were set to %NULL on entry, the slots from 0 to the return value
  * - 1 will be filled.
  */
-unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
-			nodemask_t *nodemask, int nr_pages,
+unsigned long __alloc_pages_bulk_noprof(gfp_t gfp, unsigned int alloc_flags,
+			int preferred_nid, nodemask_t *nodemask, int nr_pages,
 			struct page **page_array)
 {
 	struct page *page;
@@ -5112,8 +5112,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
-	struct alloc_context ac;
-	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	struct alloc_context ac = { .alloc_flags = alloc_flags };
+	unsigned int fastpath_alloc_flags = alloc_flags | ALLOC_WMARK_LOW;
 	int nr_populated = 0, nr_account = 0;
 
 	/*
@@ -5153,7 +5153,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
-	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
+	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &fastpath_alloc_flags))
 		goto out;
 
 	/* Find an allowed local zone that meets the low watermark. */
@@ -5161,7 +5161,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
 
-		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
+		if (cpusets_enabled() && (fastpath_alloc_flags & ALLOC_CPUSET) &&
 		    !__cpuset_zone_allowed(zone, gfp)) {
 			continue;
 		}
@@ -5171,16 +5171,17 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			goto failed;
 		}
 
-		cond_accept_memory(zone, 0, alloc_flags);
+		cond_accept_memory(zone, 0, fastpath_alloc_flags);
 retry_this_zone:
-		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
+		mark = wmark_pages(zone, fastpath_alloc_flags & ALLOC_WMARK_MASK) +
+		       nr_pages - nr_populated;
 		if (zone_watermark_fast(zone, 0,  mark,
 				zonelist_zone_idx(ac.preferred_zoneref),
-				alloc_flags, gfp)) {
+				fastpath_alloc_flags, gfp)) {
 			break;
 		}
 
-		if (cond_accept_memory(zone, 0, alloc_flags))
+		if (cond_accept_memory(zone, 0, fastpath_alloc_flags))
 			goto retry_this_zone;
 
 		/* Try again if zone has deferred pages */
@@ -5212,7 +5213,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			continue;
 		}
 
-		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
+		page = __rmqueue_pcplist(zone, 0, ac.migratetype, fastpath_alloc_flags,
 								pcp, pcp_list);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
@@ -5238,11 +5239,19 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	return nr_populated;
 
 failed:
-	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, ALLOC_DEFAULT);
+	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, alloc_flags);
 	if (page)
 		page_array[nr_populated++] = page;
 	goto out;
 }
+
+unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
+			nodemask_t *nodemask, int nr_pages,
+			struct page **page_array)
+{
+	return __alloc_pages_bulk_noprof(gfp, ALLOC_DEFAULT, preferred_nid,
+					 nodemask, nr_pages, page_array);
+}
 EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
 
 /*
@@ -5433,13 +5442,20 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
 EXPORT_SYMBOL(alloc_pages_node_noprof);
 
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask)
+		nodemask_t *nodemask, unsigned int alloc_flags)
 {
 	struct page *page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
-					preferred_nid, nodemask, ALLOC_DEFAULT);
+					preferred_nid, nodemask, alloc_flags);
 	return page_rmappable_folio(page);
 }
-EXPORT_SYMBOL(__folio_alloc_noprof);
+
+struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
+{
+	warn_if_node_offline(nid, gfp);
+
+	return __folio_alloc_noprof(gfp, order, nid, NULL, ALLOC_DEFAULT);
+}
+EXPORT_SYMBOL(__folio_alloc_node_noprof);
 
 /*
  * Common helper functions. Never use with __GFP_HIGHMEM because the returned
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index b9259deddb59d..23fc79ce97b60 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -258,6 +258,14 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_n
 		nodemask_t *nodemask, unsigned int alloc_flags);
 #define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
 
+struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
+		nodemask_t *nodemask, unsigned int alloc_flags);
+#define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
+
+unsigned long __alloc_pages_bulk_noprof(gfp_t gfp, unsigned int alloc_flags,
+		int preferred_nid, nodemask_t *nodemask, int nr_pages,
+		struct page **page_array);
+
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
-- 
2.53.0-Meta

