Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5A4C31A1E6E
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 09:42:26 -0700 (PDT)
Subject: [PATCH 08/14] libnvdimm,
 region: update nd_region_available_dpa() for multi-pmem support
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Oct 2016 09:39:23 -0700
Message-ID: <147585836356.22349.6803275913917776138.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The free dpa (dimm-physical-address) space calculation reports how much
free space is available with consideration for aliased BLK + PMEM
regions.  Recall that BLK capacity is allocated from high addresses and
PMEM is allocated from low addresses in their respective regions.

nd_region_available_dpa() accounts for the fact that the largest
encroachment (lowest starting address) into PMEM capacity by a BLK
allocation limits the available capacity to that point, regardless if
there is BLK allocation hole at a higher address.  Similarly, for the
multi-pmem case we need to track the largest encroachment (highest
 ending address) of a PMEM allocation in BLK capacity regardless of
whether there is an allocation hole that a BLK allocation could fill at
a lower address.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/dimm_devs.c   |  174 +++++++++++++++++++++++++++++++++---------
 drivers/nvdimm/nd-core.h     |    2 
 drivers/nvdimm/region_devs.c |    5 -
 3 files changed, 139 insertions(+), 42 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index cf36470e94c0..4b0296ccb375 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -386,40 +386,148 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 }
 EXPORT_SYMBOL_GPL(nvdimm_create);
 
+struct blk_alloc_info {
+	struct nd_mapping *nd_mapping;
+	resource_size_t available, busy;
+	struct resource *res;
+};
+
+static int alias_dpa_busy(struct device *dev, void *data)
+{
+	resource_size_t map_end, blk_start, new, busy;
+	struct blk_alloc_info *info = data;
+	struct nd_mapping *nd_mapping;
+	struct nd_region *nd_region;
+	struct nvdimm_drvdata *ndd;
+	struct resource *res;
+	int i;
+
+	if (!is_nd_pmem(dev))
+		return 0;
+
+	nd_region = to_nd_region(dev);
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		nd_mapping  = &nd_region->mapping[i];
+		if (nd_mapping->nvdimm == info->nd_mapping->nvdimm)
+			break;
+	}
+
+	if (i >= nd_region->ndr_mappings)
+		return 0;
+
+	ndd = to_ndd(nd_mapping);
+	map_end = nd_mapping->start + nd_mapping->size - 1;
+	blk_start = nd_mapping->start;
+ retry:
+	/*
+	 * Find the free dpa from the end of the last pmem allocation to
+	 * the end of the interleave-set mapping that is not already
+	 * covered by a blk allocation.
+	 */
+	busy = 0;
+	for_each_dpa_resource(ndd, res) {
+		if ((res->start >= blk_start && res->start < map_end)
+				|| (res->end >= blk_start
+					&& res->end <= map_end)) {
+			if (strncmp(res->name, "pmem", 4) == 0) {
+				new = max(blk_start, min(map_end + 1,
+							res->end + 1));
+				if (new != blk_start) {
+					blk_start = new;
+					goto retry;
+				}
+			} else
+				busy += min(map_end, res->end)
+					- max(nd_mapping->start, res->start) + 1;
+		} else if (nd_mapping->start > res->start
+				&& map_end < res->end) {
+			/* total eclipse of the PMEM region mapping */
+			busy += nd_mapping->size;
+			break;
+		}
+	}
+
+	info->available -= blk_start - nd_mapping->start + busy;
+	return 0;
+}
+
+static int blk_dpa_busy(struct device *dev, void *data)
+{
+	struct blk_alloc_info *info = data;
+	struct nd_mapping *nd_mapping;
+	struct nd_region *nd_region;
+	resource_size_t map_end;
+	int i;
+
+	if (!is_nd_pmem(dev))
+		return 0;
+
+	nd_region = to_nd_region(dev);
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		nd_mapping  = &nd_region->mapping[i];
+		if (nd_mapping->nvdimm == info->nd_mapping->nvdimm)
+			break;
+	}
+
+	if (i >= nd_region->ndr_mappings)
+		return 0;
+
+	map_end = nd_mapping->start + nd_mapping->size - 1;
+	if (info->res->start >= nd_mapping->start
+			&& info->res->start < map_end) {
+		if (info->res->end <= map_end) {
+			info->busy = 0;
+			return 1;
+		} else {
+			info->busy -= info->res->end - map_end;
+			return 0;
+		}
+	} else if (info->res->end >= nd_mapping->start
+			&& info->res->end <= map_end) {
+		info->busy -= nd_mapping->start - info->res->start;
+		return 0;
+	} else {
+		info->busy -= nd_mapping->size;
+		return 0;
+	}
+}
+
 /**
  * nd_blk_available_dpa - account the unused dpa of BLK region
  * @nd_mapping: container of dpa-resource-root + labels
  *
- * Unlike PMEM, BLK namespaces can occupy discontiguous DPA ranges.
+ * Unlike PMEM, BLK namespaces can occupy discontiguous DPA ranges, but
+ * we arrange for them to never start at an lower dpa than the last
+ * PMEM allocation in an aliased region.
  */
-resource_size_t nd_blk_available_dpa(struct nd_mapping *nd_mapping)
+resource_size_t nd_blk_available_dpa(struct nd_region *nd_region)
 {
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
+	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	resource_size_t map_end, busy = 0, available;
+	struct blk_alloc_info info = {
+		.nd_mapping = nd_mapping,
+		.available = nd_mapping->size,
+	};
 	struct resource *res;
 
 	if (!ndd)
 		return 0;
 
-	map_end = nd_mapping->start + nd_mapping->size - 1;
-	for_each_dpa_resource(ndd, res)
-		if (res->start >= nd_mapping->start && res->start < map_end) {
-			resource_size_t end = min(map_end, res->end);
+	device_for_each_child(&nvdimm_bus->dev, &info, alias_dpa_busy);
 
-			busy += end - res->start + 1;
-		} else if (res->end >= nd_mapping->start
-				&& res->end <= map_end) {
-			busy += res->end - nd_mapping->start;
-		} else if (nd_mapping->start > res->start
-				&& nd_mapping->start < res->end) {
-			/* total eclipse of the BLK region mapping */
-			busy += nd_mapping->size;
-		}
+	/* now account for busy blk allocations in unaliased dpa */
+	for_each_dpa_resource(ndd, res) {
+		if (strncmp(res->name, "blk", 3) != 0)
+			continue;
 
-	available = map_end - nd_mapping->start + 1;
-	if (busy < available)
-		return available - busy;
-	return 0;
+		info.res = res;
+		info.busy = resource_size(res);
+		device_for_each_child(&nvdimm_bus->dev, &info, blk_dpa_busy);
+		info.available -= info.busy;
+	}
+
+	return info.available;
 }
 
 /**
@@ -451,21 +559,16 @@ resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
 	map_start = nd_mapping->start;
 	map_end = map_start + nd_mapping->size - 1;
 	blk_start = max(map_start, map_end + 1 - *overlap);
-	for_each_dpa_resource(ndd, res)
+	for_each_dpa_resource(ndd, res) {
 		if (res->start >= map_start && res->start < map_end) {
 			if (strncmp(res->name, "blk", 3) == 0)
-				blk_start = min(blk_start, res->start);
-			else if (res->start != map_start) {
+				blk_start = min(blk_start,
+						max(map_start, res->start));
+			else if (res->end > map_end) {
 				reason = "misaligned to iset";
 				goto err;
-			} else {
-				if (busy) {
-					reason = "duplicate overlapping PMEM reservations?";
-					goto err;
-				}
+			} else
 				busy += resource_size(res);
-				continue;
-			}
 		} else if (res->end >= map_start && res->end <= map_end) {
 			if (strncmp(res->name, "blk", 3) == 0) {
 				/*
@@ -474,15 +577,14 @@ resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
 				 * be used for BLK.
 				 */
 				blk_start = map_start;
-			} else {
-				reason = "misaligned to iset";
-				goto err;
-			}
+			} else
+				busy += resource_size(res);
 		} else if (map_start > res->start && map_start < res->end) {
 			/* total eclipse of the mapping */
 			busy += nd_mapping->size;
 			blk_start = map_start;
 		}
+	}
 
 	*overlap = map_end + 1 - blk_start;
 	available = blk_start - map_start;
@@ -491,10 +593,6 @@ resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
 	return 0;
 
  err:
-	/*
-	 * Something is wrong, PMEM must align with the start of the
-	 * interleave set, and there can only be one allocation per set.
-	 */
 	nd_dbg_dpa(nd_region, ndd, res, "%s\n", reason);
 	return 0;
 }
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index fb3ade0d4a83..7c2196a1d56f 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -76,7 +76,7 @@ struct nd_mapping;
 void nd_mapping_free_labels(struct nd_mapping *nd_mapping);
 resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, resource_size_t *overlap);
-resource_size_t nd_blk_available_dpa(struct nd_mapping *nd_mapping);
+resource_size_t nd_blk_available_dpa(struct nd_region *nd_region);
 resource_size_t nd_region_available_dpa(struct nd_region *nd_region);
 resource_size_t nvdimm_allocated_dpa(struct nvdimm_drvdata *ndd,
 		struct nd_label_id *label_id);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 19bcd68c4141..3ac534aec60c 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -294,9 +294,8 @@ resource_size_t nd_region_available_dpa(struct nd_region *nd_region)
 				blk_max_overlap = overlap;
 				goto retry;
 			}
-		} else if (is_nd_blk(&nd_region->dev)) {
-			available += nd_blk_available_dpa(nd_mapping);
-		}
+		} else if (is_nd_blk(&nd_region->dev))
+			available += nd_blk_available_dpa(nd_region);
 	}
 
 	return available;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
