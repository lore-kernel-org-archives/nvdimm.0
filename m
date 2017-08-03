Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 15F0E21AEB0CD
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 16:29:48 -0700 (PDT)
Subject: [PATCH v3 2/8] dmaengine: change transaction type DMA_SG to DMA_SG_SG
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 03 Aug 2017 16:31:59 -0700
Message-ID: <150180311904.66052.14901267602467118745.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <150180288552.66052.13066621908903037900.stgit@djiang5-desk3.ch.intel.com>
References: <150180288552.66052.13066621908903037900.stgit@djiang5-desk3.ch.intel.com>
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
To: vinod.koul@intel.com, dan.j.williams@intel.com
Cc: dmaengine@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation of adding an API to perform SG to/from buffer for dmaengine,
we will change DMA_SG to DMA_SG_SG in order to explicitly making clear what
this op type is for.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/dmaengine/provider.txt |    2 +-
 drivers/crypto/ccp/ccp-dmaengine.c   |    2 +-
 drivers/dma/at_hdmac.c               |    8 ++++----
 drivers/dma/dmaengine.c              |    2 +-
 drivers/dma/dmatest.c                |   12 ++++++------
 drivers/dma/fsldma.c                 |    2 +-
 drivers/dma/mv_xor.c                 |    6 +++---
 drivers/dma/nbpfaxi.c                |    2 +-
 drivers/dma/ste_dma40.c              |    6 +++---
 drivers/dma/xgene-dma.c              |    4 ++--
 drivers/dma/xilinx/zynqmp_dma.c      |    2 +-
 include/linux/dmaengine.h            |    2 +-
 12 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/Documentation/dmaengine/provider.txt b/Documentation/dmaengine/provider.txt
index e33bc1c..8f189c9 100644
--- a/Documentation/dmaengine/provider.txt
+++ b/Documentation/dmaengine/provider.txt
@@ -181,7 +181,7 @@ Currently, the types available are:
     - Used by the client drivers to register a callback that will be
       called on a regular basis through the DMA controller interrupt
 
-  * DMA_SG
+  * DMA_SG_SG
     - The device supports memory to memory scatter-gather
       transfers.
     - Even though a plain memcpy can look like a particular case of a
diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index e00be01..f477c82 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -704,7 +704,7 @@ int ccp_dmaengine_register(struct ccp_device *ccp)
 	dma_dev->directions = DMA_MEM_TO_MEM;
 	dma_dev->residue_granularity = DMA_RESIDUE_GRANULARITY_DESCRIPTOR;
 	dma_cap_set(DMA_MEMCPY, dma_dev->cap_mask);
-	dma_cap_set(DMA_SG, dma_dev->cap_mask);
+	dma_cap_set(DMA_SG_SG, dma_dev->cap_mask);
 	dma_cap_set(DMA_INTERRUPT, dma_dev->cap_mask);
 
 	/* The DMA channels for this device can be set to public or private,
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 1baf340..7124074 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1933,14 +1933,14 @@ static int __init at_dma_probe(struct platform_device *pdev)
 
 	/* setup platform data for each SoC */
 	dma_cap_set(DMA_MEMCPY, at91sam9rl_config.cap_mask);
-	dma_cap_set(DMA_SG, at91sam9rl_config.cap_mask);
+	dma_cap_set(DMA_SG_SG, at91sam9rl_config.cap_mask);
 	dma_cap_set(DMA_INTERLEAVE, at91sam9g45_config.cap_mask);
 	dma_cap_set(DMA_MEMCPY, at91sam9g45_config.cap_mask);
 	dma_cap_set(DMA_MEMSET, at91sam9g45_config.cap_mask);
 	dma_cap_set(DMA_MEMSET_SG, at91sam9g45_config.cap_mask);
 	dma_cap_set(DMA_PRIVATE, at91sam9g45_config.cap_mask);
 	dma_cap_set(DMA_SLAVE, at91sam9g45_config.cap_mask);
-	dma_cap_set(DMA_SG, at91sam9g45_config.cap_mask);
+	dma_cap_set(DMA_SG_SG, at91sam9g45_config.cap_mask);
 
 	/* get DMA parameters from controller type */
 	plat_dat = at_dma_get_driver_data(pdev);
@@ -2078,7 +2078,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 		atdma->dma_common.residue_granularity = DMA_RESIDUE_GRANULARITY_BURST;
 	}
 
-	if (dma_has_cap(DMA_SG, atdma->dma_common.cap_mask))
+	if (dma_has_cap(DMA_SG_SG, atdma->dma_common.cap_mask))
 		atdma->dma_common.device_prep_dma_sg = atc_prep_dma_sg;
 
 	dma_writel(atdma, EN, AT_DMA_ENABLE);
@@ -2087,7 +2087,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 	  dma_has_cap(DMA_MEMCPY, atdma->dma_common.cap_mask) ? "cpy " : "",
 	  dma_has_cap(DMA_MEMSET, atdma->dma_common.cap_mask) ? "set " : "",
 	  dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask)  ? "slave " : "",
-	  dma_has_cap(DMA_SG, atdma->dma_common.cap_mask)  ? "sg-cpy " : "",
+	  dma_has_cap(DMA_SG_SG, atdma->dma_common.cap_mask)  ? "sg-cpy " : "",
 	  plat_dat->nr_channels);
 
 	dma_async_device_register(&atdma->dma_common);
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index d9118ec..2219b1f 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -937,7 +937,7 @@ int dma_async_device_register(struct dma_device *device)
 		!device->device_prep_dma_memset);
 	BUG_ON(dma_has_cap(DMA_INTERRUPT, device->cap_mask) &&
 		!device->device_prep_dma_interrupt);
-	BUG_ON(dma_has_cap(DMA_SG, device->cap_mask) &&
+	BUG_ON(dma_has_cap(DMA_SG_SG, device->cap_mask) &&
 		!device->device_prep_dma_sg);
 	BUG_ON(dma_has_cap(DMA_CYCLIC, device->cap_mask) &&
 		!device->device_prep_dma_cyclic);
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index a07ef3d..b062113 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -448,7 +448,7 @@ static int dmatest_func(void *data)
 	if (thread->type == DMA_MEMCPY) {
 		align = dev->copy_align;
 		src_cnt = dst_cnt = 1;
-	} else if (thread->type == DMA_SG) {
+	} else if (thread->type == DMA_SG_SG) {
 		align = dev->copy_align;
 		src_cnt = dst_cnt = sg_buffers;
 	} else if (thread->type == DMA_XOR) {
@@ -640,7 +640,7 @@ static int dmatest_func(void *data)
 			tx = dev->device_prep_dma_memcpy(chan,
 							 dsts[0] + dst_off,
 							 srcs[0], len, flags);
-		else if (thread->type == DMA_SG)
+		else if (thread->type == DMA_SG_SG)
 			tx = dev->device_prep_dma_sg(chan, tx_sg, src_cnt,
 						     rx_sg, src_cnt, flags);
 		else if (thread->type == DMA_XOR)
@@ -821,7 +821,7 @@ static int dmatest_add_threads(struct dmatest_info *info,
 
 	if (type == DMA_MEMCPY)
 		op = "copy";
-	else if (type == DMA_SG)
+	else if (type == DMA_SG_SG)
 		op = "sg";
 	else if (type == DMA_XOR)
 		op = "xor";
@@ -883,9 +883,9 @@ static int dmatest_add_channel(struct dmatest_info *info,
 		}
 	}
 
-	if (dma_has_cap(DMA_SG, dma_dev->cap_mask)) {
+	if (dma_has_cap(DMA_SG_SG, dma_dev->cap_mask)) {
 		if (dmatest == 1) {
-			cnt = dmatest_add_threads(info, dtc, DMA_SG);
+			cnt = dmatest_add_threads(info, dtc, DMA_SG_SG);
 			thread_count += cnt > 0 ? cnt : 0;
 		}
 	}
@@ -962,7 +962,7 @@ static void run_threaded_test(struct dmatest_info *info)
 
 	request_channels(info, DMA_MEMCPY);
 	request_channels(info, DMA_XOR);
-	request_channels(info, DMA_SG);
+	request_channels(info, DMA_SG_SG);
 	request_channels(info, DMA_PQ);
 }
 
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 3b8b752..bb63dbe 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1357,7 +1357,7 @@ static int fsldma_of_probe(struct platform_device *op)
 	fdev->irq = irq_of_parse_and_map(op->dev.of_node, 0);
 
 	dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
-	dma_cap_set(DMA_SG, fdev->common.cap_mask);
+	dma_cap_set(DMA_SG_SG, fdev->common.cap_mask);
 	dma_cap_set(DMA_SLAVE, fdev->common.cap_mask);
 	fdev->common.device_alloc_chan_resources = fsl_dma_alloc_chan_resources;
 	fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 25bc5b1..109501d 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1254,7 +1254,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 		dma_dev->device_prep_dma_interrupt = mv_xor_prep_dma_interrupt;
 	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask))
 		dma_dev->device_prep_dma_memcpy = mv_xor_prep_dma_memcpy;
-	if (dma_has_cap(DMA_SG, dma_dev->cap_mask))
+	if (dma_has_cap(DMA_SG_SG, dma_dev->cap_mask))
 		dma_dev->device_prep_dma_sg = mv_xor_prep_dma_sg;
 	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
 		dma_dev->max_xor = 8;
@@ -1309,7 +1309,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 		 mv_chan->op_in_desc ? "Descriptor Mode" : "Registers Mode",
 		 dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
 		 dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",
-		 dma_has_cap(DMA_SG, dma_dev->cap_mask) ? "sg " : "",
+		 dma_has_cap(DMA_SG_SG, dma_dev->cap_mask) ? "sg " : "",
 		 dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask) ? "intr " : "");
 
 	dma_async_device_register(dma_dev);
@@ -1552,7 +1552,7 @@ static int mv_xor_probe(struct platform_device *pdev)
 
 			dma_cap_zero(cap_mask);
 			dma_cap_set(DMA_MEMCPY, cap_mask);
-			dma_cap_set(DMA_SG, cap_mask);
+			dma_cap_set(DMA_SG_SG, cap_mask);
 			dma_cap_set(DMA_XOR, cap_mask);
 			dma_cap_set(DMA_INTERRUPT, cap_mask);
 
diff --git a/drivers/dma/nbpfaxi.c b/drivers/dma/nbpfaxi.c
index 3f45b9b..1127629 100644
--- a/drivers/dma/nbpfaxi.c
+++ b/drivers/dma/nbpfaxi.c
@@ -1417,7 +1417,7 @@ static int nbpf_probe(struct platform_device *pdev)
 	dma_cap_set(DMA_MEMCPY, dma_dev->cap_mask);
 	dma_cap_set(DMA_SLAVE, dma_dev->cap_mask);
 	dma_cap_set(DMA_PRIVATE, dma_dev->cap_mask);
-	dma_cap_set(DMA_SG, dma_dev->cap_mask);
+	dma_cap_set(DMA_SG_SG, dma_dev->cap_mask);
 
 	/* Common and MEMCPY operations */
 	dma_dev->device_alloc_chan_resources
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index c3052fb..d66ba81 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2821,7 +2821,7 @@ static void d40_ops_init(struct d40_base *base, struct dma_device *dev)
 		dev->copy_align = DMAENGINE_ALIGN_4_BYTES;
 	}
 
-	if (dma_has_cap(DMA_SG, dev->cap_mask))
+	if (dma_has_cap(DMA_SG_SG, dev->cap_mask))
 		dev->device_prep_dma_sg = d40_prep_memcpy_sg;
 
 	if (dma_has_cap(DMA_CYCLIC, dev->cap_mask))
@@ -2865,7 +2865,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 
 	dma_cap_zero(base->dma_memcpy.cap_mask);
 	dma_cap_set(DMA_MEMCPY, base->dma_memcpy.cap_mask);
-	dma_cap_set(DMA_SG, base->dma_memcpy.cap_mask);
+	dma_cap_set(DMA_SG_SG, base->dma_memcpy.cap_mask);
 
 	d40_ops_init(base, &base->dma_memcpy);
 
@@ -2883,7 +2883,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	dma_cap_zero(base->dma_both.cap_mask);
 	dma_cap_set(DMA_SLAVE, base->dma_both.cap_mask);
 	dma_cap_set(DMA_MEMCPY, base->dma_both.cap_mask);
-	dma_cap_set(DMA_SG, base->dma_both.cap_mask);
+	dma_cap_set(DMA_SG_SG, base->dma_both.cap_mask);
 	dma_cap_set(DMA_CYCLIC, base->dma_slave.cap_mask);
 
 	d40_ops_init(base, &base->dma_both);
diff --git a/drivers/dma/xgene-dma.c b/drivers/dma/xgene-dma.c
index 8b693b7..216dbb7 100644
--- a/drivers/dma/xgene-dma.c
+++ b/drivers/dma/xgene-dma.c
@@ -1653,7 +1653,7 @@ static void xgene_dma_set_caps(struct xgene_dma_chan *chan,
 	dma_cap_zero(dma_dev->cap_mask);
 
 	/* Set DMA device capability */
-	dma_cap_set(DMA_SG, dma_dev->cap_mask);
+	dma_cap_set(DMA_SG_SG, dma_dev->cap_mask);
 
 	/* Basically here, the X-Gene SoC DMA engine channel 0 supports XOR
 	 * and channel 1 supports XOR, PQ both. First thing here is we have
@@ -1732,7 +1732,7 @@ static int xgene_dma_async_register(struct xgene_dma *pdma, int id)
 	/* DMA capability info */
 	dev_info(pdma->dev,
 		 "%s: CAPABILITY ( %s%s%s)\n", dma_chan_name(&chan->dma_chan),
-		 dma_has_cap(DMA_SG, dma_dev->cap_mask) ? "SGCPY " : "",
+		 dma_has_cap(DMA_SG_SG, dma_dev->cap_mask) ? "SGCPY " : "",
 		 dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "XOR " : "",
 		 dma_has_cap(DMA_PQ, dma_dev->cap_mask) ? "PQ " : "");
 
diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index 47f6419..0258c2e 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -1064,7 +1064,7 @@ static int zynqmp_dma_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&zdev->common.channels);
 
 	dma_set_mask(&pdev->dev, DMA_BIT_MASK(44));
-	dma_cap_set(DMA_SG, zdev->common.cap_mask);
+	dma_cap_set(DMA_SG_SG, zdev->common.cap_mask);
 	dma_cap_set(DMA_MEMCPY, zdev->common.cap_mask);
 
 	p = &zdev->common;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 5336808..b1182c6 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -68,7 +68,7 @@ enum dma_transaction_type {
 	DMA_MEMSET,
 	DMA_MEMSET_SG,
 	DMA_INTERRUPT,
-	DMA_SG,
+	DMA_SG_SG,
 	DMA_PRIVATE,
 	DMA_ASYNC_TX,
 	DMA_SLAVE,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
