Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D181321D28FF0
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jul 2017 09:58:22 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/3] pmem: remove pmem_rw_page()
Date: Fri, 28 Jul 2017 10:56:03 -0600
Message-Id: <20170728165604.10455-3-ross.zwisler@linux.intel.com>
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
PMEM and has had a nonzero maintenance burden, so remove it.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
---
 drivers/nvdimm/pmem.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index f7099ada..f23c82d 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -182,26 +182,6 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 	return BLK_QC_T_NONE;
 }
 
-static int pmem_rw_page(struct block_device *bdev, sector_t sector,
-		       struct page *page, bool is_write)
-{
-	struct pmem_device *pmem = bdev->bd_queue->queuedata;
-	blk_status_t rc;
-
-	rc = pmem_do_bvec(pmem, page, PAGE_SIZE, 0, is_write, sector);
-
-	/*
-	 * The ->rw_page interface is subtle and tricky.  The core
-	 * retries on any error, so we can only invoke page_endio() in
-	 * the successful completion case.  Otherwise, we'll see crashes
-	 * caused by double completion.
-	 */
-	if (rc == 0)
-		page_endio(page, is_write, 0);
-
-	return blk_status_to_errno(rc);
-}
-
 /* see "strong" declaration in tools/testing/nvdimm/pmem-dax.c */
 __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
@@ -225,7 +205,6 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
-	.rw_page =		pmem_rw_page,
 	.revalidate_disk =	nvdimm_revalidate_disk,
 };
 
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
