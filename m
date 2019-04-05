Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com
 [IPv6:2607:f8b0:4864:20::442])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 721FB211EE6B1
 for <linux-nvdimm@lists.01.org>; Fri,  5 Apr 2019 15:12:27 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z5so4004686pfn.3
 for <linux-nvdimm@lists.01.org>; Fri, 05 Apr 2019 15:12:27 -0700 (PDT)
Subject: [mm PATCH v7 3/4] mm: Implement new zone specific memblock iterator
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 05 Apr 2019 15:12:25 -0700
Message-ID: <20190405221225.12227.22573.stgit@localhost.localdomain>
In-Reply-To: <20190405221043.12227.19679.stgit@localhost.localdomain>
References: <20190405221043.12227.19679.stgit@localhost.localdomain>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-mm@kvack.org, akpm@linux-foundation.org
Cc: pavel.tatashin@microsoft.com, mhocko@suse.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, willy@infradead.org, davem@davemloft.net, khalid.aziz@oracle.com, rppt@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, sparclinux@vger.kernel.org, alexander.h.duyck@linux.intel.com, ldufour@linux.vnet.ibm.com, mgorman@techsingularity.net, mingo@kernel.org, vbabka@suse.cz
List-ID: <linux-nvdimm@lists.01.org>

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Introduce a new iterator for_each_free_mem_pfn_range_in_zone.

This iterator will take care of making sure a given memory range provided
is in fact contained within a zone. It takes are of all the bounds checking
we were doing in deferred_grow_zone, and deferred_init_memmap. In addition
it should help to speed up the search a bit by iterating until the end of a
range is greater than the start of the zone pfn range, and will exit
completely if the start is beyond the end of the zone.

Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/memblock.h |   25 ++++++++++++++++++
 mm/memblock.c            |   64 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c          |   31 +++++++++-------------
 3 files changed, 101 insertions(+), 19 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 294d5d80e150..f8b78892b977 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -240,6 +240,31 @@ void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
 	     i >= 0; __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid))
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+void __next_mem_pfn_range_in_zone(u64 *idx, struct zone *zone,
+				  unsigned long *out_spfn,
+				  unsigned long *out_epfn);
+/**
+ * for_each_free_mem_range_in_zone - iterate through zone specific free
+ * memblock areas
+ * @i: u64 used as loop variable
+ * @zone: zone in which all of the memory blocks reside
+ * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ *
+ * Walks over free (memory && !reserved) areas of memblock in a specific
+ * zone. Available once memblock and an empty zone is initialized. The main
+ * assumption is that the zone start, end, and pgdat have been associated.
+ * This way we can use the zone to determine NUMA node, and if a given part
+ * of the memblock is valid for the zone.
+ */
+#define for_each_free_mem_pfn_range_in_zone(i, zone, p_start, p_end)	\
+	for (i = 0,							\
+	     __next_mem_pfn_range_in_zone(&i, zone, p_start, p_end);	\
+	     i != U64_MAX;					\
+	     __next_mem_pfn_range_in_zone(&i, zone, p_start, p_end))
+#endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
+
 /**
  * for_each_free_mem_range - iterate through free memblock areas
  * @i: u64 used as loop variable
diff --git a/mm/memblock.c b/mm/memblock.c
index e7665cf914b1..28fa8926d9f8 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1255,6 +1255,70 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
 	return 0;
 }
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+/**
+ * __next_mem_pfn_range_in_zone - iterator for for_each_*_range_in_zone()
+ *
+ * @idx: pointer to u64 loop variable
+ * @zone: zone in which all of the memory blocks reside
+ * @out_spfn: ptr to ulong for start pfn of the range, can be %NULL
+ * @out_epfn: ptr to ulong for end pfn of the range, can be %NULL
+ *
+ * This function is meant to be a zone/pfn specific wrapper for the
+ * for_each_mem_range type iterators. Specifically they are used in the
+ * deferred memory init routines and as such we were duplicating much of
+ * this logic throughout the code. So instead of having it in multiple
+ * locations it seemed like it would make more sense to centralize this to
+ * one new iterator that does everything they need.
+ */
+void __init_memblock
+__next_mem_pfn_range_in_zone(u64 *idx, struct zone *zone,
+			     unsigned long *out_spfn, unsigned long *out_epfn)
+{
+	int zone_nid = zone_to_nid(zone);
+	phys_addr_t spa, epa;
+	int nid;
+
+	__next_mem_range(idx, zone_nid, MEMBLOCK_NONE,
+			 &memblock.memory, &memblock.reserved,
+			 &spa, &epa, &nid);
+
+	while (*idx != U64_MAX) {
+		unsigned long epfn = PFN_DOWN(epa);
+		unsigned long spfn = PFN_UP(spa);
+
+		/*
+		 * Verify the end is at least past the start of the zone and
+		 * that we have at least one PFN to initialize.
+		 */
+		if (zone->zone_start_pfn < epfn && spfn < epfn) {
+			/* if we went too far just stop searching */
+			if (zone_end_pfn(zone) <= spfn) {
+				*idx = U64_MAX;
+				break;
+			}
+
+			if (out_spfn)
+				*out_spfn = max(zone->zone_start_pfn, spfn);
+			if (out_epfn)
+				*out_epfn = min(zone_end_pfn(zone), epfn);
+
+			return;
+		}
+
+		__next_mem_range(idx, zone_nid, MEMBLOCK_NONE,
+				 &memblock.memory, &memblock.reserved,
+				 &spa, &epa, &nid);
+	}
+
+	/* signal end of iteration */
+	if (out_spfn)
+		*out_spfn = ULONG_MAX;
+	if (out_epfn)
+		*out_epfn = 0;
+}
+
+#endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
 /**
  * memblock_alloc_range_nid - allocate boot memory block
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d2bca9803d2..61467e28c966 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1613,11 +1613,9 @@ static unsigned long  __init deferred_init_pages(struct zone *zone,
 static int __init deferred_init_memmap(void *data)
 {
 	pg_data_t *pgdat = data;
-	int nid = pgdat->node_id;
 	unsigned long start = jiffies;
 	unsigned long nr_pages = 0;
 	unsigned long spfn, epfn, first_init_pfn, flags;
-	phys_addr_t spa, epa;
 	int zid;
 	struct zone *zone;
 	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
@@ -1654,14 +1652,12 @@ static int __init deferred_init_memmap(void *data)
 	 * freeing pages we can access pages that are ahead (computing buddy
 	 * page in __free_one_page()).
 	 */
-	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
-		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
-		epfn = min_t(unsigned long, zone_end_pfn(zone), PFN_DOWN(epa));
+	for_each_free_mem_pfn_range_in_zone(i, zone, &spfn, &epfn) {
+		spfn = max_t(unsigned long, first_init_pfn, spfn);
 		nr_pages += deferred_init_pages(zone, spfn, epfn);
 	}
-	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
-		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
-		epfn = min_t(unsigned long, zone_end_pfn(zone), PFN_DOWN(epa));
+	for_each_free_mem_pfn_range_in_zone(i, zone, &spfn, &epfn) {
+		spfn = max_t(unsigned long, first_init_pfn, spfn);
 		deferred_free_pages(spfn, epfn);
 	}
 	pgdat_resize_unlock(pgdat, &flags);
@@ -1669,8 +1665,8 @@ static int __init deferred_init_memmap(void *data)
 	/* Sanity check that the next zone really is unpopulated */
 	WARN_ON(++zid < MAX_NR_ZONES && populated_zone(++zone));
 
-	pr_info("node %d initialised, %lu pages in %ums\n", nid, nr_pages,
-					jiffies_to_msecs(jiffies - start));
+	pr_info("node %d initialised, %lu pages in %ums\n",
+		pgdat->node_id,	nr_pages, jiffies_to_msecs(jiffies - start));
 
 	pgdat_init_report_one_done();
 	return 0;
@@ -1694,13 +1690,11 @@ static int __init deferred_init_memmap(void *data)
 static noinline bool __init
 deferred_grow_zone(struct zone *zone, unsigned int order)
 {
-	int nid = zone_to_nid(zone);
-	pg_data_t *pgdat = NODE_DATA(nid);
 	unsigned long nr_pages_needed = ALIGN(1 << order, PAGES_PER_SECTION);
+	pg_data_t *pgdat = zone->zone_pgdat;
 	unsigned long nr_pages = 0;
 	unsigned long first_init_pfn, spfn, epfn, t, flags;
 	unsigned long first_deferred_pfn = pgdat->first_deferred_pfn;
-	phys_addr_t spa, epa;
 	u64 i;
 
 	/* Only the last zone may have deferred pages */
@@ -1736,9 +1730,8 @@ static int __init deferred_init_memmap(void *data)
 		return false;
 	}
 
-	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
-		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
-		epfn = min_t(unsigned long, zone_end_pfn(zone), PFN_DOWN(epa));
+	for_each_free_mem_pfn_range_in_zone(i, zone, &spfn, &epfn) {
+		spfn = max_t(unsigned long, first_init_pfn, spfn);
 
 		while (spfn < epfn && nr_pages < nr_pages_needed) {
 			t = ALIGN(spfn + PAGES_PER_SECTION, PAGES_PER_SECTION);
@@ -1752,9 +1745,9 @@ static int __init deferred_init_memmap(void *data)
 			break;
 	}
 
-	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
-		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
-		epfn = min_t(unsigned long, first_deferred_pfn, PFN_DOWN(epa));
+	for_each_free_mem_pfn_range_in_zone(i, zone, &spfn, &epfn) {
+		spfn = max_t(unsigned long, first_init_pfn, spfn);
+		epfn = min_t(unsigned long, first_deferred_pfn, epfn);
 		deferred_free_pages(spfn, epfn);
 
 		if (first_deferred_pfn == epfn)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
