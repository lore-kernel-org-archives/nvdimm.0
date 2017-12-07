Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DCE9D2218E947
 for <linux-nvdimm@lists.01.org>; Thu,  7 Dec 2017 07:04:16 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/14] mm: better abstract out dev_pagemap freeing
Date: Thu,  7 Dec 2017 07:08:29 -0800
Message-Id: <20171207150840.28409-4-hch@lst.de>
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

Add a new helper that both looks up the pagemap and updates the alloc
counter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/powerpc/mm/init_64.c | 6 ++----
 arch/x86/mm/init_64.c     | 5 +----
 include/linux/memremap.h  | 7 ++++++-
 kernel/memremap.c         | 9 +++++++--
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index a07722531b32..d6a040198edf 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -268,7 +268,6 @@ void __ref vmemmap_free(unsigned long start, unsigned long end)
 
 	for (; start < end; start += page_size) {
 		unsigned long nr_pages, addr;
-		struct vmem_altmap *altmap;
 		struct page *section_base;
 		struct page *page;
 
@@ -288,9 +287,8 @@ void __ref vmemmap_free(unsigned long start, unsigned long end)
 		section_base = pfn_to_page(vmemmap_section_start(start));
 		nr_pages = 1 << page_order;
 
-		altmap = to_vmem_altmap((unsigned long) section_base);
-		if (altmap) {
-			vmem_altmap_free(altmap, nr_pages);
+		if (dev_pagemap_free_pages(section_base, nr_pages)) {
+			;
 		} else if (PageReserved(page)) {
 			/* allocated from bootmem */
 			if (page_size < PAGE_SIZE) {
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 4a837289f2ad..f5e51b941d19 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -804,12 +804,9 @@ static void __meminit free_pagetable(struct page *page, int order)
 {
 	unsigned long magic;
 	unsigned int nr_pages = 1 << order;
-	struct vmem_altmap *altmap = to_vmem_altmap((unsigned long) page);
 
-	if (altmap) {
-		vmem_altmap_free(altmap, nr_pages);
+	if (dev_pagemap_free_pages(page, nr_pages))
 		return;
-	}
 
 	/* bootmem page has reserved flag */
 	if (PageReserved(page)) {
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index f24e0c71d6a6..8f4d96f0e265 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -27,7 +27,6 @@ struct vmem_altmap {
 };
 
 unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
-void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns);
 
 #ifdef CONFIG_ZONE_DEVICE
 struct vmem_altmap *to_vmem_altmap(unsigned long memmap_start);
@@ -139,6 +138,7 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
 struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 		struct dev_pagemap *pgmap);
 static inline bool is_zone_device_page(const struct page *page);
+bool dev_pagemap_free_pages(struct page *page, unsigned nr_pages);
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct resource *res, struct percpu_ref *ref,
@@ -158,6 +158,11 @@ static inline struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 {
 	return NULL;
 }
+
+static inline bool dev_pagemap_free_pages(struct page *page, unsigned nr_pages)
+{
+	return false;
+}
 #endif /* CONFIG_ZONE_DEVICE */
 
 #if defined(CONFIG_DEVICE_PRIVATE) || defined(CONFIG_DEVICE_PUBLIC)
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 502fa107a585..1b7c5bc93162 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -470,9 +470,14 @@ unsigned long vmem_altmap_offset(struct vmem_altmap *altmap)
 	return altmap->reserve + altmap->free;
 }
 
-void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns)
+bool dev_pagemap_free_pages(struct page *page, unsigned nr_pages)
 {
-	altmap->alloc -= nr_pfns;
+	struct vmem_altmap *pgmap = to_vmem_altmap((uintptr_t)page);
+
+	if (!pgmap)
+		return false;
+	pgmap->alloc -= nr_pages;
+	return true;
 }
 
 struct vmem_altmap *to_vmem_altmap(unsigned long memmap_start)
-- 
2.14.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
