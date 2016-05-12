Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 828251A1F8E
 for <linux-nvdimm@lists.01.org>; Thu, 12 May 2016 09:29:35 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 6/7] dax: Use radix tree entry lock to protect cow faults
Date: Thu, 12 May 2016 18:29:19 +0200
Message-Id: <1463070560-1979-7-git-send-email-jack@suse.cz>
In-Reply-To: <1463070560-1979-1-git-send-email-jack@suse.cz>
References: <1463070560-1979-1-git-send-email-jack@suse.cz>
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
To: linux-nvdimm@lists.01.org
Cc: Ted Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When doing cow faults, we cannot directly fill in PTE as we do for other
faults as we rely on generic code to do proper accounting of the cowed page.
We also have no page to lock to protect against races with truncate as
other faults have and we need the protection to extend until the moment
generic code inserts cowed page into PTE thus at that point we have no
protection of fs-specific i_mmap_sem. So far we relied on using
i_mmap_lock for the protection however that is completely special to cow
faults. To make fault locking more uniform use DAX entry lock instead.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c            | 12 +++++-------
 include/linux/dax.h |  7 +++++++
 include/linux/mm.h  |  7 +++++++
 mm/memory.c         | 38 ++++++++++++++++++--------------------
 4 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index e7ecc80eb62d..a09d19f5371e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -510,7 +510,7 @@ void dax_wake_mapping_entry_waiter(struct address_space *mapping,
 	}
 }
 
-static void unlock_mapping_entry(struct address_space *mapping, pgoff_t index)
+void dax_unlock_mapping_entry(struct address_space *mapping, pgoff_t index)
 {
 	void *ret, **slot;
 
@@ -533,7 +533,7 @@ static void put_locked_mapping_entry(struct address_space *mapping,
 		unlock_page(entry);
 		put_page(entry);
 	} else {
-		unlock_mapping_entry(mapping, index);
+		dax_unlock_mapping_entry(mapping, index);
 	}
 }
 
@@ -916,12 +916,10 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			goto unlock_entry;
 		if (!radix_tree_exceptional_entry(entry)) {
 			vmf->page = entry;
-		} else {
-			unlock_mapping_entry(mapping, vmf->pgoff);
-			i_mmap_lock_read(mapping);
-			vmf->page = NULL;
+			return VM_FAULT_LOCKED;
 		}
-		return VM_FAULT_LOCKED;
+		vmf->entry = entry;
+		return VM_FAULT_DAX_LOCKED;
 	}
 
 	if (!buffer_mapped(&bh)) {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index d3d788b44d66..4ba71bdc0669 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -22,12 +22,19 @@ void dax_wake_mapping_entry_waiter(struct address_space *mapping,
 
 #ifdef CONFIG_FS_DAX
 struct page *read_dax_sector(struct block_device *bdev, sector_t n);
+void dax_unlock_mapping_entry(struct address_space *mapping, pgoff_t index);
 #else
 static inline struct page *read_dax_sector(struct block_device *bdev,
 		sector_t n)
 {
 	return ERR_PTR(-ENXIO);
 }
+/* Shouldn't ever be called when dax is disabled. */
+static inline void dax_unlock_mapping_entry(struct address_space *mapping,
+					    pgoff_t index)
+{
+	BUG();
+}
 #endif
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 864d7221de84..c08bf7b6903f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -299,6 +299,12 @@ struct vm_fault {
 					 * is set (which is also implied by
 					 * VM_FAULT_ERROR).
 					 */
+	void *entry;			/* ->fault handler can alternatively
+					 * return locked DAX entry. In that
+					 * case handler should return
+					 * VM_FAULT_DAX_LOCKED and fill in
+					 * entry here.
+					 */
 	/* for ->map_pages() only */
 	pgoff_t max_pgoff;		/* map pages for offset from pgoff till
 					 * max_pgoff inclusive */
@@ -1086,6 +1092,7 @@ static inline void clear_page_pfmemalloc(struct page *page)
 #define VM_FAULT_LOCKED	0x0200	/* ->fault locked the returned page */
 #define VM_FAULT_RETRY	0x0400	/* ->fault blocked, must retry */
 #define VM_FAULT_FALLBACK 0x0800	/* huge page fault failed, fall back to small */
+#define VM_FAULT_DAX_LOCKED 0x1000	/* ->fault has locked DAX entry */
 
 #define VM_FAULT_HWPOISON_LARGE_MASK 0xf000 /* encodes hpage index for large hwpoison */
 
diff --git a/mm/memory.c b/mm/memory.c
index 52c218e2b724..7f063c9ad711 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -63,6 +63,7 @@
 #include <linux/dma-debug.h>
 #include <linux/debugfs.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/dax.h>
 
 #include <asm/io.h>
 #include <asm/mmu_context.h>
@@ -2818,7 +2819,8 @@ oom:
  */
 static int __do_fault(struct vm_area_struct *vma, unsigned long address,
 			pgoff_t pgoff, unsigned int flags,
-			struct page *cow_page, struct page **page)
+			struct page *cow_page, struct page **page,
+			void **entry)
 {
 	struct vm_fault vmf;
 	int ret;
@@ -2833,8 +2835,10 @@ static int __do_fault(struct vm_area_struct *vma, unsigned long address,
 	ret = vma->vm_ops->fault(vma, &vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
-	if (!vmf.page)
-		goto out;
+	if (ret & VM_FAULT_DAX_LOCKED) {
+		*entry = vmf.entry;
+		return ret;
+	}
 
 	if (unlikely(PageHWPoison(vmf.page))) {
 		if (ret & VM_FAULT_LOCKED)
@@ -2848,7 +2852,6 @@ static int __do_fault(struct vm_area_struct *vma, unsigned long address,
 	else
 		VM_BUG_ON_PAGE(!PageLocked(vmf.page), vmf.page);
 
- out:
 	*page = vmf.page;
 	return ret;
 }
@@ -3020,7 +3023,7 @@ static int do_read_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		pte_unmap_unlock(pte, ptl);
 	}
 
-	ret = __do_fault(vma, address, pgoff, flags, NULL, &fault_page);
+	ret = __do_fault(vma, address, pgoff, flags, NULL, &fault_page, NULL);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
@@ -3043,6 +3046,7 @@ static int do_cow_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		pgoff_t pgoff, unsigned int flags, pte_t orig_pte)
 {
 	struct page *fault_page, *new_page;
+	void *fault_entry;
 	struct mem_cgroup *memcg;
 	spinlock_t *ptl;
 	pte_t *pte;
@@ -3060,26 +3064,24 @@ static int do_cow_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		return VM_FAULT_OOM;
 	}
 
-	ret = __do_fault(vma, address, pgoff, flags, new_page, &fault_page);
+	ret = __do_fault(vma, address, pgoff, flags, new_page, &fault_page,
+			 &fault_entry);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
 
-	if (fault_page)
+	if (!(ret & VM_FAULT_DAX_LOCKED))
 		copy_user_highpage(new_page, fault_page, address, vma);
 	__SetPageUptodate(new_page);
 
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (unlikely(!pte_same(*pte, orig_pte))) {
 		pte_unmap_unlock(pte, ptl);
-		if (fault_page) {
+		if (!(ret & VM_FAULT_DAX_LOCKED)) {
 			unlock_page(fault_page);
 			put_page(fault_page);
 		} else {
-			/*
-			 * The fault handler has no page to lock, so it holds
-			 * i_mmap_lock for read to protect against truncate.
-			 */
-			i_mmap_unlock_read(vma->vm_file->f_mapping);
+			dax_unlock_mapping_entry(vma->vm_file->f_mapping,
+						 pgoff);
 		}
 		goto uncharge_out;
 	}
@@ -3087,15 +3089,11 @@ static int do_cow_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	mem_cgroup_commit_charge(new_page, memcg, false, false);
 	lru_cache_add_active_or_unevictable(new_page, vma);
 	pte_unmap_unlock(pte, ptl);
-	if (fault_page) {
+	if (!(ret & VM_FAULT_DAX_LOCKED)) {
 		unlock_page(fault_page);
 		put_page(fault_page);
 	} else {
-		/*
-		 * The fault handler has no page to lock, so it holds
-		 * i_mmap_lock for read to protect against truncate.
-		 */
-		i_mmap_unlock_read(vma->vm_file->f_mapping);
+		dax_unlock_mapping_entry(vma->vm_file->f_mapping, pgoff);
 	}
 	return ret;
 uncharge_out:
@@ -3115,7 +3113,7 @@ static int do_shared_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	int dirtied = 0;
 	int ret, tmp;
 
-	ret = __do_fault(vma, address, pgoff, flags, NULL, &fault_page);
+	ret = __do_fault(vma, address, pgoff, flags, NULL, &fault_page, NULL);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
