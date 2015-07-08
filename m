Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/3] nfit: update block I/O path to use PMEM API
Date: Wed,  8 Jul 2015 10:00:20 -0600
Message-Id: <1436371221-30296-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1436371221-30296-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1436371221-30296-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Dan Williams <dan.j.williams@intel.com>, Len Brown <lenb@kernel.org>, Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

Update the nfit block I/O path to use the new PMEM API and to adhere to
the read/write flows outlined in the "NVDIMM Block Window Driver
Writer's Guide":

http://pmem.io/documents/NVDIMM_Driver_Writers_Guide.pdf

This includes adding support for targeted NVDIMM flushes called "flush
hints" in the ACPI 6.0 specification:

http://www.uefi.org/sites/default/files/resources/ACPI_6.0.pdf

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/nfit.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/acpi/nfit.h | 10 ++++++-
 2 files changed, 86 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index a20b7c883ca0..b3c446412f61 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -18,6 +18,7 @@
 #include <linux/list.h>
 #include <linux/acpi.h>
 #include <linux/sort.h>
+#include <linux/pmem.h>
 #include <linux/io.h>
 #include "nfit.h"
 
@@ -305,6 +306,23 @@ static bool add_idt(struct acpi_nfit_desc *acpi_desc,
 	return true;
 }
 
+static bool add_flush(struct acpi_nfit_desc *acpi_desc,
+		struct acpi_nfit_flush_address *flush)
+{
+	struct device *dev = acpi_desc->dev;
+	struct nfit_flush *nfit_flush = devm_kzalloc(dev, sizeof(*nfit_flush),
+			GFP_KERNEL);
+
+	if (!nfit_flush)
+		return false;
+	INIT_LIST_HEAD(&nfit_flush->list);
+	nfit_flush->flush = flush;
+	list_add_tail(&nfit_flush->list, &acpi_desc->flushes);
+	dev_dbg(dev, "%s: nfit_flush handle: %d hint_count: %d\n", __func__,
+			flush->device_handle, flush->hint_count);
+	return true;
+}
+
 static void *add_table(struct acpi_nfit_desc *acpi_desc, void *table,
 		const void *end)
 {
@@ -338,7 +356,8 @@ static void *add_table(struct acpi_nfit_desc *acpi_desc, void *table,
 			return err;
 		break;
 	case ACPI_NFIT_TYPE_FLUSH_ADDRESS:
-		dev_dbg(dev, "%s: flush\n", __func__);
+		if (!add_flush(acpi_desc, table))
+			return err;
 		break;
 	case ACPI_NFIT_TYPE_SMBIOS:
 		dev_dbg(dev, "%s: smbios\n", __func__);
@@ -389,6 +408,7 @@ static int nfit_mem_add(struct acpi_nfit_desc *acpi_desc,
 {
 	u16 dcr = __to_nfit_memdev(nfit_mem)->region_index;
 	struct nfit_memdev *nfit_memdev;
+	struct nfit_flush *nfit_flush;
 	struct nfit_dcr *nfit_dcr;
 	struct nfit_bdw *nfit_bdw;
 	struct nfit_idt *nfit_idt;
@@ -442,6 +462,14 @@ static int nfit_mem_add(struct acpi_nfit_desc *acpi_desc,
 			nfit_mem->idt_bdw = nfit_idt->idt;
 			break;
 		}
+
+		list_for_each_entry(nfit_flush, &acpi_desc->flushes, list) {
+			if (nfit_flush->flush->device_handle !=
+					nfit_memdev->memdev->device_handle)
+				continue;
+			nfit_mem->nfit_flush = nfit_flush;
+			break;
+		}
 		break;
 	}
 
@@ -978,6 +1006,24 @@ static u64 to_interleave_offset(u64 offset, struct nfit_blk_mmio *mmio)
 	return mmio->base_offset + line_offset + table_offset + sub_line_offset;
 }
 
+static void wmb_blk(struct nfit_blk *nfit_blk)
+{
+
+	if (nfit_blk->nvdimm_flush) {
+		/*
+		 * The first wmb() is needed to 'sfence' all previous writes
+		 * such that they are architecturally visible for the platform
+		 * buffer flush.  Note that we've already arranged for pmem
+		 * writes to avoid the cache via arch_memcpy_to_pmem().  The
+		 * final wmb() ensures ordering for the NVDIMM flush write.
+		 */
+		wmb();
+		writeq(1, nfit_blk->nvdimm_flush);
+		wmb();
+	} else
+		wmb_pmem();
+}
+
 static u64 read_blk_stat(struct nfit_blk *nfit_blk, unsigned int bw)
 {
 	struct nfit_blk_mmio *mmio = &nfit_blk->mmio[DCR];
@@ -1012,6 +1058,7 @@ static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
 		offset = to_interleave_offset(offset, mmio);
 
 	writeq(cmd, mmio->base + offset);
+	wmb_blk(nfit_blk);
 	/* FIXME: conditionally perform read-back if mandated by firmware */
 }
 
@@ -1026,7 +1073,6 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
 
 	base_offset = nfit_blk->bdw_offset + dpa % L1_CACHE_BYTES
 		+ lane * mmio->size;
-	/* TODO: non-temporal access, flush hints, cache management etc... */
 	write_blk_ctl(nfit_blk, lane, dpa, len, rw);
 	while (len) {
 		unsigned int c;
@@ -1045,13 +1091,19 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
 		}
 
 		if (rw)
-			memcpy(mmio->aperture + offset, iobuf + copied, c);
+			memcpy_to_pmem(mmio->aperture + offset,
+					iobuf + copied, c);
 		else
-			memcpy(iobuf + copied, mmio->aperture + offset, c);
+			memcpy_from_pmem(iobuf + copied,
+					mmio->aperture + offset, c);
 
 		copied += c;
 		len -= c;
 	}
+
+	if (rw)
+		wmb_blk(nfit_blk);
+
 	rc = read_blk_stat(nfit_blk, lane) ? -EIO : 0;
 	return rc;
 }
@@ -1212,12 +1264,16 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
 	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
 	struct nd_blk_region *ndbr = to_nd_blk_region(dev);
+	struct nfit_flush *nfit_flush;
 	struct nfit_blk_mmio *mmio;
 	struct nfit_blk *nfit_blk;
 	struct nfit_mem *nfit_mem;
 	struct nvdimm *nvdimm;
 	int rc;
 
+	if (!arch_has_pmem_api())
+		dev_warn(dev, "unable to guarantee persistence of writes\n");
+
 	nvdimm = nd_blk_region_to_dimm(ndbr);
 	nfit_mem = nvdimm_provider_data(nvdimm);
 	if (!nfit_mem || !nfit_mem->dcr || !nfit_mem->bdw) {
@@ -1277,6 +1333,22 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 		return rc;
 	}
 
+	nfit_flush = nfit_mem->nfit_flush;
+	if (nfit_flush && nfit_flush->flush->hint_count != 0) {
+		struct acpi_nfit_flush_address *flush = nfit_flush->flush;
+		struct resource res;
+
+		res.start = flush->hint_address[0];
+		res.end = flush->hint_address[0] + sizeof(u64) - 1;
+		res.name = dev_name(dev);
+		res.flags = IORESOURCE_MEM;
+
+		/* only need a single NVDIMM flush address.  map uncacheable */
+		nfit_blk->nvdimm_flush = devm_ioremap_resource(dev, &res);
+		if (IS_ERR(nfit_blk->nvdimm_flush))
+			return -ENOMEM;
+	}
+
 	if (mmio->line_size == 0)
 		return 0;
 
@@ -1459,6 +1531,7 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 	INIT_LIST_HEAD(&acpi_desc->dcrs);
 	INIT_LIST_HEAD(&acpi_desc->bdws);
 	INIT_LIST_HEAD(&acpi_desc->idts);
+	INIT_LIST_HEAD(&acpi_desc->flushes);
 	INIT_LIST_HEAD(&acpi_desc->memdevs);
 	INIT_LIST_HEAD(&acpi_desc->dimms);
 	mutex_init(&acpi_desc->spa_map_mutex);
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 81f2e8c5a79c..d284729cc37c 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -60,6 +60,11 @@ struct nfit_idt {
 	struct list_head list;
 };
 
+struct nfit_flush {
+	struct acpi_nfit_flush_address *flush;
+	struct list_head list;
+};
+
 struct nfit_memdev {
 	struct acpi_nfit_memory_map *memdev;
 	struct list_head list;
@@ -77,6 +82,7 @@ struct nfit_mem {
 	struct acpi_nfit_system_address *spa_bdw;
 	struct acpi_nfit_interleave *idt_dcr;
 	struct acpi_nfit_interleave *idt_bdw;
+	struct nfit_flush *nfit_flush;
 	struct list_head list;
 	struct acpi_device *adev;
 	unsigned long dsm_mask;
@@ -88,6 +94,7 @@ struct acpi_nfit_desc {
 	struct mutex spa_map_mutex;
 	struct list_head spa_maps;
 	struct list_head memdevs;
+	struct list_head flushes;
 	struct list_head dimms;
 	struct list_head spas;
 	struct list_head dcrs;
@@ -109,7 +116,7 @@ struct nfit_blk {
 	struct nfit_blk_mmio {
 		union {
 			void __iomem *base;
-			void *aperture;
+			void __pmem  *aperture;
 		};
 		u64 size;
 		u64 base_offset;
@@ -123,6 +130,7 @@ struct nfit_blk {
 	u64 bdw_offset; /* post interleave offset */
 	u64 stat_offset;
 	u64 cmd_offset;
+	void __iomem *nvdimm_flush;
 };
 
 struct nfit_spa_mapping {
-- 
1.9.3

