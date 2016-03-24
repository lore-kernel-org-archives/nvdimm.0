Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 3507A1A1E1C
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 18:27:22 -0700 (PDT)
Subject: [PATCH 11/13] libnvdimm, pmem,
 pfn: make pmem_rw_bytes generic and refactor pfn setup
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Mar 2016 18:26:18 -0700
Message-ID: <20160324012618.21436.3392.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
References: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for providing an alternative (to block device) access
mechanism to persistent memory, convert pmem_rw_bytes() to
nsio_rw_bytes().  This allows ->rw_bytes() functionality without
requiring a 'struct pmem_device' to be instantiated.

In other words, when ->rw_bytes() is in use i/o is driven through
'struct nd_namespace_io', otherwise it is driven through 'struct
pmem_device' and the block layer.  This consolidates the disjoint calls
to devm_exit_badblocks() and devm_memunmap() into a common
devm_nsio_disable() and cleans up the init path to use a unified
pmem_attach_disk() implementation.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/blk.c              |    2 
 drivers/nvdimm/btt_devs.c         |    4 -
 drivers/nvdimm/claim.c            |   61 ++++++++++
 drivers/nvdimm/nd.h               |   39 +++++-
 drivers/nvdimm/pfn_devs.c         |    4 -
 drivers/nvdimm/pmem.c             |  230 +++++++++++++------------------------
 include/linux/nd.h                |    9 +
 tools/testing/nvdimm/Kbuild       |    1 
 tools/testing/nvdimm/test/iomap.c |   27 +++-
 9 files changed, 207 insertions(+), 170 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 4c14ecdc792b..495e06d9f7e7 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -324,7 +324,7 @@ static int nd_blk_probe(struct device *dev)
 	ndns->rw_bytes = nsblk_rw_bytes;
 	if (is_nd_btt(dev))
 		return nvdimm_namespace_attach_btt(ndns);
-	else if (nd_btt_probe(dev, ndns, nsblk) == 0) {
+	else if (nd_btt_probe(dev, ndns) == 0) {
 		/* we'll come back as btt-blk */
 		return -ENXIO;
 	} else
diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index 1886171af80e..816d0dae6398 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -273,8 +273,7 @@ static int __nd_btt_probe(struct nd_btt *nd_btt,
 	return 0;
 }
 
-int nd_btt_probe(struct device *dev, struct nd_namespace_common *ndns,
-		void *drvdata)
+int nd_btt_probe(struct device *dev, struct nd_namespace_common *ndns)
 {
 	int rc;
 	struct device *btt_dev;
@@ -289,7 +288,6 @@ int nd_btt_probe(struct device *dev, struct nd_namespace_common *ndns,
 	nvdimm_bus_unlock(&ndns->dev);
 	if (!btt_dev)
 		return -ENOMEM;
-	dev_set_drvdata(btt_dev, drvdata);
 	btt_sb = devm_kzalloc(dev, sizeof(*btt_sb), GFP_KERNEL);
 	rc = __nd_btt_probe(to_nd_btt(btt_dev), ndns, btt_sb);
 	dev_dbg(dev, "%s: btt: %s\n", __func__,
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index e8f03b0e95e4..85159050a7a7 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -12,6 +12,7 @@
  */
 #include <linux/device.h>
 #include <linux/sizes.h>
+#include <linux/pmem.h>
 #include "nd-core.h"
 #include "pfn.h"
 #include "btt.h"
@@ -199,3 +200,63 @@ u64 nd_sb_checksum(struct nd_gen_sb *nd_gen_sb)
 	return sum;
 }
 EXPORT_SYMBOL(nd_sb_checksum);
+
+static int nsio_rw_bytes(struct nd_namespace_common *ndns,
+		resource_size_t offset, void *buf, size_t size, int rw)
+{
+	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
+
+	if (unlikely(offset + size > nsio->size)) {
+		dev_WARN_ONCE(&ndns->dev, 1, "request out of range\n");
+		return -EFAULT;
+	}
+
+	if (rw == READ) {
+		unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
+
+		if (unlikely(is_bad_pmem(&nsio->bb, offset / 512, sz_align)))
+			return -EIO;
+		memcpy_from_pmem(buf, nsio->addr + offset, size);
+	} else {
+		memcpy_to_pmem(nsio->addr + offset, buf, size);
+		wmb_pmem();
+	}
+
+	return 0;
+}
+
+int devm_nsio_enable(struct device *dev, struct nd_namespace_io *nsio)
+{
+	struct resource *res = &nsio->res;
+	struct nd_namespace_common *ndns = &nsio->common;
+
+	nsio->size = resource_size(res);
+	if (!devm_request_mem_region(dev, res->start, resource_size(res),
+				dev_name(dev))) {
+		dev_warn(dev, "could not reserve region %pR\n", res);
+		return -EBUSY;
+	}
+
+	ndns->rw_bytes = nsio_rw_bytes;
+	if (devm_init_badblocks(dev, &nsio->bb))
+		return -ENOMEM;
+	nvdimm_badblocks_populate(to_nd_region(ndns->dev.parent), &nsio->bb,
+			&nsio->res);
+
+	nsio->addr = devm_memremap(dev, res->start, resource_size(res),
+			ARCH_MEMREMAP_PMEM);
+	if (IS_ERR(nsio->addr))
+		return PTR_ERR(nsio->addr);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_nsio_enable);
+
+void devm_nsio_disable(struct device *dev, struct nd_namespace_io *nsio)
+{
+	struct resource *res = &nsio->res;
+
+	devm_memunmap(dev, nsio->addr);
+	devm_exit_badblocks(dev, &nsio->bb);
+	devm_release_mem_region(dev, res->start, resource_size(res));
+}
+EXPORT_SYMBOL_GPL(devm_nsio_disable);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 0fb14890ba26..a42c823c0a67 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -13,6 +13,7 @@
 #ifndef __ND_H__
 #define __ND_H__
 #include <linux/libnvdimm.h>
+#include <linux/badblocks.h>
 #include <linux/blkdev.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
@@ -197,13 +198,12 @@ struct nd_gen_sb {
 
 u64 nd_sb_checksum(struct nd_gen_sb *sb);
 #if IS_ENABLED(CONFIG_BTT)
-int nd_btt_probe(struct device *dev, struct nd_namespace_common *ndns,
-		void *drvdata);
+int nd_btt_probe(struct device *dev, struct nd_namespace_common *ndns);
 bool is_nd_btt(struct device *dev);
 struct device *nd_btt_create(struct nd_region *nd_region);
 #else
 static inline int nd_btt_probe(struct device *dev,
-		struct nd_namespace_common *ndns, void *drvdata)
+		struct nd_namespace_common *ndns)
 {
 	return -ENODEV;
 }
@@ -221,14 +221,13 @@ static inline struct device *nd_btt_create(struct nd_region *nd_region)
 
 struct nd_pfn *to_nd_pfn(struct device *dev);
 #if IS_ENABLED(CONFIG_NVDIMM_PFN)
-int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns,
-		void *drvdata);
+int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns);
 bool is_nd_pfn(struct device *dev);
 struct device *nd_pfn_create(struct nd_region *nd_region);
 int nd_pfn_validate(struct nd_pfn *nd_pfn);
 #else
-static inline int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns,
-		void *drvdata)
+static inline int nd_pfn_probe(struct device *dev,
+		struct nd_namespace_common *ndns)
 {
 	return -ENODEV;
 }
@@ -272,6 +271,19 @@ const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
 		char *name);
 void nvdimm_badblocks_populate(struct nd_region *nd_region,
 		struct badblocks *bb, const struct resource *res);
+#if IS_ENABLED(CONFIG_ND_CLAIM)
+int devm_nsio_enable(struct device *dev, struct nd_namespace_io *nsio);
+void devm_nsio_disable(struct device *dev, struct nd_namespace_io *nsio);
+#else
+static inline int devm_nsio_enable(struct device *dev,
+		struct nd_namespace_io *nsio)
+{
+	return -ENXIO;
+}
+void devm_nsio_disable(struct device *dev, struct nd_namespace_io *nsio)
+{
+}
+#endif
 int nd_blk_region_init(struct nd_region *nd_region);
 void __nd_iostat_start(struct bio *bio, unsigned long *start);
 static inline bool nd_iostat_start(struct bio *bio, unsigned long *start)
@@ -285,6 +297,19 @@ static inline bool nd_iostat_start(struct bio *bio, unsigned long *start)
 	return true;
 }
 void nd_iostat_end(struct bio *bio, unsigned long start);
+static inline bool is_bad_pmem(struct badblocks *bb, sector_t sector,
+		unsigned int len)
+{
+	if (bb->count) {
+		sector_t first_bad;
+		int num_bad;
+
+		return !!badblocks_check(bb, sector, len / 512, &first_bad,
+				&num_bad);
+	}
+
+	return false;
+}
 resource_size_t nd_namespace_blk_validate(struct nd_namespace_blk *nsblk);
 const u8 *nd_dev_to_uuid(struct device *dev);
 bool pmem_should_map_pages(struct device *dev);
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 63e2df3e052c..f8fd379501bf 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -410,8 +410,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn)
 }
 EXPORT_SYMBOL(nd_pfn_validate);
 
-int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns,
-		void *drvdata)
+int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns)
 {
 	int rc;
 	struct nd_pfn *nd_pfn;
@@ -427,7 +426,6 @@ int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns,
 	nvdimm_bus_unlock(&ndns->dev);
 	if (!pfn_dev)
 		return -ENOMEM;
-	dev_set_drvdata(pfn_dev, drvdata);
 	pfn_sb = devm_kzalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
 	nd_pfn = to_nd_pfn(pfn_dev);
 	nd_pfn->pfn_sb = pfn_sb;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index c9ae1673bb17..03bfb3422da1 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -49,19 +49,6 @@ struct pmem_device {
 	struct badblocks	bb;
 };
 
-static bool is_bad_pmem(struct badblocks *bb, sector_t sector, unsigned int len)
-{
-	if (bb->count) {
-		sector_t first_bad;
-		int num_bad;
-
-		return !!badblocks_check(bb, sector, len / 512, &first_bad,
-				&num_bad);
-	}
-
-	return false;
-}
-
 static void pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 		unsigned int len)
 {
@@ -195,16 +182,40 @@ void pmem_release_disk(void *disk)
 	put_disk(disk);
 }
 
-static struct pmem_device *pmem_alloc(struct device *dev,
-		struct resource *res, int id)
+static struct vmem_altmap *nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
+		struct resource *res, struct vmem_altmap *altmap);
+
+static int pmem_attach_disk(struct device *dev,
+		struct nd_namespace_common *ndns)
 {
+	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
+	struct vmem_altmap __altmap, *altmap = NULL;
+	struct resource *res = &nsio->res;
+	struct nd_pfn *nd_pfn = NULL;
+	int nid = dev_to_node(dev);
+	struct nd_pfn_sb *pfn_sb;
 	struct pmem_device *pmem;
+	struct resource pfn_res;
 	struct request_queue *q;
+	struct gendisk *disk;
+	void *addr;
+
+	/* while nsio_rw_bytes is active, parse a pfn info block if present */
+	if (is_nd_pfn(dev)) {
+		nd_pfn = to_nd_pfn(dev);
+		altmap = nvdimm_setup_pfn(nd_pfn, &pfn_res, &__altmap);
+		if (IS_ERR(altmap))
+			return PTR_ERR(altmap);
+	}
+
+	/* we're attaching a block device, disable raw namespace access */
+	devm_nsio_disable(dev, nsio);
 
 	pmem = devm_kzalloc(dev, sizeof(*pmem), GFP_KERNEL);
 	if (!pmem)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
+	dev_set_drvdata(dev, pmem);
 	pmem->phys_addr = res->start;
 	pmem->size = resource_size(res);
 	if (!arch_has_wmb_pmem())
@@ -213,22 +224,31 @@ static struct pmem_device *pmem_alloc(struct device *dev,
 	if (!devm_request_mem_region(dev, res->start, resource_size(res),
 				dev_name(dev))) {
 		dev_warn(dev, "could not reserve region %pR\n", res);
-		return ERR_PTR(-EBUSY);
+		return -EBUSY;
 	}
 
 	q = blk_alloc_queue_node(GFP_KERNEL, dev_to_node(dev));
 	if (!q)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
+	pmem->pmem_queue = q;
 
 	pmem->pfn_flags = PFN_DEV;
-	if (pmem_should_map_pages(dev)) {
-		pmem->virt_addr = (void __pmem *) devm_memremap_pages(dev, res,
+	if (is_nd_pfn(dev)) {
+		addr = devm_memremap_pages(dev, &pfn_res, &q->q_usage_counter,
+				altmap);
+		pfn_sb = nd_pfn->pfn_sb;
+		pmem->data_offset = le64_to_cpu(pfn_sb->dataoff);
+		pmem->pfn_pad = pfn_res.start - res->start + res->end
+			- pfn_res.end;
+		pmem->pfn_flags |= PFN_MAP;
+		res = &pfn_res; /* for badblocks populate */
+	} else if (pmem_should_map_pages(dev)) {
+		addr = devm_memremap_pages(dev, &nsio->res,
 				&q->q_usage_counter, NULL);
 		pmem->pfn_flags |= PFN_MAP;
 	} else
-		pmem->virt_addr = (void __pmem *) devm_memremap(dev,
-				pmem->phys_addr, pmem->size,
-				ARCH_MEMREMAP_PMEM);
+		addr = devm_memremap(dev, pmem->phys_addr,
+				pmem->size, ARCH_MEMREMAP_PMEM);
 
 	/*
 	 * At release time the queue must be dead before
@@ -236,23 +256,12 @@ static struct pmem_device *pmem_alloc(struct device *dev,
 	 */
 	if (devm_add_action(dev, pmem_release_queue, q)) {
 		blk_cleanup_queue(q);
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	}
 
-	if (IS_ERR(pmem->virt_addr))
-		return (void __force *) pmem->virt_addr;
-
-	pmem->pmem_queue = q;
-	return pmem;
-}
-
-static int pmem_attach_disk(struct device *dev,
-		struct nd_namespace_common *ndns, struct pmem_device *pmem)
-{
-	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
-	int nid = dev_to_node(dev);
-	struct resource bb_res;
-	struct gendisk *disk;
+	if (IS_ERR(addr))
+		return PTR_ERR(addr);
+	pmem->virt_addr = (void __pmem *) addr;
 
 	blk_queue_make_request(pmem->pmem_queue, pmem_make_request);
 	blk_queue_physical_block_size(pmem->pmem_queue, PAGE_SIZE);
@@ -277,20 +286,9 @@ static int pmem_attach_disk(struct device *dev,
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
 			/ 512);
 	pmem->pmem_disk = disk;
-	devm_exit_badblocks(dev, &pmem->bb);
 	if (devm_init_badblocks(dev, &pmem->bb))
 		return -ENOMEM;
-	bb_res.start = nsio->res.start + pmem->data_offset;
-	bb_res.end = nsio->res.end;
-	if (is_nd_pfn(dev)) {
-		struct nd_pfn *nd_pfn = to_nd_pfn(dev);
-		struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
-
-		bb_res.start += __le32_to_cpu(pfn_sb->start_pad);
-		bb_res.end -= __le32_to_cpu(pfn_sb->end_trunc);
-	}
-	nvdimm_badblocks_populate(to_nd_region(dev->parent), &pmem->bb,
-			&bb_res);
+	nvdimm_badblocks_populate(to_nd_region(dev->parent), &pmem->bb, res);
 	disk->bb = &pmem->bb;
 	add_disk(disk);
 	revalidate_disk(disk);
@@ -298,30 +296,6 @@ static int pmem_attach_disk(struct device *dev,
 	return 0;
 }
 
-static int pmem_rw_bytes(struct nd_namespace_common *ndns,
-		resource_size_t offset, void *buf, size_t size, int rw)
-{
-	struct pmem_device *pmem = dev_get_drvdata(ndns->claim);
-
-	if (unlikely(offset + size > pmem->size)) {
-		dev_WARN_ONCE(&ndns->dev, 1, "request out of range\n");
-		return -EFAULT;
-	}
-
-	if (rw == READ) {
-		unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
-
-		if (unlikely(is_bad_pmem(&pmem->bb, offset / 512, sz_align)))
-			return -EIO;
-		memcpy_from_pmem(buf, pmem->virt_addr + offset, size);
-	} else {
-		memcpy_to_pmem(pmem->virt_addr + offset, buf, size);
-		wmb_pmem();
-	}
-
-	return 0;
-}
-
 static int nd_pfn_init(struct nd_pfn *nd_pfn)
 {
 	struct pmem_device *pmem = dev_get_drvdata(&nd_pfn->dev);
@@ -442,17 +416,14 @@ static unsigned long init_altmap_reserve(resource_size_t base)
 	return reserve;
 }
 
-static int __nvdimm_namespace_attach_pfn(struct nd_pfn *nd_pfn)
+static struct vmem_altmap *__nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
+		struct resource *res, struct vmem_altmap *altmap)
 {
-	struct resource res;
-	struct request_queue *q;
-	struct pmem_device *pmem;
-	struct vmem_altmap *altmap;
-	struct device *dev = &nd_pfn->dev;
 	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
-	struct nd_namespace_common *ndns = nd_pfn->ndns;
+	u64 offset = le64_to_cpu(pfn_sb->dataoff);
 	u32 start_pad = __le32_to_cpu(pfn_sb->start_pad);
 	u32 end_trunc = __le32_to_cpu(pfn_sb->end_trunc);
+	struct nd_namespace_common *ndns = nd_pfn->ndns;
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
 	resource_size_t base = nsio->res.start + start_pad;
 	struct vmem_altmap __altmap = {
@@ -460,112 +431,75 @@ static int __nvdimm_namespace_attach_pfn(struct nd_pfn *nd_pfn)
 		.reserve = init_altmap_reserve(base),
 	};
 
-	pmem = dev_get_drvdata(dev);
-	pmem->data_offset = le64_to_cpu(pfn_sb->dataoff);
-	pmem->pfn_pad = start_pad + end_trunc;
+	memcpy(res, &nsio->res, sizeof(*res));
+	res->start += start_pad;
+	res->end -= end_trunc;
+
 	nd_pfn->mode = le32_to_cpu(nd_pfn->pfn_sb->mode);
 	if (nd_pfn->mode == PFN_MODE_RAM) {
-		if (pmem->data_offset < SZ_8K)
-			return -EINVAL;
+		if (offset < SZ_8K)
+			return ERR_PTR(-EINVAL);
 		nd_pfn->npfns = le64_to_cpu(pfn_sb->npfns);
 		altmap = NULL;
 	} else if (nd_pfn->mode == PFN_MODE_PMEM) {
-		nd_pfn->npfns = (pmem->size - pmem->pfn_pad - pmem->data_offset)
-			/ PAGE_SIZE;
+		nd_pfn->npfns = (resource_size(res) - offset) / PAGE_SIZE;
 		if (le64_to_cpu(nd_pfn->pfn_sb->npfns) > nd_pfn->npfns)
 			dev_info(&nd_pfn->dev,
 					"number of pfns truncated from %lld to %ld\n",
 					le64_to_cpu(nd_pfn->pfn_sb->npfns),
 					nd_pfn->npfns);
-		altmap = & __altmap;
-		altmap->free = PHYS_PFN(pmem->data_offset - SZ_8K);
+		memcpy(altmap, &__altmap, sizeof(*altmap));
+		altmap->free = PHYS_PFN(offset - SZ_8K);
 		altmap->alloc = 0;
 	} else
-		return -ENXIO;
-
-	/* establish pfn range for lookup, and switch to direct map */
-	q = pmem->pmem_queue;
-	memcpy(&res, &nsio->res, sizeof(res));
-	res.start += start_pad;
-	res.end -= end_trunc;
-	devm_remove_action(dev, pmem_release_queue, q);
-	devm_memunmap(dev, (void __force *) pmem->virt_addr);
-	pmem->virt_addr = (void __pmem *) devm_memremap_pages(dev, &res,
-			&q->q_usage_counter, altmap);
-	pmem->pfn_flags |= PFN_MAP;
-
-	/*
-	 * At release time the queue must be dead before
-	 * devm_memremap_pages is unwound
-	 */
-	if (devm_add_action(dev, pmem_release_queue, q)) {
-		blk_cleanup_queue(q);
-		return -ENOMEM;
-	}
-	if (IS_ERR(pmem->virt_addr))
-		return PTR_ERR(pmem->virt_addr);
+		return ERR_PTR(-ENXIO);
 
-	/* attach pmem disk in "pfn-mode" */
-	return pmem_attach_disk(dev, ndns, pmem);
+	return altmap;
 }
 
-static int nvdimm_namespace_attach_pfn(struct nd_namespace_common *ndns)
+/*
+ * Determine the effective resource range and vmem_altmap from an nd_pfn
+ * instance.
+ */
+static struct vmem_altmap *nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
+		struct resource *res, struct vmem_altmap *altmap)
 {
-	struct nd_pfn *nd_pfn = to_nd_pfn(ndns->claim);
 	int rc;
 
 	if (!nd_pfn->uuid || !nd_pfn->ndns)
-		return -ENODEV;
+		return ERR_PTR(-ENODEV);
 
 	rc = nd_pfn_init(nd_pfn);
 	if (rc)
-		return rc;
+		return ERR_PTR(rc);
+
 	/* we need a valid pfn_sb before we can init a vmem_altmap */
-	return __nvdimm_namespace_attach_pfn(nd_pfn);
+	return __nvdimm_setup_pfn(nd_pfn, res, altmap);
 }
 
 static int nd_pmem_probe(struct device *dev)
 {
-	struct nd_region *nd_region = to_nd_region(dev->parent);
 	struct nd_namespace_common *ndns;
-	struct nd_namespace_io *nsio;
-	struct pmem_device *pmem;
 
 	ndns = nvdimm_namespace_common_probe(dev);
 	if (IS_ERR(ndns))
 		return PTR_ERR(ndns);
 
-	nsio = to_nd_namespace_io(&ndns->dev);
-	pmem = pmem_alloc(dev, &nsio->res, nd_region->id);
-	if (IS_ERR(pmem))
-		return PTR_ERR(pmem);
-
-	dev_set_drvdata(dev, pmem);
-	ndns->rw_bytes = pmem_rw_bytes;
-	if (devm_init_badblocks(dev, &pmem->bb))
-		return -ENOMEM;
-	nvdimm_badblocks_populate(nd_region, &pmem->bb, &nsio->res);
+	if (devm_nsio_enable(dev, to_nd_namespace_io(&ndns->dev)))
+		return -ENXIO;
 
-	if (is_nd_btt(dev)) {
-		/* btt allocates its own request_queue */
-		devm_remove_action(dev, pmem_release_queue, pmem->pmem_queue);
-		blk_cleanup_queue(pmem->pmem_queue);
+	if (is_nd_btt(dev))
 		return nvdimm_namespace_attach_btt(ndns);
-	}
 
 	if (is_nd_pfn(dev))
-		return nvdimm_namespace_attach_pfn(ndns);
-
-	if (nd_btt_probe(dev, ndns, pmem) == 0
-			|| nd_pfn_probe(dev, ndns, pmem) == 0) {
-		/*
-		 * We'll come back as either btt-pmem, or pfn-pmem, so
-		 * drop the queue allocation for now.
-		 */
+		return pmem_attach_disk(dev, ndns);
+
+	/* if we find a valid info-block we'll come back as that personality */
+	if (nd_btt_probe(dev, ndns) == 0 || nd_pfn_probe(dev, ndns) == 0)
 		return -ENXIO;
-	}
 
-	return pmem_attach_disk(dev, ndns, pmem);
+	/* ...otherwise we're just a raw pmem device */
+	return pmem_attach_disk(dev, ndns);
 }
 
 static int nd_pmem_remove(struct device *dev)
diff --git a/include/linux/nd.h b/include/linux/nd.h
index 5ea4aec7fd63..aee2761d294c 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -15,6 +15,7 @@
 #include <linux/fs.h>
 #include <linux/ndctl.h>
 #include <linux/device.h>
+#include <linux/badblocks.h>
 
 enum nvdimm_event {
 	NVDIMM_REVALIDATE_POISON,
@@ -55,13 +56,19 @@ static inline struct nd_namespace_common *to_ndns(struct device *dev)
 }
 
 /**
- * struct nd_namespace_io - infrastructure for loading an nd_pmem instance
+ * struct nd_namespace_io - device representation of a persistent memory range
  * @dev: namespace device created by the nd region driver
  * @res: struct resource conversion of a NFIT SPA table
+ * @size: cached resource_size(@res) for fast path size checks
+ * @addr: virtual address to access the namespace range
+ * @bb: badblocks list for the namespace range
  */
 struct nd_namespace_io {
 	struct nd_namespace_common common;
 	struct resource res;
+	resource_size_t size;
+	void __pmem *addr;
+	struct badblocks bb;
 };
 
 /**
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index a34bfd0c8928..d5bc8c080b44 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -7,6 +7,7 @@ ldflags-y += --wrap=ioremap_nocache
 ldflags-y += --wrap=iounmap
 ldflags-y += --wrap=memunmap
 ldflags-y += --wrap=__devm_request_region
+ldflags-y += --wrap=__devm_release_region
 ldflags-y += --wrap=__request_region
 ldflags-y += --wrap=__release_region
 ldflags-y += --wrap=devm_memremap_pages
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index 0c1a7e65bb81..c842095f2801 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -239,13 +239,11 @@ struct resource *__wrap___devm_request_region(struct device *dev,
 }
 EXPORT_SYMBOL(__wrap___devm_request_region);
 
-void __wrap___release_region(struct resource *parent, resource_size_t start,
-				resource_size_t n)
+static bool nfit_test_release_region(struct resource *parent,
+		resource_size_t start, resource_size_t n)
 {
-	struct nfit_test_resource *nfit_res;
-
 	if (parent == &iomem_resource) {
-		nfit_res = get_nfit_res(start);
+		struct nfit_test_resource *nfit_res = get_nfit_res(start);
 		if (nfit_res) {
 			struct resource *res = nfit_res->res + 1;
 
@@ -254,11 +252,26 @@ void __wrap___release_region(struct resource *parent, resource_size_t start,
 						__func__, start, n, res);
 			else
 				memset(res, 0, sizeof(*res));
-			return;
+			return true;
 		}
 	}
-	__release_region(parent, start, n);
+	return false;
+}
+
+void __wrap___release_region(struct resource *parent, resource_size_t start,
+		resource_size_t n)
+{
+	if (!nfit_test_release_region(parent, start, n))
+		__release_region(parent, start, n);
 }
 EXPORT_SYMBOL(__wrap___release_region);
 
+void __wrap___devm_release_region(struct device *dev, struct resource *parent,
+		resource_size_t start, resource_size_t n)
+{
+	if (!nfit_test_release_region(parent, start, n))
+		__devm_release_region(dev, parent, start, n);
+}
+EXPORT_SYMBOL(__wrap___devm_release_region);
+
 MODULE_LICENSE("GPL v2");

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
