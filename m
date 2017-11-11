Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A71AB20356876
 for <linux-nvdimm@lists.01.org>; Sat, 11 Nov 2017 12:15:50 -0800 (PST)
Subject: [PATCH v2 1/4] mm: fix device-dax pud write-faults triggered by
 get_user_pages()
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 11 Nov 2017 12:11:39 -0800
Message-ID: <151043109938.2842.14834662818213616199.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151043109403.2842.11607911965674122836.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151043109403.2842.11607911965674122836.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: akpm@linux-foundation.org
Cc: Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "David S. Miller" <davem@davemloft.net>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Currently only get_user_pages_fast() can safely handle the writable gup
case due to its use of pud_access_permitted() to check whether the pud
entry is writable. In the gup slow path pud_write() is used instead of
pud_access_permitted() and to date it has been unimplemented, just calls
BUG_ON().

    kernel BUG at ./include/linux/hugetlb.h:244!
    [..]
    RIP: 0010:follow_devmap_pud+0x482/0x490
    [..]
    Call Trace:
     follow_page_mask+0x28c/0x6e0
     __get_user_pages+0xe4/0x6c0
     get_user_pages_unlocked+0x130/0x1b0
     get_user_pages_fast+0x89/0xb0
     iov_iter_get_pages_alloc+0x114/0x4a0
     nfs_direct_read_schedule_iovec+0xd2/0x350
     ? nfs_start_io_direct+0x63/0x70
     nfs_file_direct_read+0x1e0/0x250
     nfs_file_read+0x90/0xc0

For now this just implements a simple check for the _PAGE_RW bit similar
to pmd_write. However, this implies that the gup-slow-path check is
missing the extra checks that the gup-fast-path performs with
pud_access_permitted. Later patches will align all checks to use the
'access_permitted' helper if the architecture provides it. Note that the
generic 'access_permitted' helper fallback is the simple _PAGE_RW check
on architectures that do not define the 'access_permitted' helper(s).

Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@vger.kernel.org>
Cc: <x86@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm64/include/asm/pgtable.h    |    1 +
 arch/sparc/include/asm/pgtable_64.h |    1 +
 arch/x86/include/asm/pgtable.h      |    6 ++++++
 include/asm-generic/pgtable.h       |    9 +++++++++
 include/linux/hugetlb.h             |    8 --------
 5 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index b46e54c2399b..9a943792a823 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -340,6 +340,7 @@ static inline int pmd_protnone(pmd_t pmd)
 #define pfn_pmd(pfn,prot)	(__pmd(((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot)))
 #define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
 
+#define __HAVE_ARCH_PUD_WRITE
 #define pud_write(pud)		pte_write(pud_pte(pud))
 #define pud_pfn(pud)		(((pud_val(pud) & PUD_MASK) & PHYS_MASK) >> PAGE_SHIFT)
 
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index fd9d9bac7cfa..bcf54a9cf6c5 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -693,6 +693,7 @@ static inline unsigned long pmd_write(pmd_t pmd)
 	return pte_write(pte);
 }
 
+#define __HAVE_ARCH_PUD_WRITE
 #define pud_write(pud)	pte_write(__pte(pud_val(pud)))
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index f735c3016325..5c396724fd0d 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1093,6 +1093,12 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 	clear_bit(_PAGE_BIT_RW, (unsigned long *)pmdp);
 }
 
+#define __HAVE_ARCH_PUD_WRITE
+static inline int pud_write(pud_t pud)
+{
+	return pud_flags(pud) & _PAGE_RW;
+}
+
 /*
  * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
  *
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 757dc6ffc7ba..bd738624bd16 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -812,6 +812,15 @@ static inline int pmd_write(pmd_t pmd)
 	return 0;
 }
 #endif /* __HAVE_ARCH_PMD_WRITE */
+
+#ifndef __HAVE_ARCH_PUD_WRITE
+static inline int pud_write(pud_t pud)
+{
+	BUG();
+	return 0;
+}
+#endif /* __HAVE_ARCH_PUD_WRITE */
+
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #if !defined(CONFIG_TRANSPARENT_HUGEPAGE) || \
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index fbf5b31d47ee..82a25880714a 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -239,14 +239,6 @@ static inline int pgd_write(pgd_t pgd)
 }
 #endif
 
-#ifndef pud_write
-static inline int pud_write(pud_t pud)
-{
-	BUG();
-	return 0;
-}
-#endif
-
 #define HUGETLB_ANON_FILE "anon_hugepage"
 
 enum {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
