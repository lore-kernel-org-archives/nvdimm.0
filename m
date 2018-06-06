Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8384B2118B64F
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jun 2018 09:45:17 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3 1/4] pmem, libnvdimm: complete REQ_FLUSH => REQ_PREFLUSH
Date: Wed,  6 Jun 2018 10:45:12 -0600
Message-Id: <20180606164515.25677-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Complete the move from REQ_FLUSH to REQ_PREFLUSH that apparently started
way back in v4.8.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/nvdimm/pmem.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 9d714926ecf5..252adfab1e47 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -164,11 +164,6 @@ static blk_status_t pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 	return rc;
 }
 
-/* account for REQ_FLUSH rename, replace with REQ_PREFLUSH after v4.8-rc1 */
-#ifndef REQ_FLUSH
-#define REQ_FLUSH REQ_PREFLUSH
-#endif
-
 static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 {
 	blk_status_t rc = 0;
@@ -179,7 +174,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 	struct pmem_device *pmem = q->queuedata;
 	struct nd_region *nd_region = to_region(pmem);
 
-	if (bio->bi_opf & REQ_FLUSH)
+	if (bio->bi_opf & REQ_PREFLUSH)
 		nvdimm_flush(nd_region);
 
 	do_acct = nd_iostat_start(bio, &start);
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
