Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 16A6321952CDF
 for <linux-nvdimm@lists.01.org>; Fri, 26 May 2017 12:59:39 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] dax: improve fix for colliding PMD & PTE entries
Date: Fri, 26 May 2017 13:59:32 -0600
Message-Id: <20170526195932.32178-1-ross.zwisler@linux.intel.com>
In-Reply-To: <20170522215749.23516-2-ross.zwisler@linux.intel.com>
References: <20170522215749.23516-2-ross.zwisler@linux.intel.com>
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

This commit, which has not yet made it upstream but is in the -mm tree:

    dax: Fix race between colliding PMD & PTE entries

fixed a pair of race conditions where racing DAX PTE and PMD faults could
corrupt page tables.  This fix had two shortcomings which are addressed by
this patch:

1) In the PTE fault handler we only checked for a collision using
pmd_devmap().  The pmd_devmap() check will trigger when we have raced with
a PMD that has real DAX storage, but to account for the case where we
collide with a huge zero page entry we also need to check for
pmd_trans_huge().

2) In the PMD fault handler we only continued with the fault if no PMD at
all was present (pmd_none()).  This is the case when we are faulting in a
PMD for the first time, but there are two other cases to consider.  The
first is that we are servicing a write fault over a PMD huge zero page,
which we detect with pmd_trans_huge().  The second is that we are servicing
a write fault over a DAX PMD with real storage, which we address with
pmd_devmap().

Fix both of these, and instead of manually triggering a fallback in the PMD
collision case instead be consistent with the other collision detection
code in the fault handlers and just retry.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: stable@vger.kernel.org
---

For both the -mm tree and for stable, feel free to squash this with the
original commit if you think that is appropriate.

This has passed targeted testing and an xfstests run.
---
 fs/dax.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index fc62f36..2a6889b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1160,7 +1160,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 	 * the PTE we need to set up.  If so just return and the fault will be
 	 * retried.
 	 */
-	if (pmd_devmap(*vmf->pmd)) {
+	if (pmd_trans_huge(*vmf->pmd) || pmd_devmap(*vmf->pmd)) {
 		vmf_ret = VM_FAULT_NOPAGE;
 		goto unlock_entry;
 	}
@@ -1411,11 +1411,14 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 	/*
 	 * It is possible, particularly with mixed reads & writes to private
 	 * mappings, that we have raced with a PTE fault that overlaps with
-	 * the PMD we need to set up.  If so we just fall back to a PTE fault
-	 * ourselves.
+	 * the PMD we need to set up.  If so just return and the fault will be
+	 * retried.
 	 */
-	if (!pmd_none(*vmf->pmd))
+	if (!pmd_none(*vmf->pmd) && !pmd_trans_huge(*vmf->pmd) &&
+			!pmd_devmap(*vmf->pmd)) {
+		result = 0;
 		goto unlock_entry;
+	}
 
 	/*
 	 * Note that we don't use iomap_apply here.  We aren't doing I/O, only
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
