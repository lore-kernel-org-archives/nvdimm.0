Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1569021E1DAC1
 for <linux-nvdimm@lists.01.org>; Wed,  2 Aug 2017 11:39:04 -0700 (PDT)
Subject: [PATCH v2 3/5] dmaengine: add SG support to dmaengine_unmap
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 02 Aug 2017 11:41:13 -0700
Message-ID: <150169927368.59677.2621298935225059836.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <150169902310.59677.18062301799811367806.stgit@djiang5-desk3.ch.intel.com>
References: <150169902310.59677.18062301799811367806.stgit@djiang5-desk3.ch.intel.com>
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

This should provide support to unmap scatterlist with the
dmaengine_unmap_data. We will support only 1 scatterlist per
direction. The DMA addresses array has been overloaded for the
2 or less entries DMA unmap data structure in order to store the
SG pointer(s).

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/dmaengine.c   |   45 ++++++++++++++++++++++++++++++++++++---------
 include/linux/dmaengine.h |    4 ++++
 2 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index d9118ec..81d10c97 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1126,16 +1126,35 @@ static void dmaengine_unmap(struct kref *kref)
 {
 	struct dmaengine_unmap_data *unmap = container_of(kref, typeof(*unmap), kref);
 	struct device *dev = unmap->dev;
-	int cnt, i;
+	int cnt, i, sg_nents;
+	struct scatterlist *sg;
+
+	sg_nents = dma_unmap_data_sg_to_nents(unmap, unmap->map_cnt);
+	if (sg_nents) {
+		i = 0;
+		cnt = 1;
+		sg = (struct scatterlist *)unmap->addr[i];
+		dma_unmap_sg(dev, sg, sg_nents, DMA_TO_DEVICE);
+	} else {
+		cnt = unmap->to_cnt;
+		for (i = 0; i < cnt; i++)
+			dma_unmap_page(dev, unmap->addr[i], unmap->len,
+					DMA_TO_DEVICE);
+	}
+
+	sg_nents = dma_unmap_data_sg_from_nents(unmap, unmap->map_cnt);
+	if (sg_nents) {
+		sg = (struct scatterlist *)unmap->addr[i];
+		dma_unmap_sg(dev, sg, sg_nents, DMA_FROM_DEVICE);
+		cnt++;
+		i++;
+	} else {
+		cnt += unmap->from_cnt;
+		for (; i < cnt; i++)
+			dma_unmap_page(dev, unmap->addr[i], unmap->len,
+					DMA_FROM_DEVICE);
+	}
 
-	cnt = unmap->to_cnt;
-	for (i = 0; i < cnt; i++)
-		dma_unmap_page(dev, unmap->addr[i], unmap->len,
-			       DMA_TO_DEVICE);
-	cnt += unmap->from_cnt;
-	for (; i < cnt; i++)
-		dma_unmap_page(dev, unmap->addr[i], unmap->len,
-			       DMA_FROM_DEVICE);
 	cnt += unmap->bidi_cnt;
 	for (; i < cnt; i++) {
 		if (unmap->addr[i] == 0)
@@ -1179,6 +1198,10 @@ static int __init dmaengine_init_unmap_pool(void)
 		size = sizeof(struct dmaengine_unmap_data) +
 		       sizeof(dma_addr_t) * p->size;
 
+		/* add 2 more entries for SG nents overload */
+		if (i == 0)
+			size += sizeof(dma_addr_t) * 2;
+
 		p->cache = kmem_cache_create(p->name, size, 0,
 					     SLAB_HWCACHE_ALIGN, NULL);
 		if (!p->cache)
@@ -1205,6 +1228,10 @@ dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
 		return NULL;
 
 	memset(unmap, 0, sizeof(*unmap));
+	/* clear the overloaded sg nents entries */
+	if (nr < 3)
+		memset(&unmap->addr[nr], 0,
+				DMA_UNMAP_SG_ENTS * sizeof(dma_addr_t));
 	kref_init(&unmap->kref);
 	unmap->dev = dev;
 	unmap->map_cnt = nr;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 060f152..ba978dd 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -475,6 +475,10 @@ struct dmaengine_unmap_data {
 	dma_addr_t addr[0];
 };
 
+#define DMA_UNMAP_SG_ENTS	2
+#define dma_unmap_data_sg_to_nents(x, n) x->addr[n]
+#define dma_unmap_data_sg_from_nents(x, n) x->addr[n+1]
+
 /**
  * struct dma_async_tx_descriptor - async transaction descriptor
  * ---dma generic offload fields---

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
