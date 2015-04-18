Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 09/21] nd_dimm: dimm driver and base nd-bus device-driver
 infrastructure
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Apr 2015 21:36:02 -0400
Message-ID: <20150418013602.25237.13731.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
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
      nd bus devices.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/Makefile     |    1 
 drivers/block/nd/bus.c        |  158 ++++++++++++++++++++++++++++++++++++++++
 drivers/block/nd/core.c       |   43 ++++++++++-
 drivers/block/nd/dimm.c       |  103 ++++++++++++++++++++++++++
 drivers/block/nd/dimm_devs.c  |  161 ++++++++++++++++++++++++++++++++++++++---
 drivers/block/nd/nd-private.h |   12 ++-
 drivers/block/nd/nd.h         |   21 +++++
 include/linux/nd.h            |   39 ++++++++++
 include/uapi/linux/ndctl.h    |    6 ++
 9 files changed, 526 insertions(+), 18 deletions(-)
 create mode 100644 drivers/block/nd/dimm.c
 create mode 100644 include/linux/nd.h

diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
index 6b34dd4d4df8..9f1b69c86fba 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -22,3 +22,4 @@ nd_acpi-y := acpi.o
 nd-y := core.o
 nd-y += bus.o
 nd-y += dimm_devs.o
+nd-y += dimm.o
diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
index 67a0624c265b..c815dd425a49 100644
--- a/drivers/block/nd/bus.c
+++ b/drivers/block/nd/bus.c
@@ -16,10 +16,12 @@
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
 #include "nfit.h"
 #include "nd.h"
@@ -28,8 +30,57 @@ int nd_dimm_major;
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
 };
 
 static ASYNC_DOMAIN_EXCLUSIVE(nd_async_domain);
@@ -68,6 +119,109 @@ void nd_synchronize(void)
 	async_synchronize_full_domain(&nd_async_domain);
 }
 
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
+};
+
 int nd_bus_create_ndctl(struct nd_bus *nd_bus)
 {
 	dev_t devt = MKDEV(nd_bus_major, nd_bus->id);
@@ -345,7 +499,7 @@ int __init nd_bus_init(void)
 	return rc;
 }
 
-void __exit nd_bus_exit(void)
+void nd_bus_exit(void)
 {
 	class_destroy(nd_class);
 	unregister_chrdev(nd_bus_major, "ndctl");
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
index 0df1e82fcb18..426f96b02594 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -150,8 +150,33 @@ static ssize_t revision_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(revision);
 
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
 	&dev_attr_revision.attr,
 	NULL,
@@ -491,7 +516,7 @@ static int child_unregister(struct device *dev, void *data)
 	if (dev->class)
 		/* pass */;
 	else
-		device_unregister(dev);
+		nd_device_unregister(dev, ND_SYNC);
 	return 0;
 }
 
@@ -594,6 +619,7 @@ void nfit_bus_unregister(struct nd_bus *nd_bus)
 	list_del_init(&nd_bus->list);
 	mutex_unlock(&nd_bus_list_mutex);
 
+	nd_synchronize();
 	device_for_each_child(&nd_bus->dev, NULL, child_unregister);
 	nd_bus_destroy_ndctl(nd_bus);
 
@@ -603,6 +629,8 @@ EXPORT_SYMBOL(nfit_bus_unregister);
 
 static __init int nd_core_init(void)
 {
+	int rc;
+
 	BUILD_BUG_ON(sizeof(struct nfit) != 40);
 	BUILD_BUG_ON(sizeof(struct nfit_spa) != 56);
 	BUILD_BUG_ON(sizeof(struct nfit_mem) != 48);
@@ -611,12 +639,23 @@ static __init int nd_core_init(void)
 	BUILD_BUG_ON(sizeof(struct nfit_dcr) != 80);
 	BUILD_BUG_ON(sizeof(struct nfit_bdw) != 40);
 
-	return nd_bus_init();
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
+
 }
 
 static __exit void nd_core_exit(void)
 {
 	WARN_ON(!list_empty(&nd_bus_list));
+	nd_dimm_exit();
 	nd_bus_exit();
 }
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/block/nd/dimm.c b/drivers/block/nd/dimm.c
new file mode 100644
index 000000000000..fec7229afb58
--- /dev/null
+++ b/drivers/block/nd/dimm.c
@@ -0,0 +1,103 @@
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
+static bool force_enable_dimms;
+module_param(force_enable_dimms, bool, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(force_enable_dimms, "Ignore DIMM NFIT/firmware status");
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
+	rc = nd_dimm_firmware_status(dev);
+	if (rc < 0) {
+		dev_info(dev, "disabled by firmware: %d\n", rc);
+		if (!force_enable_dimms)
+			return rc;
+	}
+
+	ndd = kzalloc(sizeof(*ndd), GFP_KERNEL);
+	if (!ndd)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, ndd);
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
+
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
index b73006cfbf66..d15ca75804ac 100644
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
@@ -23,6 +24,112 @@
 
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
+	if (!test_bit(NFIT_CMD_GET_CONFIG_DATA, &nd_dimm->dsm_mask))
+		return -ENXIO;
+
+	/* TODO: validate common format interface code */
+	if (!nd_dimm->nd_mem->nfit_dcr)
+		return -ENODEV;
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
+	struct nfit_cmd_get_config_size *cmd = &ndd->nsarea;
+	struct nd_bus *nd_bus = walk_to_nd_bus(ndd->dev);
+	struct nfit_bus_descriptor *nfit_desc;
+	int rc = validate_dimm(ndd);
+
+	if (rc)
+		return rc;
+
+	if (cmd->config_size)
+		return 0; /* already valid */
+
+	memset(cmd, 0, sizeof(*cmd));
+	nfit_desc = nd_bus->nfit_desc;
+	return nfit_desc->nfit_ctl(nfit_desc, to_nd_dimm(ndd->dev),
+			NFIT_CMD_GET_CONFIG_SIZE, cmd, sizeof(*cmd));
+}
+
+int nd_dimm_init_config_data(struct nd_dimm_drvdata *ndd)
+{
+	struct nd_bus *nd_bus = walk_to_nd_bus(ndd->dev);
+	struct nfit_cmd_get_config_data_hdr *cmd;
+	struct nfit_bus_descriptor *nfit_desc;
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
+	nfit_desc = nd_bus->nfit_desc;
+	for (config_size = ndd->nsarea.config_size, offset = 0;
+			config_size; config_size -= cmd->in_length,
+			offset += cmd->in_length) {
+		cmd->in_length = min(config_size, max_cmd_size);
+		cmd->in_offset = offset;
+		rc = nfit_desc->nfit_ctl(nfit_desc, to_nd_dimm(ndd->dev),
+				NFIT_CMD_GET_CONFIG_DATA, cmd,
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
@@ -211,9 +318,27 @@ static struct attribute_group nd_dimm_attribute_group = {
 
 static const struct attribute_group *nd_dimm_attribute_groups[] = {
 	&nd_dimm_attribute_group,
+	&nd_device_attribute_group,
 	NULL,
 };
 
+/**
+ * nd_dimm_firmware_status - retrieve NFIT-specific state of the dimm
+ * @dev: dimm device to interrogate
+ *
+ * At init time as the NFIT parsing code discovers DIMMs (memdevs) it
+ * validates the state of those devices against the NFIT provider.  It
+ * is possible that an NFIT entry exists for the DIMM but the device is
+ * disabled.  In that case we will still create an nd_dimm, but prevent
+ * it from binding to its driver.
+ */
+int nd_dimm_firmware_status(struct device *dev)
+{
+	struct nd_dimm *nd_dimm = to_nd_dimm(dev);
+
+	return nd_dimm->nfit_status;
+}
+
 static struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus,
 		struct nd_mem *nd_mem)
 {
@@ -244,20 +369,12 @@ static struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus,
 	dev_set_name(dev, "nmem%d", nd_dimm->id);
 	dev->parent = &nd_bus->dev;
 	dev->type = &nd_dimm_device_type;
-	dev->bus = &nd_bus_type;
 	dev->groups = nd_dimm_attribute_groups;
 	dev->devt = MKDEV(nd_dimm_major, nd_dimm->id);
 	if (nfit_desc->add_dimm)
-		if (nfit_desc->add_dimm(nfit_desc, nd_dimm) != 0) {
-			device_initialize(dev);
-			put_device(dev);
-			return NULL;
-		}
+		nd_dimm->nfit_status = nfit_desc->add_dimm(nfit_desc, nd_dimm);
 
-	if (device_register(dev) != 0) {
-		put_device(dev);
-		return NULL;
-	}
+	nd_device_register(dev);
 
 	return nd_dimm;
  err_ida:
@@ -269,6 +386,15 @@ static struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus,
 	return NULL;
 }
 
+static int count_dimms(struct device *dev, void *c)
+{
+	int *count = c;
+
+	if (is_nd_dimm(dev))
+		(*count)++;
+	return 0;
+}
+
 int nd_bus_register_dimms(struct nd_bus *nd_bus)
 {
 	int rc = 0, dimm_count = 0;
@@ -300,5 +426,18 @@ int nd_bus_register_dimms(struct nd_bus *nd_bus)
 	}
 	mutex_unlock(&nd_bus_list_mutex);
 
-	return rc;
+	/*
+	 * Flush dimm registration as 'nd_region' registration depends on
+	 * finding 'nd_dimm's on the bus.
+	 */
+	nd_synchronize();
+	if (rc)
+		return rc;
+
+	rc = 0;
+	device_for_each_child(&nd_bus->dev, &rc, count_dimms);
+	dev_dbg(&nd_bus->dev, "%s: count: %d\n", __func__, rc);
+	if (rc != dimm_count)
+		return -ENXIO;
+	return 0;
 }
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index 31239942b724..72197992e386 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -18,7 +18,6 @@
 
 extern struct list_head nd_bus_list;
 extern struct mutex nd_bus_list_mutex;
-extern struct bus_type nd_bus_type;
 extern int nd_dimm_major;
 
 enum {
@@ -26,6 +25,11 @@ enum {
 	ND_IOCTL_MAX_BUFLEN = SZ_4M,
 };
 
+/*
+ * List manipulation is protected by nd_bus_list_mutex, except for the
+ * deferred probe tracking list which nests under instances where
+ * nd_bus_list_mutex is locked
+ */
 struct nd_bus {
 	struct nfit_bus_descriptor *nfit_desc;
 	struct radix_tree_root dimm_radix;
@@ -44,7 +48,7 @@ struct nd_dimm {
 	struct nd_mem *nd_mem;
 	struct device dev;
 	void *provider_data;
-	int id;
+	int id, nfit_status;
 	struct nd_dimm_delete {
 		struct nd_bus *nd_bus;
 		struct nd_mem *nd_mem;
@@ -88,8 +92,10 @@ struct nd_dimm *to_nd_dimm(struct device *dev);
 struct nd_bus *walk_to_nd_bus(struct device *nd_dev);
 void nd_synchronize(void);
 int __init nd_bus_init(void);
-void __exit nd_bus_exit(void);
+void nd_bus_exit(void);
 void nd_dimm_delete(struct nd_dimm *nd_dimm);
+int __init nd_dimm_init(void);
+void __exit nd_dimm_exit(void);
 int nd_bus_create_ndctl(struct nd_bus *nd_bus);
 void nd_bus_destroy_ndctl(struct nd_bus *nd_bus);
 int nd_bus_register_dimms(struct nd_bus *nd_bus);
diff --git a/drivers/block/nd/nd.h b/drivers/block/nd/nd.h
index bf6313fffd4c..f277440c72b4 100644
--- a/drivers/block/nd/nd.h
+++ b/drivers/block/nd/nd.h
@@ -12,10 +12,31 @@
  */
 #ifndef __ND_H__
 #define __ND_H__
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/ndctl.h>
+
+struct nd_dimm_drvdata {
+	struct device *dev;
+	struct nfit_cmd_get_config_size nsarea;
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
+extern struct attribute_group nd_device_attribute_group;
 struct nd_dimm;
 u32 to_nfit_handle(struct nd_dimm *nd_dimm);
 void *nd_dimm_get_pdata(struct nd_dimm *nd_dimm);
 void nd_dimm_set_pdata(struct nd_dimm *nd_dimm, void *data);
 unsigned long nd_dimm_get_dsm_mask(struct nd_dimm *nd_dimm);
 void nd_dimm_set_dsm_mask(struct nd_dimm *nd_dimm, unsigned long dsm_mask);
+int nd_dimm_init_nsarea(struct nd_dimm_drvdata *ndd);
+int nd_dimm_init_config_data(struct nd_dimm_drvdata *ndd);
+int nd_dimm_firmware_status(struct device *dev);
 #endif /* __ND_H__ */
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
index 6cc8c91a0058..f11a9f706bbf 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -175,4 +175,10 @@ static inline const char *nfit_dimm_cmd_name(unsigned cmd)
 #define NFIT_IOCTL_ARS_QUERY		_IOWR(ND_IOCTL, NFIT_CMD_ARS_QUERY,\
 					struct nfit_cmd_ars_query)
 
+
+#define ND_DEVICE_DIMM 1            /* nd_dimm: container for "config data" */
+
+enum nd_driver_flags {
+	ND_DRIVER_DIMM            = 1 << ND_DEVICE_DIMM,
+};
 #endif /* __NDCTL_H__ */

