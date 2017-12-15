Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 21ECC2216D8F6
 for <linux-nvdimm@lists.01.org>; Fri, 15 Dec 2017 06:06:18 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/17] memremap: simplify duplicate region handling in
 devm_memremap_pages
Date: Fri, 15 Dec 2017 15:09:44 +0100
Message-Id: <20171215140947.26075-15-hch@lst.de>
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

__radix_tree_insert already checks for duplicates and returns -EEXIST in
that case, so remove the duplicate (and racy) duplicates check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
---
 kernel/memremap.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index 891491ddccdb..901404094df1 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -395,17 +395,6 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
 	align_end = align_start + align_size - 1;
 
 	foreach_order_pgoff(res, order, pgoff) {
-		struct dev_pagemap *dup;
-
-		rcu_read_lock();
-		dup = find_dev_pagemap(res->start + PFN_PHYS(pgoff));
-		rcu_read_unlock();
-		if (dup) {
-			dev_err(dev, "%s: %pr collides with mapping for %s\n",
-					__func__, res, dev_name(dup->dev));
-			error = -EBUSY;
-			break;
-		}
 		error = __radix_tree_insert(&pgmap_radix,
 				PHYS_PFN(res->start) + pgoff, order, page_map);
 		if (error) {
-- 
2.14.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
