Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v4 5/9] dma-mapping: allow archs to optionally specify a
 ->map_pfn() operation
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 05 Jun 2015 17:19:30 -0400
Message-ID: <20150605211929.20751.764.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, linux-arch@vger.kernel.org, arnd@arndb.de, ross.zwisler@linux.intel.com, linux-nvdimm@lists.01.org, benh@kernel.crashing.org, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, hch@lst.de, tj@kernel.org, paulus@samba.org, hpa@zytor.com, schwidefsky@de.ibm.com, willy@linux.intel.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Initially this enables the conversion of struct scatterlist to carry a __pfn_t
instead of a struct page * reference.  Later this enables block device drivers
to perform DMA to/from persistent memory which may not have a backing struct
page entry.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/Kconfig                             |    3 +++
 include/asm-generic/dma-mapping-common.h |   30 ++++++++++++++++++++++++++++++
 include/linux/dma-debug.h                |   23 +++++++++++++++++++----
 include/linux/dma-mapping.h              |    8 +++++++-
 lib/dma-debug.c                          |   10 ++++++----
 5 files changed, 65 insertions(+), 9 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 9b98732e0f3b..69d3a3fa21af 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -203,6 +203,9 @@ config HAVE_DMA_ATTRS
 config HAVE_DMA_CONTIGUOUS
 	bool
 
+config HAVE_DMA_PFN
+	bool
+
 config HAVE_KMAP_PFN
 	bool
 
diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index 940d5ec122c9..7305efb1bac6 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -17,9 +17,15 @@ static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
 
 	kmemcheck_mark_initialized(ptr, size);
 	BUG_ON(!valid_dma_direction(dir));
+#ifdef CONFIG_HAVE_DMA_PFN
+	addr = ops->map_pfn(dev, page_to_pfn_typed(virt_to_page(ptr)),
+			     (unsigned long)ptr & ~PAGE_MASK, size,
+			     dir, attrs);
+#else
 	addr = ops->map_page(dev, virt_to_page(ptr),
 			     (unsigned long)ptr & ~PAGE_MASK, size,
 			     dir, attrs);
+#endif
 	debug_dma_map_page(dev, virt_to_page(ptr),
 			   (unsigned long)ptr & ~PAGE_MASK, size,
 			   dir, addr, true);
@@ -73,6 +79,29 @@ static inline void dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sg
 		ops->unmap_sg(dev, sg, nents, dir, attrs);
 }
 
+#ifdef CONFIG_HAVE_DMA_PFN
+static inline dma_addr_t dma_map_pfn(struct device *dev, __pfn_t pfn,
+				      size_t offset, size_t size,
+				      enum dma_data_direction dir)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	dma_addr_t addr;
+
+	BUG_ON(!valid_dma_direction(dir));
+	addr = ops->map_pfn(dev, pfn, offset, size, dir, NULL);
+	debug_dma_map_pfn(dev, pfn, offset, size, dir, addr, false);
+
+	return addr;
+}
+
+static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
+				      size_t offset, size_t size,
+				      enum dma_data_direction dir)
+{
+	kmemcheck_mark_initialized(page_address(page) + offset, size);
+	return dma_map_pfn(dev, page_to_pfn_typed(page), offset, size, dir);
+}
+#else
 static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 				      size_t offset, size_t size,
 				      enum dma_data_direction dir)
@@ -87,6 +116,7 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 
 	return addr;
 }
+#endif /* CONFIG_HAVE_DMA_PFN */
 
 static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
 				  size_t size, enum dma_data_direction dir)
diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index fe8cb610deac..a3b4c8c0cd68 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -34,10 +34,18 @@ extern void dma_debug_init(u32 num_entries);
 
 extern int dma_debug_resize_entries(u32 num_entries);
 
-extern void debug_dma_map_page(struct device *dev, struct page *page,
-			       size_t offset, size_t size,
-			       int direction, dma_addr_t dma_addr,
-			       bool map_single);
+extern void debug_dma_map_pfn(struct device *dev, __pfn_t pfn, size_t offset,
+			      size_t size, int direction, dma_addr_t dma_addr,
+			      bool map_single);
+
+static inline void debug_dma_map_page(struct device *dev, struct page *page,
+				      size_t offset, size_t size,
+				      int direction, dma_addr_t dma_addr,
+				      bool map_single)
+{
+	return debug_dma_map_pfn(dev, page_to_pfn_t(page), offset, size,
+			direction, dma_addr, map_single);
+}
 
 extern void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
 
@@ -109,6 +117,13 @@ static inline void debug_dma_map_page(struct device *dev, struct page *page,
 {
 }
 
+static inline void debug_dma_map_pfn(struct device *dev, __pfn_t pfn,
+				     size_t offset, size_t size,
+				     int direction, dma_addr_t dma_addr,
+				     bool map_single)
+{
+}
+
 static inline void debug_dma_mapping_error(struct device *dev,
 					  dma_addr_t dma_addr)
 {
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index ac07ff090919..d6437b493300 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -26,11 +26,17 @@ struct dma_map_ops {
 
 	int (*get_sgtable)(struct device *dev, struct sg_table *sgt, void *,
 			   dma_addr_t, size_t, struct dma_attrs *attrs);
-
+#ifdef CONFIG_HAVE_DMA_PFN
+	dma_addr_t (*map_pfn)(struct device *dev, __pfn_t pfn,
+			      unsigned long offset, size_t size,
+			      enum dma_data_direction dir,
+			      struct dma_attrs *attrs);
+#else
 	dma_addr_t (*map_page)(struct device *dev, struct page *page,
 			       unsigned long offset, size_t size,
 			       enum dma_data_direction dir,
 			       struct dma_attrs *attrs);
+#endif
 	void (*unmap_page)(struct device *dev, dma_addr_t dma_handle,
 			   size_t size, enum dma_data_direction dir,
 			   struct dma_attrs *attrs);
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index ae4b65e17e64..c24de1cd8f81 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -1250,11 +1250,12 @@ out:
 	put_hash_bucket(bucket, &flags);
 }
 
-void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
+void debug_dma_map_pfn(struct device *dev, __pfn_t pfn, size_t offset,
 			size_t size, int direction, dma_addr_t dma_addr,
 			bool map_single)
 {
 	struct dma_debug_entry *entry;
+	struct page *page;
 
 	if (unlikely(dma_debug_disabled()))
 		return;
@@ -1268,7 +1269,7 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 
 	entry->dev       = dev;
 	entry->type      = dma_debug_page;
-	entry->pfn	 = page_to_pfn(page);
+	entry->pfn	 = __pfn_t_to_pfn(pfn);
 	entry->offset	 = offset,
 	entry->dev_addr  = dma_addr;
 	entry->size      = size;
@@ -1278,7 +1279,8 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 	if (map_single)
 		entry->type = dma_debug_single;
 
-	if (!PageHighMem(page)) {
+	page = __pfn_t_to_page(pfn);
+	if (page && !PageHighMem(page)) {
 		void *addr = page_address(page) + offset;
 
 		check_for_stack(dev, addr);
@@ -1287,7 +1289,7 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 
 	add_dma_entry(entry);
 }
-EXPORT_SYMBOL(debug_dma_map_page);
+EXPORT_SYMBOL(debug_dma_map_pfn);
 
 void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {

