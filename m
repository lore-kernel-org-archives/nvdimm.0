Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 04/15] libnvdimm,
 pmem: move request_queue allocation earlier in probe
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 01 Nov 2015 23:30:04 -0500
Message-ID: <20151102043004.6610.78684.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Before the dynamically allocated struct pages from devm_memremap_pages()
can be put to use outside the driver, we need a mechanism to track
whether they are still in use at teardown.  Towards that goal reorder
the initialization sequence to allow the 'q_usage_counter' from the
request_queue to be used by the devm_memremap_pages() implementation (in
subsequent patches).

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |   37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 349f03e7ed06..e46988fbdee5 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -133,6 +133,7 @@ static struct pmem_device *pmem_alloc(struct device *dev,
 		struct resource *res, int id)
 {
 	struct pmem_device *pmem;
+	struct request_queue *q;
 
 	pmem = devm_kzalloc(dev, sizeof(*pmem), GFP_KERNEL);
 	if (!pmem)
@@ -150,16 +151,23 @@ static struct pmem_device *pmem_alloc(struct device *dev,
 		return ERR_PTR(-EBUSY);
 	}
 
-	if (pmem_should_map_pages(dev))
+	q = blk_alloc_queue_node(GFP_KERNEL, dev_to_node(dev));
+	if (!q)
+		return ERR_PTR(-ENOMEM);
+
+	if (pmem_should_map_pages(dev)) {
 		pmem->virt_addr = (void __pmem *) devm_memremap_pages(dev, res);
-	else
+	} else
 		pmem->virt_addr = (void __pmem *) devm_memremap(dev,
 				pmem->phys_addr, pmem->size,
 				ARCH_MEMREMAP_PMEM);
 
-	if (IS_ERR(pmem->virt_addr))
+	if (IS_ERR(pmem->virt_addr)) {
+		blk_cleanup_queue(q);
 		return (void __force *) pmem->virt_addr;
+	}
 
+	pmem->pmem_queue = q;
 	return pmem;
 }
 
@@ -179,10 +187,6 @@ static int pmem_attach_disk(struct device *dev,
 	int nid = dev_to_node(dev);
 	struct gendisk *disk;
 
-	pmem->pmem_queue = blk_alloc_queue_node(GFP_KERNEL, nid);
-	if (!pmem->pmem_queue)
-		return -ENOMEM;
-
 	blk_queue_make_request(pmem->pmem_queue, pmem_make_request);
 	blk_queue_physical_block_size(pmem->pmem_queue, PAGE_SIZE);
 	blk_queue_max_hw_sectors(pmem->pmem_queue, UINT_MAX);
@@ -400,19 +404,22 @@ static int nd_pmem_probe(struct device *dev)
 	dev_set_drvdata(dev, pmem);
 	ndns->rw_bytes = pmem_rw_bytes;
 
-	if (is_nd_btt(dev))
+	if (is_nd_btt(dev)) {
+		/* btt allocates its own request_queue */
+		blk_cleanup_queue(pmem->pmem_queue);
+		pmem->pmem_queue = NULL;
 		return nvdimm_namespace_attach_btt(ndns);
+	}
 
 	if (is_nd_pfn(dev))
 		return nvdimm_namespace_attach_pfn(ndns);
 
-	if (nd_btt_probe(ndns, pmem) == 0) {
-		/* we'll come back as btt-pmem */
-		return -ENXIO;
-	}
-
-	if (nd_pfn_probe(ndns, pmem) == 0) {
-		/* we'll come back as pfn-pmem */
+	if (nd_btt_probe(ndns, pmem) == 0 || nd_pfn_probe(ndns, pmem) == 0) {
+		/*
+		 * We'll come back as either btt-pmem, or pfn-pmem, so
+		 * drop the queue allocation for now.
+		 */
+		blk_cleanup_queue(pmem->pmem_queue);
 		return -ENXIO;
 	}
 

