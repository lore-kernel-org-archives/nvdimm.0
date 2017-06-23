Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 39B0221BBC421
 for <linux-nvdimm@lists.01.org>; Fri, 23 Jun 2017 00:13:27 -0700 (PDT)
From: "Huang, Ying" <ying.huang@intel.com>
Subject: [PATCH -mm -v2 01/12] mm, THP,
 swap: Support to clear swap cache flag for THP swapped out
Date: Fri, 23 Jun 2017 15:12:52 +0800
Message-Id: <20170623071303.13469-2-ying.huang@intel.com>
In-Reply-To: <20170623071303.13469-1-ying.huang@intel.com>
References: <20170623071303.13469-1-ying.huang@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, linux-nvdimm@lists.01.org, Huang Ying <ying.huang@intel.com>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, Shaohua Li <shli@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Huang Ying <ying.huang@intel.com>

Previously, swapcache_free_cluster() is used only in the error path of
shrink_page_list() to free the swap cluster just allocated if the
THP (Transparent Huge Page) is failed to be split.  In this patch, it
is enhanced to clear the swap cache flag (SWAP_HAS_CACHE) for the swap
cluster that holds the contents of THP swapped out.

This will be used in delaying splitting THP after swapping out
support.  Because there is no THP swapping in as a whole support yet,
after clearing the swap cache flag, the swap cluster backing the THP
swapped out will be split.  So that the swap slots in the swap cluster
can be swapped in as normal pages later.

Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/swapfile.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6ba4aab2db0b..c32e9b23d642 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1168,22 +1168,40 @@ static void swapcache_free_cluster(swp_entry_t entry)
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
 	unsigned char *map;
-	unsigned int i;
+	unsigned int i, free_entries = 0;
+	unsigned char val;
 
-	si = swap_info_get(entry);
+	si = _swap_info_get(entry);
 	if (!si)
 		return;
 
 	ci = lock_cluster(si, offset);
 	map = si->swap_map + offset;
 	for (i = 0; i < SWAPFILE_CLUSTER; i++) {
-		VM_BUG_ON(map[i] != SWAP_HAS_CACHE);
-		map[i] = 0;
+		val = map[i];
+		VM_BUG_ON(!(val & SWAP_HAS_CACHE));
+		if (val == SWAP_HAS_CACHE)
+			free_entries++;
+	}
+	if (!free_entries) {
+		for (i = 0; i < SWAPFILE_CLUSTER; i++)
+			map[i] &= ~SWAP_HAS_CACHE;
 	}
 	unlock_cluster(ci);
-	mem_cgroup_uncharge_swap(entry, SWAPFILE_CLUSTER);
-	swap_free_cluster(si, idx);
-	spin_unlock(&si->lock);
+	if (free_entries == SWAPFILE_CLUSTER) {
+		spin_lock(&si->lock);
+		ci = lock_cluster(si, offset);
+		memset(map, 0, SWAPFILE_CLUSTER);
+		unlock_cluster(ci);
+		mem_cgroup_uncharge_swap(entry, SWAPFILE_CLUSTER);
+		swap_free_cluster(si, idx);
+		spin_unlock(&si->lock);
+	} else if (free_entries) {
+		for (i = 0; i < SWAPFILE_CLUSTER; i++, entry.val++) {
+			if (!__swap_entry_free(si, entry, SWAP_HAS_CACHE))
+				free_swap_slot(entry);
+		}
+	}
 }
 #else
 static inline void swapcache_free_cluster(swp_entry_t entry)
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
