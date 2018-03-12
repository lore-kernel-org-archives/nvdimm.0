Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 341102264631F
 for <linux-nvdimm@lists.01.org>; Mon, 12 Mar 2018 12:29:12 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Mon, 12 Mar 2018 13:35:18 -0600
Message-Id: <20180312193525.2855-5-logang@deltatee.com>
In-Reply-To: <20180312193525.2855-1-logang@deltatee.com>
References: <20180312193525.2855-1-logang@deltatee.com>
Subject: [PATCH v3 04/11] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
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

For peer-to-peer transactions to work the downstream ports in each
switch must not have the ACS flags set. At this time there is no way
to dynamically change the flags and update the corresponding IOMMU
groups so this is done at enumeration time before the groups are
assigned.

This effectively means that if CONFIG_PCI_P2PDMA is selected then
all devices behind any PCIe switch will be in the same IOMMU group.
Which implies that individual devices behind any switch will not be
able to be assigned to separate VMs because there is no isolation
between them. Additionally, any malicious PCIe devices will be able
to DMA to memory exposed by other EPs in the same domain as TLPs will
not be checked by the IOMMU.

Given that the intended use case of P2P Memory is for users with
custom hardware designed for purpose, we do not expect distributors
to ever need to enable this option. Users that want to use P2P
must have compiled a custom kernel with this configuration option
and understand the implications regarding ACS. They will either
not require ACS or will have design the system in such a way that
devices that require isolation will be separate from those using P2P
transactions.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/pci/Kconfig        |  9 +++++++++
 drivers/pci/p2pdma.c       | 44 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.c          |  6 ++++++
 include/linux/pci-p2pdma.h |  5 +++++
 4 files changed, 64 insertions(+)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index d59f6f5ddfcd..c7a9d155baca 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -138,6 +138,15 @@ config PCI_P2PDMA
 	  it's hard to tell which support it at all, so at this time you
 	  will need a PCIe switch.
 
+	  Enabling this option will also disable ACS on all ports behind
+	  any PCIe switch. This effectively puts all devices behind any
+	  switch into the same IOMMU group. Which implies that individual
+	  devices behind any switch will not be able to be assigned to
+	  separate VMs because there is no isolation between them.
+	  Additionally, any malicious PCIe devices will be able to DMA
+	  to memory exposed by other EPs in the same domain as TLPs will
+	  not be checked by the IOMMU.
+
 	  If unsure, say N.
 
 config PCI_LABEL
diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index ab810c3a93eb..3e70b0662def 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -264,6 +264,50 @@ static struct pci_dev *get_upstream_bridge_port(struct pci_dev *pdev)
 }
 
 /*
+ * pci_p2pdma_disable_acs - disable ACS flags for ports in PCI
+ *	bridges/switches
+ * @pdev: device to disable ACS flags for
+ *
+ * The ACS flags for P2P Request Redirect and P2P Completion Redirect need
+ * to be disabled on any downstream port in any switch in order for
+ * the TLPs to not be forwarded up to the RC which is not what we want
+ * for P2P.
+ *
+ * This function is called when the devices are first enumerated and
+ * will result in all devices behind any switch to be in the same IOMMU
+ * group. At this time there is no way to "hotplug" IOMMU groups so we rely
+ * on this largish hammer. If you need the devices to be in separate groups
+ * don't enable CONFIG_PCI_P2PDMA.
+ *
+ * Returns 1 if the ACS bits for this device were cleared, otherwise 0.
+ */
+int pci_p2pdma_disable_acs(struct pci_dev *pdev)
+{
+	struct pci_dev *up;
+	int pos;
+	u16 ctrl;
+
+	up = get_upstream_bridge_port(pdev);
+	if (!up)
+		return 0;
+	pci_dev_put(up);
+
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
+	if (!pos)
+		return 0;
+
+	pci_info(pdev, "disabling ACS flags for peer-to-peer DMA\n");
+
+	pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
+
+	ctrl &= ~(PCI_ACS_RR | PCI_ACS_CR);
+
+	pci_write_config_word(pdev, pos + PCI_ACS_CTRL, ctrl);
+
+	return 1;
+}
+
+/*
  * This function checks if two PCI devices are behind the same switch.
  * (ie. they share the same second upstream port as returned by
  *  get_upstream_bridge_port().)
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index f6a4dd10d9b0..e5da8f482e94 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -16,6 +16,7 @@
 #include <linux/of.h>
 #include <linux/of_pci.h>
 #include <linux/pci.h>
+#include <linux/pci-p2pdma.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -2826,6 +2827,11 @@ static void pci_std_enable_acs(struct pci_dev *dev)
  */
 void pci_enable_acs(struct pci_dev *dev)
 {
+#ifdef CONFIG_PCI_P2PDMA
+	if (pci_p2pdma_disable_acs(dev))
+		return;
+#endif
+
 	if (!pci_acs_enable)
 		return;
 
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 59eb218bdb25..2a2bf2ca018e 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -18,6 +18,7 @@ struct block_device;
 struct scatterlist;
 
 #ifdef CONFIG_PCI_P2PDMA
+int pci_p2pdma_disable_acs(struct pci_dev *pdev);
 int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 		u64 offset);
 int pci_p2pdma_add_client(struct list_head *head, struct device *dev);
@@ -41,6 +42,10 @@ int pci_p2pdma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 void pci_p2pdma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
 			 enum dma_data_direction dir);
 #else /* CONFIG_PCI_P2PDMA */
+static inline int pci_p2pdma_disable_acs(struct pci_dev *pdev)
+{
+	return 0;
+}
 static inline int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar,
 		size_t size, u64 offset)
 {
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
