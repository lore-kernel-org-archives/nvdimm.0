Return-Path: <owner-linux-mm@kvack.org>
From: Keith Busch <keith.busch@intel.com>
Subject: [PATCH 4/5] mm: Consider anonymous pages without swap
Date: Thu, 21 Mar 2019 14:01:56 -0600
Message-Id: <20190321200157.29678-5-keith.busch@intel.com>
In-Reply-To: <20190321200157.29678-1-keith.busch@intel.com>
References: <20190321200157.29678-1-keith.busch@intel.com>
Sender: owner-linux-mm@kvack.org
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org
Cc: Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Age and reclaim anonymous pages from nodes that have an online migration node even
if swap is not enabled.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 include/linux/swap.h | 20 ++++++++++++++++++++
 mm/vmscan.c          | 10 +++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4bfb5c4ac108..91b405a3b44f 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -680,5 +680,25 @@ static inline bool mem_cgroup_swap_full(struct page *page)
 }
 #endif
 
+static inline bool reclaim_anon_pages(struct mem_cgroup *memcg,
+				      int node_id)
+{
+	/* Always age anon pages when we have swap */
+	if (memcg == NULL) {
+		if (get_nr_swap_pages() > 0)
+			return true;
+	} else {
+		if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
+			return true;
+	}
+
+	/* Also age anon pages if we can auto-migrate them */
+	if (next_migration_node(node_id) >= 0)
+		return true;
+
+	/* No way to reclaim anon pages */
+	return false;
+}
+
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0a95804e946a..226c4c838947 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -327,7 +327,7 @@ unsigned long zone_reclaimable_pages(struct zone *zone)
 
 	nr = zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_FILE) +
 		zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_FILE);
-	if (get_nr_swap_pages() > 0)
+	if (reclaim_anon_pages(NULL, zone_to_nid(zone)))
 		nr += zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_ANON) +
 			zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_ANON);
 
@@ -2206,7 +2206,7 @@ static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
 	 * If we don't have swap space, anonymous page deactivation
 	 * is pointless.
 	 */
-	if (!file && !total_swap_pages)
+	if (!file && !reclaim_anon_pages(NULL, pgdat->node_id))
 		return false;
 
 	inactive = lruvec_lru_size(lruvec, inactive_lru, sc->reclaim_idx);
@@ -2287,7 +2287,7 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
 	enum lru_list lru;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || mem_cgroup_get_nr_swap_pages(memcg) <= 0) {
+	if (!sc->may_swap || !reclaim_anon_pages(memcg, pgdat->node_id)) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
@@ -2650,7 +2650,7 @@ static inline bool should_continue_reclaim(struct pglist_data *pgdat,
 	 */
 	pages_for_compaction = compact_gap(sc->order);
 	inactive_lru_pages = node_page_state(pgdat, NR_INACTIVE_FILE);
-	if (get_nr_swap_pages() > 0)
+	if (!reclaim_anon_pages(NULL, pgdat->node_id))
 		inactive_lru_pages += node_page_state(pgdat, NR_INACTIVE_ANON);
 	if (sc->nr_reclaimed < pages_for_compaction &&
 			inactive_lru_pages > pages_for_compaction)
@@ -3347,7 +3347,7 @@ static void age_active_anon(struct pglist_data *pgdat,
 {
 	struct mem_cgroup *memcg;
 
-	if (!total_swap_pages)
+	if (!reclaim_anon_pages(NULL, pgdat->node_id))
 		return;
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
-- 
2.14.4
