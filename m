Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2A02A21CE7490
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jul 2017 09:59:44 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 3/3] brd: remove brd_rw_page()
Date: Fri, 28 Jul 2017 10:56:04 -0600
Message-Id: <20170728165604.10455-4-ross.zwisler@linux.intel.com>
In-Reply-To: <20170728165604.10455-1-ross.zwisler@linux.intel.com>
References: <20170728165604.10455-1-ross.zwisler@linux.intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jerome Marchand <jmarchan@redhat.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan@kernel.org>, Jan Kara <jack@suse.cz>, "karam . lee" <karam.lee@lge.com>, seungho1.park@lge.com, Nitin Gupta <ngupta@vflare.org>
List-ID: <linux-nvdimm@lists.01.org>

The rw_page() interface doesn't provide a clear performance benefit for
BRD and has had a nonzero maintenance burden, so remove it.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
---
 drivers/block/brd.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 104b71c..29325058 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -322,15 +322,6 @@ static blk_qc_t brd_make_request(struct request_queue *q, struct bio *bio)
 	return BLK_QC_T_NONE;
 }
 
-static int brd_rw_page(struct block_device *bdev, sector_t sector,
-		       struct page *page, bool is_write)
-{
-	struct brd_device *brd = bdev->bd_disk->private_data;
-	int err = brd_do_bvec(brd, page, PAGE_SIZE, 0, is_write, sector);
-	page_endio(page, is_write, err);
-	return err;
-}
-
 #ifdef CONFIG_BLK_DEV_RAM_DAX
 static long __brd_direct_access(struct brd_device *brd, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
@@ -370,7 +361,6 @@ static const struct dax_operations brd_dax_ops = {
 
 static const struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
-	.rw_page =		brd_rw_page,
 };
 
 /*
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
