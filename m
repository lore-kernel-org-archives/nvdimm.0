Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6709F1A1F3B
 for <linux-nvdimm@lists.01.org>; Wed,  7 Sep 2016 15:29:12 -0700 (PDT)
Subject: [PATCH v2 1/2] mm: fix cache mode of dax pmd mappings
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 07 Sep 2016 15:26:14 -0700
Message-ID: <147328717393.35069.6384193370523015106.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Nilesh Choudhury <nilesh.choudhury@oracle.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, dri-devel@lists.freedesktop.org, akpm@linux-foundation.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Kai Zhang <kai.ka.zhang@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

track_pfn_insert() in vmf_insert_pfn_pmd() is marking dax mappings as
uncacheable rendering them impractical for application usage.  DAX-pte
mappings are cached and the goal of establishing DAX-pmd mappings is to
attain more performance, not dramatically less (3 orders of magnitude).

track_pfn_insert() relies on a previous call to reserve_memtype() to
establish the expected page_cache_mode for the range.  While memremap()
arranges for reserve_memtype() to be called, devm_memremap_pages() does
not.  So, teach track_pfn_insert() and untrack_pfn() how to handle
tracking without a vma, and arrange for devm_memremap_pages() to
establish the write-back-cache reservation in the memtype tree.

Cc: <stable@vger.kernel.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Nilesh Choudhury <nilesh.choudhury@oracle.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Toshi Kani <toshi.kani@hpe.com>
Reported-by: Kai Zhang <kai.ka.zhang@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/mm/pat.c |   17 ++++++++++-------
 kernel/memremap.c |    9 +++++++++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index ecb1b69c1651..170cc4ff057b 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -927,9 +927,10 @@ int track_pfn_copy(struct vm_area_struct *vma)
 }
 
 /*
- * prot is passed in as a parameter for the new mapping. If the vma has a
- * linear pfn mapping for the entire range reserve the entire vma range with
- * single reserve_pfn_range call.
+ * prot is passed in as a parameter for the new mapping. If the vma has
+ * a linear pfn mapping for the entire range, or no vma is provided,
+ * reserve the entire pfn + size range with single reserve_pfn_range
+ * call.
  */
 int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
 		    unsigned long pfn, unsigned long addr, unsigned long size)
@@ -938,11 +939,12 @@ int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
 	enum page_cache_mode pcm;
 
 	/* reserve the whole chunk starting from paddr */
-	if (addr == vma->vm_start && size == (vma->vm_end - vma->vm_start)) {
+	if (!vma || (addr == vma->vm_start
+				&& size == (vma->vm_end - vma->vm_start))) {
 		int ret;
 
 		ret = reserve_pfn_range(paddr, size, prot, 0);
-		if (!ret)
+		if (ret == 0 && vma)
 			vma->vm_flags |= VM_PAT;
 		return ret;
 	}
@@ -997,7 +999,7 @@ void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
 	resource_size_t paddr;
 	unsigned long prot;
 
-	if (!(vma->vm_flags & VM_PAT))
+	if (vma && !(vma->vm_flags & VM_PAT))
 		return;
 
 	/* free the chunk starting from pfn or the whole chunk */
@@ -1011,7 +1013,8 @@ void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
 		size = vma->vm_end - vma->vm_start;
 	}
 	free_pfn_range(paddr, size);
-	vma->vm_flags &= ~VM_PAT;
+	if (vma)
+		vma->vm_flags &= ~VM_PAT;
 }
 
 /*
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 251d16b4cb41..b501e390bb34 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -247,6 +247,7 @@ static void devm_memremap_pages_release(struct device *dev, void *data)
 	align_start = res->start & ~(SECTION_SIZE - 1);
 	align_size = ALIGN(resource_size(res), SECTION_SIZE);
 	arch_remove_memory(align_start, align_size);
+	untrack_pfn(NULL, PHYS_PFN(align_start), align_size);
 	pgmap_radix_release(res);
 	dev_WARN_ONCE(dev, pgmap->altmap && pgmap->altmap->alloc,
 			"%s: failed to free all reserved pages\n", __func__);
@@ -282,6 +283,7 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
 		struct percpu_ref *ref, struct vmem_altmap *altmap)
 {
 	resource_size_t key, align_start, align_size, align_end;
+	pgprot_t pgprot = PAGE_KERNEL;
 	struct dev_pagemap *pgmap;
 	struct page_map *page_map;
 	int error, nid, is_ram;
@@ -351,6 +353,11 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
 	if (nid < 0)
 		nid = numa_mem_id();
 
+	error = track_pfn_remap(NULL, &pgprot, PHYS_PFN(align_start), 0,
+			align_size);
+	if (error)
+		goto err_pfn_remap;
+
 	error = arch_add_memory(nid, align_start, align_size, true);
 	if (error)
 		goto err_add_memory;
@@ -371,6 +378,8 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
 	return __va(res->start);
 
  err_add_memory:
+	untrack_pfn(NULL, PHYS_PFN(align_start), align_size);
+ err_pfn_remap:
  err_radix:
 	pgmap_radix_release(res);
 	devres_free(page_map);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
