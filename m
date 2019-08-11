Return-Path: <owner-linux-mm@kvack.org>
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/5] resource: pass a name argument to devm_request_free_mem_region
Date: Sun, 11 Aug 2019 10:12:43 +0200
Message-Id: <20190811081247.22111-2-hch@lst.de>
In-Reply-To: <20190811081247.22111-1-hch@lst.de>
References: <20190811081247.22111-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add an explicit resource name argument to devm_request_free_mem_region.
Besides allowing drivers to request multiple regions per device with
different names, this also prepares for a not device managed version of
the function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/nouveau/nouveau_dmem.c | 3 ++-
 include/linux/ioport.h                 | 2 +-
 kernel/resource.c                      | 5 +++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index 1333220787a1..aedf18a44789 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -605,7 +605,8 @@ nouveau_dmem_init(struct nouveau_drm *drm)
 	 * and latter if we want to do thing like over commit then we
 	 * could revisit this.
 	 */
-	res = devm_request_free_mem_region(device, &iomem_resource, size);
+	res = devm_request_free_mem_region(device, &iomem_resource, size,
+			dev_name(device));
 	if (IS_ERR(res))
 		goto out_free;
 	drm->dmem->pagemap.type = MEMORY_DEVICE_PRIVATE;
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 5b6a7121c9f0..0dcc48cafa80 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -296,7 +296,7 @@ static inline bool resource_overlaps(struct resource *r1, struct resource *r2)
 }
 
 struct resource *devm_request_free_mem_region(struct device *dev,
-		struct resource *base, unsigned long size);
+		struct resource *base, unsigned long size, const char *name);
 
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff --git a/kernel/resource.c b/kernel/resource.c
index 7ea4306503c5..0ddc558586a7 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1650,13 +1650,14 @@ EXPORT_SYMBOL(resource_list_free);
  * @dev: device struct to bind the resource to
  * @size: size in bytes of the device memory to add
  * @base: resource tree to look in
+ * @name: identifying name for the new resource
  *
  * This function tries to find an empty range of physical address big enough to
  * contain the new resource, so that it can later be hotplugged as ZONE_DEVICE
  * memory, which in turn allocates struct pages.
  */
 struct resource *devm_request_free_mem_region(struct device *dev,
-		struct resource *base, unsigned long size)
+		struct resource *base, unsigned long size, const char *name)
 {
 	resource_size_t end, addr;
 	struct resource *res;
@@ -1670,7 +1671,7 @@ struct resource *devm_request_free_mem_region(struct device *dev,
 				REGION_DISJOINT)
 			continue;
 
-		res = devm_request_mem_region(dev, addr, size, dev_name(dev));
+		res = devm_request_mem_region(dev, addr, size, name);
 		if (!res)
 			return ERR_PTR(-ENOMEM);
 		res->desc = IORES_DESC_DEVICE_PRIVATE_MEMORY;
-- 
2.20.1
