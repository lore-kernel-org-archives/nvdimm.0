Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6240E80401
 for <linux-nvdimm@lists.01.org>; Wed, 15 Mar 2017 23:12:04 -0700 (PDT)
Subject: [PATCH v4 01/13] mm: fix type width of section to/from pfn
 conversion macros
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 Mar 2017 23:06:53 -0700
Message-ID: <148964441304.19438.7881390961489435379.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148964440651.19438.2288075389153762985.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148964440651.19438.2288075389153762985.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, Mel Gorman <mgorman@techsingularity.net>, linux-kernel@vger.kernel.org, Stephen Bates <stephen.bates@microsemi.com>, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

section_nr_to_pfn() will silently accept an argument that is too small
to contain a pfn. Cast the argument to an unsigned long, similar to
PFN_PHYS(). Fix up pfn_to_section_nr() in the same way.

This was discovered in __add_pages() when converting it to use an
signed integer for the loop variable.

Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Bates <stephen.bates@microsemi.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/mmzone.h |    4 ++--
 mm/memory_hotplug.c    |    4 +---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 8e02b3750fe0..ffa9503d5be5 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1064,8 +1064,8 @@ static inline unsigned long early_pfn_to_nid(unsigned long pfn)
 #error Allocator MAX_ORDER exceeds SECTION_SIZE
 #endif
 
-#define pfn_to_section_nr(pfn) ((pfn) >> PFN_SECTION_SHIFT)
-#define section_nr_to_pfn(sec) ((sec) << PFN_SECTION_SHIFT)
+#define pfn_to_section_nr(pfn) ((unsigned long)(pfn) >> PFN_SECTION_SHIFT)
+#define section_nr_to_pfn(sec) ((unsigned long)(sec) << PFN_SECTION_SHIFT)
 
 #define SECTION_ALIGN_UP(pfn)	(((pfn) + PAGES_PER_SECTION - 1) & PAGE_SECTION_MASK)
 #define SECTION_ALIGN_DOWN(pfn)	((pfn) & PAGE_SECTION_MASK)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 6fa7208bcd56..e1751ca002fa 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -536,9 +536,7 @@ static int __meminit __add_section(int nid, struct zone *zone,
 int __ref __add_pages(int nid, struct zone *zone, unsigned long phys_start_pfn,
 			unsigned long nr_pages)
 {
-	unsigned long i;
-	int err = 0;
-	int start_sec, end_sec;
+	int err = 0, i, start_sec, end_sec;
 	struct vmem_altmap *altmap;
 
 	clear_zone_contiguous(zone);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
