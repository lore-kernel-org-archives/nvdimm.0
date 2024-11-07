Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA8621893D
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 20:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731013145; cv=none; b=takvYPxSoNHWk5yrnxnGxyFjreLJpE2gifIWzW89dXngDswjBzuRzxffrWslo6jg8D9Lmjae34EUEa7PraJwaB0XCmHyOzd5coPPXEsgkQYCCWPiGPo3LdnX2grmFycTRzjhqhbZ4cZjnDH8ajZFZLQTUlrpzNqlvqfjsnn3mus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731013145; c=relaxed/simple;
	bh=JRh0V38YDcT6tPDtCH0/XEXvjvL2eQo9unAh5i5Tvmg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Co7i5gIUx5he9ZqrfT5TMOvIB/KltQ/apkIUm3/ll6sGirebTjankKJxD1xqKiJ76Eiw+21ELh74Y4/Z9o/McVLHwadRDFIGIQWAGmJ7Ly1iloQCVyH9qmjxg6HNyKMgumAhKLtssDbCGDOoENVxX4LIkf7goDnpPPIQ8m4HVXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UHpr9WOZ; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UHpr9WOZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731013144; x=1762549144;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=JRh0V38YDcT6tPDtCH0/XEXvjvL2eQo9unAh5i5Tvmg=;
  b=UHpr9WOZNI5QCYv1SLCwdO5/FlToRFg9TNAj+83ohWxVsgnQ1SXzg9U1
   DziHMr2GjBP5f1Z01yigkHn0KUeyf0xHJ4rrSdFMjOXlC0p6ZIB3AQlTj
   kep5vdd/WG21je2PaupE/S0LzpoZSPj5V9AWkZQKk6cy9QnXlDcBbmHZC
   P9pu8o1kk9/X9sxZtbkgL1Ke+FonBInhFDOXYtyk9mvK8HG5GlFQI42iX
   RQtfFSXc7/yHVNtC22y0GI87GQGB0q8wTm7zmayO9HtFkXyA77ES6zB/H
   3vDoBZPmZwmxQ3/7zqiHwdkg7aTbFeId9Yhxgoe/XIBJIkFoRenXSV7/Q
   Q==;
X-CSE-ConnectionGUID: 759CQKRSSxmgBXGgj7sn1g==
X-CSE-MsgGUID: peMIeUr3Q+aKvS2j8xfOTQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41441040"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41441040"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:59:04 -0800
X-CSE-ConnectionGUID: QDSONlnMTGa7q+6Q8UStZg==
X-CSE-MsgGUID: hTR+LSoaSny1DN6i+JSXag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="122746022"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.195])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:59:03 -0800
From: ira.weiny@intel.com
Date: Thu, 07 Nov 2024 14:58:33 -0600
Subject: [PATCH v7 15/27] cxl/region: Add sparse DAX region support
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-dcd-type2-upstream-v7-15-56a84e66bc36@intel.com>
References: <20241107-dcd-type2-upstream-v7-0-56a84e66bc36@intel.com>
In-Reply-To: <20241107-dcd-type2-upstream-v7-0-56a84e66bc36@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731013104; l=11790;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=+CDIvMYBKRG5f3zYK1SZ76xdWI5Q/cyLSdTOm/V8Gdw=;
 b=Wj3D8bDXyLCaKzTiFTb9fkC5hZm1FuQyvKTc7bBe5cYCO8p3ACfCJcTj3OXkXj1K/pxdeLdWe
 l4dmcGgzc/TDNQt8mpaiGtMe+jPSdt7XTKMe7v2KfgdJWhufTgHEBys
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

Dynamic Capacity CXL regions must allow memory to be added or removed
dynamically.  In addition to the quantity of memory available the
location of the memory within a DC partition is dynamic based on the
extents offered by a device.  CXL DAX regions must accommodate the
sparseness of this memory in the management of DAX regions and devices.

Introduce the concept of a sparse DAX region.  Add a create_dc_region()
sysfs entry to create such regions.  Special case DC capable regions to
create a 0 sized seed DAX device to maintain compatibility which
requires a default DAX device to hold a region reference.

Indicate 0 byte available capacity until such time that capacity is
added.

Sparse regions complicate the range mapping of dax devices.  There is no
known use case for range mapping on sparse regions.  Avoid the
complication by preventing range mapping of dax devices on sparse
regions.

Interleaving is deferred for now.  Add checks.

Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl | 22 ++++++++--------
 drivers/cxl/core/core.h                 | 12 +++++++++
 drivers/cxl/core/port.c                 |  1 +
 drivers/cxl/core/region.c               | 46 +++++++++++++++++++++++++++++++--
 drivers/dax/bus.c                       | 10 +++++++
 drivers/dax/bus.h                       |  1 +
 drivers/dax/cxl.c                       | 16 ++++++++++--
 7 files changed, 93 insertions(+), 15 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 8d990d702f63363879150cf523c0be6229f315e0..aeff248ea368cf49c9977fcaf43ab4def978e896 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -439,20 +439,20 @@ Description:
 		interleave_granularity).
 
 
-What:		/sys/bus/cxl/devices/decoderX.Y/create_{pmem,ram}_region
-Date:		May, 2022, January, 2023
-KernelVersion:	v6.0 (pmem), v6.3 (ram)
+What:		/sys/bus/cxl/devices/decoderX.Y/create_{pmem,ram,dc}_region
+Date:		May, 2022, January, 2023, August 2024
+KernelVersion:	v6.0 (pmem), v6.3 (ram), v6.13 (dc)
 Contact:	linux-cxl@vger.kernel.org
 Description:
 		(RW) Write a string in the form 'regionZ' to start the process
-		of defining a new persistent, or volatile memory region
-		(interleave-set) within the decode range bounded by root decoder
-		'decoderX.Y'. The value written must match the current value
-		returned from reading this attribute. An atomic compare exchange
-		operation is done on write to assign the requested id to a
-		region and allocate the region-id for the next creation attempt.
-		EBUSY is returned if the region name written does not match the
-		current cached value.
+		of defining a new persistent, volatile, or Dynamic Capacity
+		(DC) memory region (interleave-set) within the decode range
+		bounded by root decoder 'decoderX.Y'. The value written must
+		match the current value returned from reading this attribute.
+		An atomic compare exchange operation is done on write to assign
+		the requested id to a region and allocate the region-id for the
+		next creation attempt.  EBUSY is returned if the region name
+		written does not match the current cached value.
 
 
 What:		/sys/bus/cxl/devices/decoderX.Y/delete_region
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 0c62b4069ba00a5380d456a516eb7968dc51062b..5d6fe7ab0a78cddb01c7e0d63ed55c36879c4cef 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -4,15 +4,27 @@
 #ifndef __CXL_CORE_H__
 #define __CXL_CORE_H__
 
+#include <cxlmem.h>
+
 extern const struct device_type cxl_nvdimm_bridge_type;
 extern const struct device_type cxl_nvdimm_type;
 extern const struct device_type cxl_pmu_type;
 
 extern struct attribute_group cxl_base_attribute_group;
 
+static inline struct cxl_memdev_state *
+cxled_to_mds(struct cxl_endpoint_decoder *cxled)
+{
+	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+
+	return container_of(cxlds, struct cxl_memdev_state, cxlds);
+}
+
 #ifdef CONFIG_CXL_REGION
 extern struct device_attribute dev_attr_create_pmem_region;
 extern struct device_attribute dev_attr_create_ram_region;
+extern struct device_attribute dev_attr_create_dc_region;
 extern struct device_attribute dev_attr_delete_region;
 extern struct device_attribute dev_attr_region;
 extern const struct device_type cxl_pmem_region_type;
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 2f42c8717a65586c769f0fd2016e8addc2552f9d..0eeb42f14bcab76965dbd0813b29c918007c3021 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -326,6 +326,7 @@ static struct attribute *cxl_decoder_root_attrs[] = {
 	&dev_attr_qos_class.attr,
 	SET_CXL_REGION_ATTR(create_pmem_region)
 	SET_CXL_REGION_ATTR(create_ram_region)
+	SET_CXL_REGION_ATTR(create_dc_region)
 	SET_CXL_REGION_ATTR(delete_region)
 	NULL,
 };
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 2ca6148d108cc020bebcb34b09028fa59bb62f02..34a6f447e75b18e6a1c8c27250a3e425bd0cc515 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -496,6 +496,11 @@ static ssize_t interleave_ways_store(struct device *dev,
 	if (rc)
 		return rc;
 
+	if (cxlr->mode == CXL_REGION_DC && val != 1) {
+		dev_err(dev, "Interleaving and DCD not supported\n");
+		return -EINVAL;
+	}
+
 	rc = ways_to_eiw(val, &iw);
 	if (rc)
 		return rc;
@@ -2176,6 +2181,7 @@ static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int pos,
 	if (sysfs_streq(buf, "\n"))
 		rc = detach_target(cxlr, pos);
 	else {
+		struct cxl_endpoint_decoder *cxled;
 		struct device *dev;
 
 		dev = bus_find_device_by_name(&cxl_bus_type, NULL, buf);
@@ -2187,8 +2193,13 @@ static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int pos,
 			goto out;
 		}
 
-		rc = attach_target(cxlr, to_cxl_endpoint_decoder(dev), pos,
-				   TASK_INTERRUPTIBLE);
+		cxled = to_cxl_endpoint_decoder(dev);
+		if (cxlr->mode == CXL_REGION_DC &&
+		    !cxl_dcd_supported(cxled_to_mds(cxled))) {
+			dev_dbg(dev, "DCD unsupported\n");
+			return -EINVAL;
+		}
+		rc = attach_target(cxlr, cxled, pos, TASK_INTERRUPTIBLE);
 out:
 		put_device(dev);
 	}
@@ -2533,6 +2544,7 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 	switch (mode) {
 	case CXL_REGION_RAM:
 	case CXL_REGION_PMEM:
+	case CXL_REGION_DC:
 		break;
 	default:
 		dev_err(&cxlrd->cxlsd.cxld.dev, "unsupported mode %s\n",
@@ -2586,6 +2598,20 @@ static ssize_t create_ram_region_store(struct device *dev,
 }
 DEVICE_ATTR_RW(create_ram_region);
 
+static ssize_t create_dc_region_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	return __create_region_show(to_cxl_root_decoder(dev), buf);
+}
+
+static ssize_t create_dc_region_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	return create_region_store(dev, buf, len, CXL_REGION_DC);
+}
+DEVICE_ATTR_RW(create_dc_region);
+
 static ssize_t region_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
@@ -3168,6 +3194,11 @@ static int devm_cxl_add_dax_region(struct cxl_region *cxlr)
 	struct device *dev;
 	int rc;
 
+	if (cxlr->mode == CXL_REGION_DC && cxlr->params.interleave_ways != 1) {
+		dev_err(&cxlr->dev, "Interleaving DC not supported\n");
+		return -EINVAL;
+	}
+
 	cxlr_dax = cxl_dax_region_alloc(cxlr);
 	if (IS_ERR(cxlr_dax))
 		return PTR_ERR(cxlr_dax);
@@ -3260,6 +3291,16 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
 		return ERR_PTR(-EINVAL);
 
 	mode = cxl_decoder_to_region_mode(cxled->mode);
+	if (mode == CXL_REGION_DC) {
+		if (!cxl_dcd_supported(cxled_to_mds(cxled))) {
+			dev_err(&cxled->cxld.dev, "DCD unsupported\n");
+			return ERR_PTR(-EINVAL);
+		}
+		if (cxled->cxld.interleave_ways != 1) {
+			dev_err(&cxled->cxld.dev, "Interleaving and DCD not supported\n");
+			return ERR_PTR(-EINVAL);
+		}
+	}
 	do {
 		cxlr = __create_region(cxlrd, mode,
 				       atomic_read(&cxlrd->region_id));
@@ -3467,6 +3508,7 @@ static int cxl_region_probe(struct device *dev)
 	case CXL_REGION_PMEM:
 		return devm_cxl_add_pmem_region(cxlr);
 	case CXL_REGION_RAM:
+	case CXL_REGION_DC:
 		/*
 		 * The region can not be manged by CXL if any portion of
 		 * it is already online as 'System RAM'
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index fde29e0ad68b158c5c88262d434ee7b55a5ce407..d8cb5195a227c0f6194cb210510e006327e1b35b 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -178,6 +178,11 @@ static bool is_static(struct dax_region *dax_region)
 	return (dax_region->res.flags & IORESOURCE_DAX_STATIC) != 0;
 }
 
+static bool is_sparse(struct dax_region *dax_region)
+{
+	return (dax_region->res.flags & IORESOURCE_DAX_SPARSE_CAP) != 0;
+}
+
 bool static_dev_dax(struct dev_dax *dev_dax)
 {
 	return is_static(dev_dax->region);
@@ -301,6 +306,9 @@ static unsigned long long dax_region_avail_size(struct dax_region *dax_region)
 
 	lockdep_assert_held(&dax_region_rwsem);
 
+	if (is_sparse(dax_region))
+		return 0;
+
 	for_each_dax_region_resource(dax_region, res)
 		size -= resource_size(res);
 	return size;
@@ -1373,6 +1381,8 @@ static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 		return 0;
 	if (a == &dev_attr_mapping.attr && is_static(dax_region))
 		return 0;
+	if (a == &dev_attr_mapping.attr && is_sparse(dax_region))
+		return 0;
 	if ((a == &dev_attr_align.attr ||
 	     a == &dev_attr_size.attr) && is_static(dax_region))
 		return 0444;
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index cbbf64443098c08d944878a190a0da69eccbfbf4..783bfeef42cc6c4d74f24e0a69dac5598eaf1664 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -13,6 +13,7 @@ struct dax_region;
 /* dax bus specific ioresource flags */
 #define IORESOURCE_DAX_STATIC BIT(0)
 #define IORESOURCE_DAX_KMEM BIT(1)
+#define IORESOURCE_DAX_SPARSE_CAP BIT(2)
 
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		struct range *range, int target_node, unsigned int align,
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 9b29e732b39a691fbd8ac0391b477b1584b59568..367e86b1c22a2a0af7070677a7b7fc54bc2b0214 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -13,19 +13,31 @@ static int cxl_dax_region_probe(struct device *dev)
 	struct cxl_region *cxlr = cxlr_dax->cxlr;
 	struct dax_region *dax_region;
 	struct dev_dax_data data;
+	resource_size_t dev_size;
+	unsigned long flags;
 
 	if (nid == NUMA_NO_NODE)
 		nid = memory_add_physaddr_to_nid(cxlr_dax->hpa_range.start);
 
+	flags = IORESOURCE_DAX_KMEM;
+	if (cxlr->mode == CXL_REGION_DC)
+		flags |= IORESOURCE_DAX_SPARSE_CAP;
+
 	dax_region = alloc_dax_region(dev, cxlr->id, &cxlr_dax->hpa_range, nid,
-				      PMD_SIZE, IORESOURCE_DAX_KMEM);
+				      PMD_SIZE, flags);
 	if (!dax_region)
 		return -ENOMEM;
 
+	if (cxlr->mode == CXL_REGION_DC)
+		/* Add empty seed dax device */
+		dev_size = 0;
+	else
+		dev_size = range_len(&cxlr_dax->hpa_range);
+
 	data = (struct dev_dax_data) {
 		.dax_region = dax_region,
 		.id = -1,
-		.size = range_len(&cxlr_dax->hpa_range),
+		.size = dev_size,
 		.memmap_on_memory = true,
 	};
 

-- 
2.47.0

