Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 3/3] devm_memremap_pages: fix vmem_altmap lifetime +
 alignment handling
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 30 Jan 2016 10:42:19 -0800
Message-ID: <20160130184219.17558.88859.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160130184203.17558.30413.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160130184203.17558.30413.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

to_vmem_altmap() needs to return valid results until
arch_remove_memory() completes.  It also needs to be valid for any pfn
in a section regardless of whether that pfn maps to data.  This escape
was a result of a bug in the unit test.

The signature of this bug is that free_pagetable() fails to retrieve a
vmem_altmap and goes off into the weeds:

 BUG: unable to handle kernel NULL pointer dereference at           (null)
 IP: [<ffffffff811d2629>] get_pfnblock_flags_mask+0x49/0x60
 [..]
 Call Trace:
  [<ffffffff811d3477>] free_hot_cold_page+0x97/0x1d0
  [<ffffffff811d367a>] __free_pages+0x2a/0x40
  [<ffffffff8191e669>] free_pagetable+0x8c/0xd4
  [<ffffffff8191ef4e>] remove_pagetable+0x37a/0x808
  [<ffffffff8191b210>] vmemmap_free+0x10/0x20

Fixes: 4b94ffdc4163 ("x86, mm: introduce vmem_altmap to augment vmemmap_populate()")
Cc: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 kernel/memremap.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index e517a16cb426..cbc3e97e2bb4 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -183,7 +183,11 @@ EXPORT_SYMBOL(put_zone_device_page);
 
 static void pgmap_radix_release(struct resource *res)
 {
-	resource_size_t key;
+	resource_size_t key, align_start, align_size, align_end;
+
+	align_start = res->start & ~(SECTION_SIZE - 1);
+	align_size = ALIGN(resource_size(res), SECTION_SIZE);
+	align_end = align_start + align_size - 1;
 
 	mutex_lock(&pgmap_lock);
 	for (key = res->start; key <= res->end; key += SECTION_SIZE)
@@ -226,12 +230,11 @@ static void devm_memremap_pages_release(struct device *dev, void *data)
 		percpu_ref_put(pgmap->ref);
 	}
 
-	pgmap_radix_release(res);
-
 	/* pages are dead and unused, undo the arch mapping */
 	align_start = res->start & ~(SECTION_SIZE - 1);
 	align_size = ALIGN(resource_size(res), SECTION_SIZE);
 	arch_remove_memory(align_start, align_size);
+	pgmap_radix_release(res);
 	dev_WARN_ONCE(dev, pgmap->altmap && pgmap->altmap->alloc,
 			"%s: failed to free all reserved pages\n", __func__);
 }
@@ -267,7 +270,7 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
 {
 	int is_ram = region_intersects(res->start, resource_size(res),
 			"System RAM");
-	resource_size_t key, align_start, align_size;
+	resource_size_t key, align_start, align_size, align_end;
 	struct dev_pagemap *pgmap;
 	struct page_map *page_map;
 	unsigned long pfn;
@@ -309,7 +312,10 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
 
 	mutex_lock(&pgmap_lock);
 	error = 0;
-	for (key = res->start; key <= res->end; key += SECTION_SIZE) {
+	align_start = res->start & ~(SECTION_SIZE - 1);
+	align_size = ALIGN(resource_size(res), SECTION_SIZE);
+	align_end = align_start + align_size - 1;
+	for (key = align_start; key <= align_end; key += SECTION_SIZE) {
 		struct dev_pagemap *dup;
 
 		rcu_read_lock();
@@ -336,8 +342,6 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
 	if (nid < 0)
 		nid = numa_mem_id();
 
-	align_start = res->start & ~(SECTION_SIZE - 1);
-	align_size = ALIGN(resource_size(res), SECTION_SIZE);
 	error = arch_add_memory(nid, align_start, align_size, true);
 	if (error)
 		goto err_add_memory;
