Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1BFA621F833AF
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 10:59:59 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu,  4 Jan 2018 12:01:28 -0700
Message-Id: <20180104190137.7654-4-logang@deltatee.com>
In-Reply-To: <20180104190137.7654-1-logang@deltatee.com>
References: <20180104190137.7654-1-logang@deltatee.com>
Subject: [PATCH 03/12] pci-p2p: Add PCI p2pmem dma mappings to adjust the bus
 offset
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
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Keith Busch <keith.busch@intel.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

The DMA address used when mapping PCI P2P memory must be the PCI bus
address. Thus, introduce pci_p2pmem_[un]map_sg() to map the correct
addresses when using P2P memory.

For this, we assume that an SGL passed to these functions contain all
p2p memory or no p2p memory.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/pci/p2p.c        | 43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/memremap.h |  1 +
 include/linux/pci-p2p.h  |  9 +++++++++
 3 files changed, 53 insertions(+)

diff --git a/drivers/pci/p2p.c b/drivers/pci/p2p.c
index 03330c7b5e6d..87cec87b02e3 100644
--- a/drivers/pci/p2p.c
+++ b/drivers/pci/p2p.c
@@ -184,6 +184,8 @@ int pci_p2pmem_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	pgmap->res.end = pgmap->res.start + size - 1;
 	pgmap->ref = &pdev->p2p->devmap_ref;
 	pgmap->type = MEMORY_DEVICE_PCI_P2P;
+	pgmap->pci_p2p_bus_offset = pci_bus_address(pdev, bar) -
+		pci_resource_start(pdev, bar);
 
 	addr = devm_memremap_pages(&pdev->dev, pgmap);
 	if (IS_ERR(addr))
@@ -598,3 +600,44 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
 	pdev->p2p->published = publish;
 }
 EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
+
+/*
+ * pci_p2pmem_map_sg - map a pci p2p sg for dma
+ * @sg:scatter list to map
+ * @nents:elements in the scatter list
+ *
+ * Returns the number of sgls mapped
+ */
+int pci_p2pmem_map_sg(struct scatterlist *sg, int nents)
+{
+	struct dev_pagemap *pgmap;
+	struct scatterlist *s;
+	phys_addr_t paddr;
+	int i;
+
+	for_each_sg(sg, s, nents, i) {
+		pgmap = sg_page(s)->pgmap;
+		paddr = sg_phys(s);
+
+		s->dma_address = paddr - pgmap->pci_p2p_bus_offset;
+		sg_dma_len(s) = s->length;
+	}
+
+	return nents;
+}
+EXPORT_SYMBOL_GPL(pci_p2pmem_map_sg);
+
+/**
+ * pci_p2pmem_unmap_sg - unmap a pci p2p sg for dma
+ * @sg:scatter list to map
+ * @nents:elements in the scatter list
+ */
+void pci_p2pmem_unmap_sg(struct scatterlist *sg, int nents)
+{
+	struct scatterlist *s;
+	int i;
+
+	for_each_sg(sg, s, nents, i)
+		dma_mark_clean(phys_to_virt(sg_phys(s)), sg_dma_len(s));
+}
+EXPORT_SYMBOL_GPL(pci_p2pmem_unmap_sg);
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index c17a6d167d48..a792f87b9dc3 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -125,6 +125,7 @@ struct dev_pagemap {
 	struct device *dev;
 	void *data;
 	enum memory_type type;
+	u64 pci_p2p_bus_offset;
 };
 
 #ifdef CONFIG_ZONE_DEVICE
diff --git a/include/linux/pci-p2p.h b/include/linux/pci-p2p.h
index f811c97a5886..154c39905fc9 100644
--- a/include/linux/pci-p2p.h
+++ b/include/linux/pci-p2p.h
@@ -34,6 +34,8 @@ int pci_p2pmem_alloc_sgl(struct pci_dev *pdev, struct scatterlist **sgl,
 void pci_p2pmem_free_sgl(struct pci_dev *pdev, struct scatterlist *sgl,
 		unsigned int nents);
 void pci_p2pmem_publish(struct pci_dev *pdev, bool publish);
+int pci_p2pmem_map_sg(struct scatterlist *sg, int nents);
+void pci_p2pmem_unmap_sg(struct scatterlist *sg, int nents);
 #else /* CONFIG_PCI_P2P */
 static inline int pci_p2pmem_add_resource(struct pci_dev *pdev, int bar,
 		size_t size, u64 offset)
@@ -81,5 +83,12 @@ static inline void pci_p2pmem_free_sgl(struct pci_dev *pdev,
 static inline void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
 {
 }
+static inline int pci_p2pmem_map_sg(struct scatterlist *sg, int nents)
+{
+	return -ENODEV;
+}
+static inline void pci_p2pmem_unmap_sg(struct scatterlist *sg, int nents)
+{
+}
 #endif /* CONFIG_PCI_P2P */
 #endif /* _LINUX_PCI_P2P_H */
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
