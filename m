Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE80A21E79007
 for <linux-nvdimm@lists.01.org>; Mon, 21 Aug 2017 14:08:32 -0700 (PDT)
Subject: [PATCH v5 5/7] dmaengine: add function to provide per descriptor
 xfercap for dma engine
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 21 Aug 2017 14:11:03 -0700
Message-ID: <150334986374.55214.13718278546736297978.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <150333903164.55214.3813479680626005389.stgit@djiang5-desk3.ch.intel.com>
References: <150333903164.55214.3813479680626005389.stgit@djiang5-desk3.ch.intel.com>
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
Cc: dmaengine@vger.kernel.org, hch@infradead.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding a function that will export the transfer capability per descriptor
for a DMA device for the dmaengine subsystem.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/ioat/init.c   |    1 +
 include/linux/dmaengine.h |   10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index 5c69ff6..4f24c36 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -596,6 +596,7 @@ static int ioat_enumerate_channels(struct ioatdma_device *ioat_dma)
 	if (xfercap_log == 0)
 		return 0;
 	dev_dbg(dev, "%s: xfercap = %d\n", __func__, 1 << xfercap_log);
+	dma->xfercap = 1 << xfercap_log;
 
 	for (i = 0; i < dma->chancnt; i++) {
 		ioat_chan = devm_kzalloc(dev, sizeof(*ioat_chan), GFP_KERNEL);
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 0c91411..53356c4 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -743,6 +743,7 @@ struct dma_device {
 	u32 max_burst;
 	bool descriptor_reuse;
 	enum dma_residue_granularity residue_granularity;
+	u64 xfercap;	/* descriptor transfer capability limit */
 
 	int (*device_alloc_chan_resources)(struct dma_chan *chan);
 	void (*device_free_chan_resources)(struct dma_chan *chan);
@@ -1326,6 +1327,11 @@ struct dma_chan *dma_request_chan_by_mask(const dma_cap_mask_t *mask);
 
 void dma_release_channel(struct dma_chan *chan);
 int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_caps *caps);
+
+static inline u64 dma_get_desc_xfercap(struct dma_chan *chan)
+{
+	return chan->device->xfercap;
+}
 #else
 static inline struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type)
 {
@@ -1370,6 +1376,10 @@ static inline int dma_get_slave_caps(struct dma_chan *chan,
 {
 	return -ENXIO;
 }
+static inline u64 dma_get_desc_xfercap(struct dma_chan *chan)
+{
+	return -ENXIO;
+}
 #endif
 
 #define dma_request_slave_channel_reason(dev, name) dma_request_chan(dev, name)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
