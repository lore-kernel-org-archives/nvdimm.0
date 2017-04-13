Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D3012194EB79
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 15:06:52 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 13 Apr 2017 16:05:30 -0600
Message-Id: <1492121135-4437-18-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 17/22] mmc: sdhci: Make use of the new sg_map helper function
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

Straightforward conversion, except due to the lack of error path we
have to WARN if the memory in the SGL is not mappable.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/mmc/host/sdhci.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 63bc33a..af0c107 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -497,15 +497,34 @@ static int sdhci_pre_dma_transfer(struct sdhci_host *host,
 	return sg_count;
 }
 
+/*
+ * Note this function may return PTR_ERR and must be checked.
+ */
 static char *sdhci_kmap_atomic(struct scatterlist *sg, unsigned long *flags)
 {
+	void *ret;
+
 	local_irq_save(*flags);
-	return kmap_atomic(sg_page(sg)) + sg->offset;
+
+	ret = sg_map(sg, SG_KMAP_ATOMIC);
+	if (IS_ERR(ret)) {
+		/*
+		 * This should really never happen unless the code is changed
+		 * to use memory that is not mappable in the sg. Seeing there
+		 * doesn't seem to be any error path out of here, we can only
+		 * WARN.
+		 */
+		WARN(1, "Non-mappable memory used in sg!");
+		local_irq_restore(*flags);
+	}
+
+	return ret;
 }
 
-static void sdhci_kunmap_atomic(void *buffer, unsigned long *flags)
+static void sdhci_kunmap_atomic(struct scatterlist *sg, void *buffer,
+				unsigned long *flags)
 {
-	kunmap_atomic(buffer);
+	sg_unmap(sg, buffer, SG_KMAP_ATOMIC);
 	local_irq_restore(*flags);
 }
 
@@ -568,8 +587,11 @@ static void sdhci_adma_table_pre(struct sdhci_host *host,
 		if (offset) {
 			if (data->flags & MMC_DATA_WRITE) {
 				buffer = sdhci_kmap_atomic(sg, &flags);
+				if (IS_ERR(buffer))
+					return;
+
 				memcpy(align, buffer, offset);
-				sdhci_kunmap_atomic(buffer, &flags);
+				sdhci_kunmap_atomic(sg, buffer, &flags);
 			}
 
 			/* tran, valid */
@@ -646,8 +668,11 @@ static void sdhci_adma_table_post(struct sdhci_host *host,
 					       (sg_dma_address(sg) & SDHCI_ADMA2_MASK);
 
 					buffer = sdhci_kmap_atomic(sg, &flags);
+					if (IS_ERR(buffer))
+						return;
+
 					memcpy(buffer, align, size);
-					sdhci_kunmap_atomic(buffer, &flags);
+					sdhci_kunmap_atomic(sg, buffer, &flags);
 
 					align += SDHCI_ADMA2_ALIGN;
 				}
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
