Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v4 7/9] scatterlist: cleanup sg_chain() and sg_unmark_end()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 05 Jun 2015 17:19:41 -0400
Message-ID: <20150605211941.20751.68557.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, linux-arch@vger.kernel.org, arnd@arndb.de, ross.zwisler@linux.intel.com, linux-nvdimm@lists.01.org, benh@kernel.crashing.org, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, hch@lst.de, tj@kernel.org, paulus@samba.org, hpa@zytor.com, schwidefsky@de.ibm.com, willy@linux.intel.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Replace open coded sg_chain() and sg_unmark_end() instances with the
aforementioned helpers.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/blk-merge.c            |    2 +-
 drivers/crypto/omap-sham.c   |    2 +-
 drivers/dma/imx-dma.c        |    8 ++------
 drivers/dma/ste_dma40.c      |    5 +----
 drivers/mmc/card/queue.c     |    4 ++--
 include/crypto/scatterwalk.h |    9 ++-------
 6 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 30a0d9f89017..f4a3e87623dc 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -266,7 +266,7 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 		if (rq->cmd_flags & REQ_WRITE)
 			memset(q->dma_drain_buffer, 0, q->dma_drain_size);
 
-		sg->page_link &= ~0x02;
+		sg_unmark_end(sg);
 		sg = sg_next(sg);
 		sg_set_page(sg, virt_to_page(q->dma_drain_buffer),
 			    q->dma_drain_size,
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 4d63e0d4da9a..df8b23e19b90 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -582,7 +582,7 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 		 * the dmaengine may try to DMA the incorrect amount of data.
 		 */
 		sg_init_table(&ctx->sgl, 1);
-		ctx->sgl.page_link = ctx->sg->page_link;
+		sg_assign_page(&ctx->sgl, sg_page(ctx->sg));
 		ctx->sgl.offset = ctx->sg->offset;
 		sg_dma_len(&ctx->sgl) = len32;
 		sg_dma_address(&ctx->sgl) = sg_dma_address(ctx->sg);
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index eed405976ea9..081fbfc87f6b 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -886,18 +886,14 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
 	sg_init_table(imxdmac->sg_list, periods);
 
 	for (i = 0; i < periods; i++) {
-		imxdmac->sg_list[i].page_link = 0;
-		imxdmac->sg_list[i].offset = 0;
+		sg_set_page(&imxdmac->sg_list[i], NULL, period_len, 0);
 		imxdmac->sg_list[i].dma_address = dma_addr;
 		sg_dma_len(&imxdmac->sg_list[i]) = period_len;
 		dma_addr += period_len;
 	}
 
 	/* close the loop */
-	imxdmac->sg_list[periods].offset = 0;
-	sg_dma_len(&imxdmac->sg_list[periods]) = 0;
-	imxdmac->sg_list[periods].page_link =
-		((unsigned long)imxdmac->sg_list | 0x01) & ~0x02;
+	sg_chain(imxdmac->sg_list, periods + 1, imxdmac->sg_list);
 
 	desc->type = IMXDMA_DESC_CYCLIC;
 	desc->sg = imxdmac->sg_list;
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 3c10f034d4b9..e8c00642cacb 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2562,10 +2562,7 @@ dma40_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
 		dma_addr += period_len;
 	}
 
-	sg[periods].offset = 0;
-	sg_dma_len(&sg[periods]) = 0;
-	sg[periods].page_link =
-		((unsigned long)sg | 0x01) & ~0x02;
+	sg_chain(sg, periods + 1, sg);
 
 	txd = d40_prep_sg(chan, sg, sg, periods, direction,
 			  DMA_PREP_INTERRUPT);
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 236d194c2883..127f76294e71 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -469,7 +469,7 @@ static unsigned int mmc_queue_packed_map_sg(struct mmc_queue *mq,
 			sg_set_buf(__sg, buf + offset, len);
 			offset += len;
 			remain -= len;
-			(__sg++)->page_link &= ~0x02;
+			sg_unmark_end(__sg++);
 			sg_len++;
 		} while (remain);
 	}
@@ -477,7 +477,7 @@ static unsigned int mmc_queue_packed_map_sg(struct mmc_queue *mq,
 	list_for_each_entry(req, &packed->list, queuelist) {
 		sg_len += blk_rq_map_sg(mq->queue, req, __sg);
 		__sg = sg + (sg_len - 1);
-		(__sg++)->page_link &= ~0x02;
+		sg_unmark_end(__sg++);
 	}
 	sg_mark_end(sg + (sg_len - 1));
 	return sg_len;
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 20e4226a2e14..4529889b0f07 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -25,13 +25,8 @@
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 
-static inline void scatterwalk_sg_chain(struct scatterlist *sg1, int num,
-					struct scatterlist *sg2)
-{
-	sg_set_page(&sg1[num - 1], (void *)sg2, 0, 0);
-	sg1[num - 1].page_link &= ~0x02;
-	sg1[num - 1].page_link |= 0x01;
-}
+#define scatterwalk_sg_chain(prv, num, sgl)	sg_chain(prv, num, sgl)
+#define scatterwalk_sg_next(sgl)		sg_next(sgl)
 
 static inline void scatterwalk_crypto_chain(struct scatterlist *head,
 					    struct scatterlist *sg,

