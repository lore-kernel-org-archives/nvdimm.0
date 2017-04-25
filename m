Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF5BA21951C8C
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 11:21:18 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Tue, 25 Apr 2017 12:21:01 -0600
Message-Id: <1493144468-22493-15-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 14/21] scsi: libfc,
 csiostor: Change to sg_copy_buffer in two drivers
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
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvdimm@lists.01.org, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, target-devel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Thumshirn <jth@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sumit Semwal <sumit.semwal@linaro.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

These two drivers appear to duplicate the functionality of
sg_copy_buffer. So we clean them up to use the common code.

This helps us remove a couple of instances that would otherwise be
slightly tricky sg_map usages.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Johannes Thumshirn <jth@kernel.org>
---
 drivers/scsi/csiostor/csio_scsi.c | 54 +++------------------------------------
 drivers/scsi/libfc/fc_libfc.c     | 49 ++++++++---------------------------
 2 files changed, 14 insertions(+), 89 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index a1ff75f..bd9d062 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1489,60 +1489,14 @@ static inline uint32_t
 csio_scsi_copy_to_sgl(struct csio_hw *hw, struct csio_ioreq *req)
 {
 	struct scsi_cmnd *scmnd  = (struct scsi_cmnd *)csio_scsi_cmnd(req);
-	struct scatterlist *sg;
-	uint32_t bytes_left;
-	uint32_t bytes_copy;
-	uint32_t buf_off = 0;
-	uint32_t start_off = 0;
-	uint32_t sg_off = 0;
-	void *sg_addr;
-	void *buf_addr;
 	struct csio_dma_buf *dma_buf;
+	size_t copied;
 
-	bytes_left = scsi_bufflen(scmnd);
-	sg = scsi_sglist(scmnd);
 	dma_buf = (struct csio_dma_buf *)csio_list_next(&req->gen_list);
+	copied = sg_copy_from_buffer(scsi_sglist(scmnd), scsi_sg_count(scmnd),
+				     dma_buf->vaddr, scsi_bufflen(scmnd));
 
-	/* Copy data from driver buffer to SGs of SCSI CMD */
-	while (bytes_left > 0 && sg && dma_buf) {
-		if (buf_off >= dma_buf->len) {
-			buf_off = 0;
-			dma_buf = (struct csio_dma_buf *)
-					csio_list_next(dma_buf);
-			continue;
-		}
-
-		if (start_off >= sg->length) {
-			start_off -= sg->length;
-			sg = sg_next(sg);
-			continue;
-		}
-
-		buf_addr = dma_buf->vaddr + buf_off;
-		sg_off = sg->offset + start_off;
-		bytes_copy = min((dma_buf->len - buf_off),
-				sg->length - start_off);
-		bytes_copy = min((uint32_t)(PAGE_SIZE - (sg_off & ~PAGE_MASK)),
-				 bytes_copy);
-
-		sg_addr = kmap_atomic(sg_page(sg) + (sg_off >> PAGE_SHIFT));
-		if (!sg_addr) {
-			csio_err(hw, "failed to kmap sg:%p of ioreq:%p\n",
-				sg, req);
-			break;
-		}
-
-		csio_dbg(hw, "copy_to_sgl:sg_addr %p sg_off %d buf %p len %d\n",
-				sg_addr, sg_off, buf_addr, bytes_copy);
-		memcpy(sg_addr + (sg_off & ~PAGE_MASK), buf_addr, bytes_copy);
-		kunmap_atomic(sg_addr);
-
-		start_off +=  bytes_copy;
-		buf_off += bytes_copy;
-		bytes_left -= bytes_copy;
-	}
-
-	if (bytes_left > 0)
+	if (copied != scsi_bufflen(scmnd))
 		return DID_ERROR;
 	else
 		return DID_OK;
diff --git a/drivers/scsi/libfc/fc_libfc.c b/drivers/scsi/libfc/fc_libfc.c
index d623d08..ce0805a 100644
--- a/drivers/scsi/libfc/fc_libfc.c
+++ b/drivers/scsi/libfc/fc_libfc.c
@@ -113,45 +113,16 @@ u32 fc_copy_buffer_to_sglist(void *buf, size_t len,
 			     u32 *nents, size_t *offset,
 			     u32 *crc)
 {
-	size_t remaining = len;
-	u32 copy_len = 0;
-
-	while (remaining > 0 && sg) {
-		size_t off, sg_bytes;
-		void *page_addr;
-
-		if (*offset >= sg->length) {
-			/*
-			 * Check for end and drop resources
-			 * from the last iteration.
-			 */
-			if (!(*nents))
-				break;
-			--(*nents);
-			*offset -= sg->length;
-			sg = sg_next(sg);
-			continue;
-		}
-		sg_bytes = min(remaining, sg->length - *offset);
-
-		/*
-		 * The scatterlist item may be bigger than PAGE_SIZE,
-		 * but we are limited to mapping PAGE_SIZE at a time.
-		 */
-		off = *offset + sg->offset;
-		sg_bytes = min(sg_bytes,
-			       (size_t)(PAGE_SIZE - (off & ~PAGE_MASK)));
-		page_addr = kmap_atomic(sg_page(sg) + (off >> PAGE_SHIFT));
-		if (crc)
-			*crc = crc32(*crc, buf, sg_bytes);
-		memcpy((char *)page_addr + (off & ~PAGE_MASK), buf, sg_bytes);
-		kunmap_atomic(page_addr);
-		buf += sg_bytes;
-		*offset += sg_bytes;
-		remaining -= sg_bytes;
-		copy_len += sg_bytes;
-	}
-	return copy_len;
+	size_t copied;
+
+	copied = sg_pcopy_from_buffer(sg, sg_nents(sg),
+				      buf, len, *offset);
+
+	*offset += copied;
+	if (crc)
+		*crc = crc32(*crc, buf, copied);
+
+	return copied;
 }
 
 /**
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
