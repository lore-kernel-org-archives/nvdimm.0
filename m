Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 48F16221EA0B2
 for <linux-nvdimm@lists.01.org>; Thu,  7 Dec 2017 07:04:18 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/14] memremap: remove find_dev_pagemap
Date: Thu,  7 Dec 2017 07:08:38 -0800
Message-Id: <20171207150840.28409-13-hch@lst.de>
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

We already have the proper pfn value in both callers, so just open code
the function there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/memremap.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index 4301fb657150..ba5068b9ce07 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -316,14 +316,6 @@ static void devm_memremap_pages_release(void *data)
 		      "%s: failed to free all reserved pages\n", __func__);
 }
 
-/* assumes rcu_read_lock() held at entry */
-static struct dev_pagemap *find_dev_pagemap(resource_size_t phys)
-{
-	WARN_ON_ONCE(!rcu_read_lock_held());
-
-	return radix_tree_lookup(&pgmap_radix, PHYS_PFN(phys));
-}
-
 /**
  * devm_memremap_pages - remap and provide memmap backing for the given resource
  * @dev: hosting device for @res
@@ -496,7 +488,7 @@ struct vmem_altmap *to_vmem_altmap(unsigned long memmap_start)
 	 * the memmap.
 	 */
 	rcu_read_lock();
-	pgmap = find_dev_pagemap(__pfn_to_phys(page_to_pfn(page)));
+	pgmap = radix_tree_lookup(&pgmap_radix, page_to_pfn(page));
 	rcu_read_unlock();
 
 	if (!pgmap || !pgmap->altmap_valid)
@@ -515,12 +507,12 @@ struct vmem_altmap *to_vmem_altmap(unsigned long memmap_start)
 struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 		struct dev_pagemap *pgmap)
 {
-	resource_size_t phys = PFN_PHYS(pfn);
-
 	/*
 	 * In the cached case we're already holding a live reference.
 	 */
 	if (pgmap) {
+		resource_size_t phys = PFN_PHYS(pfn);
+
 		if (phys >= pgmap->res.start && phys <= pgmap->res.end)
 			return pgmap;
 		put_dev_pagemap(pgmap);
@@ -528,7 +520,7 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 
 	/* fall back to slow path lookup */
 	rcu_read_lock();
-	pgmap = find_dev_pagemap(phys);
+	pgmap = radix_tree_lookup(&pgmap_radix, pfn);
 	if (pgmap && !percpu_ref_tryget_live(pgmap->ref))
 		pgmap = NULL;
 	rcu_read_unlock();
-- 
2.14.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
