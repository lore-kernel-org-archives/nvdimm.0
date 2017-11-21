Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 952E92034C5F2
 for <linux-nvdimm@lists.01.org>; Tue, 21 Nov 2017 11:11:41 -0800 (PST)
Subject: [PATCH v3 1/5] mm: fix device-dax pud write-faults triggered by
 get_user_pages()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 21 Nov 2017 11:07:41 -0800
Message-ID: <151129126165.37405.16031785266675461397.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151129125625.37405.15953656230804875212.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151129125625.37405.15953656230804875212.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, x86@kernel.org, Dave Hansen <dave.hansen@intel.com>, stable@vger.kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
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
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@vger.kernel.org>
Cc: <x86@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/pgtable.h |    6 ++++++
 include/asm-generic/pgtable.h  |    8 ++++++++
 include/linux/hugetlb.h        |    8 --------
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 09f9e1e00e3b..dcce76ee4aa7 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1088,6 +1088,12 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 	clear_bit(_PAGE_BIT_RW, (unsigned long *)pmdp);
 }
 
+#define pud_write pud_write
+static inline int pud_write(pud_t pud)
+{
+	return pud_flags(pud) & _PAGE_RW;
+}
+
 /*
  * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
  *
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 757dc6ffc7ba..1ac457511f4e 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -814,6 +814,14 @@ static inline int pmd_write(pmd_t pmd)
 #endif /* __HAVE_ARCH_PMD_WRITE */
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+#ifndef pud_write
+static inline int pud_write(pud_t pud)
+{
+	BUG();
+	return 0;
+}
+#endif /* pud_write */
+
 #if !defined(CONFIG_TRANSPARENT_HUGEPAGE) || \
 	(defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
 	 !defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
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
