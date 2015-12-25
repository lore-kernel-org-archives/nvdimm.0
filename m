Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 2/2] libnvdimm: Add a poison list and export badblocks
Date: Thu, 24 Dec 2015 19:21:43 -0700
Message-Id: <1451010103-11462-3-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1451010103-11462-1-git-send-email-vishal.l.verma@intel.com>
References: <1451010103-11462-1-git-send-email-vishal.l.verma@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>, Linda Knippers <linda.knippers@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

During region creation, perform Address Range Scrubs (ARS) for the SPA
(System Physical Address) ranges to retrieve known poison locations from
firmware. Add a new data structure 'nd_poison' which is used as a list
in nvdimm_bus to store these poison locations.

When creating a pmem namespace, if there is any known poison associated
with its physical address space, convert the poison ranges to bad sectors
that are exposed using the badblocks interface.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/acpi/nfit.c       | 203 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/core.c     | 187 ++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h  |   3 +
 drivers/nvdimm/nd.h       |   6 ++
 drivers/nvdimm/pmem.c     |   6 ++
 include/linux/libnvdimm.h |   1 +
 6 files changed, 406 insertions(+)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index aa45d48..ad6d8c6 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/ndctl.h>
+#include <linux/delay.h>
 #include <linux/list.h>
 #include <linux/acpi.h>
 #include <linux/sort.h>
@@ -1473,6 +1474,201 @@ static void acpi_nfit_blk_region_disable(struct nvdimm_bus *nvdimm_bus,
 	/* devm will free nfit_blk */
 }
 
+static int ars_get_cap(struct nvdimm_bus_descriptor *nd_desc,
+		struct nd_cmd_ars_cap *cmd, u64 addr, u64 length)
+{
+	cmd->address = addr;
+	cmd->length = length;
+
+	return nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_CAP, cmd,
+			sizeof(*cmd));
+}
+
+static int ars_do_start(struct nvdimm_bus_descriptor *nd_desc,
+		struct nd_cmd_ars_start *cmd, u64 addr, u64 length)
+{
+	int rc;
+
+	cmd->address = addr;
+	cmd->length = length;
+	cmd->type = ND_ARS_PERSISTENT;
+
+	while (1) {
+		rc = nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_START, cmd,
+				sizeof(*cmd));
+		if (rc)
+			return rc;
+		switch (cmd->status) {
+		case 0:
+			return 0;
+		case 1:
+			/* ARS unsupported, but we should never get here */
+			return 0;
+		case 2:
+			return -EINVAL;
+		case 3:
+			/* ARS is in progress */
+			msleep(1000);
+			break;
+		default:
+			return -ENXIO;
+		}
+	}
+}
+
+static int ars_get_status(struct nvdimm_bus_descriptor *nd_desc,
+		struct nd_cmd_ars_status *cmd)
+{
+	int rc;
+
+	while (1) {
+		rc = nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_STATUS, cmd,
+			sizeof(*cmd));
+		if (rc || cmd->status & 0xffff)
+			return -ENXIO;
+
+		/* Check extended status (Upper two bytes) */
+		switch (cmd->status >> 16) {
+		case 0:
+			return 0;
+		case 1:
+			/* ARS is in progress */
+			msleep(1000);
+			break;
+		case 2:
+			/* No ARS performed for the current boot */
+			return 0;
+		default:
+			return -ENXIO;
+		}
+	}
+}
+
+static int ars_status_process_records(struct nvdimm_bus *nvdimm_bus,
+		struct nd_cmd_ars_status *ars_status, u64 start)
+{
+	int rc;
+	u32 i;
+
+	/*
+	 * The address field returned by ars_status should be either
+	 * less than or equal to the address we last started ARS for.
+	 * The (start, length) returned by ars_status should also have
+	 * non-zero overlap with the range we started ARS for.
+	 * If this is not the case, bail.
+	 */
+	if (ars_status->address > start ||
+			(ars_status->address + ars_status->length < start))
+		return -ENXIO;
+
+	for (i = 0; i < ars_status->num_records; i++) {
+		rc = nvdimm_bus_add_poison(nvdimm_bus,
+				ars_status->records[i].err_address,
+				ars_status->records[i].length);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static int acpi_nfit_find_poison(struct acpi_nfit_desc *acpi_desc,
+		struct nd_region_desc *ndr_desc)
+{
+	struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
+	struct nvdimm_bus *nvdimm_bus = acpi_desc->nvdimm_bus;
+	struct nd_cmd_ars_status *ars_status = NULL;
+	struct nd_cmd_ars_start *ars_start = NULL;
+	struct nd_cmd_ars_cap *ars_cap = NULL;
+	u64 start, len, cur, remaining;
+	int rc;
+
+	ars_cap = kzalloc(sizeof(*ars_cap), GFP_KERNEL);
+	if (!ars_cap)
+		return -ENOMEM;
+
+	start = ndr_desc->res->start;
+	len = ndr_desc->res->end - ndr_desc->res->start + 1;
+
+	rc = ars_get_cap(nd_desc, ars_cap, start, len);
+	if (rc)
+		goto out;
+
+	/*
+	 * If ARS is unsupported, or if the 'Persistent Memory Scrub' flag in
+	 * extended status is not set, skip this but continue initialization
+	 */
+	if ((ars_cap->status & 0xffff) ||
+		!(ars_cap->status >> 16 & ND_ARS_PERSISTENT)) {
+		dev_warn(acpi_desc->dev,
+			"ARS unsupported (status: 0x%x), won't create an error list\n",
+			ars_cap->status);
+		goto out;
+	}
+
+	/*
+	 * Check if a full-range ARS has been run. If so, use those results
+	 * without having to start a new ARS.
+	 */
+	ars_status = kzalloc(ars_cap->max_ars_out + sizeof(*ars_status),
+			GFP_KERNEL);
+	if (!ars_status) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = ars_get_status(nd_desc, ars_status);
+	if (rc)
+		goto out;
+
+	if (ars_status->address <= start &&
+		(ars_status->address + ars_status->length >= start + len)) {
+		rc = ars_status_process_records(nvdimm_bus, ars_status, start);
+		goto out;
+	}
+
+	/*
+	 * ARS_STATUS can overflow if the number of poison entries found is
+	 * greater than the maximum buffer size (ars_cap->max_ars_out)
+	 * To detect overflow, check if the length field of ars_status
+	 * is less than the length we supplied. If so, process the
+	 * error entries we got, adjust the start point, and start again
+	 */
+	ars_start = kzalloc(sizeof(*ars_start), GFP_KERNEL);
+	if (!ars_start)
+		return -ENOMEM;
+
+	cur = start;
+	remaining = len;
+	do {
+		u64 done, end;
+
+		rc = ars_do_start(nd_desc, ars_start, cur, remaining);
+		if (rc)
+			goto out;
+
+		rc = ars_get_status(nd_desc, ars_status);
+		if (rc)
+			goto out;
+
+		rc = ars_status_process_records(nvdimm_bus, ars_status, cur);
+		if (rc)
+			goto out;
+
+		end = min(cur + remaining,
+			ars_status->address + ars_status->length);
+		done = end - cur;
+		cur += done;
+		remaining -= done;
+	} while (remaining);
+
+ out:
+	kfree(ars_cap);
+	kfree(ars_start);
+	kfree(ars_status);
+	return rc;
+}
+
 static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
 		struct nd_mapping *nd_mapping, struct nd_region_desc *ndr_desc,
 		struct acpi_nfit_memory_map *memdev,
@@ -1585,6 +1781,13 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 
 	nvdimm_bus = acpi_desc->nvdimm_bus;
 	if (nfit_spa_type(spa) == NFIT_SPA_PM) {
+		rc = acpi_nfit_find_poison(acpi_desc, ndr_desc);
+		if (rc) {
+			dev_err(acpi_desc->dev,
+				"error while performing ARS to find poison: %d\n",
+				rc);
+			return rc;
+		}
 		if (!nvdimm_pmem_region_create(nvdimm_bus, ndr_desc))
 			return -ENOMEM;
 	} else if (nfit_spa_type(spa) == NFIT_SPA_VOLATILE) {
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 82c49bb..21003b7 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -325,6 +325,7 @@ struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
 	if (!nvdimm_bus)
 		return NULL;
 	INIT_LIST_HEAD(&nvdimm_bus->list);
+	INIT_LIST_HEAD(&nvdimm_bus->poison_list);
 	init_waitqueue_head(&nvdimm_bus->probe_wait);
 	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
 	mutex_init(&nvdimm_bus->reconfig_mutex);
@@ -359,6 +360,191 @@ struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
 }
 EXPORT_SYMBOL_GPL(__nvdimm_bus_register);
 
+/**
+ * __add_badblock_range() - Convert a physical address range to bad sectors
+ * @disk:	the disk associated with the namespace
+ * @ns_offset:	namespace offset where the error range begins (in bytes)
+ * @len:	number of bytes of poison to be added
+ *
+ * This assumes that the range provided with (ns_offset, len) is within
+ * the bounds of physical addresses for this namespace, i.e. lies in the
+ * interval [ns_start, ns_start + ns_size)
+ */
+static int __add_badblock_range(struct gendisk *disk, u64 ns_offset, u64 len)
+{
+	unsigned int sector_size = queue_logical_block_size(disk->queue);
+	sector_t start_sector;
+	u64 num_sectors;
+	u32 rem;
+	int rc;
+
+	start_sector = div_u64(ns_offset, sector_size);
+	num_sectors = div_u64_rem(len, sector_size, &rem);
+	if (rem)
+		num_sectors++;
+
+	if (!disk->bb) {
+		rc = disk_alloc_badblocks(disk);
+		if (rc)
+			return rc;
+	}
+
+	if (unlikely(num_sectors > (u64)INT_MAX)) {
+		u64 remaining = num_sectors;
+		sector_t s = start_sector;
+
+		while (remaining) {
+			int done = min_t(u64, remaining, INT_MAX);
+
+			rc = disk_set_badblocks(disk, s, done);
+			if (rc)
+				return rc;
+			remaining -= done;
+			s += done;
+		}
+		return 0;
+	} else
+		return disk_set_badblocks(disk, start_sector, num_sectors);
+}
+
+/**
+ * nvdimm_namespace_add_poison() - Convert a list of poison ranges to badblocks
+ * @disk:	the gendisk associated with the namespace where badblocks
+ *		will be stored
+ * @offset:	offset at the start of the namespace before 'sector 0'
+ * @ndns:	the namespace containing poison ranges
+ *
+ * The poison list generated during NFIT initialization may contain multiple,
+ * possibly overlapping ranges in the SPA (System Physical Address) space.
+ * Compare each of these ranges to the namespace currently being initialized,
+ * and add badblocks to the gendisk for all matching sub-ranges
+ *
+ * Return:
+ * 0 - Success
+ */
+int nvdimm_namespace_add_poison(struct gendisk *disk, resource_size_t offset,
+		struct nd_namespace_common *ndns)
+{
+	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
+	struct nd_region *nd_region = to_nd_region(ndns->dev.parent);
+	struct nvdimm_bus *nvdimm_bus;
+	struct list_head *poison_list;
+	u64 ns_start, ns_end, ns_size;
+	struct nd_poison *pl;
+	int rc;
+
+	ns_size = nvdimm_namespace_capacity(ndns) - offset;
+	ns_start = nsio->res.start + offset;
+	ns_end = nsio->res.end;
+
+	nvdimm_bus = to_nvdimm_bus(nd_region->dev.parent);
+	poison_list = &nvdimm_bus->poison_list;
+	if (list_empty(poison_list))
+		return 0;
+
+	list_for_each_entry(pl, poison_list, list) {
+		u64 pl_end = pl->start + pl->length - 1;
+
+		/* Discard intervals with no intersection */
+		if (pl_end < ns_start)
+			continue;
+		if (pl->start > ns_end)
+			continue;
+		/* Deal with any overlap after start of the namespace */
+		if (pl->start >= ns_start) {
+			u64 start = pl->start;
+			u64 len;
+
+			if (pl_end <= ns_end)
+				len = pl->length;
+			else
+				len = ns_start + ns_size - pl->start;
+
+			rc = __add_badblock_range(disk, start - ns_start, len);
+			if (rc)
+				return rc;
+			dev_info(&nvdimm_bus->dev,
+				"Found a poison range (0x%llx, 0x%llx)\n",
+				start, len);
+			continue;
+		}
+		/* Deal with overlap for poison starting before the namespace */
+		if (pl->start < ns_start) {
+			u64 len;
+
+			if (pl_end < ns_end)
+				len = pl->start + pl->length - ns_start;
+			else
+				len = ns_size;
+
+			rc = __add_badblock_range(disk, 0, len);
+			if (rc)
+				return rc;
+			dev_info(&nvdimm_bus->dev,
+				"Found a poison range (0x%llx, 0x%llx)\n",
+				pl->start, len);
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvdimm_namespace_add_poison);
+
+static int __add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
+{
+	struct nd_poison *pl;
+
+	pl = kzalloc(sizeof(*pl), GFP_KERNEL);
+	if (!pl)
+		return -ENOMEM;
+
+	pl->start = addr;
+	pl->length = length;
+	list_add_tail(&pl->list, &nvdimm_bus->poison_list);
+
+	return 0;
+}
+
+int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
+{
+	struct nd_poison *pl;
+
+	if (list_empty(&nvdimm_bus->poison_list))
+		return __add_poison(nvdimm_bus, addr, length);
+
+	/*
+	 * There is a chance this is a duplicate, check for those first.
+	 * This will be the common case as ARS_STATUS returns all known
+	 * errors in the SPA space, and we can't query it per region
+	 */
+	list_for_each_entry(pl, &nvdimm_bus->poison_list, list)
+		if (pl->start == addr) {
+			/* If length has changed, update this list entry */
+			if (pl->length != length)
+				pl->length = length;
+			return 0;
+		}
+
+	/*
+	 * If not a duplicate or a simple length update, add the entry as is,
+	 * as any overlapping ranges will get resolved when the list is consumed
+	 * and converted to badblocks
+	 */
+	return __add_poison(nvdimm_bus, addr, length);
+}
+EXPORT_SYMBOL_GPL(nvdimm_bus_add_poison);
+
+static void free_poison_list(struct list_head *poison_list)
+{
+	struct nd_poison *pl, *next;
+
+	list_for_each_entry_safe(pl, next, poison_list, list) {
+		list_del(&pl->list);
+		kfree(pl);
+	}
+	list_del_init(poison_list);
+}
+
 static int child_unregister(struct device *dev, void *data)
 {
 	/*
@@ -385,6 +571,7 @@ void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus)
 
 	nd_synchronize();
 	device_for_each_child(&nvdimm_bus->dev, NULL, child_unregister);
+	free_poison_list(&nvdimm_bus->poison_list);
 	nvdimm_bus_destroy_ndctl(nvdimm_bus);
 
 	device_unregister(&nvdimm_bus->dev);
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 159aed5..d3b7ea7 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -30,6 +30,7 @@ struct nvdimm_bus {
 	struct list_head list;
 	struct device dev;
 	int id, probe_active;
+	struct list_head poison_list;
 	struct mutex reconfig_mutex;
 };
 
@@ -89,4 +90,6 @@ bool __nd_attach_ndns(struct device *dev, struct nd_namespace_common *attach,
 ssize_t nd_namespace_store(struct device *dev,
 		struct nd_namespace_common **_ndns, const char *buf,
 		size_t len);
+int nvdimm_namespace_add_poison(struct gendisk *disk, resource_size_t offset,
+		struct nd_namespace_common *ndns);
 #endif /* __ND_CORE_H__ */
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 417e521..ba91fcd 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -38,6 +38,12 @@ enum {
 #endif
 };
 
+struct nd_poison {
+	u64 start;
+	u64 length;
+	struct list_head list;
+};
+
 struct nvdimm_drvdata {
 	struct device *dev;
 	int nsindex_size;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 8ee7989..5b95043 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/pmem.h>
 #include <linux/nd.h>
+#include "nd-core.h"
 #include "pfn.h"
 #include "nd.h"
 
@@ -168,6 +169,7 @@ static int pmem_attach_disk(struct device *dev,
 {
 	int nid = dev_to_node(dev);
 	struct gendisk *disk;
+	int ret;
 
 	pmem->pmem_queue = blk_alloc_queue_node(GFP_KERNEL, nid);
 	if (!pmem->pmem_queue)
@@ -196,6 +198,10 @@ static int pmem_attach_disk(struct device *dev,
 	set_capacity(disk, (pmem->size - pmem->data_offset) / 512);
 	pmem->pmem_disk = disk;
 
+	ret = nvdimm_namespace_add_poison(disk, pmem->data_offset, ndns);
+	if (ret)
+		return ret;
+
 	add_disk(disk);
 	revalidate_disk(disk);
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 3f021dc..bed40df 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -116,6 +116,7 @@ static inline struct nd_blk_region_desc *to_blk_region_desc(
 
 }
 
+int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length);
 struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
 		struct nvdimm_bus_descriptor *nfit_desc, struct module *module);
 #define nvdimm_bus_register(parent, desc) \
-- 
2.5.0

