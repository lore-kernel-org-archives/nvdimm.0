Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3DF3B2021EBCB
 for <linux-nvdimm@lists.01.org>; Sun, 18 Aug 2019 02:12:04 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] resource: add a not device managed
 request_free_mem_region variant
Date: Sun, 18 Aug 2019 11:05:54 +0200
Message-Id: <20190818090557.17853-2-hch@lst.de>
In-Reply-To: <20190818090557.17853-1-hch@lst.de>
References: <20190818090557.17853-1-hch@lst.de>
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
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.ibm.com>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Factor out the guts of devm_request_free_mem_region so that we can
implement both a device managed and a manually release version as
tiny wrappers around it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
---
 include/linux/ioport.h |  2 ++
 kernel/resource.c      | 45 +++++++++++++++++++++++++++++-------------
 2 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 5b6a7121c9f0..7bddddfc76d6 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -297,6 +297,8 @@ static inline bool resource_overlaps(struct resource *r1, struct resource *r2)
 
 struct resource *devm_request_free_mem_region(struct device *dev,
 		struct resource *base, unsigned long size);
+struct resource *request_free_mem_region(struct resource *base,
+		unsigned long size, const char *name);
 
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff --git a/kernel/resource.c b/kernel/resource.c
index 7ea4306503c5..74877e9d90ca 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1644,19 +1644,8 @@ void resource_list_free(struct list_head *head)
 EXPORT_SYMBOL(resource_list_free);
 
 #ifdef CONFIG_DEVICE_PRIVATE
-/**
- * devm_request_free_mem_region - find free region for device private memory
- *
- * @dev: device struct to bind the resource to
- * @size: size in bytes of the device memory to add
- * @base: resource tree to look in
- *
- * This function tries to find an empty range of physical address big enough to
- * contain the new resource, so that it can later be hotplugged as ZONE_DEVICE
- * memory, which in turn allocates struct pages.
- */
-struct resource *devm_request_free_mem_region(struct device *dev,
-		struct resource *base, unsigned long size)
+static struct resource *__request_free_mem_region(struct device *dev,
+		struct resource *base, unsigned long size, const char *name)
 {
 	resource_size_t end, addr;
 	struct resource *res;
@@ -1670,7 +1659,10 @@ struct resource *devm_request_free_mem_region(struct device *dev,
 				REGION_DISJOINT)
 			continue;
 
-		res = devm_request_mem_region(dev, addr, size, dev_name(dev));
+		if (dev)
+			res = devm_request_mem_region(dev, addr, size, name);
+		else
+			res = request_mem_region(addr, size, name);
 		if (!res)
 			return ERR_PTR(-ENOMEM);
 		res->desc = IORES_DESC_DEVICE_PRIVATE_MEMORY;
@@ -1679,7 +1671,32 @@ struct resource *devm_request_free_mem_region(struct device *dev,
 
 	return ERR_PTR(-ERANGE);
 }
+
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
+	return __request_free_mem_region(dev, base, size, dev_name(dev));
+}
 EXPORT_SYMBOL_GPL(devm_request_free_mem_region);
+
+struct resource *request_free_mem_region(struct resource *base,
+		unsigned long size, const char *name)
+{
+	return __request_free_mem_region(NULL, base, size, name);
+}
+EXPORT_SYMBOL_GPL(request_free_mem_region);
+
 #endif /* CONFIG_DEVICE_PRIVATE */
 
 static int __init strict_iomem(char *str)
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
