Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v6 07/21] libnvdimm, nfit: regions (block-data-window,
 persistent memory, volatile memory)
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Jun 2015 16:10:47 -0400
Message-ID: <20150611201047.25175.43773.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: mingo@kernel.org, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, axboe@kernel.dk, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

A "region" device represents the maximum capacity of a BLK range (mmio
block-data-window(s)), or a PMEM range (DAX-capable persistent memory or
volatile memory), without regard for aliasing.  Aliasing, in the
dimm-local address space (DPA), is resolved by metadata on a dimm to
designate which exclusive interface will access the aliased DPA ranges.
Support for the per-dimm metadata/label arrvies is in a subsequent
patch.

The name format of "region" devices is "regionN" where, like dimms, N is
a global ida index assigned at discovery time.  This id is not reliable
across reboots nor in the presence of hotplug.  Look to attributes of
the region or static id-data of the sub-namespace to generate a
persistent name.  However, if the platform configuration does not change
it is reasonable to expect the same region id to be assigned at the next
boot.

"region"s have 2 generic attributes "size", and "mapping"s where:
- size: the BLK accessible capacity or the span of the
  system physical address range in the case of PMEM.

- mappingN: a tuple describing a dimm's contribution to the region's
  capacity in the format (<nmemX>,<dpa>,<size>).  For a PMEM-region
  there will be at least one mapping per dimm in the interleave set.  For
  a BLK-region there is only "mapping0" listing the starting DPA of the
  BLK-region and the available DPA capacity of that space (matches "size"
  above).

The max number of mappings per "region" is hard coded per the
constraints of sysfs attribute groups.  That said the number of mappings
per region should never exceed the maximum number of possible dimms in
the system.  If the current number turns out to not be enough then the
"mappings" attribute clarifies how many there are supposed to be. "32
should be enough for anybody...".

Cc: Neil Brown <neilb@suse.de>
Cc: <linux-acpi@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c          |  148 +++++++++++++++++++++
 drivers/nvdimm/Makefile      |    1 
 drivers/nvdimm/nd-core.h     |    3 
 drivers/nvdimm/nd.h          |   11 ++
 drivers/nvdimm/region_devs.c |  297 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h    |   25 ++++
 6 files changed, 484 insertions(+), 1 deletion(-)
 create mode 100644 drivers/nvdimm/region_devs.c

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index fcff81fa1395..38a6bcdcb3da 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -757,11 +757,153 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 			set_bit(i, &nd_desc->dsm_mask);
 }
 
+static ssize_t range_index_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+	struct nfit_spa *nfit_spa = nd_region_provider_data(nd_region);
+
+	return sprintf(buf, "%d\n", nfit_spa->spa->range_index);
+}
+static DEVICE_ATTR_RO(range_index);
+
+static struct attribute *acpi_nfit_region_attributes[] = {
+	&dev_attr_range_index.attr,
+	NULL,
+};
+
+static struct attribute_group acpi_nfit_region_attribute_group = {
+	.name = "nfit",
+	.attrs = acpi_nfit_region_attributes,
+};
+
+static const struct attribute_group *acpi_nfit_region_attribute_groups[] = {
+	&nd_region_attribute_group,
+	&nd_mapping_attribute_group,
+	&acpi_nfit_region_attribute_group,
+	NULL,
+};
+
+static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
+		struct nd_mapping *nd_mapping, struct nd_region_desc *ndr_desc,
+		struct acpi_nfit_memory_map *memdev,
+		struct acpi_nfit_system_address *spa)
+{
+	struct nvdimm *nvdimm = acpi_nfit_dimm_by_handle(acpi_desc,
+			memdev->device_handle);
+	struct nfit_mem *nfit_mem;
+	int blk_valid = 0;
+
+	if (!nvdimm) {
+		dev_err(acpi_desc->dev, "spa%d dimm: %#x not found\n",
+				spa->range_index, memdev->device_handle);
+		return -ENODEV;
+	}
+
+	nd_mapping->nvdimm = nvdimm;
+	switch (nfit_spa_type(spa)) {
+	case NFIT_SPA_PM:
+	case NFIT_SPA_VOLATILE:
+		nd_mapping->start = memdev->address;
+		nd_mapping->size = memdev->region_size;
+		break;
+	case NFIT_SPA_DCR:
+		nfit_mem = nvdimm_provider_data(nvdimm);
+		if (!nfit_mem || !nfit_mem->bdw) {
+			dev_dbg(acpi_desc->dev, "spa%d %s missing bdw\n",
+					spa->range_index, nvdimm_name(nvdimm));
+		} else {
+			nd_mapping->size = nfit_mem->bdw->capacity;
+			nd_mapping->start = nfit_mem->bdw->start_address;
+			blk_valid = 1;
+		}
+
+		ndr_desc->nd_mapping = nd_mapping;
+		ndr_desc->num_mappings = blk_valid;
+		if (!nvdimm_blk_region_create(acpi_desc->nvdimm_bus, ndr_desc))
+			return -ENOMEM;
+		break;
+	}
+
+	return 0;
+}
+
+static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
+		struct nfit_spa *nfit_spa)
+{
+	static struct nd_mapping nd_mappings[ND_MAX_MAPPINGS];
+	struct acpi_nfit_system_address *spa = nfit_spa->spa;
+	struct nfit_memdev *nfit_memdev;
+	struct nd_region_desc ndr_desc;
+	struct nvdimm_bus *nvdimm_bus;
+	struct resource res;
+	int count = 0;
+
+	if (spa->range_index == 0) {
+		dev_dbg(acpi_desc->dev, "%s: detected invalid spa index\n",
+				__func__);
+		return 0;
+	}
+
+	memset(&res, 0, sizeof(res));
+	memset(&nd_mappings, 0, sizeof(nd_mappings));
+	memset(&ndr_desc, 0, sizeof(ndr_desc));
+	res.start = spa->address;
+	res.end = res.start + spa->length - 1;
+	ndr_desc.res = &res;
+	ndr_desc.provider_data = nfit_spa;
+	ndr_desc.attr_groups = acpi_nfit_region_attribute_groups;
+	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
+		struct acpi_nfit_memory_map *memdev = nfit_memdev->memdev;
+		struct nd_mapping *nd_mapping;
+		int rc;
+
+		if (memdev->range_index != spa->range_index)
+			continue;
+		if (count >= ND_MAX_MAPPINGS) {
+			dev_err(acpi_desc->dev, "spa%d exceeds max mappings %d\n",
+					spa->range_index, ND_MAX_MAPPINGS);
+			return -ENXIO;
+		}
+		nd_mapping = &nd_mappings[count++];
+		rc = acpi_nfit_init_mapping(acpi_desc, nd_mapping, &ndr_desc,
+				memdev, spa);
+		if (rc)
+			return rc;
+	}
+
+	ndr_desc.nd_mapping = nd_mappings;
+	ndr_desc.num_mappings = count;
+	nvdimm_bus = acpi_desc->nvdimm_bus;
+	if (nfit_spa_type(spa) == NFIT_SPA_PM) {
+		if (!nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc))
+			return -ENOMEM;
+	} else if (nfit_spa_type(spa) == NFIT_SPA_VOLATILE) {
+		if (!nvdimm_volatile_region_create(nvdimm_bus, &ndr_desc))
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
+{
+	struct nfit_spa *nfit_spa;
+
+	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
+		int rc = acpi_nfit_register_region(acpi_desc, nfit_spa);
+
+		if (rc)
+			return rc;
+	}
+	return 0;
+}
+
 static int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 {
 	struct device *dev = acpi_desc->dev;
 	const void *end;
 	u8 *data;
+	int rc;
 
 	INIT_LIST_HEAD(&acpi_desc->spas);
 	INIT_LIST_HEAD(&acpi_desc->dcrs);
@@ -786,7 +928,11 @@ static int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 
 	acpi_nfit_init_dsms(acpi_desc);
 
-	return acpi_nfit_register_dimms(acpi_desc);
+	rc = acpi_nfit_register_dimms(acpi_desc);
+	if (rc)
+		return rc;
+
+	return acpi_nfit_register_regions(acpi_desc);
 }
 
 static int acpi_nfit_add(struct acpi_device *adev)
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index d44b5c1fcd3b..88afd0d849c3 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -4,3 +4,4 @@ libnvdimm-y := core.o
 libnvdimm-y += bus.o
 libnvdimm-y += dimm_devs.o
 libnvdimm-y += dimm.o
+libnvdimm-y += region_devs.o
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index f2004b790874..1d760bf24857 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -40,5 +40,8 @@ void nvdimm_bus_exit(void);
 int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nd_synchronize(void);
+int nvdimm_bus_register_dimms(struct nvdimm_bus *nvdimm_bus);
+int nvdimm_bus_register_regions(struct nvdimm_bus *nvdimm_bus);
+int nd_match_dimm(struct device *dev, void *data);
 bool is_nvdimm(struct device *dev);
 #endif /* __ND_CORE_H__ */
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 1f7f6ecab0fc..ea0cca337aa6 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -12,6 +12,7 @@
  */
 #ifndef __ND_H__
 #define __ND_H__
+#include <linux/libnvdimm.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/ndctl.h>
@@ -22,6 +23,16 @@ struct nvdimm_drvdata {
 	void *data;
 };
 
+struct nd_region {
+	struct device dev;
+	u16 ndr_mappings;
+	u64 ndr_size;
+	u64 ndr_start;
+	int id;
+	void *provider_data;
+	struct nd_mapping mapping[0];
+};
+
 enum nd_async_mode {
 	ND_SYNC,
 	ND_ASYNC,
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
new file mode 100644
index 000000000000..4bda2e0df8f7
--- /dev/null
+++ b/drivers/nvdimm/region_devs.c
@@ -0,0 +1,297 @@
+/*
+ * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/slab.h>
+#include <linux/io.h>
+#include "nd-core.h"
+#include "nd.h"
+
+static DEFINE_IDA(region_ida);
+
+static void nd_region_release(struct device *dev)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+	u16 i;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+
+		put_device(&nvdimm->dev);
+	}
+	ida_simple_remove(&region_ida, nd_region->id);
+	kfree(nd_region);
+}
+
+static struct device_type nd_blk_device_type = {
+	.name = "nd_blk",
+	.release = nd_region_release,
+};
+
+static struct device_type nd_pmem_device_type = {
+	.name = "nd_pmem",
+	.release = nd_region_release,
+};
+
+static struct device_type nd_volatile_device_type = {
+	.name = "nd_volatile",
+	.release = nd_region_release,
+};
+
+static bool is_nd_pmem(struct device *dev)
+{
+	return dev ? dev->type == &nd_pmem_device_type : false;
+}
+
+struct nd_region *to_nd_region(struct device *dev)
+{
+	struct nd_region *nd_region = container_of(dev, struct nd_region, dev);
+
+	WARN_ON(dev->type->release != nd_region_release);
+	return nd_region;
+}
+EXPORT_SYMBOL_GPL(to_nd_region);
+
+static ssize_t size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+	unsigned long long size = 0;
+
+	if (is_nd_pmem(dev)) {
+		size = nd_region->ndr_size;
+	} else if (nd_region->ndr_mappings == 1) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+
+		size = nd_mapping->size;
+	}
+
+	return sprintf(buf, "%llu\n", size);
+}
+static DEVICE_ATTR_RO(size);
+
+static ssize_t mappings_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+
+	return sprintf(buf, "%d\n", nd_region->ndr_mappings);
+}
+static DEVICE_ATTR_RO(mappings);
+
+static struct attribute *nd_region_attributes[] = {
+	&dev_attr_size.attr,
+	&dev_attr_mappings.attr,
+	NULL,
+};
+
+struct attribute_group nd_region_attribute_group = {
+	.attrs = nd_region_attributes,
+};
+EXPORT_SYMBOL_GPL(nd_region_attribute_group);
+
+static ssize_t mappingN(struct device *dev, char *buf, int n)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+	struct nd_mapping *nd_mapping;
+	struct nvdimm *nvdimm;
+
+	if (n >= nd_region->ndr_mappings)
+		return -ENXIO;
+	nd_mapping = &nd_region->mapping[n];
+	nvdimm = nd_mapping->nvdimm;
+
+	return sprintf(buf, "%s,%llu,%llu\n", dev_name(&nvdimm->dev),
+			nd_mapping->start, nd_mapping->size);
+}
+
+#define REGION_MAPPING(idx) \
+static ssize_t mapping##idx##_show(struct device *dev,		\
+		struct device_attribute *attr, char *buf)	\
+{								\
+	return mappingN(dev, buf, idx);				\
+}								\
+static DEVICE_ATTR_RO(mapping##idx)
+
+/*
+ * 32 should be enough for a while, even in the presence of socket
+ * interleave a 32-way interleave set is a degenerate case.
+ */
+REGION_MAPPING(0);
+REGION_MAPPING(1);
+REGION_MAPPING(2);
+REGION_MAPPING(3);
+REGION_MAPPING(4);
+REGION_MAPPING(5);
+REGION_MAPPING(6);
+REGION_MAPPING(7);
+REGION_MAPPING(8);
+REGION_MAPPING(9);
+REGION_MAPPING(10);
+REGION_MAPPING(11);
+REGION_MAPPING(12);
+REGION_MAPPING(13);
+REGION_MAPPING(14);
+REGION_MAPPING(15);
+REGION_MAPPING(16);
+REGION_MAPPING(17);
+REGION_MAPPING(18);
+REGION_MAPPING(19);
+REGION_MAPPING(20);
+REGION_MAPPING(21);
+REGION_MAPPING(22);
+REGION_MAPPING(23);
+REGION_MAPPING(24);
+REGION_MAPPING(25);
+REGION_MAPPING(26);
+REGION_MAPPING(27);
+REGION_MAPPING(28);
+REGION_MAPPING(29);
+REGION_MAPPING(30);
+REGION_MAPPING(31);
+
+static umode_t mapping_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct nd_region *nd_region = to_nd_region(dev);
+
+	if (n < nd_region->ndr_mappings)
+		return a->mode;
+	return 0;
+}
+
+static struct attribute *mapping_attributes[] = {
+	&dev_attr_mapping0.attr,
+	&dev_attr_mapping1.attr,
+	&dev_attr_mapping2.attr,
+	&dev_attr_mapping3.attr,
+	&dev_attr_mapping4.attr,
+	&dev_attr_mapping5.attr,
+	&dev_attr_mapping6.attr,
+	&dev_attr_mapping7.attr,
+	&dev_attr_mapping8.attr,
+	&dev_attr_mapping9.attr,
+	&dev_attr_mapping10.attr,
+	&dev_attr_mapping11.attr,
+	&dev_attr_mapping12.attr,
+	&dev_attr_mapping13.attr,
+	&dev_attr_mapping14.attr,
+	&dev_attr_mapping15.attr,
+	&dev_attr_mapping16.attr,
+	&dev_attr_mapping17.attr,
+	&dev_attr_mapping18.attr,
+	&dev_attr_mapping19.attr,
+	&dev_attr_mapping20.attr,
+	&dev_attr_mapping21.attr,
+	&dev_attr_mapping22.attr,
+	&dev_attr_mapping23.attr,
+	&dev_attr_mapping24.attr,
+	&dev_attr_mapping25.attr,
+	&dev_attr_mapping26.attr,
+	&dev_attr_mapping27.attr,
+	&dev_attr_mapping28.attr,
+	&dev_attr_mapping29.attr,
+	&dev_attr_mapping30.attr,
+	&dev_attr_mapping31.attr,
+	NULL,
+};
+
+struct attribute_group nd_mapping_attribute_group = {
+	.is_visible = mapping_visible,
+	.attrs = mapping_attributes,
+};
+EXPORT_SYMBOL_GPL(nd_mapping_attribute_group);
+
+void *nd_region_provider_data(struct nd_region *nd_region)
+{
+	return nd_region->provider_data;
+}
+EXPORT_SYMBOL_GPL(nd_region_provider_data);
+
+static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
+		struct nd_region_desc *ndr_desc, struct device_type *dev_type,
+		const char *caller)
+{
+	struct nd_region *nd_region;
+	struct device *dev;
+	u16 i;
+
+	for (i = 0; i < ndr_desc->num_mappings; i++) {
+		struct nd_mapping *nd_mapping = &ndr_desc->nd_mapping[i];
+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+
+		if ((nd_mapping->start | nd_mapping->size) % SZ_4K) {
+			dev_err(&nvdimm_bus->dev, "%s: %s mapping%d is not 4K aligned\n",
+					caller, dev_name(&nvdimm->dev), i);
+
+			return NULL;
+		}
+	}
+
+	nd_region = kzalloc(sizeof(struct nd_region)
+			+ sizeof(struct nd_mapping) * ndr_desc->num_mappings,
+			GFP_KERNEL);
+	if (!nd_region)
+		return NULL;
+	nd_region->id = ida_simple_get(&region_ida, 0, 0, GFP_KERNEL);
+	if (nd_region->id < 0) {
+		kfree(nd_region);
+		return NULL;
+	}
+
+	memcpy(nd_region->mapping, ndr_desc->nd_mapping,
+			sizeof(struct nd_mapping) * ndr_desc->num_mappings);
+	for (i = 0; i < ndr_desc->num_mappings; i++) {
+		struct nd_mapping *nd_mapping = &ndr_desc->nd_mapping[i];
+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+
+		get_device(&nvdimm->dev);
+	}
+	nd_region->ndr_mappings = ndr_desc->num_mappings;
+	nd_region->provider_data = ndr_desc->provider_data;
+	dev = &nd_region->dev;
+	dev_set_name(dev, "region%d", nd_region->id);
+	dev->parent = &nvdimm_bus->dev;
+	dev->type = dev_type;
+	dev->groups = ndr_desc->attr_groups;
+	nd_region->ndr_size = resource_size(ndr_desc->res);
+	nd_region->ndr_start = ndr_desc->res->start;
+	nd_device_register(dev);
+
+	return nd_region;
+}
+
+struct nd_region *nvdimm_pmem_region_create(struct nvdimm_bus *nvdimm_bus,
+		struct nd_region_desc *ndr_desc)
+{
+	return nd_region_create(nvdimm_bus, ndr_desc, &nd_pmem_device_type,
+			__func__);
+}
+EXPORT_SYMBOL_GPL(nvdimm_pmem_region_create);
+
+struct nd_region *nvdimm_blk_region_create(struct nvdimm_bus *nvdimm_bus,
+		struct nd_region_desc *ndr_desc)
+{
+	if (ndr_desc->num_mappings > 1)
+		return NULL;
+	return nd_region_create(nvdimm_bus, ndr_desc, &nd_blk_device_type,
+			__func__);
+}
+EXPORT_SYMBOL_GPL(nvdimm_blk_region_create);
+
+struct nd_region *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
+		struct nd_region_desc *ndr_desc)
+{
+	return nd_region_create(nvdimm_bus, ndr_desc, &nd_volatile_device_type,
+			__func__);
+}
+EXPORT_SYMBOL_GPL(nvdimm_volatile_region_create);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index d3ebccf4ea8b..39e7e606092a 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -26,11 +26,14 @@ enum {
 	ND_CMD_MAX_ELEM = 4,
 	ND_CMD_MAX_ENVELOPE = 16,
 	ND_CMD_ARS_STATUS_MAX = SZ_4K,
+	ND_MAX_MAPPINGS = 32,
 };
 
 extern struct attribute_group nvdimm_bus_attribute_group;
 extern struct attribute_group nvdimm_attribute_group;
 extern struct attribute_group nd_device_attribute_group;
+extern struct attribute_group nd_region_attribute_group;
+extern struct attribute_group nd_mapping_attribute_group;
 
 struct nvdimm;
 struct nvdimm_bus_descriptor;
@@ -38,6 +41,12 @@ typedef int (*ndctl_fn)(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len);
 
+struct nd_mapping {
+	struct nvdimm *nvdimm;
+	u64 start;
+	u64 size;
+};
+
 struct nvdimm_bus_descriptor {
 	const struct attribute_group **attr_groups;
 	unsigned long dsm_mask;
@@ -52,6 +61,14 @@ struct nd_cmd_desc {
 	int out_sizes[ND_CMD_MAX_ELEM];
 };
 
+struct nd_region_desc {
+	struct resource *res;
+	struct nd_mapping *nd_mapping;
+	u16 num_mappings;
+	const struct attribute_group **attr_groups;
+	void *provider_data;
+};
+
 struct nvdimm_bus;
 struct device;
 struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
@@ -59,9 +76,11 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus);
 struct nvdimm_bus *to_nvdimm_bus(struct device *dev);
 struct nvdimm *to_nvdimm(struct device *dev);
+struct nd_region *to_nd_region(struct device *dev);
 struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus);
 const char *nvdimm_name(struct nvdimm *nvdimm);
 void *nvdimm_provider_data(struct nvdimm *nvdimm);
+void *nd_region_provider_data(struct nd_region *nd_region);
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
 		unsigned long *dsm_mask);
@@ -73,4 +92,10 @@ u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
 		const struct nd_cmd_desc *desc, int idx, const u32 *in_field,
 		const u32 *out_field);
 int nvdimm_bus_check_dimm_count(struct nvdimm_bus *nvdimm_bus, int dimm_count);
+struct nd_region *nvdimm_pmem_region_create(struct nvdimm_bus *nvdimm_bus,
+		struct nd_region_desc *ndr_desc);
+struct nd_region *nvdimm_blk_region_create(struct nvdimm_bus *nvdimm_bus,
+		struct nd_region_desc *ndr_desc);
+struct nd_region *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
+		struct nd_region_desc *ndr_desc);
 #endif /* __LIBNVDIMM_H__ */

