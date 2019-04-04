From: Barret Rhoden <brho@google.com>
Subject: [PATCH v3 1/3] mm: make dev_pagemap_mapping_shift() externally visible
Date: Thu,  4 Apr 2019 16:23:43 -0400
Message-ID: <20190404202345.133553-2-brho@google.com>
References: <20190404202345.133553-1-brho@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190404202345.133553-1-brho@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, David Hildenbrand <david@redhat.com>, Dave Jiang <dave.jiang@intel.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yu.c.zhang@intel.com, yi.z.zhang@intel.com
List-Id: linux-nvdimm@lists.01.org

KVM has a use case for determining the size of a dax mapping.  The KVM
code has easy access to the address and the mm; hence the change in
parameters.

Signed-off-by: Barret Rhoden <brho@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/mm.h  |  3 +++
 mm/memory-failure.c | 38 +++-----------------------------------
 mm/util.c           | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index fe52e266016e..c09e2f4c9bac 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -963,6 +963,9 @@ static inline bool is_pci_p2pdma_page(const struct page *page)
 }
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
 
+unsigned long dev_pagemap_mapping_shift(unsigned long address,
+					struct mm_struct *mm);
+
 static inline void get_page(struct page *page)
 {
 	page = compound_head(page);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fc8b51744579..6779c163c4f4 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -265,40 +265,6 @@ void shake_page(struct page *p, int access)
 }
 EXPORT_SYMBOL_GPL(shake_page);
 
-static unsigned long dev_pagemap_mapping_shift(struct page *page,
-		struct vm_area_struct *vma)
-{
-	unsigned long address = vma_address(page, vma);
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	pgd = pgd_offset(vma->vm_mm, address);
-	if (!pgd_present(*pgd))
-		return 0;
-	p4d = p4d_offset(pgd, address);
-	if (!p4d_present(*p4d))
-		return 0;
-	pud = pud_offset(p4d, address);
-	if (!pud_present(*pud))
-		return 0;
-	if (pud_devmap(*pud))
-		return PUD_SHIFT;
-	pmd = pmd_offset(pud, address);
-	if (!pmd_present(*pmd))
-		return 0;
-	if (pmd_devmap(*pmd))
-		return PMD_SHIFT;
-	pte = pte_offset_map(pmd, address);
-	if (!pte_present(*pte))
-		return 0;
-	if (pte_devmap(*pte))
-		return PAGE_SHIFT;
-	return 0;
-}
-
 /*
  * Failure handling: if we can't find or can't kill a process there's
  * not much we can do.	We just print a message and ignore otherwise.
@@ -329,7 +295,9 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
 	tk->addr = page_address_in_vma(p, vma);
 	tk->addr_valid = 1;
 	if (is_zone_device_page(p))
-		tk->size_shift = dev_pagemap_mapping_shift(p, vma);
+		tk->size_shift =
+			dev_pagemap_mapping_shift(vma_address(page, vma),
+						  vma->vm_mm);
 	else
 		tk->size_shift = compound_order(compound_head(p)) + PAGE_SHIFT;
 
diff --git a/mm/util.c b/mm/util.c
index f94a1ac09cd8..24444e35a7ed 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -795,3 +795,37 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen)
 out:
 	return res;
 }
+
+unsigned long dev_pagemap_mapping_shift(unsigned long address,
+					struct mm_struct *mm)
+{
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pgd = pgd_offset(mm, address);
+	if (!pgd_present(*pgd))
+		return 0;
+	p4d = p4d_offset(pgd, address);
+	if (!p4d_present(*p4d))
+		return 0;
+	pud = pud_offset(p4d, address);
+	if (!pud_present(*pud))
+		return 0;
+	if (pud_devmap(*pud))
+		return PUD_SHIFT;
+	pmd = pmd_offset(pud, address);
+	if (!pmd_present(*pmd))
+		return 0;
+	if (pmd_devmap(*pmd))
+		return PMD_SHIFT;
+	pte = pte_offset_map(pmd, address);
+	if (!pte_present(*pte))
+		return 0;
+	if (pte_devmap(*pte))
+		return PAGE_SHIFT;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dev_pagemap_mapping_shift);
-- 
2.21.0.392.gf8f6787159e-goog
