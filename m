Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 035911A1E3C
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 09:42:41 -0700 (PDT)
Subject: [PATCH 11/14] libnvdimm,
 namespace: enable allocation of multiple pmem namespaces
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Oct 2016 09:39:39 -0700
Message-ID: <147585837921.22349.71262124305003476.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Now that we have nd_region_available_dpa() able to handle the presence
of multiple PMEM allocations in aliased PMEM regions, reuse that same
infrastructure to track allocations from free space.  In particular
handle allocating from an aliased PMEM region in the case where there
are dis-contiguous holes.  The allocation for BLK and PMEM are
documented in the space_valid() helper:

    BLK-space is valid as long as it does not precede a PMEM
    allocation in a given region. PMEM-space must be contiguous
    and adjacent to an existing existing allocation (if one
    exists).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/dimm_devs.c      |   32 ++++++++--
 drivers/nvdimm/namespace_devs.c |  128 +++++++++++++++++++++++++++------------
 drivers/nvdimm/nd-core.h        |   18 +++++
 3 files changed, 133 insertions(+), 45 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 4b0296ccb375..d614493ad5ac 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -386,13 +386,7 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 }
 EXPORT_SYMBOL_GPL(nvdimm_create);
 
-struct blk_alloc_info {
-	struct nd_mapping *nd_mapping;
-	resource_size_t available, busy;
-	struct resource *res;
-};
-
-static int alias_dpa_busy(struct device *dev, void *data)
+int alias_dpa_busy(struct device *dev, void *data)
 {
 	resource_size_t map_end, blk_start, new, busy;
 	struct blk_alloc_info *info = data;
@@ -418,6 +412,20 @@ static int alias_dpa_busy(struct device *dev, void *data)
 	ndd = to_ndd(nd_mapping);
 	map_end = nd_mapping->start + nd_mapping->size - 1;
 	blk_start = nd_mapping->start;
+
+	/*
+	 * In the allocation case ->res is set to free space that we are
+	 * looking to validate against PMEM aliasing collision rules
+	 * (i.e. BLK is allocated after all aliased PMEM).
+	 */
+	if (info->res) {
+		if (info->res->start >= nd_mapping->start
+				&& info->res->start < map_end)
+			/* pass */;
+		else
+			return 0;
+	}
+
  retry:
 	/*
 	 * Find the free dpa from the end of the last pmem allocation to
@@ -447,7 +455,16 @@ static int alias_dpa_busy(struct device *dev, void *data)
 		}
 	}
 
+	/* update the free space range with the probed blk_start */
+	if (info->res && blk_start > info->res->start) {
+		info->res->start = max(info->res->start, blk_start);
+		if (info->res->start > info->res->end)
+			info->res->end = info->res->start - 1;
+		return 1;
+	}
+
 	info->available -= blk_start - nd_mapping->start + busy;
+
 	return 0;
 }
 
@@ -508,6 +525,7 @@ resource_size_t nd_blk_available_dpa(struct nd_region *nd_region)
 	struct blk_alloc_info info = {
 		.nd_mapping = nd_mapping,
 		.available = nd_mapping->size,
+		.res = NULL,
 	};
 	struct resource *res;
 
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 132c5b8b5366..81451c74b01c 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -529,19 +529,68 @@ static resource_size_t init_dpa_allocation(struct nd_label_id *label_id,
 	return rc ? n : 0;
 }
 
-static bool space_valid(bool is_pmem, bool is_reserve,
-		struct nd_label_id *label_id, struct resource *res)
+
+/**
+ * space_valid() - validate free dpa space against constraints
+ * @nd_region: hosting region of the free space
+ * @ndd: dimm device data for debug
+ * @label_id: namespace id to allocate space
+ * @prev: potential allocation that precedes free space
+ * @next: allocation that follows the given free space range
+ * @exist: first allocation with same id in the mapping
+ * @n: range that must satisfied for pmem allocations
+ * @valid: free space range to validate
+ *
+ * BLK-space is valid as long as it does not precede a PMEM
+ * allocation in a given region. PMEM-space must be contiguous
+ * and adjacent to an existing existing allocation (if one
+ * exists).  If reserving PMEM any space is valid.
+ */
+static void space_valid(struct nd_region *nd_region, struct nvdimm_drvdata *ndd,
+		struct nd_label_id *label_id, struct resource *prev,
+		struct resource *next, struct resource *exist,
+		resource_size_t n, struct resource *valid)
 {
-	/*
-	 * For BLK-space any space is valid, for PMEM-space, it must be
-	 * contiguous with an existing allocation unless we are
-	 * reserving pmem.
-	 */
-	if (is_reserve || !is_pmem)
-		return true;
-	if (!res || strcmp(res->name, label_id->id) == 0)
-		return true;
-	return false;
+	bool is_reserve = strcmp(label_id->id, "pmem-reserve") == 0;
+	bool is_pmem = strncmp(label_id->id, "pmem", 4) == 0;
+
+	if (valid->start >= valid->end)
+		goto invalid;
+
+	if (is_reserve)
+		return;
+
+	if (!is_pmem) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+		struct nvdimm_bus *nvdimm_bus;
+		struct blk_alloc_info info = {
+			.nd_mapping = nd_mapping,
+			.available = nd_mapping->size,
+			.res = valid,
+		};
+
+		WARN_ON(!is_nd_blk(&nd_region->dev));
+		nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
+		device_for_each_child(&nvdimm_bus->dev, &info, alias_dpa_busy);
+		return;
+	}
+
+	/* allocation needs to be contiguous, so this is all or nothing */
+	if (resource_size(valid) < n)
+		goto invalid;
+
+	/* we've got all the space we need and no existing allocation */
+	if (!exist)
+		return;
+
+	/* allocation needs to be contiguous with the existing namespace */
+	if (valid->start == exist->end + 1
+			|| valid->end == exist->start - 1)
+		return;
+
+ invalid:
+	/* truncate @valid size to 0 */
+	valid->end = valid->start - 1;
 }
 
 enum alloc_loc {
@@ -553,18 +602,24 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 		resource_size_t n)
 {
 	resource_size_t mapping_end = nd_mapping->start + nd_mapping->size - 1;
-	bool is_reserve = strcmp(label_id->id, "pmem-reserve") == 0;
 	bool is_pmem = strncmp(label_id->id, "pmem", 4) == 0;
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct resource *res, *exist = NULL, valid;
 	const resource_size_t to_allocate = n;
-	struct resource *res;
 	int first;
 
+	for_each_dpa_resource(ndd, res)
+		if (strcmp(label_id->id, res->name) == 0)
+			exist = res;
+
+	valid.start = nd_mapping->start;
+	valid.end = mapping_end;
+	valid.name = "free space";
  retry:
 	first = 0;
 	for_each_dpa_resource(ndd, res) {
-		resource_size_t allocate, available = 0, free_start, free_end;
 		struct resource *next = res->sibling, *new_res = NULL;
+		resource_size_t allocate, available = 0;
 		enum alloc_loc loc = ALLOC_ERR;
 		const char *action;
 		int rc = 0;
@@ -577,32 +632,35 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 
 		/* space at the beginning of the mapping */
 		if (!first++ && res->start > nd_mapping->start) {
-			free_start = nd_mapping->start;
-			available = res->start - free_start;
-			if (space_valid(is_pmem, is_reserve, label_id, NULL))
+			valid.start = nd_mapping->start;
+			valid.end = res->start - 1;
+			space_valid(nd_region, ndd, label_id, NULL, next, exist,
+					to_allocate, &valid);
+			available = resource_size(&valid);
+			if (available)
 				loc = ALLOC_BEFORE;
 		}
 
 		/* space between allocations */
 		if (!loc && next) {
-			free_start = res->start + resource_size(res);
-			free_end = min(mapping_end, next->start - 1);
-			if (space_valid(is_pmem, is_reserve, label_id, res)
-					&& free_start < free_end) {
-				available = free_end + 1 - free_start;
+			valid.start = res->start + resource_size(res);
+			valid.end = min(mapping_end, next->start - 1);
+			space_valid(nd_region, ndd, label_id, res, next, exist,
+					to_allocate, &valid);
+			available = resource_size(&valid);
+			if (available)
 				loc = ALLOC_MID;
-			}
 		}
 
 		/* space at the end of the mapping */
 		if (!loc && !next) {
-			free_start = res->start + resource_size(res);
-			free_end = mapping_end;
-			if (space_valid(is_pmem, is_reserve, label_id, res)
-					&& free_start < free_end) {
-				available = free_end + 1 - free_start;
+			valid.start = res->start + resource_size(res);
+			valid.end = mapping_end;
+			space_valid(nd_region, ndd, label_id, res, next, exist,
+					to_allocate, &valid);
+			available = resource_size(&valid);
+			if (available)
 				loc = ALLOC_AFTER;
-			}
 		}
 
 		if (!loc || !available)
@@ -612,8 +670,6 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 		case ALLOC_BEFORE:
 			if (strcmp(res->name, label_id->id) == 0) {
 				/* adjust current resource up */
-				if (is_pmem && !is_reserve)
-					return n;
 				rc = adjust_resource(res, res->start - allocate,
 						resource_size(res) + allocate);
 				action = "cur grow up";
@@ -623,8 +679,6 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 		case ALLOC_MID:
 			if (strcmp(next->name, label_id->id) == 0) {
 				/* adjust next resource up */
-				if (is_pmem && !is_reserve)
-					return n;
 				rc = adjust_resource(next, next->start
 						- allocate, resource_size(next)
 						+ allocate);
@@ -648,12 +702,10 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 		if (strcmp(action, "allocate") == 0) {
 			/* BLK allocate bottom up */
 			if (!is_pmem)
-				free_start += available - allocate;
-			else if (!is_reserve && free_start != nd_mapping->start)
-				return n;
+				valid.start += available - allocate;
 
 			new_res = nvdimm_allocate_dpa(ndd, label_id,
-					free_start, allocate);
+					valid.start, allocate);
 			if (!new_res)
 				rc = -EBUSY;
 		} else if (strcmp(action, "grow down") == 0) {
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 7c2196a1d56f..3ba0b96ce7de 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -44,6 +44,23 @@ struct nvdimm {
 	struct resource *flush_wpq;
 };
 
+/**
+ * struct blk_alloc_info - tracking info for BLK dpa scanning
+ * @nd_mapping: blk region mapping boundaries
+ * @available: decremented in alias_dpa_busy as aliased PMEM is scanned
+ * @busy: decremented in blk_dpa_busy to account for ranges already
+ * 	  handled by alias_dpa_busy
+ * @res: alias_dpa_busy interprets this a free space range that needs to
+ * 	 be truncated to the valid BLK allocation starting DPA, blk_dpa_busy
+ * 	 treats it as a busy range that needs the aliased PMEM ranges
+ * 	 truncated.
+ */
+struct blk_alloc_info {
+	struct nd_mapping *nd_mapping;
+	resource_size_t available, busy;
+	struct resource *res;
+};
+
 bool is_nvdimm(struct device *dev);
 bool is_nd_pmem(struct device *dev);
 bool is_nd_blk(struct device *dev);
@@ -80,6 +97,7 @@ resource_size_t nd_blk_available_dpa(struct nd_region *nd_region);
 resource_size_t nd_region_available_dpa(struct nd_region *nd_region);
 resource_size_t nvdimm_allocated_dpa(struct nvdimm_drvdata *ndd,
 		struct nd_label_id *label_id);
+int alias_dpa_busy(struct device *dev, void *data);
 struct resource *nsblk_add_resource(struct nd_region *nd_region,
 		struct nvdimm_drvdata *ndd, struct nd_namespace_blk *nsblk,
 		resource_size_t start);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
