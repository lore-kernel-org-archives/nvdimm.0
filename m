Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4FEF21A1E1B
 for <linux-nvdimm@lists.01.org>; Tue, 27 Sep 2016 09:08:34 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 04/20] mm: Use passed vm_fault structure in __do_fault()
Date: Tue, 27 Sep 2016 18:08:08 +0200
Message-Id: <1474992504-20133-5-git-send-email-jack@suse.cz>
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

Instead of creating another vm_fault structure, use the one passed to
__do_fault() for passing arguments into fault handler.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/memory.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 4c2ec9a9d8af..b7f1f535e079 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2848,37 +2848,31 @@ static int __do_fault(struct vm_fault *vmf, struct page *cow_page,
 		      struct page **page, void **entry)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct vm_fault vmf2;
 	int ret;
 
-	vmf2.virtual_address = vmf->address & PAGE_MASK;
-	vmf2.pgoff = vmf->pgoff;
-	vmf2.flags = vmf->flags;
-	vmf2.page = NULL;
-	vmf2.gfp_mask = __get_fault_gfp_mask(vma);
-	vmf2.cow_page = cow_page;
+	vmf->cow_page = cow_page;
 
-	ret = vma->vm_ops->fault(vma, &vmf2);
+	ret = vma->vm_ops->fault(vma, vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 	if (ret & VM_FAULT_DAX_LOCKED) {
-		*entry = vmf2.entry;
+		*entry = vmf->entry;
 		return ret;
 	}
 
-	if (unlikely(PageHWPoison(vmf2.page))) {
+	if (unlikely(PageHWPoison(vmf->page))) {
 		if (ret & VM_FAULT_LOCKED)
-			unlock_page(vmf2.page);
-		put_page(vmf2.page);
+			unlock_page(vmf->page);
+		put_page(vmf->page);
 		return VM_FAULT_HWPOISON;
 	}
 
 	if (unlikely(!(ret & VM_FAULT_LOCKED)))
-		lock_page(vmf2.page);
+		lock_page(vmf->page);
 	else
-		VM_BUG_ON_PAGE(!PageLocked(vmf2.page), vmf2.page);
+		VM_BUG_ON_PAGE(!PageLocked(vmf->page), vmf->page);
 
-	*page = vmf2.page;
+	*page = vmf->page;
 	return ret;
 }
 
@@ -3573,8 +3567,10 @@ static int __handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 	struct vm_fault vmf = {
 		.vma = vma,
 		.address = address,
+		.virtual_address = address & PAGE_MASK,
 		.flags = flags,
 		.pgoff = linear_page_index(vma, address),
+		.gfp_mask = __get_fault_gfp_mask(vma),
 	};
 	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgd;
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
