Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 73BC91A1E4C
 for <linux-nvdimm@lists.01.org>; Sat,  4 Jun 2016 13:54:12 -0700 (PDT)
Subject: [PATCH 07/13] libnvdimm, pmem: use REQ_FUA,
 REQ_FLUSH for nvdimm_flush()
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 04 Jun 2016 13:53:09 -0700
Message-ID: <146507358984.8347.1228627559319403154.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Given that nvdimm_flush() has higher overhead than wmb_pmem() (pointer
chasing through nd_region), and that we otherwise assume a platform has
ADR capability when flush hints are not present, move nvdimm_flush() to
REQ_FLUSH context.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 248a89736bbf..79539b6498c9 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -148,7 +148,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 	if (do_acct)
 		nd_iostat_end(bio, start);
 
-	if (bio_data_dir(bio))
+	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA))
 		nvdimm_flush(to_region(pmem));
 
 	bio_endio(bio);
@@ -162,8 +162,6 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	int rc;
 
 	rc = pmem_do_bvec(pmem, page, PAGE_SIZE, 0, rw, sector);
-	if (rw & WRITE)
-		nvdimm_flush(to_region(pmem));
 
 	/*
 	 * The ->rw_page interface is subtle and tricky.  The core
@@ -221,9 +219,9 @@ static int pmem_attach_disk(struct device *dev,
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
 	struct nd_region *nd_region = to_nd_region(dev->parent);
 	struct vmem_altmap __altmap, *altmap = NULL;
+	int nid = dev_to_node(dev), has_flush;
 	struct resource *res = &nsio->res;
 	struct nd_pfn *nd_pfn = NULL;
-	int nid = dev_to_node(dev);
 	struct nd_pfn_sb *pfn_sb;
 	struct pmem_device *pmem;
 	struct resource pfn_res;
@@ -249,8 +247,6 @@ static int pmem_attach_disk(struct device *dev,
 	dev_set_drvdata(dev, pmem);
 	pmem->phys_addr = res->start;
 	pmem->size = resource_size(res);
-	if (nvdimm_has_flush(nd_region) < 0)
-		dev_warn(dev, "unable to guarantee persistence of writes\n");
 
 	if (!devm_request_mem_region(dev, res->start, resource_size(res),
 				dev_name(dev))) {
@@ -293,6 +289,11 @@ static int pmem_attach_disk(struct device *dev,
 		return PTR_ERR(addr);
 	pmem->virt_addr = (void __pmem *) addr;
 
+	has_flush = nvdimm_has_flush(nd_region);
+	if (has_flush < 0)
+		dev_warn(dev, "unable to guarantee persistence of writes\n");
+	else if (has_flush > 0)
+		blk_queue_write_cache(q, true, true);
 	blk_queue_make_request(q, pmem_make_request);
 	blk_queue_physical_block_size(q, PAGE_SIZE);
 	blk_queue_max_hw_sectors(q, UINT_MAX);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
