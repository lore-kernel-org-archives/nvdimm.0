Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 20/20] libnd, nd_acpi,
 nd_blk: driver for BLK-mode access persistent memory
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Apr 2015 14:26:03 -0400
Message-ID: <20150428182602.35812.78599.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Boaz Harrosh <boaz@plexistor.com>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Ross Zwisler <ross.zwisler@linux.intel.com>

The libnd implementation handles allocating dimm address space (DPA)
between PMEM and BLK mode interfaces.  After DPA has been allocated from
a BLK-region to a BLK-namespace the nd_blk driver attaches to handle I/O
as a struct bio based block device. Unlike PMEM, BLK is required to
handle platform specific details like mmio register formats and memory
controller interleave.  For this reason the libnd generic nd_blk driver
calls back into the bus provider to carry out the I/O.

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
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/Kconfig          |   12 +
 drivers/block/nd/Makefile         |    3 
 drivers/block/nd/acpi.c           |  422 +++++++++++++++++++++++++++++++++++--
 drivers/block/nd/acpi_nfit.h      |   47 ++++
 drivers/block/nd/blk.c            |  264 +++++++++++++++++++++++
 drivers/block/nd/libnd.h          |   11 +
 drivers/block/nd/namespace_devs.c |   47 ++++
 drivers/block/nd/nd-private.h     |    3 
 drivers/block/nd/nd.h             |   16 +
 drivers/block/nd/region.c         |    8 +
 drivers/block/nd/region_devs.c    |   65 +++++-
 drivers/block/nd/test/nfit.c      |   29 +++
 drivers/block/nd/test/nfit_test.h |    2 
 13 files changed, 891 insertions(+), 38 deletions(-)
 create mode 100644 drivers/block/nd/blk.c

diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
index 612bf2b14283..bac4290129fc 100644
--- a/drivers/block/nd/Kconfig
+++ b/drivers/block/nd/Kconfig
@@ -95,6 +95,18 @@ config BLK_DEV_PMEM
 
 	  Say Y if you want to use a NVDIMM described by ACPI, E820, etc...
 
+config ND_BLK
+	tristate "BLK: Block data window (aperture) device support"
+	depends on LIBND
+	default ND_ACPI
+	help
+	  This driver performs I/O using a set of mmio windows on a
+	  dimm.  The set of apertures will all access the one DIMM.
+	  Multiple windows allow multiple threads to have a different
+	  portions of the dimm open at one time.
+
+	  Say Y if you want to use a NVDIMM with BLK-mode capability
+
 config ND_BTT_DEVS
 	bool
 
diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
index 7d778b4523d4..ef36927618e5 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_ND_E820) += nd_e820.o
 obj-$(CONFIG_NFIT_TEST) += test/
 obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
 obj-$(CONFIG_ND_BTT) += nd_btt.o
+obj-$(CONFIG_ND_BLK) += nd_blk.o
 
 nd_acpi-y := acpi.o
 
@@ -27,6 +28,8 @@ nd_pmem-y := pmem.o
 
 nd_btt-y := btt.o
 
+nd_blk-y := blk.o
+
 libnd-y := core.o
 libnd-y += bus.o
 libnd-y += dimm_devs.o
diff --git a/drivers/block/nd/acpi.c b/drivers/block/nd/acpi.c
index 5b9997fbc344..e4ff3a9b4fc1 100644
--- a/drivers/block/nd/acpi.c
+++ b/drivers/block/nd/acpi.c
@@ -12,12 +12,14 @@
  */
 #include <linux/list_sort.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/ndctl.h>
 #include <linux/list.h>
 #include <linux/acpi.h>
 #include <linux/sort.h>
 #include "acpi_nfit.h"
 #include "libnd.h"
+#include "nd.h"
 
 static bool warn_checksum;
 module_param(warn_checksum, bool, S_IRUGO|S_IWUSR);
@@ -84,7 +86,7 @@ static int nd_acpi_ctl(struct nd_bus_descriptor *nd_desc,
 
 		if (!adev)
 			return -ENOTTY;
-		dimm_name = dev_name(&adev->dev);
+		dimm_name = nd_dimm_name(nd_dimm);
 		cmd_name = nd_dimm_cmd_name(cmd);
 		dsm_mask = nfit_mem->dsm_mask;
 		desc = nd_cmd_dimm_desc(cmd);
@@ -301,10 +303,21 @@ static void *add_table(struct acpi_nfit_desc *acpi_desc, void *table, const void
 				bdw->dcr_index, bdw->num_bdw);
 		break;
 	}
-	/* TODO */
-	case NFIT_TABLE_IDT:
-		dev_dbg(dev, "%s: idt\n", __func__);
+	case NFIT_TABLE_IDT: {
+		struct nfit_idt *nfit_idt = devm_kzalloc(dev, sizeof(*nfit_idt),
+				GFP_KERNEL);
+		struct acpi_nfit_idt *idt = table;
+
+		if (!nfit_idt)
+			return err;
+		INIT_LIST_HEAD(&nfit_idt->list);
+		nfit_idt->idt = idt;
+		list_add_tail(&nfit_idt->list, &acpi_desc->idts);
+		dev_dbg(dev, "%s: idt index: %d num_lines: %d\n", __func__,
+				idt->idt_index, idt->num_lines);
 		break;
+	}
+	/* TODO */
 	case NFIT_TABLE_FLUSH:
 		dev_dbg(dev, "%s: flush\n", __func__);
 		break;
@@ -356,8 +369,11 @@ static int nfit_mem_add(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_mem *nfit_mem, struct acpi_nfit_spa *spa)
 {
 	u16 dcr_index = __to_nfit_memdev(nfit_mem)->dcr_index;
+	struct nfit_memdev *nfit_memdev;
 	struct nfit_dcr *nfit_dcr;
 	struct nfit_bdw *nfit_bdw;
+	struct nfit_idt *nfit_idt;
+	u16 idt_index, spa_index;
 
 	list_for_each_entry(nfit_dcr, &acpi_desc->dcrs, list) {
 		if (nfit_dcr->dcr->dcr_index != dcr_index)
@@ -390,6 +406,26 @@ static int nfit_mem_add(struct acpi_nfit_desc *acpi_desc,
 		return 0;
 
 	nfit_mem_find_spa_bdw(acpi_desc, nfit_mem);
+
+	if (!nfit_mem->spa_bdw)
+		return 0;
+
+	spa_index = nfit_mem->spa_bdw->spa_index;
+	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
+		if (nfit_memdev->memdev->spa_index != spa_index ||
+				nfit_memdev->memdev->dcr_index != dcr_index)
+			continue;
+		nfit_mem->memdev_bdw = nfit_memdev->memdev;
+		idt_index = nfit_memdev->memdev->idt_index;
+		list_for_each_entry(nfit_idt, &acpi_desc->idts, list) {
+			if (nfit_idt->idt->idt_index != idt_index)
+				continue;
+			nfit_mem->idt_bdw = nfit_idt->idt;
+			break;
+		}
+		break;
+	}
+
 	return 0;
 }
 
@@ -433,9 +469,19 @@ static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
 		}
 
 		if (type == NFIT_SPA_DCR) {
+			struct nfit_idt *nfit_idt;
+			u16 idt_index;
+
 			/* multiple dimms may share a SPA when interleaved */
 			nfit_mem->spa_dcr = spa;
 			nfit_mem->memdev_dcr = nfit_memdev->memdev;
+			idt_index = nfit_memdev->memdev->idt_index;
+			list_for_each_entry(nfit_idt, &acpi_desc->idts, list) {
+				if (nfit_idt->idt->idt_index != idt_index)
+					continue;
+				nfit_mem->idt_dcr = nfit_idt->idt;
+				break;
+			}
 		} else {
 			/*
 			 * A single dimm may belong to multiple SPA-PM
@@ -756,7 +802,7 @@ static ssize_t spa_index_show(struct device *dev,
                 struct device_attribute *attr, char *buf)
 {
         struct nd_region *nd_region = to_nd_region(dev);
-        struct nfit_spa *nfit_spa = nd_region_provider_data(nd_region);
+        struct nfit_spa *nfit_spa = nd_region->provider_data;
 
         return sprintf(buf, "%d\n", nfit_spa->spa->spa_index);
 }
@@ -864,13 +910,343 @@ static int nd_acpi_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 	return 0;
 }
 
+static u64 to_interleave_offset(u64 offset, struct nfit_blk_mmio *mmio)
+{
+	struct acpi_nfit_idt *idt = mmio->idt;
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
+/* len is <= PAGE_SIZE by this point, so it can be done in a single BW I/O */
+static int nd_acpi_blk_region_do_io(struct nd_blk_region *ndbr, void *iobuf,
+		unsigned int len, int write, resource_size_t dpa)
+{
+	struct nfit_blk *nfit_blk = ndbr->blk_provider_data;
+	struct nfit_blk_mmio *mmio = &nfit_blk->mmio[BDW];
+	struct nd_region *nd_region = &ndbr->nd_region;
+	unsigned int bw, copied = 0;
+	u64 base_offset;
+	int rc;
+
+	bw = nd_region_acquire_lane(nd_region);
+	base_offset = nfit_blk->bdw_offset + dpa % L1_CACHE_BYTES + bw * mmio->size;
+	/* TODO: non-temporal access, flush hints, cache management etc... */
+	write_blk_ctl(nfit_blk, bw, dpa, len, write);
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
+			c = min(len, mmio->line_size - line_offset);
+		} else {
+			offset = base_offset + nfit_blk->bdw_offset;
+			c = len;
+		}
+
+		if (write)
+			memcpy(mmio->base + offset, iobuf + copied, c);
+		else
+			memcpy(iobuf + copied, mmio->base + offset, c);
+
+		len -= c;
+		copied += c;
+	}
+	rc = read_blk_stat(nfit_blk, bw) ? -EIO : 0;
+	nd_region_release_lane(nd_region, bw);
+
+	return rc;
+}
+
+static void nfit_spa_mapping_release(struct kref *kref)
+{
+	struct nfit_spa_mapping *spa_map = to_spa_map(kref);
+	struct acpi_nfit_spa *spa = spa_map->spa;
+	struct acpi_nfit_desc *acpi_desc = spa_map->acpi_desc;
+
+	WARN_ON(!mutex_is_locked(&acpi_desc->spa_map_mutex));
+	dev_dbg(acpi_desc->dev, "%s: SPA%d\n", __func__, spa->spa_index);
+	iounmap(spa_map->iomem);
+	release_mem_region(spa->spa_base, spa->spa_length);
+	list_del(&spa_map->list);
+	kfree(spa_map);
+}
+
+static struct nfit_spa_mapping *find_spa_mapping(struct acpi_nfit_desc *acpi_desc,
+		struct acpi_nfit_spa *spa)
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
+		struct acpi_nfit_spa *spa)
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
+static void *__nfit_spa_map(struct acpi_nfit_desc *acpi_desc,
+		struct acpi_nfit_spa *spa)
+{
+	resource_size_t start = spa->spa_base;
+	resource_size_t n = spa->spa_length;
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
+ * nfit_spa_map - interleave-aware managed-mappings of acpi_nfit_spa ranges
+ * @nd_bus: NFIT-bus that provided the spa table entry
+ * @nfit_spa: spa table to map
+ *
+ * In the case where block-data-window apertures and
+ * dimm-control-regions are interleaved they will end up sharing a
+ * single request_mem_region() + ioremap() for the address range.  In
+ * the style of devm nfit_spa_map() mappings are automatically dropped
+ * when all region devices referencing the same mapping are disabled /
+ * unbound.
+ */
+static void *nfit_spa_map(struct acpi_nfit_desc *acpi_desc,
+		struct acpi_nfit_spa *spa)
+{
+	struct nfit_spa_mapping *spa_map;
+
+	mutex_lock(&acpi_desc->spa_map_mutex);
+	spa_map = __nfit_spa_map(acpi_desc, spa);
+	mutex_unlock(&acpi_desc->spa_map_mutex);
+
+	return spa_map;
+}
+
+static int nfit_blk_init_interleave(struct nfit_blk_mmio *mmio,
+		struct acpi_nfit_idt *idt, u16 interleave_ways)
+{
+	if (idt) {
+		mmio->num_lines = idt->num_lines;
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
+int nd_acpi_blk_region_enable(struct nd_bus *nd_bus, struct nd_blk_region *ndbr)
+{
+	struct nd_bus_descriptor *nd_desc = to_nd_desc(nd_bus);
+	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
+	struct nd_region *nd_region = &ndbr->nd_region;
+	struct nd_mapping *nd_mapping;
+	struct nfit_blk_mmio *mmio;
+	struct nfit_blk *nfit_blk;
+	struct nfit_mem *nfit_mem;
+	struct nd_dimm *nd_dimm;
+	int rc;
+
+	nd_mapping = &nd_region->mapping[0];
+	nd_dimm = nd_mapping->nd_dimm;
+	nfit_mem = nd_dimm_provider_data(nd_dimm);
+	if (!nfit_mem || !nfit_mem->dcr || !nfit_mem->bdw) {
+		dev_dbg(&nd_region->dev, "%s: missing%s%s%s\n", __func__,
+				nfit_mem ? "" : " nfit_mem",
+				nfit_mem->dcr ? "" : " dcr",
+				nfit_mem->bdw ? "" : " bdw");
+		return -ENXIO;
+	}
+
+	nfit_blk = devm_kzalloc(&nd_region->dev, sizeof(*nfit_blk), GFP_KERNEL);
+	if (!nfit_blk)
+		return -ENOMEM;
+	ndbr->blk_provider_data = nfit_blk;
+
+	/* map block aperture memory */
+	nfit_blk->bdw_offset = nfit_mem->bdw->bdw_offset;
+	mmio = &nfit_blk->mmio[BDW];
+	mmio->base = nfit_spa_map(acpi_desc, nfit_mem->spa_bdw);
+	if (!mmio->base) {
+		dev_dbg(&nd_region->dev, "%s: %s failed to map bdw\n", __func__,
+				nd_dimm_name(nd_dimm));
+		return -ENOMEM;
+	}
+	mmio->size = nfit_mem->bdw->bdw_size;
+	mmio->base_offset = nfit_mem->memdev_bdw->region_spa_offset;
+	mmio->idt = nfit_mem->idt_bdw;
+	mmio->spa = nfit_mem->spa_bdw;
+	rc = nfit_blk_init_interleave(mmio, nfit_mem->idt_bdw,
+			nfit_mem->memdev_bdw->interleave_ways);
+	if (rc) {
+		dev_dbg(&nd_region->dev, "%s: %s failed to init bdw interleave\n",
+				__func__, nd_dimm_name(nd_dimm));
+		return rc;
+	}
+
+	/* map block control memory */
+	nfit_blk->cmd_offset = nfit_mem->dcr->cmd_offset;
+	nfit_blk->stat_offset = nfit_mem->dcr->status_offset;
+	mmio = &nfit_blk->mmio[DCR];
+	mmio->base = nfit_spa_map(acpi_desc, nfit_mem->spa_dcr);
+	if (!mmio->base) {
+		dev_dbg(&nd_region->dev, "%s: %s failed to map dcr\n", __func__,
+				nd_dimm_name(nd_dimm));
+		return -ENOMEM;
+	}
+	mmio->size = nfit_mem->dcr->bcw_size;
+	mmio->base_offset = nfit_mem->memdev_dcr->region_spa_offset;
+	mmio->idt = nfit_mem->idt_dcr;
+	mmio->spa = nfit_mem->spa_dcr;
+	rc = nfit_blk_init_interleave(mmio, nfit_mem->idt_dcr,
+			nfit_mem->memdev_dcr->interleave_ways);
+	if (rc) {
+		dev_dbg(&nd_region->dev, "%s: %s failed to init dcr interleave\n",
+				__func__, nd_dimm_name(nd_dimm));
+		return rc;
+	}
+
+	if (mmio->line_size == 0)
+		return 0;
+
+	if ((u32) nfit_blk->cmd_offset % mmio->line_size + 8 > mmio->line_size) {
+		dev_dbg(&nd_region->dev,
+				"cmd_offset crosses interleave boundary\n");
+		return -ENXIO;
+	} else if ((u32) nfit_blk->stat_offset % mmio->line_size + 8 > mmio->line_size) {
+		dev_dbg(&nd_region->dev,
+				"stat_offset crosses interleave boundary\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static void nd_acpi_blk_region_disable(struct nd_bus *nd_bus,
+		struct nd_blk_region *ndbr)
+{
+	struct nd_bus_descriptor *nd_desc = to_nd_desc(nd_bus);
+	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
+	struct nfit_blk *nfit_blk = ndbr->blk_provider_data;
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
+	ndbr->blk_provider_data = NULL;
+	/* devm will free nfit_blk */
+}
+
 static int nd_acpi_register_region(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_spa *nfit_spa)
 {
 	static struct nd_mapping nd_mappings[ND_MAX_MAPPINGS];
 	struct acpi_nfit_spa *spa = nfit_spa->spa;
+	struct nd_blk_region_desc ndbr_desc;
+	struct nd_region_desc *ndr_desc;
 	struct nfit_memdev *nfit_memdev;
-	struct nd_region_desc ndr_desc;
 	int spa_type, count = 0, rc;
 	struct resource res;
 	u16 spa_index;
@@ -885,12 +1261,13 @@ static int nd_acpi_register_region(struct acpi_nfit_desc *acpi_desc,
 
 	memset(&res, 0, sizeof(res));
 	memset(&nd_mappings, 0, sizeof(nd_mappings));
-	memset(&ndr_desc, 0, sizeof(ndr_desc));
+	memset(&ndbr_desc, 0, sizeof(ndr_desc));
 	res.start = spa->spa_base;
 	res.end = res.start + spa->spa_length - 1;
-	ndr_desc.res = &res;
-	ndr_desc.provider_data = nfit_spa;
-	ndr_desc.attr_groups = nd_acpi_region_attribute_groups;
+	ndr_desc = &ndbr_desc.ndr_desc;
+	ndr_desc->res = &res;
+	ndr_desc->provider_data = nfit_spa;
+	ndr_desc->attr_groups = nd_acpi_region_attribute_groups;
 	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
 		struct acpi_nfit_memdev *memdev = nfit_memdev->memdev;
 		struct nd_mapping *nd_mapping;
@@ -926,26 +1303,29 @@ static int nd_acpi_register_region(struct acpi_nfit_desc *acpi_desc,
 			} else {
 				nd_mapping->size = nfit_mem->bdw->blk_capacity;
 				nd_mapping->start = nfit_mem->bdw->blk_offset;
-				ndr_desc.num_lanes = nfit_mem->bdw->num_bdw;
+				ndr_desc->num_lanes = nfit_mem->bdw->num_bdw;
 			}
 
-			ndr_desc.nd_mapping = nd_mapping;
-			ndr_desc.num_mappings = blk_valid;
-			if (!nd_blk_region_create(acpi_desc->nd_bus, &ndr_desc))
+			ndr_desc->nd_mapping = nd_mapping;
+			ndr_desc->num_mappings = blk_valid;
+			ndbr_desc.enable = nd_acpi_blk_region_enable;
+			ndbr_desc.disable = nd_acpi_blk_region_disable;
+			ndbr_desc.do_io = acpi_desc->blk_do_io;
+			if (!nd_blk_region_create(acpi_desc->nd_bus, ndr_desc))
 				return -ENOMEM;
 		}
 	}
 
-	ndr_desc.nd_mapping = nd_mappings;
-	ndr_desc.num_mappings = count;
-	rc = nd_acpi_init_interleave_set(acpi_desc, &ndr_desc, spa);
+	ndr_desc->nd_mapping = nd_mappings;
+	ndr_desc->num_mappings = count;
+	rc = nd_acpi_init_interleave_set(acpi_desc, ndr_desc, spa);
 	if (rc)
 		return rc;
 	if (spa_type == NFIT_SPA_PM) {
-		if (!nd_pmem_region_create(acpi_desc->nd_bus, &ndr_desc))
+		if (!nd_pmem_region_create(acpi_desc->nd_bus, ndr_desc))
 			return -ENOMEM;
 	} else if (spa_type == NFIT_SPA_VOLATILE) {
-		if (!nd_volatile_region_create(acpi_desc->nd_bus, &ndr_desc))
+		if (!nd_volatile_region_create(acpi_desc->nd_bus, ndr_desc))
 			return -ENOMEM;
 	}
 	return 0;
@@ -972,11 +1352,14 @@ int nd_acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 	acpi_size i;
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
 	for (i = 0, sum = 0; i < sz; i++)
@@ -1035,6 +1418,7 @@ static int nd_acpi_add(struct acpi_device *adev)
 	dev_set_drvdata(dev, acpi_desc);
 	acpi_desc->dev = dev;
 	acpi_desc->nfit = (struct acpi_nfit *) tbl;
+	acpi_desc->blk_do_io = nd_acpi_blk_region_do_io;
 	nd_desc = &acpi_desc->nd_desc;
 	nd_desc->provider_name = "ACPI.NFIT";
 	nd_desc->ndctl = nd_acpi_ctl;
diff --git a/drivers/block/nd/acpi_nfit.h b/drivers/block/nd/acpi_nfit.h
index 2faac336c07d..a40128507551 100644
--- a/drivers/block/nd/acpi_nfit.h
+++ b/drivers/block/nd/acpi_nfit.h
@@ -226,6 +226,11 @@ struct nfit_bdw {
 	struct list_head list;
 };
 
+struct nfit_idt {
+	struct acpi_nfit_idt *idt;
+	struct list_head list;
+};
+
 struct nfit_memdev {
 	struct acpi_nfit_memdev *memdev;
 	struct list_head list;
@@ -236,10 +241,13 @@ struct nfit_mem {
 	struct nd_dimm *nd_dimm;
 	struct acpi_nfit_memdev *memdev_dcr;
 	struct acpi_nfit_memdev *memdev_pmem;
+	struct acpi_nfit_memdev *memdev_bdw;
 	struct acpi_nfit_dcr *dcr;
 	struct acpi_nfit_bdw *bdw;
 	struct acpi_nfit_spa *spa_dcr;
 	struct acpi_nfit_spa *spa_bdw;
+	struct acpi_nfit_idt *idt_dcr;
+	struct acpi_nfit_idt *idt_bdw;
 	struct list_head list;
 	struct acpi_device *adev;
 	unsigned long dsm_mask;
@@ -248,16 +256,55 @@ struct nfit_mem {
 struct acpi_nfit_desc {
 	struct nd_bus_descriptor nd_desc;
 	struct acpi_nfit *nfit;
+	struct mutex spa_map_mutex;
+	struct list_head spa_maps;
 	struct list_head memdevs;
 	struct list_head dimms;
 	struct list_head spas;
 	struct list_head dcrs;
 	struct list_head bdws;
+	struct list_head idts;
 	struct nd_bus *nd_bus;
 	struct device *dev;
 	unsigned long dimm_dsm_force_en;
+	int (*blk_do_io)(struct nd_blk_region *ndbr, void *iobuf,
+			unsigned int len, int write, resource_size_t dpa);
+};
+
+enum nd_blk_mmio_selector {
+	BDW,
+	DCR,
+};
+
+struct nfit_blk {
+	struct nfit_blk_mmio {
+		void *base;
+		u64 size;
+		u64 base_offset;
+		u32 line_size;
+		u32 num_lines;
+		u32 table_size;
+		struct acpi_nfit_idt *idt;
+		struct acpi_nfit_spa *spa;
+	} mmio[2];
+	u64 bdw_offset; /* post interleave offset */
+	u64 stat_offset;
+	u64 cmd_offset;
 };
 
+struct nfit_spa_mapping {
+	struct acpi_nfit_desc *acpi_desc;
+	struct acpi_nfit_spa *spa;
+	struct list_head list;
+	struct kref kref;
+	void *iomem;
+};
+
+static inline struct nfit_spa_mapping *to_spa_map(struct kref *kref)
+{
+	return container_of(kref, struct nfit_spa_mapping, kref);
+}
+
 static inline struct acpi_nfit_memdev *__to_nfit_memdev(struct nfit_mem *nfit_mem)
 {
 	if (nfit_mem->memdev_dcr)
diff --git a/drivers/block/nd/blk.c b/drivers/block/nd/blk.c
new file mode 100644
index 000000000000..8536ee8b2009
--- /dev/null
+++ b/drivers/block/nd/blk.c
@@ -0,0 +1,264 @@
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
+	struct nd_io ndio;
+	size_t disk_size;
+	int id;
+};
+
+static int nd_blk_major;
+static DEFINE_IDA(nd_blk_ida);
+
+static resource_size_t to_dev_offset(struct nd_namespace_blk *nsblk,
+				resource_size_t ns_offset, unsigned int len)
+{
+	int i;
+
+	for (i = 0; i < nsblk->num_resources; i++) {
+		if (ns_offset < resource_size(nsblk->res[i])) {
+			if (ns_offset + len > resource_size(nsblk->res[i])) {
+				dev_WARN_ONCE(&nsblk->dev, 1,
+					"%s: illegal request\n", __func__);
+				return SIZE_MAX;
+			}
+			return nsblk->res[i]->start + ns_offset;
+		}
+		ns_offset -= resource_size(nsblk->res[i]);
+	}
+
+	dev_WARN_ONCE(&nsblk->dev, 1, "%s: request out of range\n", __func__);
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
+	sector_t sector;
+
+	sector = bio->bi_iter.bi_sector;
+	if (bio_end_sector(bio) > get_capacity(disk)) {
+		err = -EIO;
+		goto out;
+	}
+
+	BUG_ON(bio->bi_rw & REQ_DISCARD);
+
+	rw = bio_data_dir(bio);
+
+	blk_dev = disk->private_data;
+	nsblk = blk_dev->nsblk;
+	ndbr = blk_dev->ndbr;
+	bio_for_each_segment(bvec, bio, iter) {
+		unsigned int len = bvec.bv_len;
+		resource_size_t	dev_offset;
+		void *iobuf;
+
+		BUG_ON(len > PAGE_SIZE);
+
+		dev_offset = to_dev_offset(nsblk, sector << SECTOR_SHIFT, len);
+		if (dev_offset == SIZE_MAX) {
+			err = -EIO;
+			goto out;
+		}
+
+		iobuf = kmap_atomic(bvec.bv_page);
+		err = ndbr->do_io(ndbr, iobuf + bvec.bv_offset, len, rw, dev_offset);
+		kunmap_atomic(iobuf);
+		if (err)
+			goto out;
+
+		sector += len >> SECTOR_SHIFT;
+	}
+
+ out:
+	bio_endio(bio, err);
+}
+
+static int nd_blk_rw_bytes(struct nd_io *ndio, void *iobuf, size_t offset,
+		size_t n, unsigned long flags)
+{
+	struct nd_namespace_blk *nsblk;
+	struct nd_blk_device *blk_dev;
+	int rw = nd_data_dir(flags);
+	struct nd_blk_region *ndbr;
+	resource_size_t	dev_offset;
+
+	blk_dev = container_of(ndio, typeof(*blk_dev), ndio);
+	ndbr = blk_dev->ndbr;
+	nsblk = blk_dev->nsblk;
+	dev_offset = to_dev_offset(nsblk, offset, n);
+
+	if (unlikely(offset + n > blk_dev->disk_size)) {
+		dev_WARN_ONCE(ndio->dev, 1, "%s: request out of range\n",
+				__func__);
+		return -EFAULT;
+	}
+
+	if (dev_offset == SIZE_MAX)
+		return -EIO;
+
+	return ndbr->do_io(ndbr, iobuf, n, rw, dev_offset);
+}
+
+static const struct block_device_operations nd_blk_fops = {
+	.owner =		THIS_MODULE,
+};
+
+static int nd_blk_probe(struct device *dev)
+{
+	struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+	struct nd_blk_device *blk_dev;
+	resource_size_t disk_size;
+	struct gendisk *disk;
+	int err;
+
+	disk_size = nd_namespace_blk_validate(nsblk);
+	if (disk_size < ND_MIN_NAMESPACE_SIZE)
+		return -ENXIO;
+
+	blk_dev = kzalloc(sizeof(*blk_dev), GFP_KERNEL);
+	if (!blk_dev)
+		return -ENOMEM;
+
+	blk_dev->id = ida_simple_get(&nd_blk_ida, 0, 0, GFP_KERNEL);
+	if (blk_dev->id < 0) {
+		err = blk_dev->id;
+		goto err_ida;
+	}
+
+	blk_dev->disk_size	= disk_size;
+
+	blk_dev->queue = blk_alloc_queue(GFP_KERNEL);
+	if (!blk_dev->queue) {
+		err = -ENOMEM;
+		goto err_alloc_queue;
+	}
+
+	blk_queue_make_request(blk_dev->queue, nd_blk_make_request);
+	blk_queue_max_hw_sectors(blk_dev->queue, 1024);
+	blk_queue_bounce_limit(blk_dev->queue, BLK_BOUNCE_ANY);
+
+	disk = blk_dev->disk = alloc_disk(0);
+	if (!disk) {
+		err = -ENOMEM;
+		goto err_alloc_disk;
+	}
+
+	blk_dev->ndbr = to_blk_region(to_nd_region(nsblk->dev.parent));
+	blk_dev->nsblk = nsblk;
+
+	disk->driverfs_dev	= dev;
+	disk->major		= nd_blk_major;
+	disk->first_minor	= 0;
+	disk->fops		= &nd_blk_fops;
+	disk->private_data	= blk_dev;
+	disk->queue		= blk_dev->queue;
+	disk->flags		= GENHD_FL_EXT_DEVT;
+	sprintf(disk->disk_name, "ndblk%d", blk_dev->id);
+	set_capacity(disk, disk_size >> SECTOR_SHIFT);
+
+	nd_bus_lock(dev);
+	dev_set_drvdata(dev, blk_dev);
+
+	add_disk(disk);
+	nd_init_ndio(&blk_dev->ndio, nd_blk_rw_bytes, dev, disk, 0);
+	nd_register_ndio(&blk_dev->ndio);
+	nd_bus_unlock(dev);
+
+	return 0;
+
+ err_alloc_disk:
+	blk_cleanup_queue(blk_dev->queue);
+ err_alloc_queue:
+	ida_simple_remove(&nd_blk_ida, blk_dev->id);
+ err_ida:
+	kfree(blk_dev);
+	return err;
+}
+
+static int nd_blk_remove(struct device *dev)
+{
+	/* FIXME: eventually need to get to nd_blk_device from struct device.
+	struct nd_namespace_io *nsio = to_nd_namespace_io(dev); */
+
+	struct nd_blk_device *blk_dev = dev_get_drvdata(dev);
+
+	nd_unregister_ndio(&blk_dev->ndio);
+	del_gendisk(blk_dev->disk);
+	put_disk(blk_dev->disk);
+	blk_cleanup_queue(blk_dev->queue);
+	ida_simple_remove(&nd_blk_ida, blk_dev->id);
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
diff --git a/drivers/block/nd/libnd.h b/drivers/block/nd/libnd.h
index e188840ed2b9..40373caf6d04 100644
--- a/drivers/block/nd/libnd.h
+++ b/drivers/block/nd/libnd.h
@@ -80,6 +80,16 @@ struct nd_region_desc {
 };
 
 struct nd_bus;
+struct nd_blk_region;
+struct nd_blk_region_desc {
+	int (*enable)(struct nd_bus *nd_bus, struct nd_blk_region *ndbr);
+	void (*disable)(struct nd_bus *nd_bus, struct nd_blk_region *ndbr);
+	int (*do_io)(struct nd_blk_region *ndbr, void *iobuf, unsigned int len,
+			int write, resource_size_t dpa);
+	struct nd_region_desc ndr_desc;
+};
+
+struct nd_bus;
 struct nd_bus *__nd_bus_register(struct device *parent,
 		struct nd_bus_descriptor *nfit_desc, struct module *module);
 #define nd_bus_register(parent, desc) \
@@ -91,7 +101,6 @@ struct nd_region *to_nd_region(struct device *dev);
 struct nd_bus_descriptor *to_nd_desc(struct nd_bus *nd_bus);
 const char *nd_dimm_name(struct nd_dimm *nd_dimm);
 void *nd_dimm_provider_data(struct nd_dimm *nd_dimm);
-void *nd_region_provider_data(struct nd_region *nd_region);
 struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
 		unsigned long *dsm_mask);
diff --git a/drivers/block/nd/namespace_devs.c b/drivers/block/nd/namespace_devs.c
index 4dc499758636..2a4d28867c58 100644
--- a/drivers/block/nd/namespace_devs.c
+++ b/drivers/block/nd/namespace_devs.c
@@ -151,6 +151,53 @@ static resource_size_t nd_namespace_blk_size(struct nd_namespace_blk *nsblk)
 	return size;
 }
 
+resource_size_t nd_namespace_blk_validate(struct nd_namespace_blk *nsblk)
+{
+	struct nd_region *nd_region = to_nd_region(nsblk->dev.parent);
+	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct nd_label_id label_id;
+	struct resource *res;
+	int count, i;
+
+	if (!nsblk->uuid || !nsblk->lbasize)
+		return 0;
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
+			return 0;
+		count++;
+	}
+
+	/* These values match after a successful label update */
+	if (count != nsblk->num_resources)
+		return 0;
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
+			return 0;
+	}
+
+	return nd_namespace_blk_size(nsblk);
+}
+EXPORT_SYMBOL(nd_namespace_blk_validate);
+
 static int nd_namespace_label_update(struct nd_region *nd_region, struct device *dev)
 {
 	dev_WARN_ONCE(dev, dev->driver,
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index 68e9ec824dc8..a9eb4da240a6 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -22,7 +22,6 @@ extern struct list_head nd_bus_list;
 extern struct mutex nd_bus_list_mutex;
 extern int nd_dimm_major;
 
-struct block_device;
 struct nd_io_claim;
 struct nd_btt;
 struct nd_io;
@@ -50,8 +49,8 @@ struct nd_dimm {
 
 struct nd_io *ndio_lookup(struct nd_bus *nd_bus, const char *diskname);
 bool is_nd_dimm(struct device *dev);
-bool is_nd_blk(struct device *dev);
 bool is_nd_pmem(struct device *dev);
+bool is_nd_blk(struct device *dev);
 #if IS_ENABLED(CONFIG_ND_BTT_DEVS)
 bool is_nd_btt(struct device *dev);
 struct nd_btt *nd_btt_create(struct nd_bus *nd_bus);
diff --git a/drivers/block/nd/nd.h b/drivers/block/nd/nd.h
index a29fb7409925..9c5a48fce0f2 100644
--- a/drivers/block/nd/nd.h
+++ b/drivers/block/nd/nd.h
@@ -113,6 +113,20 @@ struct nd_region {
 	struct nd_mapping mapping[0];
 };
 
+struct nd_blk_region {
+	int (*enable)(struct nd_bus *nd_bus, struct nd_blk_region *ndbr);
+	void (*disable)(struct nd_bus *nd_bus, struct nd_blk_region *ndbr);
+	int (*do_io)(struct nd_blk_region *ndbr, void *iobuf, unsigned int len,
+			int write, resource_size_t dpa);
+	void *blk_provider_data;
+	struct nd_region nd_region;
+};
+
+static inline struct nd_blk_region *to_blk_region(struct nd_region *nd_region)
+{
+	return container_of(nd_region, struct nd_blk_region, nd_region);
+}
+
 /*
  * Lookup next in the repeating sequence of 01, 10, and 11.
  */
@@ -242,4 +256,6 @@ void nd_bus_unlock(struct device *dev);
 bool is_nd_bus_locked(struct device *dev);
 int nd_label_reserve_dpa(struct nd_dimm_drvdata *ndd);
 void nd_dimm_free_dpa(struct nd_dimm_drvdata *ndd, struct resource *res);
+int nd_blk_region_init(struct nd_region *nd_region);
+resource_size_t nd_namespace_blk_validate(struct nd_namespace_blk *nsblk);
 #endif /* __ND_H__ */
diff --git a/drivers/block/nd/region.c b/drivers/block/nd/region.c
index dd5a885cea11..442fbd25631c 100644
--- a/drivers/block/nd/region.c
+++ b/drivers/block/nd/region.c
@@ -83,11 +83,15 @@ EXPORT_SYMBOL(nd_region_release_lane);
 
 static int nd_region_probe(struct device *dev)
 {
-	int err;
+	int err, rc;
 	struct nd_region_namespaces *num_ns;
 	struct nd_region *nd_region = to_nd_region(dev);
-	int rc = nd_region_register_namespaces(nd_region, &err);
 
+	rc = nd_blk_region_init(nd_region);
+	if (rc)
+		return rc;
+
+	rc = nd_region_register_namespaces(nd_region, &err);
 	num_ns = devm_kzalloc(dev, sizeof(*num_ns), GFP_KERNEL);
 	if (!num_ns)
 		return -ENOMEM;
diff --git a/drivers/block/nd/region_devs.c b/drivers/block/nd/region_devs.c
index 268d9ef67f9c..b1fb63d0deb9 100644
--- a/drivers/block/nd/region_devs.c
+++ b/drivers/block/nd/region_devs.c
@@ -11,6 +11,7 @@
  * General Public License for more details.
  */
 #include <linux/scatterlist.h>
+#include <linux/highmem.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
@@ -33,7 +34,10 @@ static void nd_region_release(struct device *dev)
 		put_device(&nd_dimm->dev);
 	}
 	ida_simple_remove(&region_ida, nd_region->id);
-	kfree(nd_region);
+	if (is_nd_blk(dev))
+		kfree(to_blk_region(nd_region));
+	else
+		kfree(nd_region);
 }
 
 static struct device_type nd_blk_device_type = {
@@ -339,27 +343,33 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region)
 
 /*
  * Upon successful probe/remove, take/release a reference on the
- * associated interleave set (if present)
+ * associated dimms in the interleave set, on successful probe of a BLK
+ * namespace check if we need a new seed, and on remove or failed probe
+ * of a BLK region notify the provider to disable the region.
  */
 static void nd_region_notify_driver_action(struct nd_bus *nd_bus,
 		struct device *dev, int rc, bool probe)
 {
-	if (rc)
-		return;
-
 	if (is_nd_pmem(dev) || is_nd_blk(dev)) {
 		struct nd_region *nd_region = to_nd_region(dev);
+		struct nd_blk_region *nd_blk_region;
 		int i;
 
 		for (i = 0; i < nd_region->ndr_mappings; i++) {
 			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 			struct nd_dimm *nd_dimm = nd_mapping->nd_dimm;
 
-			if (probe)
+			if (probe && rc == 0)
 				atomic_inc(&nd_dimm->busy);
-			else
+			else if (!probe)
 				atomic_dec(&nd_dimm->busy);
 		}
+
+		if (is_nd_pmem(dev) || (probe && rc == 0))
+			return;
+
+		nd_blk_region = to_blk_region(nd_region);
+		nd_blk_region->disable(nd_bus, nd_blk_region);
 	} else if (dev->parent && is_nd_blk(dev->parent) && probe && rc == 0) {
 		struct nd_region *nd_region = to_nd_region(dev->parent);
 
@@ -503,11 +513,21 @@ struct attribute_group nd_mapping_attribute_group = {
 };
 EXPORT_SYMBOL_GPL(nd_mapping_attribute_group);
 
-void *nd_region_provider_data(struct nd_region *nd_region)
+int nd_blk_region_init(struct nd_region *nd_region)
 {
-	return nd_region->provider_data;
+	struct nd_blk_region *ndbr = to_blk_region(nd_region);
+	struct nd_bus *nd_bus = walk_to_nd_bus(&nd_region->dev);
+
+	if (!is_nd_blk(&nd_region->dev))
+		return 0;
+
+	if (nd_region->ndr_mappings < 1) {
+		dev_err(&nd_region->dev, "invalid BLK region\n");
+		return -ENXIO;
+	}
+
+	return ndbr->enable(nd_bus, ndbr);
 }
-EXPORT_SYMBOL_GPL(nd_region_provider_data);
 
 static noinline struct nd_region *nd_region_create(struct nd_bus *nd_bus,
 		struct nd_region_desc *ndr_desc, struct device_type *dev_type)
@@ -529,9 +549,28 @@ static noinline struct nd_region *nd_region_create(struct nd_bus *nd_bus,
 		}
 	}
 
-	nd_region = kzalloc(sizeof(struct nd_region)
-			+ sizeof(struct nd_mapping) * ndr_desc->num_mappings,
-			GFP_KERNEL);
+	if (dev_type == &nd_blk_device_type) {
+		struct nd_blk_region_desc *ndbr_desc;
+		struct nd_blk_region *ndbr;
+
+		ndbr_desc = container_of(ndr_desc, typeof(*ndbr_desc), ndr_desc);
+		ndbr = kzalloc(sizeof(*ndbr) + sizeof(struct nd_mapping)
+				* ndr_desc->num_mappings,
+				GFP_KERNEL);
+		if (ndbr) {
+			nd_region = &ndbr->nd_region;
+			ndbr->enable = ndbr_desc->enable;
+			ndbr->disable = ndbr_desc->disable;
+			ndbr->do_io = ndbr_desc->do_io;
+		} else
+			nd_region = NULL;
+	} else {
+		nd_region = kzalloc(sizeof(struct nd_region)
+				+ sizeof(struct nd_mapping)
+				* ndr_desc->num_mappings,
+				GFP_KERNEL);
+	}
+
 	if (!nd_region)
 		return NULL;
 	nd_region->id = ida_simple_get(&region_ida, 0, 0, GFP_KERNEL);
diff --git a/drivers/block/nd/test/nfit.c b/drivers/block/nd/test/nfit.c
index 50916f0ca901..ea4b2063f2c3 100644
--- a/drivers/block/nd/test/nfit.c
+++ b/drivers/block/nd/test/nfit.c
@@ -13,6 +13,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
+#include <linux/device.h>
 #include <linux/module.h>
 #include <linux/ndctl.h>
 #include <linux/sizes.h>
@@ -21,6 +22,7 @@
 
 #include "../acpi_nfit.h"
 #include "../libnd.h"
+#include "../nd.h"
 
 /*
  * Generate an NFIT table to describe the following topology:
@@ -907,6 +909,32 @@ static void nfit_test1_setup(struct nfit_test *t)
 	nfit->checksum = nfit_checksum(nfit_buf, size);
 }
 
+static int nfit_test_blk_do_io(struct nd_blk_region *ndbr, void *iobuf,
+                unsigned int len, int rw, resource_size_t dpa)
+{
+	struct nfit_blk *nfit_blk = ndbr->blk_provider_data;
+	struct nfit_blk_mmio *mmio = &nfit_blk->mmio[BDW];
+	struct nd_region *nd_region = &ndbr->nd_region;
+        struct nfit_test_resource *nfit_res;
+	unsigned int bw;
+
+        nfit_res = nfit_test_lookup((unsigned long) mmio->base);
+        if (!nfit_res) {
+		dev_WARN_ONCE(&nd_region->dev, 1, "no test resource\n");
+		return -EIO;
+	}
+	dev_vdbg(&nd_region->dev, "%s: base: %p offset: %pa\n",
+			__func__, mmio->base, &dpa);
+	bw = nd_region_acquire_lane(nd_region);
+	if (rw)
+		memcpy(nfit_res->buf + dpa, iobuf, len);
+	else
+		memcpy(iobuf, nfit_res->buf + dpa, len);
+	nd_region_release_lane(nd_region, bw);
+
+        return 0;
+}
+
 extern const struct attribute_group *nd_acpi_attribute_groups[];
 
 static int nfit_test_probe(struct platform_device *pdev)
@@ -957,6 +985,7 @@ static int nfit_test_probe(struct platform_device *pdev)
 	acpi_desc = &nfit_test->acpi_desc;
 	acpi_desc->dev = &pdev->dev;
 	acpi_desc->nfit = nfit_test->nfit_buf;
+	acpi_desc->blk_do_io = nfit_test_blk_do_io;
 	nd_desc = &acpi_desc->nd_desc;
 	nd_desc->attr_groups = nd_acpi_attribute_groups;
 	acpi_desc->nd_bus = nd_bus_register(&pdev->dev, nd_desc);
diff --git a/drivers/block/nd/test/nfit_test.h b/drivers/block/nd/test/nfit_test.h
index 7b071478eb94..30423b5b4b6f 100644
--- a/drivers/block/nd/test/nfit_test.h
+++ b/drivers/block/nd/test/nfit_test.h
@@ -21,6 +21,6 @@ struct nfit_test_resource {
 };
 
 typedef struct nfit_test_resource *(*nfit_test_lookup_fn)(resource_size_t);
-void nfit_test_setup(nfit_test_lookup_fn fn);
+void nfit_test_setup(nfit_test_lookup_fn lookup);
 void nfit_test_teardown(void);
 #endif

