Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 255A621D4919D
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 15:22:16 -0700 (PDT)
Subject: [PATCH 1/5] dmaengine: ioatdma: revert 7618d035 to allow sharing of
 DMA channels
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 31 Jul 2017 15:24:24 -0700
Message-ID: <150153986422.49768.3900446477975437510.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <150153948477.49768.5767882242140065474.stgit@djiang5-desk3.ch.intel.com>
References: <150153948477.49768.5767882242140065474.stgit@djiang5-desk3.ch.intel.com>
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

Commit 7618d0359c16 ("dmaengine: ioatdma: Set non RAID channels to be
private capable") makes all non-RAID ioatdma channels as private to be
requestable by dma_request_channel(). With PQ CAP support going away for
ioatdma, this would make all channels private. To support the usage of
ioatdma for blk-mq implementation of pmem we need as many channels we can
share in order to be high performing. Thus reverting the patch.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/ioat/init.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index 6ad4384..e437112 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -1163,9 +1163,6 @@ static int ioat3_dma_probe(struct ioatdma_device *ioat_dma, int dca)
 		}
 	}
 
-	if (!(ioat_dma->cap & (IOAT_CAP_XOR | IOAT_CAP_PQ)))
-		dma_cap_set(DMA_PRIVATE, dma->cap_mask);
-
 	err = ioat_probe(ioat_dma);
 	if (err)
 		return err;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
