Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0ECD422225C0C
 for <linux-nvdimm@lists.01.org>; Sat, 23 Dec 2017 17:00:55 -0800 (PST)
Subject: [PATCH v4 17/18] mm, fs, dax: dax_flush_dma,
 handle dma vs block-map-change collisions
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Dec 2017 16:57:31 -0800
Message-ID: <151407705124.38751.12934858054023659736.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, hch@lst.de, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

Background:

get_user_pages() pins file backed memory pages for access by dma
devices. However, it only pins the memory pages not the page-to-file
offset association. If a file is truncated the pages are mapped out of
the file and dma may continue indefinitely into a page that is owned by
a device driver. This breaks coherency of the file vs dma, but the
assumption is that if userspace wants the file-space truncated it does
not matter what data is inbound from the device, it is not relevant
anymore. The only expectation is that dma can safely continue while the
filesystem reallocates the block(s).

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

The dax_flush_dma() routine is intended to be called by filesystems with
locks held against mm faults (i_mmap_lock). It then invalidates all
mappings to trigger any subsequent get_user_pages() to block on
i_mmap_lock. Finally it scans/rescans all pages in the mapping until it
observes all them idle.

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
 fs/dax.c            |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dax.h |   27 ++++++++++++++
 mm/gup.c            |    5 +++
 3 files changed, 127 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 7d9fff8a1195..eed589bf833e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -416,6 +416,19 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 	}
 }
 
+static struct page *dma_busy_page(void *entry)
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
@@ -557,6 +570,87 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 	return entry;
 }
 
+int dax_flush_dma(struct address_space *mapping, wait_atomic_t_action_f action)
+{
+	pgoff_t	indices[PAGEVEC_SIZE];
+	struct pagevec pvec;
+	pgoff_t	index, end;
+	unsigned i;
+
+	/* in the limited case get_user_pages for dax is disabled */
+	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
+		return 0;
+
+	if (!dax_mapping(mapping))
+		return 0;
+
+	if (mapping->nrexceptional == 0)
+		return 0;
+
+retry:
+	pagevec_init(&pvec);
+	index = 0;
+	end = -1;
+	unmap_mapping_range(mapping, 0, 0, 1);
+	/*
+	 * Flush dax_dma_lock() sections to ensure all possible page
+	 * references have been taken, or will block on the fs
+	 * 'mmap_lock'.
+	 */
+	synchronize_rcu();
+	while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
+				min(end - index, (pgoff_t)PAGEVEC_SIZE),
+				indices)) {
+		int rc = 0;
+
+		for (i = 0; i < pagevec_count(&pvec); i++) {
+			struct page *pvec_ent = pvec.pages[i];
+			struct page *page = NULL;
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
+				page = dma_busy_page(entry);
+			put_unlocked_mapping_entry(mapping, index, entry);
+			spin_unlock_irq(&mapping->tree_lock);
+
+			if (!page)
+				continue;
+			rc = wait_on_atomic_one(&page->_refcount, action,
+					TASK_INTERRUPTIBLE);
+			if (rc == 0)
+				continue;
+			break;
+		}
+		pagevec_remove_exceptionals(&pvec);
+		pagevec_release(&pvec);
+		index++;
+
+		if (rc < 0)
+			return rc;
+		if (rc == 0) {
+			cond_resched();
+			continue;
+		}
+
+		/*
+		 * We have dropped fs locks, so we need to revalidate
+		 * that previously seen idle pages are still idle.
+		 */
+		goto retry;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dax_flush_dma);
+
 static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 					  pgoff_t index, bool trunc)
 {
@@ -581,6 +675,7 @@ static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 	spin_unlock_irq(&mapping->tree_lock);
 	return ret;
 }
+
 /*
  * Delete exceptional DAX entry at @index from @mapping. Wait for radix tree
  * entry to get unlocked before deleting it.
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 3502abcbea31..ccd6aed90f95 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -81,6 +81,15 @@ const struct address_space_operations name = {	\
 	.invalidatepage = dax_invalidatepage, \
 }
 
+static inline void dax_dma_lock(void)
+{
+	rcu_read_lock();
+}
+
+static inline void dax_dma_unlock(void)
+{
+	rcu_read_unlock();
+}
 #else
 static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
 {
@@ -105,6 +114,13 @@ static inline void fs_dax_release(struct dax_device *dax_dev, void *owner)
 #define DEFINE_FSDAX_AOPS(name, writepages_fn)	\
 const struct address_space_operations name = { 0 }
 
+static inline void dax_dma_lock(void)
+{
+}
+
+static inline void dax_dma_unlock(void)
+{
+}
 #endif
 
 int dax_read_lock(void);
@@ -134,11 +150,22 @@ int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
 
+static inline struct page *refcount_to_page(atomic_t *c)
+{
+	return container_of(c, struct page, _refcount);
+}
+
 #ifdef CONFIG_FS_DAX
+int dax_flush_dma(struct address_space *mapping, wait_atomic_t_action_f action);
 int __dax_zero_page_range(struct block_device *bdev,
 		struct dax_device *dax_dev, sector_t sector,
 		unsigned int offset, unsigned int length);
 #else
+static inline int dax_flush_dma(struct address_space *mapping,
+		wait_atomic_t_action_f action)
+{
+	return 0;
+}
 static inline int __dax_zero_page_range(struct block_device *bdev,
 		struct dax_device *dax_dev, sector_t sector,
 		unsigned int offset, unsigned int length)
diff --git a/mm/gup.c b/mm/gup.c
index 9d142eb9e2e9..a8f5e13f7d17 100644
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
+		dax_dma_lock();
 		page = follow_page_mask(vma, start, foll_flags, &page_mask);
+		dax_dma_unlock();
 		if (!page) {
 			int ret;
 			ret = faultin_page(tsk, vma, start, &foll_flags,
@@ -1825,7 +1828,9 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 
 	if (gup_fast_permitted(start, nr_pages, write)) {
 		local_irq_disable();
+		dax_dma_lock();
 		gup_pgd_range(addr, end, write, pages, &nr);
+		dax_dma_unlock();
 		local_irq_enable();
 		ret = nr;
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
