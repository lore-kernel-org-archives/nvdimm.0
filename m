Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v7 06/16] libnvdimm,
 nvdimm: dimm driver and base libnvdimm device-driver infrastructure
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:13:52 -0400
Message-ID: <20150617231352.11597.52691.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

* Implement the device-model infrastructure for loading modules and
  attaching drivers to nvdimm devices.  This is a simple association of a
  nd-device-type number with a driver that has a bitmask of supported
  device types.  To facilitate userspace bind/unbind operations 'modalias'
  and 'devtype', that also appear in the uevent, are added as generic
  sysfs attributes for all nvdimm devices.  The reason for the device-type
  number is to support sub-types within a given parent devtype, be it a
  vendor-specific sub-type or otherwise.

* The first consumer of this infrastructure is the driver
  for dimm devices.  It simply uses control messages to retrieve and
  store the configuration-data image (label set) from each dimm.

Note: nd_device_register() arranges for asynchronous registration of
      nvdimm bus devices by default.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Neil Brown <neilb@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c        |   13 +++
 drivers/nvdimm/Makefile    |    1 
 drivers/nvdimm/bus.c       |  168 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/nvdimm/core.c      |   43 +++++++++++
 drivers/nvdimm/dimm.c      |   92 ++++++++++++++++++++++++
 drivers/nvdimm/dimm_devs.c |  136 ++++++++++++++++++++++++++++++++++--
 drivers/nvdimm/nd-core.h   |    6 +-
 drivers/nvdimm/nd.h        |   36 +++++++++
 include/linux/libnvdimm.h  |    2 +
 include/linux/nd.h         |   39 ++++++++++
 include/uapi/linux/ndctl.h |    6 ++
 11 files changed, 527 insertions(+), 15 deletions(-)
 create mode 100644 drivers/nvdimm/dimm.c
 create mode 100644 drivers/nvdimm/nd.h
 create mode 100644 include/linux/nd.h

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 9112a6210a4b..c4ccec1bc60b 100644
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
@@ -633,6 +637,7 @@ static struct attribute_group acpi_nfit_dimm_attribute_group = {
 
 static const struct attribute_group *acpi_nfit_dimm_attribute_groups[] = {
 	&nvdimm_attribute_group,
+	&nd_device_attribute_group,
 	&acpi_nfit_dimm_attribute_group,
 	NULL,
 };
@@ -669,7 +674,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	if (!adev_dimm) {
 		dev_err(dev, "no ACPI.NFIT device with _ADR %#x, disabling...\n",
 				device_handle);
-		return -ENODEV;
+		return force_enable_dimms ? 0 : -ENODEV;
 	}
 
 	status = acpi_evaluate_integer(adev_dimm->handle, "_STA", NULL, &sta);
@@ -690,12 +695,13 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
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
 		struct nvdimm *nvdimm;
@@ -729,9 +735,10 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 			return -ENOMEM;
 
 		nfit_mem->nvdimm = nvdimm;
+		dimm_count++;
 	}
 
-	return 0;
+	return nvdimm_bus_check_dimm_count(acpi_desc->nvdimm_bus, dimm_count);
 }
 
 static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index 5b68738ba406..d44b5c1fcd3b 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_LIBNVDIMM) += libnvdimm.o
 libnvdimm-y := core.o
 libnvdimm-y += bus.o
 libnvdimm-y += dimm_devs.o
+libnvdimm-y += dimm.o
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 15f3a3ddc225..a0308f1872bf 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
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
 #include "nd-core.h"
+#include "nd.h"
 
 int nvdimm_major;
 static int nvdimm_bus_major;
 static struct class *nd_class;
 
-struct bus_type nvdimm_bus_type = {
+static int to_nd_device_type(struct device *dev)
+{
+	if (is_nvdimm(dev))
+		return ND_DEVICE_DIMM;
+
+	return 0;
+}
+
+static int nvdimm_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	return add_uevent_var(env, "MODALIAS=" ND_DEVICE_MODALIAS_FMT,
+			to_nd_device_type(dev));
+}
+
+static int nvdimm_bus_match(struct device *dev, struct device_driver *drv)
+{
+	struct nd_device_driver *nd_drv = to_nd_device_driver(drv);
+
+	return test_bit(to_nd_device_type(dev), &nd_drv->type);
+}
+
+static int nvdimm_bus_probe(struct device *dev)
+{
+	struct nd_device_driver *nd_drv = to_nd_device_driver(dev->driver);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	int rc;
+
+	rc = nd_drv->probe(dev);
+	dev_dbg(&nvdimm_bus->dev, "%s.probe(%s) = %d\n", dev->driver->name,
+			dev_name(dev), rc);
+	return rc;
+}
+
+static int nvdimm_bus_remove(struct device *dev)
+{
+	struct nd_device_driver *nd_drv = to_nd_device_driver(dev->driver);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	int rc;
+
+	rc = nd_drv->remove(dev);
+	dev_dbg(&nvdimm_bus->dev, "%s.remove(%s) = %d\n", dev->driver->name,
+			dev_name(dev), rc);
+	return rc;
+}
+
+static struct bus_type nvdimm_bus_type = {
 	.name = "nd",
+	.uevent = nvdimm_bus_uevent,
+	.match = nvdimm_bus_match,
+	.probe = nvdimm_bus_probe,
+	.remove = nvdimm_bus_remove,
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
+	dev->bus = &nvdimm_bus_type;
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
+	drv->bus = &nvdimm_bus_type;
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
+static DEVICE_ATTR_RO(devtype);
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
 
 int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus)
 {
@@ -404,7 +568,7 @@ int __init nvdimm_bus_init(void)
 	return rc;
 }
 
-void __exit nvdimm_bus_exit(void)
+void nvdimm_bus_exit(void)
 {
 	class_destroy(nd_class);
 	unregister_chrdev(nvdimm_bus_major, "ndctl");
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 1ce159095c52..50ab880f0dc0 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -18,6 +18,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include "nd-core.h"
+#include "nd.h"
 
 LIST_HEAD(nvdimm_bus_list);
 DEFINE_MUTEX(nvdimm_bus_list_mutex);
@@ -98,8 +99,33 @@ static ssize_t provider_show(struct device *dev,
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
 static struct attribute *nvdimm_bus_attributes[] = {
 	&dev_attr_commands.attr,
+	&dev_attr_wait_probe.attr,
 	&dev_attr_provider.attr,
 	NULL,
 };
@@ -161,7 +187,7 @@ static int child_unregister(struct device *dev, void *data)
 	if (dev->class)
 		/* pass */;
 	else
-		device_unregister(dev);
+		nd_device_unregister(dev, ND_SYNC);
 	return 0;
 }
 
@@ -174,6 +200,7 @@ void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus)
 	list_del_init(&nvdimm_bus->list);
 	mutex_unlock(&nvdimm_bus_list_mutex);
 
+	nd_synchronize();
 	device_for_each_child(&nvdimm_bus->dev, NULL, child_unregister);
 	nvdimm_bus_destroy_ndctl(nvdimm_bus);
 
@@ -183,12 +210,24 @@ EXPORT_SYMBOL_GPL(nvdimm_bus_unregister);
 
 static __init int libnvdimm_init(void)
 {
-	return nvdimm_bus_init();
+	int rc;
+
+	rc = nvdimm_bus_init();
+	if (rc)
+		return rc;
+	rc = nvdimm_init();
+	if (rc)
+		goto err_dimm;
+	return 0;
+ err_dimm:
+	nvdimm_bus_exit();
+	return rc;
 }
 
 static __exit void libnvdimm_exit(void)
 {
 	WARN_ON(!list_empty(&nvdimm_bus_list));
+	nvdimm_exit();
 	nvdimm_bus_exit();
 }
 
diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
new file mode 100644
index 000000000000..28001a6ccd4e
--- /dev/null
+++ b/drivers/nvdimm/dimm.c
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
+static void free_data(struct nvdimm_drvdata *ndd)
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
+static int nvdimm_probe(struct device *dev)
+{
+	struct nvdimm_drvdata *ndd;
+	int rc;
+
+	ndd = kzalloc(sizeof(*ndd), GFP_KERNEL);
+	if (!ndd)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, ndd);
+	ndd->dev = dev;
+
+	rc = nvdimm_init_nsarea(ndd);
+	if (rc)
+		goto err;
+
+	rc = nvdimm_init_config_data(ndd);
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
+static int nvdimm_remove(struct device *dev)
+{
+	struct nvdimm_drvdata *ndd = dev_get_drvdata(dev);
+
+	free_data(ndd);
+
+	return 0;
+}
+
+static struct nd_device_driver nvdimm_driver = {
+	.probe = nvdimm_probe,
+	.remove = nvdimm_remove,
+	.drv = {
+		.name = "nvdimm",
+	},
+	.type = ND_DRIVER_DIMM,
+};
+
+int __init nvdimm_init(void)
+{
+	return nd_driver_register(&nvdimm_driver);
+}
+
+void __exit nvdimm_exit(void)
+{
+	driver_unregister(&nvdimm_driver.drv);
+}
+
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_DIMM);
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index c3dd7227d1bb..b3ae86f2e1da 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
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
 #include "nd-core.h"
+#include "nd.h"
 
 static DEFINE_IDA(dimm_ida);
 
+/*
+ * Retrieve bus and dimm handle and return if this bus supports
+ * get_config_data commands
+ */
+static int __validate_dimm(struct nvdimm_drvdata *ndd)
+{
+	struct nvdimm *nvdimm;
+
+	if (!ndd)
+		return -EINVAL;
+
+	nvdimm = to_nvdimm(ndd->dev);
+
+	if (!nvdimm->dsm_mask)
+		return -ENXIO;
+	if (!test_bit(ND_CMD_GET_CONFIG_DATA, nvdimm->dsm_mask))
+		return -ENXIO;
+
+	return 0;
+}
+
+static int validate_dimm(struct nvdimm_drvdata *ndd)
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
+ * nvdimm_init_nsarea - determine the geometry of a dimm's namespace area
+ * @nvdimm: dimm to initialize
+ */
+int nvdimm_init_nsarea(struct nvdimm_drvdata *ndd)
+{
+	struct nd_cmd_get_config_size *cmd = &ndd->nsarea;
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(ndd->dev);
+	struct nvdimm_bus_descriptor *nd_desc;
+	int rc = validate_dimm(ndd);
+
+	if (rc)
+		return rc;
+
+	if (cmd->config_size)
+		return 0; /* already valid */
+
+	memset(cmd, 0, sizeof(*cmd));
+	nd_desc = nvdimm_bus->nd_desc;
+	return nd_desc->ndctl(nd_desc, to_nvdimm(ndd->dev),
+			ND_CMD_GET_CONFIG_SIZE, cmd, sizeof(*cmd));
+}
+
+int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
+{
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(ndd->dev);
+	struct nd_cmd_get_config_data_hdr *cmd;
+	struct nvdimm_bus_descriptor *nd_desc;
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
+	nd_desc = nvdimm_bus->nd_desc;
+	for (config_size = ndd->nsarea.config_size, offset = 0;
+			config_size; config_size -= cmd->in_length,
+			offset += cmd->in_length) {
+		cmd->in_length = min(config_size, max_cmd_size);
+		cmd->in_offset = offset;
+		rc = nd_desc->ndctl(nd_desc, to_nvdimm(ndd->dev),
+				ND_CMD_GET_CONFIG_DATA, cmd,
+				cmd->in_length + sizeof(*cmd));
+		if (rc || cmd->status) {
+			rc = -ENXIO;
+			break;
+		}
+		memcpy(ndd->data + offset, cmd->out_buf, cmd->in_length);
+	}
+	dev_dbg(ndd->dev, "%s: len: %zu rc: %d\n", __func__, offset, rc);
+	kfree(cmd);
+
+	return rc;
+}
+
 static void nvdimm_release(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
@@ -111,14 +218,33 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 	dev_set_name(dev, "nmem%d", nvdimm->id);
 	dev->parent = &nvdimm_bus->dev;
 	dev->type = &nvdimm_device_type;
-	dev->bus = &nvdimm_bus_type;
 	dev->devt = MKDEV(nvdimm_major, nvdimm->id);
 	dev->groups = groups;
-	if (device_register(dev) != 0) {
-		put_device(dev);
-		return NULL;
-	}
+	nd_device_register(dev);
 
 	return nvdimm;
 }
 EXPORT_SYMBOL_GPL(nvdimm_create);
+
+static int count_dimms(struct device *dev, void *c)
+{
+	int *count = c;
+
+	if (is_nvdimm(dev))
+		(*count)++;
+	return 0;
+}
+
+int nvdimm_bus_check_dimm_count(struct nvdimm_bus *nvdimm_bus, int dimm_count)
+{
+	int count = 0;
+	/* Flush any possible dimm registration failures */
+	nd_synchronize();
+
+	device_for_each_child(&nvdimm_bus->dev, &count, count_dimms);
+	dev_dbg(&nvdimm_bus->dev, "%s: count: %d\n", __func__, count);
+	if (count != dimm_count)
+		return -ENXIO;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvdimm_bus_check_dimm_count);
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 59528b3c9de8..f2004b790874 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -17,7 +17,6 @@
 
 extern struct list_head nvdimm_bus_list;
 extern struct mutex nvdimm_bus_list_mutex;
-extern struct bus_type nvdimm_bus_type;
 extern int nvdimm_major;
 
 struct nvdimm_bus {
@@ -35,10 +34,11 @@ struct nvdimm {
 	int id;
 };
 
-bool is_nvdimm(struct device *dev);
 struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev);
 int __init nvdimm_bus_init(void);
-void __exit nvdimm_bus_exit(void);
+void nvdimm_bus_exit(void);
 int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus);
+void nd_synchronize(void);
+bool is_nvdimm(struct device *dev);
 #endif /* __ND_CORE_H__ */
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
new file mode 100644
index 000000000000..1f7f6ecab0fc
--- /dev/null
+++ b/drivers/nvdimm/nd.h
@@ -0,0 +1,36 @@
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
+struct nvdimm_drvdata {
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
+int __init nvdimm_init(void);
+void nvdimm_exit(void);
+int nvdimm_init_nsarea(struct nvdimm_drvdata *ndd);
+int nvdimm_init_config_data(struct nvdimm_drvdata *ndd);
+#endif /* __ND_H__ */
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index a39235819af3..d3ebccf4ea8b 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -30,6 +30,7 @@ enum {
 
 extern struct attribute_group nvdimm_bus_attribute_group;
 extern struct attribute_group nvdimm_attribute_group;
+extern struct attribute_group nd_device_attribute_group;
 
 struct nvdimm;
 struct nvdimm_bus_descriptor;
@@ -71,4 +72,5 @@ u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,
 u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
 		const struct nd_cmd_desc *desc, int idx, const u32 *in_field,
 		const u32 *out_field);
+int nvdimm_bus_check_dimm_count(struct nvdimm_bus *nvdimm_bus, int dimm_count);
 #endif /* __LIBNVDIMM_H__ */
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
index ff13c23b26df..37640916d146 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -175,4 +175,10 @@ static inline const char *nvdimm_cmd_name(unsigned cmd)
 #define ND_IOCTL_ARS_STATUS		_IOWR(ND_IOCTL, ND_CMD_ARS_STATUS,\
 					struct nd_cmd_ars_status)
 
+
+#define ND_DEVICE_DIMM 1            /* nd_dimm: container for "config data" */
+
+enum nd_driver_flags {
+	ND_DRIVER_DIMM            = 1 << ND_DEVICE_DIMM,
+};
 #endif /* __NDCTL_H__ */

