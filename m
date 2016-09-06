Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 92E001A1E79
 for <linux-nvdimm@lists.01.org>; Tue,  6 Sep 2016 09:52:40 -0700 (PDT)
Subject: [PATCH 4/5] mm: fix cache mode of dax pmd mappings
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 06 Sep 2016 09:49:41 -0700
Message-ID: <147318058165.30325.16762406881120129093.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147318056046.30325.5100892122988191500.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147318056046.30325.5100892122988191500.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Nilesh Choudhury <nilesh.choudhury@oracle.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Kai Zhang <kai.ka.zhang@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

track_pfn_insert() is marking dax mappings as uncacheable.

It is used to keep mappings attributes consistent across a remapped range.
However, since dax regions are never registered via track_pfn_remap(), the
caching mode lookup for dax pfns always returns _PAGE_CACHE_MODE_UC.  We do not
use track_pfn_insert() in the dax-pte path, and we always want to use the
pgprot of the vma itself, so drop this call.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nilesh Choudhury <nilesh.choudhury@oracle.com>
Reported-by: Kai Zhang <kai.ka.zhang@oracle.com>
Reported-by: Toshi Kani <toshi.kani@hpe.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/huge_memory.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a6abd76baa72..338eff05c77a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -676,8 +676,6 @@ int vmf_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;
-	if (track_pfn_insert(vma, &pgprot, pfn))
-		return VM_FAULT_SIGBUS;
 	insert_pfn_pmd(vma, addr, pmd, pfn, pgprot, write);
 	return VM_FAULT_NOPAGE;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
