Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2FF5E22646310
 for <linux-nvdimm@lists.01.org>; Mon, 12 Mar 2018 12:29:12 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Mon, 12 Mar 2018 13:35:17 -0600
Message-Id: <20180312193525.2855-4-logang@deltatee.com>
In-Reply-To: <20180312193525.2855-1-logang@deltatee.com>
References: <20180312193525.2855-1-logang@deltatee.com>
Subject: [PATCH v3 03/11] PCI/P2PDMA: Add PCI p2pmem dma mappings to adjust
 the bus offset
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
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

The DMA address used when mapping PCI P2P memory must be the PCI bus
address. Thus, introduce pci_p2pmem_[un]map_sg() to map the correct
addresses when using P2P memory.

For this, we assume that an SGL passed to these functions contain all
P2P memory or no P2P memory.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/pci/p2pdma.c       | 51 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/memremap.h   |  1 +
 include/linux/pci-p2pdma.h | 13 ++++++++++++
 3 files changed, 65 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index fd4789566a56..ab810c3a93eb 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -190,6 +190,8 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	pgmap->res.flags = pci_resource_flags(pdev, bar);
 	pgmap->ref = &pdev->p2pdma->devmap_ref;
 	pgmap->type = MEMORY_DEVICE_PCI_P2PDMA;
+	pgmap->pci_p2pdma_bus_offset = pci_bus_address(pdev, bar) -
+		pci_resource_start(pdev, bar);
 
 	addr = devm_memremap_pages(&pdev->dev, pgmap);
 	if (IS_ERR(addr)) {
@@ -731,3 +733,52 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
 	pdev->p2pdma->p2pmem_published = publish;
 }
 EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
+
+/**
+ * pci_p2pdma_map_sg - map a PCI peer-to-peer sg for DMA
+ * @dev: device doing the DMA request
+ * @sg: scatter list to map
+ * @nents: elements in the scatterlist
+ * @dir: DMA direction
+ *
+ * Returns the number of SG entries mapped
+ */
+int pci_p2pdma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+		      enum dma_data_direction dir)
+{
+	struct dev_pagemap *pgmap;
+	struct scatterlist *s;
+	phys_addr_t paddr;
+	int i;
+
+	/*
+	 * p2pdma mappings are not compatible with devices that use
+	 * dma_virt_ops.
+	 */
+	if (IS_ENABLED(CONFIG_DMA_VIRT_OPS) && dev->dma_ops == &dma_virt_ops)
+		return 0;
+
+	for_each_sg(sg, s, nents, i) {
+		pgmap = sg_page(s)->pgmap;
+		paddr = sg_phys(s);
+
+		s->dma_address = paddr - pgmap->pci_p2pdma_bus_offset;
+		sg_dma_len(s) = s->length;
+	}
+
+	return nents;
+}
+EXPORT_SYMBOL_GPL(pci_p2pdma_map_sg);
+
+/**
+ * pci_p2pdma_unmap_sg - unmap a PCI peer-to-peer sg for DMA
+ * @dev: device doing the DMA request
+ * @sg: scatter list to map
+ * @nents: elements in the scatterlist
+ * @dir: DMA direction
+ */
+void pci_p2pdma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
+			 enum dma_data_direction dir)
+{
+}
+EXPORT_SYMBOL_GPL(pci_p2pdma_unmap_sg);
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 9e907c338a44..1660f64ce96f 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -125,6 +125,7 @@ struct dev_pagemap {
 	struct device *dev;
 	void *data;
 	enum memory_type type;
+	u64 pci_p2pdma_bus_offset;
 };
 
 #ifdef CONFIG_ZONE_DEVICE
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 1f7856ff098b..59eb218bdb25 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -36,6 +36,10 @@ int pci_p2pmem_alloc_sgl(struct pci_dev *pdev, struct scatterlist **sgl,
 void pci_p2pmem_free_sgl(struct pci_dev *pdev, struct scatterlist *sgl,
 		unsigned int nents);
 void pci_p2pmem_publish(struct pci_dev *pdev, bool publish);
+int pci_p2pdma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+		      enum dma_data_direction dir);
+void pci_p2pdma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
+			 enum dma_data_direction dir);
 #else /* CONFIG_PCI_P2PDMA */
 static inline int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar,
 		size_t size, u64 offset)
@@ -97,5 +101,14 @@ static inline void pci_p2pmem_free_sgl(struct pci_dev *pdev,
 static inline void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
 {
 }
+static inline int pci_p2pdma_map_sg(struct device *dev,
+	struct scatterlist *sg, int nents, enum dma_data_direction dir)
+{
+	return 0;
+}
+static inline void pci_p2pdma_unmap_sg(struct device *dev,
+	struct scatterlist *sg, int nents, enum dma_data_direction dir)
+{
+}
 #endif /* CONFIG_PCI_P2PDMA */
 #endif /* _LINUX_PCI_P2P_H */
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
