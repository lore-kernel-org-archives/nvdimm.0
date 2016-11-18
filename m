Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 67ED981EDC
 for <linux-nvdimm@lists.01.org>; Fri, 18 Nov 2016 01:17:26 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 09/20] mm: Factor out functionality to finish page faults
Date: Fri, 18 Nov 2016 10:17:13 +0100
Message-Id: <1479460644-25076-10-git-send-email-jack@suse.cz>
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

Introduce function finish_fault() as a helper function for finishing
page faults. It is rather thin wrapper around alloc_set_pte() but since
we'd want to call this from DAX code or filesystems, it is still useful
to avoid some boilerplate code.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/mm.h |  1 +
 mm/memory.c        | 44 +++++++++++++++++++++++++++++++++++---------
 2 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 34d2891e9195..482455952f03 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -620,6 +620,7 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 
 int alloc_set_pte(struct vm_fault *vmf, struct mem_cgroup *memcg,
 		struct page *page);
+int finish_fault(struct vm_fault *vmf);
 #endif
 
 /*
diff --git a/mm/memory.c b/mm/memory.c
index 21a4a193a6c2..ba49e5bacf17 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3033,6 +3033,38 @@ int alloc_set_pte(struct vm_fault *vmf, struct mem_cgroup *memcg,
 	return 0;
 }
 
+
+/**
+ * finish_fault - finish page fault once we have prepared the page to fault
+ *
+ * @vmf: structure describing the fault
+ *
+ * This function handles all that is needed to finish a page fault once the
+ * page to fault in is prepared. It handles locking of PTEs, inserts PTE for
+ * given page, adds reverse page mapping, handles memcg charges and LRU
+ * addition. The function returns 0 on success, VM_FAULT_ code in case of
+ * error.
+ *
+ * The function expects the page to be locked and on success it consumes a
+ * reference of a page being mapped (for the PTE which maps it).
+ */
+int finish_fault(struct vm_fault *vmf)
+{
+	struct page *page;
+	int ret;
+
+	/* Did we COW the page? */
+	if ((vmf->flags & FAULT_FLAG_WRITE) &&
+	    !(vmf->vma->vm_flags & VM_SHARED))
+		page = vmf->cow_page;
+	else
+		page = vmf->page;
+	ret = alloc_set_pte(vmf, vmf->memcg, page);
+	if (vmf->pte)
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+	return ret;
+}
+
 static unsigned long fault_around_bytes __read_mostly =
 	rounddown_pow_of_two(65536);
 
@@ -3178,9 +3210,7 @@ static int do_read_fault(struct vm_fault *vmf)
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
-	ret |= alloc_set_pte(vmf, NULL, vmf->page);
-	if (vmf->pte)
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
+	ret |= finish_fault(vmf);
 	unlock_page(vmf->page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		put_page(vmf->page);
@@ -3215,9 +3245,7 @@ static int do_cow_fault(struct vm_fault *vmf)
 		copy_user_highpage(vmf->cow_page, vmf->page, vmf->address, vma);
 	__SetPageUptodate(vmf->cow_page);
 
-	ret |= alloc_set_pte(vmf, vmf->memcg, vmf->cow_page);
-	if (vmf->pte)
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
+	ret |= finish_fault(vmf);
 	if (!(ret & VM_FAULT_DAX_LOCKED)) {
 		unlock_page(vmf->page);
 		put_page(vmf->page);
@@ -3258,9 +3286,7 @@ static int do_shared_fault(struct vm_fault *vmf)
 		}
 	}
 
-	ret |= alloc_set_pte(vmf, NULL, vmf->page);
-	if (vmf->pte)
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
+	ret |= finish_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
 					VM_FAULT_RETRY))) {
 		unlock_page(vmf->page);
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
