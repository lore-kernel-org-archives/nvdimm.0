Return-Path: <owner-linux-mm@kvack.org>
Subject: [PATCH -mm 06/25] dax: Split pmd map when fallback on COW
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 07 Dec 2015 17:33:08 -0800
Message-ID: <20151208013308.25030.16548.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151208013236.25030.68781.stgit@dwillia2-desk3.jf.intel.com>
References: <20151208013236.25030.68781.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: akpm@linux-foundation.org
Cc: Toshi Kani <toshi.kani@hpe.com>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Toshi Kani <toshi.kani@hpe.com>

An infinite loop of PMD faults was observed when attempted to
mlock() a private read-only PMD mmap'd range of a DAX file.

__dax_pmd_fault() simply returns with VM_FAULT_FALLBACK when
falling back to PTE on COW.  However, __handle_mm_fault()
returns without falling back to handle_pte_fault() because
a PMD map is present in this case.

Change __dax_pmd_fault() to split the PMD map, if present,
before returning with VM_FAULT_FALLBACK.

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 68b04de71d19..88e7b3bfef21 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -578,8 +578,10 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		return VM_FAULT_FALLBACK;
 
 	/* Fall back to PTEs if we're going to COW */
-	if (write && !(vma->vm_flags & VM_SHARED))
+	if (write && !(vma->vm_flags & VM_SHARED)) {
+		split_huge_pmd(vma, pmd, address);
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
