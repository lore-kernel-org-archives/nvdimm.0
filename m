Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 158D4202E5318
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 13:37:50 -0800 (PST)
Subject: [PATCH 6/7] libnvdimm/pfn: Introduce 'struct pfn_map_info'
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Feb 2019 13:25:11 -0800
Message-ID: <155000671184.348031.10730652743216753279.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The 'start_pad' accounting bug resulted from the pmem driver inferring
properties of the established pagemap to calculate pmem->phys_addr and
pmem->size, and that nd_pfn->data_offset was identical to
pmem->data_offset. The assumptions in the current implementation are
only true when 'start_pad' is zero.

The confusion resulted in the wrong offset being applied for
sector-to-physical-page translations. In advance of introducing a
corrected implementation make the mapping parameters and translation
explicit via a new 'struct pfn_map_info' to carry the mapping and
device-offset to physical address translation parameters.

No functional change intended, this cleanup preserves the existing bug.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/pmem.c              |    9 ++-
 drivers/nvdimm/nd.h             |   13 ++++-
 drivers/nvdimm/pfn_devs.c       |   21 ++++++-
 drivers/nvdimm/pmem.c           |  111 ++++++++++++++++++---------------------
 drivers/nvdimm/pmem.h           |   12 +---
 tools/testing/nvdimm/pmem-dax.c |   15 +++--
 6 files changed, 96 insertions(+), 85 deletions(-)

diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index 2c1f459c0c63..80359df4f662 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -64,6 +64,7 @@ static int dax_pmem_probe(struct device *dev)
 	struct nd_pfn_sb *pfn_sb;
 	struct dev_dax *dev_dax;
 	struct dax_pmem *dax_pmem;
+	struct pfn_map_info mi;
 	struct nd_namespace_io *nsio;
 	struct dax_region *dax_region;
 	struct nd_namespace_common *ndns;
@@ -83,7 +84,7 @@ static int dax_pmem_probe(struct device *dev)
 	rc = devm_nsio_enable(dev, nsio);
 	if (rc)
 		return rc;
-	rc = nvdimm_setup_pfn(nd_pfn, &dax_pmem->pgmap);
+	rc = nvdimm_setup_pfn(nd_pfn, &dax_pmem->pgmap, &mi);
 	if (rc)
 		return rc;
 	devm_nsio_disable(dev, nsio);
@@ -117,8 +118,10 @@ static int dax_pmem_probe(struct device *dev)
 		return PTR_ERR(addr);
 
 	/* adjust the dax_region resource to the start of data */
-	memcpy(&res, &dax_pmem->pgmap.res, sizeof(res));
-	res.start += le64_to_cpu(pfn_sb->dataoff);
+	res = (struct resource) {
+		.start = mi.map_base + mi.map_pad + mi.map_offset,
+		.end = mi.map_base + mi.map_pad + mi.map_size - 1,
+	};
 
 	rc = sscanf(dev_name(&ndns->dev), "namespace%d.%d", &region_id, &id);
 	if (rc != 2)
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 379bf4305e61..4339d338928b 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -377,13 +377,22 @@ const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
 unsigned int pmem_sector_size(struct nd_namespace_common *ndns);
 void nvdimm_badblocks_populate(struct nd_region *nd_region,
 		struct badblocks *bb, const struct resource *res);
+struct pfn_map_info {
+	resource_size_t map_base;
+	unsigned long map_offset;
+	resource_size_t map_size;
+	unsigned long map_pad;
+	u64 pfn_flags;
+	void *map;
+};
 #if IS_ENABLED(CONFIG_ND_CLAIM)
-int nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap);
+int nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap,
+		struct pfn_map_info *mi);
 int devm_nsio_enable(struct device *dev, struct nd_namespace_io *nsio);
 void devm_nsio_disable(struct device *dev, struct nd_namespace_io *nsio);
 #else
 static inline int nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
-				   struct dev_pagemap *pgmap)
+		struct dev_pagemap *pgmap, struct pfn_map_info *mi)
 {
 	return -ENXIO;
 }
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 110699f4c3e4..1c2a0e707da3 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -611,7 +611,8 @@ static unsigned long init_altmap_reserve(resource_size_t base)
 	return reserve;
 }
 
-static int __nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap)
+static int __nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap,
+		struct pfn_map_info *mi)
 {
 	struct resource *res = &pgmap->res;
 	struct vmem_altmap *altmap = &pgmap->altmap;
@@ -632,6 +633,19 @@ static int __nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap)
 	res->start += start_pad;
 	res->end -= end_trunc;
 
+	*mi = (struct pfn_map_info) {
+		/*
+		 * TODO fix implementation to properly account for
+		 * 'start_pad' in map_base, and map_offset. As is, the
+		 * fact that __va(map_base) != __pa(map) leads
+		 * mistranslations in pmem_direct_access().
+		 */
+		.map_base = nsio->res.start,
+		.map_pad = start_pad,
+		.map_offset = offset,
+		.map_size = resource_size(res),
+	};
+
 	if (nd_pfn->mode == PFN_MODE_RAM) {
 		if (offset < reserve)
 			return -EINVAL;
@@ -789,7 +803,8 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
  * Determine the effective resource range and vmem_altmap from an nd_pfn
  * instance.
  */
-int nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap)
+int nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap,
+		struct pfn_map_info *mi)
 {
 	int rc;
 
@@ -801,6 +816,6 @@ int nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap)
 		return rc;
 
 	/* we need a valid pfn_sb before we can init a dev_pagemap */
-	return __nvdimm_setup_pfn(nd_pfn, pgmap);
+	return __nvdimm_setup_pfn(nd_pfn, pgmap, mi);
 }
 EXPORT_SYMBOL_GPL(nvdimm_setup_pfn);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index bc2f700feef8..46b823f3b94d 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -34,9 +34,7 @@
 #include <linux/nd.h>
 #include <linux/backing-dev.h>
 #include "pmem.h"
-#include "pfn.h"
 #include "nd.h"
-#include "nd-core.h"
 
 static struct device *to_dev(struct pmem_device *pmem)
 {
@@ -58,7 +56,7 @@ static void hwpoison_clear(struct pmem_device *pmem,
 	unsigned long pfn_start, pfn_end, pfn;
 
 	/* only pmem in the linear map supports HWPoison */
-	if (is_vmalloc_addr(pmem->virt_addr))
+	if (is_vmalloc_addr(pmem->mi.map))
 		return;
 
 	pfn_start = PHYS_PFN(phys);
@@ -80,17 +78,18 @@ static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
 		phys_addr_t offset, unsigned int len)
 {
 	struct device *dev = to_dev(pmem);
+	struct pfn_map_info *mi = &pmem->mi;
 	sector_t sector;
 	long cleared;
 	blk_status_t rc = BLK_STS_OK;
 
-	sector = (offset - pmem->data_offset) / 512;
+	sector = (offset - mi->map_offset) / 512;
 
-	cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);
+	cleared = nvdimm_clear_poison(dev, mi->map_base + offset, len);
 	if (cleared < len)
 		rc = BLK_STS_IOERR;
 	if (cleared > 0 && cleared / 512) {
-		hwpoison_clear(pmem, pmem->phys_addr + offset, cleared);
+		hwpoison_clear(pmem, mi->map_base + offset, cleared);
 		cleared /= 512;
 		dev_dbg(dev, "%#llx clear %ld sector%s\n",
 				(unsigned long long) sector, cleared,
@@ -100,7 +99,7 @@ static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
 			sysfs_notify_dirent(pmem->bb_state);
 	}
 
-	arch_invalidate_pmem(pmem->virt_addr + offset, len);
+	arch_invalidate_pmem(mi->map + offset, len);
 
 	return rc;
 }
@@ -151,8 +150,9 @@ static blk_status_t pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 {
 	blk_status_t rc = BLK_STS_OK;
 	bool bad_pmem = false;
-	phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
-	void *pmem_addr = pmem->virt_addr + pmem_off;
+	struct pfn_map_info *mi = &pmem->mi;
+	phys_addr_t pmem_off = sector * 512 + mi->map_offset;
+	void *pmem_addr = mi->map + pmem_off;
 
 	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
 		bad_pmem = true;
@@ -247,16 +247,17 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
 {
-	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
+	struct pfn_map_info *mi = &pmem->mi;
+	resource_size_t offset = PFN_PHYS(pgoff) + mi->map_offset;
 
 	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
 					PFN_PHYS(nr_pages))))
 		return -EIO;
 
 	if (kaddr)
-		*kaddr = pmem->virt_addr + offset;
+		*kaddr = mi->map + offset;
 	if (pfn)
-		*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
+		*pfn = phys_to_pfn_t(mi->map_base + offset, mi->pfn_flags);
 
 	/*
 	 * If badblocks are present, limit known good range to the
@@ -264,7 +265,7 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 	 */
 	if (unlikely(pmem->bb.count))
 		return nr_pages;
-	return PHYS_PFN(pmem->size - pmem->pfn_pad - offset);
+	return PHYS_PFN(mi->map_size - offset);
 }
 
 static const struct block_device_operations pmem_fops = {
@@ -354,45 +355,49 @@ static int pmem_attach_disk(struct device *dev,
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
 	struct nd_region *nd_region = to_nd_region(dev->parent);
 	int nid = dev_to_node(dev), fua;
-	struct resource *res = &nsio->res;
+	struct pfn_map_info *mi;
 	struct resource bb_res;
 	struct nd_pfn *nd_pfn = NULL;
 	struct dax_device *dax_dev;
-	struct nd_pfn_sb *pfn_sb;
 	struct pmem_device *pmem;
 	struct request_queue *q;
 	struct device *gendev;
 	struct gendisk *disk;
-	void *addr;
 	int rc;
 
 	pmem = devm_kzalloc(dev, sizeof(*pmem), GFP_KERNEL);
 	if (!pmem)
 		return -ENOMEM;
+	mi = &pmem->mi;
 
 	/* while nsio_rw_bytes is active, parse a pfn info block if present */
 	if (is_nd_pfn(dev)) {
 		nd_pfn = to_nd_pfn(dev);
-		rc = nvdimm_setup_pfn(nd_pfn, &pmem->pgmap);
+		rc = nvdimm_setup_pfn(nd_pfn, &pmem->pgmap, mi);
 		if (rc)
 			return rc;
+	} else {
+		*mi = (struct pfn_map_info) {
+			.map_offset = 0,
+			.map_base = nsio->res.start,
+			.map_size = resource_size(&nsio->res),
+		};
 	}
 
 	/* we're attaching a block device, disable raw namespace access */
 	devm_nsio_disable(dev, nsio);
 
 	dev_set_drvdata(dev, pmem);
-	pmem->phys_addr = res->start;
-	pmem->size = resource_size(res);
 	fua = nvdimm_has_flush(nd_region);
 	if (!IS_ENABLED(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) || fua < 0) {
 		dev_warn(dev, "unable to guarantee persistence of writes\n");
 		fua = 0;
 	}
 
-	if (!devm_request_mem_region(dev, res->start, resource_size(res),
+	if (!devm_request_mem_region(dev, nsio->res.start,
+				resource_size(&nsio->res),
 				dev_name(&ndns->dev))) {
-		dev_warn(dev, "could not reserve region %pR\n", res);
+		dev_warn(dev, "could not reserve region %pR\n", &nsio->res);
 		return -EBUSY;
 	}
 
@@ -403,37 +408,27 @@ static int pmem_attach_disk(struct device *dev,
 	if (devm_add_action_or_reset(dev, pmem_release_queue, q))
 		return -ENOMEM;
 
-	pmem->pfn_flags = PFN_DEV;
+	mi->pfn_flags = PFN_DEV;
 	pmem->pgmap.ref = &q->q_usage_counter;
 	pmem->pgmap.kill = pmem_freeze_queue;
 	if (is_nd_pfn(dev)) {
 		if (setup_pagemap_fsdax(dev, &pmem->pgmap))
 			return -ENOMEM;
-		addr = devm_memremap_pages(dev, &pmem->pgmap);
-		pfn_sb = nd_pfn->pfn_sb;
-		pmem->data_offset = le64_to_cpu(pfn_sb->dataoff);
-		pmem->pfn_pad = resource_size(res) -
-			resource_size(&pmem->pgmap.res);
-		pmem->pfn_flags |= PFN_MAP;
-		memcpy(&bb_res, &pmem->pgmap.res, sizeof(bb_res));
-		bb_res.start += pmem->data_offset;
+		mi->map = devm_memremap_pages(dev, &pmem->pgmap);
+		mi->pfn_flags |= PFN_MAP;
 	} else if (pmem_should_map_pages(dev)) {
 		memcpy(&pmem->pgmap.res, &nsio->res, sizeof(pmem->pgmap.res));
 		pmem->pgmap.altmap_valid = false;
 		if (setup_pagemap_fsdax(dev, &pmem->pgmap))
 			return -ENOMEM;
-		addr = devm_memremap_pages(dev, &pmem->pgmap);
-		pmem->pfn_flags |= PFN_MAP;
-		memcpy(&bb_res, &pmem->pgmap.res, sizeof(bb_res));
-	} else {
-		addr = devm_memremap(dev, pmem->phys_addr,
-				pmem->size, ARCH_MEMREMAP_PMEM);
-		memcpy(&bb_res, &nsio->res, sizeof(bb_res));
-	}
+		mi->map = devm_memremap_pages(dev, &pmem->pgmap);
+		mi->pfn_flags |= PFN_MAP;
+	} else
+		mi->map = devm_memremap(dev, mi->map_base, mi->map_size,
+				ARCH_MEMREMAP_PMEM);
 
-	if (IS_ERR(addr))
-		return PTR_ERR(addr);
-	pmem->virt_addr = addr;
+	if (IS_ERR(mi->map))
+		return PTR_ERR(mi->map);
 
 	blk_queue_write_cache(q, true, fua);
 	blk_queue_make_request(q, pmem_make_request);
@@ -441,7 +436,7 @@ static int pmem_attach_disk(struct device *dev,
 	blk_queue_logical_block_size(q, pmem_sector_size(ndns));
 	blk_queue_max_hw_sectors(q, UINT_MAX);
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
-	if (pmem->pfn_flags & PFN_MAP)
+	if (mi->pfn_flags & PFN_MAP)
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
 	q->queuedata = pmem;
 
@@ -455,10 +450,13 @@ static int pmem_attach_disk(struct device *dev,
 	disk->flags		= GENHD_FL_EXT_DEVT;
 	disk->queue->backing_dev_info->capabilities |= BDI_CAP_SYNCHRONOUS_IO;
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
-	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
-			/ 512);
+	set_capacity(disk, (mi->map_size - mi->map_offset) / 512);
 	if (devm_init_badblocks(dev, &pmem->bb))
 		return -ENOMEM;
+	bb_res = (struct resource) {
+		.start = mi->map_base + mi->map_pad + mi->map_offset,
+		.end = mi->map_base + mi->map_pad + mi->map_size - 1,
+	};
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_res);
 	disk->bb = &pmem->bb;
 
@@ -540,7 +538,6 @@ static void nd_pmem_shutdown(struct device *dev)
 static void nd_pmem_notify(struct device *dev, enum nvdimm_event event)
 {
 	struct nd_region *nd_region;
-	resource_size_t offset = 0, end_trunc = 0;
 	struct nd_namespace_common *ndns;
 	struct nd_namespace_io *nsio;
 	struct resource res;
@@ -556,32 +553,26 @@ static void nd_pmem_notify(struct device *dev, enum nvdimm_event event)
 		ndns = nd_btt->ndns;
 		nd_region = to_nd_region(ndns->dev.parent);
 		nsio = to_nd_namespace_io(&ndns->dev);
+		res = (struct resource) {
+			.start = nsio->res.start,
+			.end = nsio->res.end,
+		};
 		bb = &nsio->bb;
 		bb_state = NULL;
 	} else {
 		struct pmem_device *pmem = dev_get_drvdata(dev);
+		struct pfn_map_info *mi = &pmem->mi;
 
 		nd_region = to_region(pmem);
 		bb = &pmem->bb;
 		bb_state = pmem->bb_state;
 
-		if (is_nd_pfn(dev)) {
-			struct nd_pfn *nd_pfn = to_nd_pfn(dev);
-			struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
-
-			ndns = nd_pfn->ndns;
-			offset = pmem->data_offset +
-					__le32_to_cpu(pfn_sb->start_pad);
-			end_trunc = __le32_to_cpu(pfn_sb->end_trunc);
-		} else {
-			ndns = to_ndns(dev);
-		}
-
-		nsio = to_nd_namespace_io(&ndns->dev);
+		res = (struct resource) {
+			.start = mi->map_base + mi->map_pad + mi->map_offset,
+			.end = mi->map_base + mi->map_pad + mi->map_size - 1,
+		};
 	}
 
-	res.start = nsio->res.start + offset;
-	res.end = nsio->res.end - end_trunc;
 	nvdimm_badblocks_populate(nd_region, bb, &res);
 	if (bb_state)
 		sysfs_notify_dirent(bb_state);
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index 59cfe13ea8a8..6c27bbae349f 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -6,19 +6,11 @@
 #include <linux/types.h>
 #include <linux/pfn_t.h>
 #include <linux/fs.h>
+#include "nd.h"
 
 /* this definition is in it's own header for tools/testing/nvdimm to consume */
 struct pmem_device {
-	/* One contiguous memory region per device */
-	phys_addr_t		phys_addr;
-	/* when non-zero this device is hosting a 'pfn' instance */
-	phys_addr_t		data_offset;
-	u64			pfn_flags;
-	void			*virt_addr;
-	/* immutable base size of the namespace */
-	size_t			size;
-	/* trim size when namespace capacity has been section aligned */
-	u32			pfn_pad;
+	struct pfn_map_info	mi;
 	struct kernfs_node	*bb_state;
 	struct badblocks	bb;
 	struct dax_device	*dax_dev;
diff --git a/tools/testing/nvdimm/pmem-dax.c b/tools/testing/nvdimm/pmem-dax.c
index 2e7fd8227969..52a8760d2ec5 100644
--- a/tools/testing/nvdimm/pmem-dax.c
+++ b/tools/testing/nvdimm/pmem-dax.c
@@ -18,7 +18,8 @@
 long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
 {
-	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
+	struct pfn_map_info *mi = &pmem->mi;
+	resource_size_t offset = PFN_PHYS(pgoff) + mi->map_offset;
 
 	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
 					PFN_PHYS(nr_pages))))
@@ -28,12 +29,12 @@ long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 	 * Limit dax to a single page at a time given vmalloc()-backed
 	 * in the nfit_test case.
 	 */
-	if (get_nfit_res(pmem->phys_addr + offset)) {
+	if (get_nfit_res(mi->map_base + offset)) {
 		struct page *page;
 
 		if (kaddr)
-			*kaddr = pmem->virt_addr + offset;
-		page = vmalloc_to_page(pmem->virt_addr + offset);
+			*kaddr = mi->map + offset;
+		page = vmalloc_to_page(mi->map + offset);
 		if (pfn)
 			*pfn = page_to_pfn_t(page);
 		pr_debug_ratelimited("%s: pmem: %p pgoff: %#lx pfn: %#lx\n",
@@ -43,9 +44,9 @@ long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 	}
 
 	if (kaddr)
-		*kaddr = pmem->virt_addr + offset;
+		*kaddr = mi->map + offset;
 	if (pfn)
-		*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
+		*pfn = phys_to_pfn_t(mi->map_base + offset, mi->pfn_flags);
 
 	/*
 	 * If badblocks are present, limit known good range to the
@@ -53,5 +54,5 @@ long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 	 */
 	if (unlikely(pmem->bb.count))
 		return nr_pages;
-	return PHYS_PFN(pmem->size - pmem->pfn_pad - offset);
+	return PHYS_PFN(mi->map_size - offset);
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
