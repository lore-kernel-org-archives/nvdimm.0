Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 970932095A33E
 for <linux-nvdimm@lists.01.org>; Wed, 24 May 2017 14:43:20 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Wed, 24 May 2017 15:42:13 -0600
Message-Id: <1495662147-18277-3-git-send-email-logang@deltatee.com>
In-Reply-To: <1495662147-18277-1-git-send-email-logang@deltatee.com>
References: <1495662147-18277-1-git-send-email-logang@deltatee.com>
Subject: [RFC PATCH 02/16] staging: ccree: Cleanup: remove references to
 page_link
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
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Berg <johannes.berg@intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ming Lei <ming.lei@canonical.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jerome Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

This is a layering violation so we replace it with calls to
sg_page. This is a prep patch for replacing page_link and this
is one of the very few uses outside of scatterlist.h.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 038e2ff..07bbf8f 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -43,8 +43,8 @@
 #ifdef CC_DEBUG
 #define DUMP_SGL(sg) \
 	while (sg) { \
-		SSI_LOG_DEBUG("page=%lu offset=%u length=%u (dma_len=%u) " \
-			     "dma_addr=%08x\n", (sg)->page_link, (sg)->offset, \
+		SSI_LOG_DEBUG("page=%p offset=%u length=%u (dma_len=%u) " \
+			     "dma_addr=%08x\n", sg_page(sg), (sg)->offset, \
 			(sg)->length, sg_dma_len(sg), (sg)->dma_address); \
 		(sg) = sg_next(sg); \
 	}
@@ -442,10 +442,10 @@ static int ssi_buffer_mgr_map_scatterlist(
 			return -ENOMEM;
 		} 
 		SSI_LOG_DEBUG("Mapped sg: dma_address=0x%llX "
-			     "page_link=0x%08lX addr=%pK offset=%u "
+			     "page=%p addr=%pK offset=%u "
 			     "length=%u\n",
 			     (unsigned long long)sg_dma_address(sg), 
-			     sg->page_link, 
+			     sg_page(sg),
 			     sg_virt(sg), 
 			     sg->offset, sg->length);
 		*lbytes = nbytes;
@@ -505,10 +505,10 @@ ssi_aead_handle_config_buf(struct device *dev,
 			return -ENOMEM;
 	}
 	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=0x%llX "
-		     "page_link=0x%08lX addr=%pK "
+		     "page=%p addr=%pK "
 		     "offset=%u length=%u\n",
 		     (unsigned long long)sg_dma_address(&areq_ctx->ccm_adata_sg), 
-		     areq_ctx->ccm_adata_sg.page_link, 
+		     sg_page(&areq_ctx->ccm_adata_sg),
 		     sg_virt(&areq_ctx->ccm_adata_sg),
 		     areq_ctx->ccm_adata_sg.offset, 
 		     areq_ctx->ccm_adata_sg.length);
@@ -540,10 +540,10 @@ static inline int ssi_ahash_handle_curr_buf(struct device *dev,
 			return -ENOMEM;
 	}
 	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=0x%llX "
-		     "page_link=0x%08lX addr=%pK "
+		     "page=%p addr=%pK "
 		     "offset=%u length=%u\n",
 		     (unsigned long long)sg_dma_address(areq_ctx->buff_sg), 
-		     areq_ctx->buff_sg->page_link, 
+		     sg_page(areq_ctx->buff_sg),
 		     sg_virt(areq_ctx->buff_sg),
 		     areq_ctx->buff_sg->offset, 
 		     areq_ctx->buff_sg->length);
@@ -1870,4 +1870,3 @@ int ssi_buffer_mgr_fini(struct ssi_drvdata *drvdata)
 	}
 	return 0;
 }
-
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
