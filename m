Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2AF8281F43
 for <linux-nvdimm@lists.01.org>; Fri, 18 Nov 2016 01:17:30 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 20/20] dax: Clear dirty entry tags on cache flush
Date: Fri, 18 Nov 2016 10:17:24 +0100
Message-Id: <1479460644-25076-21-git-send-email-jack@suse.cz>
In-Reply-To: <1479460644-25076-1-git-send-email-jack@suse.cz>
References: <1479460644-25076-1-git-send-email-jack@suse.cz>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-mm@kvack.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Currently we never clear dirty tags in DAX mappings and thus address
ranges to flush accumulate. Now that we have locking of radix tree
entries, we have all the locking necessary to reliably clear the radix
tree dirty tag when flushing caches for corresponding address range.
Similarly to page_mkclean() we also have to write-protect pages to get a
page fault when the page is next written to so that we can mark the
entry dirty again.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index d64465584f4c..cafd5597434b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -31,6 +31,7 @@
 #include <linux/vmstat.h>
 #include <linux/pfn_t.h>
 #include <linux/sizes.h>
+#include <linux/mmu_notifier.h>
 #include <linux/iomap.h>
 #include "internal.h"
 
@@ -613,6 +614,59 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 	return new_entry;
 }
 
+static inline unsigned long
+pgoff_address(pgoff_t pgoff, struct vm_area_struct *vma)
+{
+	unsigned long address;
+
+	address = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
+	return address;
+}
+
+/* Walk all mappings of a given index of a file and writeprotect them */
+static void dax_mapping_entry_mkclean(struct address_space *mapping,
+				      pgoff_t index, unsigned long pfn)
+{
+	struct vm_area_struct *vma;
+	pte_t *ptep;
+	pte_t pte;
+	spinlock_t *ptl;
+	bool changed;
+
+	i_mmap_lock_read(mapping);
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, index, index) {
+		unsigned long address;
+
+		cond_resched();
+
+		if (!(vma->vm_flags & VM_SHARED))
+			continue;
+
+		address = pgoff_address(index, vma);
+		changed = false;
+		if (follow_pte(vma->vm_mm, address, &ptep, &ptl))
+			continue;
+		if (pfn != pte_pfn(*ptep))
+			goto unlock;
+		if (!pte_dirty(*ptep) && !pte_write(*ptep))
+			goto unlock;
+
+		flush_cache_page(vma, address, pfn);
+		pte = ptep_clear_flush(vma, address, ptep);
+		pte = pte_wrprotect(pte);
+		pte = pte_mkclean(pte);
+		set_pte_at(vma->vm_mm, address, ptep, pte);
+		changed = true;
+unlock:
+		pte_unmap_unlock(ptep, ptl);
+
+		if (changed)
+			mmu_notifier_invalidate_page(vma->vm_mm, address);
+	}
+	i_mmap_unlock_read(mapping);
+}
+
 static int dax_writeback_one(struct block_device *bdev,
 		struct address_space *mapping, pgoff_t index, void *entry)
 {
@@ -686,7 +740,17 @@ static int dax_writeback_one(struct block_device *bdev,
 		goto unmap;
 	}
 
+	dax_mapping_entry_mkclean(mapping, index, pfn_t_to_pfn(dax.pfn));
 	wb_cache_pmem(dax.addr, dax.size);
+	/*
+	 * After we have flushed the cache, we can clear the dirty tag. There
+	 * cannot be new dirty data in the pfn after the flush has completed as
+	 * the pfn mappings are writeprotected and fault waits for mapping
+	 * entry lock.
+	 */
+	spin_lock_irq(&mapping->tree_lock);
+	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_DIRTY);
+	spin_unlock_irq(&mapping->tree_lock);
  unmap:
 	dax_unmap_atomic(bdev, &dax);
 	put_locked_mapping_entry(mapping, index, entry);
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
