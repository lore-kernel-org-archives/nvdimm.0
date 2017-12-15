Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ADCD82216D8FD
 for <linux-nvdimm@lists.01.org>; Fri, 15 Dec 2017 06:06:13 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/17] memremap: remove to_vmem_altmap
Date: Fri, 15 Dec 2017 15:09:43 +0100
Message-Id: <20171215140947.26075-14-hch@lst.de>
In-Reply-To: <20171215140947.26075-1-hch@lst.de>
References: <20171215140947.26075-1-hch@lst.de>
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
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, linuxppc-dev@lists.ozlabs.org
List-ID: <linux-nvdimm@lists.01.org>

All callers are gone now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/memremap.h |  9 ---------
 kernel/memremap.c        | 26 --------------------------
 2 files changed, 35 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 26e8aaba27d5..3fddcfe57bb0 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -26,15 +26,6 @@ struct vmem_altmap {
 	unsigned long alloc;
 };
 
-#ifdef CONFIG_ZONE_DEVICE
-struct vmem_altmap *to_vmem_altmap(unsigned long memmap_start);
-#else
-static inline struct vmem_altmap *to_vmem_altmap(unsigned long memmap_start)
-{
-	return NULL;
-}
-#endif
-
 /*
  * Specialize ZONE_DEVICE memory into multiple types each having differents
  * usage.
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 26764085785d..891491ddccdb 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -475,32 +475,6 @@ void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns)
 	altmap->alloc -= nr_pfns;
 }
 
-struct vmem_altmap *to_vmem_altmap(unsigned long memmap_start)
-{
-	/*
-	 * 'memmap_start' is the virtual address for the first "struct
-	 * page" in this range of the vmemmap array.  In the case of
-	 * CONFIG_SPARSEMEM_VMEMMAP a page_to_pfn conversion is simple
-	 * pointer arithmetic, so we can perform this to_vmem_altmap()
-	 * conversion without concern for the initialization state of
-	 * the struct page fields.
-	 */
-	struct page *page = (struct page *) memmap_start;
-	struct dev_pagemap *pgmap;
-
-	/*
-	 * Unconditionally retrieve a dev_pagemap associated with the
-	 * given physical address, this is only for use in the
-	 * arch_{add|remove}_memory() for setting up and tearing down
-	 * the memmap.
-	 */
-	rcu_read_lock();
-	pgmap = find_dev_pagemap(__pfn_to_phys(page_to_pfn(page)));
-	rcu_read_unlock();
-
-	return pgmap ? pgmap->altmap : NULL;
-}
-
 /**
  * get_dev_pagemap() - take a new live reference on the dev_pagemap for @pfn
  * @pfn: page frame number to lookup page_map
-- 
2.14.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
