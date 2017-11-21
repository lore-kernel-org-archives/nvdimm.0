Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DD0752034C5F2
 for <linux-nvdimm@lists.01.org>; Tue, 21 Nov 2017 11:11:51 -0800 (PST)
Subject: [PATCH v3 3/5] mm: replace pud_write with pud_access_permitted in
 fault + gup paths
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 21 Nov 2017 11:07:52 -0800
Message-ID: <151129127237.37405.16073414520854722485.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, linux-nvdimm@lists.01.org, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "David S. Miller" <davem@davemloft.net>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The 'access_permitted' helper is used in the gup-fast path and goes
beyond the simple _PAGE_RW check to also:

* validate that the mapping is writable from a protection keys
  standpoint

* validate that the pte has _PAGE_USER set since all fault paths where
  pud_write is must be referencing user-memory.

Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/s390/include/asm/pgtable.h |    6 ++++++
 arch/sparc/mm/gup.c             |    2 +-
 mm/huge_memory.c                |    2 +-
 mm/memory.c                     |    2 +-
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 0a6b0286c32e..57d7bc92e0b8 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1264,6 +1264,12 @@ static inline pud_t pud_mkwrite(pud_t pud)
 	return pud;
 }
 
+#define pud_write pud_write
+static inline int pud_write(pud_t pud)
+{
+	return (pud_val(pud) & _REGION3_ENTRY_WRITE) != 0;
+}
+
 static inline pud_t pud_mkclean(pud_t pud)
 {
 	if (pud_large(pud)) {
diff --git a/arch/sparc/mm/gup.c b/arch/sparc/mm/gup.c
index 5335ba3c850e..5ae2d0a01a70 100644
--- a/arch/sparc/mm/gup.c
+++ b/arch/sparc/mm/gup.c
@@ -114,7 +114,7 @@ static int gup_huge_pud(pud_t *pudp, pud_t pud, unsigned long addr,
 	if (!(pud_val(pud) & _PAGE_VALID))
 		return 0;
 
-	if (write && !pud_write(pud))
+	if (!pud_access_permitted(pud, write))
 		return 0;
 
 	refs = 0;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 86fe697e8bfb..9583f035ccb0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1022,7 +1022,7 @@ struct page *follow_devmap_pud(struct vm_area_struct *vma, unsigned long addr,
 
 	assert_spin_locked(pud_lockptr(mm, pud));
 
-	if (flags & FOLL_WRITE && !pud_write(*pud))
+	if (!pud_access_permitted(*pud, flags & FOLL_WRITE))
 		return NULL;
 
 	if (pud_present(*pud) && pud_devmap(*pud))
diff --git a/mm/memory.c b/mm/memory.c
index 85e7a87da79f..24fbd60eb2b0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4013,7 +4013,7 @@ static int __handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 
 			/* NUMA case for anonymous PUDs would go here */
 
-			if (dirty && !pud_write(orig_pud)) {
+			if (dirty && !pud_access_permitted(orig_pud, WRITE)) {
 				ret = wp_huge_pud(&vmf, orig_pud);
 				if (!(ret & VM_FAULT_FALLBACK))
 					return ret;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
