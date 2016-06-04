Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 91AF81A1E4C
 for <linux-nvdimm@lists.01.org>; Sat,  4 Jun 2016 13:53:51 -0700 (PDT)
Subject: [PATCH 03/13] libnvdimm: introduce nvdimm_flush()
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 04 Jun 2016 13:52:48 -0700
Message-ID: <146507356876.8347.4735880992775196026.stgit@dwillia2-desk3.amr.corp.intel.com>
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

nvdimm_flush() is an alternative to the x86 pcommit instruction.  It is
an optional write flushing mechanism that an nvdimm bus can provide for
the pmem driver to consume.  In the case of the NFIT nvdimm-bus-provider
nvdimm_flush() is implemented as a series of flush-hint-address [1]
writes to each dimm in the interleave set that backs the namespace.  For
now this implementation is just a simple replacement of wmb_pmem() /
arch_has_wmb_pmem() with nvdimm_flush() / nvdimm_has_flush().

We defer the full implementation of nvdimm_flush() until the
implementation is prepared to also handle the blk-region case.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c        |   27 +++++++++++++++++++++------
 drivers/nvdimm/region_devs.c |   35 +++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h    |    2 ++
 3 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 608fc4464574..248a89736bbf 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -46,10 +46,24 @@ struct pmem_device {
 	struct badblocks	bb;
 };
 
+static struct device *to_dev(struct pmem_device *pmem)
+{
+	/*
+	 * nvdimm bus services need a 'dev' parameter, and we record the device
+	 * at init in bb.dev.
+	 */
+	return pmem->bb.dev;
+}
+
+static struct nd_region *to_region(struct pmem_device *pmem)
+{
+	return to_nd_region(to_dev(pmem)->parent);
+}
+
 static void pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 		unsigned int len)
 {
-	struct device *dev = pmem->bb.dev;
+	struct device *dev = to_dev(pmem);
 	sector_t sector;
 	long cleared;
 
@@ -135,7 +149,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 		nd_iostat_end(bio, start);
 
 	if (bio_data_dir(bio))
-		wmb_pmem();
+		nvdimm_flush(to_region(pmem));
 
 	bio_endio(bio);
 	return BLK_QC_T_NONE;
@@ -149,7 +163,7 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 
 	rc = pmem_do_bvec(pmem, page, PAGE_SIZE, 0, rw, sector);
 	if (rw & WRITE)
-		wmb_pmem();
+		nvdimm_flush(to_region(pmem));
 
 	/*
 	 * The ->rw_page interface is subtle and tricky.  The core
@@ -205,6 +219,7 @@ static int pmem_attach_disk(struct device *dev,
 		struct nd_namespace_common *ndns)
 {
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
+	struct nd_region *nd_region = to_nd_region(dev->parent);
 	struct vmem_altmap __altmap, *altmap = NULL;
 	struct resource *res = &nsio->res;
 	struct nd_pfn *nd_pfn = NULL;
@@ -234,7 +249,7 @@ static int pmem_attach_disk(struct device *dev,
 	dev_set_drvdata(dev, pmem);
 	pmem->phys_addr = res->start;
 	pmem->size = resource_size(res);
-	if (!arch_has_wmb_pmem())
+	if (nvdimm_has_flush(nd_region) < 0)
 		dev_warn(dev, "unable to guarantee persistence of writes\n");
 
 	if (!devm_request_mem_region(dev, res->start, resource_size(res),
@@ -302,7 +317,7 @@ static int pmem_attach_disk(struct device *dev,
 			/ 512);
 	if (devm_init_badblocks(dev, &pmem->bb))
 		return -ENOMEM;
-	nvdimm_badblocks_populate(to_nd_region(dev->parent), &pmem->bb, res);
+	nvdimm_badblocks_populate(nd_region, &pmem->bb, res);
 	disk->bb = &pmem->bb;
 	add_disk(disk);
 	revalidate_disk(disk);
@@ -345,8 +360,8 @@ static int nd_pmem_remove(struct device *dev)
 
 static void nd_pmem_notify(struct device *dev, enum nvdimm_event event)
 {
-	struct nd_region *nd_region = to_nd_region(dev->parent);
 	struct pmem_device *pmem = dev_get_drvdata(dev);
+	struct nd_region *nd_region = to_region(pmem);
 	resource_size_t offset = 0, end_trunc = 0;
 	struct nd_namespace_common *ndns;
 	struct nd_namespace_io *nsio;
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 320f0f3ea367..420e1a5e2250 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -14,6 +14,7 @@
 #include <linux/highmem.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/pmem.h>
 #include <linux/sort.h>
 #include <linux/io.h>
 #include <linux/nd.h>
@@ -796,6 +797,40 @@ struct nd_region *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
 }
 EXPORT_SYMBOL_GPL(nvdimm_volatile_region_create);
 
+/**
+ * nvdimm_flush - flush any posted write queues between the cpu and pmem media
+ * @nd_region: blk or interleaved pmem region
+ */
+void nvdimm_flush(struct nd_region *nd_region)
+{
+	/*
+	 * TODO: replace wmb_pmem() usage with flush hint writes where
+	 * available.
+	 */
+	wmb_pmem();
+}
+EXPORT_SYMBOL_GPL(nvdimm_flush);
+
+/**
+ * nvdimm_has_flush - determine write flushing requirements
+ * @nd_region: blk or interleaved pmem region
+ *
+ * Returns 1 if writes require flushing
+ * Returns 0 if writes do not require flushing
+ * Returns -ENXIO if flushing capability can not be determined
+ */
+int nvdimm_has_flush(struct nd_region *nd_region)
+{
+	/*
+	 * TODO: return 0 / 1 for NFIT regions depending on presence of
+	 * flush hint tables
+	 */
+	if (arch_has_wmb_pmem())
+		return 1;
+	return -ENXIO;
+}
+EXPORT_SYMBOL_GPL(nvdimm_has_flush);
+
 void __exit nd_region_devs_exit(void)
 {
 	ida_destroy(&region_ida);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 0c3c30cbbea5..90eb3119c3ce 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -156,4 +156,6 @@ struct nvdimm *nd_blk_region_to_dimm(struct nd_blk_region *ndbr);
 unsigned int nd_region_acquire_lane(struct nd_region *nd_region);
 void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane);
 u64 nd_fletcher64(void *addr, size_t len, bool le);
+void nvdimm_flush(struct nd_region *nd_region);
+int nvdimm_has_flush(struct nd_region *nd_region);
 #endif /* __LIBNVDIMM_H__ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
