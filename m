Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com
 [IPv6:2607:f8b0:4864:20::442])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A81C2211EE6B2
 for <linux-nvdimm@lists.01.org>; Fri,  5 Apr 2019 15:12:33 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id t21so1684065pfh.2
 for <linux-nvdimm@lists.01.org>; Fri, 05 Apr 2019 15:12:33 -0700 (PDT)
Subject: [mm PATCH v7 4/4] mm: Initialize MAX_ORDER_NR_PAGES at a time
 instead of doing larger sections
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 05 Apr 2019 15:12:32 -0700
Message-ID: <20190405221231.12227.85836.stgit@localhost.localdomain>
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

Add yet another iterator, for_each_free_mem_range_in_zone_from, and then
use it to support initializing and freeing pages in groups no larger than
MAX_ORDER_NR_PAGES. By doing this we can greatly improve the cache locality
of the pages while we do several loops over them in the init and freeing
process.

We are able to tighten the loops further as a result of the "from" iterator
as we can perform the initial checks for first_init_pfn in our first call
to the iterator, and continue without the need for those checks via the
"from" iterator. I have added this functionality in the function called
deferred_init_mem_pfn_range_in_zone that primes the iterator and causes us
to exit if we encounter any failure.

On my x86_64 test system with 384GB of memory per node I saw a reduction in
initialization time from 1.85s to 1.38s as a result of this patch.

Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/memblock.h |   16 +++++
 mm/page_alloc.c          |  162 ++++++++++++++++++++++++++++++++++------------
 2 files changed, 137 insertions(+), 41 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index f8b78892b977..47e3c0612592 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -263,6 +263,22 @@ void __next_mem_pfn_range_in_zone(u64 *idx, struct zone *zone,
 	     __next_mem_pfn_range_in_zone(&i, zone, p_start, p_end);	\
 	     i != U64_MAX;					\
 	     __next_mem_pfn_range_in_zone(&i, zone, p_start, p_end))
+
+/**
+ * for_each_free_mem_range_in_zone_from - iterate through zone specific
+ * free memblock areas from a given point
+ * @i: u64 used as loop variable
+ * @zone: zone in which all of the memory blocks reside
+ * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ *
+ * Walks over free (memory && !reserved) areas of memblock in a specific
+ * zone, continuing from current position. Available as soon as memblock is
+ * initialized.
+ */
+#define for_each_free_mem_pfn_range_in_zone_from(i, zone, p_start, p_end) \
+	for (; i != U64_MAX;					  \
+	     __next_mem_pfn_range_in_zone(&i, zone, p_start, p_end))
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
 /**
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 61467e28c966..06fbec9edf84 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1609,16 +1609,100 @@ static unsigned long  __init deferred_init_pages(struct zone *zone,
 	return (nr_pages);
 }
 
+/*
+ * This function is meant to pre-load the iterator for the zone init.
+ * Specifically it walks through the ranges until we are caught up to the
+ * first_init_pfn value and exits there. If we never encounter the value we
+ * return false indicating there are no valid ranges left.
+ */
+static bool __init
+deferred_init_mem_pfn_range_in_zone(u64 *i, struct zone *zone,
+				    unsigned long *spfn, unsigned long *epfn,
+				    unsigned long first_init_pfn)
+{
+	u64 j;
+
+	/*
+	 * Start out by walking through the ranges in this zone that have
+	 * already been initialized. We don't need to do anything with them
+	 * so we just need to flush them out of the system.
+	 */
+	for_each_free_mem_pfn_range_in_zone(j, zone, spfn, epfn) {
+		if (*epfn <= first_init_pfn)
+			continue;
+		if (*spfn < first_init_pfn)
+			*spfn = first_init_pfn;
+		*i = j;
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * Initialize and free pages. We do it in two loops: first we initialize
+ * struct page, then free to buddy allocator, because while we are
+ * freeing pages we can access pages that are ahead (computing buddy
+ * page in __free_one_page()).
+ *
+ * In order to try and keep some memory in the cache we have the loop
+ * broken along max page order boundaries. This way we will not cause
+ * any issues with the buddy page computation.
+ */
+static unsigned long __init
+deferred_init_maxorder(u64 *i, struct zone *zone, unsigned long *start_pfn,
+		       unsigned long *end_pfn)
+{
+	unsigned long mo_pfn = ALIGN(*start_pfn + 1, MAX_ORDER_NR_PAGES);
+	unsigned long spfn = *start_pfn, epfn = *end_pfn;
+	unsigned long nr_pages = 0;
+	u64 j = *i;
+
+	/* First we loop through and initialize the page values */
+	for_each_free_mem_pfn_range_in_zone_from(j, zone, start_pfn, end_pfn) {
+		unsigned long t;
+
+		if (mo_pfn <= *start_pfn)
+			break;
+
+		t = min(mo_pfn, *end_pfn);
+		nr_pages += deferred_init_pages(zone, *start_pfn, t);
+
+		if (mo_pfn < *end_pfn) {
+			*start_pfn = mo_pfn;
+			break;
+		}
+	}
+
+	/* Reset values and now loop through freeing pages as needed */
+	swap(j, *i);
+
+	for_each_free_mem_pfn_range_in_zone_from(j, zone, &spfn, &epfn) {
+		unsigned long t;
+
+		if (mo_pfn <= spfn)
+			break;
+
+		t = min(mo_pfn, epfn);
+		deferred_free_pages(spfn, t);
+
+		if (mo_pfn <= epfn)
+			break;
+	}
+
+	return nr_pages;
+}
+
 /* Initialise remaining memory on a node */
 static int __init deferred_init_memmap(void *data)
 {
 	pg_data_t *pgdat = data;
+	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
+	unsigned long spfn = 0, epfn = 0, nr_pages = 0;
+	unsigned long first_init_pfn, flags;
 	unsigned long start = jiffies;
-	unsigned long nr_pages = 0;
-	unsigned long spfn, epfn, first_init_pfn, flags;
-	int zid;
 	struct zone *zone;
-	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
+	int zid;
 	u64 i;
 
 	/* Bind memory initialisation thread to a local node if possible */
@@ -1644,22 +1728,20 @@ static int __init deferred_init_memmap(void *data)
 		if (first_init_pfn < zone_end_pfn(zone))
 			break;
 	}
-	first_init_pfn = max(zone->zone_start_pfn, first_init_pfn);
+
+	/* If the zone is empty somebody else may have cleared out the zone */
+	if (!deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
+						 first_init_pfn))
+		goto zone_empty;
 
 	/*
-	 * Initialize and free pages. We do it in two loops: first we initialize
-	 * struct page, than free to buddy allocator, because while we are
-	 * freeing pages we can access pages that are ahead (computing buddy
-	 * page in __free_one_page()).
+	 * Initialize and free pages in MAX_ORDER sized increments so
+	 * that we can avoid introducing any issues with the buddy
+	 * allocator.
 	 */
-	for_each_free_mem_pfn_range_in_zone(i, zone, &spfn, &epfn) {
-		spfn = max_t(unsigned long, first_init_pfn, spfn);
-		nr_pages += deferred_init_pages(zone, spfn, epfn);
-	}
-	for_each_free_mem_pfn_range_in_zone(i, zone, &spfn, &epfn) {
-		spfn = max_t(unsigned long, first_init_pfn, spfn);
-		deferred_free_pages(spfn, epfn);
-	}
+	while (spfn < epfn)
+		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
+zone_empty:
 	pgdat_resize_unlock(pgdat, &flags);
 
 	/* Sanity check that the next zone really is unpopulated */
@@ -1692,9 +1774,9 @@ static int __init deferred_init_memmap(void *data)
 {
 	unsigned long nr_pages_needed = ALIGN(1 << order, PAGES_PER_SECTION);
 	pg_data_t *pgdat = zone->zone_pgdat;
-	unsigned long nr_pages = 0;
-	unsigned long first_init_pfn, spfn, epfn, t, flags;
 	unsigned long first_deferred_pfn = pgdat->first_deferred_pfn;
+	unsigned long spfn, epfn, flags;
+	unsigned long nr_pages = 0;
 	u64 i;
 
 	/* Only the last zone may have deferred pages */
@@ -1723,37 +1805,35 @@ static int __init deferred_init_memmap(void *data)
 		return true;
 	}
 
-	first_init_pfn = max(zone->zone_start_pfn, first_deferred_pfn);
-
-	if (first_init_pfn >= pgdat_end_pfn(pgdat)) {
+	/* If the zone is empty somebody else may have cleared out the zone */
+	if (!deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
+						 first_deferred_pfn)) {
+		pgdat->first_deferred_pfn = ULONG_MAX;
 		pgdat_resize_unlock(pgdat, &flags);
-		return false;
+		return true;
 	}
 
-	for_each_free_mem_pfn_range_in_zone(i, zone, &spfn, &epfn) {
-		spfn = max_t(unsigned long, first_init_pfn, spfn);
+	/*
+	 * Initialize and free pages in MAX_ORDER sized increments so
+	 * that we can avoid introducing any issues with the buddy
+	 * allocator.
+	 */
+	while (spfn < epfn) {
+		/* update our first deferred PFN for this section */
+		first_deferred_pfn = spfn;
+
+		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
 
-		while (spfn < epfn && nr_pages < nr_pages_needed) {
-			t = ALIGN(spfn + PAGES_PER_SECTION, PAGES_PER_SECTION);
-			first_deferred_pfn = min(t, epfn);
-			nr_pages += deferred_init_pages(zone, spfn,
-							first_deferred_pfn);
-			spfn = first_deferred_pfn;
-		}
+		/* We should only stop along section boundaries */
+		if ((first_deferred_pfn ^ spfn) < PAGES_PER_SECTION)
+			continue;
 
+		/* If our quota has been met we can stop here */
 		if (nr_pages >= nr_pages_needed)
 			break;
 	}
 
-	for_each_free_mem_pfn_range_in_zone(i, zone, &spfn, &epfn) {
-		spfn = max_t(unsigned long, first_init_pfn, spfn);
-		epfn = min_t(unsigned long, first_deferred_pfn, epfn);
-		deferred_free_pages(spfn, epfn);
-
-		if (first_deferred_pfn == epfn)
-			break;
-	}
-	pgdat->first_deferred_pfn = first_deferred_pfn;
+	pgdat->first_deferred_pfn = spfn;
 	pgdat_resize_unlock(pgdat, &flags);
 
 	return nr_pages > 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
