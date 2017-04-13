Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 240042194EB79
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 15:06:45 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 13 Apr 2017 16:05:26 -0600
Message-Id: <1492121135-4437-14-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 13/22] scsi: hisi_sas, mvsas,
 gdth: Make use of the new sg_map helper function
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
To: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Sumit Semwal <sumit.semwal@linaro.org>, Ming Lin <ming.l@ssi.samsung.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org, linux-nvdimm@lists.01.org, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org, open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, target-devel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: Steve Wise <swise@opengridcomputing.com>
List-ID: <linux-nvdimm@lists.01.org>

Very straightforward conversion of three scsi drivers.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/scsi/gdth.c                    |  9 +++++++--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 14 +++++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 13 +++++++++----
 drivers/scsi/mvsas/mv_sas.c            | 10 +++++-----
 4 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index d020a13..82c9fba 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2301,10 +2301,15 @@ static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
                 return;
             }
             local_irq_save(flags);
-            address = kmap_atomic(sg_page(sl)) + sl->offset;
+            address = sg_map(sl, SG_KMAP_ATOMIC);
+            if (IS_ERR(address)) {
+                scp->result = DID_ERROR << 16;
+                return;
+	    }
+
             memcpy(address, buffer, cpnow);
             flush_dcache_page(sg_page(sl));
-            kunmap_atomic(address);
+            sg_unmap(sl, address, SG_KMAP_ATOMIC);
             local_irq_restore(flags);
             if (cpsum == cpcount)
                 break;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 854fbea..30408f8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1377,18 +1377,22 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 		void *to;
 		struct scatterlist *sg_resp = &task->smp_task.smp_resp;
 
-		ts->stat = SAM_STAT_GOOD;
-		to = kmap_atomic(sg_page(sg_resp));
+		to = sg_map(sg_resp, SG_KMAP_ATOMIC);
+		if (IS_ERR(to)) {
+			dev_err(dev, "slot complete: error mapping memory");
+			ts->stat = SAS_SG_ERR;
+			break;
+		}
 
+		ts->stat = SAM_STAT_GOOD;
 		dma_unmap_sg(dev, &task->smp_task.smp_resp, 1,
 			     DMA_FROM_DEVICE);
 		dma_unmap_sg(dev, &task->smp_task.smp_req, 1,
 			     DMA_TO_DEVICE);
-		memcpy(to + sg_resp->offset,
-		       slot->status_buffer +
+		memcpy(to, slot->status_buffer +
 		       sizeof(struct hisi_sas_err_record),
 		       sg_dma_len(sg_resp));
-		kunmap_atomic(to);
+		sg_unmap(sg_resp, to, SG_KMAP_ATOMIC);
 		break;
 	}
 	case SAS_PROTOCOL_SATA:
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 1b21445..0907947 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1796,18 +1796,23 @@ slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot,
 		struct scatterlist *sg_resp = &task->smp_task.smp_resp;
 		void *to;
 
+		to = sg_map(sg_resp, SG_KMAP_ATOMIC);
+		if (IS_ERR(to)) {
+			dev_err(dev, "slot complete: error mapping memory");
+			ts->stat = SAS_SG_ERR;
+			break;
+		}
+
 		ts->stat = SAM_STAT_GOOD;
-		to = kmap_atomic(sg_page(sg_resp));
 
 		dma_unmap_sg(dev, &task->smp_task.smp_resp, 1,
 			     DMA_FROM_DEVICE);
 		dma_unmap_sg(dev, &task->smp_task.smp_req, 1,
 			     DMA_TO_DEVICE);
-		memcpy(to + sg_resp->offset,
-		       slot->status_buffer +
+		memcpy(to, slot->status_buffer +
 		       sizeof(struct hisi_sas_err_record),
 		       sg_dma_len(sg_resp));
-		kunmap_atomic(to);
+		sg_unmap(sg_resp, to, SG_KMAP_ATOMIC);
 		break;
 	}
 	case SAS_PROTOCOL_SATA:
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index c7cc803..374d0e0 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1798,11 +1798,11 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 	case SAS_PROTOCOL_SMP: {
 			struct scatterlist *sg_resp = &task->smp_task.smp_resp;
 			tstat->stat = SAM_STAT_GOOD;
-			to = kmap_atomic(sg_page(sg_resp));
-			memcpy(to + sg_resp->offset,
-				slot->response + sizeof(struct mvs_err_info),
-				sg_dma_len(sg_resp));
-			kunmap_atomic(to);
+			to = sg_map(sg_resp, SG_KMAP_ATOMIC);
+			memcpy(to,
+			       slot->response + sizeof(struct mvs_err_info),
+			       sg_dma_len(sg_resp));
+			sg_unmap(sg_resp, to, SG_KMAP_ATOMIC);
 			break;
 		}
 
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
