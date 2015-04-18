Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 11/21] nd_region: support for legacy nvdimms
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Apr 2015 21:36:13 -0400
Message-ID: <20150418013613.25237.15849.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The NFIT region driver is an intermediary driver that translates NFIT
defined "region"s into "namespace" devices that are consumed by
persistent memory block drivers.  A "namespace" is a sub-division of a
region.

Support for NVDIMM labels is reserved for a later patch.  For now,
publish 'nd_namespace_io' devices which are simply memory ranges with no
regard for dimm boundaries, interleave, or aliasing.  This also adds a
"nstype" attribute to the parent region so that userspace can know ahead
of time the type of namespaces a given region will produce.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/Makefile         |    2 +
 drivers/block/nd/bus.c            |   26 +++++++++
 drivers/block/nd/core.c           |   18 ++++--
 drivers/block/nd/dimm.c           |    2 -
 drivers/block/nd/namespace_devs.c |  111 +++++++++++++++++++++++++++++++++++++
 drivers/block/nd/nd-private.h     |    8 ++-
 drivers/block/nd/nd.h             |    7 ++
 drivers/block/nd/nfit.h           |    7 ++
 drivers/block/nd/region.c         |   88 +++++++++++++++++++++++++++++
 drivers/block/nd/region_devs.c    |   65 +++++++++++++++++++++-
 include/linux/nd.h                |   10 +++
 include/uapi/linux/ndctl.h        |   10 +++
 12 files changed, 343 insertions(+), 11 deletions(-)
 create mode 100644 drivers/block/nd/namespace_devs.c
 create mode 100644 drivers/block/nd/region.c

diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
index 6698acbe7b44..769ddc34f974 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -24,3 +24,5 @@ nd-y += bus.o
 nd-y += dimm_devs.o
 nd-y += dimm.o
 nd-y += region_devs.o
+nd-y += region.o
+nd-y += namespace_devs.o
diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
index c815dd425a49..c98fe05a4c9b 100644
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
@@ -34,6 +35,12 @@ static int to_nd_device_type(struct device *dev)
 {
 	if (is_nd_dimm(dev))
 		return ND_DEVICE_DIMM;
+	else if (is_nd_pmem(dev))
+		return ND_DEVICE_REGION_PMEM;
+	else if (is_nd_blk(dev))
+		return ND_DEVICE_REGION_BLOCK;
+	else if (is_nd_pmem(dev->parent) || is_nd_blk(dev->parent))
+		return nd_region_to_namespace_type(to_nd_region(dev->parent));
 
 	return 0;
 }
@@ -51,27 +58,46 @@ static int nd_bus_match(struct device *dev, struct device_driver *drv)
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
index 32ecd6f05c90..c795e8057061 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -192,7 +192,7 @@ static const struct attribute_group *nd_bus_attribute_groups[] = {
 };
 
 static void *nd_bus_new(struct device *parent,
-		struct nfit_bus_descriptor *nfit_desc)
+		struct nfit_bus_descriptor *nfit_desc, struct module *module)
 {
 	struct nd_bus *nd_bus = kzalloc(sizeof(*nd_bus), GFP_KERNEL);
 	int rc;
@@ -212,6 +212,7 @@ static void *nd_bus_new(struct device *parent,
 		return NULL;
 	}
 	nd_bus->nfit_desc = nfit_desc;
+	nd_bus->module = module;
 	nd_bus->dev.parent = parent;
 	nd_bus->dev.release = nd_bus_release;
 	nd_bus->dev.groups = nd_bus_attribute_groups;
@@ -595,15 +596,16 @@ static struct nd_bus *nd_bus_probe(struct nd_bus *nd_bus)
 
 }
 
-struct nd_bus *nfit_bus_register(struct device *parent,
-		struct nfit_bus_descriptor *nfit_desc)
+struct nd_bus *__nfit_bus_register(struct device *parent,
+		struct nfit_bus_descriptor *nfit_desc,
+		struct module *module)
 {
 	static DEFINE_MUTEX(mutex);
 	struct nd_bus *nd_bus;
 
 	/* enforce single bus at a time registration */
 	mutex_lock(&mutex);
-	nd_bus = nd_bus_new(parent, nfit_desc);
+	nd_bus = nd_bus_new(parent, nfit_desc, module);
 	nd_bus = nd_bus_probe(nd_bus);
 	mutex_unlock(&mutex);
 
@@ -612,7 +614,7 @@ struct nd_bus *nfit_bus_register(struct device *parent,
 
 	return nd_bus;
 }
-EXPORT_SYMBOL(nfit_bus_register);
+EXPORT_SYMBOL(__nfit_bus_register);
 
 void nfit_bus_unregister(struct nd_bus *nd_bus)
 {
@@ -649,7 +651,12 @@ static __init int nd_core_init(void)
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
@@ -659,6 +666,7 @@ static __init int nd_core_init(void)
 static __exit void nd_core_exit(void)
 {
 	WARN_ON(!list_empty(&nd_bus_list));
+	nd_region_exit();
 	nd_dimm_exit();
 	nd_bus_exit();
 }
diff --git a/drivers/block/nd/dimm.c b/drivers/block/nd/dimm.c
index fec7229afb58..7e043c0c1bf5 100644
--- a/drivers/block/nd/dimm.c
+++ b/drivers/block/nd/dimm.c
@@ -95,7 +95,7 @@ int __init nd_dimm_init(void)
 	return nd_driver_register(&nd_dimm_driver);
 }
 
-void __exit nd_dimm_exit(void)
+void nd_dimm_exit(void)
 {
 	driver_unregister(&nd_dimm_driver.drv);
 }
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
index d254ff688ad6..db68e013b9d0 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -33,6 +33,7 @@ enum {
 struct nd_bus {
 	struct nfit_bus_descriptor *nfit_desc;
 	struct radix_tree_root dimm_radix;
+	struct module *module;
 	struct list_head memdevs;
 	struct list_head dimms;
 	struct list_head spas;
@@ -89,6 +90,8 @@ const char *spa_type_name(u16 type);
 int nfit_spa_type(struct nfit_spa __iomem *nfit_spa);
 struct nd_dimm *nd_dimm_by_handle(struct nd_bus *nd_bus, u32 nfit_handle);
 bool is_nd_dimm(struct device *dev);
+bool is_nd_blk(struct device *dev);
+bool is_nd_pmem(struct device *dev);
 struct nd_bus *to_nd_bus(struct device *dev);
 struct nd_dimm *to_nd_dimm(struct device *dev);
 struct nd_bus *walk_to_nd_bus(struct device *nd_dev);
@@ -97,11 +100,12 @@ int __init nd_bus_init(void);
 void nd_bus_exit(void);
 void nd_dimm_delete(struct nd_dimm *nd_dimm);
 int __init nd_dimm_init(void);
-void __exit nd_dimm_exit(void);
+int __init nd_region_init(void);
+void nd_dimm_exit(void);
+int nd_region_exit(void);
 int nd_bus_create_ndctl(struct nd_bus *nd_bus);
 void nd_bus_destroy_ndctl(struct nd_bus *nd_bus);
 int nd_bus_register_dimms(struct nd_bus *nd_bus);
 int nd_bus_register_regions(struct nd_bus *nd_bus);
 int nd_match_dimm(struct device *dev, void *data);
-bool is_nd_dimm(struct device *dev);
 #endif /* __ND_PRIVATE_H__ */
diff --git a/drivers/block/nd/nd.h b/drivers/block/nd/nd.h
index 13eba9bd74c7..4ac7ff2af4c8 100644
--- a/drivers/block/nd/nd.h
+++ b/drivers/block/nd/nd.h
@@ -22,6 +22,11 @@ struct nd_dimm_drvdata {
 	void *data;
 };
 
+struct nd_region_namespaces {
+	int count;
+	int active;
+};
+
 struct nd_mapping {
 	struct nd_dimm *nd_dimm;
 	u64 start;
@@ -56,4 +61,6 @@ int nd_dimm_init_nsarea(struct nd_dimm_drvdata *ndd);
 int nd_dimm_init_config_data(struct nd_dimm_drvdata *ndd);
 int nd_dimm_firmware_status(struct device *dev);
 struct nd_region *to_nd_region(struct device *dev);
+int nd_region_to_namespace_type(struct nd_region *nd_region);
+int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
 #endif /* __ND_H__ */
diff --git a/drivers/block/nd/nfit.h b/drivers/block/nd/nfit.h
index 75b480f6ff03..d8d0308f55a5 100644
--- a/drivers/block/nd/nfit.h
+++ b/drivers/block/nd/nfit.h
@@ -229,7 +229,10 @@ struct nfit_bus_descriptor {
 };
 
 struct nd_bus;
-struct nd_bus *nfit_bus_register(struct device *parent,
-		struct nfit_bus_descriptor *nfit_desc);
+#define nfit_bus_register(parent, desc) \
+	__nfit_bus_register(parent, desc, THIS_MODULE)
+struct nd_bus *__nfit_bus_register(struct device *parent,
+		struct nfit_bus_descriptor *nfit_desc,
+		struct module *module);
 void nfit_bus_unregister(struct nd_bus *nd_bus);
 #endif /* __NFIT_H__ */
diff --git a/drivers/block/nd/region.c b/drivers/block/nd/region.c
new file mode 100644
index 000000000000..29019a65808e
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
+	.type = ND_DRIVER_REGION_BLOCK | ND_DRIVER_REGION_PMEM,
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
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_REGION_BLOCK);
diff --git a/drivers/block/nd/region_devs.c b/drivers/block/nd/region_devs.c
index f474c32d6dad..03b192368e1a 100644
--- a/drivers/block/nd/region_devs.c
+++ b/drivers/block/nd/region_devs.c
@@ -50,11 +50,16 @@ static struct device_type nd_volatile_device_type = {
 	.release = nd_region_release,
 };
 
-static bool is_nd_pmem(struct device *dev)
+bool is_nd_pmem(struct device *dev)
 {
 	return dev ? dev->type == &nd_pmem_device_type : false;
 }
 
+bool is_nd_blk(struct device *dev)
+{
+	return dev ? dev->type == &nd_block_device_type : false;
+}
+
 struct nd_region *to_nd_region(struct device *dev)
 {
 	struct nd_region *nd_region = container_of(dev, struct nd_region, dev);
@@ -63,6 +68,28 @@ struct nd_region *to_nd_region(struct device *dev)
 	return nd_region;
 }
 
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
+		if (nd_region->ndr_mappings)
+			return ND_DEVICE_NAMESPACE_PMEM;
+		else
+			return ND_DEVICE_NAMESPACE_IO;
+	} else if (is_nd_blk(&nd_region->dev)) {
+		return ND_DEVICE_NAMESPACE_BLOCK;
+	}
+
+	return 0;
+}
+
 static ssize_t size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -90,9 +117,44 @@ static ssize_t mappings_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(mappings);
 
+static ssize_t spa_index_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+	struct nd_spa *nd_spa = nd_region->nd_spa;
+	u16 spa_index = readw(&nd_spa->nfit_spa->spa_index);
+
+	return sprintf(buf, "%d\n", spa_index);
+}
+static DEVICE_ATTR_RO(spa_index);
+
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
+	&dev_attr_spa_index.attr,
+	&dev_attr_init_namespaces.attr,
 	NULL,
 };
 
@@ -256,6 +318,7 @@ static struct attribute_group nd_mapping_attribute_group = {
 
 static const struct attribute_group *nd_region_attribute_groups[] = {
 	&nd_region_attribute_group,
+	&nd_device_attribute_group,
 	&nd_mapping_attribute_group,
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
index f11a9f706bbf..0ccc0f2e5765 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -177,8 +177,18 @@ static inline const char *nfit_dimm_cmd_name(unsigned cmd)
 
 
 #define ND_DEVICE_DIMM 1            /* nd_dimm: container for "config data" */
+#define ND_DEVICE_REGION_PMEM 2     /* nd_region: (parent of pmem namespaces) */
+#define ND_DEVICE_REGION_BLOCK 3    /* nd_region: (parent of block namespaces) */
+#define ND_DEVICE_NAMESPACE_IO 4    /* legacy persistent memory */
+#define ND_DEVICE_NAMESPACE_PMEM 5  /* persistent memory namespace (may alias) */
+#define ND_DEVICE_NAMESPACE_BLOCK 6 /* block-data-window namespace (may alias) */
 
 enum nd_driver_flags {
 	ND_DRIVER_DIMM            = 1 << ND_DEVICE_DIMM,
+	ND_DRIVER_REGION_PMEM     = 1 << ND_DEVICE_REGION_PMEM,
+	ND_DRIVER_REGION_BLOCK    = 1 << ND_DEVICE_REGION_BLOCK,
+	ND_DRIVER_NAMESPACE_IO    = 1 << ND_DEVICE_NAMESPACE_IO,
+	ND_DRIVER_NAMESPACE_PMEM  = 1 << ND_DEVICE_NAMESPACE_PMEM,
+	ND_DRIVER_NAMESPACE_BLOCK = 1 << ND_DEVICE_NAMESPACE_BLOCK,
 };
 #endif /* __NDCTL_H__ */

