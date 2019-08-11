Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 44A08212E46EA
 for <linux-nvdimm@lists.01.org>; Sun, 11 Aug 2019 01:15:34 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/5] memremap: don't use a separate devm action for
 devmap_managed_enable_get
Date: Sun, 11 Aug 2019 10:12:46 +0200
Message-Id: <20190811081247.22111-5-hch@lst.de>
In-Reply-To: <20190811081247.22111-1-hch@lst.de>
References: <20190811081247.22111-1-hch@lst.de>
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
To: Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

Just clean up for early failures and then piggy back on
devm_memremap_pages_release.  This helps with a pending not device
managed version of devm_memremap_pages.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/memremap.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/memremap.c b/mm/memremap.c
index 600a14cbe663..09a087ca30ff 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -21,13 +21,13 @@ DEFINE_STATIC_KEY_FALSE(devmap_managed_key);
 EXPORT_SYMBOL(devmap_managed_key);
 static atomic_t devmap_managed_enable;
 
-static void devmap_managed_enable_put(void *data)
+static void devmap_managed_enable_put(void)
 {
 	if (atomic_dec_and_test(&devmap_managed_enable))
 		static_branch_disable(&devmap_managed_key);
 }
 
-static int devmap_managed_enable_get(struct device *dev, struct dev_pagemap *pgmap)
+static int devmap_managed_enable_get(struct dev_pagemap *pgmap)
 {
 	if (!pgmap->ops || !pgmap->ops->page_free) {
 		WARN(1, "Missing page_free method\n");
@@ -36,13 +36,16 @@ static int devmap_managed_enable_get(struct device *dev, struct dev_pagemap *pgm
 
 	if (atomic_inc_return(&devmap_managed_enable) == 1)
 		static_branch_enable(&devmap_managed_key);
-	return devm_add_action_or_reset(dev, devmap_managed_enable_put, NULL);
+	return 0;
 }
 #else
-static int devmap_managed_enable_get(struct device *dev, struct dev_pagemap *pgmap)
+static int devmap_managed_enable_get(struct dev_pagemap *pgmap)
 {
 	return -EINVAL;
 }
+static void devmap_managed_enable_put(void)
+{
+}
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
 
 static void pgmap_array_delete(struct resource *res)
@@ -123,6 +126,7 @@ static void devm_memremap_pages_release(void *data)
 	untrack_pfn(NULL, PHYS_PFN(res->start), resource_size(res));
 	pgmap_array_delete(res);
 	WARN_ONCE(pgmap->altmap.alloc, "failed to free all reserved pages\n");
+	devmap_managed_enable_put();
 }
 
 static void dev_pagemap_percpu_release(struct percpu_ref *ref)
@@ -212,7 +216,7 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 	}
 
 	if (need_devmap_managed) {
-		error = devmap_managed_enable_get(dev, pgmap);
+		error = devmap_managed_enable_get(pgmap);
 		if (error)
 			return ERR_PTR(error);
 	}
@@ -321,6 +325,7 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
  err_array:
 	dev_pagemap_kill(pgmap);
 	dev_pagemap_cleanup(pgmap);
+	devmap_managed_enable_put();
 	return ERR_PTR(error);
 }
 EXPORT_SYMBOL_GPL(devm_memremap_pages);
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
