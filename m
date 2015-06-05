Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v4 9/9] x86: convert dma_map_ops to support mapping a
 __pfn_t.
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 05 Jun 2015 17:19:55 -0400
Message-ID: <20150605211955.20751.15047.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, arnd@arndb.de, ross.zwisler@linux.intel.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, benh@kernel.crashing.org, linux-nvdimm@lists.01.org, heiko.carstens@de.ibm.com, hch@lst.de, tj@kernel.org, paulus@samba.org, hpa@zytor.com, schwidefsky@de.ibm.com, willy@linux.intel.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

As long as a dma_map_sg() implementation avoids sg_page() conversions it
can support scatterlists that carry "page-less" __pfn_t entries.
However, a couple implementations require that __pfn_t_has_page() is
always true. The Xen swiotlb implementation's entanglements with ARM and
the Calgary MMUs requirement to have a pre-existing virtual mapping make
them unable to support this conversion (i.e. these now have 'depends on
!HAVE_DMA_PFN').

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/Kconfig                         |    2 ++
 arch/x86/kernel/amd_gart_64.c            |   22 +++++++++++++++++-----
 arch/x86/kernel/pci-nommu.c              |   22 +++++++++++++++++-----
 arch/x86/kernel/pci-swiotlb.c            |    4 ++++
 arch/x86/pci/sta2x11-fixup.c             |    4 ++++
 drivers/iommu/amd_iommu.c                |   21 ++++++++++++++++-----
 drivers/iommu/intel-iommu.c              |   22 +++++++++++++++++-----
 drivers/pci/Kconfig                      |    2 +-
 include/asm-generic/dma-mapping-common.h |    4 ++--
 include/linux/scatterlist.h              |    4 ++--
 include/linux/swiotlb.h                  |    4 ++++
 lib/swiotlb.c                            |   20 +++++++++++++++-----
 12 files changed, 101 insertions(+), 30 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 130d1a4c2efc..2fd7690ed0e2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -796,6 +796,7 @@ config CALGARY_IOMMU
 	bool "IBM Calgary IOMMU support"
 	select SWIOTLB
 	depends on X86_64 && PCI
+	depends on !HAVE_DMA_PFN
 	---help---
 	  Support for hardware IOMMUs in IBM's xSeries x366 and x460
 	  systems. Needed to run systems with more than 3GB of memory
@@ -1436,6 +1437,7 @@ config X86_PMEM_DMA
 	depends on !HIGHMEM
 	def_bool DEV_PFN
 	select HAVE_KMAP_PFN
+	select HAVE_DMA_PFN
 
 config HIGHPTE
 	bool "Allocate 3rd-level pagetables from highmem"
diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
index 8e3842fc8bea..8fad83c8dfd2 100644
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -239,13 +239,13 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 }
 
 /* Map a single area into the IOMMU */
-static dma_addr_t gart_map_page(struct device *dev, struct page *page,
-				unsigned long offset, size_t size,
-				enum dma_data_direction dir,
-				struct dma_attrs *attrs)
+static dma_addr_t gart_map_pfn(struct device *dev, __pfn_t pfn,
+			       unsigned long offset, size_t size,
+			       enum dma_data_direction dir,
+			       struct dma_attrs *attrs)
 {
 	unsigned long bus;
-	phys_addr_t paddr = page_to_phys(page) + offset;
+	phys_addr_t paddr = __pfn_t_to_phys(pfn) + offset;
 
 	if (!dev)
 		dev = &x86_dma_fallback_dev;
@@ -259,6 +259,14 @@ static dma_addr_t gart_map_page(struct device *dev, struct page *page,
 	return bus;
 }
 
+static __maybe_unused dma_addr_t gart_map_page(struct device *dev,
+		struct page *page, unsigned long offset, size_t size,
+		enum dma_data_direction dir, struct dma_attrs *attrs)
+{
+	return gart_map_pfn(dev, page_to_pfn_t(page), offset, size, dir,
+			attrs);
+}
+
 /*
  * Free a DMA mapping.
  */
@@ -699,7 +707,11 @@ static __init int init_amd_gatt(struct agp_kern_info *info)
 static struct dma_map_ops gart_dma_ops = {
 	.map_sg				= gart_map_sg,
 	.unmap_sg			= gart_unmap_sg,
+#ifdef CONFIG_HAVE_DMA_PFN
+	.map_pfn			= gart_map_pfn,
+#else
 	.map_page			= gart_map_page,
+#endif
 	.unmap_page			= gart_unmap_page,
 	.alloc				= gart_alloc_coherent,
 	.free				= gart_free_coherent,
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index da15918d1c81..876dacfbabf6 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -25,12 +25,12 @@ check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
 	return 1;
 }
 
-static dma_addr_t nommu_map_page(struct device *dev, struct page *page,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction dir,
-				 struct dma_attrs *attrs)
+static dma_addr_t nommu_map_pfn(struct device *dev, __pfn_t pfn,
+				unsigned long offset, size_t size,
+				enum dma_data_direction dir,
+				struct dma_attrs *attrs)
 {
-	dma_addr_t bus = page_to_phys(page) + offset;
+	dma_addr_t bus = __pfn_t_to_phys(pfn) + offset;
 	WARN_ON(size == 0);
 	if (!check_addr("map_single", dev, bus, size))
 		return DMA_ERROR_CODE;
@@ -38,6 +38,14 @@ static dma_addr_t nommu_map_page(struct device *dev, struct page *page,
 	return bus;
 }
 
+static __maybe_unused dma_addr_t nommu_map_page(struct device *dev,
+		struct page *page, unsigned long offset, size_t size,
+		enum dma_data_direction dir, struct dma_attrs *attrs)
+{
+	return nommu_map_pfn(dev, page_to_pfn_t(page), offset, size, dir,
+			attrs);
+}
+
 /* Map a set of buffers described by scatterlist in streaming
  * mode for DMA.  This is the scatter-gather version of the
  * above pci_map_single interface.  Here the scatter gather list
@@ -92,7 +100,11 @@ struct dma_map_ops nommu_dma_ops = {
 	.alloc			= dma_generic_alloc_coherent,
 	.free			= dma_generic_free_coherent,
 	.map_sg			= nommu_map_sg,
+#ifdef CONFIG_HAVE_DMA_PFN
+	.map_pfn		= nommu_map_pfn,
+#else
 	.map_page		= nommu_map_page,
+#endif
 	.sync_single_for_device = nommu_sync_single_for_device,
 	.sync_sg_for_device	= nommu_sync_sg_for_device,
 	.is_phys		= 1,
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 77dd0ad58be4..5351eb8c8f7f 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -48,7 +48,11 @@ static struct dma_map_ops swiotlb_dma_ops = {
 	.sync_sg_for_device = swiotlb_sync_sg_for_device,
 	.map_sg = swiotlb_map_sg_attrs,
 	.unmap_sg = swiotlb_unmap_sg_attrs,
+#ifdef CONFIG_HAVE_DMA_PFN
+	.map_pfn = swiotlb_map_pfn,
+#else
 	.map_page = swiotlb_map_page,
+#endif
 	.unmap_page = swiotlb_unmap_page,
 	.dma_supported = NULL,
 };
diff --git a/arch/x86/pci/sta2x11-fixup.c b/arch/x86/pci/sta2x11-fixup.c
index 5ceda85b8687..d1c6e3808bb5 100644
--- a/arch/x86/pci/sta2x11-fixup.c
+++ b/arch/x86/pci/sta2x11-fixup.c
@@ -182,7 +182,11 @@ static void *sta2x11_swiotlb_alloc_coherent(struct device *dev,
 static struct dma_map_ops sta2x11_dma_ops = {
 	.alloc = sta2x11_swiotlb_alloc_coherent,
 	.free = x86_swiotlb_free_coherent,
+#ifdef CONFIG_HAVE_DMA_PFN
+	.map_pfn = swiotlb_map_pfn,
+#else
 	.map_page = swiotlb_map_page,
+#endif
 	.unmap_page = swiotlb_unmap_page,
 	.map_sg = swiotlb_map_sg_attrs,
 	.unmap_sg = swiotlb_unmap_sg_attrs,
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index e43d48956dea..ee8f70224b73 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2754,16 +2754,15 @@ static void __unmap_single(struct dma_ops_domain *dma_dom,
 /*
  * The exported map_single function for dma_ops.
  */
-static dma_addr_t map_page(struct device *dev, struct page *page,
-			   unsigned long offset, size_t size,
-			   enum dma_data_direction dir,
-			   struct dma_attrs *attrs)
+static dma_addr_t map_pfn(struct device *dev, __pfn_t pfn, unsigned long offset,
+		size_t size, enum dma_data_direction dir,
+		struct dma_attrs *attrs)
 {
 	unsigned long flags;
 	struct protection_domain *domain;
 	dma_addr_t addr;
 	u64 dma_mask;
-	phys_addr_t paddr = page_to_phys(page) + offset;
+	phys_addr_t paddr = __pfn_t_to_phys(pfn) + offset;
 
 	INC_STATS_COUNTER(cnt_map_single);
 
@@ -2788,6 +2787,14 @@ out:
 	spin_unlock_irqrestore(&domain->lock, flags);
 
 	return addr;
+
+}
+
+static __maybe_unused dma_addr_t map_page(struct device *dev, struct page *page,
+		unsigned long offset, size_t size, enum dma_data_direction dir,
+		struct dma_attrs *attrs)
+{
+	return map_pfn(dev, page_to_pfn_t(page), offset, size, dir, attrs);
 }
 
 /*
@@ -3062,7 +3069,11 @@ static void __init prealloc_protection_domains(void)
 static struct dma_map_ops amd_iommu_dma_ops = {
 	.alloc = alloc_coherent,
 	.free = free_coherent,
+#ifdef CONFIG_HAVE_DMA_PFN
+	.map_pfn = map_pfn,
+#else
 	.map_page = map_page,
+#endif
 	.unmap_page = unmap_page,
 	.map_sg = map_sg,
 	.unmap_sg = unmap_sg,
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 9b9ada71e0d3..6d9a0f85b827 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3086,15 +3086,23 @@ error:
 	return 0;
 }
 
-static dma_addr_t intel_map_page(struct device *dev, struct page *page,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction dir,
-				 struct dma_attrs *attrs)
+static dma_addr_t intel_map_pfn(struct device *dev, __pfn_t pfn,
+				unsigned long offset, size_t size,
+				enum dma_data_direction dir,
+				struct dma_attrs *attrs)
 {
-	return __intel_map_single(dev, page_to_phys(page) + offset, size,
+	return __intel_map_single(dev, __pfn_t_to_phys(pfn) + offset, size,
 				  dir, *dev->dma_mask);
 }
 
+static __maybe_unused dma_addr_t intel_map_page(struct device *dev,
+		struct page *page, unsigned long offset, size_t size,
+		enum dma_data_direction dir, struct dma_attrs *attrs)
+{
+	return intel_map_pfn(dev, page_to_pfn_t(page), offset, size, dir,
+			attrs);
+}
+
 static void flush_unmaps(void)
 {
 	int i, j;
@@ -3380,7 +3388,11 @@ struct dma_map_ops intel_dma_ops = {
 	.free = intel_free_coherent,
 	.map_sg = intel_map_sg,
 	.unmap_sg = intel_unmap_sg,
+#ifdef CONFIG_HAVE_DMA_PFN
+	.map_pfn = intel_map_pfn,
+#else
 	.map_page = intel_map_page,
+#endif
 	.unmap_page = intel_unmap_page,
 	.mapping_error = intel_mapping_error,
 };
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 7a8f1c5e65af..e56b04e24ec6 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -56,7 +56,7 @@ config PCI_STUB
 
 config XEN_PCIDEV_FRONTEND
         tristate "Xen PCI Frontend"
-        depends on PCI && X86 && XEN
+        depends on PCI && X86 && XEN && !HAVE_DMA_PFN
         select PCI_XEN
 	select XEN_XENBUS_FRONTEND
         default y
diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index 7305efb1bac6..e031b079ce4e 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -18,7 +18,7 @@ static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
 	kmemcheck_mark_initialized(ptr, size);
 	BUG_ON(!valid_dma_direction(dir));
 #ifdef CONFIG_HAVE_DMA_PFN
-	addr = ops->map_pfn(dev, page_to_pfn_typed(virt_to_page(ptr)),
+	addr = ops->map_pfn(dev, page_to_pfn_t(virt_to_page(ptr)),
 			     (unsigned long)ptr & ~PAGE_MASK, size,
 			     dir, attrs);
 #else
@@ -99,7 +99,7 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 				      enum dma_data_direction dir)
 {
 	kmemcheck_mark_initialized(page_address(page) + offset, size);
-	return dma_map_pfn(dev, page_to_pfn_typed(page), offset, size, dir);
+	return dma_map_pfn(dev, page_to_pfn_t(page), offset, size, dir);
 }
 #else
 static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 49054374646e..20334222d0c9 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -158,9 +158,9 @@ static inline struct page *sg_page(struct scatterlist *sg)
 	return page;
 }
 
-static inline unsigned long sg_pfn(struct scatterlist *sg)
+static inline __pfn_t sg_pfn(struct scatterlist *sg)
 {
-	return __pfn_t_to_pfn(sg->pfn);
+	return sg->pfn;
 }
 
 /**
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index e7a018eaf3a2..5093fc8d2825 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -66,6 +66,10 @@ extern dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 				   unsigned long offset, size_t size,
 				   enum dma_data_direction dir,
 				   struct dma_attrs *attrs);
+extern dma_addr_t swiotlb_map_pfn(struct device *dev, __pfn_t pfn,
+				  unsigned long offset, size_t size,
+				  enum dma_data_direction dir,
+				  struct dma_attrs *attrs);
 extern void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
 			       size_t size, enum dma_data_direction dir,
 			       struct dma_attrs *attrs);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 341268841b31..5ab7566735ba 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -727,12 +727,12 @@ swiotlb_full(struct device *dev, size_t size, enum dma_data_direction dir,
  * Once the device is given the dma address, the device owns this memory until
  * either swiotlb_unmap_page or swiotlb_dma_sync_single is performed.
  */
-dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
-			    unsigned long offset, size_t size,
-			    enum dma_data_direction dir,
-			    struct dma_attrs *attrs)
+dma_addr_t swiotlb_map_pfn(struct device *dev, __pfn_t pfn,
+			   unsigned long offset, size_t size,
+			   enum dma_data_direction dir,
+			   struct dma_attrs *attrs)
 {
-	phys_addr_t map, phys = page_to_phys(page) + offset;
+	phys_addr_t map, phys = __pfn_t_to_phys(pfn) + offset;
 	dma_addr_t dev_addr = phys_to_dma(dev, phys);
 
 	BUG_ON(dir == DMA_NONE);
@@ -763,6 +763,16 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 
 	return dev_addr;
 }
+EXPORT_SYMBOL_GPL(swiotlb_map_pfn);
+
+dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
+			    unsigned long offset, size_t size,
+			    enum dma_data_direction dir,
+			    struct dma_attrs *attrs)
+{
+	return swiotlb_map_pfn(dev, page_to_pfn_t(page), offset, size, dir,
+			attrs);
+}
 EXPORT_SYMBOL_GPL(swiotlb_map_page);
 
 /*

