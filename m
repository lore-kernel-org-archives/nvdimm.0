Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A81141A1E2F
 for <linux-nvdimm@lists.01.org>; Tue, 27 Sep 2016 09:08:35 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/20] mm: Use pgoff in struct vm_fault instead of passing it
 separately
Date: Tue, 27 Sep 2016 18:08:07 +0200
Message-Id: <1474992504-20133-4-git-send-email-jack@suse.cz>
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

struct vm_fault has already pgoff entry. Use it instead of passing pgoff
as a separate argument and then assigning it later.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/memory.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 447a1ef4a9e3..4c2ec9a9d8af 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2275,7 +2275,7 @@ static int wp_pfn_shared(struct vm_fault *vmf, pte_t orig_pte)
 	if (vma->vm_ops && vma->vm_ops->pfn_mkwrite) {
 		struct vm_fault vmf2 = {
 			.page = NULL,
-			.pgoff = linear_page_index(vma, vmf->address),
+			.pgoff = vmf->pgoff,
 			.virtual_address = vmf->address & PAGE_MASK,
 			.flags = FAULT_FLAG_WRITE | FAULT_FLAG_MKWRITE,
 		};
@@ -2844,15 +2844,15 @@ oom:
  * released depending on flags and vma->vm_ops->fault() return value.
  * See filemap_fault() and __lock_page_retry().
  */
-static int __do_fault(struct vm_fault *vmf, pgoff_t pgoff,
-		struct page *cow_page, struct page **page, void **entry)
+static int __do_fault(struct vm_fault *vmf, struct page *cow_page,
+		      struct page **page, void **entry)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct vm_fault vmf2;
 	int ret;
 
 	vmf2.virtual_address = vmf->address & PAGE_MASK;
-	vmf2.pgoff = pgoff;
+	vmf2.pgoff = vmf->pgoff;
 	vmf2.flags = vmf->flags;
 	vmf2.page = NULL;
 	vmf2.gfp_mask = __get_fault_gfp_mask(vma);
@@ -3111,9 +3111,10 @@ late_initcall(fault_around_debugfs);
  * fault_around_pages() value (and therefore to page order).  This way it's
  * easier to guarantee that we don't cross page table boundaries.
  */
-static int do_fault_around(struct vm_fault *vmf, pgoff_t start_pgoff)
+static int do_fault_around(struct vm_fault *vmf)
 {
 	unsigned long address = vmf->address, nr_pages, mask;
+	pgoff_t start_pgoff = vmf->pgoff;
 	pgoff_t end_pgoff;
 	int off, ret = 0;
 
@@ -3171,7 +3172,7 @@ out:
 	return ret;
 }
 
-static int do_read_fault(struct vm_fault *vmf, pgoff_t pgoff)
+static int do_read_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *fault_page;
@@ -3183,12 +3184,12 @@ static int do_read_fault(struct vm_fault *vmf, pgoff_t pgoff)
 	 * something).
 	 */
 	if (vma->vm_ops->map_pages && fault_around_bytes >> PAGE_SHIFT > 1) {
-		ret = do_fault_around(vmf, pgoff);
+		ret = do_fault_around(vmf);
 		if (ret)
 			return ret;
 	}
 
-	ret = __do_fault(vmf, pgoff, NULL, &fault_page, NULL);
+	ret = __do_fault(vmf, NULL, &fault_page, NULL);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
@@ -3201,7 +3202,7 @@ static int do_read_fault(struct vm_fault *vmf, pgoff_t pgoff)
 	return ret;
 }
 
-static int do_cow_fault(struct vm_fault *vmf, pgoff_t pgoff)
+static int do_cow_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *fault_page, *new_page;
@@ -3222,7 +3223,7 @@ static int do_cow_fault(struct vm_fault *vmf, pgoff_t pgoff)
 		return VM_FAULT_OOM;
 	}
 
-	ret = __do_fault(vmf, pgoff, new_page, &fault_page, &fault_entry);
+	ret = __do_fault(vmf, new_page, &fault_page, &fault_entry);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
 
@@ -3237,7 +3238,7 @@ static int do_cow_fault(struct vm_fault *vmf, pgoff_t pgoff)
 		unlock_page(fault_page);
 		put_page(fault_page);
 	} else {
-		dax_unlock_mapping_entry(vma->vm_file->f_mapping, pgoff);
+		dax_unlock_mapping_entry(vma->vm_file->f_mapping, vmf->pgoff);
 	}
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
@@ -3248,7 +3249,7 @@ uncharge_out:
 	return ret;
 }
 
-static int do_shared_fault(struct vm_fault *vmf, pgoff_t pgoff)
+static int do_shared_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *fault_page;
@@ -3256,7 +3257,7 @@ static int do_shared_fault(struct vm_fault *vmf, pgoff_t pgoff)
 	int dirtied = 0;
 	int ret, tmp;
 
-	ret = __do_fault(vmf, pgoff, NULL, &fault_page, NULL);
+	ret = __do_fault(vmf, NULL, &fault_page, NULL);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
@@ -3317,16 +3318,15 @@ static int do_shared_fault(struct vm_fault *vmf, pgoff_t pgoff)
 static int do_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	pgoff_t pgoff = linear_page_index(vma, vmf->address);
 
 	/* The VMA was not fully populated on mmap() or missing VM_DONTEXPAND */
 	if (!vma->vm_ops->fault)
 		return VM_FAULT_SIGBUS;
 	if (!(vmf->flags & FAULT_FLAG_WRITE))
-		return do_read_fault(vmf, pgoff);
+		return do_read_fault(vmf);
 	if (!(vma->vm_flags & VM_SHARED))
-		return do_cow_fault(vmf, pgoff);
-	return do_shared_fault(vmf, pgoff);
+		return do_cow_fault(vmf);
+	return do_shared_fault(vmf);
 }
 
 static int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
@@ -3574,6 +3574,7 @@ static int __handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 		.vma = vma,
 		.address = address,
 		.flags = flags,
+		.pgoff = linear_page_index(vma, address),
 	};
 	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgd;
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
