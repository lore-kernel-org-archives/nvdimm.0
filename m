Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 579A221DF37CC
 for <linux-nvdimm@lists.01.org>; Mon,  7 Aug 2017 09:37:21 -0700 (PDT)
Subject: [PATCH v4 4/8] dmaengine: add verification of DMA_MEMSET_SG in
 dmaengine
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 07 Aug 2017 09:39:37 -0700
Message-ID: <150212397710.23722.415749304040796516.stgit@djiang5-desk3.ch.intel.com>
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

DMA_MEMSET_SG is missing the verification of having the operation set and
also a supporting function provided.

Fixes: Commit 50c7cd2bd ("dmaengine: Add scatter-gathered memset")

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/dmaengine.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 1c424f6..d9a71f0 100644
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
 	BUG_ON(dma_has_cap(DMA_SG_SG, device->cap_mask) &&

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
