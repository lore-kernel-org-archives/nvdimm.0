Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id BC4D31A1EDE
 for <linux-nvdimm@lists.01.org>; Tue, 12 Jul 2016 15:29:55 -0700 (PDT)
Subject: [PATCH v3] libnvdimm, pmem: use REQ_FUA, REQ_FLUSH for nvdimm_flush()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Jul 2016 15:26:59 -0700
Message-ID: <146836238217.14676.14154640837011539657.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146812112233.32932.5962348391051315694.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146812112233.32932.5962348391051315694.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Given that nvdimm_flush() has higher overhead than wmb_pmem() (pointer
chasing through nd_region), and that we otherwise assume a platform has
ADR capability when flush hints are not present, move nvdimm_flush() to
REQ_FLUSH context.

Note that we still arrange for nvdimm_flush() to be called even in the
ADR case. We need at least once wmb() fence to push buffered writes in
the cpu out to the ADR protected domain.

Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

Change since v2: arrange for wmb() to be called for flushing in the ADR case

 drivers/nvdimm/pmem.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index e303655f243e..9d9c1beef020 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -113,6 +113,11 @@ static int pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 	return rc;
 }
 
+/* account for REQ_FLUSH rename, replace with REQ_PREFLUSH after v4.8-rc1 */
+#ifndef REQ_FLUSH
+#define REQ_FLUSH REQ_PREFLUSH
+#endif
+
 static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 {
 	int rc = 0;
@@ -121,6 +126,10 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	struct pmem_device *pmem = q->queuedata;
+	struct nd_region *nd_region = to_region(pmem);
+
+	if (bio->bi_rw & REQ_FLUSH)
+		nvdimm_flush(nd_region);
 
 	do_acct = nd_iostat_start(bio, &start);
 	bio_for_each_segment(bvec, bio, iter) {
@@ -135,8 +144,8 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 	if (do_acct)
 		nd_iostat_end(bio, start);
 
-	if (bio_data_dir(bio))
-		nvdimm_flush(to_region(pmem));
+	if (bio->bi_rw & REQ_FUA)
+		nvdimm_flush(nd_region);
 
 	bio_endio(bio);
 	return BLK_QC_T_NONE;
@@ -149,8 +158,6 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	int rc;
 
 	rc = pmem_do_bvec(pmem, page, PAGE_SIZE, 0, rw, sector);
-	if (rw & WRITE)
-		nvdimm_flush(to_region(pmem));
 
 	/*
 	 * The ->rw_page interface is subtle and tricky.  The core
@@ -279,6 +286,7 @@ static int pmem_attach_disk(struct device *dev,
 		return PTR_ERR(addr);
 	pmem->virt_addr = (void __pmem *) addr;
 
+	blk_queue_write_cache(q, true, true);
 	blk_queue_make_request(q, pmem_make_request);
 	blk_queue_physical_block_size(q, PAGE_SIZE);
 	blk_queue_max_hw_sectors(q, UINT_MAX);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
