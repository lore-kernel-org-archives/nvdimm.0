Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x243.google.com (mail-pg0-x243.google.com
 [IPv6:2607:f8b0:400e:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4787E21939224
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 10:43:02 -0700 (PDT)
Received: by mail-pg0-x243.google.com with SMTP id 79so695438pgf.0
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 10:43:02 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH 3/9] powerpc/mm: Add _PAGE_DEVMAP for ppc64.
Date: Wed, 12 Apr 2017 03:42:27 +1000
Message-Id: <20170411174233.21902-4-oohall@gmail.com>
In-Reply-To: <20170411174233.21902-1-oohall@gmail.com>
References: <20170411174233.21902-1-oohall@gmail.com>
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
To: linuxppc-dev@lists.ozlabs.org
Cc: bsingharora@gmail.com, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, arbab@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Add a _PAGE_DEVMAP bit for PTE and DAX PMD entires. PowerPC doesn't
currently support PUD faults so we haven't extended it to the PUD
level.

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 arch/powerpc/include/asm/book3s/64/pgtable.h | 37 +++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index fb72ff6b98e6..b5fc6337649e 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -78,6 +78,9 @@
 
 #define _PAGE_SOFT_DIRTY	_RPAGE_SW3 /* software: software dirty tracking */
 #define _PAGE_SPECIAL		_RPAGE_SW2 /* software: special page */
+#define _PAGE_DEVMAP		_RPAGE_SW1
+#define __HAVE_ARCH_PTE_DEVMAP
+
 /*
  * Drivers request for cache inhibited pte mapping using _PAGE_NO_CACHE
  * Instead of fixing all of them, add an alternate define which
@@ -602,6 +605,16 @@ static inline pte_t pte_mkhuge(pte_t pte)
 	return pte;
 }
 
+static inline pte_t pte_mkdevmap(pte_t pte)
+{
+	return __pte(pte_val(pte) | _PAGE_SPECIAL|_PAGE_DEVMAP);
+}
+
+static inline int pte_devmap(pte_t pte)
+{
+	return !!(pte_raw(pte) & cpu_to_be64(_PAGE_DEVMAP));
+}
+
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
 	/* FIXME!! check whether this need to be a conditional */
@@ -966,6 +979,9 @@ static inline pte_t *pmdp_ptep(pmd_t *pmd)
 #define pmd_mk_savedwrite(pmd)	pte_pmd(pte_mk_savedwrite(pmd_pte(pmd)))
 #define pmd_clear_savedwrite(pmd)	pte_pmd(pte_clear_savedwrite(pmd_pte(pmd)))
 
+#define pud_pfn(...) (0)
+#define pgd_pfn(...) (0)
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 #define pmd_soft_dirty(pmd)    pte_soft_dirty(pmd_pte(pmd))
 #define pmd_mksoft_dirty(pmd)  pte_pmd(pte_mksoft_dirty(pmd_pte(pmd)))
@@ -1140,7 +1156,6 @@ static inline int pmd_move_must_withdraw(struct spinlock *new_pmd_ptl,
 	return true;
 }
 
-
 #define arch_needs_pgtable_deposit arch_needs_pgtable_deposit
 static inline bool arch_needs_pgtable_deposit(void)
 {
@@ -1149,6 +1164,26 @@ static inline bool arch_needs_pgtable_deposit(void)
 	return true;
 }
 
+static inline pmd_t pmd_mkdevmap(pmd_t pmd)
+{
+	return pte_pmd(pte_mkdevmap(pmd_pte(pmd)));
+}
+
+static inline int pmd_devmap(pmd_t pmd)
+{
+	return pte_devmap(pmd_pte(pmd));
+}
+
+static inline int pud_devmap(pud_t pud)
+{
+	return 0;
+}
+
+static inline int pgd_devmap(pgd_t pgd)
+{
+	return 0;
+}
+
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_POWERPC_BOOK3S_64_PGTABLE_H_ */
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
