Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F03321A04813
 for <linux-nvdimm@lists.01.org>; Thu, 30 Mar 2017 15:13:46 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 30 Mar 2017 16:12:33 -0600
Message-Id: <1490911959-5146-3-git-send-email-logang@deltatee.com>
In-Reply-To: <1490911959-5146-1-git-send-email-logang@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
Subject: [RFC 2/8] cxgb4: setup pcie memory window 4 and create p2pmem region
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
To: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

From: Steve Wise <swise@opengridcomputing.com>

Some cxgb4 cards expose memory as part of BAR4. This patch registers
this memory as a p2pmem device.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      |  3 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 97 ++++++++++++++++++++++++-
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h    |  5 ++
 3 files changed, 102 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 163543b..e92443b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -48,6 +48,7 @@
 #include <linux/vmalloc.h>
 #include <linux/etherdevice.h>
 #include <linux/net_tstamp.h>
+#include <linux/p2pmem.h>
 #include <asm/io.h>
 #include "t4_chip_type.h"
 #include "cxgb4_uld.h"
@@ -859,6 +860,8 @@ struct adapter {
 
 	/* TC u32 offload */
 	struct cxgb4_tc_u32_table *tc_u32;
+
+	struct p2pmem_dev *p2pmem;
 };
 
 /* Support for "sched-class" command to allow a TX Scheduling Class to be
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index afb0967..a33bcd1 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -172,6 +172,11 @@ module_param(select_queue, int, 0644);
 MODULE_PARM_DESC(select_queue,
 		 "Select between kernel provided method of selecting or driver method of selecting TX queue. Default is kernel method.");
 
+static bool use_p2pmem;
+module_param(use_p2pmem, bool, 0644);
+MODULE_PARM_DESC(use_p2pmem,
+		 "Enable registering a p2pmem device with bar space (if available)");
+
 static struct dentry *cxgb4_debugfs_root;
 
 LIST_HEAD(adapter_list);
@@ -2835,6 +2840,54 @@ static void setup_memwin_rdma(struct adapter *adap)
 	}
 }
 
+static void setup_memwin_p2pmem(struct adapter *adap)
+{
+	unsigned int mem_base = t4_read_reg(adap, CIM_EXTMEM2_BASE_ADDR_A);
+	unsigned int mem_size = t4_read_reg(adap, CIM_EXTMEM2_ADDR_SIZE_A);
+
+	if (!use_p2pmem)
+		return;
+
+	if (mem_base != 0 && mem_size != 0) {
+		unsigned int sz_kb, pcieofst;
+
+		sz_kb = roundup_pow_of_two(mem_size) >> 10;
+
+		/*
+		 * The start offset must be aligned to the window size.
+		 * Also, BAR4 has MSIX vectors using the first 8KB.
+		 * Further, the min allowed p2pmem region size is 1MB,
+		 * so set the start offset to the memory size and we're aligned
+		 * as well as past the 8KB vector table.
+		 */
+		pcieofst = sz_kb << 10;
+
+		dev_info(adap->pdev_dev,
+			 "p2pmem base 0x%x, size %uB, ilog2(sk_kb) 0x%x, "
+			 "pcieofst 0x%X\n", mem_base, mem_size, ilog2(sz_kb),
+			 pcieofst);
+
+		/* Write the window offset and size */
+		t4_write_reg(adap,
+			PCIE_MEM_ACCESS_REG(PCIE_MEM_ACCESS_BASE_WIN_A,
+					    MEMWIN_RSVD4),
+			pcieofst | BIR_V(2) | WINDOW_V(ilog2(sz_kb)));
+
+		/* Write the adapter memory base/start */
+		t4_write_reg(adap,
+			PCIE_MEM_ACCESS_REG(PCIE_MEM_ACCESS_OFFSET_A,
+					    MEMWIN_RSVD4),
+			MEMOFST_V((mem_base >> MEMOFST_S)) | PFNUM_V(adap->pf));
+
+		/* Read it back to flush it */
+		t4_read_reg(adap,
+			PCIE_MEM_ACCESS_REG(PCIE_MEM_ACCESS_OFFSET_A,
+					    MEMWIN_RSVD4));
+	} else
+		dev_info(adap->pdev_dev, "p2pmem memory not reserved, "
+			 "base 0x%x size %uB\n", mem_base, mem_size);
+}
+
 static int adap_init1(struct adapter *adap, struct fw_caps_config_cmd *c)
 {
 	u32 v;
@@ -4622,6 +4675,42 @@ static int cxgb4_iov_configure(struct pci_dev *pdev, int num_vfs)
 }
 #endif
 
+static int init_p2pmem(struct adapter *adapter)
+{
+	unsigned int mem_size = t4_read_reg(adapter, CIM_EXTMEM2_ADDR_SIZE_A);
+	struct p2pmem_dev *p;
+	int rc;
+	struct resource res;
+
+	if (!mem_size || !use_p2pmem)
+		return 0;
+
+	mem_size = roundup_pow_of_two(mem_size);
+
+	/*
+	 * Create a subset of BAR4 for the p2pmem region based on the
+	 * exported memory size.
+	 */
+	memcpy(&res, &adapter->pdev->resource[4], sizeof(res));
+	res.start += mem_size;
+	res.end = res.start + mem_size - 1;
+	dev_info(adapter->pdev_dev, "p2pmem resource start 0x%llx end 0x%llx size %lluB\n",
+		 res.start, res.end, resource_size(&res));
+
+	p = p2pmem_create(&adapter->pdev->dev);
+	if (IS_ERR(p))
+		return PTR_ERR(p);
+
+	rc = p2pmem_add_resource(p, &res);
+	if (rc) {
+		p2pmem_unregister(p);
+		return rc;
+	}
+	adapter->p2pmem = p;
+
+	return 0;
+}
+
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int func, i, err, s_qpp, qpp, num_seg;
@@ -4784,8 +4873,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	bitmap_zero(adapter->sge.blocked_fl, adapter->sge.egr_sz);
 #endif
 	setup_memwin_rdma(adapter);
-	if (err)
-		goto out_unmap_bar;
+
+	setup_memwin_p2pmem(adapter);
 
 	/* configure SGE_STAT_CFG_A to read WC stats */
 	if (!is_t4(adapter->params.chip))
@@ -4989,6 +5078,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	print_adapter_info(adapter);
 	setup_fw_sge_queues(adapter);
+	init_p2pmem(adapter);
 	return 0;
 
 sriov:
@@ -5047,7 +5137,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		free_msix_info(adapter);
 	if (adapter->num_uld || adapter->num_ofld_uld)
 		t4_uld_mem_free(adapter);
- out_unmap_bar:
 	if (!is_t4(adapter->params.chip))
 		iounmap(adapter->bar2);
  out_free_adapter:
@@ -5075,6 +5164,8 @@ static void remove_one(struct pci_dev *pdev)
 		return;
 	}
 
+	p2pmem_unregister(adapter->p2pmem);
+
 	if (adapter->pf == 4) {
 		int i;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
index 3348d33..199ddfb 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
@@ -735,6 +735,11 @@
 
 #define PCIE_MEM_ACCESS_OFFSET_A 0x306c
 
+#define MEMOFST_S    7
+#define MEMOFST_M    0x1ffffffU
+#define MEMOFST_V(x) ((x) << MEMOFST_S)
+#define MEMOFST_G(x) (((x) >> MEMOFST_S) & MEMOFST_M)
+
 #define ENABLE_S    30
 #define ENABLE_V(x) ((x) << ENABLE_S)
 #define ENABLE_F    ENABLE_V(1U)
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
