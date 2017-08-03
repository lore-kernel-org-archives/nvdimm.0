Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2811521AEB0CD
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 16:30:04 -0700 (PDT)
Subject: [PATCH v3 5/8] dmaengine: ioatdma: dma_prep_memcpy_sg support
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 03 Aug 2017 16:32:15 -0700
Message-ID: <150180313553.66052.16468245777418530059.stgit@djiang5-desk3.ch.intel.com>
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

Adding ioatdma support to copy from a physically contiguous buffer to a
provided scatterlist and vice versa. This is used to support
reading/writing persistent memory in the pmem driver.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/ioat/dma.h  |    4 +++
 drivers/dma/ioat/init.c |    2 ++
 drivers/dma/ioat/prep.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+)

diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 56200ee..6c08b06 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -370,6 +370,10 @@ struct dma_async_tx_descriptor *
 ioat_dma_prep_memcpy_lock(struct dma_chan *c, dma_addr_t dma_dest,
 			   dma_addr_t dma_src, size_t len, unsigned long flags);
 struct dma_async_tx_descriptor *
+ioat_dma_prep_memcpy_sg_lock(struct dma_chan *c,
+		struct scatterlist *sg, unsigned int sg_nents,
+		dma_addr_t dma_addr, bool to_sg, unsigned long flags);
+struct dma_async_tx_descriptor *
 ioat_prep_interrupt_lock(struct dma_chan *c, unsigned long flags);
 struct dma_async_tx_descriptor *
 ioat_prep_xor(struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index 1b881fb..5c69ff6 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -1081,6 +1081,8 @@ static int ioat3_dma_probe(struct ioatdma_device *ioat_dma, int dca)
 
 	dma = &ioat_dma->dma_dev;
 	dma->device_prep_dma_memcpy = ioat_dma_prep_memcpy_lock;
+	dma_cap_set(DMA_MEMCPY_SG, dma->cap_mask);
+	dma->device_prep_dma_memcpy_sg = ioat_dma_prep_memcpy_sg_lock;
 	dma->device_issue_pending = ioat_issue_pending;
 	dma->device_alloc_chan_resources = ioat_alloc_chan_resources;
 	dma->device_free_chan_resources = ioat_free_chan_resources;
diff --git a/drivers/dma/ioat/prep.c b/drivers/dma/ioat/prep.c
index 243421a..d8219af 100644
--- a/drivers/dma/ioat/prep.c
+++ b/drivers/dma/ioat/prep.c
@@ -159,6 +159,63 @@ ioat_dma_prep_memcpy_lock(struct dma_chan *c, dma_addr_t dma_dest,
 	return &desc->txd;
 }
 
+struct dma_async_tx_descriptor *
+ioat_dma_prep_memcpy_sg_lock(struct dma_chan *c,
+		struct scatterlist *sg, unsigned int sg_nents,
+		dma_addr_t dma_addr, bool to_sg, unsigned long flags)
+{
+	struct ioatdma_chan *ioat_chan = to_ioat_chan(c);
+	struct ioat_dma_descriptor *hw = NULL;
+	struct ioat_ring_ent *desc = NULL;
+	dma_addr_t dma_off = dma_addr;
+	int num_descs, idx, i;
+	struct scatterlist *s;
+	size_t total_len = 0, len;
+
+
+	if (test_bit(IOAT_CHAN_DOWN, &ioat_chan->state))
+		return NULL;
+
+	/*
+	 * The upper layer will garantee that each entry does not exceed
+	 * xfercap.
+	 */
+	num_descs = sg_nents;
+
+	if (likely(num_descs) &&
+	    ioat_check_space_lock(ioat_chan, num_descs) == 0)
+		idx = ioat_chan->head;
+	else
+		return NULL;
+
+	for_each_sg(sg, s, sg_nents, i) {
+		desc = ioat_get_ring_ent(ioat_chan, idx + i);
+		hw = desc->hw;
+		len = sg_dma_len(s);
+		hw->size = len;
+		hw->ctl = 0;
+		if (to_sg) {
+			hw->src_addr = dma_off;
+			hw->dst_addr = sg_dma_address(s);
+		} else {
+			hw->src_addr = sg_dma_address(s);
+			hw->dst_addr = dma_off;
+		}
+		dma_off += len;
+		total_len += len;
+		dump_desc_dbg(ioat_chan, desc);
+	}
+
+	desc->txd.flags = flags;
+	desc->len = total_len;
+	hw->ctl_f.int_en = !!(flags & DMA_PREP_INTERRUPT);
+	hw->ctl_f.fence = !!(flags & DMA_PREP_FENCE);
+	hw->ctl_f.compl_write = 1;
+	dump_desc_dbg(ioat_chan, desc);
+	/* we leave the channel locked to ensure in order submission */
+
+	return &desc->txd;
+}
 
 static struct dma_async_tx_descriptor *
 __ioat_prep_xor_lock(struct dma_chan *c, enum sum_check_flags *result,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
