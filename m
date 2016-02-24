Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 2/8] libnvdimm: protect nvdimm_{bus|namespace}_add_poison()
 with nvdimm_bus_lock()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Feb 2016 18:17:08 -0800
Message-ID: <20160224021708.22776.34242.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160224021655.22776.87952.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160224021655.22776.87952.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for making poison list retrieval asynchronus to region
registration, add protection for walking and mutating the bus-level
poison list.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/core.c |  101 +++++++++++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 38 deletions(-)

diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 2e2832b83c93..f309e6bf6833 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -408,33 +408,11 @@ static void __add_badblock_range(struct badblocks *bb, u64 ns_offset, u64 len)
 		set_badblock(bb, start_sector, num_sectors);
 }
 
-/**
- * nvdimm_namespace_add_poison() - Convert a list of poison ranges to badblocks
- * @ndns:	the namespace containing poison ranges
- * @bb:		badblocks instance to populate
- * @offset:	offset at the start of the namespace before 'sector 0'
- *
- * The poison list generated during NFIT initialization may contain multiple,
- * possibly overlapping ranges in the SPA (System Physical Address) space.
- * Compare each of these ranges to the namespace currently being initialized,
- * and add badblocks to the gendisk for all matching sub-ranges
- */
-void nvdimm_namespace_add_poison(struct nd_namespace_common *ndns,
-		struct badblocks *bb, resource_size_t offset)
+static void namespace_add_poison(struct list_head *poison_list,
+		struct badblocks *bb, struct resource *res)
 {
-	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
-	struct nd_region *nd_region = to_nd_region(ndns->dev.parent);
-	struct nvdimm_bus *nvdimm_bus;
-	struct list_head *poison_list;
-	u64 ns_start, ns_end, ns_size;
 	struct nd_poison *pl;
 
-	ns_size = nvdimm_namespace_capacity(ndns) - offset;
-	ns_start = nsio->res.start + offset;
-	ns_end = nsio->res.end;
-
-	nvdimm_bus = to_nvdimm_bus(nd_region->dev.parent);
-	poison_list = &nvdimm_bus->poison_list;
 	if (list_empty(poison_list))
 		return;
 
@@ -442,37 +420,69 @@ void nvdimm_namespace_add_poison(struct nd_namespace_common *ndns,
 		u64 pl_end = pl->start + pl->length - 1;
 
 		/* Discard intervals with no intersection */
-		if (pl_end < ns_start)
+		if (pl_end < res->start)
 			continue;
-		if (pl->start > ns_end)
+		if (pl->start >  res->end)
 			continue;
 		/* Deal with any overlap after start of the namespace */
-		if (pl->start >= ns_start) {
+		if (pl->start >= res->start) {
 			u64 start = pl->start;
 			u64 len;
 
-			if (pl_end <= ns_end)
+			if (pl_end <= res->end)
 				len = pl->length;
 			else
-				len = ns_start + ns_size - pl->start;
-			__add_badblock_range(bb, start - ns_start, len);
+				len = res->start + resource_size(res)
+					- pl->start;
+			__add_badblock_range(bb, start - res->start, len);
 			continue;
 		}
 		/* Deal with overlap for poison starting before the namespace */
-		if (pl->start < ns_start) {
+		if (pl->start < res->start) {
 			u64 len;
 
-			if (pl_end < ns_end)
-				len = pl->start + pl->length - ns_start;
+			if (pl_end < res->end)
+				len = pl->start + pl->length - res->start;
 			else
-				len = ns_size;
+				len = resource_size(res);
 			__add_badblock_range(bb, 0, len);
 		}
 	}
 }
+
+/**
+ * nvdimm_namespace_add_poison() - Convert a list of poison ranges to badblocks
+ * @ndns:	the namespace containing poison ranges
+ * @bb:		badblocks instance to populate
+ * @offset:	offset at the start of the namespace before 'sector 0'
+ *
+ * The poison list generated during NFIT initialization may contain multiple,
+ * possibly overlapping ranges in the SPA (System Physical Address) space.
+ * Compare each of these ranges to the namespace currently being initialized,
+ * and add badblocks to the gendisk for all matching sub-ranges
+ */
+void nvdimm_namespace_add_poison(struct nd_namespace_common *ndns,
+		struct badblocks *bb, resource_size_t offset)
+{
+	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
+	struct nd_region *nd_region = to_nd_region(ndns->dev.parent);
+	struct nvdimm_bus *nvdimm_bus;
+	struct list_head *poison_list;
+	struct resource res = {
+		.start = nsio->res.start + offset,
+		.end = nsio->res.end,
+	};
+
+	nvdimm_bus = to_nvdimm_bus(nd_region->dev.parent);
+	poison_list = &nvdimm_bus->poison_list;
+
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	namespace_add_poison(poison_list, bb, &res);
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
+}
 EXPORT_SYMBOL_GPL(nvdimm_namespace_add_poison);
 
-static int __add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
+static int add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
 {
 	struct nd_poison *pl;
 
@@ -487,12 +497,12 @@ static int __add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
 	return 0;
 }
 
-int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
+static int bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
 {
 	struct nd_poison *pl;
 
 	if (list_empty(&nvdimm_bus->poison_list))
-		return __add_poison(nvdimm_bus, addr, length);
+		return add_poison(nvdimm_bus, addr, length);
 
 	/*
 	 * There is a chance this is a duplicate, check for those first.
@@ -512,7 +522,18 @@ int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
 	 * as any overlapping ranges will get resolved when the list is consumed
 	 * and converted to badblocks
 	 */
-	return __add_poison(nvdimm_bus, addr, length);
+	return add_poison(nvdimm_bus, addr, length);
+}
+
+int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
+{
+	int rc;
+
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	rc = bus_add_poison(nvdimm_bus, addr, length);
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
+
+	return rc;
 }
 EXPORT_SYMBOL_GPL(nvdimm_bus_add_poison);
 
@@ -553,7 +574,11 @@ void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus)
 
 	nd_synchronize();
 	device_for_each_child(&nvdimm_bus->dev, NULL, child_unregister);
+
+	nvdimm_bus_lock(&nvdimm_bus->dev);
 	free_poison_list(&nvdimm_bus->poison_list);
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
+
 	nvdimm_bus_destroy_ndctl(nvdimm_bus);
 
 	device_unregister(&nvdimm_bus->dev);
