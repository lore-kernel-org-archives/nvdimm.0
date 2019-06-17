From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 06/25] mm: factor out a devm_request_free_mem_region helper
Date: Mon, 17 Jun 2019 14:27:14 +0200
Message-ID: <20190617122733.22432-7-hch@lst.de>
References: <20190617122733.22432-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190617122733.22432-1-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ben Skeggs <bskeggs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, nouveau-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Keep the physical address allocation that hmm_add_device does with the
rest of the resource code, and allow future reuse of it without the hmm
wrapper.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
---
 include/linux/ioport.h |  2 ++
 kernel/resource.c      | 39 +++++++++++++++++++++++++++++++++++++++
 mm/hmm.c               | 33 ++++-----------------------------
 3 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index da0ebaec25f0..76a33ae3bf6c 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -286,6 +286,8 @@ static inline bool resource_overlaps(struct resource *r1, struct resource *r2)
        return (r1->start <= r2->end && r1->end >= r2->start);
 }
 
+struct resource *devm_request_free_mem_region(struct device *dev,
+		struct resource *base, unsigned long size);
 
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff --git a/kernel/resource.c b/kernel/resource.c
index 158f04ec1d4f..d22423e85cf8 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1628,6 +1628,45 @@ void resource_list_free(struct list_head *head)
 }
 EXPORT_SYMBOL(resource_list_free);
 
+#ifdef CONFIG_DEVICE_PRIVATE
+/**
+ * devm_request_free_mem_region - find free region for device private memory
+ *
+ * @dev: device struct to bind the resource to
+ * @size: size in bytes of the device memory to add
+ * @base: resource tree to look in
+ *
+ * This function tries to find an empty range of physical address big enough to
+ * contain the new resource, so that it can later be hotplugged as ZONE_DEVICE
+ * memory, which in turn allocates struct pages.
+ */
+struct resource *devm_request_free_mem_region(struct device *dev,
+		struct resource *base, unsigned long size)
+{
+	resource_size_t end, addr;
+	struct resource *res;
+
+	size = ALIGN(size, 1UL << PA_SECTION_SHIFT);
+	end = min_t(unsigned long, base->end, (1UL << MAX_PHYSMEM_BITS) - 1);
+	addr = end - size + 1UL;
+
+	for (; addr > size && addr >= base->start; addr -= size) {
+		if (region_intersects(addr, size, 0, IORES_DESC_NONE) !=
+				REGION_DISJOINT)
+			continue;
+
+		res = devm_request_mem_region(dev, addr, size, dev_name(dev));
+		if (!res)
+			return ERR_PTR(-ENOMEM);
+		res->desc = IORES_DESC_DEVICE_PRIVATE_MEMORY;
+		return res;
+	}
+
+	return ERR_PTR(-ERANGE);
+}
+EXPORT_SYMBOL_GPL(devm_request_free_mem_region);
+#endif /* CONFIG_DEVICE_PRIVATE */
+
 static int __init strict_iomem(char *str)
 {
 	if (strstr(str, "relaxed"))
diff --git a/mm/hmm.c b/mm/hmm.c
index 64e788bb1211..172d695dcb8b 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -25,8 +25,6 @@
 #include <linux/mmu_notifier.h>
 #include <linux/memory_hotplug.h>
 
-#define PA_SECTION_SIZE (1UL << PA_SECTION_SHIFT)
-
 #if IS_ENABLED(CONFIG_HMM_MIRROR)
 static const struct mmu_notifier_ops hmm_mmu_notifier_ops;
 
@@ -1405,7 +1403,6 @@ struct hmm_devmem *hmm_devmem_add(const struct hmm_devmem_ops *ops,
 				  unsigned long size)
 {
 	struct hmm_devmem *devmem;
-	resource_size_t addr;
 	void *result;
 	int ret;
 
@@ -1427,32 +1424,10 @@ struct hmm_devmem *hmm_devmem_add(const struct hmm_devmem_ops *ops,
 	if (ret)
 		return ERR_PTR(ret);
 
-	size = ALIGN(size, PA_SECTION_SIZE);
-	addr = min((unsigned long)iomem_resource.end,
-		   (1UL << MAX_PHYSMEM_BITS) - 1);
-	addr = addr - size + 1UL;
-
-	/*
-	 * FIXME add a new helper to quickly walk resource tree and find free
-	 * range
-	 *
-	 * FIXME what about ioport_resource resource ?
-	 */
-	for (; addr > size && addr >= iomem_resource.start; addr -= size) {
-		ret = region_intersects(addr, size, 0, IORES_DESC_NONE);
-		if (ret != REGION_DISJOINT)
-			continue;
-
-		devmem->resource = devm_request_mem_region(device, addr, size,
-							   dev_name(device));
-		if (!devmem->resource)
-			return ERR_PTR(-ENOMEM);
-		break;
-	}
-	if (!devmem->resource)
-		return ERR_PTR(-ERANGE);
-
-	devmem->resource->desc = IORES_DESC_DEVICE_PRIVATE_MEMORY;
+	devmem->resource = devm_request_free_mem_region(device, &iomem_resource,
+			size);
+	if (IS_ERR(devmem->resource))
+		return ERR_CAST(devmem->resource);
 	devmem->pfn_first = devmem->resource->start >> PAGE_SHIFT;
 	devmem->pfn_last = devmem->pfn_first +
 			   (resource_size(devmem->resource) >> PAGE_SHIFT);
-- 
2.20.1
