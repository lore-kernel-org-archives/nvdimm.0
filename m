Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 77F9621DF9696
 for <linux-nvdimm@lists.01.org>; Mon,  7 Aug 2017 18:09:54 -0700 (PDT)
Subject: [PATCH] mm,
 devm_memremap_pages: use multi-order radix for ZONE_DEVICE lookups
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 07 Aug 2017 18:05:41 -0700
Message-ID: <150215410565.39310.13767886055248249438.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

devm_memremap_pages() records mapped ranges in pgmap_radix with an entry
per section's worth of memory (128MB).  The key for each of those
entries is a section number.

This leads to false positives when devm_memremap_pages() is passed a
section-unaligned range as lookups in the misalignment fail to return
NULL. We can close this hole by using the pfn as the key for entries in
the tree.  The number of entries required to describe a remapped range
is reduced by leveraging multi-order entries.

In practice this approach usually yields just one entry in the tree if
the size and starting address are of the same power-of-2 alignment.
Previously we always needed nr_entries = mapping_size / 128MB.

Link: https://lists.01.org/pipermail/linux-nvdimm/2016-August/006666.html
Reported-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Hi Andrew,

This is an optimization for devm_memremap_pages() that has been idling
in my local tree for a while. At one point Matthew had proposed an
official radix tree api to allow filling a range of a radix similar to
what the foreach_order_pgoff() loop is performing. Perhaps this prompts
Matthew to dust that proposal off, but this patch otherwise minimizes
the amount of entries we need in the pgmap_radix.

This patch is against latest -next.


 kernel/memremap.c |   52 ++++++++++++++++++++++++++++++++++++++--------------
 mm/Kconfig        |    1 +
 2 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index 9afdc434fb49..066e73c2fcc9 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -194,18 +194,41 @@ struct page_map {
 	struct vmem_altmap altmap;
 };
 
-static void pgmap_radix_release(struct resource *res)
+static unsigned long order_at(struct resource *res, unsigned long pgoff)
 {
-	resource_size_t key, align_start, align_size, align_end;
+	unsigned long phys_pgoff = PHYS_PFN(res->start) + pgoff;
+	unsigned long nr_pages, mask;
 
-	align_start = res->start & ~(SECTION_SIZE - 1);
-	align_size = ALIGN(resource_size(res), SECTION_SIZE);
-	align_end = align_start + align_size - 1;
+	nr_pages = PHYS_PFN(resource_size(res));
+	if (nr_pages == pgoff)
+		return ULONG_MAX;
+
+	/*
+	 * What is the largest aligned power-of-2 range available from
+	 * this resource pgoff to the end of the resource range,
+	 * considering the alignment of the current pgoff?
+	 */
+	mask = phys_pgoff | rounddown_pow_of_two(nr_pages - pgoff);
+	if (!mask)
+		return ULONG_MAX;
+
+	return find_first_bit(&mask, BITS_PER_LONG);
+}
+
+#define foreach_order_pgoff(res, order, pgoff) \
+	for (pgoff = 0, order = order_at((res), pgoff); order < ULONG_MAX; \
+			pgoff += 1UL << order, order = order_at((res), pgoff))
+
+static void pgmap_radix_release(struct resource *res)
+{
+	unsigned long pgoff, order;
 
 	mutex_lock(&pgmap_lock);
-	for (key = res->start; key <= res->end; key += SECTION_SIZE)
-		radix_tree_delete(&pgmap_radix, key >> PA_SECTION_SHIFT);
+	foreach_order_pgoff(res, order, pgoff)
+		radix_tree_delete(&pgmap_radix, PHYS_PFN(res->start) + pgoff);
 	mutex_unlock(&pgmap_lock);
+
+	synchronize_rcu();
 }
 
 static unsigned long pfn_first(struct page_map *page_map)
@@ -268,7 +291,7 @@ struct dev_pagemap *find_dev_pagemap(resource_size_t phys)
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	page_map = radix_tree_lookup(&pgmap_radix, phys >> PA_SECTION_SHIFT);
+	page_map = radix_tree_lookup(&pgmap_radix, PHYS_PFN(phys));
 	return page_map ? &page_map->pgmap : NULL;
 }
 
@@ -293,12 +316,12 @@ struct dev_pagemap *find_dev_pagemap(resource_size_t phys)
 void *devm_memremap_pages(struct device *dev, struct resource *res,
 		struct percpu_ref *ref, struct vmem_altmap *altmap)
 {
-	resource_size_t key, align_start, align_size, align_end;
+	resource_size_t align_start, align_size, align_end;
+	unsigned long pfn, pgoff, order;
 	pgprot_t pgprot = PAGE_KERNEL;
 	struct dev_pagemap *pgmap;
 	struct page_map *page_map;
 	int error, nid, is_ram;
-	unsigned long pfn;
 
 	align_start = res->start & ~(SECTION_SIZE - 1);
 	align_size = ALIGN(res->start + resource_size(res), SECTION_SIZE)
@@ -337,11 +360,12 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
 	mutex_lock(&pgmap_lock);
 	error = 0;
 	align_end = align_start + align_size - 1;
-	for (key = align_start; key <= align_end; key += SECTION_SIZE) {
+
+	foreach_order_pgoff(res, order, pgoff) {
 		struct dev_pagemap *dup;
 
 		rcu_read_lock();
-		dup = find_dev_pagemap(key);
+		dup = find_dev_pagemap(res->start + PFN_PHYS(pgoff));
 		rcu_read_unlock();
 		if (dup) {
 			dev_err(dev, "%s: %pr collides with mapping for %s\n",
@@ -349,8 +373,8 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
 			error = -EBUSY;
 			break;
 		}
-		error = radix_tree_insert(&pgmap_radix, key >> PA_SECTION_SHIFT,
-				page_map);
+		error = __radix_tree_insert(&pgmap_radix,
+				PHYS_PFN(res->start) + pgoff, order, page_map);
 		if (error) {
 			dev_err(dev, "%s: failed: %d\n", __func__, error);
 			break;
diff --git a/mm/Kconfig b/mm/Kconfig
index ab937c8d247f..9ef8c2ea92ad 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -681,6 +681,7 @@ config ZONE_DEVICE
 	depends on MEMORY_HOTREMOVE
 	depends on SPARSEMEM_VMEMMAP
 	depends on ARCH_HAS_ZONE_DEVICE
+	select RADIX_TREE_MULTIORDER
 
 	help
 	  Device memory hotplug support allows for establishing pmem,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
