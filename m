Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 5/6] nd_blk: add support for flush hints
Date: Thu, 28 May 2015 16:35:52 -0600
Message-Id: <1432852553-24865-6-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1432852553-24865-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1432852553-24865-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-ID: <linux-nvdimm@lists.01.org>

Add support for flush hints and use them in the nd_blk I/O path instead
of the global persistent_sync() whenever we can.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/nfit.c | 49 +++++++++++++++++++++++++++++++++++++++++++++----
 drivers/acpi/nfit.h | 22 ++++++++++++++++++++++
 2 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 22df61968c1c..6cca50d1c690 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -286,9 +286,20 @@ static void *add_table(struct acpi_nfit_desc *acpi_desc, void *table, const void
 				idt->interleave_index, idt->line_count);
 		break;
 	}
-	case ACPI_NFIT_TYPE_FLUSH_ADDRESS:
-		dev_dbg(dev, "%s: flush\n", __func__);
+	case ACPI_NFIT_TYPE_FLUSH_ADDRESS: {
+		struct nfit_flush *nfit_flush = devm_kzalloc(dev,
+				sizeof(*nfit_flush), GFP_KERNEL);
+		struct acpi_nfit_flush_address *flush = table;
+
+		if (!nfit_flush)
+			return err;
+		INIT_LIST_HEAD(&nfit_flush->list);
+		nfit_flush->flush = flush;
+		list_add_tail(&nfit_flush->list, &acpi_desc->flushes);
+		dev_dbg(dev, "%s: flush_hint handle: %d hint_count: %d\n",
+			__func__, flush->device_handle, flush->hint_count);
 		break;
+	}
 	case ACPI_NFIT_TYPE_SMBIOS:
 		dev_dbg(dev, "%s: smbios\n", __func__);
 		break;
@@ -338,6 +349,7 @@ static int nfit_mem_add(struct acpi_nfit_desc *acpi_desc,
 {
 	u16 dcr_index = __to_nfit_memdev(nfit_mem)->region_index;
 	struct nfit_memdev *nfit_memdev;
+	struct nfit_flush *nfit_flush;
 	struct nfit_dcr *nfit_dcr;
 	struct nfit_bdw *nfit_bdw;
 	struct nfit_idt *nfit_idt;
@@ -384,6 +396,7 @@ static int nfit_mem_add(struct acpi_nfit_desc *acpi_desc,
 				nfit_memdev->memdev->region_index != dcr_index)
 			continue;
 		nfit_mem->memdev_bdw = nfit_memdev->memdev;
+
 		idt_index = nfit_memdev->memdev->interleave_index;
 		list_for_each_entry(nfit_idt, &acpi_desc->idts, list) {
 			if (nfit_idt->idt->interleave_index != idt_index)
@@ -391,6 +404,14 @@ static int nfit_mem_add(struct acpi_nfit_desc *acpi_desc,
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
 
@@ -929,7 +950,7 @@ static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
 
 	/* mmio->base must be mapped uncacheable */
 	writeq(cmd, mmio->base + offset);
-	persistent_sync();
+	nfit_blk->psync(nfit_blk);
 	/* FIXME: conditionally perform read-back if mandated by firmware */
 }
 
@@ -970,7 +991,7 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk, void *iobuf,
 	}
 
 	if (write)
-		persistent_sync();
+		nfit_blk->psync(nfit_blk);
 
 	rc = read_blk_stat(nfit_blk, bw) ? -EIO : 0;
 	return rc;
@@ -1130,6 +1151,7 @@ static int acpi_nfit_blk_region_enable(struct nd_bus *nd_bus, struct device *dev
 	struct nd_bus_descriptor *nd_desc = to_nd_desc(nd_bus);
 	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
 	struct nd_blk_region *ndbr = to_nd_blk_region(dev);
+	struct nfit_flush *nfit_flush;
 	struct nfit_blk_mmio *mmio;
 	struct nfit_blk *nfit_blk;
 	struct nfit_mem *nfit_mem;
@@ -1195,6 +1217,24 @@ static int acpi_nfit_blk_region_enable(struct nd_bus *nd_bus, struct device *dev
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
+		/* only need a single hint address.  map uncacheable */
+		nfit_blk->flush_hint = devm_ioremap_resource(dev, &res);
+		if (IS_ERR(nfit_blk->flush_hint))
+			return -ENOMEM;
+		nfit_blk->psync = directed_psync;
+	} else
+		nfit_blk->psync = global_psync;
+
 	if (mmio->line_size == 0)
 		return 0;
 
@@ -1349,6 +1389,7 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 	INIT_LIST_HEAD(&acpi_desc->dcrs);
 	INIT_LIST_HEAD(&acpi_desc->bdws);
 	INIT_LIST_HEAD(&acpi_desc->idts);
+	INIT_LIST_HEAD(&acpi_desc->flushes);
 	INIT_LIST_HEAD(&acpi_desc->memdevs);
 	INIT_LIST_HEAD(&acpi_desc->dimms);
 	mutex_init(&acpi_desc->spa_map_mutex);
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index b882a22ee7bb..858719017bef 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -18,6 +18,7 @@
 #include <linux/libnd.h>
 #include <linux/uuid.h>
 #include <linux/acpi.h>
+#include <linux/pmem.h>
 #include <acpi/acuuid.h>
 
 #define UUID_NFIT_BUS "2f10e7a4-9e91-11e4-89d3-123b93f75cba"
@@ -66,6 +67,11 @@ struct nfit_idt {
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
@@ -83,6 +89,7 @@ struct nfit_mem {
 	struct acpi_nfit_system_address *spa_bdw;
 	struct acpi_nfit_interleave *idt_dcr;
 	struct acpi_nfit_interleave *idt_bdw;
+	struct nfit_flush *nfit_flush;
 	struct list_head list;
 	struct acpi_device *adev;
 	unsigned long dsm_mask;
@@ -94,6 +101,7 @@ struct acpi_nfit_desc {
 	struct mutex spa_map_mutex;
 	struct list_head spa_maps;
 	struct list_head memdevs;
+	struct list_head flushes;
 	struct list_head dimms;
 	struct list_head spas;
 	struct list_head dcrs;
@@ -131,6 +139,8 @@ struct nfit_blk {
 	u64 bdw_offset; /* post interleave offset */
 	u64 stat_offset;
 	u64 cmd_offset;
+	void __iomem *flush_hint;
+	void (*psync)(struct nfit_blk *nfit_blk);
 };
 
 struct nfit_spa_mapping {
@@ -158,6 +168,18 @@ static inline struct acpi_nfit_desc *to_acpi_desc(struct nd_bus_descriptor *nd_d
 	return container_of(nd_desc, struct acpi_nfit_desc, nd_desc);
 }
 
+static inline void directed_psync(struct nfit_blk *nfit_blk)
+{
+	wmb(); /* order previous writes */
+	writeq(1, nfit_blk->flush_hint); /* flush_hint must be mapped UC */
+	wmb(); /* order the write to the flush_hint */
+}
+
+static inline void global_psync(struct nfit_blk *nfit_blk)
+{
+	persistent_sync();
+}
+
 const u8 *to_nfit_uuid(enum nfit_uuids id);
 int acpi_nfit_init(struct acpi_nfit_desc *nfit, acpi_size sz);
 #endif /* __NFIT_H__ */
-- 
1.9.3

