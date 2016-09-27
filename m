Return-Path: <owner-linux-mm@kvack.org>
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/20] mm: Remove unnecessary vma->vm_ops check
Date: Tue, 27 Sep 2016 18:08:15 +0200
Message-Id: <1474992504-20133-12-git-send-email-jack@suse.cz>
In-Reply-To: <1474992504-20133-1-git-send-email-jack@suse.cz>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

We don't check whether vma->vm_ops is NULL in do_shared_fault() so
there's hardly any point in checking it in wp_page_shared() which gets
called only for shared file mappings as well.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index a4522e8999b2..63d9c1a54caf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2301,7 +2301,7 @@ static int wp_page_shared(struct vm_fault *vmf, struct page *old_page)
 
 	get_page(old_page);
 
-	if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
+	if (vma->vm_ops->page_mkwrite) {
 		int tmp;
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-- 
2.6.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
