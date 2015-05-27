Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v4 06/21] libnd,
 nd_dimm: dimm driver and base libnd device-driver infrastructure
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 May 2015 18:25:15 -0400
Message-ID: <20150527222515.17965.12851.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150527210155.17965.74864.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150527210155.17965.74864.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: sfr@canb.auug.org.au, linux-nvdimm@lists.01.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

* Implement the device-model infrastructure for loading modules and
  attaching drivers to nd devices.  This is a simple association of a
  nd-device-type number with a driver that has a bitmask of supported
  device types.  To facilitate userspace bind/unbind operations 'modalias'
  and 'devtype', that also appear in the uevent, are added as generic
  sysfs attributes for all nd devices.  The reason for the device-type
  number is to support sub-types within a given parent devtype, be it a
  vendor-specific sub-type or otherwise.

* The first consumer of this infrastructure is the driver
  for dimm devices.  It simply uses control messages to retrieve and
  store the configuration-data image (label set) from each dimm.

Note: nd_device_register() arranges for asynchronous registration of
      nd bus devices by default.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c           |   13 ++-
 drivers/block/nd/Makefile     |    1 
 drivers/block/nd/bus.c        |  168 +++++++++++++++++++++++++++++++++++++++++
 drivers/block/nd/core.c       |   43 ++++++++++
 drivers/block/nd/dimm.c       |   92 ++++++++++++++++++++++
 drivers/block/nd/dimm_devs.c  |  136 ++++++++++++++++++++++++++++++++-
 drivers/block/nd/nd-private.h |    8 +-
 drivers/block/nd/nd.h         |   34 ++++++++
 include/linux/libnd.h         |    2 
 include/linux/nd.h            |   39 ++++++++++
 include/uapi/linux/ndctl.h    |    6 +
 11 files changed, 527 insertions(+), 15 deletions(-)
 create mode 100644 drivers/block/nd/dimm.c
 create mode 100644 drivers/block/nd/nd.h
 create mode 100644 include/linux/nd.h

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index b7c1c5a5b589..c75f4bf1c230 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -18,6 +18,10 @@
 #include <linux/acpi.h>
 #include "nfit.h"
 
+static bool force_enable_dimms;
+module_param(force_enable_dimms, bool, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(force_enable_dimms, "Ignore _STA (ACPI DIMM device) status");
+
 static u8 nfit_uuid[NFIT_UUID_MAX][16];
 
 static const u8 *to_nfit_uuid(enum nfit_uuids id)
@@ -592,6 +596,7 @@ static struct attribute_group acpi_nfit_dimm_attribute_group = {
 
 static const struct attribute_group *acpi_nfit_dimm_attribute_groups[] = {
 	&nd_dimm_attribute_group,
+	&nd_device_attribute_group,
 	&acpi_nfit_dimm_attribute_group,
 	NULL,
 };
@@ -628,7 +633,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	if (!adev_dimm) {
 		dev_err(dev, "no ACPI.NFIT device with _ADR %#x, disabling...\n",
 				device_handle);
-		return -ENODEV;
+		return force_enable_dimms ? 0 : -ENODEV;
 	}
 
 	status = acpi_evaluate_integer(adev_dimm->handle, "_STA", NULL, &sta);
@@ -649,12 +654,13 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		if (acpi_check_dsm(adev_dimm->handle, uuid, 1, 1ULL << i))
 			set_bit(i, &nfit_mem->dsm_mask);
 
-	return rc;
+	return force_enable_dimms ? 0 : rc;
 }
 
 static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 {
 	struct nfit_mem *nfit_mem;
+	int dimm_count = 0;
 
 	list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
 		struct nd_dimm *nd_dimm;
@@ -688,9 +694,10 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 			return -ENOMEM;
 
 		nfit_mem->nd_dimm = nd_dimm;
+		dimm_count++;
 	}
 
-	return 0;
+	return nd_bus_validate_dimm_count(acpi_desc->nd_bus, dimm_count);
 }
 
 static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
index 2954b9543bec..d9ef4496e8d3 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_LIBND) += libnd.o
 libnd-y := core.o
 libnd-y += bus.o
 libnd-y += dimm_devs.o
+libnd-y += dimm.o
diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
index f072a9e0c1bd..3f5cdbc24973 100644
--- a/drivers/block/nd/bus.c
+++ b/drivers/block/nd/bus.c
@@ -16,19 +16,183 @@
 #include <linux/fcntl.h>
 #include <linux/async.h>
 #include <linux/ndctl.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/io.h>
 #include <linux/mm.h>
+#include <linux/nd.h>
 #include "nd-private.h"
+#include "nd.h"
 
 int nd_dimm_major;
 static int nd_bus_major;
 static struct class *nd_class;
 
-struct bus_type nd_bus_type = {
+static int to_nd_device_type(struct device *dev)
+{
+	if (is_nd_dimm(dev))
+		return ND_DEVICE_DIMM;
+
+	return 0;
+}
+
+static int nd_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	return add_uevent_var(env, "MODALIAS=" ND_DEVICE_MODALIAS_FMT,
+			to_nd_device_type(dev));
+}
+
+static int nd_bus_match(struct device *dev, struct device_driver *drv)
+{
+	struct nd_device_driver *nd_drv = to_nd_device_driver(drv);
+
+	return test_bit(to_nd_device_type(dev), &nd_drv->type);
+}
+
+static int nd_bus_probe(struct device *dev)
+{
+	struct nd_device_driver *nd_drv = to_nd_device_driver(dev->driver);
+	struct nd_bus *nd_bus = walk_to_nd_bus(dev);
+	int rc;
+
+	rc = nd_drv->probe(dev);
+	dev_dbg(&nd_bus->dev, "%s.probe(%s) = %d\n", dev->driver->name,
+			dev_name(dev), rc);
+	return rc;
+}
+
+static int nd_bus_remove(struct device *dev)
+{
+	struct nd_device_driver *nd_drv = to_nd_device_driver(dev->driver);
+	struct nd_bus *nd_bus = walk_to_nd_bus(dev);
+	int rc;
+
+	rc = nd_drv->remove(dev);
+	dev_dbg(&nd_bus->dev, "%s.remove(%s) = %d\n", dev->driver->name,
+			dev_name(dev), rc);
+	return rc;
+}
+
+static struct bus_type nd_bus_type = {
 	.name = "nd",
+	.uevent = nd_bus_uevent,
+	.match = nd_bus_match,
+	.probe = nd_bus_probe,
+	.remove = nd_bus_remove,
+};
+
+static ASYNC_DOMAIN_EXCLUSIVE(nd_async_domain);
+
+void nd_synchronize(void)
+{
+	async_synchronize_full_domain(&nd_async_domain);
+}
+EXPORT_SYMBOL_GPL(nd_synchronize);
+
+static void nd_async_device_register(void *d, async_cookie_t cookie)
+{
+	struct device *dev = d;
+
+	if (device_add(dev) != 0) {
+		dev_err(dev, "%s: failed\n", __func__);
+		put_device(dev);
+	}
+	put_device(dev);
+}
+
+static void nd_async_device_unregister(void *d, async_cookie_t cookie)
+{
+	struct device *dev = d;
+
+	device_unregister(dev);
+	put_device(dev);
+}
+
+void nd_device_register(struct device *dev)
+{
+	dev->bus = &nd_bus_type;
+	device_initialize(dev);
+	get_device(dev);
+	async_schedule_domain(nd_async_device_register, dev,
+			&nd_async_domain);
+}
+EXPORT_SYMBOL(nd_device_register);
+
+void nd_device_unregister(struct device *dev, enum nd_async_mode mode)
+{
+	switch (mode) {
+	case ND_ASYNC:
+		get_device(dev);
+		async_schedule_domain(nd_async_device_unregister, dev,
+				&nd_async_domain);
+		break;
+	case ND_SYNC:
+		nd_synchronize();
+		device_unregister(dev);
+		break;
+	}
+}
+EXPORT_SYMBOL(nd_device_unregister);
+
+/**
+ * __nd_driver_register() - register a region or a namespace driver
+ * @nd_drv: driver to register
+ * @owner: automatically set by nd_driver_register() macro
+ * @mod_name: automatically set by nd_driver_register() macro
+ */
+int __nd_driver_register(struct nd_device_driver *nd_drv, struct module *owner,
+		const char *mod_name)
+{
+	struct device_driver *drv = &nd_drv->drv;
+
+	if (!nd_drv->type) {
+		pr_debug("driver type bitmask not set (%pf)\n",
+				__builtin_return_address(0));
+		return -EINVAL;
+	}
+
+	if (!nd_drv->probe || !nd_drv->remove) {
+		pr_debug("->probe() and ->remove() must be specified\n");
+		return -EINVAL;
+	}
+
+	drv->bus = &nd_bus_type;
+	drv->owner = owner;
+	drv->mod_name = mod_name;
+
+	return driver_register(drv);
+}
+EXPORT_SYMBOL(__nd_driver_register);
+
+static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	return sprintf(buf, ND_DEVICE_MODALIAS_FMT "\n",
+			to_nd_device_type(dev));
+}
+static DEVICE_ATTR_RO(modalias);
+
+static ssize_t devtype_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	return sprintf(buf, "%s\n", dev->type->name);
+}
+DEVICE_ATTR_RO(devtype);
+
+static struct attribute *nd_device_attributes[] = {
+	&dev_attr_modalias.attr,
+	&dev_attr_devtype.attr,
+	NULL,
+};
+
+/**
+ * nd_device_attribute_group - generic attributes for all devices on an nd bus
+ */
+struct attribute_group nd_device_attribute_group = {
+	.attrs = nd_device_attributes,
 };
+EXPORT_SYMBOL_GPL(nd_device_attribute_group);
 
 int nd_bus_create_ndctl(struct nd_bus *nd_bus)
 {
@@ -402,7 +566,7 @@ int __init nd_bus_init(void)
 	return rc;
 }
 
-void __exit nd_bus_exit(void)
+void nd_bus_exit(void)
 {
 	class_destroy(nd_class);
 	unregister_chrdev(nd_bus_major, "ndctl");
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
index d7a922913da2..a3dd3a22ce92 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -18,6 +18,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include "nd-private.h"
+#include "nd.h"
 
 LIST_HEAD(nd_bus_list);
 DEFINE_MUTEX(nd_bus_list_mutex);
@@ -96,8 +97,33 @@ static ssize_t provider_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(provider);
 
+static int flush_namespaces(struct device *dev, void *data)
+{
+	device_lock(dev);
+	device_unlock(dev);
+	return 0;
+}
+
+static int flush_regions_dimms(struct device *dev, void *data)
+{
+	device_lock(dev);
+	device_unlock(dev);
+	device_for_each_child(dev, NULL, flush_namespaces);
+	return 0;
+}
+
+static ssize_t wait_probe_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	nd_synchronize();
+	device_for_each_child(dev, NULL, flush_regions_dimms);
+	return sprintf(buf, "1\n");
+}
+static DEVICE_ATTR_RO(wait_probe);
+
 static struct attribute *nd_bus_attributes[] = {
 	&dev_attr_commands.attr,
+	&dev_attr_wait_probe.attr,
 	&dev_attr_provider.attr,
 	NULL,
 };
@@ -158,7 +184,7 @@ static int child_unregister(struct device *dev, void *data)
 	if (dev->class)
 		/* pass */;
 	else
-		device_unregister(dev);
+		nd_device_unregister(dev, ND_SYNC);
 	return 0;
 }
 
@@ -171,6 +197,7 @@ void nd_bus_unregister(struct nd_bus *nd_bus)
 	list_del_init(&nd_bus->list);
 	mutex_unlock(&nd_bus_list_mutex);
 
+	nd_synchronize();
 	device_for_each_child(&nd_bus->dev, NULL, child_unregister);
 	nd_bus_destroy_ndctl(nd_bus);
 
@@ -180,12 +207,24 @@ EXPORT_SYMBOL_GPL(nd_bus_unregister);
 
 static __init int libnd_init(void)
 {
-	return nd_bus_init();
+	int rc;
+
+	rc = nd_bus_init();
+	if (rc)
+		return rc;
+	rc = nd_dimm_init();
+	if (rc)
+		goto err_dimm;
+	return 0;
+ err_dimm:
+	nd_bus_exit();
+	return rc;
 }
 
 static __exit void libnd_exit(void)
 {
 	WARN_ON(!list_empty(&nd_bus_list));
+	nd_dimm_exit();
 	nd_bus_exit();
 }
 
diff --git a/drivers/block/nd/dimm.c b/drivers/block/nd/dimm.c
new file mode 100644
index 000000000000..1665b7d69e3a
--- /dev/null
+++ b/drivers/block/nd/dimm.c
@@ -0,0 +1,92 @@
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
+#include <linux/vmalloc.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/sizes.h>
+#include <linux/ndctl.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/nd.h>
+#include "nd.h"
+
+static void free_data(struct nd_dimm_drvdata *ndd)
+{
+	if (!ndd)
+		return;
+
+	if (ndd->data && is_vmalloc_addr(ndd->data))
+		vfree(ndd->data);
+	else
+		kfree(ndd->data);
+	kfree(ndd);
+}
+
+static int nd_dimm_probe(struct device *dev)
+{
+	struct nd_dimm_drvdata *ndd;
+	int rc;
+
+	ndd = kzalloc(sizeof(*ndd), GFP_KERNEL);
+	if (!ndd)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, ndd);
+	ndd->dev = dev;
+
+	rc = nd_dimm_init_nsarea(ndd);
+	if (rc)
+		goto err;
+
+	rc = nd_dimm_init_config_data(ndd);
+	if (rc)
+		goto err;
+
+	dev_dbg(dev, "config data size: %d\n", ndd->nsarea.config_size);
+
+	return 0;
+
+ err:
+	free_data(ndd);
+	return rc;
+}
+
+static int nd_dimm_remove(struct device *dev)
+{
+	struct nd_dimm_drvdata *ndd = dev_get_drvdata(dev);
+
+	free_data(ndd);
+
+	return 0;
+}
+
+static struct nd_device_driver nd_dimm_driver = {
+	.probe = nd_dimm_probe,
+	.remove = nd_dimm_remove,
+	.drv = {
+		.name = "nd_dimm",
+	},
+	.type = ND_DRIVER_DIMM,
+};
+
+int __init nd_dimm_init(void)
+{
+	return nd_driver_register(&nd_dimm_driver);
+}
+
+void __exit nd_dimm_exit(void)
+{
+	driver_unregister(&nd_dimm_driver.drv);
+}
+
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_DIMM);
diff --git a/drivers/block/nd/dimm_devs.c b/drivers/block/nd/dimm_devs.c
index 3fa26f61c3db..33b6d5336096 100644
--- a/drivers/block/nd/dimm_devs.c
+++ b/drivers/block/nd/dimm_devs.c
@@ -11,6 +11,7 @@
  * General Public License for more details.
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/vmalloc.h>
 #include <linux/device.h>
 #include <linux/ndctl.h>
 #include <linux/slab.h>
@@ -18,9 +19,115 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include "nd-private.h"
+#include "nd.h"
 
 static DEFINE_IDA(dimm_ida);
 
+/*
+ * Retrieve bus and dimm handle and return if this bus supports
+ * get_config_data commands
+ */
+static int __validate_dimm(struct nd_dimm_drvdata *ndd)
+{
+	struct nd_dimm *nd_dimm;
+
+	if (!ndd)
+		return -EINVAL;
+
+	nd_dimm = to_nd_dimm(ndd->dev);
+
+	if (!nd_dimm->dsm_mask)
+		return -ENXIO;
+	if (!test_bit(ND_CMD_GET_CONFIG_DATA, nd_dimm->dsm_mask))
+		return -ENXIO;
+
+	return 0;
+}
+
+static int validate_dimm(struct nd_dimm_drvdata *ndd)
+{
+	int rc = __validate_dimm(ndd);
+
+	if (rc && ndd)
+		dev_dbg(ndd->dev, "%pf: %s error: %d\n",
+				__builtin_return_address(0), __func__, rc);
+	return rc;
+}
+
+/**
+ * nd_dimm_init_nsarea - determine the geometry of a dimm's namespace area
+ * @nd_dimm: dimm to initialize
+ */
+int nd_dimm_init_nsarea(struct nd_dimm_drvdata *ndd)
+{
+	struct nd_cmd_get_config_size *cmd = &ndd->nsarea;
+	struct nd_bus *nd_bus = walk_to_nd_bus(ndd->dev);
+	struct nd_bus_descriptor *nd_desc;
+	int rc = validate_dimm(ndd);
+
+	if (rc)
+		return rc;
+
+	if (cmd->config_size)
+		return 0; /* already valid */
+
+	memset(cmd, 0, sizeof(*cmd));
+	nd_desc = nd_bus->nd_desc;
+	return nd_desc->ndctl(nd_desc, to_nd_dimm(ndd->dev),
+			ND_CMD_GET_CONFIG_SIZE, cmd, sizeof(*cmd));
+}
+
+int nd_dimm_init_config_data(struct nd_dimm_drvdata *ndd)
+{
+	struct nd_bus *nd_bus = walk_to_nd_bus(ndd->dev);
+	struct nd_cmd_get_config_data_hdr *cmd;
+	struct nd_bus_descriptor *nd_desc;
+	int rc = validate_dimm(ndd);
+	u32 max_cmd_size, config_size;
+	size_t offset;
+
+	if (rc)
+		return rc;
+
+	if (ndd->data)
+		return 0;
+
+	if (ndd->nsarea.status || ndd->nsarea.max_xfer == 0)
+		return -ENXIO;
+
+	ndd->data = kmalloc(ndd->nsarea.config_size, GFP_KERNEL);
+	if (!ndd->data)
+		ndd->data = vmalloc(ndd->nsarea.config_size);
+
+	if (!ndd->data)
+		return -ENOMEM;
+
+	max_cmd_size = min_t(u32, PAGE_SIZE, ndd->nsarea.max_xfer);
+	cmd = kzalloc(max_cmd_size + sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	nd_desc = nd_bus->nd_desc;
+	for (config_size = ndd->nsarea.config_size, offset = 0;
+			config_size; config_size -= cmd->in_length,
+			offset += cmd->in_length) {
+		cmd->in_length = min(config_size, max_cmd_size);
+		cmd->in_offset = offset;
+		rc = nd_desc->ndctl(nd_desc, to_nd_dimm(ndd->dev),
+				ND_CMD_GET_CONFIG_DATA, cmd,
+				cmd->in_length + sizeof(*cmd));
+		if (rc || cmd->status) {
+			rc = -ENXIO;
+			break;
+		}
+		memcpy(ndd->data + offset, cmd->out_buf, cmd->in_length);
+	}
+	dev_dbg(ndd->dev, "%s: len: %zd rc: %d\n", __func__, offset, rc);
+	kfree(cmd);
+
+	return rc;
+}
+
 static void nd_dimm_release(struct device *dev)
 {
 	struct nd_dimm *nd_dimm = to_nd_dimm(dev);
@@ -111,14 +218,33 @@ struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus, void *provider_data,
 	dev_set_name(dev, "nmem%d", nd_dimm->id);
 	dev->parent = &nd_bus->dev;
 	dev->type = &nd_dimm_device_type;
-	dev->bus = &nd_bus_type;
 	dev->devt = MKDEV(nd_dimm_major, nd_dimm->id);
 	dev->groups = groups;
-	if (device_register(dev) != 0) {
-		put_device(dev);
-		return NULL;
-	}
+	nd_device_register(dev);
 
 	return nd_dimm;
 }
 EXPORT_SYMBOL_GPL(nd_dimm_create);
+
+static int count_dimms(struct device *dev, void *c)
+{
+	int *count = c;
+
+	if (is_nd_dimm(dev))
+		(*count)++;
+	return 0;
+}
+
+int nd_bus_validate_dimm_count(struct nd_bus *nd_bus, int dimm_count)
+{
+	int count = 0;
+	/* Flush any possible dimm registration failures */
+	nd_synchronize();
+
+	device_for_each_child(&nd_bus->dev, &count, count_dimms);
+	dev_dbg(&nd_bus->dev, "%s: count: %d\n", __func__, count);
+	if (count != dimm_count)
+		return -ENXIO;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nd_bus_validate_dimm_count);
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index c71a5f34355a..a333f3401ca7 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -17,7 +17,6 @@
 
 extern struct list_head nd_bus_list;
 extern struct mutex nd_bus_list_mutex;
-extern struct bus_type nd_bus_type;
 extern int nd_dimm_major;
 
 struct nd_bus {
@@ -35,10 +34,13 @@ struct nd_dimm {
 	int id;
 };
 
-bool is_nd_dimm(struct device *dev);
 struct nd_bus *walk_to_nd_bus(struct device *nd_dev);
 int __init nd_bus_init(void);
-void __exit nd_bus_exit(void);
+void nd_bus_exit(void);
+int __init nd_dimm_init(void);
+void __exit nd_dimm_exit(void);
 int nd_bus_create_ndctl(struct nd_bus *nd_bus);
 void nd_bus_destroy_ndctl(struct nd_bus *nd_bus);
+void nd_synchronize(void);
+bool is_nd_dimm(struct device *dev);
 #endif /* __ND_PRIVATE_H__ */
diff --git a/drivers/block/nd/nd.h b/drivers/block/nd/nd.h
new file mode 100644
index 000000000000..1a5a081ce640
--- /dev/null
+++ b/drivers/block/nd/nd.h
@@ -0,0 +1,34 @@
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
+#ifndef __ND_H__
+#define __ND_H__
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/ndctl.h>
+
+struct nd_dimm_drvdata {
+	struct device *dev;
+	struct nd_cmd_get_config_size nsarea;
+	void *data;
+};
+
+enum nd_async_mode {
+	ND_SYNC,
+	ND_ASYNC,
+};
+
+void nd_device_register(struct device *dev);
+void nd_device_unregister(struct device *dev, enum nd_async_mode mode);
+int nd_dimm_init_nsarea(struct nd_dimm_drvdata *ndd);
+int nd_dimm_init_config_data(struct nd_dimm_drvdata *ndd);
+#endif /* __ND_H__ */
diff --git a/include/linux/libnd.h b/include/linux/libnd.h
index ca72c49ae376..0d7e82401e4b 100644
--- a/include/linux/libnd.h
+++ b/include/linux/libnd.h
@@ -29,6 +29,7 @@ enum {
 
 extern struct attribute_group nd_bus_attribute_group;
 extern struct attribute_group nd_dimm_attribute_group;
+extern struct attribute_group nd_device_attribute_group;
 
 struct nd_dimm;
 struct nd_bus_descriptor;
@@ -70,4 +71,5 @@ u32 nd_cmd_in_size(struct nd_dimm *nd_dimm, int cmd,
 u32 nd_cmd_out_size(struct nd_dimm *nd_dimm, int cmd,
 		const struct nd_cmd_desc *desc, int idx, const u32 *in_field,
 		const u32 *out_field);
+int nd_bus_validate_dimm_count(struct nd_bus *nd_bus, int dimm_count);
 #endif /* __LIBND_H__ */
diff --git a/include/linux/nd.h b/include/linux/nd.h
new file mode 100644
index 000000000000..e074f67e53a3
--- /dev/null
+++ b/include/linux/nd.h
@@ -0,0 +1,39 @@
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
+#ifndef __LINUX_ND_H__
+#define __LINUX_ND_H__
+#include <linux/ndctl.h>
+#include <linux/device.h>
+
+struct nd_device_driver {
+	struct device_driver drv;
+	unsigned long type;
+	int (*probe)(struct device *dev);
+	int (*remove)(struct device *dev);
+};
+
+static inline struct nd_device_driver *to_nd_device_driver(
+		struct device_driver *drv)
+{
+	return container_of(drv, struct nd_device_driver, drv);
+}
+
+#define MODULE_ALIAS_ND_DEVICE(type) \
+	MODULE_ALIAS("nd:t" __stringify(type) "*")
+#define ND_DEVICE_MODALIAS_FMT "nd:t%d"
+
+int __must_check __nd_driver_register(struct nd_device_driver *nd_drv,
+		struct module *module, const char *mod_name);
+#define nd_driver_register(driver) \
+	__nd_driver_register(driver, THIS_MODULE, KBUILD_MODNAME)
+#endif /* __LINUX_ND_H__ */
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 62c01bf76198..1ccd2c633193 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -175,4 +175,10 @@ static inline const char *nd_dimm_cmd_name(unsigned cmd)
 #define ND_IOCTL_ARS_QUERY		_IOWR(ND_IOCTL, ND_CMD_ARS_QUERY,\
 					struct nd_cmd_ars_query)
 
+
+#define ND_DEVICE_DIMM 1            /* nd_dimm: container for "config data" */
+
+enum nd_driver_flags {
+	ND_DRIVER_DIMM            = 1 << ND_DEVICE_DIMM,
+};
 #endif /* __NDCTL_H__ */

