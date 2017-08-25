Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B83852095DC9C
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 13:57:27 -0700 (PDT)
Subject: [PATCH v6 7/8] dmaengine: provide number of available channels
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 25 Aug 2017 14:00:03 -0700
Message-ID: <150369480338.6962.4785083630379841867.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <150369446130.6962.4195769527575520889.stgit@djiang5-desk3.ch.intel.com>
References: <150369446130.6962.4195769527575520889.stgit@djiang5-desk3.ch.intel.com>
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

Adding a dmaengine support function to provide the number of available
channels that can be shared with support of a filter function.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/dmaengine.c   |   45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dmaengine.h |    7 +++++++
 2 files changed, 52 insertions(+)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 09ee03d..a952e52 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -674,6 +674,51 @@ struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
 }
 EXPORT_SYMBOL_GPL(__dma_request_channel);
 
+static int get_candidate_count(const dma_cap_mask_t *mask,
+					  struct dma_device *dev,
+					  dma_filter_fn fn, void *fn_param)
+{
+	struct dma_chan *chan;
+	int count = 0;
+
+	if (mask && !__dma_device_satisfies_mask(dev, mask)) {
+		dev_dbg(dev->dev, "%s: wrong capabilities\n", __func__);
+		return 0;
+	}
+
+	list_for_each_entry(chan, &dev->channels, device_node) {
+		if (dma_has_cap(DMA_PRIVATE, dev->cap_mask)) {
+			dev_dbg(dev->dev, "%s: %s is marked for private\n",
+				 __func__, dma_chan_name(chan));
+			continue;
+		}
+		if (fn && !fn(chan, fn_param)) {
+			dev_dbg(dev->dev, "%s: %s filter said false\n",
+				 __func__, dma_chan_name(chan));
+			continue;
+		}
+		count++;
+	}
+
+	return count;
+}
+
+int dma_get_channel_count(const dma_cap_mask_t *mask,
+			    dma_filter_fn fn, void *fn_param)
+{
+	struct dma_device *device;
+	int total = 0;
+
+	/* Find a channel */
+	mutex_lock(&dma_list_mutex);
+	list_for_each_entry(device, &dma_device_list, global_node)
+		total += get_candidate_count(mask, device, fn, fn_param);
+	mutex_unlock(&dma_list_mutex);
+
+	return total;
+}
+EXPORT_SYMBOL_GPL(dma_get_channel_count);
+
 static const struct dma_slave_map *dma_filter_match(struct dma_device *device,
 						    const char *name,
 						    struct device *dev)
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index fc53854..7956063 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1331,6 +1331,8 @@ enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
 void dma_issue_pending_all(void);
 struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
 					dma_filter_fn fn, void *fn_param);
+int dma_get_channel_count(const dma_cap_mask_t *mask,
+					dma_filter_fn fn, void *fn_param);
 struct dma_chan *dma_request_slave_channel(struct device *dev, const char *name);
 
 struct dma_chan *dma_request_chan(struct device *dev, const char *name);
@@ -1364,6 +1366,11 @@ static inline struct dma_chan *__dma_request_channel(const dma_cap_mask_t *mask,
 {
 	return NULL;
 }
+static int dma_get_channel_count(const dma_cap_mask_t *mask,
+					dma_filter_fn fn, void *fn_param)
+{
+	return 0;
+}
 static inline struct dma_chan *dma_request_slave_channel(struct device *dev,
 							 const char *name)
 {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
