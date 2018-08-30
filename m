Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9985F21107832
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 13:05:47 -0700 (PDT)
Subject: [PATCH] mm: fix BUG_ON() in vmf_insert_pfn_pud() from VM_MIXEDMAP
 removal
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 30 Aug 2018 13:05:46 -0700
Message-ID: <153565954666.35458.15832314745699968487.stgit@djiang5-desk3.ch.intel.com>
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
Cc: jack@suse.com, linux-mm@kvack.org, dan.j.williams@intel.com.vishal.l.verma, ""@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

It looks like I missed the PUD path when doing VM_MIXEDMAP removal.
This can be triggered by:
1. Boot with memmap=4G!8G
2. build ndctl with destructive flag on
3. make TESTS=device-dax check

[  +0.000675] kernel BUG at mm/huge_memory.c:824!

Applying the same change that was applied to vmf_insert_pfn_pmd() in the
original patch.

Fixes: e1fb4a08649 ("dax: remove VM_MIXEDMAP for fsdax and device dax")

Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c3bc7e9c9a2a..533f9b00147d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -821,11 +821,11 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
 	 * but we need to be consistent with PTEs and architectures that
 	 * can't support a 'special' bit.
 	 */
-	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
+	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) &&
+			!pfn_t_devmap(pfn));
 	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
-	BUG_ON(!pfn_t_devmap(pfn));
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
