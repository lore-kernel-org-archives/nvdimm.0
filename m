Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C0C1F1A1E07
 for <linux-nvdimm@lists.01.org>; Fri, 22 Jul 2016 05:20:45 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/15] mm: Move part of wp_page_reuse() into the single call
 site
Date: Fri, 22 Jul 2016 14:19:37 +0200
Message-Id: <1469189981-19000-12-git-send-email-jack@suse.cz>
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

wp_page_reuse() handles write shared faults which is needed only in
wp_page_shared(). Move the handling only into that location to make
wp_page_reuse() simpler.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/memory.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 56b5fe8421a9..c3f639c33232 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2101,11 +2101,10 @@ static void fault_dirty_shared_page(struct vm_area_struct *vma,
  * case, all we need to do here is to mark the page as writable and update
  * any related book-keeping.
  */
-static inline int wp_page_reuse(struct mm_struct *mm,
+static inline void wp_page_reuse(struct mm_struct *mm,
 			struct vm_area_struct *vma, unsigned long address,
 			pte_t *page_table, spinlock_t *ptl, pte_t orig_pte,
-			struct page *page, int page_mkwrite,
-			int dirty_shared)
+			struct page *page)
 	__releases(ptl)
 {
 	pte_t entry;
@@ -2123,16 +2122,6 @@ static inline int wp_page_reuse(struct mm_struct *mm,
 	if (ptep_set_access_flags(vma, address, page_table, entry, 1))
 		update_mmu_cache(vma, address, page_table);
 	pte_unmap_unlock(page_table, ptl);
-
-	if (dirty_shared) {
-		if (!page_mkwrite)
-			lock_page(page);
-
-		fault_dirty_shared_page(vma, page);
-		put_page(page);
-	}
-
-	return VM_FAULT_WRITE;
 }
 
 /*
@@ -2308,8 +2297,8 @@ static int wp_pfn_shared(struct mm_struct *mm,
 			return 0;
 		}
 	}
-	return wp_page_reuse(mm, vma, address, page_table, ptl, orig_pte,
-			     NULL, 0, 0);
+	wp_page_reuse(mm, vma, address, page_table, ptl, orig_pte, NULL);
+	return VM_FAULT_WRITE;
 }
 
 static int wp_page_shared(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -2318,8 +2307,6 @@ static int wp_page_shared(struct mm_struct *mm, struct vm_area_struct *vma,
 			  struct page *old_page)
 	__releases(ptl)
 {
-	int page_mkwrite = 0;
-
 	get_page(old_page);
 
 	if (vma->vm_ops->page_mkwrite) {
@@ -2346,11 +2333,17 @@ static int wp_page_shared(struct mm_struct *mm, struct vm_area_struct *vma,
 			put_page(old_page);
 			return 0;
 		}
-		page_mkwrite = 1;
+		wp_page_reuse(mm, vma, address, page_table, ptl, orig_pte,
+			      old_page);
+	} else {
+		wp_page_reuse(mm, vma, address, page_table, ptl, orig_pte,
+			      old_page);
+		lock_page(old_page);
 	}
 
-	return wp_page_reuse(mm, vma, address, page_table, ptl,
-			     orig_pte, old_page, page_mkwrite, 1);
+	fault_dirty_shared_page(vma, old_page);
+	put_page(old_page);
+	return VM_FAULT_WRITE;
 }
 
 /*
@@ -2429,8 +2422,9 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				page_move_anon_rmap(old_page, vma);
 			}
 			unlock_page(old_page);
-			return wp_page_reuse(mm, vma, address, page_table, ptl,
-					     orig_pte, old_page, 0, 0);
+			wp_page_reuse(mm, vma, address, page_table, ptl,
+				      orig_pte, old_page);
+			return VM_FAULT_WRITE;
 		}
 		unlock_page(old_page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
