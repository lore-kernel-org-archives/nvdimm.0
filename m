Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com
 [IPv6:2607:f8b0:4864:20::443])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 53DED211EE6B1
 for <linux-nvdimm@lists.01.org>; Fri,  5 Apr 2019 15:12:21 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 9so3985052pfj.13
 for <linux-nvdimm@lists.01.org>; Fri, 05 Apr 2019 15:12:21 -0700 (PDT)
Subject: [mm PATCH v7 2/4] mm: Drop meminit_pfn_in_nid as it is redundant
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 05 Apr 2019 15:12:19 -0700
Message-ID: <20190405221219.12227.93957.stgit@localhost.localdomain>
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

As best as I can tell the meminit_pfn_in_nid call is completely redundant.
The deferred memory initialization is already making use of
for_each_free_mem_range which in turn will call into __next_mem_range which
will only return a memory range if it matches the node ID provided assuming
it is not NUMA_NO_NODE.

I am operating on the assumption that there are no zones or pgdata_t
structures that have a NUMA node of NUMA_NO_NODE associated with them. If
that is the case then __next_mem_range will never return a memory range
that doesn't match the zone's node ID and as such the check is redundant.

So one piece I would like to verify on this is if this works for ia64.
Technically it was using a different approach to get the node ID, but it
seems to have the node ID also encoded into the memblock. So I am
assuming this is okay, but would like to get confirmation on that.

On my x86_64 test system with 384GB of memory per node I saw a reduction in
initialization time from 2.80s to 1.85s as a result of this patch.

Reviewed-by: Pavel Tatashin <pavel.tatashin@microsoft.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 mm/page_alloc.c |   51 ++++++++++++++-------------------------------------
 1 file changed, 14 insertions(+), 37 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0c53807a2943..2d2bca9803d2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1398,36 +1398,22 @@ int __meminit early_pfn_to_nid(unsigned long pfn)
 #endif
 
 #ifdef CONFIG_NODES_SPAN_OTHER_NODES
-static inline bool __meminit __maybe_unused
-meminit_pfn_in_nid(unsigned long pfn, int node,
-		   struct mminit_pfnnid_cache *state)
+/* Only safe to use early in boot when initialisation is single-threaded */
+static inline bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
 {
 	int nid;
 
-	nid = __early_pfn_to_nid(pfn, state);
+	nid = __early_pfn_to_nid(pfn, &early_pfnnid_cache);
 	if (nid >= 0 && nid != node)
 		return false;
 	return true;
 }
 
-/* Only safe to use early in boot when initialisation is single-threaded */
-static inline bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
-{
-	return meminit_pfn_in_nid(pfn, node, &early_pfnnid_cache);
-}
-
 #else
-
 static inline bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
 {
 	return true;
 }
-static inline bool __meminit  __maybe_unused
-meminit_pfn_in_nid(unsigned long pfn, int node,
-		   struct mminit_pfnnid_cache *state)
-{
-	return true;
-}
 #endif
 
 
@@ -1556,21 +1542,13 @@ static inline void __init pgdat_init_report_one_done(void)
  *
  * Then, we check if a current large page is valid by only checking the validity
  * of the head pfn.
- *
- * Finally, meminit_pfn_in_nid is checked on systems where pfns can interleave
- * within a node: a pfn is between start and end of a node, but does not belong
- * to this memory node.
  */
-static inline bool __init
-deferred_pfn_valid(int nid, unsigned long pfn,
-		   struct mminit_pfnnid_cache *nid_init_state)
+static inline bool __init deferred_pfn_valid(unsigned long pfn)
 {
 	if (!pfn_valid_within(pfn))
 		return false;
 	if (!(pfn & (pageblock_nr_pages - 1)) && !pfn_valid(pfn))
 		return false;
-	if (!meminit_pfn_in_nid(pfn, nid, nid_init_state))
-		return false;
 	return true;
 }
 
@@ -1578,15 +1556,14 @@ static inline void __init pgdat_init_report_one_done(void)
  * Free pages to buddy allocator. Try to free aligned pages in
  * pageblock_nr_pages sizes.
  */
-static void __init deferred_free_pages(int nid, int zid, unsigned long pfn,
+static void __init deferred_free_pages(unsigned long pfn,
 				       unsigned long end_pfn)
 {
-	struct mminit_pfnnid_cache nid_init_state = { };
 	unsigned long nr_pgmask = pageblock_nr_pages - 1;
 	unsigned long nr_free = 0;
 
 	for (; pfn < end_pfn; pfn++) {
-		if (!deferred_pfn_valid(nid, pfn, &nid_init_state)) {
+		if (!deferred_pfn_valid(pfn)) {
 			deferred_free_range(pfn - nr_free, nr_free);
 			nr_free = 0;
 		} else if (!(pfn & nr_pgmask)) {
@@ -1606,17 +1583,18 @@ static void __init deferred_free_pages(int nid, int zid, unsigned long pfn,
  * by performing it only once every pageblock_nr_pages.
  * Return number of pages initialized.
  */
-static unsigned long  __init deferred_init_pages(int nid, int zid,
+static unsigned long  __init deferred_init_pages(struct zone *zone,
 						 unsigned long pfn,
 						 unsigned long end_pfn)
 {
-	struct mminit_pfnnid_cache nid_init_state = { };
 	unsigned long nr_pgmask = pageblock_nr_pages - 1;
+	int nid = zone_to_nid(zone);
 	unsigned long nr_pages = 0;
+	int zid = zone_idx(zone);
 	struct page *page = NULL;
 
 	for (; pfn < end_pfn; pfn++) {
-		if (!deferred_pfn_valid(nid, pfn, &nid_init_state)) {
+		if (!deferred_pfn_valid(pfn)) {
 			page = NULL;
 			continue;
 		} else if (!page || !(pfn & nr_pgmask)) {
@@ -1679,12 +1657,12 @@ static int __init deferred_init_memmap(void *data)
 	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
 		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
 		epfn = min_t(unsigned long, zone_end_pfn(zone), PFN_DOWN(epa));
-		nr_pages += deferred_init_pages(nid, zid, spfn, epfn);
+		nr_pages += deferred_init_pages(zone, spfn, epfn);
 	}
 	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
 		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
 		epfn = min_t(unsigned long, zone_end_pfn(zone), PFN_DOWN(epa));
-		deferred_free_pages(nid, zid, spfn, epfn);
+		deferred_free_pages(spfn, epfn);
 	}
 	pgdat_resize_unlock(pgdat, &flags);
 
@@ -1716,7 +1694,6 @@ static int __init deferred_init_memmap(void *data)
 static noinline bool __init
 deferred_grow_zone(struct zone *zone, unsigned int order)
 {
-	int zid = zone_idx(zone);
 	int nid = zone_to_nid(zone);
 	pg_data_t *pgdat = NODE_DATA(nid);
 	unsigned long nr_pages_needed = ALIGN(1 << order, PAGES_PER_SECTION);
@@ -1766,7 +1743,7 @@ static int __init deferred_init_memmap(void *data)
 		while (spfn < epfn && nr_pages < nr_pages_needed) {
 			t = ALIGN(spfn + PAGES_PER_SECTION, PAGES_PER_SECTION);
 			first_deferred_pfn = min(t, epfn);
-			nr_pages += deferred_init_pages(nid, zid, spfn,
+			nr_pages += deferred_init_pages(zone, spfn,
 							first_deferred_pfn);
 			spfn = first_deferred_pfn;
 		}
@@ -1778,7 +1755,7 @@ static int __init deferred_init_memmap(void *data)
 	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
 		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
 		epfn = min_t(unsigned long, first_deferred_pfn, PFN_DOWN(epa));
-		deferred_free_pages(nid, zid, spfn, epfn);
+		deferred_free_pages(spfn, epfn);
 
 		if (first_deferred_pfn == epfn)
 			break;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
