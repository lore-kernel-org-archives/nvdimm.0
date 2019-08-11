Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 81F54212CFEC5
 for <linux-nvdimm@lists.01.org>; Sun, 11 Aug 2019 01:15:37 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5] memremap: provide a not device managed memremap_pages
Date: Sun, 11 Aug 2019 10:12:47 +0200
Message-Id: <20190811081247.22111-6-hch@lst.de>
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

The kvmppc ultravisor code wants a device private memory pool that is
system wide and not attached to a device.  Instead of faking up one
provide a low-level memremap_pages for it.  Note that this function is
not exported, and doesn't have a cleanup routine associated with it to
discourage use from more driver like users.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/memremap.h |  1 +
 mm/memremap.c            | 74 ++++++++++++++++++++++++----------------
 2 files changed, 45 insertions(+), 30 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 8f0013e18e14..eac23e88a94a 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -123,6 +123,7 @@ static inline struct vmem_altmap *pgmap_altmap(struct dev_pagemap *pgmap)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
+void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
 void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
 struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
diff --git a/mm/memremap.c b/mm/memremap.c
index 09a087ca30ff..7b7575330db4 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -137,27 +137,12 @@ static void dev_pagemap_percpu_release(struct percpu_ref *ref)
 	complete(&pgmap->done);
 }
 
-/**
- * devm_memremap_pages - remap and provide memmap backing for the given resource
- * @dev: hosting device for @res
- * @pgmap: pointer to a struct dev_pagemap
- *
- * Notes:
- * 1/ At a minimum the res and type members of @pgmap must be initialized
- *    by the caller before passing it to this function
- *
- * 2/ The altmap field may optionally be initialized, in which case
- *    PGMAP_ALTMAP_VALID must be set in pgmap->flags.
- *
- * 3/ The ref field may optionally be provided, in which pgmap->ref must be
- *    'live' on entry and will be killed and reaped at
- *    devm_memremap_pages_release() time, or if this routine fails.
- *
- * 4/ res is expected to be a host memory range that could feasibly be
- *    treated as a "System RAM" range, i.e. not a device mmio range, but
- *    this is not enforced.
+/*
+ * This version is not intended for system resources only, and there is no
+ * way to clean up the resource acquisitions.  If you need to clean up you
+ * probably want dev_memremap_pages below.
  */
-void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
+void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 {
 	struct resource *res = &pgmap->res;
 	struct dev_pagemap *conflict_pgmap;
@@ -168,7 +153,7 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 		.altmap = pgmap_altmap(pgmap),
 	};
 	pgprot_t pgprot = PAGE_KERNEL;
-	int error, nid, is_ram;
+	int error, is_ram;
 	bool need_devmap_managed = true;
 
 	switch (pgmap->type) {
@@ -223,7 +208,7 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 
 	conflict_pgmap = get_dev_pagemap(PHYS_PFN(res->start), NULL);
 	if (conflict_pgmap) {
-		dev_WARN(dev, "Conflicting mapping in same section\n");
+		WARN(1, "Conflicting mapping in same section\n");
 		put_dev_pagemap(conflict_pgmap);
 		error = -ENOMEM;
 		goto err_array;
@@ -231,7 +216,7 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 
 	conflict_pgmap = get_dev_pagemap(PHYS_PFN(res->end), NULL);
 	if (conflict_pgmap) {
-		dev_WARN(dev, "Conflicting mapping in same section\n");
+		WARN(1, "Conflicting mapping in same section\n");
 		put_dev_pagemap(conflict_pgmap);
 		error = -ENOMEM;
 		goto err_array;
@@ -252,7 +237,6 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 	if (error)
 		goto err_array;
 
-	nid = dev_to_node(dev);
 	if (nid < 0)
 		nid = numa_mem_id();
 
@@ -308,12 +292,6 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 				PHYS_PFN(res->start),
 				PHYS_PFN(resource_size(res)), pgmap);
 	percpu_ref_get_many(pgmap->ref, pfn_end(pgmap) - pfn_first(pgmap));
-
-	error = devm_add_action_or_reset(dev, devm_memremap_pages_release,
-			pgmap);
-	if (error)
-		return ERR_PTR(error);
-
 	return __va(res->start);
 
  err_add_memory:
@@ -328,6 +306,42 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 	devmap_managed_enable_put();
 	return ERR_PTR(error);
 }
+
+/**
+ * devm_memremap_pages - remap and provide memmap backing for the given resource
+ * @dev: hosting device for @res
+ * @pgmap: pointer to a struct dev_pagemap
+ *
+ * Notes:
+ * 1/ At a minimum the res and type members of @pgmap must be initialized
+ *    by the caller before passing it to this function
+ *
+ * 2/ The altmap field may optionally be initialized, in which case
+ *    PGMAP_ALTMAP_VALID must be set in pgmap->flags.
+ *
+ * 3/ The ref field may optionally be provided, in which pgmap->ref must be
+ *    'live' on entry and will be killed and reaped at
+ *    devm_memremap_pages_release() time, or if this routine fails.
+ *
+ * 4/ res is expected to be a host memory range that could feasibly be
+ *    treated as a "System RAM" range, i.e. not a device mmio range, but
+ *    this is not enforced.
+ */
+void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
+{
+	int error;
+	void *ret;
+
+	ret = memremap_pages(pgmap, dev_to_node(dev));
+	if (IS_ERR(ret))
+		return ret;
+
+	error = devm_add_action_or_reset(dev, devm_memremap_pages_release,
+			pgmap);
+	if (error)
+		return ERR_PTR(error);
+	return ret;
+}
 EXPORT_SYMBOL_GPL(devm_memremap_pages);
 
 void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap)
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
