Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACBD1C9DCF
	for <nvdimm@lists.linux.dev>; Fri, 16 Aug 2024 14:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723819521; cv=none; b=E3uLA0AWEFlSjQT8O5ZUzRPpkuTUm3RkLIg+caCrrB9T/pjcjfTw5l43od/AmeJ6fFXEKuAdHh8d9z+/+2k0IDCTU3WoJpYm3t93jxs6T98U6O/Y/DToZXgP7i5Om/5ANngcIj2qZ/35LvDjpwDa6QWHybICS5CkgnTazeOksYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723819521; c=relaxed/simple;
	bh=uhWZ3N3tkYuVbTriArf1p2KiIjpv3vdwFOAw9cg65g0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GYBIF6MCigX9l5fR1LX6HnLJ+uCME0zn7BQ4qmUHpEUzXORMrMHocAv5IOA5dSgjjF0p0sXjdnM82K5+g6MmA2jeMY2xsNZikYBhpQTQOQPnUL/eeYIlhlNxNFVxjUkQ1CyAR6aGQF0Mi0EeDUJvFeq0VbpQOdCGMsPou/xe310=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OwyFCO4r; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OwyFCO4r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723819520; x=1755355520;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=uhWZ3N3tkYuVbTriArf1p2KiIjpv3vdwFOAw9cg65g0=;
  b=OwyFCO4r0Vhu9x6WCfUlaSNapdbcoOp2aVdiWIrOyYZeXgeN4+YuEkGe
   IPsb+sczPYwzCoqzdCYOq3lYhckScUqRZQai4PSFsVS0O5Yt91LPN8CCf
   OUJhQT7TnzuMQ0J9H8GMb9lkSwZRduLPCj3QFQoavzK0k0uspvNjkckS/
   efRzaDppY042dRGuMdAsfadCCtJlOgNbaev+/q5u/B577aAJde5onFvis
   gKbuV6NcGfnfs/0lhUzHW8kgm8w683S5Bjjmws0HcfVUTEd8V0muFmWQa
   4zNgL6mSfn/Yyv92ktj5zST2LrqEO7tiIqe8b10I/Hj9EbY/rb4wkyFyl
   Q==;
X-CSE-ConnectionGUID: nshRjGfbSfSeXlDF5UpS9A==
X-CSE-MsgGUID: jgbKpt5qRoi8eZZEMlbyAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11166"; a="21973097"
X-IronPort-AV: E=Sophos;i="6.10,152,1719903600"; 
   d="scan'208";a="21973097"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 07:45:18 -0700
X-CSE-ConnectionGUID: XiwB8az8Sx6h1UxspYaXXQ==
X-CSE-MsgGUID: /fQjt6FHRnqLbiqPE3kWYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,152,1719903600"; 
   d="scan'208";a="97205592"
Received: from iweiny-mobl.amr.corp.intel.com (HELO localhost) ([10.125.111.52])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 07:45:16 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Fri, 16 Aug 2024 09:44:28 -0500
Subject: [PATCH v3 20/25] dax/bus: Factor out dev dax resize logic
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240816-dcd-type2-upstream-v3-20-7c9b96cba6d7@intel.com>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
In-Reply-To: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Chris Mason <clm@fb.com>, 
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, 
 Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=ed25519-sha256; t=1723819456; l=8750;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=uhWZ3N3tkYuVbTriArf1p2KiIjpv3vdwFOAw9cg65g0=;
 b=0PEhxlXqDqdxRIzufr+0rqTBXRwDciOpJcaF5Rc6C4Cmz7iVOUADC/qYJ7OgWWSMCRpqeNLhG
 UoF4KQA2knyDiGo1Qr9ZlSww8zc+B2C9mvIw6XU4J5oCdYcQKBW2hyL
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Dynamic Capacity regions must limit dev dax resources to those areas
which have extents backing real memory.  Such DAX regions are dubbed
'sparse' regions.  In order to manage where memory is available four
alternatives were considered:

1) Create a single region resource child on region creation which
   reserves the entire region.  Then as extents are added punch holes in
   this reservation.  This requires new resource manipulation to punch
   the holes and still requires an additional iteration over the extent
   areas which may already have existing dev dax resources used.

2) Maintain an ordered xarray of extents which can be queried while
   processing the resize logic.  The issue is that existing region->res
   children may artificially limit the allocation size sent to
   alloc_dev_dax_range().  IE the resource children can't be directly
   used in the resize logic to find where space in the region is.  This
   also poses a problem of managing the available size in 2 places.

3) Maintain a separate resource tree with extents.  This option is the
   same as 2) but with the different data structure.  Most ideally there
   should be a unified representation of the resource tree not two places
   to look for space.

4) Create region resource children for each extent.  Manage the dax dev
   resize logic in the same way as before but use a region child
   (extent) resource as the parents to find space within each extent.

Option 4 can leverage the existing resize algorithm to find space within
the extents.  It manages the available space in a singular resource tree
which is less complicated for finding space.

In preparation for this change, factor out the dev_dax_resize logic.
For static regions use dax_region->res as the parent to find space for
the dax ranges.  Future patches will use the same algorithm with
individual extent resources as the parent.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
Changes:
[iweiny: Rebase on new DAX region locking]
[iweiny: Reword commit message]
[iweiny: Drop reviews]
---
 drivers/dax/bus.c | 129 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 79 insertions(+), 50 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index d8cb5195a227..975860371d9f 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -844,11 +844,9 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
 	return 0;
 }
 
-static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
-		resource_size_t size)
+static int alloc_dev_dax_range(struct resource *parent, struct dev_dax *dev_dax,
+			       u64 start, resource_size_t size)
 {
-	struct dax_region *dax_region = dev_dax->region;
-	struct resource *res = &dax_region->res;
 	struct device *dev = &dev_dax->dev;
 	struct dev_dax_range *ranges;
 	unsigned long pgoff = 0;
@@ -866,14 +864,14 @@ static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
 		return 0;
 	}
 
-	alloc = __request_region(res, start, size, dev_name(dev), 0);
+	alloc = __request_region(parent, start, size, dev_name(dev), 0);
 	if (!alloc)
 		return -ENOMEM;
 
 	ranges = krealloc(dev_dax->ranges, sizeof(*ranges)
 			* (dev_dax->nr_range + 1), GFP_KERNEL);
 	if (!ranges) {
-		__release_region(res, alloc->start, resource_size(alloc));
+		__release_region(parent, alloc->start, resource_size(alloc));
 		return -ENOMEM;
 	}
 
@@ -1026,50 +1024,45 @@ static bool adjust_ok(struct dev_dax *dev_dax, struct resource *res)
 	return true;
 }
 
-static ssize_t dev_dax_resize(struct dax_region *dax_region,
-		struct dev_dax *dev_dax, resource_size_t size)
+/**
+ * dev_dax_resize_static - Expand the device into the unused portion of the
+ * region. This may involve adjusting the end of an existing resource, or
+ * allocating a new resource.
+ *
+ * @parent: parent resource to allocate this range in
+ * @dev_dax: DAX device to be expanded
+ * @to_alloc: amount of space to alloc; must be <= space available in @parent
+ *
+ * Return the amount of space allocated or -ERRNO on failure
+ */
+static ssize_t dev_dax_resize_static(struct resource *parent,
+				     struct dev_dax *dev_dax,
+				     resource_size_t to_alloc)
 {
-	resource_size_t avail = dax_region_avail_size(dax_region), to_alloc;
-	resource_size_t dev_size = dev_dax_size(dev_dax);
-	struct resource *region_res = &dax_region->res;
-	struct device *dev = &dev_dax->dev;
 	struct resource *res, *first;
-	resource_size_t alloc = 0;
 	int rc;
 
-	if (dev->driver)
-		return -EBUSY;
-	if (size == dev_size)
-		return 0;
-	if (size > dev_size && size - dev_size > avail)
-		return -ENOSPC;
-	if (size < dev_size)
-		return dev_dax_shrink(dev_dax, size);
-
-	to_alloc = size - dev_size;
-	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dev_dax, to_alloc),
-			"resize of %pa misaligned\n", &to_alloc))
-		return -ENXIO;
-
-	/*
-	 * Expand the device into the unused portion of the region. This
-	 * may involve adjusting the end of an existing resource, or
-	 * allocating a new resource.
-	 */
-retry:
-	first = region_res->child;
-	if (!first)
-		return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc);
+	first = parent->child;
+	if (!first) {
+		rc = alloc_dev_dax_range(parent, dev_dax,
+					   parent->start, to_alloc);
+		if (rc)
+			return rc;
+		return to_alloc;
+	}
 
-	rc = -ENOSPC;
 	for (res = first; res; res = res->sibling) {
 		struct resource *next = res->sibling;
+		resource_size_t alloc;
 
 		/* space at the beginning of the region */
-		if (res == first && res->start > dax_region->res.start) {
-			alloc = min(res->start - dax_region->res.start, to_alloc);
-			rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, alloc);
-			break;
+		if (res == first && res->start > parent->start) {
+			alloc = min(res->start - parent->start, to_alloc);
+			rc = alloc_dev_dax_range(parent, dev_dax,
+						 parent->start, alloc);
+			if (rc)
+				return rc;
+			return alloc;
 		}
 
 		alloc = 0;
@@ -1078,21 +1071,55 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
 			alloc = min(next->start - (res->end + 1), to_alloc);
 
 		/* space at the end of the region */
-		if (!alloc && !next && res->end < region_res->end)
-			alloc = min(region_res->end - res->end, to_alloc);
+		if (!alloc && !next && res->end < parent->end)
+			alloc = min(parent->end - res->end, to_alloc);
 
 		if (!alloc)
 			continue;
 
 		if (adjust_ok(dev_dax, res)) {
 			rc = adjust_dev_dax_range(dev_dax, res, resource_size(res) + alloc);
-			break;
+			if (rc)
+				return rc;
+			return alloc;
 		}
-		rc = alloc_dev_dax_range(dev_dax, res->end + 1, alloc);
-		break;
+		rc = alloc_dev_dax_range(parent, dev_dax, res->end + 1, alloc);
+		if (rc)
+			return rc;
+		return alloc;
 	}
-	if (rc)
-		return rc;
+
+	/* available was already calculated and should never be an issue */
+	dev_WARN_ONCE(&dev_dax->dev, 1, "space not found?");
+	return 0;
+}
+
+static ssize_t dev_dax_resize(struct dax_region *dax_region,
+		struct dev_dax *dev_dax, resource_size_t size)
+{
+	resource_size_t avail = dax_region_avail_size(dax_region), to_alloc;
+	resource_size_t dev_size = dev_dax_size(dev_dax);
+	struct device *dev = &dev_dax->dev;
+	resource_size_t alloc = 0;
+
+	if (dev->driver)
+		return -EBUSY;
+	if (size == dev_size)
+		return 0;
+	if (size > dev_size && size - dev_size > avail)
+		return -ENOSPC;
+	if (size < dev_size)
+		return dev_dax_shrink(dev_dax, size);
+
+	to_alloc = size - dev_size;
+	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dev_dax, to_alloc),
+			"resize of %pa misaligned\n", &to_alloc))
+		return -ENXIO;
+
+retry:
+	alloc = dev_dax_resize_static(&dax_region->res, dev_dax, to_alloc);
+	if (alloc <= 0)
+		return alloc;
 	to_alloc -= alloc;
 	if (to_alloc)
 		goto retry;
@@ -1198,7 +1225,8 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 
 	to_alloc = range_len(&r);
 	if (alloc_is_aligned(dev_dax, to_alloc))
-		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
+		rc = alloc_dev_dax_range(&dax_region->res, dev_dax, r.start,
+					 to_alloc);
 	up_write(&dax_dev_rwsem);
 	up_write(&dax_region_rwsem);
 
@@ -1466,7 +1494,8 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	device_initialize(dev);
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
 
-	rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, data->size);
+	rc = alloc_dev_dax_range(&dax_region->res, dev_dax, dax_region->res.start,
+				 data->size);
 	if (rc)
 		goto err_range;
 

-- 
2.45.2

