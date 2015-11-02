Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 10/15] dax,
 pmem: introduce zone_device_revoke() and devm_memunmap_pages()
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 01 Nov 2015 23:30:36 -0500
Message-ID: <20151102043036.6610.33788.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: Dave Hansen <dave@sr71.net>, jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, ross.zwisler@linux.intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Before we allow ZONE_DEVICE pages to be put into active use outside of
the pmem driver, we need a mechanism to revoke access and assert they
are idle when the driver is shutdown.  devm_memunmap_pages() checks that
the reference count passed in at devm_memremap_pages() time is dead, and
then uses zone_device_revoke() to unmap any active inode mappings.

For pmem, it is using the q_usage_counter percpu_ref from its
request_queue as the reference count for devm_memremap_pages().

Cc: Jan Kara <jack@suse.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |   50 +++++++++++++++++++++----
 fs/dax.c              |   20 ++++++++++
 include/linux/io.h    |   17 ---------
 include/linux/mm.h    |   25 +++++++++++++
 kernel/memremap.c     |   98 ++++++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 182 insertions(+), 28 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 09093372e5f0..aa2f1292120a 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -24,12 +24,15 @@
 #include <linux/memory_hotplug.h>
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
+#include <linux/async.h>
 #include <linux/slab.h>
 #include <linux/pmem.h>
 #include <linux/nd.h>
 #include "pfn.h"
 #include "nd.h"
 
+static ASYNC_DOMAIN_EXCLUSIVE(async_pmem);
+
 struct pmem_device {
 	struct request_queue	*pmem_queue;
 	struct gendisk		*pmem_disk;
@@ -147,7 +150,8 @@ static struct pmem_device *pmem_alloc(struct device *dev,
 
 	pmem->pfn_flags = PFN_DEV;
 	if (pmem_should_map_pages(dev)) {
-		pmem->virt_addr = (void __pmem *) devm_memremap_pages(dev, res);
+		pmem->virt_addr = (void __pmem *) devm_memremap_pages(dev, res,
+				&q->q_usage_counter);
 		pmem->pfn_flags |= PFN_MAP;
 	} else
 		pmem->virt_addr = (void __pmem *) devm_memremap(dev,
@@ -163,14 +167,43 @@ static struct pmem_device *pmem_alloc(struct device *dev,
 	return pmem;
 }
 
-static void pmem_detach_disk(struct pmem_device *pmem)
+
+static void async_blk_cleanup_queue(void *data, async_cookie_t cookie)
 {
+	struct pmem_device *pmem = data;
+
+	blk_cleanup_queue(pmem->pmem_queue);
+}
+
+static void pmem_detach_disk(struct device *dev)
+{
+	struct pmem_device *pmem = dev_get_drvdata(dev);
+	struct request_queue *q = pmem->pmem_queue;
+
 	if (!pmem->pmem_disk)
 		return;
 
 	del_gendisk(pmem->pmem_disk);
 	put_disk(pmem->pmem_disk);
-	blk_cleanup_queue(pmem->pmem_queue);
+	async_schedule_domain(async_blk_cleanup_queue, pmem, &async_pmem);
+
+	if (pmem_should_map_pages(dev)) {
+		/*
+		 * Wait for queue to go dead so that we know no new
+		 * references will be taken against the pages allocated
+		 * by devm_memremap_pages().
+		 */
+		blk_wait_queue_dead(q);
+
+		/*
+		 * Manually release the page mapping so that
+		 * blk_cleanup_queue() can complete queue draining.
+		 */
+		devm_memunmap_pages(dev, (void __force *) pmem->virt_addr);
+	}
+
+	/* Wait for blk_cleanup_queue() to finish */
+	async_synchronize_full_domain(&async_pmem);
 }
 
 static int pmem_attach_disk(struct device *dev,
@@ -299,11 +332,9 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 static int nvdimm_namespace_detach_pfn(struct nd_namespace_common *ndns)
 {
 	struct nd_pfn *nd_pfn = to_nd_pfn(ndns->claim);
-	struct pmem_device *pmem;
 
 	/* free pmem disk */
-	pmem = dev_get_drvdata(&nd_pfn->dev);
-	pmem_detach_disk(pmem);
+	pmem_detach_disk(&nd_pfn->dev);
 
 	/* release nd_pfn resources */
 	kfree(nd_pfn->pfn_sb);
@@ -321,6 +352,7 @@ static int nvdimm_namespace_attach_pfn(struct nd_namespace_common *ndns)
 	struct nd_region *nd_region;
 	struct nd_pfn_sb *pfn_sb;
 	struct pmem_device *pmem;
+	struct request_queue *q;
 	phys_addr_t offset;
 	int rc;
 
@@ -357,8 +389,10 @@ static int nvdimm_namespace_attach_pfn(struct nd_namespace_common *ndns)
 
 	/* establish pfn range for lookup, and switch to direct map */
 	pmem = dev_get_drvdata(dev);
+	q = pmem->pmem_queue;
 	devm_memunmap(dev, (void __force *) pmem->virt_addr);
-	pmem->virt_addr = (void __pmem *) devm_memremap_pages(dev, &nsio->res);
+	pmem->virt_addr = (void __pmem *) devm_memremap_pages(dev, &nsio->res,
+			&q->q_usage_counter);
 	pmem->pfn_flags |= PFN_MAP;
 	if (IS_ERR(pmem->virt_addr)) {
 		rc = PTR_ERR(pmem->virt_addr);
@@ -428,7 +462,7 @@ static int nd_pmem_remove(struct device *dev)
 	else if (is_nd_pfn(dev))
 		nvdimm_namespace_detach_pfn(pmem->ndns);
 	else
-		pmem_detach_disk(pmem);
+		pmem_detach_disk(dev);
 
 	return 0;
 }
diff --git a/fs/dax.c b/fs/dax.c
index 4d6861f022d9..ac8992e86779 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -327,6 +327,23 @@ static int copy_user_bh(struct page *to, struct inode *inode,
 	return 0;
 }
 
+/* must be called within a dax_map_atomic / dax_unmap_atomic section */
+static void dax_account_mapping(struct block_device *bdev, pfn_t pfn,
+		struct address_space *mapping)
+{
+	/*
+	 * If we are establishing a mapping for a page mapped pfn, take an
+	 * extra reference against the request_queue.  See zone_device_revoke
+	 * for the paired decrement.
+	 */
+	if (pfn_t_has_page(pfn)) {
+		struct page *page = pfn_t_to_page(pfn);
+
+		page->mapping = mapping;
+		percpu_ref_get(&bdev->bd_queue->q_usage_counter);
+	}
+}
+
 static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 			struct vm_area_struct *vma, struct vm_fault *vmf)
 {
@@ -364,6 +381,8 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 		clear_pmem(addr, PAGE_SIZE);
 		wmb_pmem();
 	}
+
+	dax_account_mapping(bdev, pfn, mapping);
 	dax_unmap_atomic(bdev, addr);
 
 	error = vm_insert_mixed(vma, vaddr, pfn_t_to_pfn(pfn));
@@ -677,6 +696,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
 			result |= VM_FAULT_MAJOR;
 		}
+		dax_account_mapping(bdev, pfn, mapping);
 		dax_unmap_atomic(bdev, kaddr);
 
 		result |= vmf_insert_pfn_pmd(vma, address, pmd,
diff --git a/include/linux/io.h b/include/linux/io.h
index de64c1e53612..2f2f8859abd9 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -87,23 +87,6 @@ void *devm_memremap(struct device *dev, resource_size_t offset,
 		size_t size, unsigned long flags);
 void devm_memunmap(struct device *dev, void *addr);
 
-void *__devm_memremap_pages(struct device *dev, struct resource *res);
-
-#ifdef CONFIG_ZONE_DEVICE
-void *devm_memremap_pages(struct device *dev, struct resource *res);
-#else
-static inline void *devm_memremap_pages(struct device *dev, struct resource *res)
-{
-	/*
-	 * Fail attempts to call devm_memremap_pages() without
-	 * ZONE_DEVICE support enabled, this requires callers to fall
-	 * back to plain devm_memremap() based on config
-	 */
-	WARN_ON_ONCE(1);
-	return ERR_PTR(-ENXIO);
-}
-#endif
-
 /*
  * Some systems do not have legacy ISA devices.
  * /dev/port is not a valid interface on these systems.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b8a90c481ae4..f6225140b5d7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -717,6 +717,31 @@ static inline enum zone_type page_zonenum(const struct page *page)
 	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
 }
 
+struct percpu_ref;
+struct resource;
+struct device;
+#ifdef CONFIG_ZONE_DEVICE
+void devm_memunmap_pages(struct device *dev, void *addr);
+void *devm_memremap_pages(struct device *dev, struct resource *res,
+		struct percpu_ref *ref);
+#else
+static inline void devm_memunmap_pages(struct device *dev, void *addr)
+{
+}
+
+static inline void *devm_memremap_pages(struct device *dev,
+		struct resource *res, struct percpu_ref *ref)
+{
+	/*
+	 * Fail attempts to call devm_memremap_pages() without
+	 * ZONE_DEVICE support enabled, this requires callers to fall
+	 * back to plain devm_memremap() based on config
+	 */
+	WARN_ON_ONCE(1);
+	return ERR_PTR(-ENXIO);
+}
+#endif
+
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define SECTION_IN_PAGE_FLAGS
 #endif
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 3218e8b1fc28..a73e18d8a120 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -12,9 +12,11 @@
  */
 #include <linux/device.h>
 #include <linux/types.h>
+#include <linux/fs.h>
 #include <linux/io.h>
 #include <linux/mm.h>
 #include <linux/memory_hotplug.h>
+#include <linux/percpu-refcount.h>
 
 #ifndef ioremap_cache
 /* temporary while we convert existing ioremap_cache users to memremap */
@@ -140,17 +142,88 @@ EXPORT_SYMBOL(devm_memunmap);
 #ifdef CONFIG_ZONE_DEVICE
 struct page_map {
 	struct resource res;
+	struct percpu_ref *ref;
 };
 
-static void devm_memremap_pages_release(struct device *dev, void *res)
+static unsigned long pfn_first(struct page_map *page_map)
 {
-	struct page_map *page_map = res;
+	const struct resource *res = &page_map->res;
+
+	return res->start >> PAGE_SHIFT;
+}
+
+static unsigned long pfn_end(struct page_map *page_map)
+{
+	const struct resource *res = &page_map->res;
+
+	return (res->start + resource_size(res)) >> PAGE_SHIFT;
+}
+
+#define for_each_device_pfn(pfn, map) \
+	for (pfn = pfn_first(map); pfn < pfn_end(map); pfn++)
+
+static void zone_device_revoke(struct device *dev, struct page_map *page_map)
+{
+	unsigned long pfn;
+	int retry = 3;
+	struct percpu_ref *ref = page_map->ref;
+	struct address_space *mapping_prev;
+
+	if (percpu_ref_tryget_live(ref)) {
+		dev_WARN(dev, "%s: page mapping is still live!\n", __func__);
+		percpu_ref_put(ref);
+	}
+
+ retry:
+	mapping_prev = NULL;
+	for_each_device_pfn(pfn, page_map) {
+		struct page *page = pfn_to_page(pfn);
+		struct address_space *mapping = page->mapping;
+		struct inode *inode = mapping ? mapping->host : NULL;
+
+		dev_WARN_ONCE(dev, atomic_read(&page->_count) < 1,
+				"%s: ZONE_DEVICE page was freed!\n", __func__);
+
+		/* See dax_account_mapping */
+		if (mapping) {
+			percpu_ref_put(ref);
+			page->mapping = NULL;
+		}
+
+		if (!mapping || !inode || mapping == mapping_prev) {
+			dev_WARN_ONCE(dev, atomic_read(&page->_count) > 1,
+					"%s: unexpected elevated page count pfn: %lx\n",
+					__func__, pfn);
+			continue;
+		}
+
+		unmap_mapping_range(mapping, 0, 0, 1);
+		mapping_prev = mapping;
+	}
+
+	/*
+	 * Straggling mappings may have been established immediately
+	 * after the percpu_ref was killed.
+	 */
+	if (!percpu_ref_is_zero(ref) && retry--)
+		goto retry;
+
+	if (!percpu_ref_is_zero(ref))
+		dev_warn(dev, "%s: not all references released\n", __func__);
+}
+
+static void devm_memremap_pages_release(struct device *dev, void *data)
+{
+	struct page_map *page_map = data;
+
+	zone_device_revoke(dev, page_map);
 
 	/* pages are dead and unused, undo the arch mapping */
 	arch_remove_memory(page_map->res.start, resource_size(&page_map->res));
 }
 
-void *devm_memremap_pages(struct device *dev, struct resource *res)
+void *devm_memremap_pages(struct device *dev, struct resource *res,
+		struct percpu_ref *ref)
 {
 	int is_ram = region_intersects(res->start, resource_size(res),
 			"System RAM");
@@ -172,6 +245,7 @@ void *devm_memremap_pages(struct device *dev, struct resource *res)
 		return ERR_PTR(-ENOMEM);
 
 	memcpy(&page_map->res, res, sizeof(*res));
+	page_map->ref = ref;
 
 	nid = dev_to_node(dev);
 	if (nid < 0)
@@ -187,4 +261,22 @@ void *devm_memremap_pages(struct device *dev, struct resource *res)
 	return __va(res->start);
 }
 EXPORT_SYMBOL(devm_memremap_pages);
+
+static int page_map_match(struct device *dev, void *res, void *match_data)
+{
+	struct page_map *page_map = res;
+	resource_size_t phys = *(resource_size_t *) match_data;
+
+	return page_map->res.start == phys;
+}
+
+void devm_memunmap_pages(struct device *dev, void *addr)
+{
+	resource_size_t start = __pa(addr);
+
+	if (devres_release(dev, devm_memremap_pages_release, page_map_match,
+				&start) != 0)
+		dev_WARN(dev, "failed to find page map to release\n");
+}
+EXPORT_SYMBOL(devm_memunmap_pages);
 #endif /* CONFIG_ZONE_DEVICE */

