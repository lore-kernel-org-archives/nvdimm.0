Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 903A421E25730
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jul 2017 09:56:54 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/3] btt: remove btt_rw_page()
Date: Fri, 28 Jul 2017 10:56:02 -0600
Message-Id: <20170728165604.10455-2-ross.zwisler@linux.intel.com>
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

The rw_page() interface doesn't provide a clear performance benefit for the
BTT and has had a nonzero maintenance burden, so remove it.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
---
 drivers/nvdimm/btt.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 14323fa..e10d330 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1236,20 +1236,6 @@ static blk_qc_t btt_make_request(struct request_queue *q, struct bio *bio)
 	return BLK_QC_T_NONE;
 }
 
-static int btt_rw_page(struct block_device *bdev, sector_t sector,
-		struct page *page, bool is_write)
-{
-	struct btt *btt = bdev->bd_disk->private_data;
-	int rc;
-
-	rc = btt_do_bvec(btt, NULL, page, PAGE_SIZE, 0, is_write, sector);
-	if (rc == 0)
-		page_endio(page, is_write, 0);
-
-	return rc;
-}
-
-
 static int btt_getgeo(struct block_device *bd, struct hd_geometry *geo)
 {
 	/* some standard values */
@@ -1261,7 +1247,6 @@ static int btt_getgeo(struct block_device *bd, struct hd_geometry *geo)
 
 static const struct block_device_operations btt_fops = {
 	.owner =		THIS_MODULE,
-	.rw_page =		btt_rw_page,
 	.getgeo =		btt_getgeo,
 	.revalidate_disk =	nvdimm_revalidate_disk,
 };
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
