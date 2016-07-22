Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D7F9D1A1E0A
 for <linux-nvdimm@lists.01.org>; Fri, 22 Jul 2016 05:20:45 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 12/15] mm: Lift vm_fault structure creation from
 do_page_mkwrite()
Date: Fri, 22 Jul 2016 14:19:38 +0200
Message-Id: <1469189981-19000-13-git-send-email-jack@suse.cz>
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

Move creation of struct vm_fault up from do_page_mkwrite() to avoid
passing some parameters and actually safe creating it in one case.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/memory.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index c3f639c33232..1d2916c53d43 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2033,17 +2033,12 @@ static void init_vmf(struct vm_fault *vmf, struct vm_area_struct *vma,
  *
  * We do this without the lock held, so that it can sleep if it needs to.
  */
-static int do_page_mkwrite(struct vm_area_struct *vma, struct page *page,
-	       unsigned long address, pmd_t *pmd, pte_t orig_pte)
+static int do_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	struct vm_fault vmf;
 	int ret;
+	struct page *page = vmf->page;
 
-	init_vmf(&vmf, vma, address, pmd, page->index,
-		 FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE, orig_pte);
-	vmf.page = page;
-
-	ret = vma->vm_ops->page_mkwrite(vma, &vmf);
+	ret = vma->vm_ops->page_mkwrite(vma, vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
 		return ret;
 	if (unlikely(!(ret & VM_FAULT_LOCKED))) {
@@ -2311,9 +2306,14 @@ static int wp_page_shared(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	if (vma->vm_ops->page_mkwrite) {
 		int tmp;
+		struct vm_fault vmf;
 
 		pte_unmap_unlock(page_table, ptl);
-		tmp = do_page_mkwrite(vma, old_page, address, pmd, orig_pte);
+
+		init_vmf(&vmf, vma, address, pmd, old_page->index,
+			 FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE, orig_pte);
+		vmf.page = old_page;
+		tmp = do_page_mkwrite(vma, &vmf);
 		if (unlikely(!tmp || (tmp &
 				      (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
 			put_page(old_page);
@@ -3137,7 +3137,6 @@ uncharge_out:
 static int do_shared_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct vm_fault *vmf)
 {
-	unsigned long address = (unsigned long)vmf->virtual_address;
 	int ret, tmp;
 
 	ret = __do_fault(vma, vmf);
@@ -3150,8 +3149,8 @@ static int do_shared_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 */
 	if (vma->vm_ops->page_mkwrite) {
 		unlock_page(vmf->page);
-		tmp = do_page_mkwrite(vma, vmf->page, address, vmf->pmd,
-				      vmf->orig_pte);
+		vmf->flags = FAULT_FLAG_WRITE | FAULT_FLAG_MKWRITE;
+		tmp = do_page_mkwrite(vma, vmf);
 		if (unlikely(!tmp ||
 				(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
 			put_page(vmf->page);
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
