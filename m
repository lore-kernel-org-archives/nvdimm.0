Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v4 14/21] libnd: blk labels and namespace instantiation
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 May 2015 18:25:59 -0400
Message-ID: <20150527222559.17965.91451.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150527210155.17965.74864.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150527210155.17965.74864.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: sfr@canb.auug.org.au, linux-nvdimm@lists.01.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

A blk label set describes a namespace comprised of one or more
discontiguous dpa ranges on a single dimm.  They may alias with one or
more pmem interleave sets that include the given dimm.

This is the runtime/volatile configuration infrastructure for sysfs
manipulation of 'alt_name', 'uuid', 'size', and 'sector_size'.  A later
patch will make these settings persistent by writing back the label(s).

Unlike pmem namespaces, multiple blk namespaces can be created per
region.  Once a blk namespace has been created a new seed device
(unconfigured child of a parent blk region) is instantiated.  As long as
a region has 'available_size' != 0 new child namespaces may be created.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/core.c           |   40 +++
 drivers/block/nd/dimm_devs.c      |   35 +++
 drivers/block/nd/namespace_devs.c |  505 ++++++++++++++++++++++++++++++++++---
 drivers/block/nd/nd-private.h     |    8 +
 drivers/block/nd/nd.h             |    5 
 drivers/block/nd/region_devs.c    |   15 +
 include/linux/libnd.h             |    3 
 include/linux/nd.h                |   25 ++
 8 files changed, 591 insertions(+), 45 deletions(-)

diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
index 0bf69abb47fc..b45863343a48 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -171,6 +171,46 @@ int nd_uuid_store(struct device *dev, u8 **uuid_out, const char *buf,
 	return 0;
 }
 
+ssize_t nd_sector_size_show(unsigned long current_lbasize,
+		const unsigned long *supported, char *buf)
+{
+	ssize_t len = 0;
+	int i;
+
+	for (i = 0; supported[i]; i++)
+		if (current_lbasize == supported[i])
+			len += sprintf(buf + len, "[%ld] ", supported[i]);
+		else
+			len += sprintf(buf + len, "%ld ", supported[i]);
+	len += sprintf(buf + len, "\n");
+	return len;
+}
+
+ssize_t nd_sector_size_store(struct device *dev, const char *buf,
+		unsigned long *current_lbasize, const unsigned long *supported)
+{
+	unsigned long lbasize;
+	int rc, i;
+
+	if (dev->driver)
+		return -EBUSY;
+
+	rc = kstrtoul(buf, 0, &lbasize);
+	if (rc)
+		return rc;
+
+	for (i = 0; supported[i]; i++)
+		if (lbasize == supported[i])
+			break;
+
+	if (supported[i]) {
+		*current_lbasize = lbasize;
+		return 0;
+	} else {
+		return -EINVAL;
+	}
+}
+
 static ssize_t commands_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/block/nd/dimm_devs.c b/drivers/block/nd/dimm_devs.c
index b242d3ae6d12..4aa5654354ac 100644
--- a/drivers/block/nd/dimm_devs.c
+++ b/drivers/block/nd/dimm_devs.c
@@ -256,6 +256,41 @@ struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus, void *provider_data,
 EXPORT_SYMBOL_GPL(nd_dimm_create);
 
 /**
+ * nd_blk_available_dpa - account the unused dpa of BLK region
+ * @nd_mapping: container of dpa-resource-root + labels
+ *
+ * Unlike PMEM, BLK namespaces can occupy discontiguous DPA ranges.
+ */
+resource_size_t nd_blk_available_dpa(struct nd_mapping *nd_mapping)
+{
+	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+	resource_size_t map_end, busy = 0, available;
+	struct resource *res;
+
+	if (!ndd)
+		return 0;
+
+	map_end = nd_mapping->start + nd_mapping->size - 1;
+	for_each_dpa_resource(ndd, res)
+		if (res->start >= nd_mapping->start && res->start < map_end) {
+			resource_size_t end = min(map_end, res->end);
+
+			busy += end - res->start + 1;
+		} else if (res->end >= nd_mapping->start && res->end <= map_end) {
+			busy += res->end - nd_mapping->start;
+		} else if (nd_mapping->start > res->start
+				&& nd_mapping->start < res->end) {
+			/* total eclipse of the BLK region mapping */
+			busy += nd_mapping->size;
+		}
+
+	available = map_end - nd_mapping->start + 1;
+	if (busy < available)
+		return available - busy;
+	return 0;
+}
+
+/**
  * nd_pmem_available_dpa - for the given dimm+region account unallocated dpa
  * @nd_mapping: container of dpa-resource-root + labels
  * @nd_region: constrain available space check to this reference region
diff --git a/drivers/block/nd/namespace_devs.c b/drivers/block/nd/namespace_devs.c
index d0417575b18c..a1cdee83a80c 100644
--- a/drivers/block/nd/namespace_devs.c
+++ b/drivers/block/nd/namespace_devs.c
@@ -37,7 +37,15 @@ static void namespace_pmem_release(struct device *dev)
 
 static void namespace_blk_release(struct device *dev)
 {
-	/* TODO: blk namespace support */
+	struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+	struct nd_region *nd_region = to_nd_region(dev->parent);
+
+	if (nsblk->id >= 0)
+		ida_simple_remove(&nd_region->ns_ida, nsblk->id);
+	kfree(nsblk->alt_name);
+	kfree(nsblk->uuid);
+	kfree(nsblk->res);
+	kfree(nsblk);
 }
 
 static struct device_type namespace_io_device_type = {
@@ -90,8 +98,9 @@ static ssize_t __alt_name_store(struct device *dev, const char *buf,
 
 		ns_altname = &nspm->alt_name;
 	} else if (is_namespace_blk(dev)) {
-		/* TODO: blk namespace support */
-		return -ENXIO;
+		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+
+		ns_altname = &nsblk->alt_name;
 	} else
 		return -ENXIO;
 
@@ -124,6 +133,24 @@ out:
 	return rc;
 }
 
+static resource_size_t nd_namespace_blk_size(struct nd_namespace_blk *nsblk)
+{
+	struct nd_region *nd_region = to_nd_region(nsblk->dev.parent);
+	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct nd_label_id label_id;
+	resource_size_t size = 0;
+	struct resource *res;
+
+	if (!nsblk->uuid)
+		return 0;
+	nd_label_gen_id(&label_id, nsblk->uuid, NSLABEL_FLAG_LOCAL);
+	for_each_dpa_resource(ndd, res)
+		if (strcmp(res->name, label_id.id) == 0)
+			size += resource_size(res);
+	return size;
+}
+
 static ssize_t alt_name_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
@@ -150,8 +177,9 @@ static ssize_t alt_name_show(struct device *dev,
 
 		ns_altname = nspm->alt_name;
 	} else if (is_namespace_blk(dev)) {
-		/* TODO: blk namespace support */
-		return -ENXIO;
+		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+
+		ns_altname = nsblk->alt_name;
 	} else
 		return -ENXIO;
 
@@ -197,6 +225,8 @@ static int scan_free(struct nd_region *nd_region,
 			new_start = res->start;
 
 		rc = adjust_resource(res, new_start, resource_size(res) - n);
+		if (rc == 0)
+			res->flags |= DPA_RESOURCE_ADJUSTED;
 		nd_dbg_dpa(nd_region, ndd, res, "shrink %d\n", rc);
 		break;
 	}
@@ -257,14 +287,15 @@ static resource_size_t init_dpa_allocation(struct nd_label_id *label_id,
 	return rc ? n : 0;
 }
 
-static bool space_valid(bool is_pmem, struct nd_label_id *label_id,
-		struct resource *res)
+static bool space_valid(bool is_pmem, bool is_reserve,
+		struct nd_label_id *label_id, struct resource *res)
 {
 	/*
 	 * For BLK-space any space is valid, for PMEM-space, it must be
-	 * contiguous with an existing allocation.
+	 * contiguous with an existing allocation unless we are
+	 * reserving pmem.
 	 */
-	if (!is_pmem)
+	if (is_reserve || !is_pmem)
 		return true;
 	if (!res || strcmp(res->name, label_id->id) == 0)
 		return true;
@@ -280,6 +311,7 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 		resource_size_t n)
 {
 	resource_size_t mapping_end = nd_mapping->start + nd_mapping->size - 1;
+	bool is_reserve = strcmp(label_id->id, "pmem-reserve") == 0;
 	bool is_pmem = strncmp(label_id->id, "pmem", 4) == 0;
 	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
 	const resource_size_t to_allocate = n;
@@ -305,7 +337,7 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 		if (!first++ && res->start > nd_mapping->start) {
 			free_start = nd_mapping->start;
 			available = res->start - free_start;
-			if (space_valid(is_pmem, label_id, NULL))
+			if (space_valid(is_pmem, is_reserve, label_id, NULL))
 				loc = ALLOC_BEFORE;
 		}
 
@@ -313,7 +345,7 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 		if (!loc && next) {
 			free_start = res->start + resource_size(res);
 			free_end = min(mapping_end, next->start - 1);
-			if (space_valid(is_pmem, label_id, res)
+			if (space_valid(is_pmem, is_reserve, label_id, res)
 					&& free_start < free_end) {
 				available = free_end + 1 - free_start;
 				loc = ALLOC_MID;
@@ -324,7 +356,7 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 		if (!loc && !next) {
 			free_start = res->start + resource_size(res);
 			free_end = mapping_end;
-			if (space_valid(is_pmem, label_id, res)
+			if (space_valid(is_pmem, is_reserve, label_id, res)
 					&& free_start < free_end) {
 				available = free_end + 1 - free_start;
 				loc = ALLOC_AFTER;
@@ -338,7 +370,7 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 		case ALLOC_BEFORE:
 			if (strcmp(res->name, label_id->id) == 0) {
 				/* adjust current resource up */
-				if (is_pmem)
+				if (is_pmem && !is_reserve)
 					return n;
 				rc = adjust_resource(res, res->start - allocate,
 						resource_size(res) + allocate);
@@ -349,7 +381,7 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 		case ALLOC_MID:
 			if (strcmp(next->name, label_id->id) == 0) {
 				/* adjust next resource up */
-				if (is_pmem)
+				if (is_pmem && !is_reserve)
 					return n;
 				rc = adjust_resource(next, next->start
 						- allocate, resource_size(next)
@@ -375,7 +407,7 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 			/* BLK allocate bottom up */
 			if (!is_pmem)
 				free_start += available - allocate;
-			else if (free_start != nd_mapping->start)
+			else if (!is_reserve && free_start != nd_mapping->start)
 				return n;
 
 			new_res = nd_dimm_allocate_dpa(ndd, label_id,
@@ -386,6 +418,8 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 			/* adjust current resource down */
 			rc = adjust_resource(res, res->start, resource_size(res)
 					+ allocate);
+			if (rc == 0)
+				res->flags |= DPA_RESOURCE_ADJUSTED;
 		}
 
 		if (!new_res)
@@ -411,11 +445,106 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 			return 0;
 	}
 
-	if (is_pmem && n == to_allocate)
+	/*
+	 * If we allocated nothing in the BLK case it may be because we are in
+	 * an initial "pmem-reserve pass".  Only do an initial BLK allocation
+	 * when none of the DPA space is reserved.
+	 */
+	if ((is_pmem || !ndd->dpa.child) && n == to_allocate)
 		return init_dpa_allocation(label_id, nd_region, nd_mapping, n);
 	return n;
 }
 
+static int merge_dpa(struct nd_region *nd_region,
+		struct nd_mapping *nd_mapping, struct nd_label_id *label_id)
+{
+	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct resource *res;
+
+	if (strncmp("pmem", label_id->id, 4) == 0)
+		return 0;
+ retry:
+	for_each_dpa_resource(ndd, res) {
+		int rc;
+		struct resource *next = res->sibling;
+		resource_size_t end = res->start + resource_size(res);
+
+		if (!next || strcmp(res->name, label_id->id) != 0
+				|| strcmp(next->name, label_id->id) != 0
+				|| end != next->start)
+			continue;
+		end += resource_size(next);
+		nd_dimm_free_dpa(ndd, next);
+		rc = adjust_resource(res, res->start, end - res->start);
+		nd_dbg_dpa(nd_region, ndd, res, "merge %d\n", rc);
+		if (rc)
+			return rc;
+		res->flags |= DPA_RESOURCE_ADJUSTED;
+		goto retry;
+	}
+
+	return 0;
+}
+
+static int __reserve_free_pmem(struct device *dev, void *data)
+{
+	struct nd_dimm *nd_dimm = data;
+	struct nd_region *nd_region;
+	struct nd_label_id label_id;
+	int i;
+
+	if (!is_nd_pmem(dev))
+		return 0;
+
+	nd_region = to_nd_region(dev);
+	if (nd_region->ndr_mappings == 0)
+		return 0;
+
+	memset(&label_id, 0, sizeof(label_id));
+	strcat(label_id.id, "pmem-reserve");
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		resource_size_t n, rem = 0;
+
+		if (nd_mapping->nd_dimm != nd_dimm)
+			continue;
+
+		n = nd_pmem_available_dpa(nd_region, nd_mapping, &rem);
+		if (n == 0)
+			return 0;
+		rem = scan_allocate(nd_region, nd_mapping, &label_id, n);
+		dev_WARN_ONCE(&nd_region->dev, rem,
+				"pmem reserve underrun: %#llx of %#llx bytes\n",
+				(unsigned long long) n - rem,
+				(unsigned long long) n);
+		return rem ? -ENXIO : 0;
+	}
+
+	return 0;
+}
+
+static void release_free_pmem(struct nd_bus *nd_bus, struct nd_mapping *nd_mapping)
+{
+	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct resource *res, *_res;
+
+	for_each_dpa_resource_safe(ndd, res, _res)
+		if (strcmp(res->name, "pmem-reserve") == 0)
+			nd_dimm_free_dpa(ndd, res);
+}
+
+static int reserve_free_pmem(struct nd_bus *nd_bus,
+		struct nd_mapping *nd_mapping)
+{
+	struct nd_dimm *nd_dimm = nd_mapping->nd_dimm;
+	int rc;
+
+	rc = device_for_each_child(&nd_bus->dev, nd_dimm, __reserve_free_pmem);
+	if (rc)
+		release_free_pmem(nd_bus, nd_mapping);
+	return rc;
+}
+
 /**
  * grow_dpa_allocation - for each dimm allocate n bytes for @label_id
  * @nd_region: the set of dimms to allocate @n more bytes from
@@ -432,13 +561,44 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 static int grow_dpa_allocation(struct nd_region *nd_region,
 		struct nd_label_id *label_id, resource_size_t n)
 {
+	struct nd_bus *nd_bus = walk_to_nd_bus(&nd_region->dev);
+	bool is_pmem = strncmp(label_id->id, "pmem", 4) == 0;
 	int i;
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
-		int rc;
+		resource_size_t rem = n;
+		int rc, j;
+
+		/*
+		 * In the BLK case try once with all unallocated PMEM
+		 * reserved, and once without
+		 */
+		for (j = is_pmem; j < 2; j++) {
+			bool blk_only = j == 0;
+
+			if (blk_only) {
+				rc = reserve_free_pmem(nd_bus, nd_mapping);
+				if (rc)
+					return rc;
+			}
+			rem = scan_allocate(nd_region, nd_mapping, label_id, rem);
+			if (blk_only)
+				release_free_pmem(nd_bus, nd_mapping);
+
+			/* try again and allow encroachments into PMEM */
+			if (rem == 0)
+				break;
+		}
 
-		rc = scan_allocate(nd_region, nd_mapping, label_id, n);
+		dev_WARN_ONCE(&nd_region->dev, rem,
+				"allocation underrun: %#llx of %#llx bytes\n",
+				(unsigned long long) n - rem,
+				(unsigned long long) n);
+		if (rem)
+			return -ENXIO;
+
+		rc = merge_dpa(nd_region, nd_mapping, label_id);
 		if (rc)
 			return rc;
 	}
@@ -474,8 +634,10 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 
 		uuid = nspm->uuid;
 	} else if (is_namespace_blk(dev)) {
-		/* TODO: blk namespace support */
-		return -ENXIO;
+		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+
+		uuid = nsblk->uuid;
+		flags = NSLABEL_FLAG_LOCAL;
 	}
 
 	/*
@@ -529,6 +691,14 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 
 		nd_namespace_pmem_set_size(nd_region, nspm,
 				val * nd_region->ndr_mappings);
+	} else if (is_namespace_blk(dev)) {
+		/*
+		 * Try to delete the namespace if we deleted all of its
+		 * allocation and this is not the seed device for the
+		 * region.
+		 */
+		if (val == 0 && nd_region->ns_seed != dev)
+			nd_device_unregister(dev, ND_ASYNC);
 	}
 
 	return rc;
@@ -555,8 +725,9 @@ static ssize_t size_store(struct device *dev,
 
 		uuid = &nspm->uuid;
 	} else if (is_namespace_blk(dev)) {
-		/* TODO: blk namespace support */
-		rc = -ENXIO;
+		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+
+		uuid = &nsblk->uuid;
 	}
 
 	if (rc == 0 && val == 0 && uuid) {
@@ -577,21 +748,23 @@ static ssize_t size_store(struct device *dev,
 static ssize_t size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
+	unsigned long long size = 0;
+
+	nd_bus_lock(dev);
 	if (is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
-		return sprintf(buf, "%llu\n", (unsigned long long)
-				resource_size(&nspm->nsio.res));
+		size = resource_size(&nspm->nsio.res);
 	} else if (is_namespace_blk(dev)) {
-		/* TODO: blk namespace support */
-		return -ENXIO;
+		size = nd_namespace_blk_size(to_nd_namespace_blk(dev));
 	} else if (is_namespace_io(dev)) {
 		struct nd_namespace_io *nsio = to_nd_namespace_io(dev);
 
-		return sprintf(buf, "%llu\n", (unsigned long long)
-				resource_size(&nsio->res));
-	} else
-		return -ENXIO;
+		size = resource_size(&nsio->res);
+	}
+	nd_bus_unlock(dev);
+
+	return sprintf(buf, "%llu\n", size);
 }
 static DEVICE_ATTR(size, S_IRUGO, size_show, size_store);
 
@@ -605,8 +778,9 @@ static ssize_t uuid_show(struct device *dev,
 
 		uuid = nspm->uuid;
 	} else if (is_namespace_blk(dev)) {
-		/* TODO: blk namespace support */
-		return -ENXIO;
+		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+
+		uuid = nsblk->uuid;
 	} else
 		return -ENXIO;
 
@@ -670,8 +844,9 @@ static ssize_t uuid_store(struct device *dev,
 
 		ns_uuid = &nspm->uuid;
 	} else if (is_namespace_blk(dev)) {
-		/* TODO: blk namespace support */
-		return -ENXIO;
+		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+
+		ns_uuid = &nsblk->uuid;
 	} else
 		return -ENXIO;
 
@@ -713,12 +888,48 @@ static ssize_t resource_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(resource);
 
+static const unsigned long ns_lbasize_supported[] = { 512, 0 };
+
+static ssize_t sector_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+
+	if (!is_namespace_blk(dev))
+		return -ENXIO;
+
+	return nd_sector_size_show(nsblk->lbasize, ns_lbasize_supported, buf);
+}
+
+static ssize_t sector_size_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+	ssize_t rc;
+
+	if (!is_namespace_blk(dev))
+		return -ENXIO;
+
+	device_lock(dev);
+	nd_bus_lock(dev);
+	rc = nd_sector_size_store(dev, buf, &nsblk->lbasize,
+			ns_lbasize_supported);
+	dev_dbg(dev, "%s: result: %zd wrote: %s%s", __func__,
+			rc, buf, buf[len - 1] == '\n' ? "" : "\n");
+	nd_bus_unlock(dev);
+	device_unlock(dev);
+
+	return rc ? rc : len;
+}
+static DEVICE_ATTR_RW(sector_size);
+
 static struct attribute *nd_namespace_attributes[] = {
 	&dev_attr_nstype.attr,
 	&dev_attr_size.attr,
 	&dev_attr_uuid.attr,
 	&dev_attr_resource.attr,
 	&dev_attr_alt_name.attr,
+	&dev_attr_sector_size.attr,
 	NULL,
 };
 
@@ -735,6 +946,10 @@ static umode_t nd_namespace_attr_visible(struct kobject *kobj, struct attribute
 	if (is_namespace_pmem(dev) || is_namespace_blk(dev)) {
 		if (a == &dev_attr_size.attr)
 			return S_IWUSR;
+
+		if (is_namespace_pmem(dev) && a == &dev_attr_sector_size.attr)
+			return 0;
+
 		return a->mode;
 	}
 
@@ -1029,6 +1244,174 @@ static struct device **create_namespace_pmem(struct nd_region *nd_region)
 	return NULL;
 }
 
+struct resource *nsblk_add_resource(struct nd_region *nd_region,
+		struct nd_dimm_drvdata *ndd, struct nd_namespace_blk *nsblk,
+		resource_size_t start)
+{
+	struct nd_label_id label_id;
+	struct resource *res;
+
+	nd_label_gen_id(&label_id, nsblk->uuid, NSLABEL_FLAG_LOCAL);
+	res = krealloc(nsblk->res,
+			sizeof(void *) * (nsblk->num_resources + 1),
+			GFP_KERNEL);
+	if (!res)
+		return NULL;
+	nsblk->res = (struct resource **) res;
+	for_each_dpa_resource(ndd, res)
+		if (strcmp(res->name, label_id.id) == 0 && res->start == start) {
+			nsblk->res[nsblk->num_resources++] = res;
+			return res;
+		}
+	return NULL;
+}
+
+static struct device *nd_namespace_blk_create(struct nd_region *nd_region)
+{
+	struct nd_namespace_blk *nsblk;
+	struct device *dev;
+
+	if (!is_nd_blk(&nd_region->dev))
+		return NULL;
+
+	nsblk = kzalloc(sizeof(*nsblk), GFP_KERNEL);
+	if (!nsblk)
+		return NULL;
+
+	dev = &nsblk->dev;
+	dev->type = &namespace_blk_device_type;
+	nsblk->id = ida_simple_get(&nd_region->ns_ida, 0, 0, GFP_KERNEL);
+	if (nsblk->id < 0) {
+		kfree(nsblk);
+		return NULL;
+	}
+	dev_set_name(dev, "namespace%d.%d", nd_region->id, nsblk->id);
+	dev->parent = &nd_region->dev;
+	dev->groups = nd_namespace_attribute_groups;
+
+	return &nsblk->dev;
+}
+
+void nd_region_create_blk_seed(struct nd_region *nd_region)
+{
+	WARN_ON(!is_nd_bus_locked(&nd_region->dev));
+	nd_region->ns_seed = nd_namespace_blk_create(nd_region);
+	/*
+	 * Seed creation failures are not fatal, provisioning is simply
+	 * disabled until memory becomes available
+	 */
+	if (!nd_region->ns_seed)
+		dev_err(&nd_region->dev, "failed to create blk namespace\n");
+	else
+		nd_device_register(nd_region->ns_seed);
+}
+
+static struct device **create_namespace_blk(struct nd_region *nd_region)
+{
+	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+	struct nd_namespace_label __iomem *nd_label;
+	struct device *dev, **devs = NULL;
+	u8 label_uuid[NSLABEL_UUID_LEN];
+	struct nd_namespace_blk *nsblk;
+	struct nd_dimm_drvdata *ndd;
+	int i, l, count = 0;
+	struct resource *res;
+
+	if (nd_region->ndr_mappings == 0)
+		return NULL;
+
+	ndd = to_ndd(nd_mapping);
+	for_each_label(l, nd_label, nd_mapping->labels) {
+		u32 flags = readl(&nd_label->flags);
+		char *name[NSLABEL_NAME_LEN];
+		struct device **__devs;
+
+		if (flags & NSLABEL_FLAG_LOCAL)
+			/* pass */;
+		else
+			continue;
+
+		memcpy_fromio(label_uuid, nd_label->uuid, NSLABEL_UUID_LEN);
+		for (i = 0; i < count; i++) {
+			nsblk = to_nd_namespace_blk(devs[i]);
+			if (memcmp(nsblk->uuid, label_uuid,
+						NSLABEL_UUID_LEN) == 0) {
+				res = nsblk_add_resource(nd_region, ndd, nsblk,
+						readq(&nd_label->dpa));
+				if (!res)
+					goto err;
+				nd_dbg_dpa(nd_region, ndd, res, "%s assign\n",
+					dev_name(&nsblk->dev));
+				break;
+			}
+		}
+		if (i < count)
+			continue;
+		__devs = kcalloc(count + 2, sizeof(dev), GFP_KERNEL);
+		if (!__devs)
+			goto err;
+		memcpy(__devs, devs, sizeof(dev) * count);
+		kfree(devs);
+		devs = __devs;
+
+		nsblk = kzalloc(sizeof(*nsblk), GFP_KERNEL);
+		if (!nsblk)
+			goto err;
+		dev = &nsblk->dev;
+		dev->type = &namespace_blk_device_type;
+		dev_set_name(dev, "namespace%d.%d", nd_region->id, count);
+		devs[count++] = dev;
+		nsblk->id = -1;
+		nsblk->lbasize = readq(&nd_label->lbasize);
+		nsblk->uuid = kmemdup(label_uuid, NSLABEL_UUID_LEN, GFP_KERNEL);
+		if (!nsblk->uuid)
+			goto err;
+		memcpy_fromio(name, nd_label->name, NSLABEL_NAME_LEN);
+		if (name[0])
+			nsblk->alt_name = kmemdup(name, NSLABEL_NAME_LEN,
+					GFP_KERNEL);
+		res = nsblk_add_resource(nd_region, ndd, nsblk,
+				readq(&nd_label->dpa));
+		if (!res)
+			goto err;
+		nd_dbg_dpa(nd_region, ndd, res, "%s assign\n",
+				dev_name(&nsblk->dev));
+	}
+
+	dev_dbg(&nd_region->dev, "%s: discovered %d blk namespace%s\n",
+			__func__, count, count == 1 ? "" : "s");
+
+	if (count == 0) {
+		/* Publish a zero-sized namespace for userspace to configure. */
+		for (i = 0; i < nd_region->ndr_mappings; i++) {
+			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+
+			kfree(nd_mapping->labels);
+			nd_mapping->labels = NULL;
+		}
+
+		devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
+		if (!devs)
+			goto err;
+		nsblk = kzalloc(sizeof(*nsblk), GFP_KERNEL);
+		if (!nsblk)
+			goto err;
+		dev = &nsblk->dev;
+		dev->type = &namespace_blk_device_type;
+		devs[count++] = dev;
+	}
+
+	return devs;
+
+err:
+	for (i = 0; i < count; i++) {
+		nsblk = to_nd_namespace_blk(devs[i]);
+		namespace_blk_release(&nsblk->dev);
+	}
+	kfree(devs);
+	return NULL;
+}
+
 static int init_active_labels(struct nd_region *nd_region)
 {
 	int i;
@@ -1092,6 +1475,9 @@ int nd_region_register_namespaces(struct nd_region *nd_region, int *err)
 	case ND_DEVICE_NAMESPACE_PMEM:
 		devs = create_namespace_pmem(nd_region);
 		break;
+	case ND_DEVICE_NAMESPACE_BLK:
+		devs = create_namespace_blk(nd_region);
+		break;
 	default:
 		break;
 	}
@@ -1102,26 +1488,59 @@ int nd_region_register_namespaces(struct nd_region *nd_region, int *err)
 		goto err;
 	}
 
-	nd_region->ns_seed = devs[0];
 	for (i = 0; devs[i]; i++) {
 		struct device *dev = devs[i];
+		int id;
+
+		if (type == ND_DEVICE_NAMESPACE_BLK) {
+			struct nd_namespace_blk *nsblk;
 
-		dev_set_name(dev, "namespace%d.%d", nd_region->id, i);
+			nsblk = to_nd_namespace_blk(dev);
+			id = ida_simple_get(&nd_region->ns_ida, 0, 0,
+					GFP_KERNEL);
+			nsblk->id = id;
+		} else
+			id = i;
+
+		if (id < 0)
+			break;
+		dev_set_name(dev, "namespace%d.%d", nd_region->id, id);
 		dev->parent = &nd_region->dev;
 		dev->groups = nd_namespace_attribute_groups;
 		nd_device_register(dev);
 	}
-	kfree(devs);
+	if (i)
+		nd_region->ns_seed = devs[0];
 
-	return i;
+	if (devs[i]) {
+		int j;
+
+		for (j = i; devs[j]; j++) {
+			struct device *dev = devs[j];
+
+			device_initialize(dev);
+			put_device(dev);
+		}
+		*err = j - i;
+		/*
+		 * All of the namespaces we tried to register failed, so
+		 * fail region activation.
+		 */
+		if (*err == 0)
+			rc = -ENODEV;
+	}
+	kfree(devs);
 
  err:
-	for (i = 0; i < nd_region->ndr_mappings; i++) {
-		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+	if (rc == -ENODEV) {
+		for (i = 0; i < nd_region->ndr_mappings; i++) {
+			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 
-		kfree(nd_mapping->labels);
-		nd_mapping->labels = NULL;
+			kfree(nd_mapping->labels);
+			nd_mapping->labels = NULL;
+		}
+		return rc;
 	}
 
-	return rc;
+	return i;
 }
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index 814843454417..fe852175a3b8 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -16,6 +16,7 @@
 #include <linux/libnd.h>
 #include <linux/sizes.h>
 #include <linux/mutex.h>
+#include <linux/nd.h>
 
 extern struct list_head nd_bus_list;
 extern struct mutex nd_bus_list_mutex;
@@ -52,6 +53,8 @@ void nd_dimm_exit(void);
 int nd_region_exit(void);
 void nd_region_probe_start(struct nd_bus *nd_bus, struct device *dev);
 void nd_region_probe_end(struct nd_bus *nd_bus, struct device *dev, int rc);
+struct nd_region;
+void nd_region_create_blk_seed(struct nd_region *nd_region);
 void nd_region_notify_remove(struct nd_bus *nd_bus, struct device *dev, int rc);
 int nd_bus_create_ndctl(struct nd_bus *nd_bus);
 void nd_bus_destroy_ndctl(struct nd_bus *nd_bus);
@@ -68,7 +71,12 @@ struct nd_dimm_drvdata;
 struct nd_mapping;
 resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, resource_size_t *overlap);
+resource_size_t nd_blk_available_dpa(struct nd_mapping *nd_mapping);
 resource_size_t nd_region_available_dpa(struct nd_region *nd_region);
 resource_size_t nd_dimm_allocated_dpa(struct nd_dimm_drvdata *ndd,
 		struct nd_label_id *label_id);
+struct nd_mapping;
+struct resource *nsblk_add_resource(struct nd_region *nd_region,
+		struct nd_dimm_drvdata *ndd, struct nd_namespace_blk *nsblk,
+		resource_size_t start);
 #endif /* __ND_PRIVATE_H__ */
diff --git a/drivers/block/nd/nd.h b/drivers/block/nd/nd.h
index d9d221a7006e..3876d0c7db87 100644
--- a/drivers/block/nd/nd.h
+++ b/drivers/block/nd/nd.h
@@ -90,6 +90,7 @@ static inline struct nd_namespace_label __iomem *nd_get_label(
 
 struct nd_region {
 	struct device dev;
+	struct ida ns_ida;
 	struct device *ns_seed;
 	u16 ndr_mappings;
 	u64 ndr_size;
@@ -119,6 +120,10 @@ void nd_device_register(struct device *dev);
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode);
 int nd_uuid_store(struct device *dev, u8 **uuid_out, const char *buf,
 		size_t len);
+ssize_t nd_sector_size_show(unsigned long current_lbasize,
+		const unsigned long *supported, char *buf);
+ssize_t nd_sector_size_store(struct device *dev, const char *buf,
+		unsigned long *current_lbasize, const unsigned long *supported);
 struct nd_dimm;
 struct nd_dimm_drvdata *to_ndd(struct nd_mapping *nd_mapping);
 int nd_dimm_init_nsarea(struct nd_dimm_drvdata *ndd);
diff --git a/drivers/block/nd/region_devs.c b/drivers/block/nd/region_devs.c
index 6b43a5c901cd..1ae6bb44c371 100644
--- a/drivers/block/nd/region_devs.c
+++ b/drivers/block/nd/region_devs.c
@@ -118,7 +118,12 @@ static int is_uuid_busy(struct device *dev, void *data)
 		break;
 	}
 	case ND_DEVICE_NAMESPACE_BLK: {
-		/* TODO: blk namespace support */
+		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+
+		if (!nsblk->uuid)
+			break;
+		if (memcmp(uuid, nsblk->uuid, NSLABEL_UUID_LEN) == 0)
+			return -EBUSY;
 		break;
 	}
 	default:
@@ -230,7 +235,7 @@ resource_size_t nd_region_available_dpa(struct nd_region *nd_region)
 				goto retry;
 			}
 		} else if (is_nd_blk(&nd_region->dev)) {
-			/* TODO: BLK Namespace support */
+			available += nd_blk_available_dpa(nd_mapping);
 		}
 	}
 
@@ -360,6 +365,11 @@ static void nd_region_notify_driver_action(struct nd_bus *nd_bus,
 			else
 				atomic_dec(&nd_dimm->busy);
 		}
+	} else if (dev->parent && is_nd_blk(dev->parent) && probe && rc == 0) {
+		struct nd_region *nd_region = to_nd_region(dev->parent);
+
+		if (nd_region->ns_seed == dev)
+			nd_region_create_blk_seed(nd_region);
 	}
 }
 
@@ -546,6 +556,7 @@ static noinline struct nd_region *nd_region_create(struct nd_bus *nd_bus,
 	nd_region->ndr_mappings = ndr_desc->num_mappings;
 	nd_region->provider_data = ndr_desc->provider_data;
 	nd_region->nd_set = ndr_desc->nd_set;
+	ida_init(&nd_region->ns_ida);
 	dev = &nd_region->dev;
 	dev_set_name(dev, "region%d", nd_region->id);
 	dev->parent = &nd_bus->dev;
diff --git a/include/linux/libnd.h b/include/linux/libnd.h
index 3190a561ea59..43f58330d14c 100644
--- a/include/linux/libnd.h
+++ b/include/linux/libnd.h
@@ -26,6 +26,9 @@ enum {
 	ND_CMD_MAX_ENVELOPE = 16,
 	ND_CMD_ARS_QUERY_MAX = SZ_4K,
 	ND_MAX_MAPPINGS = 32,
+
+	/* mark newly adjusted resources as requiring a label update */
+	DPA_RESOURCE_ADJUSTED = 1 << 0,
 };
 
 extern struct attribute_group nd_bus_attribute_group;
diff --git a/include/linux/nd.h b/include/linux/nd.h
index 255c38a83083..23276ea91690 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -50,6 +50,26 @@ struct nd_namespace_pmem {
 	u8 *uuid;
 };
 
+/**
+ * struct nd_namespace_blk - namespace for dimm-bounded persistent memory
+ * @dev: namespace device creation by the nd region driver
+ * @alt_name: namespace name supplied in the dimm label
+ * @uuid: namespace name supplied in the dimm label
+ * @id: ida allocated id
+ * @lbasize: blk namespaces have a native sector size when btt not present
+ * @num_resources: number of dpa extents to claim
+ * @res: discontiguous dpa extents for given dimm
+ */
+struct nd_namespace_blk {
+	struct device dev;
+	char *alt_name;
+	u8 *uuid;
+	int id;
+	unsigned long lbasize;
+	int num_resources;
+	struct resource **res;
+};
+
 static inline struct nd_namespace_io *to_nd_namespace_io(struct device *dev)
 {
 	return container_of(dev, struct nd_namespace_io, dev);
@@ -62,6 +82,11 @@ static inline struct nd_namespace_pmem *to_nd_namespace_pmem(struct device *dev)
 	return container_of(nsio, struct nd_namespace_pmem, nsio);
 }
 
+static inline struct nd_namespace_blk *to_nd_namespace_blk(struct device *dev)
+{
+	return container_of(dev, struct nd_namespace_blk, dev);
+}
+
 #define MODULE_ALIAS_ND_DEVICE(type) \
 	MODULE_ALIAS("nd:t" __stringify(type) "*")
 #define ND_DEVICE_MODALIAS_FMT "nd:t%d"

