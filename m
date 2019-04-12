Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from tc-sys-mailedm05.tc.baidu.com (mx56.baidu.com [61.135.168.56])
 by ml01.01.org (Postfix) with ESMTP id 9FD7E2120ADCA
 for <linux-nvdimm@lists.01.org>; Thu, 11 Apr 2019 23:47:20 -0700 (PDT)
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
 by tc-sys-mailedm05.tc.baidu.com (Postfix) with ESMTP id 4396B1EBA008
 for <linux-nvdimm@lists.01.org>; Fri, 12 Apr 2019 14:47:18 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH][RFC] nvdimm: pmem: always flush nvdimm for write request
Date: Fri, 12 Apr 2019 14:47:18 +0800
Message-Id: <1555051638-32354-1-git-send-email-lirongqing@baidu.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

flush nvdimm for write request can speed the random write, give
about 20% performance

The below is result of fio 4k random write nvdimm as /dev/pmem0

Before:
Jobs: 32 (f=32): [W(32)][14.2%][w=1884MiB/s][w=482k IOPS][eta 01m:43s]
After:
Jobs: 32 (f=32): [W(32)][8.3%][w=2378MiB/s][w=609k IOPS][eta 01m:50s]

This makes sure that the newly written data is durable too

Co-developed-by: Liang ZhiCheng <liangzhicheng@baidu.com>
Signed-off-by: Liang ZhiCheng <liangzhicheng@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
This test is done on intel AEP

 drivers/nvdimm/pmem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 1d432c5ed..9f8f25880 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -197,6 +197,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 	unsigned long start;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
+	unsigned int op = bio_op(bio);
 	struct pmem_device *pmem = q->queuedata;
 	struct nd_region *nd_region = to_region(pmem);
 
@@ -206,7 +207,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 	do_acct = nd_iostat_start(bio, &start);
 	bio_for_each_segment(bvec, bio, iter) {
 		rc = pmem_do_bvec(pmem, bvec.bv_page, bvec.bv_len,
-				bvec.bv_offset, bio_op(bio), iter.bi_sector);
+				bvec.bv_offset, op, iter.bi_sector);
 		if (rc) {
 			bio->bi_status = rc;
 			break;
@@ -215,7 +216,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 	if (do_acct)
 		nd_iostat_end(bio, start);
 
-	if (bio->bi_opf & REQ_FUA)
+	if (bio->bi_opf & REQ_FUA || op_is_write(op))
 		nvdimm_flush(nd_region);
 
 	bio_endio(bio);
-- 
2.16.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
