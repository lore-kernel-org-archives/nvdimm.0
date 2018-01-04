Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2A061222A54E4
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 10:59:59 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu,  4 Jan 2018 12:01:33 -0700
Message-Id: <20180104190137.7654-9-logang@deltatee.com>
In-Reply-To: <20180104190137.7654-1-logang@deltatee.com>
References: <20180104190137.7654-1-logang@deltatee.com>
Subject: [PATCH 08/12] nvme-pci: clean up SMBSZ bit definitions
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

From: Christoph Hellwig <hch@lst.de>

Define the bit positions instead of macros using the magic values,
and move the expanded helpers to calculate the size and size unit into
the implementation C file.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/pci.c | 23 +++++++++++++++++------
 include/linux/nvme.h    | 22 ++++++++++++++--------
 2 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 58c379af6fb4..5af239e46f52 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1369,7 +1369,7 @@ static int nvme_cmb_qdepth(struct nvme_dev *dev, int nr_io_queues,
 static int nvme_alloc_sq_cmds(struct nvme_dev *dev, struct nvme_queue *nvmeq,
 				int qid, int depth)
 {
-	if (qid && dev->cmb && use_cmb_sqes && NVME_CMB_SQS(dev->cmbsz)) {
+	if (qid && dev->cmb && use_cmb_sqes && (dev->cmbsz & NVME_CMBSZ_SQS)) {
 		unsigned offset = (qid - 1) * roundup(SQ_SIZE(depth),
 						      dev->ctrl.page_size);
 		nvmeq->sq_dma_addr = dev->cmb_bus_addr + offset;
@@ -1663,9 +1663,21 @@ static ssize_t nvme_cmb_show(struct device *dev,
 }
 static DEVICE_ATTR(cmb, S_IRUGO, nvme_cmb_show, NULL);
 
+static u64 nvme_cmb_size_unit(struct nvme_dev *dev)
+{
+	u8 szu = (dev->cmbsz >> NVME_CMBSZ_SZU_SHIFT) & NVME_CMBSZ_SZU_MASK;
+
+	return 1ULL << (12 + 4 * szu);
+}
+
+static u32 nvme_cmb_size(struct nvme_dev *dev)
+{
+	return (dev->cmbsz >> NVME_CMBSZ_SZ_SHIFT) & NVME_CMBSZ_SZ_MASK;
+}
+
 static void nvme_map_cmb(struct nvme_dev *dev)
 {
-	u64 szu, size, offset;
+	u64 size, offset;
 	resource_size_t bar_size;
 	struct pci_dev *pdev = to_pci_dev(dev->dev);
 	int bar;
@@ -1678,9 +1690,8 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 	if (!use_cmb_sqes)
 		return;
 
-	szu = (u64)1 << (12 + 4 * NVME_CMB_SZU(dev->cmbsz));
-	size = szu * NVME_CMB_SZ(dev->cmbsz);
-	offset = szu * NVME_CMB_OFST(dev->cmbloc);
+	size = nvme_cmb_size_unit(dev) * nvme_cmb_size(dev);
+	offset = nvme_cmb_size_unit(dev) * NVME_CMB_OFST(dev->cmbloc);
 	bar = NVME_CMB_BIR(dev->cmbloc);
 	bar_size = pci_resource_len(pdev, bar);
 
@@ -1909,7 +1920,7 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 	if (nr_io_queues == 0)
 		return 0;
 
-	if (dev->cmb && NVME_CMB_SQS(dev->cmbsz)) {
+	if (dev->cmb && (dev->cmbsz & NVME_CMBSZ_SQS)) {
 		result = nvme_cmb_qdepth(dev, nr_io_queues,
 				sizeof(struct nvme_command));
 		if (result > 0)
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index aea87f0d917b..4112e2bd747f 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -124,14 +124,20 @@ enum {
 
 #define NVME_CMB_BIR(cmbloc)	((cmbloc) & 0x7)
 #define NVME_CMB_OFST(cmbloc)	(((cmbloc) >> 12) & 0xfffff)
-#define NVME_CMB_SZ(cmbsz)	(((cmbsz) >> 12) & 0xfffff)
-#define NVME_CMB_SZU(cmbsz)	(((cmbsz) >> 8) & 0xf)
-
-#define NVME_CMB_WDS(cmbsz)	((cmbsz) & 0x10)
-#define NVME_CMB_RDS(cmbsz)	((cmbsz) & 0x8)
-#define NVME_CMB_LISTS(cmbsz)	((cmbsz) & 0x4)
-#define NVME_CMB_CQS(cmbsz)	((cmbsz) & 0x2)
-#define NVME_CMB_SQS(cmbsz)	((cmbsz) & 0x1)
+
+enum {
+	NVME_CMBSZ_SQS		= 1 << 0,
+	NVME_CMBSZ_CQS		= 1 << 1,
+	NVME_CMBSZ_LISTS	= 1 << 2,
+	NVME_CMBSZ_RDS		= 1 << 3,
+	NVME_CMBSZ_WDS		= 1 << 4,
+
+	NVME_CMBSZ_SZ_SHIFT	= 12,
+	NVME_CMBSZ_SZ_MASK	= 0xfffff,
+
+	NVME_CMBSZ_SZU_SHIFT	= 8,
+	NVME_CMBSZ_SZU_MASK	= 0xf,
+};
 
 /*
  * Submission and Completion Queue Entry Sizes for the NVM command set.
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
