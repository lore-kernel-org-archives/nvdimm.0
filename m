Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v7 08/16] libnvdimm: support for legacy (non-aliasing)
 nvdimms
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:14:03 -0400
Message-ID: <20150617231403.11597.54960.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The libnvdimm region driver is an intermediary driver that translates
non-volatile "region"s into "namespace" sub-devices that are surfaced by
persistent memory block-device drivers (PMEM and BLK).

ACPI 6 introduces the concept that a given nvdimm may simultaneously
offer multiple access modes to its media through direct PMEM load/store
access, or windowed BLK mode.  Existing nvdimms mostly implement a PMEM
interface, some offer a BLK-like mode, but never both as ACPI 6 defines.
If an nvdimm is single interfaced, then there is no need for dimm
metadata labels.  For these devices we can take the region boundaries
directly to create a child namespace device (nd_namespace_io).

Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c             |    1 
 drivers/nvdimm/Makefile         |    2 +
 drivers/nvdimm/bus.c            |   26 +++++++++
 drivers/nvdimm/core.c           |   44 ++++++++++++++-
 drivers/nvdimm/dimm.c           |    2 -
 drivers/nvdimm/namespace_devs.c |  111 +++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h        |    6 ++
 drivers/nvdimm/nd.h             |   13 +++++
 drivers/nvdimm/region.c         |   93 +++++++++++++++++++++++++++++++++
 drivers/nvdimm/region_devs.c    |   66 +++++++++++++++++++++++
 include/linux/libnvdimm.h       |    7 ++
 include/linux/nd.h              |   10 ++++
 include/uapi/linux/ndctl.h      |   10 ++++
 13 files changed, 383 insertions(+), 8 deletions(-)
 create mode 100644 drivers/nvdimm/namespace_devs.c
 create mode 100644 drivers/nvdimm/region.c

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 068f69d70c9e..ce290748fe36 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -780,6 +780,7 @@ static struct attribute_group acpi_nfit_region_attribute_group = {
 static const struct attribute_group *acpi_nfit_region_attribute_groups[] = {
 	&nd_region_attribute_group,
 	&nd_mapping_attribute_group,
+	&nd_device_attribute_group,
 	&acpi_nfit_region_attribute_group,
 	NULL,
 };
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index 88afd0d849c3..af5e2760ddbd 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -5,3 +5,5 @@ libnvdimm-y += bus.o
 libnvdimm-y += dimm_devs.o
 libnvdimm-y += dimm.o
 libnvdimm-y += region_devs.o
+libnvdimm-y += region.o
+libnvdimm-y += namespace_devs.o
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index a0308f1872bf..4b77665a6cc8 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -13,6 +13,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
+#include <linux/module.h>
 #include <linux/fcntl.h>
 #include <linux/async.h>
 #include <linux/ndctl.h>
@@ -33,6 +34,12 @@ static int to_nd_device_type(struct device *dev)
 {
 	if (is_nvdimm(dev))
 		return ND_DEVICE_DIMM;
+	else if (is_nd_pmem(dev))
+		return ND_DEVICE_REGION_PMEM;
+	else if (is_nd_blk(dev))
+		return ND_DEVICE_REGION_BLK;
+	else if (is_nd_pmem(dev->parent) || is_nd_blk(dev->parent))
+		return nd_region_to_nstype(to_nd_region(dev->parent));
 
 	return 0;
 }
@@ -50,27 +57,46 @@ static int nvdimm_bus_match(struct device *dev, struct device_driver *drv)
 	return test_bit(to_nd_device_type(dev), &nd_drv->type);
 }
 
+static struct module *to_bus_provider(struct device *dev)
+{
+	/* pin bus providers while regions are enabled */
+	if (is_nd_pmem(dev) || is_nd_blk(dev)) {
+		struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+
+		return nvdimm_bus->module;
+	}
+	return NULL;
+}
+
 static int nvdimm_bus_probe(struct device *dev)
 {
 	struct nd_device_driver *nd_drv = to_nd_device_driver(dev->driver);
+	struct module *provider = to_bus_provider(dev);
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 	int rc;
 
+	if (!try_module_get(provider))
+		return -ENXIO;
+
 	rc = nd_drv->probe(dev);
 	dev_dbg(&nvdimm_bus->dev, "%s.probe(%s) = %d\n", dev->driver->name,
 			dev_name(dev), rc);
+	if (rc != 0)
+		module_put(provider);
 	return rc;
 }
 
 static int nvdimm_bus_remove(struct device *dev)
 {
 	struct nd_device_driver *nd_drv = to_nd_device_driver(dev->driver);
+	struct module *provider = to_bus_provider(dev);
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 	int rc;
 
 	rc = nd_drv->remove(dev);
 	dev_dbg(&nvdimm_bus->dev, "%s.remove(%s) = %d\n", dev->driver->name,
 			dev_name(dev), rc);
+	module_put(provider);
 	return rc;
 }
 
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 50ab880f0dc0..1b6b15d11f54 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -24,6 +24,36 @@ LIST_HEAD(nvdimm_bus_list);
 DEFINE_MUTEX(nvdimm_bus_list_mutex);
 static DEFINE_IDA(nd_ida);
 
+void nvdimm_bus_lock(struct device *dev)
+{
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+
+	if (!nvdimm_bus)
+		return;
+	mutex_lock(&nvdimm_bus->reconfig_mutex);
+}
+EXPORT_SYMBOL(nvdimm_bus_lock);
+
+void nvdimm_bus_unlock(struct device *dev)
+{
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+
+	if (!nvdimm_bus)
+		return;
+	mutex_unlock(&nvdimm_bus->reconfig_mutex);
+}
+EXPORT_SYMBOL(nvdimm_bus_unlock);
+
+bool is_nvdimm_bus_locked(struct device *dev)
+{
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+
+	if (!nvdimm_bus)
+		return false;
+	return mutex_is_locked(&nvdimm_bus->reconfig_mutex);
+}
+EXPORT_SYMBOL(is_nvdimm_bus_locked);
+
 static void nvdimm_bus_release(struct device *dev)
 {
 	struct nvdimm_bus *nvdimm_bus;
@@ -135,8 +165,8 @@ struct attribute_group nvdimm_bus_attribute_group = {
 };
 EXPORT_SYMBOL_GPL(nvdimm_bus_attribute_group);
 
-struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
-		struct nvdimm_bus_descriptor *nd_desc)
+struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
+		struct nvdimm_bus_descriptor *nd_desc, struct module *module)
 {
 	struct nvdimm_bus *nvdimm_bus;
 	int rc;
@@ -146,11 +176,13 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 		return NULL;
 	INIT_LIST_HEAD(&nvdimm_bus->list);
 	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
+	mutex_init(&nvdimm_bus->reconfig_mutex);
 	if (nvdimm_bus->id < 0) {
 		kfree(nvdimm_bus);
 		return NULL;
 	}
 	nvdimm_bus->nd_desc = nd_desc;
+	nvdimm_bus->module = module;
 	nvdimm_bus->dev.parent = parent;
 	nvdimm_bus->dev.release = nvdimm_bus_release;
 	nvdimm_bus->dev.groups = nd_desc->attr_groups;
@@ -174,7 +206,7 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 	put_device(&nvdimm_bus->dev);
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(nvdimm_bus_register);
+EXPORT_SYMBOL_GPL(__nvdimm_bus_register);
 
 static int child_unregister(struct device *dev, void *data)
 {
@@ -218,7 +250,12 @@ static __init int libnvdimm_init(void)
 	rc = nvdimm_init();
 	if (rc)
 		goto err_dimm;
+	rc = nd_region_init();
+	if (rc)
+		goto err_region;
 	return 0;
+ err_region:
+	nvdimm_exit();
  err_dimm:
 	nvdimm_bus_exit();
 	return rc;
@@ -227,6 +264,7 @@ static __init int libnvdimm_init(void)
 static __exit void libnvdimm_exit(void)
 {
 	WARN_ON(!list_empty(&nvdimm_bus_list));
+	nd_region_exit();
 	nvdimm_exit();
 	nvdimm_bus_exit();
 }
diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index 28001a6ccd4e..eb20fc2df32b 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -84,7 +84,7 @@ int __init nvdimm_init(void)
 	return nd_driver_register(&nvdimm_driver);
 }
 
-void __exit nvdimm_exit(void)
+void nvdimm_exit(void)
 {
 	driver_unregister(&nvdimm_driver.drv);
 }
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
new file mode 100644
index 000000000000..4f653d1e61ad
--- /dev/null
+++ b/drivers/nvdimm/namespace_devs.c
@@ -0,0 +1,111 @@
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
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/nd.h>
+#include "nd.h"
+
+static void namespace_io_release(struct device *dev)
+{
+	struct nd_namespace_io *nsio = to_nd_namespace_io(dev);
+
+	kfree(nsio);
+}
+
+static struct device_type namespace_io_device_type = {
+	.name = "nd_namespace_io",
+	.release = namespace_io_release,
+};
+
+static ssize_t nstype_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev->parent);
+
+	return sprintf(buf, "%d\n", nd_region_to_nstype(nd_region));
+}
+static DEVICE_ATTR_RO(nstype);
+
+static struct attribute *nd_namespace_attributes[] = {
+	&dev_attr_nstype.attr,
+	NULL,
+};
+
+static struct attribute_group nd_namespace_attribute_group = {
+	.attrs = nd_namespace_attributes,
+};
+
+static const struct attribute_group *nd_namespace_attribute_groups[] = {
+	&nd_device_attribute_group,
+	&nd_namespace_attribute_group,
+	NULL,
+};
+
+static struct device **create_namespace_io(struct nd_region *nd_region)
+{
+	struct nd_namespace_io *nsio;
+	struct device *dev, **devs;
+	struct resource *res;
+
+	nsio = kzalloc(sizeof(*nsio), GFP_KERNEL);
+	if (!nsio)
+		return NULL;
+
+	devs = kcalloc(2, sizeof(struct device *), GFP_KERNEL);
+	if (!devs) {
+		kfree(nsio);
+		return NULL;
+	}
+
+	dev = &nsio->dev;
+	dev->type = &namespace_io_device_type;
+	dev->parent = &nd_region->dev;
+	res = &nsio->res;
+	res->name = dev_name(&nd_region->dev);
+	res->flags = IORESOURCE_MEM;
+	res->start = nd_region->ndr_start;
+	res->end = res->start + nd_region->ndr_size - 1;
+
+	devs[0] = dev;
+	return devs;
+}
+
+int nd_region_register_namespaces(struct nd_region *nd_region, int *err)
+{
+	struct device **devs = NULL;
+	int i;
+
+	*err = 0;
+	switch (nd_region_to_nstype(nd_region)) {
+	case ND_DEVICE_NAMESPACE_IO:
+		devs = create_namespace_io(nd_region);
+		break;
+	default:
+		break;
+	}
+
+	if (!devs)
+		return -ENODEV;
+
+	for (i = 0; devs[i]; i++) {
+		struct device *dev = devs[i];
+
+		dev_set_name(dev, "namespace%d.%d", nd_region->id, i);
+		dev->groups = nd_namespace_attribute_groups;
+		nd_device_register(dev);
+	}
+	kfree(devs);
+
+	return i;
+}
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 1d760bf24857..0e9b41fd2546 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -21,9 +21,11 @@ extern int nvdimm_major;
 
 struct nvdimm_bus {
 	struct nvdimm_bus_descriptor *nd_desc;
+	struct module *module;
 	struct list_head list;
 	struct device dev;
 	int id;
+	struct mutex reconfig_mutex;
 };
 
 struct nvdimm {
@@ -34,6 +36,9 @@ struct nvdimm {
 	int id;
 };
 
+bool is_nvdimm(struct device *dev);
+bool is_nd_blk(struct device *dev);
+bool is_nd_pmem(struct device *dev);
 struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev);
 int __init nvdimm_bus_init(void);
 void nvdimm_bus_exit(void);
@@ -43,5 +48,4 @@ void nd_synchronize(void);
 int nvdimm_bus_register_dimms(struct nvdimm_bus *nvdimm_bus);
 int nvdimm_bus_register_regions(struct nvdimm_bus *nvdimm_bus);
 int nd_match_dimm(struct device *dev, void *data);
-bool is_nvdimm(struct device *dev);
 #endif /* __ND_CORE_H__ */
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index ea0cca337aa6..bc5a08e36a25 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -23,6 +23,11 @@ struct nvdimm_drvdata {
 	void *data;
 };
 
+struct nd_region_namespaces {
+	int count;
+	int active;
+};
+
 struct nd_region {
 	struct device dev;
 	u16 ndr_mappings;
@@ -41,7 +46,15 @@ enum nd_async_mode {
 void nd_device_register(struct device *dev);
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode);
 int __init nvdimm_init(void);
+int __init nd_region_init(void);
 void nvdimm_exit(void);
+void nd_region_exit(void);
 int nvdimm_init_nsarea(struct nvdimm_drvdata *ndd);
 int nvdimm_init_config_data(struct nvdimm_drvdata *ndd);
+struct nd_region *to_nd_region(struct device *dev);
+int nd_region_to_nstype(struct nd_region *nd_region);
+int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
+void nvdimm_bus_lock(struct device *dev);
+void nvdimm_bus_unlock(struct device *dev);
+bool is_nvdimm_bus_locked(struct device *dev);
 #endif /* __ND_H__ */
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
new file mode 100644
index 000000000000..ade3dba81afd
--- /dev/null
+++ b/drivers/nvdimm/region.c
@@ -0,0 +1,93 @@
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
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/nd.h>
+#include "nd.h"
+
+static int nd_region_probe(struct device *dev)
+{
+	int err;
+	struct nd_region_namespaces *num_ns;
+	struct nd_region *nd_region = to_nd_region(dev);
+	int rc = nd_region_register_namespaces(nd_region, &err);
+
+	num_ns = devm_kzalloc(dev, sizeof(*num_ns), GFP_KERNEL);
+	if (!num_ns)
+		return -ENOMEM;
+
+	if (rc < 0)
+		return rc;
+
+	num_ns->active = rc;
+	num_ns->count = rc + err;
+	dev_set_drvdata(dev, num_ns);
+
+	if (err == 0)
+		return 0;
+
+	if (rc == err)
+		return -ENODEV;
+
+	/*
+	 * Given multiple namespaces per region, we do not want to
+	 * disable all the successfully registered peer namespaces upon
+	 * a single registration failure.  If userspace is missing a
+	 * namespace that it expects it can disable/re-enable the region
+	 * to retry discovery after correcting the failure.
+	 * <regionX>/namespaces returns the current
+	 * "<async-registered>/<total>" namespace count.
+	 */
+	dev_err(dev, "failed to register %d namespace%s, continuing...\n",
+			err, err == 1 ? "" : "s");
+	return 0;
+}
+
+static int child_unregister(struct device *dev, void *data)
+{
+	nd_device_unregister(dev, ND_SYNC);
+	return 0;
+}
+
+static int nd_region_remove(struct device *dev)
+{
+	/* flush attribute readers and disable */
+	nvdimm_bus_lock(dev);
+	dev_set_drvdata(dev, NULL);
+	nvdimm_bus_unlock(dev);
+
+	device_for_each_child(dev, NULL, child_unregister);
+	return 0;
+}
+
+static struct nd_device_driver nd_region_driver = {
+	.probe = nd_region_probe,
+	.remove = nd_region_remove,
+	.drv = {
+		.name = "nd_region",
+	},
+	.type = ND_DRIVER_REGION_BLK | ND_DRIVER_REGION_PMEM,
+};
+
+int __init nd_region_init(void)
+{
+	return nd_driver_register(&nd_region_driver);
+}
+
+void nd_region_exit(void)
+{
+	driver_unregister(&nd_region_driver.drv);
+}
+
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_REGION_PMEM);
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_REGION_BLK);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 4bda2e0df8f7..b5c5b9095b28 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -47,11 +47,16 @@ static struct device_type nd_volatile_device_type = {
 	.release = nd_region_release,
 };
 
-static bool is_nd_pmem(struct device *dev)
+bool is_nd_pmem(struct device *dev)
 {
 	return dev ? dev->type == &nd_pmem_device_type : false;
 }
 
+bool is_nd_blk(struct device *dev)
+{
+	return dev ? dev->type == &nd_blk_device_type : false;
+}
+
 struct nd_region *to_nd_region(struct device *dev)
 {
 	struct nd_region *nd_region = container_of(dev, struct nd_region, dev);
@@ -61,6 +66,37 @@ struct nd_region *to_nd_region(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(to_nd_region);
 
+/**
+ * nd_region_to_nstype() - region to an integer namespace type
+ * @nd_region: region-device to interrogate
+ *
+ * This is the 'nstype' attribute of a region as well, an input to the
+ * MODALIAS for namespace devices, and bit number for a nvdimm_bus to match
+ * namespace devices with namespace drivers.
+ */
+int nd_region_to_nstype(struct nd_region *nd_region)
+{
+	if (is_nd_pmem(&nd_region->dev)) {
+		u16 i, alias;
+
+		for (i = 0, alias = 0; i < nd_region->ndr_mappings; i++) {
+			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+			struct nvdimm *nvdimm = nd_mapping->nvdimm;
+
+			if (nvdimm->flags & NDD_ALIASING)
+				alias++;
+		}
+		if (alias)
+			return ND_DEVICE_NAMESPACE_PMEM;
+		else
+			return ND_DEVICE_NAMESPACE_IO;
+	} else if (is_nd_blk(&nd_region->dev)) {
+		return ND_DEVICE_NAMESPACE_BLK;
+	}
+
+	return 0;
+}
+
 static ssize_t size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -88,9 +124,37 @@ static ssize_t mappings_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(mappings);
 
+static ssize_t nstype_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+
+	return sprintf(buf, "%d\n", nd_region_to_nstype(nd_region));
+}
+static DEVICE_ATTR_RO(nstype);
+
+static ssize_t init_namespaces_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region_namespaces *num_ns = dev_get_drvdata(dev);
+	ssize_t rc;
+
+	nvdimm_bus_lock(dev);
+	if (num_ns)
+		rc = sprintf(buf, "%d/%d\n", num_ns->active, num_ns->count);
+	else
+		rc = -ENXIO;
+	nvdimm_bus_unlock(dev);
+
+	return rc;
+}
+static DEVICE_ATTR_RO(init_namespaces);
+
 static struct attribute *nd_region_attributes[] = {
 	&dev_attr_size.attr,
+	&dev_attr_nstype.attr,
 	&dev_attr_mappings.attr,
+	&dev_attr_init_namespaces.attr,
 	NULL,
 };
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 39e7e606092a..37f966aff386 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -71,8 +71,11 @@ struct nd_region_desc {
 
 struct nvdimm_bus;
 struct device;
-struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
-		struct nvdimm_bus_descriptor *nfit_desc);
+struct module;
+struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
+		struct nvdimm_bus_descriptor *nfit_desc, struct module *module);
+#define nvdimm_bus_register(parent, desc) \
+	__nvdimm_bus_register(parent, desc, THIS_MODULE)
 void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus);
 struct nvdimm_bus *to_nvdimm_bus(struct device *dev);
 struct nvdimm *to_nvdimm(struct device *dev);
diff --git a/include/linux/nd.h b/include/linux/nd.h
index e074f67e53a3..da70e9962197 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -26,6 +26,16 @@ static inline struct nd_device_driver *to_nd_device_driver(
 		struct device_driver *drv)
 {
 	return container_of(drv, struct nd_device_driver, drv);
+};
+
+struct nd_namespace_io {
+	struct device dev;
+	struct resource res;
+};
+
+static inline struct nd_namespace_io *to_nd_namespace_io(struct device *dev)
+{
+	return container_of(dev, struct nd_namespace_io, dev);
 }
 
 #define MODULE_ALIAS_ND_DEVICE(type) \
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 37640916d146..174b6371dcc1 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -177,8 +177,18 @@ static inline const char *nvdimm_cmd_name(unsigned cmd)
 
 
 #define ND_DEVICE_DIMM 1            /* nd_dimm: container for "config data" */
+#define ND_DEVICE_REGION_PMEM 2     /* nd_region: (parent of PMEM namespaces) */
+#define ND_DEVICE_REGION_BLK 3      /* nd_region: (parent of BLK namespaces) */
+#define ND_DEVICE_NAMESPACE_IO 4    /* legacy persistent memory */
+#define ND_DEVICE_NAMESPACE_PMEM 5  /* PMEM namespace (may alias with BLK) */
+#define ND_DEVICE_NAMESPACE_BLK 6   /* BLK namespace (may alias with PMEM) */
 
 enum nd_driver_flags {
 	ND_DRIVER_DIMM            = 1 << ND_DEVICE_DIMM,
+	ND_DRIVER_REGION_PMEM     = 1 << ND_DEVICE_REGION_PMEM,
+	ND_DRIVER_REGION_BLK      = 1 << ND_DEVICE_REGION_BLK,
+	ND_DRIVER_NAMESPACE_IO    = 1 << ND_DEVICE_NAMESPACE_IO,
+	ND_DRIVER_NAMESPACE_PMEM  = 1 << ND_DEVICE_NAMESPACE_PMEM,
+	ND_DRIVER_NAMESPACE_BLK   = 1 << ND_DEVICE_NAMESPACE_BLK,
 };
 #endif /* __NDCTL_H__ */

