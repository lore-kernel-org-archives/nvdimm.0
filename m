Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A76C22194EB5E
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 15:06:52 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 13 Apr 2017 16:05:34 -0600
Message-Id: <1492121135-4437-22-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 21/22] mmc: tifm_sd: Make use of the new sg_map helper function
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

This conversion is a bit complicated. We modiy the read_fifo,
write_fifo and copy_page functions to take a scatterlist instead of a
page. Thus we can use sg_map instead of kmap_atomic. There's a bit of
accounting that needed to be done for the offset for this to work.
(Seeing sg_map takes care of the offset but it's already added and
used earlier in the code.

There's also no error path, so if unmappable memory finds its way into
the sgl we can only WARN.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/mmc/host/tifm_sd.c | 88 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 67 insertions(+), 21 deletions(-)

diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 93c4b40..75b0d74 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -111,14 +111,26 @@ struct tifm_sd {
 };
 
 /* for some reason, host won't respond correctly to readw/writew */
-static void tifm_sd_read_fifo(struct tifm_sd *host, struct page *pg,
+static void tifm_sd_read_fifo(struct tifm_sd *host, struct scatterlist *sg,
 			      unsigned int off, unsigned int cnt)
 {
 	struct tifm_dev *sock = host->dev;
 	unsigned char *buf;
 	unsigned int pos = 0, val;
 
-	buf = kmap_atomic(pg) + off;
+	buf = sg_map_offset(sg, off - sg->offset, SG_KMAP_ATOMIC);
+	if (IS_ERR(buf)) {
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
 	if (host->cmd_flags & DATA_CARRY) {
 		buf[pos++] = host->bounce_buf_data[0];
 		host->cmd_flags &= ~DATA_CARRY;
@@ -134,17 +146,29 @@ static void tifm_sd_read_fifo(struct tifm_sd *host, struct page *pg,
 		}
 		buf[pos++] = (val >> 8) & 0xff;
 	}
-	kunmap_atomic(buf - off);
+	sg_unmap_offset(sg, buf, off - sg->offset, SG_KMAP_ATOMIC);
 }
 
-static void tifm_sd_write_fifo(struct tifm_sd *host, struct page *pg,
+static void tifm_sd_write_fifo(struct tifm_sd *host, struct scatterlist *sg,
 			       unsigned int off, unsigned int cnt)
 {
 	struct tifm_dev *sock = host->dev;
 	unsigned char *buf;
 	unsigned int pos = 0, val;
 
-	buf = kmap_atomic(pg) + off;
+	buf = sg_map_offset(sg, off - sg->offset, SG_KMAP_ATOMIC);
+	if (IS_ERR(buf)) {
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
 	if (host->cmd_flags & DATA_CARRY) {
 		val = host->bounce_buf_data[0] | ((buf[pos++] << 8) & 0xff00);
 		writel(val, sock->addr + SOCK_MMCSD_DATA);
@@ -161,7 +185,7 @@ static void tifm_sd_write_fifo(struct tifm_sd *host, struct page *pg,
 		val |= (buf[pos++] << 8) & 0xff00;
 		writel(val, sock->addr + SOCK_MMCSD_DATA);
 	}
-	kunmap_atomic(buf - off);
+	sg_unmap_offset(sg, buf, off - sg->offset, SG_KMAP_ATOMIC);
 }
 
 static void tifm_sd_transfer_data(struct tifm_sd *host)
@@ -170,7 +194,6 @@ static void tifm_sd_transfer_data(struct tifm_sd *host)
 	struct scatterlist *sg = r_data->sg;
 	unsigned int off, cnt, t_size = TIFM_MMCSD_FIFO_SIZE * 2;
 	unsigned int p_off, p_cnt;
-	struct page *pg;
 
 	if (host->sg_pos == host->sg_len)
 		return;
@@ -192,33 +215,57 @@ static void tifm_sd_transfer_data(struct tifm_sd *host)
 		}
 		off = sg[host->sg_pos].offset + host->block_pos;
 
-		pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
 		p_off = offset_in_page(off);
 		p_cnt = PAGE_SIZE - p_off;
 		p_cnt = min(p_cnt, cnt);
 		p_cnt = min(p_cnt, t_size);
 
 		if (r_data->flags & MMC_DATA_READ)
-			tifm_sd_read_fifo(host, pg, p_off, p_cnt);
+			tifm_sd_read_fifo(host, &sg[host->sg_pos], p_off,
+					  p_cnt);
 		else if (r_data->flags & MMC_DATA_WRITE)
-			tifm_sd_write_fifo(host, pg, p_off, p_cnt);
+			tifm_sd_write_fifo(host, &sg[host->sg_pos], p_off,
+					   p_cnt);
 
 		t_size -= p_cnt;
 		host->block_pos += p_cnt;
 	}
 }
 
-static void tifm_sd_copy_page(struct page *dst, unsigned int dst_off,
-			      struct page *src, unsigned int src_off,
+static void tifm_sd_copy_page(struct scatterlist *dst, unsigned int dst_off,
+			      struct scatterlist *src, unsigned int src_off,
 			      unsigned int count)
 {
-	unsigned char *src_buf = kmap_atomic(src) + src_off;
-	unsigned char *dst_buf = kmap_atomic(dst) + dst_off;
+	unsigned char *src_buf, *dst_buf;
+
+	src_off -= src->offset;
+	dst_off -= dst->offset;
+
+	src_buf = sg_map_offset(src, src_off, SG_KMAP_ATOMIC);
+	if (IS_ERR(src_buf))
+		goto sg_map_err;
+
+	dst_buf = sg_map_offset(dst, dst_off, SG_KMAP_ATOMIC);
+	if (IS_ERR(dst_buf))
+		goto sg_map_err;
 
 	memcpy(dst_buf, src_buf, count);
 
-	kunmap_atomic(dst_buf - dst_off);
-	kunmap_atomic(src_buf - src_off);
+	sg_unmap_offset(dst, dst_buf, dst_off, SG_KMAP_ATOMIC);
+	sg_unmap_offset(src, src_buf, src_off, SG_KMAP_ATOMIC);
+
+sg_map_err:
+	if (!IS_ERR(src_buf))
+		sg_unmap_offset(src, src_buf, src_off, SG_KMAP_ATOMIC);
+
+	/*
+	 * This should really never happen unless
+	 * the code is changed to use memory that is
+	 * not mappable in the sg. Seeing there doesn't
+	 * seem to be any error path out of here,
+	 * we can only WARN.
+	 */
+	WARN(1, "Non-mappable memory used in sg!");
 }
 
 static void tifm_sd_bounce_block(struct tifm_sd *host, struct mmc_data *r_data)
@@ -227,7 +274,6 @@ static void tifm_sd_bounce_block(struct tifm_sd *host, struct mmc_data *r_data)
 	unsigned int t_size = r_data->blksz;
 	unsigned int off, cnt;
 	unsigned int p_off, p_cnt;
-	struct page *pg;
 
 	dev_dbg(&host->dev->dev, "bouncing block\n");
 	while (t_size) {
@@ -241,18 +287,18 @@ static void tifm_sd_bounce_block(struct tifm_sd *host, struct mmc_data *r_data)
 		}
 		off = sg[host->sg_pos].offset + host->block_pos;
 
-		pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
 		p_off = offset_in_page(off);
 		p_cnt = PAGE_SIZE - p_off;
 		p_cnt = min(p_cnt, cnt);
 		p_cnt = min(p_cnt, t_size);
 
 		if (r_data->flags & MMC_DATA_WRITE)
-			tifm_sd_copy_page(sg_page(&host->bounce_buf),
+			tifm_sd_copy_page(&host->bounce_buf,
 					  r_data->blksz - t_size,
-					  pg, p_off, p_cnt);
+					  &sg[host->sg_pos], p_off, p_cnt);
 		else if (r_data->flags & MMC_DATA_READ)
-			tifm_sd_copy_page(pg, p_off, sg_page(&host->bounce_buf),
+			tifm_sd_copy_page(&sg[host->sg_pos], p_off,
+					  &host->bounce_buf,
 					  r_data->blksz - t_size, p_cnt);
 
 		t_size -= p_cnt;
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
