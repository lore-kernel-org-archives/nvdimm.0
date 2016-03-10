Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 9D6121A1F75
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 15:55:55 -0800 (PST)
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v5 08/14] x86: Fix whitespace issues
Date: Thu, 10 Mar 2016 18:55:25 -0500
Message-Id: <1457654131-4562-9-git-send-email-matthew.r.wilcox@intel.com>
In-Reply-To: <1457654131-4562-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1457654131-4562-1-git-send-email-matthew.r.wilcox@intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

checkpatch whines about these whitespace issues.  No code changes.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 arch/x86/include/asm/pgtable-2level.h |  2 +-
 arch/x86/include/asm/pgtable.h        | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-2level.h b/arch/x86/include/asm/pgtable-2level.h
index 520318f..2f558ba 100644
--- a/arch/x86/include/asm/pgtable-2level.h
+++ b/arch/x86/include/asm/pgtable-2level.h
@@ -11,7 +11,7 @@
  * within a page table are directly modified.  Thus, the following
  * hook is made available.
  */
-static inline void native_set_pte(pte_t *ptep , pte_t pte)
+static inline void native_set_pte(pte_t *ptep, pte_t pte)
 {
 	*ptep = pte;
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 35306ca..4cbc459 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -746,13 +746,13 @@ static inline pmd_t native_local_pmdp_get_and_clear(pmd_t *pmdp)
 #endif
 
 static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
-				     pte_t *ptep , pte_t pte)
+				     pte_t *ptep, pte_t pte)
 {
 	native_set_pte(ptep, pte);
 }
 
 static inline void native_set_pmd_at(struct mm_struct *mm, unsigned long addr,
-				     pmd_t *pmdp , pmd_t pmd)
+				     pmd_t *pmdp, pmd_t pmd)
 {
 	native_set_pmd(pmdp, pmd);
 }
@@ -852,8 +852,8 @@ static inline int pmd_write(pmd_t pmd)
 }
 
 #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
-static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm, unsigned long addr,
-				       pmd_t *pmdp)
+static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
+					unsigned long addr, pmd_t *pmdp)
 {
 	return native_pmdp_get_and_clear(pmdp);
 }
@@ -877,7 +877,7 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
  */
 static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
 {
-       memcpy(dst, src, count * sizeof(pgd_t));
+	memcpy(dst, src, count * sizeof(pgd_t));
 }
 
 #define PTE_SHIFT ilog2(PTRS_PER_PTE)
-- 
2.7.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
