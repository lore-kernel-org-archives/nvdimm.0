Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8E25782044
 for <linux-nvdimm@lists.01.org>; Tue,  7 Feb 2017 21:34:17 -0800 (PST)
Subject: [-mm PATCH] mm: fix get_user_pages() vs device-dax pud mappings
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 07 Feb 2017 21:30:11 -0800
Message-ID: <148653181153.38226.9605457830505509385.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>, Nilesh Choudhury <nilesh.choudhury@oracle.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

A new unit test for the device-dax 1GB enabling currently fails with
this warning before hanging the test thread:

 WARNING: CPU: 0 PID: 21 at lib/percpu-refcount.c:155 percpu_ref_switch_to_atomic_rcu+0x1e3/0x1f0
 percpu ref (dax_pmem_percpu_release [dax_pmem]) <= 0 (0) after switching to atomic
 [..]
 CPU: 0 PID: 21 Comm: rcuos/1 Tainted: G           O    4.10.0-rc7-next-20170207+ #944
 [..]
 Call Trace:
  dump_stack+0x86/0xc3
  __warn+0xcb/0xf0
  warn_slowpath_fmt+0x5f/0x80
  ? rcu_nocb_kthread+0x27a/0x510
  ? dax_pmem_percpu_exit+0x50/0x50 [dax_pmem]
  percpu_ref_switch_to_atomic_rcu+0x1e3/0x1f0
  ? percpu_ref_exit+0x60/0x60
  rcu_nocb_kthread+0x339/0x510
  ? rcu_nocb_kthread+0x27a/0x510
  kthread+0x101/0x140

The get_user_pages() path needs to arrange for references to be taken
against the dev_pagemap instance backing the pud mapping. Refactor the
existing __gup_device_huge_pmd() to also account for the pud case.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Nilesh Choudhury <nilesh.choudhury@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/mm/gup.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 0d4fb3ebbbac..99c7805a9693 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -154,14 +154,12 @@ static inline void get_head_page_multiple(struct page *page, int nr)
 	SetPageReferenced(page);
 }
 
-static int __gup_device_huge_pmd(pmd_t pmd, unsigned long addr,
+static int __gup_device_huge(unsigned long pfn, unsigned long addr,
 		unsigned long end, struct page **pages, int *nr)
 {
 	int nr_start = *nr;
-	unsigned long pfn = pmd_pfn(pmd);
 	struct dev_pagemap *pgmap = NULL;
 
-	pfn += (addr & ~PMD_MASK) >> PAGE_SHIFT;
 	do {
 		struct page *page = pfn_to_page(pfn);
 
@@ -180,6 +178,24 @@ static int __gup_device_huge_pmd(pmd_t pmd, unsigned long addr,
 	return 1;
 }
 
+static int __gup_device_huge_pmd(pmd_t pmd, unsigned long addr,
+		unsigned long end, struct page **pages, int *nr)
+{
+	unsigned long fault_pfn;
+
+	fault_pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+	return __gup_device_huge(fault_pfn, addr, end, pages, nr);
+}
+
+static int __gup_device_huge_pud(pud_t pud, unsigned long addr,
+		unsigned long end, struct page **pages, int *nr)
+{
+	unsigned long fault_pfn;
+
+	fault_pfn = pud_pfn(pud) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
+	return __gup_device_huge(fault_pfn, addr, end, pages, nr);
+}
+
 static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
 		unsigned long end, int write, struct page **pages, int *nr)
 {
@@ -251,9 +267,13 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
 
 	if (!pte_allows_gup(pud_val(pud), write))
 		return 0;
+
+	VM_BUG_ON(!pfn_valid(pud_pfn(pud)));
+	if (pud_devmap(pud))
+		return __gup_device_huge_pud(pud, addr, end, pages, nr);
+
 	/* hugepages are never "special" */
 	VM_BUG_ON(pud_flags(pud) & _PAGE_SPECIAL);
-	VM_BUG_ON(!pfn_valid(pud_pfn(pud)));
 
 	refs = 0;
 	head = pud_page(pud);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
