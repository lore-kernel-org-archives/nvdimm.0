Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9D9BB21A16E4D
 for <linux-nvdimm@lists.01.org>; Mon, 22 May 2017 14:57:55 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 1/2] mm: avoid spurious 'bad pmd' warning messages
Date: Mon, 22 May 2017 15:57:48 -0600
Message-Id: <20170522215749.23516-1-ross.zwisler@linux.intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, stable@vger.kernel.org, linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

When the pmd_devmap() checks were added by:

commit 5c7fb56e5e3f ("mm, dax: dax-pmd vs thp-pmd vs hugetlbfs-pmd")

to add better support for DAX huge pages, they were all added to the end of
if() statements after existing pmd_trans_huge() checks.  So, things like:

-       if (pmd_trans_huge(*pmd))
+       if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd))

When further checks were added after pmd_trans_unstable() checks by:

commit 7267ec008b5c ("mm: postpone page table allocation until we have page
to map")

they were also added at the end of the conditional:

+       if (pmd_trans_unstable(fe->pmd) || pmd_devmap(*fe->pmd))

This ordering is fine for pmd_trans_huge(), but doesn't work for
pmd_trans_unstable().  This is because DAX huge pages trip the bad_pmd()
check inside of pmd_none_or_trans_huge_or_clear_bad() (called by
pmd_trans_unstable()), which prints out a warning and returns 1.  So, we do
end up doing the right thing, but only after spamming dmesg with suspicious
looking messages:

mm/pgtable-generic.c:39: bad pmd ffff8808daa49b88(84000001006000a5)

Reorder these checks in a helper so that pmd_devmap() is checked first,
avoiding the error messages, and add a comment explaining why the ordering
is important.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Fixes: commit 7267ec008b5c ("mm: postpone page table allocation until we have page to map")
Cc: stable@vger.kernel.org
---

Changes from v1:
 - Break the checks out into the new pmd_devmap_trans_unstable() helper and
   add a comment about the ordering (Dave).  I ended up keeping this helper
   in mm/memory.c because I didn't see an obvious header where it would
   live happily.  pmd_devmap() is either defined in
   arch/x86/include/asm/pgtable.h or in include/linux/mm.h depending on
   __HAVE_ARCH_PTE_DEVMAP and CONFIG_TRANSPARENT_HUGEPAGE, and
   pmd_trans_unstable() is defined in include/asm-generic/pgtable.h.

 - Add a comment explaining why pte_alloc_one_map() doesn't suffer from races.
   This was the result of a conversation with Dave Hansen.
---
 mm/memory.c | 40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 6ff5d72..2e65df1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3029,6 +3029,17 @@ static int __do_fault(struct vm_fault *vmf)
 	return ret;
 }
 
+/*
+ * The ordering of these checks is important for pmds with _PAGE_DEVMAP set.
+ * If we check pmd_trans_unstable() first we will trip the bad_pmd() check
+ * inside of pmd_none_or_trans_huge_or_clear_bad(). This will end up correctly
+ * returning 1 but not before it spams dmesg with the pmd_clear_bad() output.
+ */
+static int pmd_devmap_trans_unstable(pmd_t *pmd)
+{
+	return pmd_devmap(*pmd) || pmd_trans_unstable(pmd);
+}
+
 static int pte_alloc_one_map(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -3052,18 +3063,27 @@ static int pte_alloc_one_map(struct vm_fault *vmf)
 map_pte:
 	/*
 	 * If a huge pmd materialized under us just retry later.  Use
-	 * pmd_trans_unstable() instead of pmd_trans_huge() to ensure the pmd
-	 * didn't become pmd_trans_huge under us and then back to pmd_none, as
-	 * a result of MADV_DONTNEED running immediately after a huge pmd fault
-	 * in a different thread of this mm, in turn leading to a misleading
-	 * pmd_trans_huge() retval.  All we have to ensure is that it is a
-	 * regular pmd that we can walk with pte_offset_map() and we can do that
-	 * through an atomic read in C, which is what pmd_trans_unstable()
-	 * provides.
+	 * pmd_trans_unstable() via pmd_devmap_trans_unstable() instead of
+	 * pmd_trans_huge() to ensure the pmd didn't become pmd_trans_huge
+	 * under us and then back to pmd_none, as a result of MADV_DONTNEED
+	 * running immediately after a huge pmd fault in a different thread of
+	 * this mm, in turn leading to a misleading pmd_trans_huge() retval.
+	 * All we have to ensure is that it is a regular pmd that we can walk
+	 * with pte_offset_map() and we can do that through an atomic read in
+	 * C, which is what pmd_trans_unstable() provides.
 	 */
-	if (pmd_trans_unstable(vmf->pmd) || pmd_devmap(*vmf->pmd))
+	if (pmd_devmap_trans_unstable(vmf->pmd))
 		return VM_FAULT_NOPAGE;
 
+	/*
+	 * At this point we know that our vmf->pmd points to a page of ptes
+	 * and it cannot become pmd_none(), pmd_devmap() or pmd_trans_huge()
+	 * for the duration of the fault.  If a racing MADV_DONTNEED runs and
+	 * we zap the ptes pointed to by our vmf->pmd, the vmf->ptl will still
+	 * be valid and we will re-check to make sure the vmf->pte isn't
+	 * pte_none() under vmf->ptl protection when we return to
+	 * alloc_set_pte().
+	 */
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
 			&vmf->ptl);
 	return 0;
@@ -3690,7 +3710,7 @@ static int handle_pte_fault(struct vm_fault *vmf)
 		vmf->pte = NULL;
 	} else {
 		/* See comment in pte_alloc_one_map() */
-		if (pmd_trans_unstable(vmf->pmd) || pmd_devmap(*vmf->pmd))
+		if (pmd_devmap_trans_unstable(vmf->pmd))
 			return 0;
 		/*
 		 * A regular pmd is established and it can't morph into a huge
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
