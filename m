Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 09/20] libnd: support for legacy (non-aliasing) nvdimms
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Apr 2015 14:25:01 -0400
Message-ID: <20150428182501.35812.30017.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The libnd region driver is an intermediary driver that translates
non-volatile "region"s into "namespace" sub-devices that are surfaced by
persistent memory block-device drivers (PMEM and BLK).

ACPI 6 introduces the concept that a given nvdimm may offer multiple
access modes to its media through either direct PMEM load/store access,
or windowed BLK mode.  Existing nvdimms mostly implement a PMEM
interface, some offer a BLK-like mode, but never both.  If an nvdimm is
single interfaced, then there is no need for dimm metadata labels.  For
these devices we can take the region boundaries directly to create a
child namespace device (nd_namespace_io).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/Makefile         |    2 +
 drivers/block/nd/acpi.c           |    1 
 drivers/block/nd/bus.c            |   26 +++++++++
 drivers/block/nd/core.c           |   13 +++-
 drivers/block/nd/dimm.c           |    2 -
 drivers/block/nd/libnd.h          |    6 +-
 drivers/block/nd/namespace_devs.c |  111 +++++++++++++++++++++++++++++++++++++
 drivers/block/nd/nd-private.h     |    9 ++-
 drivers/block/nd/nd.h             |    8 +++
 drivers/block/nd/region.c         |   88 +++++++++++++++++++++++++++++
 drivers/block/nd/region_devs.c    |   61 ++++++++++++++++++++
 include/linux/nd.h                |   10 +++
 include/uapi/linux/ndctl.h        |   10 +++
 13 files changed, 338 insertions(+), 9 deletions(-)
 create mode 100644 drivers/block/nd/namespace_devs.c
 create mode 100644 drivers/block/nd/region.c

diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
index 6010469c4d4c..0fb0891e1817 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -23,3 +23,5 @@ libnd-y += bus.o
 libnd-y += dimm_devs.o
 libnd-y += dimm.o
 libnd-y += region_devs.o
+libnd-y += region.o
+libnd-y += namespace_devs.o
diff --git a/drivers/block/nd/acpi.c b/drivers/block/nd/acpi.c
index 41d0bb732b3e..c3dda74f73d7 100644
--- a/drivers/block/nd/acpi.c
+++ b/drivers/block/nd/acpi.c
@@ -774,6 +774,7 @@ static struct attribute_group nd_acpi_region_attribute_group = {
 static const struct attribute_group *nd_acpi_region_attribute_groups[] = {
 	&nd_region_attribute_group,
 	&nd_mapping_attribute_group,
+	&nd_device_attribute_group,
 	&nd_acpi_region_attribute_group,
 	NULL,
 };
diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
index 7bd79f30e5e7..46568d182559 100644
--- a/drivers/block/nd/bus.c
+++ b/drivers/block/nd/bus.c
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
 	if (is_nd_dimm(dev))
 		return ND_DEVICE_DIMM;
+	else if (is_nd_pmem(dev))
+		return ND_DEVICE_REGION_PMEM;
+	else if (is_nd_blk(dev))
+		return ND_DEVICE_REGION_BLK;
+	else if (is_nd_pmem(dev->parent) || is_nd_blk(dev->parent))
+		return nd_region_to_namespace_type(to_nd_region(dev->parent));
 
 	return 0;
 }
@@ -50,27 +57,46 @@ static int nd_bus_match(struct device *dev, struct device_driver *drv)
 	return test_bit(to_nd_device_type(dev), &nd_drv->type);
 }
 
+static struct module *to_bus_provider(struct device *dev)
+{
+	/* pin bus providers while regions are enabled */
+	if (is_nd_pmem(dev) || is_nd_blk(dev)) {
+		struct nd_bus *nd_bus = walk_to_nd_bus(dev);
+
+		return nd_bus->module;
+	}
+	return NULL;
+}
+
 static int nd_bus_probe(struct device *dev)
 {
 	struct nd_device_driver *nd_drv = to_nd_device_driver(dev->driver);
+	struct module *provider = to_bus_provider(dev);
 	struct nd_bus *nd_bus = walk_to_nd_bus(dev);
 	int rc;
 
+	if (!try_module_get(provider))
+		return -ENXIO;
+
 	rc = nd_drv->probe(dev);
 	dev_dbg(&nd_bus->dev, "%s.probe(%s) = %d\n", dev->driver->name,
 			dev_name(dev), rc);
+	if (rc != 0)
+		module_put(provider);
 	return rc;
 }
 
 static int nd_bus_remove(struct device *dev)
 {
 	struct nd_device_driver *nd_drv = to_nd_device_driver(dev->driver);
+	struct module *provider = to_bus_provider(dev);
 	struct nd_bus *nd_bus = walk_to_nd_bus(dev);
 	int rc;
 
 	rc = nd_drv->remove(dev);
 	dev_dbg(&nd_bus->dev, "%s.remove(%s) = %d\n", dev->driver->name,
 			dev_name(dev), rc);
+	module_put(provider);
 	return rc;
 }
 
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
index d8d1c9cb3f16..646e424ae36c 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -133,8 +133,8 @@ struct attribute_group nd_bus_attribute_group = {
 };
 EXPORT_SYMBOL_GPL(nd_bus_attribute_group);
 
-struct nd_bus *nd_bus_register(struct device *parent,
-		struct nd_bus_descriptor *nd_desc)
+struct nd_bus *__nd_bus_register(struct device *parent,
+		struct nd_bus_descriptor *nd_desc, struct module *module)
 {
 	struct nd_bus *nd_bus = kzalloc(sizeof(*nd_bus), GFP_KERNEL);
 	int rc;
@@ -148,6 +148,7 @@ struct nd_bus *nd_bus_register(struct device *parent,
 		return NULL;
 	}
 	nd_bus->nd_desc = nd_desc;
+	nd_bus->module = module;
 	nd_bus->dev.parent = parent;
 	nd_bus->dev.release = nd_bus_release;
 	nd_bus->dev.groups = nd_desc->attr_groups;
@@ -171,7 +172,7 @@ struct nd_bus *nd_bus_register(struct device *parent,
 	put_device(&nd_bus->dev);
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(nd_bus_register);
+EXPORT_SYMBOL_GPL(__nd_bus_register);
 
 static int child_unregister(struct device *dev, void *data)
 {
@@ -215,7 +216,12 @@ static __init int libnd_init(void)
 	rc = nd_dimm_init();
 	if (rc)
 		goto err_dimm;
+	rc = nd_region_init();
+	if (rc)
+		goto err_region;
 	return 0;
+ err_region:
+	nd_dimm_exit();
  err_dimm:
 	nd_bus_exit();
 	return rc;
@@ -224,6 +230,7 @@ static __init int libnd_init(void)
 static __exit void libnd_exit(void)
 {
 	WARN_ON(!list_empty(&nd_bus_list));
+	nd_region_exit();
 	nd_dimm_exit();
 	nd_bus_exit();
 }
diff --git a/drivers/block/nd/dimm.c b/drivers/block/nd/dimm.c
index a4c8e3ffe97c..6b7d2842509c 100644
--- a/drivers/block/nd/dimm.c
+++ b/drivers/block/nd/dimm.c
@@ -85,7 +85,7 @@ int __init nd_dimm_init(void)
 	return nd_driver_register(&nd_dimm_driver);
 }
 
-void __exit nd_dimm_exit(void)
+void nd_dimm_exit(void)
 {
 	driver_unregister(&nd_dimm_driver.drv);
 }
diff --git a/drivers/block/nd/libnd.h b/drivers/block/nd/libnd.h
index 630a703d1316..8c6f07696f30 100644
--- a/drivers/block/nd/libnd.h
+++ b/drivers/block/nd/libnd.h
@@ -69,8 +69,10 @@ struct nd_region_desc {
 };
 
 struct nd_bus;
-struct nd_bus *nd_bus_register(struct device *parent,
-		struct nd_bus_descriptor *nfit_desc);
+struct nd_bus *__nd_bus_register(struct device *parent,
+		struct nd_bus_descriptor *nfit_desc, struct module *module);
+#define nd_bus_register(parent, desc) \
+	__nd_bus_register(parent, desc, THIS_MODULE)
 void nd_bus_unregister(struct nd_bus *nd_bus);
 struct nd_bus *to_nd_bus(struct device *dev);
 struct nd_dimm *to_nd_dimm(struct device *dev);
diff --git a/drivers/block/nd/namespace_devs.c b/drivers/block/nd/namespace_devs.c
new file mode 100644
index 000000000000..6861327f4245
--- /dev/null
+++ b/drivers/block/nd/namespace_devs.c
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
+static ssize_t type_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev->parent);
+
+	return sprintf(buf, "%d\n", nd_region_to_namespace_type(nd_region));
+}
+static DEVICE_ATTR_RO(type);
+
+static struct attribute *nd_namespace_attributes[] = {
+	&dev_attr_type.attr,
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
+	switch (nd_region_to_namespace_type(nd_region)) {
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
+		dev->parent = &nd_region->dev;
+		dev->groups = nd_namespace_attribute_groups;
+		nd_device_register(dev);
+	}
+	kfree(devs);
+
+	return i;
+}
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index 838b6f958c00..131fc66ce7ab 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -21,6 +21,7 @@ extern int nd_dimm_major;
 
 struct nd_bus {
 	struct nd_bus_descriptor *nd_desc;
+	struct module *module;
 	struct list_head list;
 	struct device dev;
 	int id;
@@ -34,16 +35,20 @@ struct nd_dimm {
 	int id;
 };
 
+bool is_nd_dimm(struct device *dev);
+bool is_nd_blk(struct device *dev);
+bool is_nd_pmem(struct device *dev);
 struct nd_bus *walk_to_nd_bus(struct device *nd_dev);
 int __init nd_bus_init(void);
 void nd_bus_exit(void);
 int __init nd_dimm_init(void);
-void __exit nd_dimm_exit(void);
+int __init nd_region_init(void);
+void nd_dimm_exit(void);
+int nd_region_exit(void);
 int nd_bus_create_ndctl(struct nd_bus *nd_bus);
 void nd_bus_destroy_ndctl(struct nd_bus *nd_bus);
 void nd_synchronize(void);
 int nd_bus_register_dimms(struct nd_bus *nd_bus);
 int nd_bus_register_regions(struct nd_bus *nd_bus);
 int nd_match_dimm(struct device *dev, void *data);
-bool is_nd_dimm(struct device *dev);
 #endif /* __ND_PRIVATE_H__ */
diff --git a/drivers/block/nd/nd.h b/drivers/block/nd/nd.h
index cae83de12c45..23469513f4c0 100644
--- a/drivers/block/nd/nd.h
+++ b/drivers/block/nd/nd.h
@@ -23,6 +23,11 @@ struct nd_dimm_drvdata {
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
@@ -42,4 +47,7 @@ void nd_device_register(struct device *dev);
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode);
 int nd_dimm_init_nsarea(struct nd_dimm_drvdata *ndd);
 int nd_dimm_init_config_data(struct nd_dimm_drvdata *ndd);
+struct nd_region *to_nd_region(struct device *dev);
+int nd_region_to_namespace_type(struct nd_region *nd_region);
+int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
 #endif /* __ND_H__ */
diff --git a/drivers/block/nd/region.c b/drivers/block/nd/region.c
new file mode 100644
index 000000000000..9d1fd45d78a1
--- /dev/null
+++ b/drivers/block/nd/region.c
@@ -0,0 +1,88 @@
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
+void __exit nd_region_exit(void)
+{
+	driver_unregister(&nd_region_driver.drv);
+}
+
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_REGION_PMEM);
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_REGION_BLK);
diff --git a/drivers/block/nd/region_devs.c b/drivers/block/nd/region_devs.c
index 12a5415acfcc..49ebce0c97be 100644
--- a/drivers/block/nd/region_devs.c
+++ b/drivers/block/nd/region_devs.c
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
+ * nd_region_to_namespace_type() - region to an integer namespace type
+ * @nd_region: region-device to interrogate
+ *
+ * This is the 'nstype' attribute of a region as well, an input to the
+ * MODALIAS for namespace devices, and bit number for a nd_bus to match
+ * namespace devices with namespace drivers.
+ */
+int nd_region_to_namespace_type(struct nd_region *nd_region)
+{
+	if (is_nd_pmem(&nd_region->dev)) {
+		u16 i, alias;
+
+		for (i = 0, alias = 0; i < nd_region->ndr_mappings; i++) {
+			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+			struct nd_dimm *nd_dimm = nd_mapping->nd_dimm;
+
+			if (nd_dimm->flags & NDD_ALIASING)
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
@@ -88,9 +124,32 @@ static ssize_t mappings_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(mappings);
 
+static ssize_t nstype_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+
+	return sprintf(buf, "%d\n", nd_region_to_namespace_type(nd_region));
+}
+static DEVICE_ATTR_RO(nstype);
+
+static ssize_t init_namespaces_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region_namespaces *num_ns = dev_get_drvdata(dev);
+
+	if (!num_ns)
+		return -ENXIO;
+
+	return sprintf(buf, "%d/%d\n", num_ns->active, num_ns->count);
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
index 1ccd2c633193..5ffa319f3408 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -177,8 +177,18 @@ static inline const char *nd_dimm_cmd_name(unsigned cmd)
 
 
 #define ND_DEVICE_DIMM 1            /* nd_dimm: container for "config data" */
+#define ND_DEVICE_REGION_PMEM 2     /* nd_region: (parent of pmem namespaces) */
+#define ND_DEVICE_REGION_BLK 3      /* nd_region: (parent of blk namespaces) */
+#define ND_DEVICE_NAMESPACE_IO 4    /* legacy persistent memory */
+#define ND_DEVICE_NAMESPACE_PMEM 5  /* persistent memory namespace (may alias) */
+#define ND_DEVICE_NAMESPACE_BLK 6   /* block-data-window namespace (may alias) */
 
 enum nd_driver_flags {
 	ND_DRIVER_DIMM            = 1 << ND_DEVICE_DIMM,
+	ND_DRIVER_REGION_PMEM     = 1 << ND_DEVICE_REGION_PMEM,
+	ND_DRIVER_REGION_BLK      = 1 << ND_DEVICE_REGION_BLK,
+	ND_DRIVER_NAMESPACE_IO    = 1 << ND_DEVICE_NAMESPACE_IO,
+	ND_DRIVER_NAMESPACE_PMEM  = 1 << ND_DEVICE_NAMESPACE_PMEM,
+	ND_DRIVER_NAMESPACE_BLK   = 1 << ND_DEVICE_NAMESPACE_BLK,
 };
 #endif /* __NDCTL_H__ */

