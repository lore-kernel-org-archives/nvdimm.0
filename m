Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D732F221EA0A6
 for <linux-nvdimm@lists.01.org>; Thu,  7 Dec 2017 07:04:17 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/14] mm: merge vmem_altmap_alloc into
 dev_pagemap_alloc_block_buf
Date: Thu,  7 Dec 2017 07:08:34 -0800
Message-Id: <20171207150840.28409-9-hch@lst.de>
In-Reply-To: <20171207150840.28409-1-hch@lst.de>
References: <20171207150840.28409-1-hch@lst.de>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

There is no clear separation between the two, so merge them.  Also move
the device page map argument first for the more natural calling
convention.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/powerpc/mm/init_64.c |  2 +-
 arch/x86/mm/init_64.c     |  2 +-
 include/linux/mm.h        |  4 ++--
 mm/sparse-vmemmap.c       | 51 ++++++++++++++++++-----------------------------
 4 files changed, 23 insertions(+), 36 deletions(-)

diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index 3a39a644e96c..ec706857bdd6 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -203,7 +203,7 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node)
 		/* altmap lookups only work at section boundaries */
 		altmap = to_vmem_altmap(SECTION_ALIGN_DOWN(start));
 		if (altmap)
-			p = dev_pagemap_alloc_block_buf(page_size, altmap);
+			p = dev_pagemap_alloc_block_buf(altmap, page_size);
 		else
 			p = vmemmap_alloc_block_buf(page_size, node);
 		if (!p)
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 9e1b489aa826..131749080874 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1372,7 +1372,7 @@ static int __meminit vmemmap_populate_hugepages(unsigned long start,
 			void *p;
 
 			if (altmap)
-				p = dev_pagemap_alloc_block_buf(PMD_SIZE, altmap);
+				p = dev_pagemap_alloc_block_buf(altmap, PMD_SIZE);
 			else
 				p = vmemmap_alloc_block_buf(PMD_SIZE, node);
 			if (p) {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 856869e2c119..cd3d1c00f6a3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2547,8 +2547,8 @@ pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node);
-void *dev_pagemap_alloc_block_buf(unsigned long size,
-		struct vmem_altmap *altmap);
+void *dev_pagemap_alloc_block_buf(struct vmem_altmap *pgmap,
+		unsigned long size);
 void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
 int vmemmap_populate_basepages(unsigned long start, unsigned long end,
 			       int node);
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 268b6c7dfdf4..fef41a6a9f64 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -107,33 +107,16 @@ static unsigned long __meminit vmem_altmap_nr_free(struct vmem_altmap *altmap)
 }
 
 /**
- * vmem_altmap_alloc - allocate pages from the vmem_altmap reservation
- * @altmap - reserved page pool for the allocation
- * @nr_pfns - size (in pages) of the allocation
+ * dev_pagemap_alloc_block_buf - allocate pages from the device page map
+ * @pgmap:	device page map
+ * @size:	size (in bytes) of the allocation
  *
- * Allocations are aligned to the size of the request
+ * Allocations are aligned to the size of the request.
  */
-static unsigned long __meminit vmem_altmap_alloc(struct vmem_altmap *altmap,
-		unsigned long nr_pfns)
+void * __meminit dev_pagemap_alloc_block_buf(struct vmem_altmap *pgmap,
+		unsigned long size)
 {
-	unsigned long pfn = vmem_altmap_next_pfn(altmap);
-	unsigned long nr_align;
-
-	nr_align = 1UL << find_first_bit(&nr_pfns, BITS_PER_LONG);
-	nr_align = ALIGN(pfn, nr_align) - pfn;
-
-	if (nr_pfns + nr_align > vmem_altmap_nr_free(altmap))
-		return ULONG_MAX;
-	altmap->alloc += nr_pfns;
-	altmap->align += nr_align;
-	return pfn + nr_align;
-}
-
-void * __meminit dev_pagemap_alloc_block_buf(unsigned long size,
-		struct vmem_altmap *altmap)
-{
-	unsigned long pfn, nr_pfns;
-	void *ptr;
+	unsigned long pfn, nr_pfns, nr_align;
 
 	if (size & ~PAGE_MASK) {
 		pr_warn_once("%s: allocations must be multiple of PAGE_SIZE (%ld)\n",
@@ -141,16 +124,20 @@ void * __meminit dev_pagemap_alloc_block_buf(unsigned long size,
 		return NULL;
 	}
 
+	pfn = vmem_altmap_next_pfn(pgmap);
 	nr_pfns = size >> PAGE_SHIFT;
-	pfn = vmem_altmap_alloc(altmap, nr_pfns);
-	if (pfn < ULONG_MAX)
-		ptr = __va(__pfn_to_phys(pfn));
-	else
-		ptr = NULL;
-	pr_debug("%s: pfn: %#lx alloc: %ld align: %ld nr: %#lx\n",
-			__func__, pfn, altmap->alloc, altmap->align, nr_pfns);
+	nr_align = 1UL << find_first_bit(&nr_pfns, BITS_PER_LONG);
+	nr_align = ALIGN(pfn, nr_align) - pfn;
+	if (nr_pfns + nr_align > vmem_altmap_nr_free(pgmap))
+		return NULL;
 
-	return ptr;
+	pgmap->alloc += nr_pfns;
+	pgmap->align += nr_align;
+	pfn += nr_align;
+
+	pr_debug("%s: pfn: %#lx alloc: %ld align: %ld nr: %#lx\n",
+			__func__, pfn, pgmap->alloc, pgmap->align, nr_pfns);
+	return __va(__pfn_to_phys(pfn));
 }
 
 void __meminit vmemmap_verify(pte_t *pte, int node,
-- 
2.14.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
