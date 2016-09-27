Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3FDFC1A1E25
 for <linux-nvdimm@lists.01.org>; Tue, 27 Sep 2016 09:08:37 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 15/20] mm: Move part of wp_page_reuse() into the single call
 site
Date: Tue, 27 Sep 2016 18:08:19 +0200
Message-Id: <1474992504-20133-16-git-send-email-jack@suse.cz>
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

wp_page_reuse() handles write shared faults which is needed only in
wp_page_shared(). Move the handling only into that location to make
wp_page_reuse() simpler and avoid a strange situation when we sometimes
pass in locked page, sometimes unlocked etc.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/memory.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 98304eb7bff4..f49e736d6a36 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2099,8 +2099,7 @@ static void fault_dirty_shared_page(struct vm_area_struct *vma,
  * case, all we need to do here is to mark the page as writable and update
  * any related book-keeping.
  */
-static inline int wp_page_reuse(struct vm_fault *vmf,
-				int page_mkwrite, int dirty_shared)
+static inline void wp_page_reuse(struct vm_fault *vmf)
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -2120,16 +2119,6 @@ static inline int wp_page_reuse(struct vm_fault *vmf,
 	if (ptep_set_access_flags(vma, vmf->address, vmf->pte, entry, 1))
 		update_mmu_cache(vma, vmf->address, vmf->pte);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
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
@@ -2304,7 +2293,8 @@ static int wp_pfn_shared(struct vm_fault *vmf)
 			return 0;
 		}
 	}
-	return wp_page_reuse(vmf, 0, 0);
+	wp_page_reuse(vmf);
+	return VM_FAULT_WRITE;
 }
 
 static int wp_page_shared(struct vm_fault *vmf)
@@ -2342,7 +2332,13 @@ static int wp_page_shared(struct vm_fault *vmf)
 		page_mkwrite = 1;
 	}
 
-	return wp_page_reuse(vmf, page_mkwrite, 1);
+	wp_page_reuse(vmf);
+	if (!page_mkwrite)
+		lock_page(vmf->page);
+	fault_dirty_shared_page(vma, vmf->page);
+	put_page(vmf->page);
+
+	return VM_FAULT_WRITE;
 }
 
 /*
@@ -2417,7 +2413,8 @@ static int do_wp_page(struct vm_fault *vmf)
 				page_move_anon_rmap(vmf->page, vma);
 			}
 			unlock_page(vmf->page);
-			return wp_page_reuse(vmf, 0, 0);
+			wp_page_reuse(vmf);
+			return VM_FAULT_WRITE;
 		}
 		unlock_page(vmf->page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
