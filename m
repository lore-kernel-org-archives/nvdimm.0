Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 03/17] libnvdimm, nfit,
 nd_blk: driver for BLK-mode access persistent memory
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 25 Jun 2015 05:36:34 -0400
Message-ID: <20150625093634.40066.27252.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
References: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, boaz@plexistor.com, toshi.kani@hp.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Ross Zwisler <ross.zwisler@linux.intel.com>

The libnvdimm implementation handles allocating dimm address space (DPA)
between PMEM and BLK mode interfaces.  After DPA has been allocated from
a BLK-region to a BLK-namespace the nd_blk driver attaches to handle I/O
as a struct bio based block device. Unlike PMEM, BLK is required to
handle platform specific details like mmio register formats and memory
controller interleave.  For this reason the libnvdimm generic nd_blk
driver calls back into the bus provider to carry out the I/O.

This initial implementation handles the BLK interface defined by the
ACPI 6 NFIT [1] and the NVDIMM DSM Interface Example [2] composed from
DCR (dimm control region), BDW (block data window), IDT (interleave
descriptor) NFIT structures and the hardware register format.
[1]: http://www.uefi.org/sites/default/files/resources/ACPI_6.0.pdf
[2]: http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c             |  449 ++++++++++++++++++++++++++++++++++++++-
 drivers/acpi/nfit.h             |   49 ++++
 drivers/nvdimm/Kconfig          |   13 +
 drivers/nvdimm/Makefile         |    3 
 drivers/nvdimm/blk.c            |  245 +++++++++++++++++++++
 drivers/nvdimm/dimm_devs.c      |    9 +
 drivers/nvdimm/namespace_devs.c |   65 ++++++
 drivers/nvdimm/nd-core.h        |    3 
 drivers/nvdimm/nd.h             |   13 +
 drivers/nvdimm/region.c         |    8 +
 drivers/nvdimm/region_devs.c    |   91 +++++++-
 include/linux/libnvdimm.h       |   27 ++
 12 files changed, 941 insertions(+), 34 deletions(-)
 create mode 100644 drivers/nvdimm/blk.c

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index fc38b49eff7d..2aa6aa97b40c 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -13,12 +13,20 @@
 #include <linux/list_sort.h>
 #include <linux/libnvdimm.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/ndctl.h>
 #include <linux/list.h>
 #include <linux/acpi.h>
 #include <linux/sort.h>
+#include <linux/io.h>
 #include "nfit.h"
 
+/*
+ * For readq() and writeq() on 32-bit builds, the hi-lo, lo-hi order is
+ * irrelevant.
+ */
+#include <asm-generic/io-64-nonatomic-hi-lo.h>
+
 static bool force_enable_dimms;
 module_param(force_enable_dimms, bool, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(force_enable_dimms, "Ignore _STA (ACPI DIMM device) status");
@@ -72,7 +80,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 
 		if (!adev)
 			return -ENOTTY;
-		dimm_name = dev_name(&adev->dev);
+		dimm_name = nvdimm_name(nvdimm);
 		cmd_name = nvdimm_cmd_name(cmd);
 		dsm_mask = nfit_mem->dsm_mask;
 		desc = nd_cmd_dimm_desc(cmd);
@@ -279,6 +287,23 @@ static bool add_bdw(struct acpi_nfit_desc *acpi_desc,
 	return true;
 }
 
+static bool add_idt(struct acpi_nfit_desc *acpi_desc,
+		struct acpi_nfit_interleave *idt)
+{
+	struct device *dev = acpi_desc->dev;
+	struct nfit_idt *nfit_idt = devm_kzalloc(dev, sizeof(*nfit_idt),
+			GFP_KERNEL);
+
+	if (!nfit_idt)
+		return false;
+	INIT_LIST_HEAD(&nfit_idt->list);
+	nfit_idt->idt = idt;
+	list_add_tail(&nfit_idt->list, &acpi_desc->idts);
+	dev_dbg(dev, "%s: idt index: %d num_lines: %d\n", __func__,
+			idt->interleave_index, idt->line_count);
+	return true;
+}
+
 static void *add_table(struct acpi_nfit_desc *acpi_desc, void *table,
 		const void *end)
 {
@@ -307,9 +332,9 @@ static void *add_table(struct acpi_nfit_desc *acpi_desc, void *table,
 		if (!add_bdw(acpi_desc, table))
 			return err;
 		break;
-	/* TODO */
 	case ACPI_NFIT_TYPE_INTERLEAVE:
-		dev_dbg(dev, "%s: idt\n", __func__);
+		if (!add_idt(acpi_desc, table))
+			return err;
 		break;
 	case ACPI_NFIT_TYPE_FLUSH_ADDRESS:
 		dev_dbg(dev, "%s: flush\n", __func__);
@@ -362,8 +387,11 @@ static int nfit_mem_add(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_mem *nfit_mem, struct acpi_nfit_system_address *spa)
 {
 	u16 dcr = __to_nfit_memdev(nfit_mem)->region_index;
+	struct nfit_memdev *nfit_memdev;
 	struct nfit_dcr *nfit_dcr;
 	struct nfit_bdw *nfit_bdw;
+	struct nfit_idt *nfit_idt;
+	u16 idt_idx, range_index;
 
 	list_for_each_entry(nfit_dcr, &acpi_desc->dcrs, list) {
 		if (nfit_dcr->dcr->region_index != dcr)
@@ -396,6 +424,26 @@ static int nfit_mem_add(struct acpi_nfit_desc *acpi_desc,
 		return 0;
 
 	nfit_mem_find_spa_bdw(acpi_desc, nfit_mem);
+
+	if (!nfit_mem->spa_bdw)
+		return 0;
+
+	range_index = nfit_mem->spa_bdw->range_index;
+	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
+		if (nfit_memdev->memdev->range_index != range_index ||
+				nfit_memdev->memdev->region_index != dcr)
+			continue;
+		nfit_mem->memdev_bdw = nfit_memdev->memdev;
+		idt_idx = nfit_memdev->memdev->interleave_index;
+		list_for_each_entry(nfit_idt, &acpi_desc->idts, list) {
+			if (nfit_idt->idt->interleave_index != idt_idx)
+				continue;
+			nfit_mem->idt_bdw = nfit_idt->idt;
+			break;
+		}
+		break;
+	}
+
 	return 0;
 }
 
@@ -439,9 +487,19 @@ static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
 		}
 
 		if (type == NFIT_SPA_DCR) {
+			struct nfit_idt *nfit_idt;
+			u16 idt_idx;
+
 			/* multiple dimms may share a SPA when interleaved */
 			nfit_mem->spa_dcr = spa;
 			nfit_mem->memdev_dcr = nfit_memdev->memdev;
+			idt_idx = nfit_memdev->memdev->interleave_index;
+			list_for_each_entry(nfit_idt, &acpi_desc->idts, list) {
+				if (nfit_idt->idt->interleave_index != idt_idx)
+					continue;
+				nfit_mem->idt_dcr = nfit_idt->idt;
+				break;
+			}
 		} else {
 			/*
 			 * A single dimm may belong to multiple SPA-PM
@@ -871,6 +929,359 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 	return 0;
 }
 
+static u64 to_interleave_offset(u64 offset, struct nfit_blk_mmio *mmio)
+{
+	struct acpi_nfit_interleave *idt = mmio->idt;
+	u32 sub_line_offset, line_index, line_offset;
+	u64 line_no, table_skip_count, table_offset;
+
+	line_no = div_u64_rem(offset, mmio->line_size, &sub_line_offset);
+	table_skip_count = div_u64_rem(line_no, mmio->num_lines, &line_index);
+	line_offset = idt->line_offset[line_index]
+		* mmio->line_size;
+	table_offset = table_skip_count * mmio->table_size;
+
+	return mmio->base_offset + line_offset + table_offset + sub_line_offset;
+}
+
+static u64 read_blk_stat(struct nfit_blk *nfit_blk, unsigned int bw)
+{
+	struct nfit_blk_mmio *mmio = &nfit_blk->mmio[DCR];
+	u64 offset = nfit_blk->stat_offset + mmio->size * bw;
+
+	if (mmio->num_lines)
+		offset = to_interleave_offset(offset, mmio);
+
+	return readq(mmio->base + offset);
+}
+
+static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
+		resource_size_t dpa, unsigned int len, unsigned int write)
+{
+	u64 cmd, offset;
+	struct nfit_blk_mmio *mmio = &nfit_blk->mmio[DCR];
+
+	enum {
+		BCW_OFFSET_MASK = (1ULL << 48)-1,
+		BCW_LEN_SHIFT = 48,
+		BCW_LEN_MASK = (1ULL << 8) - 1,
+		BCW_CMD_SHIFT = 56,
+	};
+
+	cmd = (dpa >> L1_CACHE_SHIFT) & BCW_OFFSET_MASK;
+	len = len >> L1_CACHE_SHIFT;
+	cmd |= ((u64) len & BCW_LEN_MASK) << BCW_LEN_SHIFT;
+	cmd |= ((u64) write) << BCW_CMD_SHIFT;
+
+	offset = nfit_blk->cmd_offset + mmio->size * bw;
+	if (mmio->num_lines)
+		offset = to_interleave_offset(offset, mmio);
+
+	writeq(cmd, mmio->base + offset);
+	/* FIXME: conditionally perform read-back if mandated by firmware */
+}
+
+static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
+		resource_size_t dpa, void *iobuf, size_t len, int rw,
+		unsigned int lane)
+{
+	struct nfit_blk_mmio *mmio = &nfit_blk->mmio[BDW];
+	unsigned int copied = 0;
+	u64 base_offset;
+	int rc;
+
+	base_offset = nfit_blk->bdw_offset + dpa % L1_CACHE_BYTES
+		+ lane * mmio->size;
+	/* TODO: non-temporal access, flush hints, cache management etc... */
+	write_blk_ctl(nfit_blk, lane, dpa, len, rw);
+	while (len) {
+		unsigned int c;
+		u64 offset;
+
+		if (mmio->num_lines) {
+			u32 line_offset;
+
+			offset = to_interleave_offset(base_offset + copied,
+					mmio);
+			div_u64_rem(offset, mmio->line_size, &line_offset);
+			c = min_t(size_t, len, mmio->line_size - line_offset);
+		} else {
+			offset = base_offset + nfit_blk->bdw_offset;
+			c = len;
+		}
+
+		if (rw)
+			memcpy(mmio->aperture + offset, iobuf + copied, c);
+		else
+			memcpy(iobuf + copied, mmio->aperture + offset, c);
+
+		copied += c;
+		len -= c;
+	}
+	rc = read_blk_stat(nfit_blk, lane) ? -EIO : 0;
+	return rc;
+}
+
+static int acpi_nfit_blk_region_do_io(struct nd_blk_region *ndbr,
+		resource_size_t dpa, void *iobuf, u64 len, int rw)
+{
+	struct nfit_blk *nfit_blk = nd_blk_region_provider_data(ndbr);
+	struct nfit_blk_mmio *mmio = &nfit_blk->mmio[BDW];
+	struct nd_region *nd_region = nfit_blk->nd_region;
+	unsigned int lane, copied = 0;
+	int rc = 0;
+
+	lane = nd_region_acquire_lane(nd_region);
+	while (len) {
+		u64 c = min(len, mmio->size);
+
+		rc = acpi_nfit_blk_single_io(nfit_blk, dpa + copied,
+				iobuf + copied, c, rw, lane);
+		if (rc)
+			break;
+
+		copied += c;
+		len -= c;
+	}
+	nd_region_release_lane(nd_region, lane);
+
+	return rc;
+}
+
+static void nfit_spa_mapping_release(struct kref *kref)
+{
+	struct nfit_spa_mapping *spa_map = to_spa_map(kref);
+	struct acpi_nfit_system_address *spa = spa_map->spa;
+	struct acpi_nfit_desc *acpi_desc = spa_map->acpi_desc;
+
+	WARN_ON(!mutex_is_locked(&acpi_desc->spa_map_mutex));
+	dev_dbg(acpi_desc->dev, "%s: SPA%d\n", __func__, spa->range_index);
+	iounmap(spa_map->iomem);
+	release_mem_region(spa->address, spa->length);
+	list_del(&spa_map->list);
+	kfree(spa_map);
+}
+
+static struct nfit_spa_mapping *find_spa_mapping(
+		struct acpi_nfit_desc *acpi_desc,
+		struct acpi_nfit_system_address *spa)
+{
+	struct nfit_spa_mapping *spa_map;
+
+	WARN_ON(!mutex_is_locked(&acpi_desc->spa_map_mutex));
+	list_for_each_entry(spa_map, &acpi_desc->spa_maps, list)
+		if (spa_map->spa == spa)
+			return spa_map;
+
+	return NULL;
+}
+
+static void nfit_spa_unmap(struct acpi_nfit_desc *acpi_desc,
+		struct acpi_nfit_system_address *spa)
+{
+	struct nfit_spa_mapping *spa_map;
+
+	mutex_lock(&acpi_desc->spa_map_mutex);
+	spa_map = find_spa_mapping(acpi_desc, spa);
+
+	if (spa_map)
+		kref_put(&spa_map->kref, nfit_spa_mapping_release);
+	mutex_unlock(&acpi_desc->spa_map_mutex);
+}
+
+static void __iomem *__nfit_spa_map(struct acpi_nfit_desc *acpi_desc,
+		struct acpi_nfit_system_address *spa)
+{
+	resource_size_t start = spa->address;
+	resource_size_t n = spa->length;
+	struct nfit_spa_mapping *spa_map;
+	struct resource *res;
+
+	WARN_ON(!mutex_is_locked(&acpi_desc->spa_map_mutex));
+
+	spa_map = find_spa_mapping(acpi_desc, spa);
+	if (spa_map) {
+		kref_get(&spa_map->kref);
+		return spa_map->iomem;
+	}
+
+	spa_map = kzalloc(sizeof(*spa_map), GFP_KERNEL);
+	if (!spa_map)
+		return NULL;
+
+	INIT_LIST_HEAD(&spa_map->list);
+	spa_map->spa = spa;
+	kref_init(&spa_map->kref);
+	spa_map->acpi_desc = acpi_desc;
+
+	res = request_mem_region(start, n, dev_name(acpi_desc->dev));
+	if (!res)
+		goto err_mem;
+
+	/* TODO: cacheability based on the spa type */
+	spa_map->iomem = ioremap_nocache(start, n);
+	if (!spa_map->iomem)
+		goto err_map;
+
+	list_add_tail(&spa_map->list, &acpi_desc->spa_maps);
+	return spa_map->iomem;
+
+ err_map:
+	release_mem_region(start, n);
+ err_mem:
+	kfree(spa_map);
+	return NULL;
+}
+
+/**
+ * nfit_spa_map - interleave-aware managed-mappings of acpi_nfit_system_address ranges
+ * @nvdimm_bus: NFIT-bus that provided the spa table entry
+ * @nfit_spa: spa table to map
+ *
+ * In the case where block-data-window apertures and
+ * dimm-control-regions are interleaved they will end up sharing a
+ * single request_mem_region() + ioremap() for the address range.  In
+ * the style of devm nfit_spa_map() mappings are automatically dropped
+ * when all region devices referencing the same mapping are disabled /
+ * unbound.
+ */
+static void __iomem *nfit_spa_map(struct acpi_nfit_desc *acpi_desc,
+		struct acpi_nfit_system_address *spa)
+{
+	void __iomem *iomem;
+
+	mutex_lock(&acpi_desc->spa_map_mutex);
+	iomem = __nfit_spa_map(acpi_desc, spa);
+	mutex_unlock(&acpi_desc->spa_map_mutex);
+
+	return iomem;
+}
+
+static int nfit_blk_init_interleave(struct nfit_blk_mmio *mmio,
+		struct acpi_nfit_interleave *idt, u16 interleave_ways)
+{
+	if (idt) {
+		mmio->num_lines = idt->line_count;
+		mmio->line_size = idt->line_size;
+		if (interleave_ways == 0)
+			return -ENXIO;
+		mmio->table_size = mmio->num_lines * interleave_ways
+			* mmio->line_size;
+	}
+
+	return 0;
+}
+
+static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
+		struct device *dev)
+{
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
+	struct nd_blk_region *ndbr = to_nd_blk_region(dev);
+	struct nfit_blk_mmio *mmio;
+	struct nfit_blk *nfit_blk;
+	struct nfit_mem *nfit_mem;
+	struct nvdimm *nvdimm;
+	int rc;
+
+	nvdimm = nd_blk_region_to_dimm(ndbr);
+	nfit_mem = nvdimm_provider_data(nvdimm);
+	if (!nfit_mem || !nfit_mem->dcr || !nfit_mem->bdw) {
+		dev_dbg(dev, "%s: missing%s%s%s\n", __func__,
+				nfit_mem ? "" : " nfit_mem",
+				nfit_mem->dcr ? "" : " dcr",
+				nfit_mem->bdw ? "" : " bdw");
+		return -ENXIO;
+	}
+
+	nfit_blk = devm_kzalloc(dev, sizeof(*nfit_blk), GFP_KERNEL);
+	if (!nfit_blk)
+		return -ENOMEM;
+	nd_blk_region_set_provider_data(ndbr, nfit_blk);
+	nfit_blk->nd_region = to_nd_region(dev);
+
+	/* map block aperture memory */
+	nfit_blk->bdw_offset = nfit_mem->bdw->offset;
+	mmio = &nfit_blk->mmio[BDW];
+	mmio->base = nfit_spa_map(acpi_desc, nfit_mem->spa_bdw);
+	if (!mmio->base) {
+		dev_dbg(dev, "%s: %s failed to map bdw\n", __func__,
+				nvdimm_name(nvdimm));
+		return -ENOMEM;
+	}
+	mmio->size = nfit_mem->bdw->size;
+	mmio->base_offset = nfit_mem->memdev_bdw->region_offset;
+	mmio->idt = nfit_mem->idt_bdw;
+	mmio->spa = nfit_mem->spa_bdw;
+	rc = nfit_blk_init_interleave(mmio, nfit_mem->idt_bdw,
+			nfit_mem->memdev_bdw->interleave_ways);
+	if (rc) {
+		dev_dbg(dev, "%s: %s failed to init bdw interleave\n",
+				__func__, nvdimm_name(nvdimm));
+		return rc;
+	}
+
+	/* map block control memory */
+	nfit_blk->cmd_offset = nfit_mem->dcr->command_offset;
+	nfit_blk->stat_offset = nfit_mem->dcr->status_offset;
+	mmio = &nfit_blk->mmio[DCR];
+	mmio->base = nfit_spa_map(acpi_desc, nfit_mem->spa_dcr);
+	if (!mmio->base) {
+		dev_dbg(dev, "%s: %s failed to map dcr\n", __func__,
+				nvdimm_name(nvdimm));
+		return -ENOMEM;
+	}
+	mmio->size = nfit_mem->dcr->window_size;
+	mmio->base_offset = nfit_mem->memdev_dcr->region_offset;
+	mmio->idt = nfit_mem->idt_dcr;
+	mmio->spa = nfit_mem->spa_dcr;
+	rc = nfit_blk_init_interleave(mmio, nfit_mem->idt_dcr,
+			nfit_mem->memdev_dcr->interleave_ways);
+	if (rc) {
+		dev_dbg(dev, "%s: %s failed to init dcr interleave\n",
+				__func__, nvdimm_name(nvdimm));
+		return rc;
+	}
+
+	if (mmio->line_size == 0)
+		return 0;
+
+	if ((u32) nfit_blk->cmd_offset % mmio->line_size
+			+ 8 > mmio->line_size) {
+		dev_dbg(dev, "cmd_offset crosses interleave boundary\n");
+		return -ENXIO;
+	} else if ((u32) nfit_blk->stat_offset % mmio->line_size
+			+ 8 > mmio->line_size) {
+		dev_dbg(dev, "stat_offset crosses interleave boundary\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static void acpi_nfit_blk_region_disable(struct nvdimm_bus *nvdimm_bus,
+		struct device *dev)
+{
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
+	struct nd_blk_region *ndbr = to_nd_blk_region(dev);
+	struct nfit_blk *nfit_blk = nd_blk_region_provider_data(ndbr);
+	int i;
+
+	if (!nfit_blk)
+		return; /* never enabled */
+
+	/* auto-free BLK spa mappings */
+	for (i = 0; i < 2; i++) {
+		struct nfit_blk_mmio *mmio = &nfit_blk->mmio[i];
+
+		if (mmio->base)
+			nfit_spa_unmap(acpi_desc, mmio->spa);
+	}
+	nd_blk_region_set_provider_data(ndbr, NULL);
+	/* devm will free nfit_blk */
+}
+
 static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
 		struct nd_mapping *nd_mapping, struct nd_region_desc *ndr_desc,
 		struct acpi_nfit_memory_map *memdev,
@@ -878,6 +1289,7 @@ static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
 {
 	struct nvdimm *nvdimm = acpi_nfit_dimm_by_handle(acpi_desc,
 			memdev->device_handle);
+	struct nd_blk_region_desc *ndbr_desc;
 	struct nfit_mem *nfit_mem;
 	int blk_valid = 0;
 
@@ -908,6 +1320,10 @@ static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
 
 		ndr_desc->nd_mapping = nd_mapping;
 		ndr_desc->num_mappings = blk_valid;
+		ndbr_desc = to_blk_region_desc(ndr_desc);
+		ndbr_desc->enable = acpi_nfit_blk_region_enable;
+		ndbr_desc->disable = acpi_nfit_blk_region_disable;
+		ndbr_desc->do_io = acpi_nfit_blk_region_do_io;
 		if (!nvdimm_blk_region_create(acpi_desc->nvdimm_bus, ndr_desc))
 			return -ENOMEM;
 		break;
@@ -921,8 +1337,9 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 {
 	static struct nd_mapping nd_mappings[ND_MAX_MAPPINGS];
 	struct acpi_nfit_system_address *spa = nfit_spa->spa;
+	struct nd_blk_region_desc ndbr_desc;
+	struct nd_region_desc *ndr_desc;
 	struct nfit_memdev *nfit_memdev;
-	struct nd_region_desc ndr_desc;
 	struct nvdimm_bus *nvdimm_bus;
 	struct resource res;
 	int count = 0, rc;
@@ -935,12 +1352,13 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 
 	memset(&res, 0, sizeof(res));
 	memset(&nd_mappings, 0, sizeof(nd_mappings));
-	memset(&ndr_desc, 0, sizeof(ndr_desc));
+	memset(&ndbr_desc, 0, sizeof(ndbr_desc));
 	res.start = spa->address;
 	res.end = res.start + spa->length - 1;
-	ndr_desc.res = &res;
-	ndr_desc.provider_data = nfit_spa;
-	ndr_desc.attr_groups = acpi_nfit_region_attribute_groups;
+	ndr_desc = &ndbr_desc.ndr_desc;
+	ndr_desc->res = &res;
+	ndr_desc->provider_data = nfit_spa;
+	ndr_desc->attr_groups = acpi_nfit_region_attribute_groups;
 	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
 		struct acpi_nfit_memory_map *memdev = nfit_memdev->memdev;
 		struct nd_mapping *nd_mapping;
@@ -953,24 +1371,24 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 			return -ENXIO;
 		}
 		nd_mapping = &nd_mappings[count++];
-		rc = acpi_nfit_init_mapping(acpi_desc, nd_mapping, &ndr_desc,
+		rc = acpi_nfit_init_mapping(acpi_desc, nd_mapping, ndr_desc,
 				memdev, spa);
 		if (rc)
 			return rc;
 	}
 
-	ndr_desc.nd_mapping = nd_mappings;
-	ndr_desc.num_mappings = count;
-	rc = acpi_nfit_init_interleave_set(acpi_desc, &ndr_desc, spa);
+	ndr_desc->nd_mapping = nd_mappings;
+	ndr_desc->num_mappings = count;
+	rc = acpi_nfit_init_interleave_set(acpi_desc, ndr_desc, spa);
 	if (rc)
 		return rc;
 
 	nvdimm_bus = acpi_desc->nvdimm_bus;
 	if (nfit_spa_type(spa) == NFIT_SPA_PM) {
-		if (!nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc))
+		if (!nvdimm_pmem_region_create(nvdimm_bus, ndr_desc))
 			return -ENOMEM;
 	} else if (nfit_spa_type(spa) == NFIT_SPA_VOLATILE) {
-		if (!nvdimm_volatile_region_create(nvdimm_bus, &ndr_desc))
+		if (!nvdimm_volatile_region_create(nvdimm_bus, ndr_desc))
 			return -ENOMEM;
 	}
 	return 0;
@@ -996,11 +1414,14 @@ static int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 	u8 *data;
 	int rc;
 
+	INIT_LIST_HEAD(&acpi_desc->spa_maps);
 	INIT_LIST_HEAD(&acpi_desc->spas);
 	INIT_LIST_HEAD(&acpi_desc->dcrs);
 	INIT_LIST_HEAD(&acpi_desc->bdws);
+	INIT_LIST_HEAD(&acpi_desc->idts);
 	INIT_LIST_HEAD(&acpi_desc->memdevs);
 	INIT_LIST_HEAD(&acpi_desc->dimms);
+	mutex_init(&acpi_desc->spa_map_mutex);
 
 	data = (u8 *) acpi_desc->nfit;
 	end = data + sz;
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index b76e33629098..7bd38b7baf39 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -52,6 +52,11 @@ struct nfit_bdw {
 	struct list_head list;
 };
 
+struct nfit_idt {
+	struct acpi_nfit_interleave *idt;
+	struct list_head list;
+};
+
 struct nfit_memdev {
 	struct acpi_nfit_memory_map *memdev;
 	struct list_head list;
@@ -62,10 +67,13 @@ struct nfit_mem {
 	struct nvdimm *nvdimm;
 	struct acpi_nfit_memory_map *memdev_dcr;
 	struct acpi_nfit_memory_map *memdev_pmem;
+	struct acpi_nfit_memory_map *memdev_bdw;
 	struct acpi_nfit_control_region *dcr;
 	struct acpi_nfit_data_region *bdw;
 	struct acpi_nfit_system_address *spa_dcr;
 	struct acpi_nfit_system_address *spa_bdw;
+	struct acpi_nfit_interleave *idt_dcr;
+	struct acpi_nfit_interleave *idt_bdw;
 	struct list_head list;
 	struct acpi_device *adev;
 	unsigned long dsm_mask;
@@ -74,16 +82,57 @@ struct nfit_mem {
 struct acpi_nfit_desc {
 	struct nvdimm_bus_descriptor nd_desc;
 	struct acpi_table_nfit *nfit;
+	struct mutex spa_map_mutex;
+	struct list_head spa_maps;
 	struct list_head memdevs;
 	struct list_head dimms;
 	struct list_head spas;
 	struct list_head dcrs;
 	struct list_head bdws;
+	struct list_head idts;
 	struct nvdimm_bus *nvdimm_bus;
 	struct device *dev;
 	unsigned long dimm_dsm_force_en;
 };
 
+enum nd_blk_mmio_selector {
+	BDW,
+	DCR,
+};
+
+struct nfit_blk {
+	struct nfit_blk_mmio {
+		union {
+			void __iomem *base;
+			void *aperture;
+		};
+		u64 size;
+		u64 base_offset;
+		u32 line_size;
+		u32 num_lines;
+		u32 table_size;
+		struct acpi_nfit_interleave *idt;
+		struct acpi_nfit_system_address *spa;
+	} mmio[2];
+	struct nd_region *nd_region;
+	u64 bdw_offset; /* post interleave offset */
+	u64 stat_offset;
+	u64 cmd_offset;
+};
+
+struct nfit_spa_mapping {
+	struct acpi_nfit_desc *acpi_desc;
+	struct acpi_nfit_system_address *spa;
+	struct list_head list;
+	struct kref kref;
+	void __iomem *iomem;
+};
+
+static inline struct nfit_spa_mapping *to_spa_map(struct kref *kref)
+{
+	return container_of(kref, struct nfit_spa_mapping, kref);
+}
+
 static inline struct acpi_nfit_memory_map *__to_nfit_memdev(
 		struct nfit_mem *nfit_mem)
 {
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 204ee0796411..72226acb5c0f 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -34,6 +34,19 @@ config BLK_DEV_PMEM
 
 	  Say Y if you want to use an NVDIMM
 
+config ND_BLK
+	tristate "BLK: Block data window (aperture) device support"
+	default LIBNVDIMM
+	select ND_BTT if BTT
+	help
+	  Support NVDIMMs, or other devices, that implement a BLK-mode
+	  access capability.  BLK-mode access uses memory-mapped-i/o
+	  apertures to access persistent media.
+
+	  Say Y if your platform firmware emits an ACPI.NFIT table
+	  (CONFIG_ACPI_NFIT), or otherwise exposes BLK-mode
+	  capabilities.
+
 config ND_BTT
 	tristate
 
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index d2aab6c58492..594bb97c867a 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -1,11 +1,14 @@
 obj-$(CONFIG_LIBNVDIMM) += libnvdimm.o
 obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
 obj-$(CONFIG_ND_BTT) += nd_btt.o
+obj-$(CONFIG_ND_BLK) += nd_blk.o
 
 nd_pmem-y := pmem.o
 
 nd_btt-y := btt.o
 
+nd_blk-y := blk.o
+
 libnvdimm-y := core.o
 libnvdimm-y += bus.o
 libnvdimm-y += dimm_devs.o
diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
new file mode 100644
index 000000000000..9ac0c266c15c
--- /dev/null
+++ b/drivers/nvdimm/blk.c
@@ -0,0 +1,245 @@
+/*
+ * NVDIMM Block Window Driver
+ * Copyright (c) 2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/blkdev.h>
+#include <linux/fs.h>
+#include <linux/genhd.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/nd.h>
+#include <linux/sizes.h>
+#include "nd.h"
+
+struct nd_blk_device {
+	struct request_queue *queue;
+	struct gendisk *disk;
+	struct nd_namespace_blk *nsblk;
+	struct nd_blk_region *ndbr;
+	size_t disk_size;
+};
+
+static int nd_blk_major;
+
+static resource_size_t to_dev_offset(struct nd_namespace_blk *nsblk,
+				resource_size_t ns_offset, unsigned int len)
+{
+	int i;
+
+	for (i = 0; i < nsblk->num_resources; i++) {
+		if (ns_offset < resource_size(nsblk->res[i])) {
+			if (ns_offset + len > resource_size(nsblk->res[i])) {
+				dev_WARN_ONCE(&nsblk->common.dev, 1,
+					"illegal request\n");
+				return SIZE_MAX;
+			}
+			return nsblk->res[i]->start + ns_offset;
+		}
+		ns_offset -= resource_size(nsblk->res[i]);
+	}
+
+	dev_WARN_ONCE(&nsblk->common.dev, 1, "request out of range\n");
+	return SIZE_MAX;
+}
+
+static void nd_blk_make_request(struct request_queue *q, struct bio *bio)
+{
+	struct block_device *bdev = bio->bi_bdev;
+	struct gendisk *disk = bdev->bd_disk;
+	struct nd_namespace_blk *nsblk;
+	struct nd_blk_device *blk_dev;
+	struct nd_blk_region *ndbr;
+	struct bvec_iter iter;
+	struct bio_vec bvec;
+	int err = 0, rw;
+
+	blk_dev = disk->private_data;
+	nsblk = blk_dev->nsblk;
+	ndbr = blk_dev->ndbr;
+	rw = bio_data_dir(bio);
+	bio_for_each_segment(bvec, bio, iter) {
+		unsigned int len = bvec.bv_len;
+		resource_size_t	dev_offset;
+		void *iobuf;
+
+		BUG_ON(len > PAGE_SIZE);
+
+		dev_offset = to_dev_offset(nsblk,
+				iter.bi_sector << SECTOR_SHIFT, len);
+		if (dev_offset == SIZE_MAX) {
+			err = -EIO;
+			goto out;
+		}
+
+		iobuf = kmap_atomic(bvec.bv_page);
+		err = ndbr->do_io(ndbr, dev_offset, iobuf + bvec.bv_offset,
+				len, rw);
+		kunmap_atomic(iobuf);
+		if (err)
+			goto out;
+	}
+
+ out:
+	bio_endio(bio, err);
+}
+
+static int nd_blk_rw_bytes(struct nd_namespace_common *ndns,
+		resource_size_t offset, void *iobuf, size_t n, int rw)
+{
+	struct nd_blk_device *blk_dev = dev_get_drvdata(ndns->claim);
+	struct nd_namespace_blk *nsblk = blk_dev->nsblk;
+	struct nd_blk_region *ndbr = blk_dev->ndbr;
+	resource_size_t	dev_offset;
+
+	dev_offset = to_dev_offset(nsblk, offset, n);
+
+	if (unlikely(offset + n > blk_dev->disk_size)) {
+		dev_WARN_ONCE(&ndns->dev, 1, "request out of range\n");
+		return -EFAULT;
+	}
+
+	if (dev_offset == SIZE_MAX)
+		return -EIO;
+
+	return ndbr->do_io(ndbr, dev_offset, iobuf, n, rw);
+}
+
+static const struct block_device_operations nd_blk_fops = {
+	.owner = THIS_MODULE,
+};
+
+static int nd_blk_attach_disk(struct nd_namespace_common *ndns,
+		struct nd_blk_device *blk_dev)
+{
+	struct nd_namespace_blk *nsblk = to_nd_namespace_blk(&ndns->dev);
+	struct gendisk *disk;
+
+	blk_dev->queue = blk_alloc_queue(GFP_KERNEL);
+	if (!blk_dev->queue)
+		return -ENOMEM;
+
+	blk_queue_make_request(blk_dev->queue, nd_blk_make_request);
+	blk_queue_max_hw_sectors(blk_dev->queue, UINT_MAX);
+	blk_queue_bounce_limit(blk_dev->queue, BLK_BOUNCE_ANY);
+	blk_queue_logical_block_size(blk_dev->queue, nsblk->lbasize);
+	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, blk_dev->queue);
+
+	disk = blk_dev->disk = alloc_disk(0);
+	if (!disk) {
+		blk_cleanup_queue(blk_dev->queue);
+		return -ENOMEM;
+	}
+
+	disk->driverfs_dev	= &ndns->dev;
+	disk->major		= nd_blk_major;
+	disk->first_minor	= 0;
+	disk->fops		= &nd_blk_fops;
+	disk->private_data	= blk_dev;
+	disk->queue		= blk_dev->queue;
+	disk->flags		= GENHD_FL_EXT_DEVT;
+	nvdimm_namespace_disk_name(ndns, disk->disk_name);
+	set_capacity(disk, blk_dev->disk_size >> SECTOR_SHIFT);
+	add_disk(disk);
+
+	return 0;
+}
+
+static int nd_blk_probe(struct device *dev)
+{
+	struct nd_namespace_common *ndns;
+	struct nd_blk_device *blk_dev;
+	int rc;
+
+	ndns = nvdimm_namespace_common_probe(dev);
+	if (IS_ERR(ndns))
+		return PTR_ERR(ndns);
+
+	blk_dev = kzalloc(sizeof(*blk_dev), GFP_KERNEL);
+	if (!blk_dev)
+		return -ENOMEM;
+
+	blk_dev->disk_size = nvdimm_namespace_capacity(ndns);
+	blk_dev->ndbr = to_nd_blk_region(dev->parent);
+	blk_dev->nsblk = to_nd_namespace_blk(&ndns->dev);
+	dev_set_drvdata(dev, blk_dev);
+
+	ndns->rw_bytes = nd_blk_rw_bytes;
+	if (is_nd_btt(dev))
+		rc = nvdimm_namespace_attach_btt(ndns);
+	else if (nd_btt_probe(ndns, blk_dev) == 0) {
+		/* we'll come back as btt-blk */
+		rc = -ENXIO;
+	} else
+		rc = nd_blk_attach_disk(ndns, blk_dev);
+	if (rc)
+		kfree(blk_dev);
+	return rc;
+}
+
+static void nd_blk_detach_disk(struct nd_blk_device *blk_dev)
+{
+	del_gendisk(blk_dev->disk);
+	put_disk(blk_dev->disk);
+	blk_cleanup_queue(blk_dev->queue);
+}
+
+static int nd_blk_remove(struct device *dev)
+{
+	struct nd_blk_device *blk_dev = dev_get_drvdata(dev);
+
+	if (is_nd_btt(dev))
+		nvdimm_namespace_detach_btt(to_nd_btt(dev)->ndns);
+	else
+		nd_blk_detach_disk(blk_dev);
+	kfree(blk_dev);
+
+	return 0;
+}
+
+static struct nd_device_driver nd_blk_driver = {
+	.probe = nd_blk_probe,
+	.remove = nd_blk_remove,
+	.drv = {
+		.name = "nd_blk",
+	},
+	.type = ND_DRIVER_NAMESPACE_BLK,
+};
+
+static int __init nd_blk_init(void)
+{
+	int rc;
+
+	rc = register_blkdev(0, "nd_blk");
+	if (rc < 0)
+		return rc;
+
+	nd_blk_major = rc;
+	rc = nd_driver_register(&nd_blk_driver);
+
+	if (rc < 0)
+		unregister_blkdev(nd_blk_major, "nd_blk");
+
+	return rc;
+}
+
+static void __exit nd_blk_exit(void)
+{
+	driver_unregister(&nd_blk_driver.drv);
+	unregister_blkdev(nd_blk_major, "nd_blk");
+}
+
+MODULE_AUTHOR("Ross Zwisler <ross.zwisler@linux.intel.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_NAMESPACE_BLK);
+module_init(nd_blk_init);
+module_exit(nd_blk_exit);
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 83b179ed6d61..c05eb807d674 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -209,6 +209,15 @@ struct nvdimm *to_nvdimm(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(to_nvdimm);
 
+struct nvdimm *nd_blk_region_to_dimm(struct nd_blk_region *ndbr)
+{
+	struct nd_region *nd_region = &ndbr->nd_region;
+	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+
+	return nd_mapping->nvdimm;
+}
+EXPORT_SYMBOL_GPL(nd_blk_region_to_dimm);
+
 struct nvdimm_drvdata *to_ndd(struct nd_mapping *nd_mapping)
 {
 	struct nvdimm *nvdimm = nd_mapping->nvdimm;
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 4aa647c8d644..1ce1e70de44a 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -173,6 +173,65 @@ static resource_size_t nd_namespace_blk_size(struct nd_namespace_blk *nsblk)
 	return size;
 }
 
+static bool __nd_namespace_blk_validate(struct nd_namespace_blk *nsblk)
+{
+	struct nd_region *nd_region = to_nd_region(nsblk->common.dev.parent);
+	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct nd_label_id label_id;
+	struct resource *res;
+	int count, i;
+
+	if (!nsblk->uuid || !nsblk->lbasize || !ndd)
+		return false;
+
+	count = 0;
+	nd_label_gen_id(&label_id, nsblk->uuid, NSLABEL_FLAG_LOCAL);
+	for_each_dpa_resource(ndd, res) {
+		if (strcmp(res->name, label_id.id) != 0)
+			continue;
+		/*
+		 * Resources with unacknoweldged adjustments indicate a
+		 * failure to update labels
+		 */
+		if (res->flags & DPA_RESOURCE_ADJUSTED)
+			return false;
+		count++;
+	}
+
+	/* These values match after a successful label update */
+	if (count != nsblk->num_resources)
+		return false;
+
+	for (i = 0; i < nsblk->num_resources; i++) {
+		struct resource *found = NULL;
+
+		for_each_dpa_resource(ndd, res)
+			if (res == nsblk->res[i]) {
+				found = res;
+				break;
+			}
+		/* stale resource */
+		if (!found)
+			return false;
+	}
+
+	return true;
+}
+
+resource_size_t nd_namespace_blk_validate(struct nd_namespace_blk *nsblk)
+{
+	resource_size_t size;
+
+	nvdimm_bus_lock(&nsblk->common.dev);
+	size = __nd_namespace_blk_validate(nsblk);
+	nvdimm_bus_unlock(&nsblk->common.dev);
+
+	return size;
+}
+EXPORT_SYMBOL(nd_namespace_blk_validate);
+
+
 static int nd_namespace_label_update(struct nd_region *nd_region,
 		struct device *dev)
 {
@@ -1224,7 +1283,11 @@ struct nd_namespace_common *nvdimm_namespace_common_probe(struct device *dev)
 			return ERR_PTR(-ENODEV);
 		}
 	} else if (is_namespace_blk(&ndns->dev)) {
-		return ERR_PTR(-ENODEV); /* TODO */
+		struct nd_namespace_blk *nsblk;
+
+		nsblk = to_nd_namespace_blk(&ndns->dev);
+		if (!nd_namespace_blk_validate(nsblk))
+			return ERR_PTR(-ENODEV);
 	}
 
 	return ndns;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 5e6413964776..e1970c71ad1c 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -43,9 +43,8 @@ struct nvdimm {
 };
 
 bool is_nvdimm(struct device *dev);
-bool is_nd_blk(struct device *dev);
 bool is_nd_pmem(struct device *dev);
-struct nd_btt;
+bool is_nd_blk(struct device *dev);
 struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev);
 int __init nvdimm_bus_init(void);
 void nvdimm_bus_exit(void);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 78177a76a05d..d7fc6ef4e4d8 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -101,6 +101,15 @@ struct nd_region {
 	struct nd_mapping mapping[0];
 };
 
+struct nd_blk_region {
+	int (*enable)(struct nvdimm_bus *nvdimm_bus, struct device *dev);
+	void (*disable)(struct nvdimm_bus *nvdimm_bus, struct device *dev);
+	int (*do_io)(struct nd_blk_region *ndbr, resource_size_t dpa,
+			void *iobuf, u64 len, int rw);
+	void *blk_provider_data;
+	struct nd_region nd_region;
+};
+
 /*
  * Lookup next in the repeating sequence of 01, 10, and 11.
  */
@@ -170,8 +179,6 @@ static inline struct device *nd_btt_create(struct nd_region *nd_region)
 
 #endif
 struct nd_region *to_nd_region(struct device *dev);
-unsigned int nd_region_acquire_lane(struct nd_region *nd_region);
-void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane);
 int nd_region_to_nstype(struct nd_region *nd_region);
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
 u64 nd_region_interleave_set_cookie(struct nd_region *nd_region);
@@ -191,4 +198,6 @@ int nvdimm_namespace_attach_btt(struct nd_namespace_common *ndns);
 int nvdimm_namespace_detach_btt(struct nd_namespace_common *ndns);
 const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
 		char *name);
+int nd_blk_region_init(struct nd_region *nd_region);
+resource_size_t nd_namespace_blk_validate(struct nd_namespace_blk *nsblk);
 #endif /* __ND_H__ */
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index eb8aebcd4800..f28f78ccff19 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -18,11 +18,10 @@
 
 static int nd_region_probe(struct device *dev)
 {
-	int err;
+	int err, rc;
 	static unsigned long once;
 	struct nd_region_namespaces *num_ns;
 	struct nd_region *nd_region = to_nd_region(dev);
-	int rc = nd_region_register_namespaces(nd_region, &err);
 
 	if (nd_region->num_lanes > num_online_cpus()
 			&& nd_region->num_lanes < num_possible_cpus()
@@ -34,6 +33,11 @@ static int nd_region_probe(struct device *dev)
 				nd_region->num_lanes);
 	}
 
+	rc = nd_blk_region_init(nd_region);
+	if (rc)
+		return rc;
+
+	rc = nd_region_register_namespaces(nd_region, &err);
 	num_ns = devm_kzalloc(dev, sizeof(*num_ns), GFP_KERNEL);
 	if (!num_ns)
 		return -ENOMEM;
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index abf344651358..fb35d451016f 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -11,6 +11,7 @@
  * General Public License for more details.
  */
 #include <linux/scatterlist.h>
+#include <linux/highmem.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
@@ -34,7 +35,10 @@ static void nd_region_release(struct device *dev)
 	}
 	free_percpu(nd_region->lane);
 	ida_simple_remove(&region_ida, nd_region->id);
-	kfree(nd_region);
+	if (is_nd_blk(dev))
+		kfree(to_nd_blk_region(dev));
+	else
+		kfree(nd_region);
 }
 
 static struct device_type nd_blk_device_type = {
@@ -71,6 +75,33 @@ struct nd_region *to_nd_region(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(to_nd_region);
 
+struct nd_blk_region *to_nd_blk_region(struct device *dev)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+
+	WARN_ON(!is_nd_blk(dev));
+	return container_of(nd_region, struct nd_blk_region, nd_region);
+}
+EXPORT_SYMBOL_GPL(to_nd_blk_region);
+
+void *nd_region_provider_data(struct nd_region *nd_region)
+{
+	return nd_region->provider_data;
+}
+EXPORT_SYMBOL_GPL(nd_region_provider_data);
+
+void *nd_blk_region_provider_data(struct nd_blk_region *ndbr)
+{
+	return ndbr->blk_provider_data;
+}
+EXPORT_SYMBOL_GPL(nd_blk_region_provider_data);
+
+void nd_blk_region_set_provider_data(struct nd_blk_region *ndbr, void *data)
+{
+	ndbr->blk_provider_data = data;
+}
+EXPORT_SYMBOL_GPL(nd_blk_region_set_provider_data);
+
 /**
  * nd_region_to_nstype() - region to an integer namespace type
  * @nd_region: region-device to interrogate
@@ -365,7 +396,8 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region)
 /*
  * Upon successful probe/remove, take/release a reference on the
  * associated interleave set (if present), and plant new btt + namespace
- * seeds.
+ * seeds.  Also, on the removal of a BLK region, notify the provider to
+ * disable the region.
  */
 static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
 		struct device *dev, bool probe)
@@ -385,8 +417,14 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
 			nd_mapping->labels = NULL;
 			put_ndd(ndd);
 			nd_mapping->ndd = NULL;
-			atomic_dec(&nvdimm->busy);
+			if (ndd)
+				atomic_dec(&nvdimm->busy);
 		}
+
+		if (is_nd_pmem(dev))
+			return;
+
+		to_nd_blk_region(dev)->disable(nvdimm_bus, dev);
 	}
 	if (dev->parent && is_nd_blk(dev->parent) && probe) {
 		nd_region = to_nd_region(dev->parent);
@@ -526,11 +564,21 @@ struct attribute_group nd_mapping_attribute_group = {
 };
 EXPORT_SYMBOL_GPL(nd_mapping_attribute_group);
 
-void *nd_region_provider_data(struct nd_region *nd_region)
+int nd_blk_region_init(struct nd_region *nd_region)
 {
-	return nd_region->provider_data;
+	struct device *dev = &nd_region->dev;
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+
+	if (!is_nd_blk(dev))
+		return 0;
+
+	if (nd_region->ndr_mappings < 1) {
+		dev_err(dev, "invalid BLK region\n");
+		return -ENXIO;
+	}
+
+	return to_nd_blk_region(dev)->enable(nvdimm_bus, dev);
 }
-EXPORT_SYMBOL_GPL(nd_region_provider_data);
 
 /**
  * nd_region_acquire_lane - allocate and lock a lane
@@ -591,6 +639,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 {
 	struct nd_region *nd_region;
 	struct device *dev;
+	void *region_buf;
 	unsigned int i;
 
 	for (i = 0; i < ndr_desc->num_mappings; i++) {
@@ -605,10 +654,30 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 		}
 	}
 
-	nd_region = kzalloc(sizeof(struct nd_region)
-			+ sizeof(struct nd_mapping) * ndr_desc->num_mappings,
-			GFP_KERNEL);
-	if (!nd_region)
+	if (dev_type == &nd_blk_device_type) {
+		struct nd_blk_region_desc *ndbr_desc;
+		struct nd_blk_region *ndbr;
+
+		ndbr_desc = to_blk_region_desc(ndr_desc);
+		ndbr = kzalloc(sizeof(*ndbr) + sizeof(struct nd_mapping)
+				* ndr_desc->num_mappings,
+				GFP_KERNEL);
+		if (ndbr) {
+			nd_region = &ndbr->nd_region;
+			ndbr->enable = ndbr_desc->enable;
+			ndbr->disable = ndbr_desc->disable;
+			ndbr->do_io = ndbr_desc->do_io;
+		}
+		region_buf = ndbr;
+	} else {
+		nd_region = kzalloc(sizeof(struct nd_region)
+				+ sizeof(struct nd_mapping)
+				* ndr_desc->num_mappings,
+				GFP_KERNEL);
+		region_buf = nd_region;
+	}
+
+	if (!region_buf)
 		return NULL;
 	nd_region->id = ida_simple_get(&region_ida, 0, 0, GFP_KERNEL);
 	if (nd_region->id < 0)
@@ -653,7 +722,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
  err_percpu:
 	ida_simple_remove(&region_ida, nd_region->id);
  err_id:
-	kfree(nd_region);
+	kfree(region_buf);
 	return NULL;
 }
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 531d99dfac68..7fc1b25bdb5d 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -14,6 +14,7 @@
  */
 #ifndef __LIBNVDIMM_H__
 #define __LIBNVDIMM_H__
+#include <linux/kernel.h>
 #include <linux/sizes.h>
 #include <linux/types.h>
 
@@ -89,8 +90,24 @@ struct nd_region_desc {
 };
 
 struct nvdimm_bus;
-struct device;
 struct module;
+struct device;
+struct nd_blk_region;
+struct nd_blk_region_desc {
+	int (*enable)(struct nvdimm_bus *nvdimm_bus, struct device *dev);
+	void (*disable)(struct nvdimm_bus *nvdimm_bus, struct device *dev);
+	int (*do_io)(struct nd_blk_region *ndbr, resource_size_t dpa,
+			void *iobuf, u64 len, int rw);
+	struct nd_region_desc ndr_desc;
+};
+
+static inline struct nd_blk_region_desc *to_blk_region_desc(
+		struct nd_region_desc *ndr_desc)
+{
+	return container_of(ndr_desc, struct nd_blk_region_desc, ndr_desc);
+
+}
+
 struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
 		struct nvdimm_bus_descriptor *nfit_desc, struct module *module);
 #define nvdimm_bus_register(parent, desc) \
@@ -99,10 +116,10 @@ void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus);
 struct nvdimm_bus *to_nvdimm_bus(struct device *dev);
 struct nvdimm *to_nvdimm(struct device *dev);
 struct nd_region *to_nd_region(struct device *dev);
+struct nd_blk_region *to_nd_blk_region(struct device *dev);
 struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus);
 const char *nvdimm_name(struct nvdimm *nvdimm);
 void *nvdimm_provider_data(struct nvdimm *nvdimm);
-void *nd_region_provider_data(struct nd_region *nd_region);
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
 		unsigned long *dsm_mask);
@@ -120,5 +137,11 @@ struct nd_region *nvdimm_blk_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_region_desc *ndr_desc);
 struct nd_region *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_region_desc *ndr_desc);
+void *nd_region_provider_data(struct nd_region *nd_region);
+void *nd_blk_region_provider_data(struct nd_blk_region *ndbr);
+void nd_blk_region_set_provider_data(struct nd_blk_region *ndbr, void *data);
+struct nvdimm *nd_blk_region_to_dimm(struct nd_blk_region *ndbr);
+unsigned int nd_region_acquire_lane(struct nd_region *nd_region);
+void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane);
 u64 nd_fletcher64(void *addr, size_t len, bool le);
 #endif /* __LIBNVDIMM_H__ */

