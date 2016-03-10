Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 5C04D1A1F75
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 15:55:55 -0800 (PST)
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v5 07/14] x86: Unify native_*_get_and_clear !SMP case
Date: Thu, 10 Mar 2016 18:55:24 -0500
Message-Id: <1457654131-4562-8-git-send-email-matthew.r.wilcox@intel.com>
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

x86_32 and x86_64 had diverged slightly in their implementations
of the non-SMP cases for native_ptep_get_and_clear() and
native_pmdp_get_and_clear().  Unify the non-SMP cases in pgtable.h,
leaving only the SMP cases in the other three files.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 arch/x86/include/asm/pgtable-2level.h |  6 ------
 arch/x86/include/asm/pgtable-3level.h |  7 +------
 arch/x86/include/asm/pgtable.h        |  5 +++++
 arch/x86/include/asm/pgtable_64.h     | 18 ++----------------
 4 files changed, 8 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-2level.h b/arch/x86/include/asm/pgtable-2level.h
index fd74a11..520318f 100644
--- a/arch/x86/include/asm/pgtable-2level.h
+++ b/arch/x86/include/asm/pgtable-2level.h
@@ -42,17 +42,11 @@ static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 {
 	return __pte(xchg(&xp->pte_low, 0));
 }
-#else
-#define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
-#endif
 
-#ifdef CONFIG_SMP
 static inline pmd_t native_pmdp_get_and_clear(pmd_t *xp)
 {
 	return __pmd(xchg((pmdval_t *)xp, 0));
 }
-#else
-#define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
 #endif
 
 /* Bit manipulation helper on pte/pgoff entry */
diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
index cdaa58c..b1b6412 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -149,11 +149,7 @@ static inline pte_t native_ptep_get_and_clear(pte_t *ptep)
 
 	return res;
 }
-#else
-#define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
-#endif
 
-#ifdef CONFIG_SMP
 union split_pmd {
 	struct {
 		u32 pmd_low;
@@ -161,6 +157,7 @@ union split_pmd {
 	};
 	pmd_t pmd;
 };
+
 static inline pmd_t native_pmdp_get_and_clear(pmd_t *pmdp)
 {
 	union split_pmd res, *orig = (union split_pmd *)pmdp;
@@ -172,8 +169,6 @@ static inline pmd_t native_pmdp_get_and_clear(pmd_t *pmdp)
 
 	return res.pmd;
 }
-#else
-#define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
 #endif
 
 /* Encode and de-code a swap entry */
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 1ff49ec..35306ca 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -740,6 +740,11 @@ static inline pmd_t native_local_pmdp_get_and_clear(pmd_t *pmdp)
 	return res;
 }
 
+#ifndef CONFIG_SMP
+#define native_ptep_get_and_clear(p)	native_local_ptep_get_and_clear(p)
+#define native_pmdp_get_and_clear(p)	native_local_pmdp_get_and_clear(p)
+#endif
+
 static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
 				     pte_t *ptep , pte_t pte)
 {
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 2ee7811..a0c0219 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -70,31 +70,17 @@ static inline void native_pmd_clear(pmd_t *pmd)
 	native_set_pmd(pmd, native_make_pmd(0));
 }
 
+#ifdef CONFIG_SMP
 static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 {
-#ifdef CONFIG_SMP
 	return native_make_pte(xchg(&xp->pte, 0));
-#else
-	/* native_local_ptep_get_and_clear,
-	   but duplicated because of cyclic dependency */
-	pte_t ret = *xp;
-	native_pte_clear(NULL, 0, xp);
-	return ret;
-#endif
 }
 
 static inline pmd_t native_pmdp_get_and_clear(pmd_t *xp)
 {
-#ifdef CONFIG_SMP
 	return native_make_pmd(xchg(&xp->pmd, 0));
-#else
-	/* native_local_pmdp_get_and_clear,
-	   but duplicated because of cyclic dependency */
-	pmd_t ret = *xp;
-	native_pmd_clear(xp);
-	return ret;
-#endif
 }
+#endif
 
 static inline void native_set_pud(pud_t *pudp, pud_t pud)
 {
-- 
2.7.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
