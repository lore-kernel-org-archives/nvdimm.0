Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B68721951C9D
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 11:21:25 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Tue, 25 Apr 2017 12:21:08 -0600
Message-Id: <1493144468-22493-22-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 21/21] memstick: Make use of the new sg_map helper function
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
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Alex Dubov <oakad@yahoo.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sumit Semwal <sumit.semwal@linaro.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Straightforward conversion, but we have to make use of
SG_MAP_MUST_NOT_FAIL which may BUG_ON in certain cases
in the future.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/host/jmb38x_ms.c | 11 ++++++-----
 drivers/memstick/host/tifm_ms.c   | 11 ++++++-----
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 48db922..9019e37 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -303,7 +303,6 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 	unsigned int off;
 	unsigned int t_size, p_cnt;
 	unsigned char *buf;
-	struct page *pg;
 	unsigned long flags = 0;
 
 	if (host->req->long_data) {
@@ -318,14 +317,14 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 		unsigned int uninitialized_var(p_off);
 
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
 			p_off = offset_in_page(off);
 			p_cnt = PAGE_SIZE - p_off;
 			p_cnt = min(p_cnt, length);
 
 			local_irq_save(flags);
-			buf = kmap_atomic(pg) + p_off;
+			buf = sg_map(&host->req->sg,
+				     off - host->req->sg.offset,
+				     SG_KMAP_ATOMIC | SG_MAP_MUST_NOT_FAIL);
 		} else {
 			buf = host->req->data + host->block_pos;
 			p_cnt = host->req->data_len - host->block_pos;
@@ -341,7 +340,9 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 				 : jmb38x_ms_read_reg_data(host, buf, p_cnt);
 
 		if (host->req->long_data) {
-			kunmap_atomic(buf - p_off);
+			sg_unmap(&host->req->sg, buf,
+				 off - host->req->sg.offset,
+				 SG_KMAP_ATOMIC);
 			local_irq_restore(flags);
 		}
 
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index 7bafa72..304985d 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -186,7 +186,6 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 	unsigned int off;
 	unsigned int t_size, p_cnt;
 	unsigned char *buf;
-	struct page *pg;
 	unsigned long flags = 0;
 
 	if (host->req->long_data) {
@@ -203,14 +202,14 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 		unsigned int uninitialized_var(p_off);
 
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
 			p_off = offset_in_page(off);
 			p_cnt = PAGE_SIZE - p_off;
 			p_cnt = min(p_cnt, length);
 
 			local_irq_save(flags);
-			buf = kmap_atomic(pg) + p_off;
+			buf = sg_map(&host->req->sg,
+				     off - host->req->sg.offset,
+				     SG_KMAP_ATOMIC | SG_MAP_MUST_NOT_FAIL);
 		} else {
 			buf = host->req->data + host->block_pos;
 			p_cnt = host->req->data_len - host->block_pos;
@@ -221,7 +220,9 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 			 : tifm_ms_read_data(host, buf, p_cnt);
 
 		if (host->req->long_data) {
-			kunmap_atomic(buf - p_off);
+			sg_unmap(&host->req->sg, buf,
+				 off - host->req->sg.offset,
+				 SG_KMAP_ATOMIC | SG_MAP_MUST_NOT_FAIL);
 			local_irq_restore(flags);
 		}
 
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
