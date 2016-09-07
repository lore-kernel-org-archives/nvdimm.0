Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 061DB1A1F3F
 for <linux-nvdimm@lists.01.org>; Wed,  7 Sep 2016 15:29:17 -0700 (PDT)
Subject: [PATCH v2 2/2] mm: fix cache mode tracking in vm_insert_mixed()
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 07 Sep 2016 15:26:19 -0700
Message-ID: <147328717909.35069.14256589123570653697.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147328716869.35069.16311932814998156819.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147328716869.35069.16311932814998156819.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Matthew Wilcox <mawilcox@microsoft.com>, David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

vm_insert_mixed() unlike vm_insert_pfn_prot() and vmf_insert_pfn_pmd(),
fails to check the pgprot_t it uses for the mapping against the one
recorded in the memtype tracking tree.  Add the missing call to
track_pfn_insert() to preclude cases where incompatible aliased mappings
are established for a given physical address range.

Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/memory.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 83be99d9d8a1..8841fed328f9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1649,10 +1649,14 @@ EXPORT_SYMBOL(vm_insert_pfn_prot);
 int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			pfn_t pfn)
 {
+	pgprot_t pgprot = vma->vm_page_prot;
+
 	BUG_ON(!(vma->vm_flags & VM_MIXEDMAP));
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
+	if (track_pfn_insert(vma, &pgprot, pfn))
+		return -EINVAL;
 
 	/*
 	 * If we don't have pte special, then we have to use the pfn_valid()
@@ -1670,9 +1674,9 @@ int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 		 * result in pfn_t_has_page() == false.
 		 */
 		page = pfn_to_page(pfn_t_to_pfn(pfn));
-		return insert_page(vma, addr, page, vma->vm_page_prot);
+		return insert_page(vma, addr, page, pgprot);
 	}
-	return insert_pfn(vma, addr, pfn, vma->vm_page_prot);
+	return insert_pfn(vma, addr, pfn, pgprot);
 }
 EXPORT_SYMBOL(vm_insert_mixed);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
