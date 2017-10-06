Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DAE0321EA15C1
 for <linux-nvdimm@lists.01.org>; Thu,  5 Oct 2017 18:52:24 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 1/4] libnvdimm: move poison list functions to a new 'badrange'
 file
Date: Thu,  5 Oct 2017 19:53:37 -0600
Message-Id: <20171006015340.29722-2-vishal.l.verma@intel.com>
In-Reply-To: <20171006015340.29722-1-vishal.l.verma@intel.com>
References: <20171006015340.29722-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Dave Jiang <dave.jiang@intel.com>

From: Dave Jiang <dave.jiang@intel.com>

nfit_test needs to use the poison list manipulation code as well. Make
it more generic and in the process rename poison to badrange, and move
all the related helpers to a new file.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
[vishal: add a missed include in bus.c for the new badrange functions]
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/acpi/nfit/core.c  |   2 +-
 drivers/acpi/nfit/mce.c   |   2 +-
 drivers/nvdimm/Makefile   |   1 +
 drivers/nvdimm/badrange.c | 294 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/bus.c      |  24 ++--
 drivers/nvdimm/core.c     | 260 +---------------------------------------
 drivers/nvdimm/nd-core.h  |   3 +-
 drivers/nvdimm/nd.h       |   6 -
 include/linux/libnvdimm.h |  21 +++-
 9 files changed, 331 insertions(+), 282 deletions(-)
 create mode 100644 drivers/nvdimm/badrange.c

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index a3ecd5e..4b157f8 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2240,7 +2240,7 @@ static int ars_status_process_records(struct acpi_nfit_desc *acpi_desc,
 		if (ars_status->out_length
 				< 44 + sizeof(struct nd_ars_record) * (i + 1))
 			break;
-		rc = nvdimm_bus_add_poison(nvdimm_bus,
+		rc = nvdimm_bus_add_badrange(nvdimm_bus,
 				ars_status->records[i].err_address,
 				ars_status->records[i].length);
 		if (rc)
diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
index feeb95d..b929214 100644
--- a/drivers/acpi/nfit/mce.c
+++ b/drivers/acpi/nfit/mce.c
@@ -67,7 +67,7 @@ static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
 			continue;
 
 		/* If this fails due to an -ENOMEM, there is little we can do */
-		nvdimm_bus_add_poison(acpi_desc->nvdimm_bus,
+		nvdimm_bus_add_badrange(acpi_desc->nvdimm_bus,
 				ALIGN(mce->addr, L1_CACHE_BYTES),
 				L1_CACHE_BYTES);
 		nvdimm_region_notify(nfit_spa->nd_region,
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index 909554c..ca6d325 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -20,6 +20,7 @@ libnvdimm-y += region_devs.o
 libnvdimm-y += region.o
 libnvdimm-y += namespace_devs.o
 libnvdimm-y += label.o
+libnvdimm-y += badrange.o
 libnvdimm-$(CONFIG_ND_CLAIM) += claim.o
 libnvdimm-$(CONFIG_BTT) += btt_devs.o
 libnvdimm-$(CONFIG_NVDIMM_PFN) += pfn_devs.o
diff --git a/drivers/nvdimm/badrange.c b/drivers/nvdimm/badrange.c
new file mode 100644
index 0000000..6ad782f
--- /dev/null
+++ b/drivers/nvdimm/badrange.c
@@ -0,0 +1,294 @@
+/*
+ * Copyright(c) 2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/libnvdimm.h>
+#include <linux/badblocks.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/blkdev.h>
+#include <linux/device.h>
+#include <linux/ctype.h>
+#include <linux/ndctl.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include "nd-core.h"
+#include "nd.h"
+
+void badrange_init(struct badrange *badrange)
+{
+	INIT_LIST_HEAD(&badrange->list);
+	spin_lock_init(&badrange->lock);
+}
+EXPORT_SYMBOL_GPL(badrange_init);
+
+static void append_badrange_entry(struct badrange *badrange,
+		struct badrange_entry *be, u64 addr, u64 length)
+{
+	lockdep_assert_held(&badrange->lock);
+	be->start = addr;
+	be->length = length;
+	list_add_tail(&be->list, &badrange->list);
+}
+
+static int alloc_and_append_badrange_entry(struct badrange *badrange,
+		u64 addr, u64 length, gfp_t flags)
+{
+	struct badrange_entry *be;
+
+	be = kzalloc(sizeof(*be), flags);
+	if (!be)
+		return -ENOMEM;
+
+	append_badrange_entry(badrange, be, addr, length);
+	return 0;
+}
+
+static int add_badrange(struct badrange *badrange, u64 addr, u64 length)
+{
+	struct badrange_entry *be, *be_new;
+
+	spin_unlock(&badrange->lock);
+	be_new = kzalloc(sizeof(*be_new), GFP_KERNEL);
+	spin_lock(&badrange->lock);
+
+	if (list_empty(&badrange->list)) {
+		if (!be_new)
+			return -ENOMEM;
+		append_badrange_entry(badrange, be_new, addr, length);
+		return 0;
+	}
+
+	/*
+	 * There is a chance this is a duplicate, check for those first.
+	 * This will be the common case as ARS_STATUS returns all known
+	 * errors in the SPA space, and we can't query it per region
+	 */
+	list_for_each_entry(be, &badrange->list, list)
+		if (be->start == addr) {
+			/* If length has changed, update this list entry */
+			if (be->length != length)
+				be->length = length;
+			kfree(be_new);
+			return 0;
+		}
+
+	/*
+	 * If not a duplicate or a simple length update, add the entry as is,
+	 * as any overlapping ranges will get resolved when the list is consumed
+	 * and converted to badblocks
+	 */
+	if (!be_new)
+		return -ENOMEM;
+	append_badrange_entry(badrange, be_new, addr, length);
+
+	return 0;
+}
+
+int badrange_add(struct badrange *badrange, u64 addr, u64 length)
+{
+	int rc;
+
+	spin_lock(&badrange->lock);
+	rc = add_badrange(badrange, addr, length);
+	spin_unlock(&badrange->lock);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(badrange_add);
+
+void badrange_forget(struct badrange *badrange, phys_addr_t start,
+		unsigned int len)
+{
+	struct list_head *badrange_list = &badrange->list;
+	u64 clr_end = start + len - 1;
+	struct badrange_entry *be, *next;
+
+	spin_lock(&badrange->lock);
+	WARN_ON_ONCE(list_empty(badrange_list));
+
+	/*
+	 * [start, clr_end] is the badrange interval being cleared.
+	 * [be->start, be_end] is the badrange_list entry we're comparing
+	 * the above interval against. The badrange list entry may need
+	 * to be modified (update either start or length), deleted, or
+	 * split into two based on the overlap characteristics
+	 */
+
+	list_for_each_entry_safe(be, next, badrange_list, list) {
+		u64 be_end = be->start + be->length - 1;
+
+		/* Skip intervals with no intersection */
+		if (be_end < start)
+			continue;
+		if (be->start >  clr_end)
+			continue;
+		/* Delete combeetely overlapped badrange entries */
+		if ((be->start >= start) && (be_end <= clr_end)) {
+			list_del(&be->list);
+			kfree(be);
+			continue;
+		}
+		/* Adjust start point of partially cleared entries */
+		if ((start <= be->start) && (clr_end > be->start)) {
+			be->length -= clr_end - be->start + 1;
+			be->start = clr_end + 1;
+			continue;
+		}
+		/* Adjust be->length for partial clearing at the tail end */
+		if ((be->start < start) && (be_end <= clr_end)) {
+			/* be->start remains the same */
+			be->length = start - be->start;
+			continue;
+		}
+		/*
+		 * If clearing in the middle of an entry, we split it into
+		 * two by modifying the current entry to represent one half of
+		 * the split, and adding a new entry for the second half.
+		 */
+		if ((be->start < start) && (be_end > clr_end)) {
+			u64 new_start = clr_end + 1;
+			u64 new_len = be_end - new_start + 1;
+
+			/* Add new entry covering the right half */
+			alloc_and_append_badrange_entry(badrange, new_start,
+					new_len, GFP_NOWAIT);
+			/* Adjust this entry to cover the left half */
+			be->length = start - be->start;
+			continue;
+		}
+	}
+	spin_unlock(&badrange->lock);
+}
+EXPORT_SYMBOL_GPL(badrange_forget);
+
+static void set_badblock(struct badblocks *bb, sector_t s, int num)
+{
+	dev_dbg(bb->dev, "Found a bad range (0x%llx, 0x%llx)\n",
+			(u64) s * 512, (u64) num * 512);
+	/* this isn't an error as the hardware will still throw an exception */
+	if (badblocks_set(bb, s, num, 1))
+		dev_info_once(bb->dev, "%s: failed for sector %llx\n",
+				__func__, (u64) s);
+}
+
+/**
+ * __add_badblock_range() - Convert a physical address range to bad sectors
+ * @bb:		badblocks instance to populate
+ * @ns_offset:	namespace offset where the error range begins (in bytes)
+ * @len:	number of bytes of badrange to be added
+ *
+ * This assumes that the range provided with (ns_offset, len) is within
+ * the bounds of physical addresses for this namespace, i.e. lies in the
+ * interval [ns_start, ns_start + ns_size)
+ */
+static void __add_badblock_range(struct badblocks *bb, u64 ns_offset, u64 len)
+{
+	const unsigned int sector_size = 512;
+	sector_t start_sector, end_sector;
+	u64 num_sectors;
+	u32 rem;
+
+	start_sector = div_u64(ns_offset, sector_size);
+	end_sector = div_u64_rem(ns_offset + len, sector_size, &rem);
+	if (rem)
+		end_sector++;
+	num_sectors = end_sector - start_sector;
+
+	if (unlikely(num_sectors > (u64)INT_MAX)) {
+		u64 remaining = num_sectors;
+		sector_t s = start_sector;
+
+		while (remaining) {
+			int done = min_t(u64, remaining, INT_MAX);
+
+			set_badblock(bb, s, done);
+			remaining -= done;
+			s += done;
+		}
+	} else
+		set_badblock(bb, start_sector, num_sectors);
+}
+
+static void badblocks_populate(struct badrange *badrange,
+		struct badblocks *bb, const struct resource *res)
+{
+	struct badrange_entry *be;
+
+	if (list_empty(&badrange->list))
+		return;
+
+	list_for_each_entry(be, &badrange->list, list) {
+		u64 be_end = be->start + be->length - 1;
+
+		/* Discard intervals with no intersection */
+		if (be_end < res->start)
+			continue;
+		if (be->start >  res->end)
+			continue;
+		/* Deal with any overlap after start of the namespace */
+		if (be->start >= res->start) {
+			u64 start = be->start;
+			u64 len;
+
+			if (be_end <= res->end)
+				len = be->length;
+			else
+				len = res->start + resource_size(res)
+					- be->start;
+			__add_badblock_range(bb, start - res->start, len);
+			continue;
+		}
+		/*
+		 * Deal with overlap for badrange starting before
+		 * the namespace.
+		 */
+		if (be->start < res->start) {
+			u64 len;
+
+			if (be_end < res->end)
+				len = be->start + be->length - res->start;
+			else
+				len = resource_size(res);
+			__add_badblock_range(bb, 0, len);
+		}
+	}
+}
+
+/**
+ * nvdimm_badblocks_populate() - Convert a list of badranges to badblocks
+ * @region: parent region of the range to interrogate
+ * @bb: badblocks instance to populate
+ * @res: resource range to consider
+ *
+ * The badrange list generated during bus initialization may contain
+ * multiple, possibly overlapping physical address ranges.  Compare each
+ * of these ranges to the resource range currently being initialized,
+ * and add badblocks entries for all matching sub-ranges
+ */
+void nvdimm_badblocks_populate(struct nd_region *nd_region,
+		struct badblocks *bb, const struct resource *res)
+{
+	struct nvdimm_bus *nvdimm_bus;
+
+	if (!is_memory(&nd_region->dev)) {
+		dev_WARN_ONCE(&nd_region->dev, 1,
+				"%s only valid for pmem regions\n", __func__);
+		return;
+	}
+	nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
+
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	badblocks_populate(&nvdimm_bus->badrange, bb, res);
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
+}
+EXPORT_SYMBOL_GPL(nvdimm_badblocks_populate);
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index baf2839..0d4d0f4 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -11,6 +11,7 @@
  * General Public License for more details.
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/libnvdimm.h>
 #include <linux/sched/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
@@ -221,7 +222,7 @@ static void nvdimm_account_cleared_poison(struct nvdimm_bus *nvdimm_bus,
 		phys_addr_t phys, u64 cleared)
 {
 	if (cleared > 0)
-		nvdimm_forget_poison(nvdimm_bus, phys, cleared);
+		badrange_forget(&nvdimm_bus->badrange, phys, cleared);
 
 	if (cleared > 0 && cleared / 512)
 		nvdimm_clear_badblocks_regions(nvdimm_bus, phys, cleared);
@@ -344,11 +345,10 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 		return NULL;
 	INIT_LIST_HEAD(&nvdimm_bus->list);
 	INIT_LIST_HEAD(&nvdimm_bus->mapping_list);
-	INIT_LIST_HEAD(&nvdimm_bus->poison_list);
 	init_waitqueue_head(&nvdimm_bus->probe_wait);
 	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
 	mutex_init(&nvdimm_bus->reconfig_mutex);
-	spin_lock_init(&nvdimm_bus->poison_lock);
+	badrange_init(&nvdimm_bus->badrange);
 	if (nvdimm_bus->id < 0) {
 		kfree(nvdimm_bus);
 		return NULL;
@@ -395,15 +395,15 @@ static int child_unregister(struct device *dev, void *data)
 	return 0;
 }
 
-static void free_poison_list(struct list_head *poison_list)
+static void free_badrange_list(struct list_head *badrange_list)
 {
-	struct nd_poison *pl, *next;
+	struct badrange_entry *be, *next;
 
-	list_for_each_entry_safe(pl, next, poison_list, list) {
-		list_del(&pl->list);
-		kfree(pl);
+	list_for_each_entry_safe(be, next, badrange_list, list) {
+		list_del(&be->list);
+		kfree(be);
 	}
-	list_del_init(poison_list);
+	list_del_init(badrange_list);
 }
 
 static int nd_bus_remove(struct device *dev)
@@ -417,9 +417,9 @@ static int nd_bus_remove(struct device *dev)
 	nd_synchronize();
 	device_for_each_child(&nvdimm_bus->dev, NULL, child_unregister);
 
-	spin_lock(&nvdimm_bus->poison_lock);
-	free_poison_list(&nvdimm_bus->poison_list);
-	spin_unlock(&nvdimm_bus->poison_lock);
+	spin_lock(&nvdimm_bus->badrange.lock);
+	free_badrange_list(&nvdimm_bus->badrange.list);
+	spin_unlock(&nvdimm_bus->badrange.lock);
 
 	nvdimm_bus_destroy_ndctl(nvdimm_bus);
 
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index bb71f0c..1dc5276 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -398,265 +398,11 @@ struct attribute_group nvdimm_bus_attribute_group = {
 };
 EXPORT_SYMBOL_GPL(nvdimm_bus_attribute_group);
 
-static void set_badblock(struct badblocks *bb, sector_t s, int num)
+int nvdimm_bus_add_badrange(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
 {
-	dev_dbg(bb->dev, "Found a poison range (0x%llx, 0x%llx)\n",
-			(u64) s * 512, (u64) num * 512);
-	/* this isn't an error as the hardware will still throw an exception */
-	if (badblocks_set(bb, s, num, 1))
-		dev_info_once(bb->dev, "%s: failed for sector %llx\n",
-				__func__, (u64) s);
+	return badrange_add(&nvdimm_bus->badrange, addr, length);
 }
-
-/**
- * __add_badblock_range() - Convert a physical address range to bad sectors
- * @bb:		badblocks instance to populate
- * @ns_offset:	namespace offset where the error range begins (in bytes)
- * @len:	number of bytes of poison to be added
- *
- * This assumes that the range provided with (ns_offset, len) is within
- * the bounds of physical addresses for this namespace, i.e. lies in the
- * interval [ns_start, ns_start + ns_size)
- */
-static void __add_badblock_range(struct badblocks *bb, u64 ns_offset, u64 len)
-{
-	const unsigned int sector_size = 512;
-	sector_t start_sector, end_sector;
-	u64 num_sectors;
-	u32 rem;
-
-	start_sector = div_u64(ns_offset, sector_size);
-	end_sector = div_u64_rem(ns_offset + len, sector_size, &rem);
-	if (rem)
-		end_sector++;
-	num_sectors = end_sector - start_sector;
-
-	if (unlikely(num_sectors > (u64)INT_MAX)) {
-		u64 remaining = num_sectors;
-		sector_t s = start_sector;
-
-		while (remaining) {
-			int done = min_t(u64, remaining, INT_MAX);
-
-			set_badblock(bb, s, done);
-			remaining -= done;
-			s += done;
-		}
-	} else
-		set_badblock(bb, start_sector, num_sectors);
-}
-
-static void badblocks_populate(struct list_head *poison_list,
-		struct badblocks *bb, const struct resource *res)
-{
-	struct nd_poison *pl;
-
-	if (list_empty(poison_list))
-		return;
-
-	list_for_each_entry(pl, poison_list, list) {
-		u64 pl_end = pl->start + pl->length - 1;
-
-		/* Discard intervals with no intersection */
-		if (pl_end < res->start)
-			continue;
-		if (pl->start >  res->end)
-			continue;
-		/* Deal with any overlap after start of the namespace */
-		if (pl->start >= res->start) {
-			u64 start = pl->start;
-			u64 len;
-
-			if (pl_end <= res->end)
-				len = pl->length;
-			else
-				len = res->start + resource_size(res)
-					- pl->start;
-			__add_badblock_range(bb, start - res->start, len);
-			continue;
-		}
-		/* Deal with overlap for poison starting before the namespace */
-		if (pl->start < res->start) {
-			u64 len;
-
-			if (pl_end < res->end)
-				len = pl->start + pl->length - res->start;
-			else
-				len = resource_size(res);
-			__add_badblock_range(bb, 0, len);
-		}
-	}
-}
-
-/**
- * nvdimm_badblocks_populate() - Convert a list of poison ranges to badblocks
- * @region: parent region of the range to interrogate
- * @bb: badblocks instance to populate
- * @res: resource range to consider
- *
- * The poison list generated during bus initialization may contain
- * multiple, possibly overlapping physical address ranges.  Compare each
- * of these ranges to the resource range currently being initialized,
- * and add badblocks entries for all matching sub-ranges
- */
-void nvdimm_badblocks_populate(struct nd_region *nd_region,
-		struct badblocks *bb, const struct resource *res)
-{
-	struct nvdimm_bus *nvdimm_bus;
-	struct list_head *poison_list;
-
-	if (!is_memory(&nd_region->dev)) {
-		dev_WARN_ONCE(&nd_region->dev, 1,
-				"%s only valid for pmem regions\n", __func__);
-		return;
-	}
-	nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
-	poison_list = &nvdimm_bus->poison_list;
-
-	nvdimm_bus_lock(&nvdimm_bus->dev);
-	badblocks_populate(poison_list, bb, res);
-	nvdimm_bus_unlock(&nvdimm_bus->dev);
-}
-EXPORT_SYMBOL_GPL(nvdimm_badblocks_populate);
-
-static void append_poison_entry(struct nvdimm_bus *nvdimm_bus,
-		struct nd_poison *pl, u64 addr, u64 length)
-{
-	lockdep_assert_held(&nvdimm_bus->poison_lock);
-	pl->start = addr;
-	pl->length = length;
-	list_add_tail(&pl->list, &nvdimm_bus->poison_list);
-}
-
-static int add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length,
-			gfp_t flags)
-{
-	struct nd_poison *pl;
-
-	pl = kzalloc(sizeof(*pl), flags);
-	if (!pl)
-		return -ENOMEM;
-
-	append_poison_entry(nvdimm_bus, pl, addr, length);
-	return 0;
-}
-
-static int bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
-{
-	struct nd_poison *pl, *pl_new;
-
-	spin_unlock(&nvdimm_bus->poison_lock);
-	pl_new = kzalloc(sizeof(*pl_new), GFP_KERNEL);
-	spin_lock(&nvdimm_bus->poison_lock);
-
-	if (list_empty(&nvdimm_bus->poison_list)) {
-		if (!pl_new)
-			return -ENOMEM;
-		append_poison_entry(nvdimm_bus, pl_new, addr, length);
-		return 0;
-	}
-
-	/*
-	 * There is a chance this is a duplicate, check for those first.
-	 * This will be the common case as ARS_STATUS returns all known
-	 * errors in the SPA space, and we can't query it per region
-	 */
-	list_for_each_entry(pl, &nvdimm_bus->poison_list, list)
-		if (pl->start == addr) {
-			/* If length has changed, update this list entry */
-			if (pl->length != length)
-				pl->length = length;
-			kfree(pl_new);
-			return 0;
-		}
-
-	/*
-	 * If not a duplicate or a simple length update, add the entry as is,
-	 * as any overlapping ranges will get resolved when the list is consumed
-	 * and converted to badblocks
-	 */
-	if (!pl_new)
-		return -ENOMEM;
-	append_poison_entry(nvdimm_bus, pl_new, addr, length);
-
-	return 0;
-}
-
-int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
-{
-	int rc;
-
-	spin_lock(&nvdimm_bus->poison_lock);
-	rc = bus_add_poison(nvdimm_bus, addr, length);
-	spin_unlock(&nvdimm_bus->poison_lock);
-
-	return rc;
-}
-EXPORT_SYMBOL_GPL(nvdimm_bus_add_poison);
-
-void nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus, phys_addr_t start,
-		unsigned int len)
-{
-	struct list_head *poison_list = &nvdimm_bus->poison_list;
-	u64 clr_end = start + len - 1;
-	struct nd_poison *pl, *next;
-
-	spin_lock(&nvdimm_bus->poison_lock);
-	WARN_ON_ONCE(list_empty(poison_list));
-
-	/*
-	 * [start, clr_end] is the poison interval being cleared.
-	 * [pl->start, pl_end] is the poison_list entry we're comparing
-	 * the above interval against. The poison list entry may need
-	 * to be modified (update either start or length), deleted, or
-	 * split into two based on the overlap characteristics
-	 */
-
-	list_for_each_entry_safe(pl, next, poison_list, list) {
-		u64 pl_end = pl->start + pl->length - 1;
-
-		/* Skip intervals with no intersection */
-		if (pl_end < start)
-			continue;
-		if (pl->start >  clr_end)
-			continue;
-		/* Delete completely overlapped poison entries */
-		if ((pl->start >= start) && (pl_end <= clr_end)) {
-			list_del(&pl->list);
-			kfree(pl);
-			continue;
-		}
-		/* Adjust start point of partially cleared entries */
-		if ((start <= pl->start) && (clr_end > pl->start)) {
-			pl->length -= clr_end - pl->start + 1;
-			pl->start = clr_end + 1;
-			continue;
-		}
-		/* Adjust pl->length for partial clearing at the tail end */
-		if ((pl->start < start) && (pl_end <= clr_end)) {
-			/* pl->start remains the same */
-			pl->length = start - pl->start;
-			continue;
-		}
-		/*
-		 * If clearing in the middle of an entry, we split it into
-		 * two by modifying the current entry to represent one half of
-		 * the split, and adding a new entry for the second half.
-		 */
-		if ((pl->start < start) && (pl_end > clr_end)) {
-			u64 new_start = clr_end + 1;
-			u64 new_len = pl_end - new_start + 1;
-
-			/* Add new entry covering the right half */
-			add_poison(nvdimm_bus, new_start, new_len, GFP_NOWAIT);
-			/* Adjust this entry to cover the left half */
-			pl->length = start - pl->start;
-			continue;
-		}
-	}
-	spin_unlock(&nvdimm_bus->poison_lock);
-}
-EXPORT_SYMBOL_GPL(nvdimm_forget_poison);
+EXPORT_SYMBOL_GPL(nvdimm_bus_add_badrange);
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 int nd_integrity_init(struct gendisk *disk, unsigned long meta_size)
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 86bc19a..79274ea 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -29,10 +29,9 @@ struct nvdimm_bus {
 	struct list_head list;
 	struct device dev;
 	int id, probe_active;
-	struct list_head poison_list;
 	struct list_head mapping_list;
 	struct mutex reconfig_mutex;
-	spinlock_t poison_lock;
+	struct badrange badrange;
 };
 
 struct nvdimm {
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 023fc93..377c800 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -34,12 +34,6 @@ enum {
 	NVDIMM_IO_ATOMIC = 1,
 };
 
-struct nd_poison {
-	u64 start;
-	u64 length;
-	struct list_head list;
-};
-
 struct nvdimm_drvdata {
 	struct device *dev;
 	int nslabel_size;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 3eaad2f..f8109dd 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -18,6 +18,18 @@
 #include <linux/sizes.h>
 #include <linux/types.h>
 #include <linux/uuid.h>
+#include <linux/spinlock.h>
+
+struct badrange_entry {
+	u64 start;
+	u64 length;
+	struct list_head list;
+};
+
+struct badrange {
+	struct list_head list;
+	spinlock_t lock;
+};
 
 enum {
 	/* when a dimm supports both PMEM and BLK access a label is required */
@@ -129,9 +141,12 @@ static inline struct nd_blk_region_desc *to_blk_region_desc(
 
 }
 
-int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length);
-void nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus,
-		phys_addr_t start, unsigned int len);
+void badrange_init(struct badrange *badrange);
+int badrange_add(struct badrange *badrange, u64 addr, u64 length);
+void badrange_forget(struct badrange *badrange, phys_addr_t start,
+		unsigned int len);
+int nvdimm_bus_add_badrange(struct nvdimm_bus *nvdimm_bus, u64 addr,
+		u64 length);
 struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 		struct nvdimm_bus_descriptor *nfit_desc);
 void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus);
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
