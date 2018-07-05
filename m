Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 203FE210E38B1
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 23:59:30 -0700 (PDT)
Subject: [PATCH 04/13] mm: Multithread ZONE_DEVICE initialization
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Jul 2018 23:49:23 -0700
Message-ID: <153077336359.40830.13007326947037437465.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153077334130.40830.2714147692560185329.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153077334130.40830.2714147692560185329.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, hch@lst.de, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On large / multi-socket persistent memory systems it can potentially
take minutes to initialize the memmap. Even though such systems have
multiple persistent memory namespaces that are registered
asynchronously, they serialize on the mem_hotplug_begin() lock.

The method for hiding memmap initialization in the typical memory case
can not be directly reused for persistent memory. In the typical /
volatile memory case pages are background freed to the memory allocator
as they become initialized. For persistent memory the aim is to push
everything to the background, but since it is dax mapped there is no way
to redirect applications to limit their usage to the initialized set.
I.e. any address may be directly accessed at any time.

The bulk of the work is memmap_init_zone(). Splitting the work into
threads yields a 1.5x to 2x performance in the time to initialize a
128GB namespace. However, the work is still serialized when there are
multiple namespaces and the work is ultimately limited by memory-media
write bandwidth. So, this commie is only a preparation step towards
ultimately moving all memmap initialization completely into the
background.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/memmap_async.h |   17 +++++
 mm/page_alloc.c              |  145 ++++++++++++++++++++++++++++--------------
 2 files changed, 113 insertions(+), 49 deletions(-)

diff --git a/include/linux/memmap_async.h b/include/linux/memmap_async.h
index 11aa9f3a523e..d2011681a910 100644
--- a/include/linux/memmap_async.h
+++ b/include/linux/memmap_async.h
@@ -2,12 +2,24 @@
 #ifndef __LINUX_MEMMAP_ASYNC_H
 #define __LINUX_MEMMAP_ASYNC_H
 #include <linux/async.h>
+#include <linux/ioport.h>
 
+struct dev_pagemap;
 struct vmem_altmap;
 
+/*
+ * Regardless of how many threads we request here the workqueue core may
+ * limit based on the amount of other concurrent 'async' work in the
+ * system, see WQ_MAX_ACTIVE
+ */
+#define NR_MEMMAP_THREADS 16
+
 struct memmap_init_env {
 	struct vmem_altmap *altmap;
+	struct dev_pagemap *pgmap;
 	bool want_memblock;
+	unsigned long zone;
+	int context;
 	int nid;
 };
 
@@ -19,6 +31,11 @@ struct memmap_init_memmap {
 	int result;
 };
 
+struct memmap_init_pages {
+	struct resource res;
+	struct memmap_init_env *env;
+};
+
 struct memmap_async_state {
 	struct memmap_init_env env;
 	struct memmap_init_memmap memmap;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fb45cfeb4a50..6d0ed17cf305 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -38,6 +38,7 @@
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/memory_hotplug.h>
+#include <linux/memmap_async.h>
 #include <linux/nodemask.h>
 #include <linux/vmalloc.h>
 #include <linux/vmstat.h>
@@ -5455,6 +5456,68 @@ void __ref build_all_zonelists(pg_data_t *pgdat)
 
 ASYNC_DOMAIN_EXCLUSIVE(memmap_init_domain);
 
+static void __meminit memmap_init_one(unsigned long pfn, unsigned long zone,
+		int nid, enum memmap_context context, struct dev_pagemap *pgmap)
+{
+	struct page *page = pfn_to_page(pfn);
+
+	__init_single_page(page, pfn, zone, nid);
+	if (context == MEMMAP_HOTPLUG)
+		SetPageReserved(page);
+
+	/*
+	 * Mark the block movable so that blocks are reserved for
+	 * movable at startup. This will force kernel allocations to
+	 * reserve their blocks rather than leaking throughout the
+	 * address space during boot when many long-lived kernel
+	 * allocations are made.
+	 *
+	 * bitmap is created for zone's valid pfn range. but memmap can
+	 * be created for invalid pages (for alignment) check here not
+	 * to call set_pageblock_migratetype() against pfn out of zone.
+	 *
+	 * Please note that MEMMAP_HOTPLUG path doesn't clear memmap
+	 * because this is done early in sparse_add_one_section
+	 */
+	if (!(pfn & (pageblock_nr_pages - 1))) {
+		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+		cond_resched();
+	}
+
+	if (is_zone_device_page(page)) {
+		struct vmem_altmap *altmap = &pgmap->altmap;
+
+		if (WARN_ON_ONCE(!pgmap))
+			return;
+
+		/* skip invalid device pages */
+		if (pgmap->altmap_valid && (pfn < (altmap->base_pfn
+						+ vmem_altmap_offset(altmap))))
+			return;
+		/*
+		 * ZONE_DEVICE pages union ->lru with a ->pgmap back
+		 * pointer.  It is a bug if a ZONE_DEVICE page is ever
+		 * freed or placed on a driver-private list.  Seed the
+		 * storage with poison.
+		 */
+		page->lru.prev = LIST_POISON2;
+		page->pgmap = pgmap;
+		percpu_ref_get(pgmap->ref);
+	}
+}
+
+static void __ref memmap_init_async(void *data, async_cookie_t cookie)
+{
+	struct memmap_init_pages *args = data;
+	struct memmap_init_env *env = args->env;
+	struct resource *res = &args->res;
+	unsigned long pfn;
+
+	for (pfn = PHYS_PFN(res->start); pfn < PHYS_PFN(res->end+1); pfn++)
+		memmap_init_one(pfn, env->zone, env->nid, env->context,
+				env->pgmap);
+}
+
 /*
  * Initially all pages are reserved - free ones are freed
  * up by free_all_bootmem() once the early boot process is
@@ -5469,7 +5532,6 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 	struct vmem_altmap *altmap = NULL;
 	unsigned long pfn;
 	unsigned long nr_initialised = 0;
-	struct page *page;
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	struct memblock_region *r = NULL, *tmp;
 #endif
@@ -5486,14 +5548,43 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 	if (altmap && start_pfn == altmap->base_pfn)
 		start_pfn += altmap->reserve;
 
-	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+	if (context != MEMMAP_EARLY) {
 		/*
 		 * There can be holes in boot-time mem_map[]s handed to this
 		 * function.  They do not exist on hotplugged memory.
 		 */
-		if (context != MEMMAP_EARLY)
-			goto not_early;
+		ASYNC_DOMAIN_EXCLUSIVE(local);
+		struct memmap_init_pages args[NR_MEMMAP_THREADS];
+		struct memmap_init_env env = {
+			.nid = nid,
+			.zone = zone,
+			.pgmap = pgmap,
+			.context = context,
+		};
+		unsigned long step, rem;
+		int i;
+
+		size = end_pfn - start_pfn;
+		step = size / NR_MEMMAP_THREADS;
+		rem = size % NR_MEMMAP_THREADS;
+		for (i = 0; i < NR_MEMMAP_THREADS; i++) {
+			struct memmap_init_pages *t = &args[i];
+
+			t->env = &env;
+			t->res.start = PFN_PHYS(start_pfn);
+			t->res.end = PFN_PHYS(start_pfn + step) - 1;
+			if (i == NR_MEMMAP_THREADS-1)
+				t->res.end += PFN_PHYS(rem);
+
+			async_schedule_domain(memmap_init_async, t, &local);
+
+			start_pfn += step;
+		}
+		async_synchronize_full_domain(&local);
+		return;
+	}
 
+	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		if (!early_pfn_valid(pfn))
 			continue;
 		if (!early_pfn_in_nid(pfn, nid))
@@ -5522,51 +5613,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 			}
 		}
 #endif
-
-not_early:
-		page = pfn_to_page(pfn);
-		__init_single_page(page, pfn, zone, nid);
-		if (context == MEMMAP_HOTPLUG)
-			SetPageReserved(page);
-
-		/*
-		 * Mark the block movable so that blocks are reserved for
-		 * movable at startup. This will force kernel allocations
-		 * to reserve their blocks rather than leaking throughout
-		 * the address space during boot when many long-lived
-		 * kernel allocations are made.
-		 *
-		 * bitmap is created for zone's valid pfn range. but memmap
-		 * can be created for invalid pages (for alignment)
-		 * check here not to call set_pageblock_migratetype() against
-		 * pfn out of zone.
-		 *
-		 * Please note that MEMMAP_HOTPLUG path doesn't clear memmap
-		 * because this is done early in sparse_add_one_section
-		 */
-		if (!(pfn & (pageblock_nr_pages - 1))) {
-			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
-			cond_resched();
-		}
-
-		if (is_zone_device_page(page)) {
-			if (WARN_ON_ONCE(!pgmap))
-				continue;
-
-			/* skip invalid device pages */
-			if (altmap && (pfn < (altmap->base_pfn
-						+ vmem_altmap_offset(altmap))))
-				continue;
-			/*
-			 * ZONE_DEVICE pages union ->lru with a ->pgmap back
-			 * pointer.  It is a bug if a ZONE_DEVICE page is ever
-			 * freed or placed on a driver-private list.  Seed the
-			 * storage with poison.
-			 */
-			page->lru.prev = LIST_POISON2;
-			page->pgmap = pgmap;
-			percpu_ref_get(pgmap->ref);
-		}
+		memmap_init_one(pfn, zone, nid, context, NULL);
 	}
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
