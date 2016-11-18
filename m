Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 315F081F3E
 for <linux-nvdimm@lists.01.org>; Fri, 18 Nov 2016 01:17:28 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/20] mm: Factor out common parts of write fault handling
Date: Fri, 18 Nov 2016 10:17:15 +0100
Message-Id: <1479460644-25076-12-git-send-email-jack@suse.cz>
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

Currently we duplicate handling of shared write faults in
wp_page_reuse() and do_shared_fault(). Factor them out into a common
function.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/memory.c | 78 +++++++++++++++++++++++++++++--------------------------------
 1 file changed, 37 insertions(+), 41 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index e9e9224264da..139e115acf35 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2067,6 +2067,41 @@ static int do_page_mkwrite(struct vm_area_struct *vma, struct page *page,
 }
 
 /*
+ * Handle dirtying of a page in shared file mapping on a write fault.
+ *
+ * The function expects the page to be locked and unlocks it.
+ */
+static void fault_dirty_shared_page(struct vm_area_struct *vma,
+				    struct page *page)
+{
+	struct address_space *mapping;
+	bool dirtied;
+	bool page_mkwrite = vma->vm_ops && vma->vm_ops->page_mkwrite;
+
+	dirtied = set_page_dirty(page);
+	VM_BUG_ON_PAGE(PageAnon(page), page);
+	/*
+	 * Take a local copy of the address_space - page.mapping may be zeroed
+	 * by truncate after unlock_page().   The address_space itself remains
+	 * pinned by vma->vm_file's reference.  We rely on unlock_page()'s
+	 * release semantics to prevent the compiler from undoing this copying.
+	 */
+	mapping = page_rmapping(page);
+	unlock_page(page);
+
+	if ((dirtied || page_mkwrite) && mapping) {
+		/*
+		 * Some device drivers do not set page.mapping
+		 * but still dirty their pages
+		 */
+		balance_dirty_pages_ratelimited(mapping);
+	}
+
+	if (!page_mkwrite)
+		file_update_time(vma->vm_file);
+}
+
+/*
  * Handle write page faults for pages that can be reused in the current vma
  *
  * This can happen either due to the mapping being with the VM_SHARED flag,
@@ -2096,28 +2131,11 @@ static inline int wp_page_reuse(struct vm_fault *vmf, struct page *page,
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 
 	if (dirty_shared) {
-		struct address_space *mapping;
-		int dirtied;
-
 		if (!page_mkwrite)
 			lock_page(page);
 
-		dirtied = set_page_dirty(page);
-		VM_BUG_ON_PAGE(PageAnon(page), page);
-		mapping = page->mapping;
-		unlock_page(page);
+		fault_dirty_shared_page(vma, page);
 		put_page(page);
-
-		if ((dirtied || page_mkwrite) && mapping) {
-			/*
-			 * Some device drivers do not set page.mapping
-			 * but still dirty their pages
-			 */
-			balance_dirty_pages_ratelimited(mapping);
-		}
-
-		if (!page_mkwrite)
-			file_update_time(vma->vm_file);
 	}
 
 	return VM_FAULT_WRITE;
@@ -3259,8 +3277,6 @@ static int do_cow_fault(struct vm_fault *vmf)
 static int do_shared_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct address_space *mapping;
-	int dirtied = 0;
 	int ret, tmp;
 
 	ret = __do_fault(vmf);
@@ -3289,27 +3305,7 @@ static int do_shared_fault(struct vm_fault *vmf)
 		return ret;
 	}
 
-	if (set_page_dirty(vmf->page))
-		dirtied = 1;
-	/*
-	 * Take a local copy of the address_space - page.mapping may be zeroed
-	 * by truncate after unlock_page().   The address_space itself remains
-	 * pinned by vma->vm_file's reference.  We rely on unlock_page()'s
-	 * release semantics to prevent the compiler from undoing this copying.
-	 */
-	mapping = page_rmapping(vmf->page);
-	unlock_page(vmf->page);
-	if ((dirtied || vma->vm_ops->page_mkwrite) && mapping) {
-		/*
-		 * Some device drivers do not set page.mapping but still
-		 * dirty their pages
-		 */
-		balance_dirty_pages_ratelimited(mapping);
-	}
-
-	if (!vma->vm_ops->page_mkwrite)
-		file_update_time(vma->vm_file);
-
+	fault_dirty_shared_page(vma, vmf->page);
 	return ret;
 }
 
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
