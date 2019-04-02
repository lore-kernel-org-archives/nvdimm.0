Return-Path: <owner-linux-mm@kvack.org>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v2] mm: Fix modifying of page protection by insert_pfn_pmd()
Date: Tue,  2 Apr 2019 17:21:25 +0530
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <20190402115125.18803-1-aneesh.kumar@linux.ibm.com>
Sender: owner-linux-mm@kvack.org
To: dan.j.williams@intel.com, akpm@linux-foundation.org, Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, stable@vger.kernel.org, Chandan Rajendra <chandan@linux.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

With some architectures like ppc64, set_pmd_at() cannot cope with
a situation where there is already some (different) valid entry present.

Use pmdp_set_access_flags() instead to modify the pfn which is built to
deal with modifying existing PMD entries.

This is similar to
commit cae85cb8add3 ("mm/memory.c: fix modifying of page protection by insert_pfn()")

We also do similar update w.r.t insert_pfn_pud eventhough ppc64 don't support
pud pfn entries now.

Without this patch we also see the below message in kernel log
"BUG: non-zero pgtables_bytes on freeing mm:"

CC: stable@vger.kernel.org
Reported-by: Chandan Rajendra <chandan@linux.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
Changes from v1:
* Fix the pgtable leak 

 mm/huge_memory.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 404acdcd0455..165ea46bf149 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -755,6 +755,21 @@ static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
 	spinlock_t *ptl;
 
 	ptl = pmd_lock(mm, pmd);
+	if (!pmd_none(*pmd)) {
+		if (write) {
+			if (pmd_pfn(*pmd) != pfn_t_to_pfn(pfn)) {
+				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
+				goto out_unlock;
+			}
+			entry = pmd_mkyoung(*pmd);
+			entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+			if (pmdp_set_access_flags(vma, addr, pmd, entry, 1))
+				update_mmu_cache_pmd(vma, addr, pmd);
+		}
+
+		goto out_unlock;
+	}
+
 	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
 	if (pfn_t_devmap(pfn))
 		entry = pmd_mkdevmap(entry);
@@ -766,11 +781,16 @@ static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
 	if (pgtable) {
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 		mm_inc_nr_ptes(mm);
+		pgtable = NULL;
 	}
 
 	set_pmd_at(mm, addr, pmd, entry);
 	update_mmu_cache_pmd(vma, addr, pmd);
+
+out_unlock:
 	spin_unlock(ptl);
+	if (pgtable)
+		pte_free(mm, pgtable);
 }
 
 vm_fault_t vmf_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
@@ -821,6 +841,20 @@ static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
 	spinlock_t *ptl;
 
 	ptl = pud_lock(mm, pud);
+	if (!pud_none(*pud)) {
+		if (write) {
+			if (pud_pfn(*pud) != pfn_t_to_pfn(pfn)) {
+				WARN_ON_ONCE(!is_huge_zero_pud(*pud));
+				goto out_unlock;
+			}
+			entry = pud_mkyoung(*pud);
+			entry = maybe_pud_mkwrite(pud_mkdirty(entry), vma);
+			if (pudp_set_access_flags(vma, addr, pud, entry, 1))
+				update_mmu_cache_pud(vma, addr, pud);
+		}
+		goto out_unlock;
+	}
+
 	entry = pud_mkhuge(pfn_t_pud(pfn, prot));
 	if (pfn_t_devmap(pfn))
 		entry = pud_mkdevmap(entry);
@@ -830,6 +864,8 @@ static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
 	}
 	set_pud_at(mm, addr, pud, entry);
 	update_mmu_cache_pud(vma, addr, pud);
+
+out_unlock:
 	spin_unlock(ptl);
 }
 
-- 
2.20.1
