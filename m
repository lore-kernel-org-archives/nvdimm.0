Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D9DD721DF37D6
 for <linux-nvdimm@lists.01.org>; Mon,  7 Aug 2017 09:37:15 -0700 (PDT)
Subject: [PATCH v4 3/8] dmaengine: Add DMA_MEMCPY_SG transaction op
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 07 Aug 2017 09:39:31 -0700
Message-ID: <150212397144.23722.92320326335988578.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <150212381454.23722.1549806704988615279.stgit@djiang5-desk3.ch.intel.com>
References: <150212381454.23722.1549806704988615279.stgit@djiang5-desk3.ch.intel.com>
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

Adding a dmaengine transaction operation that allows copy to/from a
scatterlist and a flat buffer.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/dmaengine/provider.txt |    3 +++
 drivers/dma/dmaengine.c              |    2 ++
 include/linux/dmaengine.h            |    6 ++++++
 3 files changed, 11 insertions(+)

diff --git a/Documentation/dmaengine/provider.txt b/Documentation/dmaengine/provider.txt
index 8f189c9..03e8650 100644
--- a/Documentation/dmaengine/provider.txt
+++ b/Documentation/dmaengine/provider.txt
@@ -188,6 +188,9 @@ Currently, the types available are:
       scatter-gather transfer, with a single chunk to transfer, it's a
       distinct transaction type in the mem2mem transfers case
 
+  * DMA_MEMCPY_SG
+    - The device supports scatterlist to/from memory.
+
   * DMA_PRIVATE
     - The devices only supports slave transfers, and as such isn't
       available for async transfers.
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 2219b1f..1c424f6 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -939,6 +939,8 @@ int dma_async_device_register(struct dma_device *device)
 		!device->device_prep_dma_interrupt);
 	BUG_ON(dma_has_cap(DMA_SG_SG, device->cap_mask) &&
 		!device->device_prep_dma_sg);
+	BUG_ON(dma_has_cap(DMA_MEMCPY_SG, device->cap_mask) &&
+		!device->device_prep_dma_memcpy_sg);
 	BUG_ON(dma_has_cap(DMA_CYCLIC, device->cap_mask) &&
 		!device->device_prep_dma_cyclic);
 	BUG_ON(dma_has_cap(DMA_INTERLEAVE, device->cap_mask) &&
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index b1182c6..fc25475 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -67,6 +67,7 @@ enum dma_transaction_type {
 	DMA_PQ_VAL,
 	DMA_MEMSET,
 	DMA_MEMSET_SG,
+	DMA_MEMCPY_SG,
 	DMA_INTERRUPT,
 	DMA_SG_SG,
 	DMA_PRIVATE,
@@ -693,6 +694,7 @@ struct dma_filter {
  * @device_prep_dma_pq_val: prepares a pqzero_sum operation
  * @device_prep_dma_memset: prepares a memset operation
  * @device_prep_dma_memset_sg: prepares a memset operation over a scatter list
+ * @device_prep_dma_memcpy_sg: prepares memcpy between scatterlist and buffer
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
  * @device_prep_slave_sg: prepares a slave dma operation
  * @device_prep_dma_cyclic: prepare a cyclic dma operation suitable for audio.
@@ -769,6 +771,10 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_dma_memset_sg)(
 		struct dma_chan *chan, struct scatterlist *sg,
 		unsigned int nents, int value, unsigned long flags);
+	struct dma_async_tx_descriptor *(*device_prep_dma_memcpy_sg)(
+		struct dma_chan *chan,
+		struct scatterlist *dst_sg, unsigned int dst_nents,
+		dma_addr_t src, bool to_sg, unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
 		struct dma_chan *chan, unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_sg)(

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
