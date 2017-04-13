Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CA14C2194EB6F
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 15:06:19 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 13 Apr 2017 16:05:27 -0600
Message-Id: <1492121135-4437-15-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 14/22] scsi: arcmsr, ips,
 megaraid: Make use of the new sg_map helper function
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

Very straightforward conversion of three scsi drivers

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 16 ++++++++++++----
 drivers/scsi/ips.c               |  8 ++++----
 drivers/scsi/megaraid.c          |  9 +++++++--
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index af032c4..3cd485c 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2306,7 +2306,10 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 
 	use_sg = scsi_sg_count(cmd);
 	sg = scsi_sglist(cmd);
-	buffer = kmap_atomic(sg_page(sg)) + sg->offset;
+	buffer = sg_map(sg, SG_KMAP_ATOMIC);
+	if (IS_ERR(buffer))
+		return ARCMSR_MESSAGE_FAIL;
+
 	if (use_sg > 1) {
 		retvalue = ARCMSR_MESSAGE_FAIL;
 		goto message_out;
@@ -2539,7 +2542,7 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 message_out:
 	if (use_sg) {
 		struct scatterlist *sg = scsi_sglist(cmd);
-		kunmap_atomic(buffer - sg->offset);
+		sg_unmap(sg, buffer, SG_KMAP_ATOMIC);
 	}
 	return retvalue;
 }
@@ -2590,11 +2593,16 @@ static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
 		strncpy(&inqdata[32], "R001", 4); /* Product Revision */
 
 		sg = scsi_sglist(cmd);
-		buffer = kmap_atomic(sg_page(sg)) + sg->offset;
+		buffer = sg_map(sg, SG_KMAP_ATOMIC);
+		if (IS_ERR(buffer)) {
+			cmd->result = (DID_ERROR << 16);
+			cmd->scsi_done(cmd);
+			return;
+		}
 
 		memcpy(buffer, inqdata, sizeof(inqdata));
 		sg = scsi_sglist(cmd);
-		kunmap_atomic(buffer - sg->offset);
+		sg_unmap(sg, buffer, SG_KMAP_ATOMIC);
 
 		cmd->scsi_done(cmd);
 	}
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 3419e1b..a44291d 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1506,14 +1506,14 @@ static int ips_is_passthru(struct scsi_cmnd *SC)
                 /* kmap_atomic() ensures addressability of the user buffer.*/
                 /* local_irq_save() protects the KM_IRQ0 address slot.     */
                 local_irq_save(flags);
-                buffer = kmap_atomic(sg_page(sg)) + sg->offset;
-                if (buffer && buffer[0] == 'C' && buffer[1] == 'O' &&
+                buffer = sg_map(sg, SG_KMAP_ATOMIC);
+                if (!IS_ERR(buffer) && buffer[0] == 'C' && buffer[1] == 'O' &&
                     buffer[2] == 'P' && buffer[3] == 'P') {
-                        kunmap_atomic(buffer - sg->offset);
+                        sg_unmap(sg, buffer, SG_KMAP_ATOMIC);
                         local_irq_restore(flags);
                         return 1;
                 }
-                kunmap_atomic(buffer - sg->offset);
+                sg_unmap(sg, buffer, SG_KMAP_ATOMIC);
                 local_irq_restore(flags);
 	}
 	return 0;
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 3c63c29..0b66e50 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -663,10 +663,15 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
 			struct scatterlist *sg;
 
 			sg = scsi_sglist(cmd);
-			buf = kmap_atomic(sg_page(sg)) + sg->offset;
+			buf = sg_map(sg, SG_KMAP_ATOMIC);
+			if (IS_ERR(buf)) {
+                                cmd->result = (DID_ERROR << 16);
+				cmd->scsi_done(cmd);
+				return NULL;
+			}
 
 			memset(buf, 0, cmd->cmnd[4]);
-			kunmap_atomic(buf - sg->offset);
+			sg_unmap(sg, buf, SG_KMAP_ATOMIC);
 
 			cmd->result = (DID_OK << 16);
 			cmd->scsi_done(cmd);
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
