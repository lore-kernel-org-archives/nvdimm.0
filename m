Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 32D7E2217CE54
 for <linux-nvdimm@lists.01.org>; Thu,  7 Dec 2017 07:04:16 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/14] mm: optimize dev_pagemap reference counting around
 get_dev_pagemap
Date: Thu,  7 Dec 2017 07:08:28 -0800
Message-Id: <20171207150840.28409-3-hch@lst.de>
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

Change the calling convention so that get_dev_pagemap always consumes the
previous reference instead of doing this using an explicit earlier call to
put_dev_pagemap in the callers.

The callers will still need to put the final reference after finishing the
loop over the pages.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/memremap.c | 17 +++++++++--------
 mm/gup.c          |  7 +++++--
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index f0b54eca85b0..502fa107a585 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -506,22 +506,23 @@ struct vmem_altmap *to_vmem_altmap(unsigned long memmap_start)
  * @pfn: page frame number to lookup page_map
  * @pgmap: optional known pgmap that already has a reference
  *
- * @pgmap allows the overhead of a lookup to be bypassed when @pfn lands in the
- * same mapping.
+ * If @pgmap is non-NULL and covers @pfn it will be returned as-is.  If @pgmap
+ * is non-NULL but does not cover @pfn the reference to it while be released.
  */
 struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 		struct dev_pagemap *pgmap)
 {
-	const struct resource *res = pgmap ? pgmap->res : NULL;
 	resource_size_t phys = PFN_PHYS(pfn);
 
 	/*
-	 * In the cached case we're already holding a live reference so
-	 * we can simply do a blind increment
+	 * In the cached case we're already holding a live reference.
 	 */
-	if (res && phys >= res->start && phys <= res->end) {
-		percpu_ref_get(pgmap->ref);
-		return pgmap;
+	if (pgmap) {
+		const struct resource *res = pgmap ? pgmap->res : NULL;
+
+		if (res && phys >= res->start && phys <= res->end)
+			return pgmap;
+		put_dev_pagemap(pgmap);
 	}
 
 	/* fall back to slow path lookup */
diff --git a/mm/gup.c b/mm/gup.c
index d3fb60e5bfac..9d142eb9e2e9 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1410,7 +1410,6 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 
-		put_dev_pagemap(pgmap);
 		SetPageReferenced(page);
 		pages[*nr] = page;
 		(*nr)++;
@@ -1420,6 +1419,8 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 	ret = 1;
 
 pte_unmap:
+	if (pgmap)
+		put_dev_pagemap(pgmap);
 	pte_unmap(ptem);
 	return ret;
 }
@@ -1459,10 +1460,12 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
 		SetPageReferenced(page);
 		pages[*nr] = page;
 		get_page(page);
-		put_dev_pagemap(pgmap);
 		(*nr)++;
 		pfn++;
 	} while (addr += PAGE_SIZE, addr != end);
+
+	if (pgmap)
+		put_dev_pagemap(pgmap);
 	return 1;
 }
 
-- 
2.14.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
