Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 91ED321951C9B
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 11:21:30 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Tue, 25 Apr 2017 12:21:07 -0600
Message-Id: <1493144468-22493-21-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 20/21] mmc: tifm_sd: Make use of the new sg_map helper
 function
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
Cc: Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulf.hansson@linaro.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Alex Dubov <oakad@yahoo.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sumit Semwal <sumit.semwal@linaro.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

This conversion is a bit complicated. We modiy the read_fifo,
write_fifo and copy_page functions to take a scatterlist instead of a
page. Thus we can use sg_map instead of kmap_atomic. There's a bit of
accounting that needed to be done for the offset for this to work.
(Seeing sg_map takes care of the offset but it's already added and
used earlier in the code.)

There's also no error path, so we use SG_MAP_MUST_NOT_FAIL which may
BUG_ON in certain cases in the future.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/tifm_sd.c | 50 +++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 93c4b40..e64345a 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -111,14 +111,16 @@ struct tifm_sd {
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
+	buf = sg_map(sg, off - sg->offset,
+		     SG_KMAP_ATOMIC | SG_MAP_MUST_NOT_FAIL);
+
 	if (host->cmd_flags & DATA_CARRY) {
 		buf[pos++] = host->bounce_buf_data[0];
 		host->cmd_flags &= ~DATA_CARRY;
@@ -134,17 +136,19 @@ static void tifm_sd_read_fifo(struct tifm_sd *host, struct page *pg,
 		}
 		buf[pos++] = (val >> 8) & 0xff;
 	}
-	kunmap_atomic(buf - off);
+	sg_unmap(sg, buf, off - sg->offset, SG_KMAP_ATOMIC);
 }
 
-static void tifm_sd_write_fifo(struct tifm_sd *host, struct page *pg,
+static void tifm_sd_write_fifo(struct tifm_sd *host, struct scatterlist *sg,
 			       unsigned int off, unsigned int cnt)
 {
 	struct tifm_dev *sock = host->dev;
 	unsigned char *buf;
 	unsigned int pos = 0, val;
 
-	buf = kmap_atomic(pg) + off;
+	buf = sg_map(sg, off - sg->offset,
+		     SG_KMAP_ATOMIC | SG_MAP_MUST_NOT_FAIL);
+
 	if (host->cmd_flags & DATA_CARRY) {
 		val = host->bounce_buf_data[0] | ((buf[pos++] << 8) & 0xff00);
 		writel(val, sock->addr + SOCK_MMCSD_DATA);
@@ -161,7 +165,7 @@ static void tifm_sd_write_fifo(struct tifm_sd *host, struct page *pg,
 		val |= (buf[pos++] << 8) & 0xff00;
 		writel(val, sock->addr + SOCK_MMCSD_DATA);
 	}
-	kunmap_atomic(buf - off);
+	sg_unmap(sg, buf, off - sg->offset, SG_KMAP_ATOMIC);
 }
 
 static void tifm_sd_transfer_data(struct tifm_sd *host)
@@ -170,7 +174,6 @@ static void tifm_sd_transfer_data(struct tifm_sd *host)
 	struct scatterlist *sg = r_data->sg;
 	unsigned int off, cnt, t_size = TIFM_MMCSD_FIFO_SIZE * 2;
 	unsigned int p_off, p_cnt;
-	struct page *pg;
 
 	if (host->sg_pos == host->sg_len)
 		return;
@@ -192,33 +195,39 @@ static void tifm_sd_transfer_data(struct tifm_sd *host)
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
+	src_buf = sg_map(src, src_off, SG_KMAP_ATOMIC | SG_MAP_MUST_NOT_FAIL);
+	dst_buf = sg_map(dst, dst_off, SG_KMAP_ATOMIC | SG_MAP_MUST_NOT_FAIL);
 
 	memcpy(dst_buf, src_buf, count);
 
-	kunmap_atomic(dst_buf - dst_off);
-	kunmap_atomic(src_buf - src_off);
+	sg_unmap(dst, dst_buf, dst_off, SG_KMAP_ATOMIC);
+	sg_unmap(src, src_buf, src_off, SG_KMAP_ATOMIC);
 }
 
 static void tifm_sd_bounce_block(struct tifm_sd *host, struct mmc_data *r_data)
@@ -227,7 +236,6 @@ static void tifm_sd_bounce_block(struct tifm_sd *host, struct mmc_data *r_data)
 	unsigned int t_size = r_data->blksz;
 	unsigned int off, cnt;
 	unsigned int p_off, p_cnt;
-	struct page *pg;
 
 	dev_dbg(&host->dev->dev, "bouncing block\n");
 	while (t_size) {
@@ -241,18 +249,18 @@ static void tifm_sd_bounce_block(struct tifm_sd *host, struct mmc_data *r_data)
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
