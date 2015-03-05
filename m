Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54F844E5.5090500@plexistor.com>
Date: Thu, 05 Mar 2015 13:58:29 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 5/8] mm: Let sparse_{add,remove}_one_section receive a node_id
References: <54F82CE0.4040502@plexistor.com> <54F830D4.7030205@plexistor.com>
In-Reply-To: <54F830D4.7030205@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Yigal Korman <yigal@plexistor.com>

Refactored the arguments of sparse_add_one_section / sparse_remove_one_section
to use node id instead of struct zone * - A memory section has no direct
connection to zones, all that was needed from zone was the node id.

This is for add_persistent_memory that will want a section of pages
allocated but without any zone associated. This is because belonging
to a zone will give the memory to the page allocators, but
persistent_memory belongs to a block device, and is not available for
regular volatile usage.

Signed-off-by: Yigal Korman <yigal@plexistor.com>
Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 include/linux/memory_hotplug.h | 4 ++--
 mm/memory_hotplug.c            | 4 ++--
 mm/sparse.c                    | 9 +++++----
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 8f1a419..77ca3a4 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -265,8 +265,8 @@ extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern bool is_memblock_offlined(struct memory_block *mem);
 extern void remove_memory(int nid, u64 start, u64 size);
-extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn);
-extern void sparse_remove_one_section(struct zone *zone, struct mem_section *ms);
+extern int sparse_add_one_section(int nid, unsigned long start_pfn);
+extern void sparse_remove_one_section(int nid, struct mem_section *ms);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 9fab107..7a73d30 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -472,7 +472,7 @@ static int __meminit __add_section(int nid, struct zone *zone,
 	if (pfn_valid(phys_start_pfn))
 		return -EEXIST;
 
-	ret = sparse_add_one_section(zone, phys_start_pfn);
+	ret = sparse_add_one_section(zone->zone_pgdat->node_id, phys_start_pfn);
 
 	if (ret < 0)
 		return ret;
@@ -738,7 +738,7 @@ static int __remove_section(struct zone *zone, struct mem_section *ms)
 	start_pfn = section_nr_to_pfn(scn_nr);
 	__remove_zone(zone, start_pfn);
 
-	sparse_remove_one_section(zone, ms);
+	sparse_remove_one_section(zone->zone_pgdat->node_id, ms);
 	return 0;
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index d1b48b6..12a10ab 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -690,10 +690,10 @@ static void free_map_bootmem(struct page *memmap)
  * set.  If this is <=0, then that means that the passed-in
  * map was not consumed and must be freed.
  */
-int __meminit sparse_add_one_section(struct zone *zone, unsigned long start_pfn)
+int __meminit sparse_add_one_section(int nid, unsigned long start_pfn)
 {
 	unsigned long section_nr = pfn_to_section_nr(start_pfn);
-	struct pglist_data *pgdat = zone->zone_pgdat;
+	struct pglist_data *pgdat = NODE_DATA(nid);
 	struct mem_section *ms;
 	struct page *memmap;
 	unsigned long *usemap;
@@ -788,11 +788,11 @@ static void free_section_usemap(struct page *memmap, unsigned long *usemap)
 		free_map_bootmem(memmap);
 }
 
-void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
+void sparse_remove_one_section(int nid, struct mem_section *ms)
 {
 	struct page *memmap = NULL;
 	unsigned long *usemap = NULL, flags;
-	struct pglist_data *pgdat = zone->zone_pgdat;
+	struct pglist_data *pgdat = NODE_DATA(nid);
 
 	pgdat_resize_lock(pgdat, &flags);
 	if (ms->section_mem_map) {
@@ -807,5 +807,6 @@ void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
 	clear_hwpoisoned_pages(memmap, PAGES_PER_SECTION);
 	free_section_usemap(memmap, usemap);
 }
+
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 #endif /* CONFIG_MEMORY_HOTPLUG */
-- 
1.9.3

