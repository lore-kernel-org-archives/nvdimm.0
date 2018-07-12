Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0EA712097E277
 for <linux-nvdimm@lists.01.org>; Thu, 12 Jul 2018 08:47:32 -0700 (PDT)
From: Keith Busch <keith.busch@intel.com>
Subject: [PATCHv3 1/2] libnvdimm: Use max contiguous area for namespace size
Date: Thu, 12 Jul 2018 09:47:08 -0600
Message-Id: <20180712154709.16444-1-keith.busch@intel.com>
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
To: linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This patch will find the max contiguous area to determine the largest
pmem namespace size that can be created. If the requested size exceeds
the largest available, ENOSPC error will be returned.

This fixes the allocation underrun error and wrong error return code
that have otherwise been observed as the following kernel warning:

  WARNING: CPU: <CPU> PID: <PID> at drivers/nvdimm/namespace_devs.c:913 size_store

Fixes: a1f3e4d6a0c3 ("libnvdimm, region: update nd_region_available_dpa() for multi-pmem support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Keith Busch <keith.busch@intel.com>
---
v2 -> v3:

  This one takes block regions into account by reserving pmem regions
  on dimms and finding the largest intersection among all dimms in
  the region.

 drivers/nvdimm/dimm_devs.c      | 30 ++++++++++++++++++++++++++++++
 drivers/nvdimm/namespace_devs.c |  6 +++---
 drivers/nvdimm/nd-core.h        |  9 +++++++++
 drivers/nvdimm/region_devs.c    | 24 ++++++++++++++++++++++++
 4 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 8d348b22ba45..9e977cbd1a60 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -536,6 +536,36 @@ resource_size_t nd_blk_available_dpa(struct nd_region *nd_region)
 	return info.available;
 }
 
+/**
+ * nd_pmem_max_contiguous_dpa - For the given dimm+region, return the max
+ *			   contiguous unallocated dpa range.
+ * @nd_region: constrain available space check to this reference region
+ * @nd_mapping: container of dpa-resource-root + labels
+ */
+resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
+					   struct nd_mapping *nd_mapping)
+{
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(ndd->dev);
+	resource_size_t max = 0;
+	struct resource *res;
+
+	/* if a dimm is disabled the available capacity is zero */
+	if (!ndd)
+		return 0;
+
+	if (reserve_free_pmem(nvdimm_bus, nd_mapping))
+		return 0;
+	for_each_dpa_resource(ndd, res) {
+		if (strcmp(res->name, "pmem-reserve") != 0)
+			continue;
+		if (resource_size(res) > max)
+			max = resource_size(res);
+	}
+	release_free_pmem(nvdimm_bus, nd_mapping);
+	return max;
+}
+
 /**
  * nd_pmem_available_dpa - for the given dimm+region account unallocated dpa
  * @nd_mapping: container of dpa-resource-root + labels
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 28afdd668905..c3afff2cdf1d 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -836,7 +836,7 @@ static int __reserve_free_pmem(struct device *dev, void *data)
 	return 0;
 }
 
-static void release_free_pmem(struct nvdimm_bus *nvdimm_bus,
+void release_free_pmem(struct nvdimm_bus *nvdimm_bus,
 		struct nd_mapping *nd_mapping)
 {
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
@@ -847,7 +847,7 @@ static void release_free_pmem(struct nvdimm_bus *nvdimm_bus,
 			nvdimm_free_dpa(ndd, res);
 }
 
-static int reserve_free_pmem(struct nvdimm_bus *nvdimm_bus,
+int reserve_free_pmem(struct nvdimm_bus *nvdimm_bus,
 		struct nd_mapping *nd_mapping)
 {
 	struct nvdimm *nvdimm = nd_mapping->nvdimm;
@@ -1032,7 +1032,7 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 
 		allocated += nvdimm_allocated_dpa(ndd, &label_id);
 	}
-	available = nd_region_available_dpa(nd_region);
+	available = nd_region_allocatable_dpa(nd_region);
 
 	if (val > available + allocated)
 		return -ENOSPC;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 79274ead54fb..1c5f5b389940 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -100,6 +100,15 @@ struct nd_region;
 struct nvdimm_drvdata;
 struct nd_mapping;
 void nd_mapping_free_labels(struct nd_mapping *nd_mapping);
+
+int reserve_free_pmem(struct nvdimm_bus *nvdimm_bus,
+		      struct nd_mapping *nd_mapping);
+void release_free_pmem(struct nvdimm_bus *nvdimm_bus,
+		       struct nd_mapping *nd_mapping);
+
+resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
+					   struct nd_mapping *nd_mapping);
+resource_size_t nd_region_allocatable_dpa(struct nd_region *nd_region);
 resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, resource_size_t *overlap);
 resource_size_t nd_blk_available_dpa(struct nd_region *nd_region);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index ec3543b83330..c30d5af02cc2 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -389,6 +389,30 @@ resource_size_t nd_region_available_dpa(struct nd_region *nd_region)
 	return available;
 }
 
+resource_size_t nd_region_allocatable_dpa(struct nd_region *nd_region)
+{
+	resource_size_t available = 0;
+	int i;
+
+	if (is_memory(&nd_region->dev))
+		available = PHYS_ADDR_MAX;
+
+	WARN_ON(!is_nvdimm_bus_locked(&nd_region->dev));
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+
+		if (is_memory(&nd_region->dev))
+			available = min(available,
+					nd_pmem_max_contiguous_dpa(nd_region,
+								   nd_mapping));
+		else if (is_nd_blk(&nd_region->dev))
+			available += nd_blk_available_dpa(nd_region);
+	}
+	if (is_memory(&nd_region->dev))
+		return available * nd_region->ndr_mappings;
+	return available;
+}
+
 static ssize_t available_size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
