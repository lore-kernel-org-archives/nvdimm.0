Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from lgeamrelo13.lge.com (LGEAMRELO13.lge.com [156.147.23.53])
 by ml01.01.org (Postfix) with ESMTP id 0542921DFE93A
 for <linux-nvdimm@lists.01.org>; Mon,  7 Aug 2017 23:48:16 -0700 (PDT)
From: Minchan Kim <minchan@kernel.org>
Subject: [PATCH v1 5/6] zram: remove zram_rw_page
Date: Tue,  8 Aug 2017 15:50:23 +0900
Message-Id: <1502175024-28338-6-git-send-email-minchan@kernel.org>
In-Reply-To: <1502175024-28338-1-git-send-email-minchan@kernel.org>
References: <1502175024-28338-1-git-send-email-minchan@kernel.org>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, jack@suse.cz, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, kernel-team <kernel-team@lge.com>, seungho1.park@lge.com, "karam . lee" <karam.lee@lge.com>
List-ID: <linux-nvdimm@lists.01.org>

With on-stack-bio, rw_page interface doesn't provide a clear performance
benefit for zram and surely has a maintenance burden, so remove the
last user to remove rw_page completely.

Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 52 -------------------------------------------
 1 file changed, 52 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 3eda88d0ca95..9620163308fa 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1268,57 +1268,6 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	atomic64_inc(&zram->stats.notify_free);
 }
 
-static int zram_rw_page(struct block_device *bdev, sector_t sector,
-		       struct page *page, bool is_write)
-{
-	int offset, ret;
-	u32 index;
-	struct zram *zram;
-	struct bio_vec bv;
-
-	if (PageTransHuge(page))
-		return -ENOTSUPP;
-	zram = bdev->bd_disk->private_data;
-
-	if (!valid_io_request(zram, sector, PAGE_SIZE)) {
-		atomic64_inc(&zram->stats.invalid_io);
-		ret = -EINVAL;
-		goto out;
-	}
-
-	index = sector >> SECTORS_PER_PAGE_SHIFT;
-	offset = (sector & (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
-
-	bv.bv_page = page;
-	bv.bv_len = PAGE_SIZE;
-	bv.bv_offset = 0;
-
-	ret = zram_bvec_rw(zram, &bv, index, offset, is_write, NULL);
-out:
-	/*
-	 * If I/O fails, just return error(ie, non-zero) without
-	 * calling page_endio.
-	 * It causes resubmit the I/O with bio request by upper functions
-	 * of rw_page(e.g., swap_readpage, __swap_writepage) and
-	 * bio->bi_end_io does things to handle the error
-	 * (e.g., SetPageError, set_page_dirty and extra works).
-	 */
-	if (unlikely(ret < 0))
-		return ret;
-
-	switch (ret) {
-	case 0:
-		page_endio(page, is_write, 0);
-		break;
-	case 1:
-		ret = 0;
-		break;
-	default:
-		WARN_ON(1);
-	}
-	return ret;
-}
-
 static void zram_reset_device(struct zram *zram)
 {
 	struct zcomp *comp;
@@ -1460,7 +1409,6 @@ static int zram_open(struct block_device *bdev, fmode_t mode)
 static const struct block_device_operations zram_devops = {
 	.open = zram_open,
 	.swap_slot_free_notify = zram_slot_free_notify,
-	.rw_page = zram_rw_page,
 	.owner = THIS_MODULE
 };
 
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
