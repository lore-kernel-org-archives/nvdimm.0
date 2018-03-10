Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A90CF220C2A58
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 22:58:24 -0800 (PST)
Subject: [PATCH v5 09/11] mm, fs,
 dax: handle layout changes to pinned dax mappings
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Mar 2018 22:55:37 -0800
Message-ID: <152066493762.40260.14701327157254972582.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, jack@suse.cz, "Darrick J. Wong" <darrick.wong@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Background:

get_user_pages() in the filesystem pins file backed memory pages for
access by devices performing dma. However, it only pins the memory pages
not the page-to-file offset association. If a file is truncated the
pages are mapped out of the file and dma may continue indefinitely into
a page that is owned by a device driver. This breaks coherency of the
file vs dma, but the assumption is that if userspace wants the
file-space truncated it does not matter what data is inbound from the
device, it is not relevant anymore. The only expectation is that dma can
safely continue while the filesystem reallocates the block(s).

Problem:

This expectation that dma can safely continue while the filesystem
changes the block map is broken by dax. With dax the target dma page
*is* the filesystem block. The model of leaving the page pinned for dma,
but truncating the file block out of the file, means that the filesytem
is free to reallocate a block under active dma to another file and now
the expected data-incoherency situation has turned into active
data-corruption.

Solution:

Defer all filesystem operations (fallocate(), truncate()) on a dax mode
file while any page/block in the file is under active dma. This solution
assumes that dma is transient. Cases where dma operations are known to
not be transient, like RDMA, have been explicitly disabled via
commits like 5f1d43de5416 "IB/core: disable memory registration of
filesystem-dax vmas".

The dax_layout_busy_page() routine is called by filesystems with a lock
held against mm faults (i_mmap_lock) to find pinned / busy dax pages.
The process of looking up a busy page invalidates all mappings
to trigger any subsequent get_user_pages() to block on i_mmap_lock.
The filesystem continues to call dax_layout_busy_page() until it finally
returns no more active pages. This approach assumes that the page
pinning is transient, if that assumption is violated the system would
have likely hung from the uncompleted I/O.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c            |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dax.h |   30 ++++++++++++++++
 mm/gup.c            |    5 +++
 3 files changed, 128 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index fecf463a1468..cfaaf31fae85 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -375,6 +375,19 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 	}
 }
 
+static struct page *dax_busy_page(void *entry)
+{
+	unsigned long pfn, end_pfn;
+
+	for_each_entry_pfn(entry, pfn, end_pfn) {
+		struct page *page = pfn_to_page(pfn);
+
+		if (page_ref_count(page) > 1)
+			return page;
+	}
+	return NULL;
+}
+
 /*
  * Find radix tree entry at given index. If it points to an exceptional entry,
  * return it with the radix tree entry locked. If the radix tree doesn't
@@ -516,6 +529,85 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 	return entry;
 }
 
+/**
+ * dax_layout_busy_page - find first pinned page in @mapping
+ * @mapping: address space to scan for a page with ref count > 1
+ *
+ * DAX requires ZONE_DEVICE mapped pages. These pages are never
+ * 'onlined' to the page allocator so they are considered idle when
+ * page->count == 1. A filesystem uses this interface to determine if
+ * any page in the mapping is busy, i.e. for DMA, or other
+ * get_user_pages() usages.
+ *
+ * It is expected that the filesystem is holding locks to block the
+ * establishment of new mappings in this address_space. I.e. it expects
+ * to be able to run unmap_mapping_range() and subsequently not race
+ * mapping_mapped() becoming true. It expects that get_user_pages() pte
+ * walks are performed under rcu_read_lock().
+ */
+struct page *dax_layout_busy_page(struct address_space *mapping)
+{
+	pgoff_t	indices[PAGEVEC_SIZE];
+	struct page *page = NULL;
+	struct pagevec pvec;
+	pgoff_t	index, end;
+	unsigned i;
+
+	/*
+	 * In the 'limited' case get_user_pages() for dax is disabled.
+	 */
+	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
+		return NULL;
+
+	if (!dax_mapping(mapping) || !mapping_mapped(mapping))
+		return NULL;
+
+	pagevec_init(&pvec);
+	index = 0;
+	end = -1;
+	/*
+	 * Flush dax_layout_lock() sections to ensure all possible page
+	 * references have been taken, or otherwise arrange for faults
+	 * to block on the filesystem lock that is taken for
+	 * establishing new mappings.
+	 */
+	unmap_mapping_range(mapping, 0, 0, 1);
+	synchronize_rcu();
+
+	while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
+				min(end - index, (pgoff_t)PAGEVEC_SIZE),
+				indices)) {
+		for (i = 0; i < pagevec_count(&pvec); i++) {
+			struct page *pvec_ent = pvec.pages[i];
+			void *entry;
+
+			index = indices[i];
+			if (index >= end)
+				break;
+
+			if (!radix_tree_exceptional_entry(pvec_ent))
+				continue;
+
+			spin_lock_irq(&mapping->tree_lock);
+			entry = get_unlocked_mapping_entry(mapping, index, NULL);
+			if (entry)
+				page = dax_busy_page(entry);
+			put_unlocked_mapping_entry(mapping, index, entry);
+			spin_unlock_irq(&mapping->tree_lock);
+			if (page)
+				break;
+		}
+		pagevec_remove_exceptionals(&pvec);
+		pagevec_release(&pvec);
+		index++;
+
+		if (page)
+			break;
+	}
+	return page;
+}
+EXPORT_SYMBOL_GPL(dax_layout_busy_page);
+
 static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 					  pgoff_t index, bool trunc)
 {
@@ -540,6 +632,7 @@ static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 	spin_unlock_irq(&mapping->tree_lock);
 	return ret;
 }
+
 /*
  * Delete exceptional DAX entry at @index from @mapping. Wait for radix tree
  * entry to get unlocked before deleting it.
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 9b4259aee016..62671a636512 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -56,6 +56,18 @@ void fs_dax_release(struct dax_device *dax_dev, void *owner);
 int dax_set_page_dirty(struct page *page);
 void dax_invalidatepage(struct page *page, unsigned int offset,
 		unsigned int length);
+
+static inline void dax_layout_lock(void)
+{
+	rcu_read_lock();
+}
+
+static inline void dax_layout_unlock(void)
+{
+	rcu_read_unlock();
+}
+
+struct page *dax_layout_busy_page(struct address_space *mapping);
 #else
 static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
 {
@@ -79,6 +91,19 @@ static inline void fs_dax_release(struct dax_device *dax_dev, void *owner)
 
 #define dax_set_page_dirty NULL
 #define dax_invalidatepage NULL
+
+static inline void dax_layout_lock(void)
+{
+}
+
+static inline void dax_layout_unlock(void)
+{
+}
+
+static inline struct page *dax_layout_busy_page(struct address_space *mapping)
+{
+	return NULL;
+}
 #endif
 
 int dax_read_lock(void);
@@ -108,6 +133,11 @@ int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
 
+static inline struct page *refcount_to_page(atomic_t *c)
+{
+	return container_of(c, struct page, _refcount);
+}
+
 #ifdef CONFIG_FS_DAX
 int __dax_zero_page_range(struct block_device *bdev,
 		struct dax_device *dax_dev, sector_t sector,
diff --git a/mm/gup.c b/mm/gup.c
index 1b46e6e74881..a81efac6983a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -13,6 +13,7 @@
 #include <linux/sched/signal.h>
 #include <linux/rwsem.h>
 #include <linux/hugetlb.h>
+#include <linux/dax.h>
 
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
@@ -693,7 +694,9 @@ static long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		if (unlikely(fatal_signal_pending(current)))
 			return i ? i : -ERESTARTSYS;
 		cond_resched();
+		dax_layout_lock();
 		page = follow_page_mask(vma, start, foll_flags, &page_mask);
+		dax_layout_unlock();
 		if (!page) {
 			int ret;
 			ret = faultin_page(tsk, vma, start, &foll_flags,
@@ -1809,7 +1812,9 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 
 	if (gup_fast_permitted(start, nr_pages, write)) {
 		local_irq_disable();
+		dax_layout_lock();
 		gup_pgd_range(addr, end, write, pages, &nr);
+		dax_layout_unlock();
 		local_irq_enable();
 		ret = nr;
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
