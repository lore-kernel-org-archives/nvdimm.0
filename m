Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2415C21E79010
 for <linux-nvdimm@lists.01.org>; Mon, 21 Aug 2017 14:08:38 -0700 (PDT)
Subject: [PATCH v5 6/7] dmaengine: add SG support to dmaengine_unmap
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 21 Aug 2017 14:11:09 -0700
Message-ID: <150334986946.55214.3540641512473593212.stgit@djiang5-desk3.ch.intel.com>
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

This provides support to unmap scatterlist with the
dmaengine_unmap_data. We will support only 1 scatterlist per
direction.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/dmaengine.c   |   27 +++++++++++++++++++++++++++
 include/linux/dmaengine.h |   13 ++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 40a035e..09ee03d 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1124,12 +1124,39 @@ static struct dmaengine_unmap_pool *__get_unmap_pool(int nr)
 	}
 }
 
+static void dmaengine_unmap_sg(struct dmaengine_unmap_data *unmap)
+{
+	struct device *dev = unmap->dev;
+
+	if (unmap->to_sg) {
+		dma_unmap_sg(dev, unmap->unmap_sg.sg,
+				unmap->sg_nents, DMA_TO_DEVICE);
+
+		dma_unmap_page(dev, unmap->unmap_sg.buf_phys, unmap->len,
+					DMA_FROM_DEVICE);
+	}
+
+	if (unmap->from_sg) {
+		dma_unmap_page(dev, unmap->unmap_sg.buf_phys, unmap->len,
+				DMA_TO_DEVICE);
+		dma_unmap_sg(dev, unmap->unmap_sg.sg,
+				unmap->sg_nents, DMA_FROM_DEVICE);
+	}
+
+	mempool_free(unmap, __get_unmap_pool(unmap->map_cnt)->pool);
+}
+
 static void dmaengine_unmap(struct kref *kref)
 {
 	struct dmaengine_unmap_data *unmap = container_of(kref, typeof(*unmap), kref);
 	struct device *dev = unmap->dev;
 	int cnt, i;
 
+	if (unmap->to_sg || unmap->from_sg) {
+		dmaengine_unmap_sg(unmap);
+		return;
+	}
+
 	cnt = unmap->to_cnt;
 	for (i = 0; i < cnt; i++)
 		dma_unmap_page(dev, unmap->addr[i], unmap->len,
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 53356c4..fc53854 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -464,15 +464,26 @@ struct dmaengine_result {
 typedef void (*dma_async_tx_callback_result)(void *dma_async_param,
 				const struct dmaengine_result *result);
 
+struct dmaengine_unmap_sg {
+	struct scatterlist *sg;
+	dma_addr_t buf_phys;
+};
+
 struct dmaengine_unmap_data {
 	u8 map_cnt;
 	u8 to_cnt;
+	u8 to_sg;
 	u8 from_cnt;
+	u8 from_sg;
 	u8 bidi_cnt;
+	int sg_nents;
 	struct device *dev;
 	struct kref kref;
 	size_t len;
-	dma_addr_t addr[0];
+	union {
+		struct dmaengine_unmap_sg unmap_sg;
+		dma_addr_t addr[0];
+	};
 };
 
 /**

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
