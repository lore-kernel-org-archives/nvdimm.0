Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 33A222095C3D2
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 15:06:24 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 13 Apr 2017 16:05:32 -0600
Message-Id: <1492121135-4437-20-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 19/22] mmc: tmio: Make use of the new sg_map helper function
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

Straightforward conversion to sg_map helper. A couple paths will
WARN if the memory does not end up being mappable.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/mmc/host/tmio_mmc.h     | 12 ++++++++++--
 drivers/mmc/host/tmio_mmc_dma.c |  5 +++++
 drivers/mmc/host/tmio_mmc_pio.c | 24 ++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index 2b349d4..ba68c9fed 100644
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -198,17 +198,25 @@ void tmio_mmc_enable_mmc_irqs(struct tmio_mmc_host *host, u32 i);
 void tmio_mmc_disable_mmc_irqs(struct tmio_mmc_host *host, u32 i);
 irqreturn_t tmio_mmc_irq(int irq, void *devid);
 
+/* Note: this function may return PTR_ERR and must be checked! */
 static inline char *tmio_mmc_kmap_atomic(struct scatterlist *sg,
 					 unsigned long *flags)
 {
+	void *ret;
+
 	local_irq_save(*flags);
-	return kmap_atomic(sg_page(sg)) + sg->offset;
+	ret = sg_map(sg, SG_KMAP_ATOMIC);
+
+	if (IS_ERR(ret))
+		local_irq_restore(*flags);
+
+	return ret;
 }
 
 static inline void tmio_mmc_kunmap_atomic(struct scatterlist *sg,
 					  unsigned long *flags, void *virt)
 {
-	kunmap_atomic(virt - sg->offset);
+	sg_unmap(sg, virt, SG_KMAP_ATOMIC);
 	local_irq_restore(*flags);
 }
 
diff --git a/drivers/mmc/host/tmio_mmc_dma.c b/drivers/mmc/host/tmio_mmc_dma.c
index fa8a936..07531f7 100644
--- a/drivers/mmc/host/tmio_mmc_dma.c
+++ b/drivers/mmc/host/tmio_mmc_dma.c
@@ -149,6 +149,11 @@ static void tmio_mmc_start_dma_tx(struct tmio_mmc_host *host)
 	if (!aligned) {
 		unsigned long flags;
 		void *sg_vaddr = tmio_mmc_kmap_atomic(sg, &flags);
+		if (IS_ERR(sg_vaddr)) {
+			ret = PTR_ERR(sg_vaddr);
+			goto pio;
+		}
+
 		sg_init_one(&host->bounce_sg, host->bounce_buf, sg->length);
 		memcpy(host->bounce_buf, sg_vaddr, host->bounce_sg.length);
 		tmio_mmc_kunmap_atomic(sg, &flags, sg_vaddr);
diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
index 6b789a7..d6fdbf6 100644
--- a/drivers/mmc/host/tmio_mmc_pio.c
+++ b/drivers/mmc/host/tmio_mmc_pio.c
@@ -479,6 +479,18 @@ static void tmio_mmc_pio_irq(struct tmio_mmc_host *host)
 	}
 
 	sg_virt = tmio_mmc_kmap_atomic(host->sg_ptr, &flags);
+	if (IS_ERR(sg_virt)) {
+		/*
+		 * This should really never happen unless
+		 * the code is changed to use memory that is
+		 * not mappable in the sg. Seeing there doesn't
+		 * seem to be any error path out of here,
+		 * we can only WARN.
+		 */
+		WARN(1, "Non-mappable memory used in sg!");
+		return;
+	}
+
 	buf = (unsigned short *)(sg_virt + host->sg_off);
 
 	count = host->sg_ptr->length - host->sg_off;
@@ -506,6 +518,18 @@ static void tmio_mmc_check_bounce_buffer(struct tmio_mmc_host *host)
 	if (host->sg_ptr == &host->bounce_sg) {
 		unsigned long flags;
 		void *sg_vaddr = tmio_mmc_kmap_atomic(host->sg_orig, &flags);
+		if (IS_ERR(sg_vaddr)) {
+			/*
+			 * This should really never happen unless
+			 * the code is changed to use memory that is
+			 * not mappable in the sg. Seeing there doesn't
+			 * seem to be any error path out of here,
+			 * we can only WARN.
+			 */
+			WARN(1, "Non-mappable memory used in sg!");
+			return;
+		}
+
 		memcpy(sg_vaddr, host->bounce_buf, host->bounce_sg.length);
 		tmio_mmc_kunmap_atomic(host->sg_orig, &flags, sg_vaddr);
 	}
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
