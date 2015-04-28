Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 14/20] libnd: pmem label sets and namespace instantiation.
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Apr 2015 14:25:30 -0400
Message-ID: <20150428182530.35812.86604.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

A complete label set is a PMEM-label per dimm where all the UUIDs
match and the interleave set cookie matches an active interleave set.

Present a sysfs ABI for manipulation of a PMEM-namespace's 'alt_name',
'uuid', and 'size' attributes.  A later patch will make these settings
persistent by writing back the label.

Note that PMEM allocations grow forwards from the start of an interleave
set (lowest dimm-physical-address (DPA)).  BLK-namespaces that alias
with a PMEM interleave set will grow allocations backward from the
highest DPA.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/bus.c            |    6 
 drivers/block/nd/core.c           |   64 ++
 drivers/block/nd/dimm.c           |    2 
 drivers/block/nd/dimm_devs.c      |  127 +++++
 drivers/block/nd/label.c          |   54 ++
 drivers/block/nd/label.h          |    3 
 drivers/block/nd/libnd.h          |    2 
 drivers/block/nd/namespace_devs.c | 1024 +++++++++++++++++++++++++++++++++++++
 drivers/block/nd/nd-private.h     |   14 +
 drivers/block/nd/nd.h             |   33 +
 drivers/block/nd/pmem.c           |   22 +
 drivers/block/nd/region_devs.c    |  145 +++++
 include/linux/nd.h                |   24 +
 include/uapi/linux/ndctl.h        |    4 
 14 files changed, 1512 insertions(+), 12 deletions(-)

diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
index 8afb8d4a7e81..819259e92468 100644
--- a/drivers/block/nd/bus.c
+++ b/drivers/block/nd/bus.c
@@ -364,8 +364,10 @@ u32 nd_cmd_out_size(struct nd_dimm *nd_dimm, int cmd,
 }
 EXPORT_SYMBOL_GPL(nd_cmd_out_size);
 
-static void wait_nd_bus_probe_idle(struct nd_bus *nd_bus)
+void wait_nd_bus_probe_idle(struct device *dev)
 {
+	struct nd_bus *nd_bus = walk_to_nd_bus(dev);
+
 	do {
 		if (nd_bus->probe_active == 0)
 			break;
@@ -384,7 +386,7 @@ static int nd_cmd_clear_to_send(struct nd_dimm *nd_dimm, unsigned int cmd)
 		return 0;
 
 	nd_bus = walk_to_nd_bus(&nd_dimm->dev);
-	wait_nd_bus_probe_idle(nd_bus);
+	wait_nd_bus_probe_idle(&nd_bus->dev);
 
 	if (atomic_read(&nd_dimm->busy))
 		return -EBUSY;
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
index 603970d0ef3a..cf64b7a50d3a 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -13,6 +13,7 @@
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/ctype.h>
 #include <linux/ndctl.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
@@ -106,6 +107,69 @@ struct nd_bus *walk_to_nd_bus(struct device *nd_dev)
 	return NULL;
 }
 
+static bool is_uuid_sep(char sep)
+{
+	if (sep == '\n' || sep == '-' || sep == ':' || sep == '\0')
+		return true;
+	return false;
+}
+
+static int nd_uuid_parse(struct device *dev, u8 *uuid_out, const char *buf,
+		size_t len)
+{
+	const char *str = buf;
+	u8 uuid[16];
+	int i;
+
+	for (i = 0; i < 16; i++) {
+		if (!isxdigit(str[0]) || !isxdigit(str[1])) {
+			dev_dbg(dev, "%s: pos: %d buf[%zd]: %c buf[%zd]: %c\n",
+					__func__, i, str - buf, str[0],
+					str + 1 - buf, str[1]);
+			return -EINVAL;
+		}
+
+		uuid[i] = (hex_to_bin(str[0]) << 4) | hex_to_bin(str[1]);
+		str += 2;
+		if (is_uuid_sep(*str))
+			str++;
+	}
+
+	memcpy(uuid_out, uuid, sizeof(uuid));
+	return 0;
+}
+
+/**
+ * nd_uuid_store: common implementation for writing 'uuid' sysfs attributes
+ * @dev: container device for the uuid property
+ * @uuid_out: uuid buffer to replace
+ * @buf: raw sysfs buffer to parse
+ *
+ * Enforce that uuids can only be changed while the device is disabled
+ * (driver detached)
+ * LOCKING: expects device_lock() is held on entry
+ */
+int nd_uuid_store(struct device *dev, u8 **uuid_out, const char *buf,
+		size_t len)
+{
+	u8 uuid[16];
+	int rc;
+
+	if (dev->driver)
+		return -EBUSY;
+
+	rc = nd_uuid_parse(dev, uuid, buf, len);
+	if (rc)
+		return rc;
+
+	kfree(*uuid_out);
+	*uuid_out = kmemdup(uuid, sizeof(uuid), GFP_KERNEL);
+	if (!(*uuid_out))
+		return -ENOMEM;
+
+	return 0;
+}
+
 static ssize_t commands_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/block/nd/dimm.c b/drivers/block/nd/dimm.c
index 5477176c5de0..e2f964308672 100644
--- a/drivers/block/nd/dimm.c
+++ b/drivers/block/nd/dimm.c
@@ -86,7 +86,7 @@ static int nd_dimm_remove(struct device *dev)
 	nd_bus_lock(dev);
 	dev_set_drvdata(dev, NULL);
 	for_each_dpa_resource_safe(ndd, res, _r)
-		__release_region(&ndd->dpa, res->start, resource_size(res));
+		nd_dimm_free_dpa(ndd, res);
 	nd_bus_unlock(dev);
 	free_data(ndd);
 
diff --git a/drivers/block/nd/dimm_devs.c b/drivers/block/nd/dimm_devs.c
index 3fbd0d0502eb..b242d3ae6d12 100644
--- a/drivers/block/nd/dimm_devs.c
+++ b/drivers/block/nd/dimm_devs.c
@@ -159,6 +159,14 @@ struct nd_dimm *to_nd_dimm(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(to_nd_dimm);
 
+struct nd_dimm_drvdata *to_ndd(struct nd_mapping *nd_mapping)
+{
+	struct nd_dimm *nd_dimm = nd_mapping->nd_dimm;
+
+	return dev_get_drvdata(&nd_dimm->dev);
+}
+EXPORT_SYMBOL(to_ndd);
+
 const char *nd_dimm_name(struct nd_dimm *nd_dimm)
 {
 	return dev_name(&nd_dimm->dev);
@@ -247,6 +255,125 @@ struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus, void *provider_data,
 }
 EXPORT_SYMBOL_GPL(nd_dimm_create);
 
+/**
+ * nd_pmem_available_dpa - for the given dimm+region account unallocated dpa
+ * @nd_mapping: container of dpa-resource-root + labels
+ * @nd_region: constrain available space check to this reference region
+ * @overlap: calculate available space assuming this level of overlap
+ *
+ * Validate that a PMEM label, if present, aligns with the start of an
+ * interleave set and truncate the available size at the lowest BLK
+ * overlap point.
+ *
+ * The expectation is that this routine is called multiple times as it
+ * probes for the largest BLK encroachment for any single member DIMM of
+ * the interleave set.  Once that value is determined the PMEM-limit for
+ * the set can be established.
+ */
+resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
+		struct nd_mapping *nd_mapping, resource_size_t *overlap)
+{
+	resource_size_t map_end, busy = 0, available, blk_start;
+	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct resource *res;
+	const char *reason;
+
+	if (!ndd)
+		return 0;
+
+	map_end = nd_mapping->start + nd_mapping->size - 1;
+	blk_start = max(nd_mapping->start, map_end + 1 - *overlap);
+	for_each_dpa_resource(ndd, res)
+		if (res->start >= nd_mapping->start && res->start < map_end) {
+			if (strncmp(res->name, "blk", 3) == 0)
+				blk_start = min(blk_start, res->start);
+			else if (res->start != nd_mapping->start) {
+				reason = "misaligned to iset";
+				goto err;
+			} else {
+				if (busy) {
+					reason = "duplicate overlapping PMEM reservations?";
+					goto err;
+				}
+				busy += resource_size(res);
+				continue;
+			}
+		} else if (res->end >= nd_mapping->start && res->end <= map_end) {
+			if (strncmp(res->name, "blk", 3) == 0) {
+				/*
+				 * If a BLK allocation overlaps the start of
+				 * PMEM the entire interleave set may now only
+				 * be used for BLK.
+				 */
+				blk_start = nd_mapping->start;
+			} else {
+				reason = "misaligned to iset";
+				goto err;
+			}
+		} else if (nd_mapping->start > res->start
+				&& nd_mapping->start < res->end) {
+			/* total eclipse of the mapping */
+			busy += nd_mapping->size;
+			blk_start = nd_mapping->start;
+		}
+
+	*overlap = map_end + 1 - blk_start;
+	available = blk_start - nd_mapping->start;
+	if (busy < available)
+		return available - busy;
+	return 0;
+
+ err:
+	/*
+	 * Something is wrong, PMEM must align with the start of the
+	 * interleave set, and there can only be one allocation per set.
+	 */
+	nd_dbg_dpa(nd_region, ndd, res, "%s\n", reason);
+	return 0;
+}
+
+void nd_dimm_free_dpa(struct nd_dimm_drvdata *ndd, struct resource *res)
+{
+	WARN_ON_ONCE(!is_nd_bus_locked(ndd->dev));
+	kfree(res->name);
+	__release_region(&ndd->dpa, res->start, resource_size(res));
+}
+
+struct resource *nd_dimm_allocate_dpa(struct nd_dimm_drvdata *ndd,
+		struct nd_label_id *label_id, resource_size_t start,
+		resource_size_t n)
+{
+	char *name = kmemdup(label_id, sizeof(*label_id), GFP_KERNEL);
+	struct resource *res;
+
+	if (!name)
+		return NULL;
+
+	WARN_ON_ONCE(!is_nd_bus_locked(ndd->dev));
+	res = __request_region(&ndd->dpa, start, n, name, 0);
+	if (!res)
+		kfree(name);
+	return res;
+}
+
+/**
+ * nd_dimm_allocated_dpa - sum up the dpa currently allocated to this label_id
+ * @nd_dimm: container of dpa-resource-root + labels
+ * @label_id: dpa resource name of the form {pmem|blk}-<human readable uuid>
+ */
+resource_size_t nd_dimm_allocated_dpa(struct nd_dimm_drvdata *ndd,
+		struct nd_label_id *label_id)
+{
+	resource_size_t allocated = 0;
+	struct resource *res;
+
+	for_each_dpa_resource(ndd, res)
+		if (strcmp(res->name, label_id->id) == 0)
+			allocated += resource_size(res);
+
+	return allocated;
+}
+
 static int count_dimms(struct device *dev, void *c)
 {
 	int *count = c;
diff --git a/drivers/block/nd/label.c b/drivers/block/nd/label.c
index e791ea8bbdde..b55fa2a6f872 100644
--- a/drivers/block/nd/label.c
+++ b/drivers/block/nd/label.c
@@ -228,7 +228,7 @@ static bool preamble_current(struct nd_dimm_drvdata *ndd,
 	return true;
 }
 
-static char *nd_label_gen_id(struct nd_label_id *label_id, u8 *uuid, u32 flags)
+char *nd_label_gen_id(struct nd_label_id *label_id, u8 *uuid, u32 flags)
 {
 	if (!label_id || !uuid)
 		return NULL;
@@ -289,3 +289,55 @@ int nd_label_reserve_dpa(struct nd_dimm_drvdata *ndd)
 
 	return 0;
 }
+
+int nd_label_active_count(struct nd_dimm_drvdata *ndd)
+{
+	struct nd_namespace_index __iomem *nsindex;
+	unsigned long *free;
+	u32 nslot, slot;
+	int count = 0;
+
+	if (!preamble_current(ndd, &nsindex, &free, &nslot))
+		return 0;
+
+	for_each_clear_bit_le(slot, free, nslot) {
+		struct nd_namespace_label __iomem *nd_label;
+
+		nd_label = nd_label_base(ndd) + slot;
+
+		if (!slot_valid(nd_label, slot)) {
+			dev_dbg(ndd->dev,
+				"%s: slot%d invalid slot: %d dpa: %lx rawsize: %lx\n",
+					__func__, slot, readl(&nd_label->slot),
+					(unsigned long) readq(&nd_label->dpa),
+					(unsigned long) readq(&nd_label->rawsize));
+			continue;
+		}
+		count++;
+	}
+	return count;
+}
+
+struct nd_namespace_label __iomem *nd_label_active(
+		struct nd_dimm_drvdata *ndd, int n)
+{
+	struct nd_namespace_index __iomem *nsindex;
+	unsigned long *free;
+	u32 nslot, slot;
+
+	if (!preamble_current(ndd, &nsindex, &free, &nslot))
+		return NULL;
+
+	for_each_clear_bit_le(slot, free, nslot) {
+		struct nd_namespace_label __iomem *nd_label;
+
+		nd_label = nd_label_base(ndd) + slot;
+		if (slot != readl(&nd_label->slot))
+			continue;
+
+		if (n-- == 0)
+			return nd_label_base(ndd) + slot;
+	}
+
+	return NULL;
+}
diff --git a/drivers/block/nd/label.h b/drivers/block/nd/label.h
index 79ed885a43c0..4436624f4146 100644
--- a/drivers/block/nd/label.h
+++ b/drivers/block/nd/label.h
@@ -126,4 +126,7 @@ void nd_label_copy(struct nd_dimm_drvdata *ndd,
 		struct nd_namespace_index *dst,
 		struct nd_namespace_index *src);
 size_t sizeof_namespace_index(struct nd_dimm_drvdata *ndd);
+int nd_label_active_count(struct nd_dimm_drvdata *ndd);
+struct nd_namespace_label __iomem *nd_label_active(
+		struct nd_dimm_drvdata *ndd, int n);
 #endif /* __LABEL_H__ */
diff --git a/drivers/block/nd/libnd.h b/drivers/block/nd/libnd.h
index deb29eff5b61..832dcfebbb49 100644
--- a/drivers/block/nd/libnd.h
+++ b/drivers/block/nd/libnd.h
@@ -40,8 +40,10 @@ typedef int (*ndctl_fn)(struct nd_bus_descriptor *nd_desc,
 		struct nd_dimm *nd_dimm, unsigned int cmd, void *buf,
 		unsigned int buf_len);
 
+struct nd_namespace_label;
 struct nd_mapping {
 	struct nd_dimm *nd_dimm;
+	struct nd_namespace_label **labels;
 	u64 start;
 	u64 size;
 };
diff --git a/drivers/block/nd/namespace_devs.c b/drivers/block/nd/namespace_devs.c
index 6861327f4245..fb23904df4c7 100644
--- a/drivers/block/nd/namespace_devs.c
+++ b/drivers/block/nd/namespace_devs.c
@@ -14,8 +14,11 @@
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/nd.h>
+#include "nd-private.h"
 #include "nd.h"
 
+#include <asm-generic/io-64-nonatomic-lo-hi.h>
+
 static void namespace_io_release(struct device *dev)
 {
 	struct nd_namespace_io *nsio = to_nd_namespace_io(dev);
@@ -23,11 +26,50 @@ static void namespace_io_release(struct device *dev)
 	kfree(nsio);
 }
 
+static void namespace_pmem_release(struct device *dev)
+{
+	struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+	kfree(nspm->alt_name);
+	kfree(nspm->uuid);
+	kfree(nspm);
+}
+
+static void namespace_blk_release(struct device *dev)
+{
+	/* TODO: blk namespace support */
+}
+
 static struct device_type namespace_io_device_type = {
 	.name = "nd_namespace_io",
 	.release = namespace_io_release,
 };
 
+static struct device_type namespace_pmem_device_type = {
+	.name = "nd_namespace_pmem",
+	.release = namespace_pmem_release,
+};
+
+static struct device_type namespace_blk_device_type = {
+	.name = "nd_namespace_blk",
+	.release = namespace_blk_release,
+};
+
+static bool is_namespace_pmem(struct device *dev)
+{
+	return dev ? dev->type == &namespace_pmem_device_type : false;
+}
+
+static bool is_namespace_blk(struct device *dev)
+{
+	return dev ? dev->type == &namespace_blk_device_type : false;
+}
+
+static bool is_namespace_io(struct device *dev)
+{
+	return dev ? dev->type == &namespace_io_device_type : false;
+}
+
 static ssize_t type_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -37,13 +79,674 @@ static ssize_t type_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(type);
 
+static ssize_t __alt_name_store(struct device *dev, const char *buf,
+		const size_t len)
+{
+	char *input, *pos, *alt_name, **ns_altname;
+	ssize_t rc;
+
+	if (is_namespace_pmem(dev)) {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+		ns_altname = &nspm->alt_name;
+	} else if (is_namespace_blk(dev)) {
+		/* TODO: blk namespace support */
+		return -ENXIO;
+	} else
+		return -ENXIO;
+
+	if (dev->driver)
+		return -EBUSY;
+
+	input = kmemdup(buf, len + 1, GFP_KERNEL);
+	if (!input)
+		return -ENOMEM;
+
+	input[len] = '\0';
+	pos = strim(input);
+	if (strlen(pos) + 1 > NSLABEL_NAME_LEN) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	alt_name = kzalloc(NSLABEL_NAME_LEN, GFP_KERNEL);
+	if (!alt_name) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	kfree(*ns_altname);
+	*ns_altname = alt_name;
+	sprintf(*ns_altname, "%s", pos);
+	rc = len;
+
+out:
+	kfree(input);
+	return rc;
+}
+
+static ssize_t alt_name_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	ssize_t rc;
+
+	device_lock(dev);
+	nd_bus_lock(dev);
+	wait_nd_bus_probe_idle(dev);
+	rc = __alt_name_store(dev, buf, len);
+	dev_dbg(dev, "%s: %s (%zd)\n", __func__, rc < 0 ? "fail" : "success", rc);
+	nd_bus_unlock(dev);
+	device_unlock(dev);
+
+	return rc;
+}
+
+static ssize_t alt_name_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	char *ns_altname;
+
+	if (is_namespace_pmem(dev)) {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+		ns_altname = nspm->alt_name;
+	} else if (is_namespace_blk(dev)) {
+		/* TODO: blk namespace support */
+		return -ENXIO;
+	} else
+		return -ENXIO;
+
+	return sprintf(buf, "%s\n", ns_altname ? ns_altname : "");
+}
+static DEVICE_ATTR_RW(alt_name);
+
+static int scan_free(struct nd_region *nd_region,
+		struct nd_mapping *nd_mapping, struct nd_label_id *label_id,
+		resource_size_t n)
+{
+	bool is_blk = strncmp(label_id->id, "blk", 3) == 0;
+	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+	int rc = 0;
+
+	while (n) {
+		struct resource *res, *last;
+		resource_size_t new_start;
+
+		last = NULL;
+		for_each_dpa_resource(ndd, res)
+			if (strcmp(res->name, label_id->id) == 0)
+				last = res;
+		res = last;
+		if (!res)
+			return 0;
+
+		if (n >= resource_size(res)) {
+			n -= resource_size(res);
+			nd_dbg_dpa(nd_region, ndd, res, "delete %d\n", rc);
+			nd_dimm_free_dpa(ndd, res);
+			/* retry with last resource deleted */
+			continue;
+		}
+
+		/*
+		 * Keep BLK allocations relegated to high DPA as much as
+		 * possible
+		 */
+		if (is_blk)
+			new_start = res->start + n;
+		else
+			new_start = res->start;
+
+		rc = adjust_resource(res, new_start, resource_size(res) - n);
+		nd_dbg_dpa(nd_region, ndd, res, "shrink %d\n", rc);
+		break;
+	}
+
+	return rc;
+}
+
+/**
+ * shrink_dpa_allocation - for each dimm in region free n bytes for label_id
+ * @nd_region: the set of dimms to reclaim @n bytes from
+ * @label_id: unique identifier for the namespace consuming this dpa range
+ * @n: number of bytes per-dimm to release
+ *
+ * Assumes resources are ordered.  Starting from the end try to
+ * adjust_resource() the allocation to @n, but if @n is larger than the
+ * allocation delete it and find the 'new' last allocation in the label
+ * set.
+ */
+static int shrink_dpa_allocation(struct nd_region *nd_region,
+		struct nd_label_id *label_id, resource_size_t n)
+{
+	int i;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		int rc;
+
+		rc = scan_free(nd_region, nd_mapping, label_id, n);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static resource_size_t init_dpa_allocation(struct nd_label_id *label_id,
+		struct nd_region *nd_region, struct nd_mapping *nd_mapping,
+		resource_size_t n)
+{
+	bool is_blk = strncmp(label_id->id, "blk", 3) == 0;
+	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+	resource_size_t first_dpa;
+	struct resource *res;
+	int rc = 0;
+
+	/* allocate blk from highest dpa first */
+	if (is_blk)
+		first_dpa = nd_mapping->start + nd_mapping->size - n;
+	else
+		first_dpa = nd_mapping->start;
+
+	/* first resource allocation for this label-id or dimm */
+	res = nd_dimm_allocate_dpa(ndd, label_id, first_dpa, n);
+	if (!res)
+		rc = -EBUSY;
+
+	nd_dbg_dpa(nd_region, ndd, res, "init %d\n", rc);
+	return rc ? n : 0;
+}
+
+static bool space_valid(bool is_pmem, struct nd_label_id *label_id,
+		struct resource *res)
+{
+	/*
+	 * For BLK-space any space is valid, for PMEM-space, it must be
+	 * contiguous with an existing allocation.
+	 */
+	if (!is_pmem)
+		return true;
+	if (!res || strcmp(res->name, label_id->id) == 0)
+		return true;
+	return false;
+}
+
+enum alloc_loc {
+	ALLOC_ERR = 0, ALLOC_BEFORE, ALLOC_MID, ALLOC_AFTER,
+};
+
+static resource_size_t scan_allocate(struct nd_region *nd_region,
+		struct nd_mapping *nd_mapping, struct nd_label_id *label_id,
+		resource_size_t n)
+{
+	resource_size_t mapping_end = nd_mapping->start + nd_mapping->size - 1;
+	bool is_pmem = strncmp(label_id->id, "pmem", 4) == 0;
+	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+	const resource_size_t to_allocate = n;
+	struct resource *res;
+	int first;
+
+ retry:
+	first = 0;
+	for_each_dpa_resource(ndd, res) {
+		resource_size_t allocate, available = 0, free_start, free_end;
+		struct resource *next = res->sibling, *new_res = NULL;
+		enum alloc_loc loc = ALLOC_ERR;
+		const char *action;
+		int rc = 0;
+
+		/* ignore resources outside this nd_mapping */
+		if (res->start > mapping_end)
+			continue;
+		if (res->end < nd_mapping->start)
+			continue;
+
+		/* space at the beginning of the mapping */
+		if (!first++ && res->start > nd_mapping->start) {
+			free_start = nd_mapping->start;
+			available = res->start - free_start;
+			if (space_valid(is_pmem, label_id, NULL))
+				loc = ALLOC_BEFORE;
+		}
+
+		/* space between allocations */
+		if (!loc && next) {
+			free_start = res->start + resource_size(res);
+			free_end = min(mapping_end, next->start - 1);
+			if (space_valid(is_pmem, label_id, res)
+					&& free_start < free_end) {
+				available = free_end + 1 - free_start;
+				loc = ALLOC_MID;
+			}
+		}
+
+		/* space at the end of the mapping */
+		if (!loc && !next) {
+			free_start = res->start + resource_size(res);
+			free_end = mapping_end;
+			if (space_valid(is_pmem, label_id, res)
+					&& free_start < free_end) {
+				available = free_end + 1 - free_start;
+				loc = ALLOC_AFTER;
+			}
+		}
+
+		if (!loc || !available)
+			continue;
+		allocate = min(available, n);
+		switch (loc) {
+		case ALLOC_BEFORE:
+			if (strcmp(res->name, label_id->id) == 0) {
+				/* adjust current resource up */
+				if (is_pmem)
+					return n;
+				rc = adjust_resource(res, res->start - allocate,
+						resource_size(res) + allocate);
+				action = "cur grow up";
+			} else
+				action = "allocate";
+			break;
+		case ALLOC_MID:
+			if (strcmp(next->name, label_id->id) == 0) {
+				/* adjust next resource up */
+				if (is_pmem)
+					return n;
+				rc = adjust_resource(next, next->start
+						- allocate, resource_size(next)
+						+ allocate);
+				new_res = next;
+				action = "next grow up";
+			} else if (strcmp(res->name, label_id->id) == 0) {
+				action = "grow down";
+			} else
+				action = "allocate";
+			break;
+		case ALLOC_AFTER:
+			if (strcmp(res->name, label_id->id) == 0)
+				action = "grow down";
+			else
+				action = "allocate";
+			break;
+		default:
+			return n;
+		}
+
+		if (strcmp(action, "allocate") == 0) {
+			/* BLK allocate bottom up */
+			if (!is_pmem)
+				free_start += available - allocate;
+			else if (free_start != nd_mapping->start)
+				return n;
+
+			new_res = nd_dimm_allocate_dpa(ndd, label_id,
+					free_start, allocate);
+			if (!new_res)
+				rc = -EBUSY;
+		} else if (strcmp(action, "grow down") == 0) {
+			/* adjust current resource down */
+			rc = adjust_resource(res, res->start, resource_size(res)
+					+ allocate);
+		}
+
+		if (!new_res)
+			new_res = res;
+
+		nd_dbg_dpa(nd_region, ndd, new_res, "%s(%d) %d\n",
+				action, loc, rc);
+
+		if (rc)
+			return n;
+
+		n -= allocate;
+		if (n) {
+			/*
+			 * Retry scan with newly inserted resources.
+			 * For example, if we did an ALLOC_BEFORE
+			 * insertion there may also have been space
+			 * available for an ALLOC_AFTER insertion, so we
+			 * need to check this same resource again
+			 */
+			goto retry;
+		} else
+			return 0;
+	}
+
+	if (is_pmem && n == to_allocate)
+		return init_dpa_allocation(label_id, nd_region, nd_mapping, n);
+	return n;
+}
+
+/**
+ * grow_dpa_allocation - for each dimm allocate n bytes for @label_id
+ * @nd_region: the set of dimms to allocate @n more bytes from
+ * @label_id: unique identifier for the namespace consuming this dpa range
+ * @n: number of bytes per-dimm to add to the existing allocation
+ *
+ * Assumes resources are ordered.  For BLK regions, first consume
+ * BLK-only available DPA free space, then consume PMEM-aliased DPA
+ * space starting at the highest DPA.  For PMEM regions start
+ * allocations from the start of an interleave set and end at the first
+ * BLK allocation or the end of the interleave set, whichever comes
+ * first.
+ */
+static int grow_dpa_allocation(struct nd_region *nd_region,
+		struct nd_label_id *label_id, resource_size_t n)
+{
+	int i;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		int rc;
+
+		rc = scan_allocate(nd_region, nd_mapping, label_id, n);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static void nd_namespace_pmem_set_size(struct nd_region *nd_region,
+		struct nd_namespace_pmem *nspm, resource_size_t size)
+{
+	struct resource *res = &nspm->nsio.res;
+
+	res->start = nd_region->ndr_start;
+	res->end = nd_region->ndr_start + size - 1;
+}
+
+static ssize_t __size_store(struct device *dev, unsigned long long val)
+{
+	resource_size_t allocated = 0, available = 0;
+	struct nd_region *nd_region = to_nd_region(dev->parent);
+	struct nd_mapping *nd_mapping;
+	struct nd_dimm_drvdata *ndd;
+	struct nd_label_id label_id;
+	u32 flags = 0, remainder;
+	u8 *uuid = NULL;
+	int rc, i;
+
+	if (dev->driver)
+		return -EBUSY;
+
+	if (is_namespace_pmem(dev)) {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+		uuid = nspm->uuid;
+	} else if (is_namespace_blk(dev)) {
+		/* TODO: blk namespace support */
+		return -ENXIO;
+	}
+
+	/*
+	 * We need a uuid for the allocation-label and dimm(s) on which
+	 * to store the label.
+	 */
+	if (!uuid || nd_region->ndr_mappings == 0)
+		return -ENXIO;
+
+	div_u64_rem(val, SZ_4K * nd_region->ndr_mappings, &remainder);
+	if (remainder) {
+		dev_dbg(dev, "%llu is not %dK aligned\n", val,
+				(SZ_4K * nd_region->ndr_mappings) / SZ_1K);
+		return -EINVAL;
+	}
+
+	nd_label_gen_id(&label_id, uuid, flags);
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		nd_mapping = &nd_region->mapping[i];
+		ndd = to_ndd(nd_mapping);
+
+		/*
+		 * All dimms in an interleave set, or the base dimm for a blk
+		 * region, need to be enabled for the size to be changed.
+		 */
+		if (!ndd)
+			return -ENXIO;
+
+		allocated += nd_dimm_allocated_dpa(ndd, &label_id);
+	}
+	available = nd_region_available_dpa(nd_region);
+
+	if (val > available + allocated)
+		return -ENOSPC;
+
+	if (val == allocated)
+		return 0;
+
+	val = div_u64(val, nd_region->ndr_mappings);
+	allocated = div_u64(allocated, nd_region->ndr_mappings);
+	if (val < allocated)
+		rc = shrink_dpa_allocation(nd_region, &label_id, allocated - val);
+	else
+		rc = grow_dpa_allocation(nd_region, &label_id, val - allocated);
+
+	if (rc)
+		return rc;
+
+	if (is_namespace_pmem(dev)) {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+		nd_namespace_pmem_set_size(nd_region, nspm,
+				val * nd_region->ndr_mappings);
+	}
+
+	return rc;
+}
+
+static ssize_t size_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	unsigned long long val;
+	u8 **uuid = NULL;
+	int rc;
+
+	rc = kstrtoull(buf, 0, &val);
+	if (rc)
+		return rc;
+
+	device_lock(dev);
+	nd_bus_lock(dev);
+	wait_nd_bus_probe_idle(dev);
+	rc = __size_store(dev, val);
+
+	if (is_namespace_pmem(dev)) {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+		uuid = &nspm->uuid;
+	} else if (is_namespace_blk(dev)) {
+		/* TODO: blk namespace support */
+		rc = -ENXIO;
+	}
+
+	if (rc == 0 && val == 0 && uuid) {
+		/* setting size zero == 'delete namespace' */
+		kfree(*uuid);
+		*uuid = NULL;
+	}
+
+	dev_dbg(dev, "%s: %llx %s (%d)\n", __func__, val, rc < 0
+			? "fail" : "success", rc);
+
+	nd_bus_unlock(dev);
+	device_unlock(dev);
+
+	return rc ? rc : len;
+}
+
+static ssize_t size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	if (is_namespace_pmem(dev)) {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+		return sprintf(buf, "%llu\n", (unsigned long long)
+				resource_size(&nspm->nsio.res));
+	} else if (is_namespace_blk(dev)) {
+		/* TODO: blk namespace support */
+		return -ENXIO;
+	} else if (is_namespace_io(dev)) {
+		struct nd_namespace_io *nsio = to_nd_namespace_io(dev);
+
+		return sprintf(buf, "%llu\n", (unsigned long long)
+				resource_size(&nsio->res));
+	} else
+		return -ENXIO;
+}
+static DEVICE_ATTR(size, S_IRUGO, size_show, size_store);
+
+static ssize_t uuid_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	u8 *uuid;
+
+	if (is_namespace_pmem(dev)) {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+		uuid = nspm->uuid;
+	} else if (is_namespace_blk(dev)) {
+		/* TODO: blk namespace support */
+		return -ENXIO;
+	} else
+		return -ENXIO;
+
+	if (uuid)
+		return sprintf(buf, "%pUb\n", uuid);
+	return sprintf(buf, "\n");
+}
+
+/**
+ * namespace_update_uuid - check for a unique uuid and whether we're "renaming"
+ * @nd_region: parent region so we can updates all dimms in the set
+ * @dev: namespace type for generating label_id
+ * @new_uuid: incoming uuid
+ * @old_uuid: reference to the uuid storage location in the namespace object
+ */
+static int namespace_update_uuid(struct nd_region *nd_region,
+		struct device *dev, u8 *new_uuid, u8 **old_uuid)
+{
+	u32 flags = is_namespace_blk(dev) ? NSLABEL_FLAG_LOCAL : 0;
+	struct nd_label_id old_label_id;
+	struct nd_label_id new_label_id;
+	int i, rc;
+
+	rc = nd_is_uuid_unique(dev, new_uuid) ? 0 : -EINVAL;
+	if (rc) {
+		kfree(new_uuid);
+		return rc;
+	}
+
+	if (*old_uuid == NULL)
+		goto out;
+
+	nd_label_gen_id(&old_label_id, *old_uuid, flags);
+	nd_label_gen_id(&new_label_id, new_uuid, flags);
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+		struct resource *res;
+
+		for_each_dpa_resource(ndd, res)
+			if (strcmp(res->name, old_label_id.id) == 0)
+				sprintf((void *) res->name, "%s",
+						new_label_id.id);
+	}
+	kfree(*old_uuid);
+ out:
+	*old_uuid = new_uuid;
+	return 0;
+}
+
+static ssize_t uuid_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct nd_region *nd_region = to_nd_region(dev->parent);
+	u8 *uuid = NULL;
+	u8 **ns_uuid;
+	ssize_t rc;
+
+	if (is_namespace_pmem(dev)) {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+		ns_uuid = &nspm->uuid;
+	} else if (is_namespace_blk(dev)) {
+		/* TODO: blk namespace support */
+		return -ENXIO;
+	} else
+		return -ENXIO;
+
+	device_lock(dev);
+	nd_bus_lock(dev);
+	wait_nd_bus_probe_idle(dev);
+	rc = nd_uuid_store(dev, &uuid, buf, len);
+	if (rc >= 0)
+		rc = namespace_update_uuid(nd_region, dev, uuid, ns_uuid);
+	dev_dbg(dev, "%s: result: %zd wrote: %s%s", __func__,
+			rc, buf, buf[len - 1] == '\n' ? "" : "\n");
+	nd_bus_unlock(dev);
+	device_unlock(dev);
+
+	return rc ? rc : len;
+}
+static DEVICE_ATTR_RW(uuid);
+
+static ssize_t resource_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct resource *res;
+
+	if (is_namespace_pmem(dev)) {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+		res = &nspm->nsio.res;
+	} else if (is_namespace_io(dev)) {
+		struct nd_namespace_io *nsio = to_nd_namespace_io(dev);
+
+		res = &nsio->res;
+	} else
+		return -ENXIO;
+
+	/* no address to convey if the namespace has no allocation */
+	if (resource_size(res) == 0)
+		return -ENXIO;
+	return sprintf(buf, "%#llx\n", (unsigned long long) res->start);
+}
+static DEVICE_ATTR_RO(resource);
+
 static struct attribute *nd_namespace_attributes[] = {
 	&dev_attr_type.attr,
+	&dev_attr_size.attr,
+	&dev_attr_uuid.attr,
+	&dev_attr_resource.attr,
+	&dev_attr_alt_name.attr,
 	NULL,
 };
 
+static umode_t nd_namespace_attr_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+
+	if (a == &dev_attr_resource.attr) {
+		if (is_namespace_blk(dev))
+			return 0;
+		return a->mode;
+	}
+
+	if (is_namespace_pmem(dev) || is_namespace_blk(dev)) {
+		if (a == &dev_attr_size.attr)
+			return S_IWUSR;
+		return a->mode;
+	}
+
+	if (a == &dev_attr_type.attr || a == &dev_attr_size.attr)
+		return a->mode;
+
+	return 0;
+}
+
 static struct attribute_group nd_namespace_attribute_group = {
 	.attrs = nd_namespace_attributes,
+	.is_visible = nd_namespace_attr_visible,
 };
 
 static const struct attribute_group *nd_namespace_attribute_groups[] = {
@@ -80,23 +783,326 @@ static struct device **create_namespace_io(struct nd_region *nd_region)
 	return devs;
 }
 
+static bool has_uuid_at_pos(struct nd_region *nd_region, u8 *uuid, u64 cookie, u16 pos)
+{
+	struct nd_namespace_label __iomem *found = NULL;
+	int i;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nd_namespace_label __iomem *nd_label;
+		u8 label_uuid[NSLABEL_UUID_LEN];
+		u8 *found_uuid = NULL;
+		int l;
+
+		for_each_label(l, nd_label, nd_mapping->labels) {
+			u64 isetcookie = readq(&nd_label->isetcookie);
+			u16 position = readw(&nd_label->position);
+			u16 nlabel = readw(&nd_label->nlabel);
+
+			if (isetcookie != cookie)
+				continue;
+
+			memcpy_fromio(label_uuid, nd_label->uuid,
+					NSLABEL_UUID_LEN);
+			if (memcmp(label_uuid, uuid, NSLABEL_UUID_LEN) != 0)
+				continue;
+
+			if (found_uuid) {
+				dev_dbg(to_ndd(nd_mapping)->dev,
+						"%s duplicate entry for uuid\n",
+						__func__);
+				return false;
+			}
+			found_uuid = label_uuid;
+			if (nlabel != nd_region->ndr_mappings)
+				continue;
+			if (position != pos)
+				continue;
+			found = nd_label;
+			break;
+		}
+		if (found)
+			break;
+	}
+	return found != NULL;
+}
+
+static int select_pmem_uuid(struct nd_region *nd_region, u8 *pmem_uuid)
+{
+	struct nd_namespace_label __iomem *select = NULL;
+	int i;
+
+	if (!pmem_uuid)
+		return -ENODEV;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nd_namespace_label __iomem *nd_label;
+		u64 hw_start, hw_end, pmem_start, pmem_end;
+		int l;
+
+		for_each_label(l, nd_label, nd_mapping->labels) {
+			u8 label_uuid[NSLABEL_UUID_LEN];
+
+			memcpy_fromio(label_uuid, nd_label->uuid,
+					NSLABEL_UUID_LEN);
+			if (memcmp(label_uuid, pmem_uuid, NSLABEL_UUID_LEN) == 0)
+				break;
+		}
+
+		if (!nd_label) {
+			WARN_ON(1);
+			return -EINVAL;
+		}
+
+		select = nd_label;
+		/*
+		 * Check that this label is compliant with the dpa
+		 * range published in NFIT
+		 */
+		hw_start = nd_mapping->start;
+		hw_end = hw_start + nd_mapping->size;
+		pmem_start = readq(&select->dpa);
+		pmem_end = pmem_start + readq(&select->rawsize);
+		if (pmem_start == hw_start && pmem_end <= hw_end)
+			/* pass */;
+		else
+			return -EINVAL;
+
+		nd_set_label(nd_mapping->labels, select, 0);
+		nd_set_label(nd_mapping->labels, (void __iomem *) NULL, 1);
+	}
+	return 0;
+}
+
+/**
+ * find_pmem_label_set - validate interleave set labelling, retrieve label0
+ * @nd_region: region with mappings to validate
+ */
+static int find_pmem_label_set(struct nd_region *nd_region,
+		struct nd_namespace_pmem *nspm)
+{
+	u64 cookie = nd_region_interleave_set_cookie(nd_region);
+	struct nd_namespace_label __iomem *nd_label;
+	u8 select_uuid[NSLABEL_UUID_LEN];
+	resource_size_t size = 0;
+	u8 *pmem_uuid = NULL;
+	int rc = -ENODEV, l;
+	u16 i;
+
+	if (cookie == 0)
+		return -ENXIO;
+
+	/*
+	 * Find a complete set of labels by uuid.  By definition we can start
+	 * with any mapping as the reference label
+	 */
+	for_each_label(l, nd_label, nd_region->mapping[0].labels) {
+		u64 isetcookie = readq(&nd_label->isetcookie);
+		u8 label_uuid[NSLABEL_UUID_LEN];
+
+		if (isetcookie != cookie)
+			continue;
+
+		memcpy_fromio(label_uuid, nd_label->uuid,
+				NSLABEL_UUID_LEN);
+		for (i = 0; nd_region->ndr_mappings; i++)
+			if (!has_uuid_at_pos(nd_region, label_uuid, cookie, i))
+				break;
+		if (i < nd_region->ndr_mappings) {
+			/*
+			 * Give up if we don't find an instance of a
+			 * uuid at each position (from 0 to
+			 * nd_region->ndr_mappings - 1), or if we find a
+			 * dimm with two instances of the same uuid.
+			 */
+			rc = -EINVAL;
+			goto err;
+		} else if (pmem_uuid) {
+			/*
+			 * If there is more than one valid uuid set, we
+			 * need userspace to clean this up.
+			 */
+			rc = -EBUSY;
+			goto err;
+		}
+		memcpy(select_uuid, label_uuid, NSLABEL_UUID_LEN);
+		pmem_uuid = select_uuid;
+	}
+
+	/*
+	 * Fix up each mapping's 'labels' to have the validated pmem label for
+	 * that position at labels[0], and NULL at labels[1].  In the process,
+	 * check that the namespace aligns with interleave-set.  We know
+	 * that it does not overlap with any blk namespaces by virtue of
+	 * the dimm being enabled (i.e. nd_label_reserve_dpa()
+	 * succeeded).
+	 */
+	rc = select_pmem_uuid(nd_region, pmem_uuid);
+	if (rc)
+		goto err;
+
+	/* Calculate total size and populate namespace properties from label0 */
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nd_namespace_label __iomem *label0;
+
+		label0 = nd_get_label(nd_mapping->labels, 0);
+		size += readq(&label0->rawsize);
+		if (readl(&label0->position) != 0)
+			continue;
+		WARN_ON(nspm->alt_name || nspm->uuid);
+		nspm->alt_name = kmemdup((void __force *) label0->name,
+				NSLABEL_NAME_LEN, GFP_KERNEL);
+		nspm->uuid = kmemdup((void __force *) label0->uuid,
+				NSLABEL_UUID_LEN, GFP_KERNEL);
+	}
+
+	if (!nspm->alt_name || !nspm->uuid) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	nd_namespace_pmem_set_size(nd_region, nspm, size);
+
+	return 0;
+ err:
+	switch (rc) {
+	case -EINVAL:
+		dev_dbg(&nd_region->dev, "%s: invalid label(s)\n", __func__);
+		break;
+	case -ENODEV:
+		dev_dbg(&nd_region->dev, "%s: label not found\n", __func__);
+		break;
+	default:
+		dev_dbg(&nd_region->dev, "%s: unexpected err: %d\n", __func__, rc);
+		break;
+	}
+	return rc;
+}
+
+static struct device **create_namespace_pmem(struct nd_region *nd_region)
+{
+	struct nd_namespace_pmem *nspm;
+	struct device *dev, **devs;
+	struct resource *res;
+	int rc;
+
+	nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
+	if (!nspm)
+		return NULL;
+
+	dev = &nspm->nsio.dev;
+	dev->type = &namespace_pmem_device_type;
+	res = &nspm->nsio.res;
+	res->name = dev_name(&nd_region->dev);
+	res->flags = IORESOURCE_MEM;
+	rc = find_pmem_label_set(nd_region, nspm);
+	if (rc == -ENODEV) {
+		int i;
+
+		/* Pass, try to permit namespace creation... */
+		for (i = 0; i < nd_region->ndr_mappings; i++) {
+			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+
+			kfree(nd_mapping->labels);
+			nd_mapping->labels = NULL;
+		}
+
+		/* Publish a zero-sized namespace for userspace to configure. */
+		nd_namespace_pmem_set_size(nd_region, nspm, 0);
+
+		rc = 0;
+	} else if (rc)
+		goto err;
+
+	devs = kcalloc(2, sizeof(struct device *), GFP_KERNEL);
+	if (!devs)
+		goto err;
+
+	devs[0] = dev;
+	return devs;
+
+ err:
+	namespace_pmem_release(&nspm->nsio.dev);
+	return NULL;
+}
+
+static int init_active_labels(struct nd_region *nd_region)
+{
+	int i;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+		int count, j;
+
+		/*
+		 * If the dimm is disabled then prevent the region from
+		 * being activated if it aliases DPA.
+		 */
+		if (!ndd) {
+			struct nd_dimm *nd_dimm = nd_mapping->nd_dimm;
+
+			if ((nd_dimm->flags & NDD_ALIASING) == 0)
+				return 0;
+			dev_dbg(&nd_region->dev, "%s: is disabled, failing probe\n",
+					dev_name(&nd_mapping->nd_dimm->dev));
+			return -ENXIO;
+		}
+
+		count = nd_label_active_count(ndd);
+		dev_dbg(ndd->dev, "%s: %d\n", __func__, count);
+		if (!count)
+			continue;
+		nd_mapping->labels = kcalloc(count + 1,
+				sizeof(struct nd_namespace_label *), GFP_KERNEL);
+		if (!nd_mapping->labels)
+			return -ENOMEM;
+		for (j = 0; j < count; j++) {
+			struct nd_namespace_label __iomem *label;
+
+			label = nd_label_active(ndd, j);
+			nd_set_label(nd_mapping->labels, label, j);
+		}
+	}
+
+	return 0;
+}
+
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err)
 {
 	struct device **devs = NULL;
-	int i;
+	int i, rc = 0, type;
 
 	*err = 0;
-	switch (nd_region_to_namespace_type(nd_region)) {
+	nd_bus_lock(&nd_region->dev);
+	rc = init_active_labels(nd_region);
+	if (rc) {
+		nd_bus_unlock(&nd_region->dev);
+		return rc;
+	}
+
+	type = nd_region_to_namespace_type(nd_region);
+	switch (type) {
 	case ND_DEVICE_NAMESPACE_IO:
 		devs = create_namespace_io(nd_region);
 		break;
+	case ND_DEVICE_NAMESPACE_PMEM:
+		devs = create_namespace_pmem(nd_region);
+		break;
 	default:
 		break;
 	}
+	nd_bus_unlock(&nd_region->dev);
 
-	if (!devs)
-		return -ENODEV;
+	if (!devs) {
+		rc = -ENODEV;
+		goto err;
+	}
 
+	nd_region->ns_seed = devs[0];
 	for (i = 0; devs[i]; i++) {
 		struct device *dev = devs[i];
 
@@ -108,4 +1114,14 @@ int nd_region_register_namespaces(struct nd_region *nd_region, int *err)
 	kfree(devs);
 
 	return i;
+
+ err:
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+
+		kfree(nd_mapping->labels);
+		nd_mapping->labels = NULL;
+	}
+
+	return rc;
 }
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index 5d8249be3415..f09d7784dc11 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -60,4 +60,18 @@ int nd_bus_register_dimms(struct nd_bus *nd_bus);
 int nd_bus_register_regions(struct nd_bus *nd_bus);
 int nd_bus_init_interleave_sets(struct nd_bus *nd_bus);
 int nd_match_dimm(struct device *dev, void *data);
+struct nd_label_id;
+char *nd_label_gen_id(struct nd_label_id *label_id, u8 *uuid, u32 flags);
+bool nd_is_uuid_unique(struct device *dev, u8 *uuid);
+struct nd_region;
+struct nd_dimm_drvdata;
+struct nd_mapping;
+resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
+		struct nd_mapping *nd_mapping, resource_size_t *overlap);
+resource_size_t nd_region_available_dpa(struct nd_region *nd_region);
+struct resource *nd_dimm_allocate_dpa(struct nd_dimm_drvdata *ndd,
+		struct nd_label_id *label_id, resource_size_t start,
+		resource_size_t n);
+resource_size_t nd_dimm_allocated_dpa(struct nd_dimm_drvdata *ndd,
+		struct nd_label_id *label_id);
 #endif /* __ND_PRIVATE_H__ */
diff --git a/drivers/block/nd/nd.h b/drivers/block/nd/nd.h
index 832103a5e3f7..c93675172889 100644
--- a/drivers/block/nd/nd.h
+++ b/drivers/block/nd/nd.h
@@ -15,6 +15,7 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/ndctl.h>
+#include <linux/types.h>
 #include "libnd.h"
 #include "label.h"
 
@@ -59,12 +60,37 @@ static inline struct nd_namespace_index __iomem *to_next_namespace_index(
 		(unsigned long long) (res ? resource_size(res) : 0), \
 		(unsigned long long) (res ? res->start : 0), ##arg)
 
+/* sparse helpers */
+static inline void nd_set_label(struct nd_namespace_label **labels,
+		struct nd_namespace_label __iomem *label, int idx)
+{
+	labels[idx] = (void __force *) label;
+}
+
+static inline struct nd_namespace_label __iomem *nd_get_label(
+		struct nd_namespace_label **labels, int idx)
+{
+	struct nd_namespace_label __iomem *label = NULL;
+
+	if (labels)
+		label = (struct nd_namespace_label __iomem *) labels[idx];
+
+	return label;
+}
+
+#define for_each_label(l, label, labels) \
+	for (l = 0; (label = nd_get_label(labels, l)); l++)
+
+#define for_each_dpa_resource(ndd, res) \
+	for (res = (ndd)->dpa.child; res; res = res->sibling)
+
 #define for_each_dpa_resource_safe(ndd, res, next) \
 	for (res = (ndd)->dpa.child, next = res ? res->sibling : NULL; \
 			res; res = next, next = next ? next->sibling : NULL)
 
 struct nd_region {
 	struct device dev;
+	struct device *ns_seed;
 	u16 ndr_mappings;
 	u64 ndr_size;
 	u64 ndr_start;
@@ -88,15 +114,22 @@ enum nd_async_mode {
 	ND_ASYNC,
 };
 
+void wait_nd_bus_probe_idle(struct device *dev);
 void nd_device_register(struct device *dev);
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode);
+int nd_uuid_store(struct device *dev, u8 **uuid_out, const char *buf,
+		size_t len);
+struct nd_dimm;
+struct nd_dimm_drvdata *to_ndd(struct nd_mapping *nd_mapping);
 int nd_dimm_init_nsarea(struct nd_dimm_drvdata *ndd);
 int nd_dimm_init_config_data(struct nd_dimm_drvdata *ndd);
 struct nd_region *to_nd_region(struct device *dev);
 int nd_region_to_namespace_type(struct nd_region *nd_region);
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
+u64 nd_region_interleave_set_cookie(struct nd_region *nd_region);
 void nd_bus_lock(struct device *dev);
 void nd_bus_unlock(struct device *dev);
 bool is_nd_bus_locked(struct device *dev);
 int nd_label_reserve_dpa(struct nd_dimm_drvdata *ndd);
+void nd_dimm_free_dpa(struct nd_dimm_drvdata *ndd, struct resource *res);
 #endif /* __ND_H__ */
diff --git a/drivers/block/nd/pmem.c b/drivers/block/nd/pmem.c
index c9dd8d7eca3a..32e7e74ee25a 100644
--- a/drivers/block/nd/pmem.c
+++ b/drivers/block/nd/pmem.c
@@ -24,6 +24,7 @@
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
 #include <linux/nd.h>
+#include "nd.h"
 
 #define PMEM_MINORS		16
 
@@ -209,9 +210,27 @@ static void pmem_free(struct pmem_device *pmem)
 
 static int nd_pmem_probe(struct device *dev)
 {
+	struct nd_region *nd_region = to_nd_region(dev->parent);
 	struct nd_namespace_io *nsio = to_nd_namespace_io(dev);
 	struct pmem_device *pmem;
 
+	if (resource_size(&nsio->res) < ND_MIN_NAMESPACE_SIZE) {
+		resource_size_t size = resource_size(&nsio->res);
+
+		dev_dbg(dev, "%s: size: %pa, too small must be at least %#x\n",
+				__func__, &size, ND_MIN_NAMESPACE_SIZE);
+		return -ENODEV;
+	}
+
+	if (nd_region_to_namespace_type(nd_region) == ND_DEVICE_NAMESPACE_PMEM) {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+		if (!nspm->uuid) {
+			dev_dbg(dev, "%s: uuid not set\n", __func__);
+			return -ENODEV;
+		}
+	}
+
 	pmem = pmem_alloc(dev, &nsio->res);
 	if (IS_ERR(pmem))
 		return PTR_ERR(pmem);
@@ -231,13 +250,14 @@ static int nd_pmem_remove(struct device *dev)
 
 MODULE_ALIAS("pmem");
 MODULE_ALIAS_ND_DEVICE(ND_DEVICE_NAMESPACE_IO);
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_NAMESPACE_PMEM);
 static struct nd_device_driver nd_pmem_driver = {
 	.probe = nd_pmem_probe,
 	.remove = nd_pmem_remove,
 	.drv = {
 		.name = "pmem",
 	},
-	.type = ND_DRIVER_NAMESPACE_IO,
+	.type = ND_DRIVER_NAMESPACE_IO | ND_DRIVER_NAMESPACE_PMEM,
 };
 
 static int __init pmem_init(void)
diff --git a/drivers/block/nd/region_devs.c b/drivers/block/nd/region_devs.c
index c1cea42d0473..e74b3d4534b4 100644
--- a/drivers/block/nd/region_devs.c
+++ b/drivers/block/nd/region_devs.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/io.h>
+#include <linux/nd.h>
 #include "nd-private.h"
 #include "nd.h"
 
@@ -99,6 +100,58 @@ int nd_region_to_namespace_type(struct nd_region *nd_region)
 
 	return 0;
 }
+EXPORT_SYMBOL(nd_region_to_namespace_type);
+
+static int is_uuid_busy(struct device *dev, void *data)
+{
+	struct nd_region *nd_region = to_nd_region(dev->parent);
+	u8 *uuid = data;
+
+	switch (nd_region_to_namespace_type(nd_region)) {
+	case ND_DEVICE_NAMESPACE_PMEM: {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+		if (!nspm->uuid)
+			break;
+		if (memcmp(uuid, nspm->uuid, NSLABEL_UUID_LEN) == 0)
+			return -EBUSY;
+		break;
+	}
+	case ND_DEVICE_NAMESPACE_BLK: {
+		/* TODO: blk namespace support */
+		break;
+	}
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int is_namespace_uuid_busy(struct device *dev, void *data)
+{
+	if (is_nd_pmem(dev) || is_nd_blk(dev))
+		return device_for_each_child(dev, data, is_uuid_busy);
+	return 0;
+}
+
+/**
+ * nd_is_uuid_unique - verify that no other namespace has @uuid
+ * @dev: any device on a nd_bus
+ * @uuid: uuid to check
+ */
+bool nd_is_uuid_unique(struct device *dev, u8 *uuid)
+{
+	struct nd_bus *nd_bus = walk_to_nd_bus(dev);
+
+	if (!nd_bus)
+		return false;
+	WARN_ON_ONCE(!is_nd_bus_locked(&nd_bus->dev));
+	if (device_for_each_child(&nd_bus->dev, uuid,
+				is_namespace_uuid_busy) != 0)
+		return false;
+	return true;
+}
 
 static ssize_t size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
@@ -151,6 +204,60 @@ static ssize_t set_cookie_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(set_cookie);
 
+resource_size_t nd_region_available_dpa(struct nd_region *nd_region)
+{
+	resource_size_t blk_max_overlap = 0, available, overlap;
+	int i;
+
+	WARN_ON(!is_nd_bus_locked(&nd_region->dev));
+
+ retry:
+	available = 0;
+	overlap = blk_max_overlap;
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+
+		/* if a dimm is disabled the available capacity is zero */
+		if (!ndd)
+			return 0;
+
+		if (is_nd_pmem(&nd_region->dev)) {
+			available += nd_pmem_available_dpa(nd_region,
+					nd_mapping, &overlap);
+			if (overlap > blk_max_overlap) {
+				blk_max_overlap = overlap;
+				goto retry;
+			}
+		} else if (is_nd_blk(&nd_region->dev)) {
+			/* TODO: BLK Namespace support */
+		}
+	}
+
+	return available;
+}
+
+static ssize_t available_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+	unsigned long long available = 0;
+
+	/*
+	 * Flush in-flight updates and grab a snapshot of the available
+	 * size.  Of course, this value is potentially invalidated the
+	 * memory nd_bus_lock() is dropped, but that's userspace's
+	 * problem to not race itself.
+	 */
+	nd_bus_lock(dev);
+	wait_nd_bus_probe_idle(dev);
+	available = nd_region_available_dpa(nd_region);
+	nd_bus_unlock(dev);
+
+	return sprintf(buf, "%llu\n", available);
+}
+static DEVICE_ATTR_RO(available_size);
+
 static ssize_t init_namespaces_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -163,11 +270,29 @@ static ssize_t init_namespaces_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(init_namespaces);
 
+static ssize_t namespace_seed_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+	ssize_t rc;
+
+	nd_bus_lock(dev);
+	if (nd_region->ns_seed)
+		rc = sprintf(buf, "%s\n", dev_name(nd_region->ns_seed));
+	else
+		rc = sprintf(buf, "\n");
+	nd_bus_unlock(dev);
+	return rc;
+}
+static DEVICE_ATTR_RO(namespace_seed);
+
 static struct attribute *nd_region_attributes[] = {
 	&dev_attr_size.attr,
 	&dev_attr_nstype.attr,
 	&dev_attr_mappings.attr,
 	&dev_attr_set_cookie.attr,
+	&dev_attr_available_size.attr,
+	&dev_attr_namespace_seed.attr,
 	&dev_attr_init_namespaces.attr,
 	NULL,
 };
@@ -177,12 +302,17 @@ static umode_t nd_region_visible(struct kobject *kobj, struct attribute *a, int
 	struct device *dev = container_of(kobj, typeof(*dev), kobj);
 	struct nd_region *nd_region = to_nd_region(dev);
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
+	int type = nd_region_to_namespace_type(nd_region);
 
-	if (a != &dev_attr_set_cookie.attr)
+	if (a != &dev_attr_set_cookie.attr && a != &dev_attr_available_size.attr)
 		return a->mode;
 
-	if (is_nd_pmem(dev) && nd_set)
-			return a->mode;
+	if ((type == ND_DEVICE_NAMESPACE_PMEM
+				|| type == ND_DEVICE_NAMESPACE_BLK)
+			&& a == &dev_attr_available_size.attr)
+		return a->mode;
+	else if (is_nd_pmem(dev) && nd_set)
+		return a->mode;
 
 	return 0;
 }
@@ -193,6 +323,15 @@ struct attribute_group nd_region_attribute_group = {
 };
 EXPORT_SYMBOL_GPL(nd_region_attribute_group);
 
+u64 nd_region_interleave_set_cookie(struct nd_region *nd_region)
+{
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
+
+	if (nd_set)
+		return nd_set->cookie;
+	return 0;
+}
+
 /*
  * Upon successful probe/remove, take/release a reference on the
  * associated interleave set (if present)
diff --git a/include/linux/nd.h b/include/linux/nd.h
index da70e9962197..255c38a83083 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -28,16 +28,40 @@ static inline struct nd_device_driver *to_nd_device_driver(
 	return container_of(drv, struct nd_device_driver, drv);
 };
 
+/**
+ * struct nd_namespace_io - infrastructure for loading an nd_pmem instance
+ * @dev: namespace device created by the nd region driver
+ * @res: struct resource conversion of a NFIT SPA table
+ */
 struct nd_namespace_io {
 	struct device dev;
 	struct resource res;
 };
 
+/**
+ * struct nd_namespace_pmem - namespace device for dimm-backed interleaved memory
+ * @nsio: device and system physical address range to drive
+ * @alt_name: namespace name supplied in the dimm label
+ * @uuid: namespace name supplied in the dimm label
+ */
+struct nd_namespace_pmem {
+	struct nd_namespace_io nsio;
+	char *alt_name;
+	u8 *uuid;
+};
+
 static inline struct nd_namespace_io *to_nd_namespace_io(struct device *dev)
 {
 	return container_of(dev, struct nd_namespace_io, dev);
 }
 
+static inline struct nd_namespace_pmem *to_nd_namespace_pmem(struct device *dev)
+{
+	struct nd_namespace_io *nsio = to_nd_namespace_io(dev);
+
+	return container_of(nsio, struct nd_namespace_pmem, nsio);
+}
+
 #define MODULE_ALIAS_ND_DEVICE(type) \
 	MODULE_ALIAS("nd:t" __stringify(type) "*")
 #define ND_DEVICE_MODALIAS_FMT "nd:t%d"
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 624a19d9e6e4..0b4dcabb248a 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -190,4 +190,8 @@ enum nd_driver_flags {
 	ND_DRIVER_NAMESPACE_PMEM  = 1 << ND_DEVICE_NAMESPACE_PMEM,
 	ND_DRIVER_NAMESPACE_BLK   = 1 << ND_DEVICE_NAMESPACE_BLK,
 };
+
+enum {
+	ND_MIN_NAMESPACE_SIZE = 0x00400000,
+};
 #endif /* __NDCTL_H__ */

