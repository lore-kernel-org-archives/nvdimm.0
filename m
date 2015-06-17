Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v7 13/16] libnvdimm: pmem label sets and namespace
 instantiation.
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:14:31 -0400
Message-ID: <20150617231431.11597.37021.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

A complete label set is a PMEM-label per-dimm per-interleave-set where
all the UUIDs match and the interleave set cookie matches the hosting
interleave set.

Present sysfs attributes for manipulation of a PMEM-namespace's
'alt_name', 'uuid', and 'size' attributes.  A later patch will make
these settings persistent by writing back the label.

Note that PMEM allocations grow forwards from the start of an interleave
set (lowest dimm-physical-address (DPA)).  BLK-namespaces that alias
with a PMEM interleave set will grow allocations backward from the
highest DPA.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Neil Brown <neilb@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c            |    8 
 drivers/nvdimm/core.c           |   64 ++
 drivers/nvdimm/dimm.c           |   21 -
 drivers/nvdimm/dimm_devs.c      |  137 +++++
 drivers/nvdimm/label.c          |   55 ++
 drivers/nvdimm/label.h          |    2 
 drivers/nvdimm/namespace_devs.c | 1002 +++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h        |   12 
 drivers/nvdimm/nd.h             |   17 +
 drivers/nvdimm/pmem.c           |   20 +
 drivers/nvdimm/region.c         |    3 
 drivers/nvdimm/region_devs.c    |  158 ++++++
 include/linux/libnvdimm.h       |   10 
 include/linux/nd.h              |   24 +
 include/uapi/linux/ndctl.h      |    4 
 15 files changed, 1506 insertions(+), 31 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index ffb43cada625..fddc3f2a8f80 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -97,6 +97,8 @@ static int nvdimm_bus_probe(struct device *dev)
 	rc = nd_drv->probe(dev);
 	if (rc == 0)
 		nd_region_probe_success(nvdimm_bus, dev);
+	else
+		nd_region_disable(nvdimm_bus, dev);
 	nvdimm_bus_probe_end(nvdimm_bus);
 
 	dev_dbg(&nvdimm_bus->dev, "%s.probe(%s) = %d\n", dev->driver->name,
@@ -381,8 +383,10 @@ u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
 }
 EXPORT_SYMBOL_GPL(nd_cmd_out_size);
 
-static void wait_nvdimm_bus_probe_idle(struct nvdimm_bus *nvdimm_bus)
+void wait_nvdimm_bus_probe_idle(struct device *dev)
 {
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+
 	do {
 		if (nvdimm_bus->probe_active == 0)
 			break;
@@ -402,7 +406,7 @@ static int nd_cmd_clear_to_send(struct nvdimm *nvdimm, unsigned int cmd)
 		return 0;
 
 	nvdimm_bus = walk_to_nvdimm_bus(&nvdimm->dev);
-	wait_nvdimm_bus_probe_idle(nvdimm_bus);
+	wait_nvdimm_bus_probe_idle(&nvdimm_bus->dev);
 
 	if (atomic_read(&nvdimm->busy))
 		return -EBUSY;
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 7806eaaf4707..cf99cce8ef33 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -14,6 +14,7 @@
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/ctype.h>
 #include <linux/ndctl.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
@@ -109,6 +110,69 @@ struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev)
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
diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index 2df97c3c3b34..71d12bb67339 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -21,18 +21,6 @@
 #include "label.h"
 #include "nd.h"
 
-static void free_data(struct nvdimm_drvdata *ndd)
-{
-	if (!ndd)
-		return;
-
-	if (ndd->data && is_vmalloc_addr(ndd->data))
-		vfree(ndd->data);
-	else
-		kfree(ndd->data);
-	kfree(ndd);
-}
-
 static int nvdimm_probe(struct device *dev)
 {
 	struct nvdimm_drvdata *ndd;
@@ -49,6 +37,8 @@ static int nvdimm_probe(struct device *dev)
 	ndd->dpa.start = 0;
 	ndd->dpa.end = -1;
 	ndd->dev = dev;
+	get_device(dev);
+	kref_init(&ndd->kref);
 
 	rc = nvdimm_init_nsarea(ndd);
 	if (rc)
@@ -74,21 +64,18 @@ static int nvdimm_probe(struct device *dev)
 	return 0;
 
  err:
-	free_data(ndd);
+	put_ndd(ndd);
 	return rc;
 }
 
 static int nvdimm_remove(struct device *dev)
 {
 	struct nvdimm_drvdata *ndd = dev_get_drvdata(dev);
-	struct resource *res, *_r;
 
 	nvdimm_bus_lock(dev);
 	dev_set_drvdata(dev, NULL);
-	for_each_dpa_resource_safe(ndd, res, _r)
-		nvdimm_free_dpa(ndd, res);
 	nvdimm_bus_unlock(dev);
-	free_data(ndd);
+	put_ndd(ndd);
 
 	return 0;
 }
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index d2ef02e4be6c..b55acef179ba 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -159,6 +159,48 @@ struct nvdimm *to_nvdimm(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(to_nvdimm);
 
+struct nvdimm_drvdata *to_ndd(struct nd_mapping *nd_mapping)
+{
+	struct nvdimm *nvdimm = nd_mapping->nvdimm;
+
+	WARN_ON_ONCE(!is_nvdimm_bus_locked(&nvdimm->dev));
+
+	return dev_get_drvdata(&nvdimm->dev);
+}
+EXPORT_SYMBOL(to_ndd);
+
+void nvdimm_drvdata_release(struct kref *kref)
+{
+	struct nvdimm_drvdata *ndd = container_of(kref, typeof(*ndd), kref);
+	struct device *dev = ndd->dev;
+	struct resource *res, *_r;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	nvdimm_bus_lock(dev);
+	for_each_dpa_resource_safe(ndd, res, _r)
+		nvdimm_free_dpa(ndd, res);
+	nvdimm_bus_unlock(dev);
+
+	if (ndd->data && is_vmalloc_addr(ndd->data))
+		vfree(ndd->data);
+	else
+		kfree(ndd->data);
+	kfree(ndd);
+	put_device(dev);
+}
+
+void get_ndd(struct nvdimm_drvdata *ndd)
+{
+	kref_get(&ndd->kref);
+}
+
+void put_ndd(struct nvdimm_drvdata *ndd)
+{
+	if (ndd)
+		kref_put(&ndd->kref, nvdimm_drvdata_release);
+}
+
 const char *nvdimm_name(struct nvdimm *nvdimm)
 {
 	return dev_name(&nvdimm->dev);
@@ -247,6 +289,83 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 }
 EXPORT_SYMBOL_GPL(nvdimm_create);
 
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
+	resource_size_t map_start, map_end, busy = 0, available, blk_start;
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct resource *res;
+	const char *reason;
+
+	if (!ndd)
+		return 0;
+
+	map_start = nd_mapping->start;
+	map_end = map_start + nd_mapping->size - 1;
+	blk_start = max(map_start, map_end + 1 - *overlap);
+	for_each_dpa_resource(ndd, res)
+		if (res->start >= map_start && res->start < map_end) {
+			if (strncmp(res->name, "blk", 3) == 0)
+				blk_start = min(blk_start, res->start);
+			else if (res->start != map_start) {
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
+		} else if (res->end >= map_start && res->end <= map_end) {
+			if (strncmp(res->name, "blk", 3) == 0) {
+				/*
+				 * If a BLK allocation overlaps the start of
+				 * PMEM the entire interleave set may now only
+				 * be used for BLK.
+				 */
+				blk_start = map_start;
+			} else {
+				reason = "misaligned to iset";
+				goto err;
+			}
+		} else if (map_start > res->start && map_start < res->end) {
+			/* total eclipse of the mapping */
+			busy += nd_mapping->size;
+			blk_start = map_start;
+		}
+
+	*overlap = map_end + 1 - blk_start;
+	available = blk_start - map_start;
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
 void nvdimm_free_dpa(struct nvdimm_drvdata *ndd, struct resource *res)
 {
 	WARN_ON_ONCE(!is_nvdimm_bus_locked(ndd->dev));
@@ -271,6 +390,24 @@ struct resource *nvdimm_allocate_dpa(struct nvdimm_drvdata *ndd,
 	return res;
 }
 
+/**
+ * nvdimm_allocated_dpa - sum up the dpa currently allocated to this label_id
+ * @nvdimm: container of dpa-resource-root + labels
+ * @label_id: dpa resource name of the form {pmem|blk}-<human readable uuid>
+ */
+resource_size_t nvdimm_allocated_dpa(struct nvdimm_drvdata *ndd,
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
diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index db5d7492dc8d..1a3bcd27a57a 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -230,7 +230,7 @@ static bool preamble_current(struct nvdimm_drvdata *ndd,
 	return true;
 }
 
-static char *nd_label_gen_id(struct nd_label_id *label_id, u8 *uuid, u32 flags)
+char *nd_label_gen_id(struct nd_label_id *label_id, u8 *uuid, u32 flags)
 {
 	if (!label_id || !uuid)
 		return NULL;
@@ -288,3 +288,56 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 
 	return 0;
 }
+
+int nd_label_active_count(struct nvdimm_drvdata *ndd)
+{
+	struct nd_namespace_index *nsindex;
+	unsigned long *free;
+	u32 nslot, slot;
+	int count = 0;
+
+	if (!preamble_current(ndd, &nsindex, &free, &nslot))
+		return 0;
+
+	for_each_clear_bit_le(slot, free, nslot) {
+		struct nd_namespace_label *nd_label;
+
+		nd_label = nd_label_base(ndd) + slot;
+
+		if (!slot_valid(nd_label, slot)) {
+			u32 label_slot = __le32_to_cpu(nd_label->slot);
+			u64 size = __le64_to_cpu(nd_label->rawsize);
+			u64 dpa = __le64_to_cpu(nd_label->dpa);
+
+			dev_dbg(ndd->dev,
+				"%s: slot%d invalid slot: %d dpa: %llx size: %llx\n",
+					__func__, slot, label_slot, dpa, size);
+			continue;
+		}
+		count++;
+	}
+	return count;
+}
+
+struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
+{
+	struct nd_namespace_index *nsindex;
+	unsigned long *free;
+	u32 nslot, slot;
+
+	if (!preamble_current(ndd, &nsindex, &free, &nslot))
+		return NULL;
+
+	for_each_clear_bit_le(slot, free, nslot) {
+		struct nd_namespace_label *nd_label;
+
+		nd_label = nd_label_base(ndd) + slot;
+		if (!slot_valid(nd_label, slot))
+			continue;
+
+		if (n-- == 0)
+			return nd_label_base(ndd) + slot;
+	}
+
+	return NULL;
+}
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index d6aa0d5c6b4e..8ee1376526c7 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -125,4 +125,6 @@ int nd_label_validate(struct nvdimm_drvdata *ndd);
 void nd_label_copy(struct nvdimm_drvdata *ndd, struct nd_namespace_index *dst,
 		struct nd_namespace_index *src);
 size_t sizeof_namespace_index(struct nvdimm_drvdata *ndd);
+int nd_label_active_count(struct nvdimm_drvdata *ndd);
+struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n);
 #endif /* __LABEL_H__ */
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 4f653d1e61ad..5d81032fcfc5 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -14,6 +14,7 @@
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/nd.h>
+#include "nd-core.h"
 #include "nd.h"
 
 static void namespace_io_release(struct device *dev)
@@ -23,11 +24,50 @@ static void namespace_io_release(struct device *dev)
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
 static ssize_t nstype_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -37,13 +77,676 @@ static ssize_t nstype_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(nstype);
 
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
+	nvdimm_bus_lock(dev);
+	wait_nvdimm_bus_probe_idle(dev);
+	rc = __alt_name_store(dev, buf, len);
+	dev_dbg(dev, "%s: %s(%zd)\n", __func__, rc < 0 ? "fail " : "", rc);
+	nvdimm_bus_unlock(dev);
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
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
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
+			nvdimm_free_dpa(ndd, res);
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
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
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
+	res = nvdimm_allocate_dpa(ndd, label_id, first_dpa, n);
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
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
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
+			new_res = nvdimm_allocate_dpa(ndd, label_id,
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
+	struct nvdimm_drvdata *ndd;
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
+		allocated += nvdimm_allocated_dpa(ndd, &label_id);
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
+		rc = shrink_dpa_allocation(nd_region, &label_id,
+				allocated - val);
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
+	nvdimm_bus_lock(dev);
+	wait_nvdimm_bus_probe_idle(dev);
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
+	nvdimm_bus_unlock(dev);
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
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
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
+	nvdimm_bus_lock(dev);
+	wait_nvdimm_bus_probe_idle(dev);
+	rc = nd_uuid_store(dev, &uuid, buf, len);
+	if (rc >= 0)
+		rc = namespace_update_uuid(nd_region, dev, uuid, ns_uuid);
+	dev_dbg(dev, "%s: result: %zd wrote: %s%s", __func__,
+			rc, buf, buf[len - 1] == '\n' ? "" : "\n");
+	nvdimm_bus_unlock(dev);
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
 	&dev_attr_nstype.attr,
+	&dev_attr_size.attr,
+	&dev_attr_uuid.attr,
+	&dev_attr_resource.attr,
+	&dev_attr_alt_name.attr,
 	NULL,
 };
 
+static umode_t namespace_visible(struct kobject *kobj,
+		struct attribute *a, int n)
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
+			return S_IWUSR | S_IRUGO;
+		return a->mode;
+	}
+
+	if (a == &dev_attr_nstype.attr || a == &dev_attr_size.attr)
+		return a->mode;
+
+	return 0;
+}
+
 static struct attribute_group nd_namespace_attribute_group = {
 	.attrs = nd_namespace_attributes,
+	.is_visible = namespace_visible,
 };
 
 static const struct attribute_group *nd_namespace_attribute_groups[] = {
@@ -81,23 +784,318 @@ static struct device **create_namespace_io(struct nd_region *nd_region)
 	return devs;
 }
 
+static bool has_uuid_at_pos(struct nd_region *nd_region, u8 *uuid,
+		u64 cookie, u16 pos)
+{
+	struct nd_namespace_label *found = NULL;
+	int i;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nd_namespace_label *nd_label;
+		bool found_uuid = false;
+		int l;
+
+		for_each_label(l, nd_label, nd_mapping->labels) {
+			u64 isetcookie = __le64_to_cpu(nd_label->isetcookie);
+			u16 position = __le16_to_cpu(nd_label->position);
+			u16 nlabel = __le16_to_cpu(nd_label->nlabel);
+
+			if (isetcookie != cookie)
+				continue;
+
+			if (memcmp(nd_label->uuid, uuid, NSLABEL_UUID_LEN) != 0)
+				continue;
+
+			if (found_uuid) {
+				dev_dbg(to_ndd(nd_mapping)->dev,
+						"%s duplicate entry for uuid\n",
+						__func__);
+				return false;
+			}
+			found_uuid = true;
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
+static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
+{
+	struct nd_namespace_label *select = NULL;
+	int i;
+
+	if (!pmem_id)
+		return -ENODEV;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nd_namespace_label *nd_label;
+		u64 hw_start, hw_end, pmem_start, pmem_end;
+		int l;
+
+		for_each_label(l, nd_label, nd_mapping->labels)
+			if (memcmp(nd_label->uuid, pmem_id, NSLABEL_UUID_LEN) == 0)
+				break;
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
+		pmem_start = __le64_to_cpu(select->dpa);
+		pmem_end = pmem_start + __le64_to_cpu(select->rawsize);
+		if (pmem_start == hw_start && pmem_end <= hw_end)
+			/* pass */;
+		else
+			return -EINVAL;
+
+		nd_mapping->labels[0] = select;
+		nd_mapping->labels[1] = NULL;
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
+	struct nd_namespace_label *nd_label;
+	u8 select_id[NSLABEL_UUID_LEN];
+	resource_size_t size = 0;
+	u8 *pmem_id = NULL;
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
+		u64 isetcookie = __le64_to_cpu(nd_label->isetcookie);
+
+		if (isetcookie != cookie)
+			continue;
+
+		for (i = 0; nd_region->ndr_mappings; i++)
+			if (!has_uuid_at_pos(nd_region, nd_label->uuid,
+						cookie, i))
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
+		} else if (pmem_id) {
+			/*
+			 * If there is more than one valid uuid set, we
+			 * need userspace to clean this up.
+			 */
+			rc = -EBUSY;
+			goto err;
+		}
+		memcpy(select_id, nd_label->uuid, NSLABEL_UUID_LEN);
+		pmem_id = select_id;
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
+	rc = select_pmem_id(nd_region, pmem_id);
+	if (rc)
+		goto err;
+
+	/* Calculate total size and populate namespace properties from label0 */
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nd_namespace_label *label0 = nd_mapping->labels[0];
+
+		size += __le64_to_cpu(label0->rawsize);
+		if (__le16_to_cpu(label0->position) != 0)
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
+		dev_dbg(&nd_region->dev, "%s: unexpected err: %d\n",
+				__func__, rc);
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
+	dev->parent = &nd_region->dev;
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
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+		int count, j;
+
+		/*
+		 * If the dimm is disabled then prevent the region from
+		 * being activated if it aliases DPA.
+		 */
+		if (!ndd) {
+			if ((nvdimm->flags & NDD_ALIASING) == 0)
+				return 0;
+			dev_dbg(&nd_region->dev, "%s: is disabled, failing probe\n",
+					dev_name(&nd_mapping->nvdimm->dev));
+			return -ENXIO;
+		}
+		nd_mapping->ndd = ndd;
+		atomic_inc(&nvdimm->busy);
+		get_ndd(ndd);
+
+		count = nd_label_active_count(ndd);
+		dev_dbg(ndd->dev, "%s: %d\n", __func__, count);
+		if (!count)
+			continue;
+		nd_mapping->labels = kcalloc(count + 1, sizeof(void *),
+				GFP_KERNEL);
+		if (!nd_mapping->labels)
+			return -ENOMEM;
+		for (j = 0; j < count; j++) {
+			struct nd_namespace_label *label;
+
+			label = nd_label_active(ndd, j);
+			nd_mapping->labels[j] = label;
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
-	switch (nd_region_to_nstype(nd_region)) {
+	nvdimm_bus_lock(&nd_region->dev);
+	rc = init_active_labels(nd_region);
+	if (rc) {
+		nvdimm_bus_unlock(&nd_region->dev);
+		return rc;
+	}
+
+	type = nd_region_to_nstype(nd_region);
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
+	nvdimm_bus_unlock(&nd_region->dev);
 
 	if (!devs)
 		return -ENODEV;
 
+	nd_region->ns_seed = devs[0];
 	for (i = 0; devs[i]; i++) {
 		struct device *dev = devs[i];
 
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 6a4b2c066ee7..c6c889292bab 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -56,4 +56,16 @@ int nvdimm_bus_register_dimms(struct nvdimm_bus *nvdimm_bus);
 int nvdimm_bus_register_regions(struct nvdimm_bus *nvdimm_bus);
 int nvdimm_bus_init_interleave_sets(struct nvdimm_bus *nvdimm_bus);
 int nd_match_dimm(struct device *dev, void *data);
+struct nd_label_id;
+char *nd_label_gen_id(struct nd_label_id *label_id, u8 *uuid, u32 flags);
+bool nd_is_uuid_unique(struct device *dev, u8 *uuid);
+struct nd_region;
+struct nvdimm_drvdata;
+struct nd_mapping;
+resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
+		struct nd_mapping *nd_mapping, resource_size_t *overlap);
+resource_size_t nd_region_available_dpa(struct nd_region *nd_region);
+resource_size_t nvdimm_allocated_dpa(struct nvdimm_drvdata *ndd,
+		struct nd_label_id *label_id);
+void get_ndd(struct nvdimm_drvdata *ndd);
 #endif /* __ND_CORE_H__ */
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 401fa0d5b6ea..03e610cd9f43 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -16,6 +16,7 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/ndctl.h>
+#include <linux/types.h>
 #include "label.h"
 
 struct nvdimm_drvdata {
@@ -25,6 +26,7 @@ struct nvdimm_drvdata {
 	void *data;
 	int ns_current, ns_next;
 	struct resource dpa;
+	struct kref kref;
 };
 
 struct nd_region_namespaces {
@@ -59,12 +61,19 @@ static inline struct nd_namespace_index *to_next_namespace_index(
 		(unsigned long long) (res ? resource_size(res) : 0), \
 		(unsigned long long) (res ? res->start : 0), ##arg)
 
+#define for_each_label(l, label, labels) \
+	for (l = 0; (label = labels ? labels[l] : NULL); l++)
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
@@ -88,20 +97,28 @@ enum nd_async_mode {
 	ND_ASYNC,
 };
 
+void wait_nvdimm_bus_probe_idle(struct device *dev);
 void nd_device_register(struct device *dev);
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode);
+int nd_uuid_store(struct device *dev, u8 **uuid_out, const char *buf,
+		size_t len);
 int __init nvdimm_init(void);
 int __init nd_region_init(void);
 void nvdimm_exit(void);
 void nd_region_exit(void);
+struct nvdimm;
+struct nvdimm_drvdata *to_ndd(struct nd_mapping *nd_mapping);
 int nvdimm_init_nsarea(struct nvdimm_drvdata *ndd);
 int nvdimm_init_config_data(struct nvdimm_drvdata *ndd);
 struct nd_region *to_nd_region(struct device *dev);
 int nd_region_to_nstype(struct nd_region *nd_region);
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
+u64 nd_region_interleave_set_cookie(struct nd_region *nd_region);
 void nvdimm_bus_lock(struct device *dev);
 void nvdimm_bus_unlock(struct device *dev);
 bool is_nvdimm_bus_locked(struct device *dev);
+void nvdimm_drvdata_release(struct kref *kref);
+void put_ndd(struct nvdimm_drvdata *ndd);
 int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd);
 void nvdimm_free_dpa(struct nvdimm_drvdata *ndd, struct resource *res);
 struct resource *nvdimm_allocate_dpa(struct nvdimm_drvdata *ndd,
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index d46975ed9e40..90902a142e35 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -203,6 +203,23 @@ static int nd_pmem_probe(struct device *dev)
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
+	if (nd_region_to_nstype(nd_region) == ND_DEVICE_NAMESPACE_PMEM) {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+		if (!nspm->uuid) {
+			dev_dbg(dev, "%s: uuid not set\n", __func__);
+			return -ENODEV;
+		}
+	}
+
 	pmem = pmem_alloc(dev, &nsio->res, nd_region->id);
 	if (IS_ERR(pmem))
 		return PTR_ERR(pmem);
@@ -222,13 +239,14 @@ static int nd_pmem_remove(struct device *dev)
 
 MODULE_ALIAS("pmem");
 MODULE_ALIAS_ND_DEVICE(ND_DEVICE_NAMESPACE_IO);
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_NAMESPACE_PMEM);
 static struct nd_device_driver nd_pmem_driver = {
 	.probe = nd_pmem_probe,
 	.remove = nd_pmem_remove,
 	.drv = {
 		.name = "nd_pmem",
 	},
-	.type = ND_DRIVER_NAMESPACE_IO,
+	.type = ND_DRIVER_NAMESPACE_IO | ND_DRIVER_NAMESPACE_PMEM,
 };
 
 static int __init pmem_init(void)
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index ade3dba81afd..9aba44e483e0 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -61,8 +61,11 @@ static int child_unregister(struct device *dev, void *data)
 
 static int nd_region_remove(struct device *dev)
 {
+	struct nd_region *nd_region = to_nd_region(dev);
+
 	/* flush attribute readers and disable */
 	nvdimm_bus_lock(dev);
+	nd_region->ns_seed = NULL;
 	dev_set_drvdata(dev, NULL);
 	nvdimm_bus_unlock(dev);
 
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 1571424578f0..b45806f7176d 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/io.h>
+#include <linux/nd.h>
 #include "nd-core.h"
 #include "nd.h"
 
@@ -99,6 +100,58 @@ int nd_region_to_nstype(struct nd_region *nd_region)
 
 	return 0;
 }
+EXPORT_SYMBOL(nd_region_to_nstype);
+
+static int is_uuid_busy(struct device *dev, void *data)
+{
+	struct nd_region *nd_region = to_nd_region(dev->parent);
+	u8 *uuid = data;
+
+	switch (nd_region_to_nstype(nd_region)) {
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
+ * @dev: any device on a nvdimm_bus
+ * @uuid: uuid to check
+ */
+bool nd_is_uuid_unique(struct device *dev, u8 *uuid)
+{
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+
+	if (!nvdimm_bus)
+		return false;
+	WARN_ON_ONCE(!is_nvdimm_bus_locked(&nvdimm_bus->dev));
+	if (device_for_each_child(&nvdimm_bus->dev, uuid,
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
+	WARN_ON(!is_nvdimm_bus_locked(&nd_region->dev));
+
+ retry:
+	available = 0;
+	overlap = blk_max_overlap;
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
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
+	 * memory nvdimm_bus_lock() is dropped, but that's userspace's
+	 * problem to not race itself.
+	 */
+	nvdimm_bus_lock(dev);
+	wait_nvdimm_bus_probe_idle(dev);
+	available = nd_region_available_dpa(nd_region);
+	nvdimm_bus_unlock(dev);
+
+	return sprintf(buf, "%llu\n", available);
+}
+static DEVICE_ATTR_RO(available_size);
+
 static ssize_t init_namespaces_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -168,11 +275,29 @@ static ssize_t init_namespaces_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(init_namespaces);
 
+static ssize_t namespace_seed_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+	ssize_t rc;
+
+	nvdimm_bus_lock(dev);
+	if (nd_region->ns_seed)
+		rc = sprintf(buf, "%s\n", dev_name(nd_region->ns_seed));
+	else
+		rc = sprintf(buf, "\n");
+	nvdimm_bus_unlock(dev);
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
@@ -182,12 +307,18 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 	struct device *dev = container_of(kobj, typeof(*dev), kobj);
 	struct nd_region *nd_region = to_nd_region(dev);
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
+	int type = nd_region_to_nstype(nd_region);
 
-	if (a != &dev_attr_set_cookie.attr)
+	if (a != &dev_attr_set_cookie.attr
+			&& a != &dev_attr_available_size.attr)
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
@@ -198,6 +329,15 @@ struct attribute_group nd_region_attribute_group = {
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
@@ -205,18 +345,20 @@ EXPORT_SYMBOL_GPL(nd_region_attribute_group);
 static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
 		struct device *dev, bool probe)
 {
-	if (is_nd_pmem(dev) || is_nd_blk(dev)) {
+	if (!probe && (is_nd_pmem(dev) || is_nd_blk(dev))) {
 		struct nd_region *nd_region = to_nd_region(dev);
 		int i;
 
 		for (i = 0; i < nd_region->ndr_mappings; i++) {
 			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+			struct nvdimm_drvdata *ndd = nd_mapping->ndd;
 			struct nvdimm *nvdimm = nd_mapping->nvdimm;
 
-			if (probe)
-				atomic_inc(&nvdimm->busy);
-			else
-				atomic_dec(&nvdimm->busy);
+			kfree(nd_mapping->labels);
+			nd_mapping->labels = NULL;
+			put_ndd(ndd);
+			nd_mapping->ndd = NULL;
+			atomic_dec(&nvdimm->busy);
 		}
 	}
 }
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 1b627b109360..c130972e08c4 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -41,10 +41,20 @@ typedef int (*ndctl_fn)(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len);
 
+struct nd_namespace_label;
+struct nvdimm_drvdata;
 struct nd_mapping {
 	struct nvdimm *nvdimm;
+	struct nd_namespace_label **labels;
 	u64 start;
 	u64 size;
+	/*
+	 * @ndd is for private use at region enable / disable time for
+	 * get_ndd() + put_ndd(), all other nd_mapping to ndd
+	 * conversions use to_ndd() which respects enabled state of the
+	 * nvdimm.
+	 */
+	struct nvdimm_drvdata *ndd;
 };
 
 struct nvdimm_bus_descriptor {
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
index 1357a87b8714..2b94ea2287bb 100644
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

