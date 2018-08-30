Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E48702194D3AE
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 11:54:04 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 30 Aug 2018 12:53:48 -0600
Message-Id: <20180830185352.3369-10-logang@deltatee.com>
In-Reply-To: <20180830185352.3369-1-logang@deltatee.com>
References: <20180830185352.3369-1-logang@deltatee.com>
Subject: [PATCH v5 09/13] nvme-pci: Use PCI p2pmem subsystem to manage the CMB
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
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Register the CMB buffer as p2pmem and use the appropriate allocation
functions to create and destroy the IO submission queues.

If the CMB supports WDS and RDS, publish it for use as P2P memory
by other devices.

Kernels without CONFIG_PCI_P2PDMA will also no longer support NVMe CMB.
However, seeing the main use-cases for the CMB is P2P operations,
this seems like a reasonable dependency.

We drop the __iomem safety on the buffer seeing that, by convention, it's
safe to directly access memory mapped by memremap()/devm_memremap_pages().
Architectures where this is not safe will not be supported by memremap()
and therefore will not be support PCI P2P and have no support for CMB.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/nvme/host/pci.c | 80 +++++++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 35 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 1b9951d2067e..2902585c6ddf 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -30,6 +30,7 @@
 #include <linux/types.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/sed-opal.h>
+#include <linux/pci-p2pdma.h>
 
 #include "nvme.h"
 
@@ -99,9 +100,8 @@ struct nvme_dev {
 	struct work_struct remove_work;
 	struct mutex shutdown_lock;
 	bool subsystem;
-	void __iomem *cmb;
-	pci_bus_addr_t cmb_bus_addr;
 	u64 cmb_size;
+	bool cmb_use_sqes;
 	u32 cmbsz;
 	u32 cmbloc;
 	struct nvme_ctrl ctrl;
@@ -158,7 +158,7 @@ struct nvme_queue {
 	struct nvme_dev *dev;
 	spinlock_t sq_lock;
 	struct nvme_command *sq_cmds;
-	struct nvme_command __iomem *sq_cmds_io;
+	bool sq_cmds_is_io;
 	spinlock_t cq_lock ____cacheline_aligned_in_smp;
 	volatile struct nvme_completion *cqes;
 	struct blk_mq_tags **tags;
@@ -439,11 +439,8 @@ static int nvme_pci_map_queues(struct blk_mq_tag_set *set)
 static void nvme_submit_cmd(struct nvme_queue *nvmeq, struct nvme_command *cmd)
 {
 	spin_lock(&nvmeq->sq_lock);
-	if (nvmeq->sq_cmds_io)
-		memcpy_toio(&nvmeq->sq_cmds_io[nvmeq->sq_tail], cmd,
-				sizeof(*cmd));
-	else
-		memcpy(&nvmeq->sq_cmds[nvmeq->sq_tail], cmd, sizeof(*cmd));
+
+	memcpy(&nvmeq->sq_cmds[nvmeq->sq_tail], cmd, sizeof(*cmd));
 
 	if (++nvmeq->sq_tail == nvmeq->q_depth)
 		nvmeq->sq_tail = 0;
@@ -1224,9 +1221,18 @@ static void nvme_free_queue(struct nvme_queue *nvmeq)
 {
 	dma_free_coherent(nvmeq->q_dmadev, CQ_SIZE(nvmeq->q_depth),
 				(void *)nvmeq->cqes, nvmeq->cq_dma_addr);
-	if (nvmeq->sq_cmds)
-		dma_free_coherent(nvmeq->q_dmadev, SQ_SIZE(nvmeq->q_depth),
-					nvmeq->sq_cmds, nvmeq->sq_dma_addr);
+
+	if (nvmeq->sq_cmds) {
+		if (nvmeq->sq_cmds_is_io)
+			pci_free_p2pmem(to_pci_dev(nvmeq->q_dmadev),
+					nvmeq->sq_cmds,
+					SQ_SIZE(nvmeq->q_depth));
+		else
+			dma_free_coherent(nvmeq->q_dmadev,
+					  SQ_SIZE(nvmeq->q_depth),
+					  nvmeq->sq_cmds,
+					  nvmeq->sq_dma_addr);
+	}
 }
 
 static void nvme_free_queues(struct nvme_dev *dev, int lowest)
@@ -1315,12 +1321,21 @@ static int nvme_cmb_qdepth(struct nvme_dev *dev, int nr_io_queues,
 static int nvme_alloc_sq_cmds(struct nvme_dev *dev, struct nvme_queue *nvmeq,
 				int qid, int depth)
 {
-	/* CMB SQEs will be mapped before creation */
-	if (qid && dev->cmb && use_cmb_sqes && (dev->cmbsz & NVME_CMBSZ_SQS))
-		return 0;
+	struct pci_dev *pdev = to_pci_dev(dev->dev);
+
+	if (qid && dev->cmb_use_sqes && (dev->cmbsz & NVME_CMBSZ_SQS)) {
+		nvmeq->sq_cmds = pci_alloc_p2pmem(pdev, SQ_SIZE(depth));
+		nvmeq->sq_dma_addr = pci_p2pmem_virt_to_bus(pdev,
+						nvmeq->sq_cmds);
+		nvmeq->sq_cmds_is_io = true;
+	}
+
+	if (!nvmeq->sq_cmds) {
+		nvmeq->sq_cmds = dma_alloc_coherent(dev->dev, SQ_SIZE(depth),
+					&nvmeq->sq_dma_addr, GFP_KERNEL);
+		nvmeq->sq_cmds_is_io = false;
+	}
 
-	nvmeq->sq_cmds = dma_alloc_coherent(dev->dev, SQ_SIZE(depth),
-					    &nvmeq->sq_dma_addr, GFP_KERNEL);
 	if (!nvmeq->sq_cmds)
 		return -ENOMEM;
 	return 0;
@@ -1397,13 +1412,6 @@ static int nvme_create_queue(struct nvme_queue *nvmeq, int qid)
 	int result;
 	s16 vector;
 
-	if (dev->cmb && use_cmb_sqes && (dev->cmbsz & NVME_CMBSZ_SQS)) {
-		unsigned offset = (qid - 1) * roundup(SQ_SIZE(nvmeq->q_depth),
-						      dev->ctrl.page_size);
-		nvmeq->sq_dma_addr = dev->cmb_bus_addr + offset;
-		nvmeq->sq_cmds_io = dev->cmb + offset;
-	}
-
 	/*
 	 * A queue's vector matches the queue identifier unless the controller
 	 * has only one vector available.
@@ -1644,9 +1652,6 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 		return;
 	dev->cmbloc = readl(dev->bar + NVME_REG_CMBLOC);
 
-	if (!use_cmb_sqes)
-		return;
-
 	size = nvme_cmb_size_unit(dev) * nvme_cmb_size(dev);
 	offset = nvme_cmb_size_unit(dev) * NVME_CMB_OFST(dev->cmbloc);
 	bar = NVME_CMB_BIR(dev->cmbloc);
@@ -1663,11 +1668,18 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 	if (size > bar_size - offset)
 		size = bar_size - offset;
 
-	dev->cmb = ioremap_wc(pci_resource_start(pdev, bar) + offset, size);
-	if (!dev->cmb)
+	if (pci_p2pdma_add_resource(pdev, bar, size, offset)) {
+		dev_warn(dev->ctrl.device,
+			 "failed to register the CMB\n");
 		return;
-	dev->cmb_bus_addr = pci_bus_address(pdev, bar) + offset;
+	}
+
 	dev->cmb_size = size;
+	dev->cmb_use_sqes = use_cmb_sqes && (dev->cmbsz & NVME_CMBSZ_SQS);
+
+	if ((dev->cmbsz & (NVME_CMBSZ_WDS | NVME_CMBSZ_RDS)) ==
+			(NVME_CMBSZ_WDS | NVME_CMBSZ_RDS))
+		pci_p2pmem_publish(pdev, true);
 
 	if (sysfs_add_file_to_group(&dev->ctrl.device->kobj,
 				    &dev_attr_cmb.attr, NULL))
@@ -1677,12 +1689,10 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 
 static inline void nvme_release_cmb(struct nvme_dev *dev)
 {
-	if (dev->cmb) {
-		iounmap(dev->cmb);
-		dev->cmb = NULL;
+	if (dev->cmb_size) {
 		sysfs_remove_file_from_group(&dev->ctrl.device->kobj,
 					     &dev_attr_cmb.attr, NULL);
-		dev->cmbsz = 0;
+		dev->cmb_size = 0;
 	}
 }
 
@@ -1881,13 +1891,13 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 	if (nr_io_queues == 0)
 		return 0;
 
-	if (dev->cmb && (dev->cmbsz & NVME_CMBSZ_SQS)) {
+	if (dev->cmb_use_sqes) {
 		result = nvme_cmb_qdepth(dev, nr_io_queues,
 				sizeof(struct nvme_command));
 		if (result > 0)
 			dev->q_depth = result;
 		else
-			nvme_release_cmb(dev);
+			dev->cmb_use_sqes = false;
 	}
 
 	do {
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
