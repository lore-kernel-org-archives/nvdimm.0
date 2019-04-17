Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4FBFC2120ADDF
 for <linux-nvdimm@lists.01.org>; Wed, 17 Apr 2019 11:53:18 -0700 (PDT)
Subject: [PATCH v6 07/12] mm: Kill is_dev_zone() helper
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Apr 2019 11:39:32 -0700
Message-ID: <155552637207.2015392.16917498971420465931.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: mhocko@suse.com, linux-nvdimm@lists.01.org, david@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

Given there are no more usages of is_dev_zone() outside of 'ifdef
CONFIG_ZONE_DEVICE' protection, kill off the compilation helper.

Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/mmzone.h |   12 ------------
 mm/page_alloc.c        |    2 +-
 2 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index b13f0cddf75e..3237c5e456df 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -855,18 +855,6 @@ static inline int local_memory_node(int node_id) { return node_id; };
  */
 #define zone_idx(zone)		((zone) - (zone)->zone_pgdat->node_zones)
 
-#ifdef CONFIG_ZONE_DEVICE
-static inline bool is_dev_zone(const struct zone *zone)
-{
-	return zone_idx(zone) == ZONE_DEVICE;
-}
-#else
-static inline bool is_dev_zone(const struct zone *zone)
-{
-	return false;
-}
-#endif
-
 /*
  * Returns true if a zone has pages managed by the buddy allocator.
  * All the reclaim decisions have to use this function rather than
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c9ad28a78018..fd455bd742d5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5844,7 +5844,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
 
-	if (WARN_ON_ONCE(!pgmap || !is_dev_zone(zone)))
+	if (WARN_ON_ONCE(!pgmap || zone_idx(zone) != ZONE_DEVICE))
 		return;
 
 	/*

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
