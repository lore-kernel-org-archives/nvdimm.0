Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE5DE21A16EED
 for <linux-nvdimm@lists.01.org>; Wed, 17 May 2017 10:16:55 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/2] mm: avoid spurious 'bad pmd' warning messages
Date: Wed, 17 May 2017 11:16:38 -0600
Message-Id: <20170517171639.14501-1-ross.zwisler@linux.intel.com>
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

Reorder these checks so that pmd_devmap() is checked first, avoiding the
error messages.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: commit 7267ec008b5c ("mm: postpone page table allocation until we have page to map")
Cc: stable@vger.kernel.org
---
 mm/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 6ff5d72..1ee269d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3061,7 +3061,7 @@ static int pte_alloc_one_map(struct vm_fault *vmf)
 	 * through an atomic read in C, which is what pmd_trans_unstable()
 	 * provides.
 	 */
-	if (pmd_trans_unstable(vmf->pmd) || pmd_devmap(*vmf->pmd))
+	if (pmd_devmap(*vmf->pmd) || pmd_trans_unstable(vmf->pmd))
 		return VM_FAULT_NOPAGE;
 
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
@@ -3690,7 +3690,7 @@ static int handle_pte_fault(struct vm_fault *vmf)
 		vmf->pte = NULL;
 	} else {
 		/* See comment in pte_alloc_one_map() */
-		if (pmd_trans_unstable(vmf->pmd) || pmd_devmap(*vmf->pmd))
+		if (pmd_devmap(*vmf->pmd) || pmd_trans_unstable(vmf->pmd))
 			return 0;
 		/*
 		 * A regular pmd is established and it can't morph into a huge
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
