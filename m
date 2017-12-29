Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB10422280C45
 for <linux-nvdimm@lists.01.org>; Thu, 28 Dec 2017 23:50:02 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/17] mm: split altmap memory map allocation from normal case
Date: Fri, 29 Dec 2017 08:53:58 +0100
Message-Id: <20171229075406.1936-10-hch@lst.de>
In-Reply-To: <20171229075406.1936-1-hch@lst.de>
References: <20171229075406.1936-1-hch@lst.de>
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
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, linuxppc-dev@lists.ozlabs.org
List-ID: <linux-nvdimm@lists.01.org>

No functional changes, just untangling the call chain and document
why the altmap is passed around the hotplug code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/powerpc/mm/init_64.c |  5 ++++-
 arch/x86/mm/init_64.c     |  5 ++++-
 include/linux/mm.h        |  9 ++-------
 mm/sparse-vmemmap.c       | 15 +++------------
 4 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index db7d4e092157..7a2251d99ed3 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -200,7 +200,10 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		if (vmemmap_populated(start, page_size))
 			continue;
 
-		p =  __vmemmap_alloc_block_buf(page_size, node, altmap);
+		if (altmap)
+			p = altmap_alloc_block_buf(page_size, altmap);
+		else
+			p = vmemmap_alloc_block_buf(page_size, node);
 		if (!p)
 			return -ENOMEM;
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 0cab4b5b59ba..1ab42c852069 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1385,7 +1385,10 @@ static int __meminit vmemmap_populate_hugepages(unsigned long start,
 		if (pmd_none(*pmd)) {
 			void *p;
 
-			p = __vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
+			if (altmap)
+				p = altmap_alloc_block_buf(PMD_SIZE, altmap);
+			else
+				p = vmemmap_alloc_block_buf(PMD_SIZE, node);
 			if (p) {
 				pte_t entry;
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index fd01135324b6..09637c353de0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2547,13 +2547,8 @@ pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
 pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
-void *__vmemmap_alloc_block_buf(unsigned long size, int node,
-		struct vmem_altmap *altmap);
-static inline void *vmemmap_alloc_block_buf(unsigned long size, int node)
-{
-	return __vmemmap_alloc_block_buf(size, node, NULL);
-}
-
+void *vmemmap_alloc_block_buf(unsigned long size, int node);
+void *altmap_alloc_block_buf(unsigned long size, struct vmem_altmap *altmap);
 void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
 int vmemmap_populate_basepages(unsigned long start, unsigned long end,
 			       int node);
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 376dcf05a39c..d012c9e2811b 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -74,7 +74,7 @@ void * __meminit vmemmap_alloc_block(unsigned long size, int node)
 }
 
 /* need to make sure size is all the same during early stage */
-static void * __meminit alloc_block_buf(unsigned long size, int node)
+void * __meminit vmemmap_alloc_block_buf(unsigned long size, int node)
 {
 	void *ptr;
 
@@ -129,7 +129,7 @@ static unsigned long __meminit vmem_altmap_alloc(struct vmem_altmap *altmap,
 	return pfn + nr_align;
 }
 
-static void * __meminit altmap_alloc_block_buf(unsigned long size,
+void * __meminit altmap_alloc_block_buf(unsigned long size,
 		struct vmem_altmap *altmap)
 {
 	unsigned long pfn, nr_pfns;
@@ -153,15 +153,6 @@ static void * __meminit altmap_alloc_block_buf(unsigned long size,
 	return ptr;
 }
 
-/* need to make sure size is all the same during early stage */
-void * __meminit __vmemmap_alloc_block_buf(unsigned long size, int node,
-		struct vmem_altmap *altmap)
-{
-	if (altmap)
-		return altmap_alloc_block_buf(size, altmap);
-	return alloc_block_buf(size, node);
-}
-
 void __meminit vmemmap_verify(pte_t *pte, int node,
 				unsigned long start, unsigned long end)
 {
@@ -178,7 +169,7 @@ pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node)
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	if (pte_none(*pte)) {
 		pte_t entry;
-		void *p = alloc_block_buf(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node);
 		if (!p)
 			return NULL;
 		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
-- 
2.14.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
