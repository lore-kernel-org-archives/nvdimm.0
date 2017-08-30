Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 40E2321E95DE8
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 13:56:09 -0700 (PDT)
Subject: [PATCH v7 7/9] libnvdimm: remove definition of REQ_FLUSH
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 30 Aug 2017 13:56:12 -0700
Message-ID: <150412657216.69288.11577587751205759548.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <150412628764.69288.12074115435918322858.stgit@djiang5-desk3.ch.intel.com>
References: <150412628764.69288.12074115435918322858.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: vinod.koul@intel.com, dan.j.williams@intel.com
Cc: dmaengine@vger.kernel.org, hch@infradead.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

According to driver comment REQ_FLUSH is replaced with REQ_PREFLUSH after
v4.8-rc1. Removing definition and putting in new definition.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/pmem.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index f7099ada..b1460d1 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -144,11 +144,6 @@ static blk_status_t pmem_do_bvec(struct pmem_device *pmem, struct page *page,
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
@@ -159,7 +154,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 	struct pmem_device *pmem = q->queuedata;
 	struct nd_region *nd_region = to_region(pmem);
 
-	if (bio->bi_opf & REQ_FLUSH)
+	if (bio->bi_opf & REQ_PREFLUSH)
 		nvdimm_flush(nd_region);
 
 	do_acct = nd_iostat_start(bio, &start);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
