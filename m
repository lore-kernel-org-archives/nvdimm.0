Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E1E92095B9C1
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 13:57:25 -0700 (PDT)
Subject: [PATCH v6 3/8] dmaengine: add verification of DMA_MEMSET_SG in
 dmaengine
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 25 Aug 2017 13:59:41 -0700
Message-ID: <150369478100.6962.6259321243184040278.stgit@djiang5-desk3.ch.intel.com>
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

DMA_MEMSET_SG is missing the verification of having the operation set and
also a supporting function provided.

Fixes: Commit 50c7cd2bd ("dmaengine: Add scatter-gathered memset")

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/dmaengine.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 4d2c4e1..40a035e 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -935,6 +935,8 @@ int dma_async_device_register(struct dma_device *device)
 		!device->device_prep_dma_pq_val);
 	BUG_ON(dma_has_cap(DMA_MEMSET, device->cap_mask) &&
 		!device->device_prep_dma_memset);
+	BUG_ON(dma_has_cap(DMA_MEMSET_SG, device->cap_mask) &&
+		!device->device_prep_dma_memset_sg);
 	BUG_ON(dma_has_cap(DMA_INTERRUPT, device->cap_mask) &&
 		!device->device_prep_dma_interrupt);
 	BUG_ON(dma_has_cap(DMA_MEMCPY_SG, device->cap_mask) &&

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
