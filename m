Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CD50D2217CE54
 for <linux-nvdimm@lists.01.org>; Thu,  7 Dec 2017 07:04:16 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/14] memremap: simplify duplicate region handling in
 devm_memremap_pages
Date: Thu,  7 Dec 2017 07:08:37 -0800
Message-Id: <20171207150840.28409-12-hch@lst.de>
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

__radix_tree_insert already checks for duplicates and returns -EEXIST in
that case, so remove the duplicate (and racy) duplicates check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/memremap.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index f4b198304e3b..4301fb657150 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -379,17 +379,6 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
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
 				PHYS_PFN(res->start) + pgoff, order, pgmap);
 		if (error) {
-- 
2.14.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
