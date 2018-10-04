Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7AB1821157FFA
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 14:27:58 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu,  4 Oct 2018 15:27:38 -0600
Message-Id: <20181004212747.6301-5-logang@deltatee.com>
In-Reply-To: <20181004212747.6301-1-logang@deltatee.com>
References: <20181004212747.6301-1-logang@deltatee.com>
MIME-Version: 1.0
Subject: [PATCH v9 04/13] PCI/P2PDMA: Introduce configfs/sysfs enable
 attribute helpers
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
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Users of the P2PDMA infrastructure will typically need a way for
the user to tell the kernel to use P2P resources. Typically
this will be a simple on/off boolean operation but sometimes
it may be desirable for the user to specify the exact device to
use for the P2P operation.

Add new helpers for attributes which take a boolean or a PCI device.
Any boolean as accepted by strtobool() turn P2P on or off (such as 'y', 'n',
'1', '0', etc). Specifying a full PCI device name/BDF will select the
specific device.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/p2pdma.c       | 82 ++++++++++++++++++++++++++++++++++++++
 include/linux/pci-p2pdma.h | 15 +++++++
 2 files changed, 97 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index e914f04ea1ec..b18b3703ab79 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -8,6 +8,8 @@
  * Copyright (c) 2018, Eideticom Inc.
  */
 
+#define pr_fmt(fmt) "pci-p2pdma: " fmt
+#include <linux/ctype.h>
 #include <linux/pci-p2pdma.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -725,3 +727,83 @@ int pci_p2pdma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	return nents;
 }
 EXPORT_SYMBOL_GPL(pci_p2pdma_map_sg);
+
+/**
+ * pci_p2pdma_enable_store - parse a configfs/sysfs attribute store
+ *		to enable p2pdma
+ * @page: contents of the value to be stored
+ * @p2p_dev: returns the PCI device that was selected to be used
+ *		(if one was specified in the stored value)
+ * @use_p2pdma: returns whether to enable p2pdma or not
+ *
+ * Parses an attribute value to decide whether to enable p2pdma.
+ * The value can select a PCI device (using it's full BDF device
+ * name) or a boolean (in any format strtobool() accepts). A false
+ * value disables p2pdma, a true value expects the caller
+ * to automatically find a compatible device and specifying a PCI device
+ * expects the caller to use the specific provider.
+ *
+ * pci_p2pdma_enable_show() should be used as the show operation for
+ * the attribute.
+ *
+ * Returns 0 on success
+ */
+int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
+			    bool *use_p2pdma)
+{
+	struct device *dev;
+
+	dev = bus_find_device_by_name(&pci_bus_type, NULL, page);
+	if (dev) {
+		*use_p2pdma = true;
+		*p2p_dev = to_pci_dev(dev);
+
+		if (!pci_has_p2pmem(*p2p_dev)) {
+			pci_err(*p2p_dev,
+				"PCI device has no peer-to-peer memory: %s\n",
+				page);
+			pci_dev_put(*p2p_dev);
+			return -ENODEV;
+		}
+
+		return 0;
+	} else if ((page[0] == '0' || page[0] == '1') && !iscntrl(page[1])) {
+		/*
+		 * If the user enters a PCI device that  doesn't exist
+		 * like "0000:01:00.1", we don't want strtobool to think
+		 * it's a '0' when it's clearly not what the user wanted.
+		 * So we require 0's and 1's to be exactly one character.
+		 */
+	} else if (!strtobool(page, use_p2pdma)) {
+		return 0;
+	}
+
+	pr_err("No such PCI device: %.*s\n", (int)strcspn(page, "\n"), page);
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(pci_p2pdma_enable_store);
+
+/**
+ * pci_p2pdma_enable_show - show a configfs/sysfs attribute indicating
+ *		whether p2pdma is enabled
+ * @page: contents of the stored value
+ * @p2p_dev: the selected p2p device (NULL if no device is selected)
+ * @use_p2pdma: whether p2pdme has been enabled
+ *
+ * Attributes that use pci_p2pdma_enable_store() should use this function
+ * to show the value of the attribute.
+ *
+ * Returns 0 on success
+ */
+ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
+			       bool use_p2pdma)
+{
+	if (!use_p2pdma)
+		return sprintf(page, "0\n");
+
+	if (!p2p_dev)
+		return sprintf(page, "1\n");
+
+	return sprintf(page, "%s\n", pci_name(p2p_dev));
+}
+EXPORT_SYMBOL_GPL(pci_p2pdma_enable_show);
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index b6dfb6dc2e53..bca9bc3e5be7 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -32,6 +32,10 @@ void pci_p2pmem_free_sgl(struct pci_dev *pdev, struct scatterlist *sgl);
 void pci_p2pmem_publish(struct pci_dev *pdev, bool publish);
 int pci_p2pdma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 		      enum dma_data_direction dir);
+int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
+			    bool *use_p2pdma);
+ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
+			       bool use_p2pdma);
 #else /* CONFIG_PCI_P2PDMA */
 static inline int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar,
 		size_t size, u64 offset)
@@ -82,6 +86,17 @@ static inline int pci_p2pdma_map_sg(struct device *dev,
 {
 	return 0;
 }
+static inline int pci_p2pdma_enable_store(const char *page,
+		struct pci_dev **p2p_dev, bool *use_p2pdma)
+{
+	*use_p2pdma = false;
+	return 0;
+}
+static inline ssize_t pci_p2pdma_enable_show(char *page,
+		struct pci_dev *p2p_dev, bool use_p2pdma)
+{
+	return sprintf(page, "none\n");
+}
 #endif /* CONFIG_PCI_P2PDMA */
 
 
-- 
2.19.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
