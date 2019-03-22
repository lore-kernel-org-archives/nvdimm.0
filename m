Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 92332211E82FD
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 10:11:04 -0700 (PDT)
Subject: [PATCH v5 06/10] mm/sparsemem: Prepare for sub-section ranges
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Mar 2019 09:58:25 -0700
Message-ID: <155327390559.225273.10974961998965315841.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155327387405.225273.9325594075351253804.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155327387405.225273.9325594075351253804.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Prepare the memory hot-{add,remove} paths for handling sub-section
ranges by plumbing the starting page frame and number of pages being
handled through arch_{add,remove}_memory() to
sparse_{add,remove}_one_section().

This is simply plumbing, small cleanups, and some identifier renames. No
intended functional changes.

Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/mm/init_64.c          |   11 +++++
 include/linux/memory_hotplug.h |    7 ++-
 mm/memory_hotplug.c            |   85 ++++++++++++++++++++++------------------
 mm/sparse.c                    |    7 ++-
 4 files changed, 66 insertions(+), 44 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 799887eada60..4ae817a79ac3 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -781,6 +781,17 @@ int add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
 {
 	int ret;
 
+	/*
+	 * Only allow partial section hotplug for !memblock ranges,
+	 * since register_new_memory() requires section alignment, and
+	 * CONFIG_SPARSEMEM_VMEMMAP=n requires sections to be fully
+	 * populated.
+	 */
+	if ((!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP) || want_memblock)
+			&& ((start_pfn & ~PAGE_SECTION_MASK)
+				|| (nr_pages & ~PAGE_SECTION_MASK)))
+		return -EINVAL;
+
 	ret = __add_pages(nid, start_pfn, nr_pages, altmap, want_memblock);
 	WARN_ON_ONCE(ret);
 
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 8ade08c50d26..83ee937fb67f 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -336,9 +336,10 @@ extern int arch_add_memory(int nid, u64 start, u64 size,
 extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap);
 extern bool is_memblock_offlined(struct memory_block *mem);
-extern int sparse_add_one_section(int nid, unsigned long start_pfn,
-				  struct vmem_altmap *altmap);
-extern void sparse_remove_one_section(struct zone *zone, struct mem_section *ms,
+extern int sparse_add_section(int nid, unsigned long pfn,
+		unsigned long nr_pages, struct vmem_altmap *altmap);
+extern void sparse_remove_section(struct zone *zone, struct mem_section *ms,
+		unsigned long pfn, unsigned long nr_pages,
 		unsigned long map_offset, struct vmem_altmap *altmap);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0ea3bb58d223..e093348f5d04 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -250,22 +250,23 @@ void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
 }
 #endif /* CONFIG_HAVE_BOOTMEM_INFO_NODE */
 
-static int __meminit __add_section(int nid, unsigned long phys_start_pfn,
-		struct vmem_altmap *altmap, bool want_memblock)
+static int __meminit __add_section(int nid, unsigned long pfn,
+		unsigned long nr_pages,	struct vmem_altmap *altmap,
+		bool want_memblock)
 {
 	int ret;
 
-	if (pfn_valid(phys_start_pfn))
+	if (pfn_valid(pfn))
 		return -EEXIST;
 
-	ret = sparse_add_one_section(nid, phys_start_pfn, altmap);
+	ret = sparse_add_section(nid, pfn, nr_pages, altmap);
 	if (ret < 0)
 		return ret;
 
 	if (!want_memblock)
 		return 0;
 
-	return hotplug_memory_register(nid, __pfn_to_section(phys_start_pfn));
+	return hotplug_memory_register(nid, __pfn_to_section(pfn));
 }
 
 /*
@@ -274,23 +275,18 @@ static int __meminit __add_section(int nid, unsigned long phys_start_pfn,
  * call this function after deciding the zone to which to
  * add the new pages.
  */
-int __ref __add_pages(int nid, unsigned long phys_start_pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap,
-		bool want_memblock)
+int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, bool want_memblock)
 {
 	unsigned long i;
 	int err = 0;
 	int start_sec, end_sec;
 
-	/* during initialize mem_map, align hot-added range to section */
-	start_sec = pfn_to_section_nr(phys_start_pfn);
-	end_sec = pfn_to_section_nr(phys_start_pfn + nr_pages - 1);
-
 	if (altmap) {
 		/*
 		 * Validate altmap is within bounds of the total request
 		 */
-		if (altmap->base_pfn != phys_start_pfn
+		if (altmap->base_pfn != pfn
 				|| vmem_altmap_offset(altmap) > nr_pages) {
 			pr_warn_once("memory add fail, invalid altmap\n");
 			err = -EINVAL;
@@ -299,9 +295,16 @@ int __ref __add_pages(int nid, unsigned long phys_start_pfn,
 		altmap->alloc = 0;
 	}
 
+	start_sec = pfn_to_section_nr(pfn);
+	end_sec = pfn_to_section_nr(pfn + nr_pages - 1);
 	for (i = start_sec; i <= end_sec; i++) {
-		err = __add_section(nid, section_nr_to_pfn(i), altmap,
-				want_memblock);
+		unsigned long pfns;
+
+		pfns = min(nr_pages, PAGES_PER_SECTION
+				- (pfn & ~PAGE_SECTION_MASK));
+		err = __add_section(nid, pfn, pfns, altmap, want_memblock);
+		pfn += pfns;
+		nr_pages -= pfns;
 
 		/*
 		 * EEXIST is finally dealt with by ioresource collision
@@ -506,10 +509,10 @@ static void shrink_pgdat_span(struct pglist_data *pgdat,
 	pgdat->node_spanned_pages = 0;
 }
 
-static void __remove_zone(struct zone *zone, unsigned long start_pfn)
+static void __remove_zone(struct zone *zone, unsigned long start_pfn,
+		unsigned long nr_pages)
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
-	int nr_pages = PAGES_PER_SECTION;
 	unsigned long flags;
 
 	pgdat_resize_lock(zone->zone_pgdat, &flags);
@@ -518,11 +521,11 @@ static void __remove_zone(struct zone *zone, unsigned long start_pfn)
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 }
 
-static int __remove_section(struct zone *zone, struct mem_section *ms,
-		unsigned long map_offset, struct vmem_altmap *altmap)
+static int __remove_section(struct zone *zone, unsigned long pfn,
+		unsigned long nr_pages, unsigned long map_offset,
+		struct vmem_altmap *altmap)
 {
-	unsigned long start_pfn;
-	int scn_nr;
+	struct mem_section *ms = __nr_to_section(pfn_to_section_nr(pfn));
 	int ret = -EINVAL;
 
 	if (!valid_section(ms))
@@ -532,18 +535,16 @@ static int __remove_section(struct zone *zone, struct mem_section *ms,
 	if (ret)
 		return ret;
 
-	scn_nr = __section_nr(ms);
-	start_pfn = section_nr_to_pfn((unsigned long)scn_nr);
-	__remove_zone(zone, start_pfn);
+	__remove_zone(zone, pfn, nr_pages);
 
-	sparse_remove_one_section(zone, ms, map_offset, altmap);
+	sparse_remove_section(zone, ms, pfn, nr_pages, map_offset, altmap);
 	return 0;
 }
 
 /**
  * __remove_pages() - remove sections of pages from a zone
  * @zone: zone from which pages need to be removed
- * @phys_start_pfn: starting pageframe (must be aligned to start of a section)
+ * @pfn: starting pageframe (must be aligned to start of a section)
  * @nr_pages: number of pages to remove (must be multiple of section size)
  * @altmap: alternative device page map or %NULL if default memmap is used
  *
@@ -552,12 +553,11 @@ static int __remove_section(struct zone *zone, struct mem_section *ms,
  * sure that pages are marked reserved and zones are adjust properly by
  * calling offline_pages().
  */
-int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
+int __remove_pages(struct zone *zone, unsigned long pfn,
 		 unsigned long nr_pages, struct vmem_altmap *altmap)
 {
-	unsigned long i;
 	unsigned long map_offset = 0;
-	int sections_to_remove, ret = 0;
+	int i, start_sec, end_sec, ret = 0;
 
 	/* In the ZONE_DEVICE case device driver owns the memory region */
 	if (is_dev_zone(zone)) {
@@ -566,7 +566,7 @@ int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
 	} else {
 		resource_size_t start, size;
 
-		start = phys_start_pfn << PAGE_SHIFT;
+		start = pfn << PAGE_SHIFT;
 		size = nr_pages * PAGE_SIZE;
 
 		ret = release_mem_region_adjustable(&iomem_resource, start,
@@ -582,18 +582,27 @@ int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
 	clear_zone_contiguous(zone);
 
 	/*
-	 * We can only remove entire sections
+	 * Only ZONE_DEVICE memory is enabled to remove
+	 * section-unaligned ranges. See register_new_memory() which
+	 * assumes section alignment and is skipped for ZONE_DEVICE
+	 * ranges.
 	 */
-	BUG_ON(phys_start_pfn & ~PAGE_SECTION_MASK);
-	BUG_ON(nr_pages % PAGES_PER_SECTION);
+	if (!is_dev_zone(zone) && ((pfn | nr_pages) & ~PAGE_SECTION_MASK)) {
+		WARN(1, "section unaligned removal not supported\n");
+		return -EINVAL;
+	}
 
-	sections_to_remove = nr_pages / PAGES_PER_SECTION;
-	for (i = 0; i < sections_to_remove; i++) {
-		unsigned long pfn = phys_start_pfn + i*PAGES_PER_SECTION;
+	start_sec = pfn_to_section_nr(pfn);
+	end_sec = pfn_to_section_nr(pfn + nr_pages - 1);
+	for (i = start_sec; i <= end_sec; i++) {
+		unsigned long pfns;
 
 		cond_resched();
-		ret = __remove_section(zone, __pfn_to_section(pfn), map_offset,
-				altmap);
+		pfns = min(nr_pages, PAGES_PER_SECTION
+				- (pfn & ~PAGE_SECTION_MASK));
+		ret = __remove_section(zone, pfn, pfns, map_offset, altmap);
+		pfn += pfns;
+		nr_pages -= pfns;
 		map_offset = 0;
 		if (ret)
 			break;
diff --git a/mm/sparse.c b/mm/sparse.c
index 38f80639c6cc..767713c88cf5 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -748,8 +748,8 @@ static void free_map_bootmem(struct page *memmap)
  * set.  If this is <=0, then that means that the passed-in
  * map was not consumed and must be freed.
  */
-int __meminit sparse_add_one_section(int nid, unsigned long start_pfn,
-				     struct vmem_altmap *altmap)
+int __meminit sparse_add_section(int nid, unsigned long start_pfn,
+		unsigned long nr_pages, struct vmem_altmap *altmap)
 {
 	unsigned long section_nr = pfn_to_section_nr(start_pfn);
 	struct mem_section_usage *usage;
@@ -858,7 +858,8 @@ static void free_section_usage(struct page *memmap,
 		free_map_bootmem(memmap);
 }
 
-void sparse_remove_one_section(struct zone *zone, struct mem_section *ms,
+void sparse_remove_section(struct zone *zone, struct mem_section *ms,
+		unsigned long pfn, unsigned long nr_pages,
 		unsigned long map_offset, struct vmem_altmap *altmap)
 {
 	struct page *memmap = NULL;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
