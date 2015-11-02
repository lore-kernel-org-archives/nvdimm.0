Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 06/15] um: kill pfn_t
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 01 Nov 2015 23:30:15 -0500
Message-ID: <20151102043015.6610.2007.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: Dave Hansen <dave@sr71.net>, jack@suse.cz, linux-nvdimm@lists.01.org, Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>, david@fromorbit.com, linux-kernel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The core has developed a need for a "pfn_t" type [1].  Convert the usage
of pfn_t by usermode-linux to an unsigned long, and update pfn_to_phys()
to drop its expectation of a typed pfn.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-September/002199.html

Cc: Dave Hansen <dave@sr71.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/um/include/asm/page.h           |    6 +++---
 arch/um/include/asm/pgtable-3level.h |    4 ++--
 arch/um/include/asm/pgtable.h        |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/um/include/asm/page.h b/arch/um/include/asm/page.h
index 71c5d132062a..fe26a5e06268 100644
--- a/arch/um/include/asm/page.h
+++ b/arch/um/include/asm/page.h
@@ -18,6 +18,7 @@
 
 struct page;
 
+#include <linux/pfn.h>
 #include <linux/types.h>
 #include <asm/vm-flags.h>
 
@@ -76,7 +77,6 @@ typedef struct { unsigned long pmd; } pmd_t;
 #define pte_is_zero(p) (!((p).pte & ~_PAGE_NEWPAGE))
 #define pte_set_val(p, phys, prot) (p).pte = (phys | pgprot_val(prot))
 
-typedef unsigned long pfn_t;
 typedef unsigned long phys_t;
 
 #endif
@@ -109,8 +109,8 @@ extern unsigned long uml_physmem;
 #define __pa(virt) to_phys((void *) (unsigned long) (virt))
 #define __va(phys) to_virt((unsigned long) (phys))
 
-#define phys_to_pfn(p) ((pfn_t) ((p) >> PAGE_SHIFT))
-#define pfn_to_phys(pfn) ((phys_t) ((pfn) << PAGE_SHIFT))
+#define phys_to_pfn(p) ((p) >> PAGE_SHIFT)
+#define pfn_to_phys(pfn) PFN_PHYS(pfn)
 
 #define pfn_valid(pfn) ((pfn) < max_mapnr)
 #define virt_addr_valid(v) pfn_valid(phys_to_pfn(__pa(v)))
diff --git a/arch/um/include/asm/pgtable-3level.h b/arch/um/include/asm/pgtable-3level.h
index 2b4274e7c095..bae8523a162f 100644
--- a/arch/um/include/asm/pgtable-3level.h
+++ b/arch/um/include/asm/pgtable-3level.h
@@ -98,7 +98,7 @@ static inline unsigned long pte_pfn(pte_t pte)
 	return phys_to_pfn(pte_val(pte));
 }
 
-static inline pte_t pfn_pte(pfn_t page_nr, pgprot_t pgprot)
+static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
 {
 	pte_t pte;
 	phys_t phys = pfn_to_phys(page_nr);
@@ -107,7 +107,7 @@ static inline pte_t pfn_pte(pfn_t page_nr, pgprot_t pgprot)
 	return pte;
 }
 
-static inline pmd_t pfn_pmd(pfn_t page_nr, pgprot_t pgprot)
+static inline pmd_t pfn_pmd(unsigned long page_nr, pgprot_t pgprot)
 {
 	return __pmd((page_nr << PAGE_SHIFT) | pgprot_val(pgprot));
 }
diff --git a/arch/um/include/asm/pgtable.h b/arch/um/include/asm/pgtable.h
index 18eb9924dda3..7485398d0737 100644
--- a/arch/um/include/asm/pgtable.h
+++ b/arch/um/include/asm/pgtable.h
@@ -271,7 +271,7 @@ static inline int pte_same(pte_t pte_a, pte_t pte_b)
 
 #define phys_to_page(phys) pfn_to_page(phys_to_pfn(phys))
 #define __virt_to_page(virt) phys_to_page(__pa(virt))
-#define page_to_phys(page) pfn_to_phys((pfn_t) page_to_pfn(page))
+#define page_to_phys(page) pfn_to_phys(page_to_pfn(page))
 #define virt_to_page(addr) __virt_to_page((const unsigned long) addr)
 
 #define mk_pte(page, pgprot) \

