Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BE27E1A1E30
 for <linux-nvdimm@lists.01.org>; Tue, 27 Sep 2016 09:08:35 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/20] mm: Allow full handling of COW faults in ->fault
 handlers
Date: Tue, 27 Sep 2016 18:08:12 +0200
Message-Id: <1474992504-20133-9-git-send-email-jack@suse.cz>
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

To allow full handling of COW faults add memcg field to struct vm_fault
and a return value of ->fault() handler meaning that COW fault is fully
handled and memcg charge must not be canceled. This will allow us to
remove knowledge about special DAX locking from the generic fault code.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/mm.h | 4 +++-
 mm/memory.c        | 8 +++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c908fd7243ea..faa77b15e9a6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -303,7 +303,8 @@ struct vm_fault {
 					 * the 'address' */
 	pte_t orig_pte;			/* Value of PTE at the time of fault */
 
-	struct page *cow_page;		/* Handler may choose to COW */
+	struct page *cow_page;		/* Page handler may use for COW fault */
+	struct mem_cgroup *memcg;	/* Cgroup cow_page belongs to */
 	struct page *page;		/* ->fault handlers should return a
 					 * page here, unless VM_FAULT_NOPAGE
 					 * is set (which is also implied by
@@ -1117,6 +1118,7 @@ static inline void clear_page_pfmemalloc(struct page *page)
 #define VM_FAULT_RETRY	0x0400	/* ->fault blocked, must retry */
 #define VM_FAULT_FALLBACK 0x0800	/* huge page fault failed, fall back to small */
 #define VM_FAULT_DAX_LOCKED 0x1000	/* ->fault has locked DAX entry */
+#define VM_FAULT_DONE_COW   0x2000	/* ->fault has fully handled COW */
 
 #define VM_FAULT_HWPOISON_LARGE_MASK 0xf000 /* encodes hpage index for large hwpoison */
 
diff --git a/mm/memory.c b/mm/memory.c
index 0c8779c23925..17db88a38e8a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2844,9 +2844,8 @@ static int __do_fault(struct vm_fault *vmf)
 	int ret;
 
 	ret = vma->vm_ops->fault(vma, vmf);
-	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
-		return ret;
-	if (ret & VM_FAULT_DAX_LOCKED)
+	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
+			    VM_FAULT_DAX_LOCKED | VM_FAULT_DONE_COW)))
 		return ret;
 
 	if (unlikely(PageHWPoison(vmf->page))) {
@@ -3205,9 +3204,12 @@ static int do_cow_fault(struct vm_fault *vmf)
 	}
 
 	vmf->cow_page = new_page;
+	vmf->memcg = memcg;
 	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
+	if (ret & VM_FAULT_DONE_COW)
+		return ret;
 
 	if (!(ret & VM_FAULT_DAX_LOCKED))
 		copy_user_highpage(new_page, vmf->page, vmf->address, vma);
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
