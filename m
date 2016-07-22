Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5876F1A1E02
 for <linux-nvdimm@lists.01.org>; Fri, 22 Jul 2016 05:20:44 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/15] mm: Add pmd and orig_pte fields to vm_fault
Date: Fri, 22 Jul 2016 14:19:29 +0200
Message-Id: <1469189981-19000-4-git-send-email-jack@suse.cz>
In-Reply-To: <1469189981-19000-1-git-send-email-jack@suse.cz>
References: <1469189981-19000-1-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add pmd and orig_pte fields to struct vm_fault to allow ->fault or
->page_mkwrite handlers to fully handle the fault. Actually pmd could be
looked up with the already available information but it is unnecessary
to force this upon the handler when we have the value easily available.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 54 ++++++++++++++++++++++++++++++------------------------
 2 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ece042dfe23c..dfb59b1f3584 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -309,6 +309,8 @@ struct vm_fault {
 					 * VM_FAULT_DAX_LOCKED and fill in
 					 * entry here.
 					 */
+	pmd_t *pmd;			/* PMD we fault into */
+	pte_t orig_pte;			/* Value of PTE at the time of fault */
 	/* for ->map_pages() only */
 	pgoff_t max_pgoff;		/* map pages for offset from pgoff till
 					 * max_pgoff inclusive */
diff --git a/mm/memory.c b/mm/memory.c
index 651accbe34cc..3c8bc4f08ee2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2014,7 +2014,8 @@ static gfp_t __get_fault_gfp_mask(struct vm_area_struct *vma)
 }
 
 static void init_vmf(struct vm_fault *vmf, struct vm_area_struct *vma,
-		     unsigned long address, pgoff_t pgoff, unsigned int flags)
+		     unsigned long address, pmd_t *pmd, pgoff_t pgoff,
+		     unsigned int flags, pte_t orig_pte)
 {
 	vmf->virtual_address = (void __user *)(address & PAGE_MASK);
 	vmf->pgoff = pgoff;
@@ -2022,6 +2023,8 @@ static void init_vmf(struct vm_fault *vmf, struct vm_area_struct *vma,
 	vmf->page = NULL;
 	vmf->gfp_mask = __get_fault_gfp_mask(vma);
 	vmf->cow_page = NULL;
+	vmf->pmd = pmd;
+	vmf->orig_pte = orig_pte;
 }
 
 /*
@@ -2031,13 +2034,13 @@ static void init_vmf(struct vm_fault *vmf, struct vm_area_struct *vma,
  * We do this without the lock held, so that it can sleep if it needs to.
  */
 static int do_page_mkwrite(struct vm_area_struct *vma, struct page *page,
-	       unsigned long address)
+	       unsigned long address, pmd_t *pmd, pte_t orig_pte)
 {
 	struct vm_fault vmf;
 	int ret;
 
-	init_vmf(&vmf, vma, address, page->index,
-		 FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE);
+	init_vmf(&vmf, vma, address, pmd, page->index,
+		 FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE, orig_pte);
 	vmf.page = page;
 
 	ret = vma->vm_ops->page_mkwrite(vma, &vmf);
@@ -2271,8 +2274,9 @@ static int wp_pfn_shared(struct mm_struct *mm,
 		int ret;
 
 		pte_unmap_unlock(page_table, ptl);
-		init_vmf(&vmf, vma, address, linear_page_index(vma, address),
-			 FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE);
+		init_vmf(&vmf, vma, address, pmd,
+			 linear_page_index(vma, address),
+			 FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE, orig_pte);
 		ret = vma->vm_ops->pfn_mkwrite(vma, &vmf);
 		if (ret & VM_FAULT_ERROR)
 			return ret;
@@ -2304,7 +2308,7 @@ static int wp_page_shared(struct mm_struct *mm, struct vm_area_struct *vma,
 		int tmp;
 
 		pte_unmap_unlock(page_table, ptl);
-		tmp = do_page_mkwrite(vma, old_page, address);
+		tmp = do_page_mkwrite(vma, old_page, address, pmd, orig_pte);
 		if (unlikely(!tmp || (tmp &
 				      (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
 			put_page(old_page);
@@ -2986,14 +2990,15 @@ static void do_fault_around(struct vm_area_struct *vma, struct vm_fault *vmf,
 		pte++;
 	}
 
-	init_vmf(&vmfaround, vma, start_addr, pgoff, vmf->flags);
+	init_vmf(&vmfaround, vma, start_addr, vmf->pmd, pgoff, vmf->flags,
+		 vmf->orig_pte);
 	vmfaround.pte = pte;
 	vmfaround.max_pgoff = max_pgoff;
 	vma->vm_ops->map_pages(vma, &vmfaround);
 }
 
 static int do_read_fault(struct mm_struct *mm, struct vm_area_struct *vma,
-		pmd_t *pmd, pte_t orig_pte, struct vm_fault *vmf)
+		struct vm_fault *vmf)
 {
 	spinlock_t *ptl;
 	pte_t *pte;
@@ -3006,9 +3011,9 @@ static int do_read_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * something).
 	 */
 	if (vma->vm_ops->map_pages && fault_around_bytes >> PAGE_SHIFT > 1) {
-		pte = pte_offset_map_lock(mm, pmd, address, &ptl);
+		pte = pte_offset_map_lock(mm, vmf->pmd, address, &ptl);
 		do_fault_around(vma, vmf, pte);
-		if (!pte_same(*pte, orig_pte))
+		if (!pte_same(*pte, vmf->orig_pte))
 			goto unlock_out;
 		pte_unmap_unlock(pte, ptl);
 	}
@@ -3017,8 +3022,8 @@ static int do_read_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
-	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
-	if (unlikely(!pte_same(*pte, orig_pte))) {
+	pte = pte_offset_map_lock(mm, vmf->pmd, address, &ptl);
+	if (unlikely(!pte_same(*pte, vmf->orig_pte))) {
 		pte_unmap_unlock(pte, ptl);
 		unlock_page(vmf->page);
 		put_page(vmf->page);
@@ -3032,7 +3037,7 @@ unlock_out:
 }
 
 static int do_cow_fault(struct mm_struct *mm, struct vm_area_struct *vma,
-		pmd_t *pmd, pte_t orig_pte, struct vm_fault *vmf)
+		struct vm_fault *vmf)
 {
 	struct page *new_page;
 	struct mem_cgroup *memcg;
@@ -3062,8 +3067,8 @@ static int do_cow_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		copy_user_highpage(new_page, vmf->page, address, vma);
 	__SetPageUptodate(new_page);
 
-	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
-	if (unlikely(!pte_same(*pte, orig_pte))) {
+	pte = pte_offset_map_lock(mm, vmf->pmd, address, &ptl);
+	if (unlikely(!pte_same(*pte, vmf->orig_pte))) {
 		pte_unmap_unlock(pte, ptl);
 		if (!(ret & VM_FAULT_DAX_LOCKED)) {
 			unlock_page(vmf->page);
@@ -3092,7 +3097,7 @@ uncharge_out:
 }
 
 static int do_shared_fault(struct mm_struct *mm, struct vm_area_struct *vma,
-		pmd_t *pmd, pte_t orig_pte, struct vm_fault *vmf)
+		struct vm_fault *vmf)
 {
 	struct address_space *mapping;
 	unsigned long address = (unsigned long)vmf->virtual_address;
@@ -3111,7 +3116,8 @@ static int do_shared_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 */
 	if (vma->vm_ops->page_mkwrite) {
 		unlock_page(vmf->page);
-		tmp = do_page_mkwrite(vma, vmf->page, address);
+		tmp = do_page_mkwrite(vma, vmf->page, address, vmf->pmd,
+				      vmf->orig_pte);
 		if (unlikely(!tmp ||
 				(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
 			put_page(vmf->page);
@@ -3119,8 +3125,8 @@ static int do_shared_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		}
 	}
 
-	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
-	if (unlikely(!pte_same(*pte, orig_pte))) {
+	pte = pte_offset_map_lock(mm, vmf->pmd, address, &ptl);
+	if (unlikely(!pte_same(*pte, vmf->orig_pte))) {
 		pte_unmap_unlock(pte, ptl);
 		unlock_page(vmf->page);
 		put_page(vmf->page);
@@ -3170,12 +3176,12 @@ static int do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	/* The VMA was not fully populated on mmap() or missing VM_DONTEXPAND */
 	if (!vma->vm_ops->fault)
 		return VM_FAULT_SIGBUS;
-	init_vmf(&vmf, vma, address, pgoff, flags);
+	init_vmf(&vmf, vma, address, pmd, pgoff, flags, orig_pte);
 	if (!(flags & FAULT_FLAG_WRITE))
-		return do_read_fault(mm, vma, pmd, orig_pte, &vmf);
+		return do_read_fault(mm, vma, &vmf);
 	if (!(vma->vm_flags & VM_SHARED))
-		return do_cow_fault(mm, vma, pmd, orig_pte, &vmf);
-	return do_shared_fault(mm, vma, pmd, orig_pte, &vmf);
+		return do_cow_fault(mm, vma, &vmf);
+	return do_shared_fault(mm, vma, &vmf);
 }
 
 static int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
