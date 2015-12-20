Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: vishal@kernel.org
Subject: [PATCH 3/3] pmem: Use the poison list to expose badblocks
Date: Sun, 20 Dec 2015 02:18:42 -0700
Message-Id: <1450603122-7205-4-git-send-email-vishal@kernel.org>
In-Reply-To: <1450603122-7205-1-git-send-email-vishal@kernel.org>
References: <1450603122-7205-1-git-send-email-vishal@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>, Linda Knippers <linda.knippers@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Vishal Verma <vishal.l.verma@intel.com>

Enable the gendisk badblocks feature for pmem namespaces.
If the pmem namespace being created has any known poison associated with
its physical address space, convert the poison ranges to bad sectors
exposed using the badblocks interface.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/pmem.c | 124 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 124 insertions(+)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 8ee7989..462570f 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -19,14 +19,18 @@
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/init.h>
+#include <linux/list.h>
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/memory_hotplug.h>
 #include <linux/moduleparam.h>
+#include <linux/libnvdimm.h>
 #include <linux/vmalloc.h>
+#include <linux/blkdev.h>
 #include <linux/slab.h>
 #include <linux/pmem.h>
 #include <linux/nd.h>
+#include "nd-core.h"
 #include "pfn.h"
 #include "nd.h"
 
@@ -163,11 +167,122 @@ static void pmem_detach_disk(struct pmem_device *pmem)
 	blk_cleanup_queue(pmem->pmem_queue);
 }
 
+/**
+ * pmem_add_badblock_range() - Convert a physical address range to bad sectors
+ * @disk:	the disk associated with the pmem namespace
+ * @start:	start of the physical address range
+ * @length:	number of bytes of poison to be added
+ *
+ * This assumes that the range provided with (start, length) is already within
+ * the bounds of physical addresses for this namespace, i.e. lies in the
+ * interval [pmem->phys_addr, pmem->phys_addr + pmem->size)
+ */
+static int pmem_add_badblock_range(struct gendisk *disk, u64 start, u64 length)
+{
+	unsigned int sector_size = queue_logical_block_size(disk->queue);
+	struct pmem_device *pmem = disk->private_data;
+	sector_t start_sector;
+	u64 num_sectors;
+	u32 rem;
+
+	start_sector = div_u64(start - pmem->phys_addr, sector_size);
+	num_sectors = div_u64_rem(length, sector_size, &rem);
+	if (rem)
+		num_sectors++;
+
+	if (unlikely(num_sectors > (u64)INT_MAX)) {
+		u64 remaining = num_sectors;
+		sector_t s = start_sector;
+		int rc;
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
+/*
+ * The poison list generated during NFIT initialization may contain multiple,
+ * possibly overlapping ranges in the SPA (System Physical Address) space.
+ * Compare each of these ranges to the pmem namespace currently being
+ * initialized, and add badblocks for the sub-ranges that match
+ */
+static int pmem_add_poison(struct gendisk *disk, struct nvdimm_bus *nvdimm_bus)
+{
+	struct pmem_device *pmem = disk->private_data;
+	struct list_head *poison_list;
+	struct nd_poison *pl;
+	int rc;
+
+	poison_list = nvdimm_bus_get_poison_list(nvdimm_bus);
+	if (list_empty(poison_list))
+		return 0;
+
+	list_for_each_entry(pl, poison_list, list) {
+		u64 pl_end = pl->start + pl->length - 1;
+		u64 pmem_end = pmem->phys_addr + pmem->size - 1;
+
+		/* Discard intervals with no intersection */
+		if (pl_end < pmem->phys_addr)
+			continue;
+		if (pl->start > pmem_end)
+			continue;
+		/* Deal with any overlap after start of the pmem range */
+		if (pl->start >= pmem->phys_addr) {
+			u64 start = pl->start;
+			u64 len;
+
+			if (pl_end <= pmem_end)
+				len = pl->length;
+			else
+				len = pmem->phys_addr + pmem->size - pl->start;
+
+			rc = pmem_add_badblock_range(disk, start, len);
+			if (rc)
+				return rc;
+			dev_info(&nvdimm_bus->dev,
+				"Found a poison range (0x%llx, 0x%llx)\n",
+				start, len);
+			continue;
+		}
+		/* Deal with overlap for poison starting before pmem range */
+		if (pl->start < pmem->phys_addr) {
+			u64 start = pmem->phys_addr;
+			u64 len;
+
+			if (pl_end < pmem_end)
+				len = pl->start + pl->length - pmem->phys_addr;
+			else
+				len = pmem->size;
+
+			rc = pmem_add_badblock_range(disk, start, len);
+			if (rc)
+				return rc;
+			dev_info(&nvdimm_bus->dev,
+				"Found a poison range (0x%llx, 0x%llx)\n",
+				start, len);
+		}
+	}
+
+	return 0;
+}
+
 static int pmem_attach_disk(struct device *dev,
 		struct nd_namespace_common *ndns, struct pmem_device *pmem)
 {
+	struct nd_region *nd_region = to_nd_region(dev->parent);
+	struct nvdimm_bus *nvdimm_bus;
 	int nid = dev_to_node(dev);
 	struct gendisk *disk;
+	int ret;
 
 	pmem->pmem_queue = blk_alloc_queue_node(GFP_KERNEL, nid);
 	if (!pmem->pmem_queue)
@@ -196,6 +311,15 @@ static int pmem_attach_disk(struct device *dev,
 	set_capacity(disk, (pmem->size - pmem->data_offset) / 512);
 	pmem->pmem_disk = disk;
 
+	ret = disk_alloc_badblocks(disk);
+	if (ret)
+		return ret;
+
+	nvdimm_bus = to_nvdimm_bus(nd_region->dev.parent);
+	ret = pmem_add_poison(disk, nvdimm_bus);
+	if (ret)
+		return ret;
+
 	add_disk(disk);
 	revalidate_disk(disk);
 
-- 
2.5.0

