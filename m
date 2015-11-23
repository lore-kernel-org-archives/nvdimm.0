Return-Path: <owner-linux-mm@kvack.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH] dax: Split pmd map when fallback on COW
Date: Mon, 23 Nov 2015 13:05:20 -0700
Message-Id: <1448309120-20911-1-git-send-email-toshi.kani@hpe.com>
Sender: owner-linux-mm@kvack.org
To: dan.j.williams@intel.com
Cc: kirill.shutemov@linux.intel.com, willy@linux.intel.com, ross.zwisler@linux.intel.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

An infinite loop of PMD faults was observed when attempted to
mlock() a private read-only PMD mmap'd range of a DAX file.

__dax_pmd_fault() simply returns with VM_FAULT_FALLBACK when
falling back to PTE on COW.  However, __handle_mm_fault()
returns without falling back to handle_pte_fault() because
a PMD map is present in this case.

Change __dax_pmd_fault() to split the PMD map, if present,
before returning with VM_FAULT_FALLBACK.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 43671b6..3405583 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -546,8 +546,10 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		return VM_FAULT_FALLBACK;
 
 	/* Fall back to PTEs if we're going to COW */
-	if (write && !(vma->vm_flags & VM_SHARED))
+	if (write && !(vma->vm_flags & VM_SHARED)) {
+		split_huge_page_pmd(vma, address, pmd);
 		return VM_FAULT_FALLBACK;
+	}
 	/* If the PMD would extend outside the VMA */
 	if (pmd_addr < vma->vm_start)
 		return VM_FAULT_FALLBACK;

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
