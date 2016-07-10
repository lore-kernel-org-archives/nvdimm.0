Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 11D0C1A1E3E
 for <linux-nvdimm@lists.01.org>; Sat,  9 Jul 2016 20:28:06 -0700 (PDT)
Subject: [PATCH v2 08/17] libnvdimm: introduce nvdimm_flush() and
 nvdimm_has_flush()
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Jul 2016 20:25:12 -0700
Message-ID: <146812111205.32932.3785207412939078453.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, hch@lst.de, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

nvdimm_flush() is a replacement for the x86 'pcommit' instruction.  It is
an optional write flushing mechanism that an nvdimm bus can provide for
the pmem driver to consume.  In the case of the NFIT nvdimm-bus-provider
nvdimm_flush() is implemented as a series of flush-hint-address [1]
writes to each dimm in the interleave set (region) that backs the
namespace.

The nvdimm_has_flush() routine relies on platform firmware to describe
the flushing capabilities of a platform.  It uses the heuristic of
whether an nvdimm bus provider provides flush address data to return a
ternary result:

      1: flush addresses defined
      0: dimm topology described without flush addresses (assume ADR)
 -errno: no topology information, unable to determine flush mechanism

The pmem driver is expected to take the following actions on this ternary
result:

      1: nvdimm_flush() in response to REQ_FUA / REQ_FLUSH and shutdown
      0: do not set, WC or FUA on the queue, take no further action
 -errno: warn and then operate as if nvdimm_has_flush() returned '0'

The caveat of this heuristic is that it can not distinguish the "dimm
does not have flush address" case from the "platform firmware is broken
and failed to describe a flush address".  Given we are already
explicitly trusting the NFIT there's not much more we can do beyond
blacklisting broken firmwares if they are ever encountered.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c          |   33 ++-----------------------
 drivers/acpi/nfit.h          |    1 -
 drivers/nvdimm/pmem.c        |   27 ++++++++++++++++-----
 drivers/nvdimm/region_devs.c |   55 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h    |    2 ++
 5 files changed, 81 insertions(+), 37 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 6796f780870a..0497175ee6cb 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1393,24 +1393,6 @@ static u64 to_interleave_offset(u64 offset, struct nfit_blk_mmio *mmio)
 	return mmio->base_offset + line_offset + table_offset + sub_line_offset;
 }
 
-static void wmb_blk(struct nfit_blk *nfit_blk)
-{
-
-	if (nfit_blk->nvdimm_flush) {
-		/*
-		 * The first wmb() is needed to 'sfence' all previous writes
-		 * such that they are architecturally visible for the platform
-		 * buffer flush.  Note that we've already arranged for pmem
-		 * writes to avoid the cache via arch_memcpy_to_pmem().  The
-		 * final wmb() ensures ordering for the NVDIMM flush write.
-		 */
-		wmb();
-		writeq(1, nfit_blk->nvdimm_flush);
-		wmb();
-	} else
-		wmb_pmem();
-}
-
 static u32 read_blk_stat(struct nfit_blk *nfit_blk, unsigned int bw)
 {
 	struct nfit_blk_mmio *mmio = &nfit_blk->mmio[DCR];
@@ -1445,7 +1427,7 @@ static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
 		offset = to_interleave_offset(offset, mmio);
 
 	writeq(cmd, mmio->addr.base + offset);
-	wmb_blk(nfit_blk);
+	nvdimm_flush(nfit_blk->nd_region);
 
 	if (nfit_blk->dimm_flags & NFIT_BLK_DCR_LATCH)
 		readq(mmio->addr.base + offset);
@@ -1496,7 +1478,7 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
 	}
 
 	if (rw)
-		wmb_blk(nfit_blk);
+		nvdimm_flush(nfit_blk->nd_region);
 
 	rc = read_blk_stat(nfit_blk, lane) ? -EIO : 0;
 	return rc;
@@ -1570,7 +1552,6 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 {
 	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
 	struct nd_blk_region *ndbr = to_nd_blk_region(dev);
-	struct nfit_flush *nfit_flush;
 	struct nfit_blk_mmio *mmio;
 	struct nfit_blk *nfit_blk;
 	struct nfit_mem *nfit_mem;
@@ -1645,15 +1626,7 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 		return rc;
 	}
 
-	nfit_flush = nfit_mem->nfit_flush;
-	if (nfit_flush && nfit_flush->flush->hint_count != 0) {
-		nfit_blk->nvdimm_flush = devm_nvdimm_ioremap(dev,
-				nfit_flush->flush->hint_address[0], 8);
-		if (!nfit_blk->nvdimm_flush)
-			return -ENOMEM;
-	}
-
-	if (!arch_has_wmb_pmem() && !nfit_blk->nvdimm_flush)
+	if (nvdimm_has_flush(nfit_blk->nd_region) < 0)
 		dev_warn(dev, "unable to guarantee persistence of writes\n");
 
 	if (mmio->line_size == 0)
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 9282eb324dcc..9fda77cf81da 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -183,7 +183,6 @@ struct nfit_blk {
 	u64 bdw_offset; /* post interleave offset */
 	u64 stat_offset;
 	u64 cmd_offset;
-	void __iomem *nvdimm_flush;
 	u32 dimm_flags;
 };
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index b6fcb97a601c..e303655f243e 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -33,10 +33,24 @@
 #include "pfn.h"
 #include "nd.h"
 
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
 
@@ -122,7 +136,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 		nd_iostat_end(bio, start);
 
 	if (bio_data_dir(bio))
-		wmb_pmem();
+		nvdimm_flush(to_region(pmem));
 
 	bio_endio(bio);
 	return BLK_QC_T_NONE;
@@ -136,7 +150,7 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 
 	rc = pmem_do_bvec(pmem, page, PAGE_SIZE, 0, rw, sector);
 	if (rw & WRITE)
-		wmb_pmem();
+		nvdimm_flush(to_region(pmem));
 
 	/*
 	 * The ->rw_page interface is subtle and tricky.  The core
@@ -193,6 +207,7 @@ static int pmem_attach_disk(struct device *dev,
 		struct nd_namespace_common *ndns)
 {
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
+	struct nd_region *nd_region = to_nd_region(dev->parent);
 	struct vmem_altmap __altmap, *altmap = NULL;
 	struct resource *res = &nsio->res;
 	struct nd_pfn *nd_pfn = NULL;
@@ -222,7 +237,7 @@ static int pmem_attach_disk(struct device *dev,
 	dev_set_drvdata(dev, pmem);
 	pmem->phys_addr = res->start;
 	pmem->size = resource_size(res);
-	if (!arch_has_wmb_pmem())
+	if (nvdimm_has_flush(nd_region) < 0)
 		dev_warn(dev, "unable to guarantee persistence of writes\n");
 
 	if (!devm_request_mem_region(dev, res->start, resource_size(res),
@@ -284,7 +299,7 @@ static int pmem_attach_disk(struct device *dev,
 			/ 512);
 	if (devm_init_badblocks(dev, &pmem->bb))
 		return -ENOMEM;
-	nvdimm_badblocks_populate(to_nd_region(dev->parent), &pmem->bb, res);
+	nvdimm_badblocks_populate(nd_region, &pmem->bb, res);
 	disk->bb = &pmem->bb;
 	add_disk(disk);
 
@@ -331,8 +346,8 @@ static int nd_pmem_remove(struct device *dev)
 
 static void nd_pmem_notify(struct device *dev, enum nvdimm_event event)
 {
-	struct nd_region *nd_region = to_nd_region(dev->parent);
 	struct pmem_device *pmem = dev_get_drvdata(dev);
+	struct nd_region *nd_region = to_region(pmem);
 	resource_size_t offset = 0, end_trunc = 0;
 	struct nd_namespace_common *ndns;
 	struct nd_namespace_io *nsio;
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 67022f74febc..46b6e2f7d5f0 100644
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
@@ -864,6 +865,60 @@ struct nd_region *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
 }
 EXPORT_SYMBOL_GPL(nvdimm_volatile_region_create);
 
+/**
+ * nvdimm_flush - flush any posted write queues between the cpu and pmem media
+ * @nd_region: blk or interleaved pmem region
+ */
+void nvdimm_flush(struct nd_region *nd_region)
+{
+	struct nd_region_data *ndrd = dev_get_drvdata(&nd_region->dev);
+	int i;
+
+	/*
+	 * The first wmb() is needed to 'sfence' all previous writes
+	 * such that they are architecturally visible for the platform
+	 * buffer flush.  Note that we've already arranged for pmem
+	 * writes to avoid the cache via arch_memcpy_to_pmem().  The
+	 * final wmb() ensures ordering for the NVDIMM flush write.
+	 */
+	wmb();
+	for (i = 0; i < nd_region->ndr_mappings; i++)
+		if (ndrd->flush_wpq[i][0])
+			writeq(1, ndrd->flush_wpq[i][0]);
+	wmb();
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
+	struct nd_region_data *ndrd = dev_get_drvdata(&nd_region->dev);
+	int i;
+
+	/* no nvdimm == flushing capability unknown */
+	if (nd_region->ndr_mappings == 0)
+		return -ENXIO;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++)
+		/* flush hints present, flushing required */
+		if (ndrd->flush_wpq[i][0])
+			return 1;
+
+	/*
+	 * The platform defines dimm devices without hints, assume
+	 * platform persistence mechanism like ADR
+	 */
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvdimm_has_flush);
+
 void __exit nd_region_devs_exit(void)
 {
 	ida_destroy(&region_ida);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 815b9b430ead..d37fda6dd64c 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -166,4 +166,6 @@ struct nvdimm *nd_blk_region_to_dimm(struct nd_blk_region *ndbr);
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
