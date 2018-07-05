Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD561210E2DA7
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 13:19:47 -0700 (PDT)
From: Keith Busch <keith.busch@intel.com>
Subject: [PATCHv2 1/2] libnvdimm: Use max contiguous area for namespace size
Date: Thu,  5 Jul 2018 14:17:25 -0600
Message-Id: <20180705201726.512-1-keith.busch@intel.com>
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
namespace size that can be created. If the requested size exceeds the
largest available, ENOSPC error will be returned.

This fixes the allocation underrun error and wrong error return code
that have otherwise been observed as the following kernel warning:

  WARNING: CPU: <CPU> PID: <PID> at drivers/nvdimm/namespace_devs.c:913 size_store

Fixes: a1f3e4d6a0c3 ("libnvdimm, region: update nd_region_available_dpa() for multi-pmem support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Keith Busch <keith.busch@intel.com>
---
v1 -> v2:

  Updated changelog to indicate the warning this patch fixes and copy
  stable.

  Fixed code comments with the correct name of a function

 drivers/nvdimm/dimm_devs.c      | 29 +++++++++++++++++++++++++++++
 drivers/nvdimm/namespace_devs.c |  2 +-
 drivers/nvdimm/nd-core.h        |  3 +++
 drivers/nvdimm/region_devs.c    | 23 +++++++++++++++++++++++
 4 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 8d348b22ba45..791a93cd8eb1 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -536,6 +536,35 @@ resource_size_t nd_blk_available_dpa(struct nd_region *nd_region)
 	return info.available;
 }
 
+/**
+ * nd_pmem_max_contiguous_dpa - For the given dimm+region, return the max
+ *				contiguous unallocated dpa range.
+ * @nd_region: constrain available space check to this reference region
+ * @nd_mapping: container of dpa-resource-root + labels
+ */
+resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
+					   struct nd_mapping *nd_mapping)
+{
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+	resource_size_t start, end, max = 0;
+	struct resource *res;
+
+	if (!ndd)
+		return 0;
+
+	start = nd_mapping->start;
+	end = start + nd_mapping->size;
+
+	for_each_dpa_resource(ndd, res) {
+		if ((res->start - start) > max)
+			max = res->start - start;
+		start = res->start + resource_size(res);
+	}
+	if (start < end && end - start > max)
+		max = end - start;
+	return max;
+}
+
 /**
  * nd_pmem_available_dpa - for the given dimm+region account unallocated dpa
  * @nd_mapping: container of dpa-resource-root + labels
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 28afdd668905..c00d1d2d48f9 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1032,7 +1032,7 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 
 		allocated += nvdimm_allocated_dpa(ndd, &label_id);
 	}
-	available = nd_region_available_dpa(nd_region);
+	available = nd_region_contiguous_max(nd_region);
 
 	if (val > available + allocated)
 		return -ENOSPC;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 79274ead54fb..8e4acd075b0f 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -100,6 +100,9 @@ struct nd_region;
 struct nvdimm_drvdata;
 struct nd_mapping;
 void nd_mapping_free_labels(struct nd_mapping *nd_mapping);
+resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
+					   struct nd_mapping *nd_mapping);
+resource_size_t nd_region_contiguous_max(struct nd_region *nd_region);
 resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, resource_size_t *overlap);
 resource_size_t nd_blk_available_dpa(struct nd_region *nd_region);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index ec3543b83330..8af483d7ef57 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -357,6 +357,29 @@ static ssize_t set_cookie_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(set_cookie);
 
+resource_size_t nd_region_contiguous_max(struct nd_region *nd_region)
+{
+	resource_size_t available = 0;
+	int i;
+
+	WARN_ON(!is_nvdimm_bus_locked(&nd_region->dev));
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+
+		/* if a dimm is disabled the available capacity is zero */
+		if (!ndd)
+			return 0;
+
+		if (is_memory(&nd_region->dev))
+			available += nd_pmem_max_contiguous_dpa(nd_region,
+								nd_mapping);
+		else if (is_nd_blk(&nd_region->dev))
+			available += nd_blk_available_dpa(nd_region);
+	}
+	return available;
+}
+
 resource_size_t nd_region_available_dpa(struct nd_region *nd_region)
 {
 	resource_size_t blk_max_overlap = 0, available, overlap;
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
