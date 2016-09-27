Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F7501A1E26
 for <linux-nvdimm@lists.01.org>; Tue, 27 Sep 2016 09:08:35 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 05/20] mm: Trim __do_fault() arguments
Date: Tue, 27 Sep 2016 18:08:09 +0200
Message-Id: <1474992504-20133-6-git-send-email-jack@suse.cz>
In-Reply-To: <1474992504-20133-1-git-send-email-jack@suse.cz>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Use vm_fault structure to pass cow_page, page, and entry in and out of
the function. That reduces number of __do_fault() arguments from 4 to 1.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/memory.c | 53 +++++++++++++++++++++++------------------------------
 1 file changed, 23 insertions(+), 30 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index b7f1f535e079..ba7760fb7db2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2844,26 +2844,22 @@ oom:
  * released depending on flags and vma->vm_ops->fault() return value.
  * See filemap_fault() and __lock_page_retry().
  */
-static int __do_fault(struct vm_fault *vmf, struct page *cow_page,
-		      struct page **page, void **entry)
+static int __do_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	int ret;
 
-	vmf->cow_page = cow_page;
-
 	ret = vma->vm_ops->fault(vma, vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
-	if (ret & VM_FAULT_DAX_LOCKED) {
-		*entry = vmf->entry;
+	if (ret & VM_FAULT_DAX_LOCKED)
 		return ret;
-	}
 
 	if (unlikely(PageHWPoison(vmf->page))) {
 		if (ret & VM_FAULT_LOCKED)
 			unlock_page(vmf->page);
 		put_page(vmf->page);
+		vmf->page = NULL;
 		return VM_FAULT_HWPOISON;
 	}
 
@@ -2872,7 +2868,6 @@ static int __do_fault(struct vm_fault *vmf, struct page *cow_page,
 	else
 		VM_BUG_ON_PAGE(!PageLocked(vmf->page), vmf->page);
 
-	*page = vmf->page;
 	return ret;
 }
 
@@ -3169,7 +3164,6 @@ out:
 static int do_read_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct page *fault_page;
 	int ret = 0;
 
 	/*
@@ -3183,24 +3177,23 @@ static int do_read_fault(struct vm_fault *vmf)
 			return ret;
 	}
 
-	ret = __do_fault(vmf, NULL, &fault_page, NULL);
+	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
-	ret |= alloc_set_pte(vmf, NULL, fault_page);
+	ret |= alloc_set_pte(vmf, NULL, vmf->page);
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-	unlock_page(fault_page);
+	unlock_page(vmf->page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
-		put_page(fault_page);
+		put_page(vmf->page);
 	return ret;
 }
 
 static int do_cow_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct page *fault_page, *new_page;
-	void *fault_entry;
+	struct page *new_page;
 	struct mem_cgroup *memcg;
 	int ret;
 
@@ -3217,20 +3210,21 @@ static int do_cow_fault(struct vm_fault *vmf)
 		return VM_FAULT_OOM;
 	}
 
-	ret = __do_fault(vmf, new_page, &fault_page, &fault_entry);
+	vmf->cow_page = new_page;
+	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
 
 	if (!(ret & VM_FAULT_DAX_LOCKED))
-		copy_user_highpage(new_page, fault_page, vmf->address, vma);
+		copy_user_highpage(new_page, vmf->page, vmf->address, vma);
 	__SetPageUptodate(new_page);
 
 	ret |= alloc_set_pte(vmf, memcg, new_page);
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 	if (!(ret & VM_FAULT_DAX_LOCKED)) {
-		unlock_page(fault_page);
-		put_page(fault_page);
+		unlock_page(vmf->page);
+		put_page(vmf->page);
 	} else {
 		dax_unlock_mapping_entry(vma->vm_file->f_mapping, vmf->pgoff);
 	}
@@ -3246,12 +3240,11 @@ uncharge_out:
 static int do_shared_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct page *fault_page;
 	struct address_space *mapping;
 	int dirtied = 0;
 	int ret, tmp;
 
-	ret = __do_fault(vmf, NULL, &fault_page, NULL);
+	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
@@ -3260,26 +3253,26 @@ static int do_shared_fault(struct vm_fault *vmf)
 	 * about to become writable
 	 */
 	if (vma->vm_ops->page_mkwrite) {
-		unlock_page(fault_page);
-		tmp = do_page_mkwrite(vma, fault_page, vmf->address);
+		unlock_page(vmf->page);
+		tmp = do_page_mkwrite(vma, vmf->page, vmf->address);
 		if (unlikely(!tmp ||
 				(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
-			put_page(fault_page);
+			put_page(vmf->page);
 			return tmp;
 		}
 	}
 
-	ret |= alloc_set_pte(vmf, NULL, fault_page);
+	ret |= alloc_set_pte(vmf, NULL, vmf->page);
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
 					VM_FAULT_RETRY))) {
-		unlock_page(fault_page);
-		put_page(fault_page);
+		unlock_page(vmf->page);
+		put_page(vmf->page);
 		return ret;
 	}
 
-	if (set_page_dirty(fault_page))
+	if (set_page_dirty(vmf->page))
 		dirtied = 1;
 	/*
 	 * Take a local copy of the address_space - page.mapping may be zeroed
@@ -3287,8 +3280,8 @@ static int do_shared_fault(struct vm_fault *vmf)
 	 * pinned by vma->vm_file's reference.  We rely on unlock_page()'s
 	 * release semantics to prevent the compiler from undoing this copying.
 	 */
-	mapping = page_rmapping(fault_page);
-	unlock_page(fault_page);
+	mapping = page_rmapping(vmf->page);
+	unlock_page(vmf->page);
 	if ((dirtied || vma->vm_ops->page_mkwrite) && mapping) {
 		/*
 		 * Some device drivers do not set page.mapping but still
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
