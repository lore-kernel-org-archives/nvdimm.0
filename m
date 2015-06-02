Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v5 04/21] libnvdimm, nfit: dimm/memory-devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 01 Jun 2015 20:14:30 -0400
Message-ID: <20150602001430.4506.23525.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Enable dimm devices to be registered on a libnvdimm bus.  The kernel
assigned device id for dimms is dynamic.  If userspace needs a more
static identifier it should consult a provider-specific attribute.  In
the case where NFIT is the provider, the 'nmemX/nfit/handle' or
'nmemX/nfit/serial' attributes may be used for this purpose.

Cc: Neil Brown <neilb@suse.de>
Cc: <linux-acpi@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c         |  160 +++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit.h         |    1 
 drivers/nvdimm/Makefile     |    1 
 drivers/nvdimm/bus.c        |   14 +++-
 drivers/nvdimm/core.c       |   33 ++++++++-
 drivers/nvdimm/dimm_devs.c  |   92 +++++++++++++++++++++++++
 drivers/nvdimm/nd-private.h |   12 +++
 include/linux/libnvdimm.h   |   11 +++
 8 files changed, 320 insertions(+), 4 deletions(-)
 create mode 100644 drivers/nvdimm/dimm_devs.c

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index ec228ab336b3..a17678b7d74a 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -343,6 +343,164 @@ static const struct attribute_group *acpi_nfit_attribute_groups[] = {
 	NULL,
 };
 
+static struct acpi_nfit_memory_map *to_nfit_memdev(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+
+	return __to_nfit_memdev(nfit_mem);
+}
+
+static struct acpi_nfit_control_region *to_nfit_dcr(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+
+	return nfit_mem->dcr;
+}
+
+static ssize_t handle_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_memory_map *memdev = to_nfit_memdev(dev);
+
+	return sprintf(buf, "%#x\n", memdev->device_handle);
+}
+static DEVICE_ATTR_RO(handle);
+
+static ssize_t phys_id_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_memory_map *memdev = to_nfit_memdev(dev);
+
+	return sprintf(buf, "%#x\n", memdev->physical_id);
+}
+static DEVICE_ATTR_RO(phys_id);
+
+static ssize_t vendor_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "%#x\n", dcr->vendor_id);
+}
+static DEVICE_ATTR_RO(vendor);
+
+static ssize_t rev_id_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "%#x\n", dcr->revision_id);
+}
+static DEVICE_ATTR_RO(rev_id);
+
+static ssize_t device_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "%#x\n", dcr->device_id);
+}
+static DEVICE_ATTR_RO(device);
+
+static ssize_t format_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "%#x\n", dcr->code);
+}
+static DEVICE_ATTR_RO(format);
+
+static ssize_t serial_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "%#x\n", dcr->serial_number);
+}
+static DEVICE_ATTR_RO(serial);
+
+static struct attribute *acpi_nfit_dimm_attributes[] = {
+	&dev_attr_handle.attr,
+	&dev_attr_phys_id.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_device.attr,
+	&dev_attr_format.attr,
+	&dev_attr_serial.attr,
+	&dev_attr_rev_id.attr,
+	NULL,
+};
+
+static umode_t acpi_nfit_dimm_attr_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+
+	if (to_nfit_dcr(dev))
+		return a->mode;
+	else
+		return 0;
+}
+
+static struct attribute_group acpi_nfit_dimm_attribute_group = {
+	.name = "nfit",
+	.attrs = acpi_nfit_dimm_attributes,
+	.is_visible = acpi_nfit_dimm_attr_visible,
+};
+
+static const struct attribute_group *acpi_nfit_dimm_attribute_groups[] = {
+	&acpi_nfit_dimm_attribute_group,
+	NULL,
+};
+
+static struct nvdimm *acpi_nfit_dimm_by_handle(struct acpi_nfit_desc *acpi_desc,
+		u32 device_handle)
+{
+	struct nfit_mem *nfit_mem;
+
+	list_for_each_entry(nfit_mem, &acpi_desc->dimms, list)
+		if (__to_nfit_memdev(nfit_mem)->device_handle == device_handle)
+			return nfit_mem->nvdimm;
+
+	return NULL;
+}
+
+static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
+{
+	struct nfit_mem *nfit_mem;
+
+	list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
+		struct nvdimm *nvdimm;
+		unsigned long flags = 0;
+		u32 device_handle;
+
+		device_handle = __to_nfit_memdev(nfit_mem)->device_handle;
+		nvdimm = acpi_nfit_dimm_by_handle(acpi_desc, device_handle);
+		if (nvdimm) {
+			/*
+			 * If for some reason we find multiple DCRs the
+			 * first one wins
+			 */
+			dev_err(acpi_desc->dev, "duplicate DCR detected: %s\n",
+					nvdimm_name(nvdimm));
+			continue;
+		}
+
+		if (nfit_mem->bdw && nfit_mem->memdev_pmem)
+			flags |= NDD_ALIASING;
+
+		nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
+				acpi_nfit_dimm_attribute_groups, flags);
+		if (!nvdimm)
+			return -ENOMEM;
+
+		nfit_mem->nvdimm = nvdimm;
+	}
+
+	return 0;
+}
+
 static int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 {
 	struct device *dev = acpi_desc->dev;
@@ -370,7 +528,7 @@ static int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 	if (nfit_mem_init(acpi_desc) != 0)
 		return -ENOMEM;
 
-	return 0;
+	return acpi_nfit_register_dimms(acpi_desc);
 }
 
 static int acpi_nfit_add(struct acpi_device *adev)
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 735e463edbf7..5f1bd10053ce 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -59,6 +59,7 @@ struct nfit_memdev {
 
 /* assembled tables for a given dimm/memory-device */
 struct nfit_mem {
+	struct nvdimm *nvdimm;
 	struct acpi_nfit_memory_map *memdev_dcr;
 	struct acpi_nfit_memory_map *memdev_pmem;
 	struct acpi_nfit_control_region *dcr;
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index 8a8293c72c7c..5b68738ba406 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_LIBNVDIMM) += libnvdimm.o
 
 libnvdimm-y := core.o
 libnvdimm-y += bus.o
+libnvdimm-y += dimm_devs.o
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 312caef5b0e9..a368076c6729 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -13,6 +13,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/uaccess.h>
 #include <linux/fcntl.h>
+#include <linux/async.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/io.h>
@@ -21,6 +22,10 @@
 static int nvdimm_bus_major;
 static struct class *nd_class;
 
+struct bus_type nvdimm_bus_type = {
+	.name = "nd",
+};
+
 int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus)
 {
 	dev_t devt = MKDEV(nvdimm_bus_major, nvdimm_bus->id);
@@ -59,9 +64,13 @@ int __init nvdimm_bus_init(void)
 {
 	int rc;
 
+	rc = bus_register(&nvdimm_bus_type);
+	if (rc)
+		return rc;
+
 	rc = register_chrdev(0, "ndctl", &nvdimm_bus_fops);
 	if (rc < 0)
-		return rc;
+		goto err_chrdev;
 	nvdimm_bus_major = rc;
 
 	nd_class = class_create(THIS_MODULE, "nd");
@@ -72,6 +81,8 @@ int __init nvdimm_bus_init(void)
 
  err_class:
 	unregister_chrdev(nvdimm_bus_major, "ndctl");
+ err_chrdev:
+	bus_unregister(&nvdimm_bus_type);
 
 	return rc;
 }
@@ -80,4 +91,5 @@ void __exit nvdimm_bus_exit(void)
 {
 	class_destroy(nd_class);
 	unregister_chrdev(nvdimm_bus_major, "ndctl");
+	bus_unregister(&nvdimm_bus_type);
 }
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 86b4da096de1..45c916fe72dc 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -18,8 +18,8 @@
 #include <linux/slab.h>
 #include "nd-private.h"
 
-static LIST_HEAD(nvdimm_bus_list);
-static DEFINE_MUTEX(nvdimm_bus_list_mutex);
+LIST_HEAD(nvdimm_bus_list);
+DEFINE_MUTEX(nvdimm_bus_list_mutex);
 static DEFINE_IDA(nd_ida);
 
 static void nvdimm_bus_release(struct device *dev)
@@ -46,6 +46,19 @@ struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus)
 }
 EXPORT_SYMBOL_GPL(to_nd_desc);
 
+struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev)
+{
+	struct device *dev;
+
+	for (dev = nd_dev; dev; dev = dev->parent)
+		if (dev->release == nvdimm_bus_release)
+			break;
+	dev_WARN_ONCE(nd_dev, !dev, "invalid dev, not on nd bus\n");
+	if (dev)
+		return to_nvdimm_bus(dev);
+	return NULL;
+}
+
 static const char *nvdimm_bus_provider(struct nvdimm_bus *nvdimm_bus)
 {
 	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
@@ -118,6 +131,21 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 }
 EXPORT_SYMBOL_GPL(nvdimm_bus_register);
 
+static int child_unregister(struct device *dev, void *data)
+{
+	/*
+	 * the singular ndctl class device per bus needs to be
+	 * "device_destroy"ed, so skip it here
+	 *
+	 * i.e. remove classless children
+	 */
+	if (dev->class)
+		/* pass */;
+	else
+		device_unregister(dev);
+	return 0;
+}
+
 void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus)
 {
 	if (!nvdimm_bus)
@@ -127,6 +155,7 @@ void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus)
 	list_del_init(&nvdimm_bus->list);
 	mutex_unlock(&nvdimm_bus_list_mutex);
 
+	device_for_each_child(&nvdimm_bus->dev, NULL, child_unregister);
 	nvdimm_bus_destroy_ndctl(nvdimm_bus);
 
 	device_unregister(&nvdimm_bus->dev);
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
new file mode 100644
index 000000000000..8246a629f813
--- /dev/null
+++ b/drivers/nvdimm/dimm_devs.c
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
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include "nd-private.h"
+
+static DEFINE_IDA(dimm_ida);
+
+static void nvdimm_release(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	ida_simple_remove(&dimm_ida, nvdimm->id);
+	kfree(nvdimm);
+}
+
+static struct device_type nvdimm_device_type = {
+	.name = "nvdimm",
+	.release = nvdimm_release,
+};
+
+static bool is_nvdimm(struct device *dev)
+{
+	return dev->type == &nvdimm_device_type;
+}
+
+struct nvdimm *to_nvdimm(struct device *dev)
+{
+	struct nvdimm *nvdimm = container_of(dev, struct nvdimm, dev);
+
+	WARN_ON(!is_nvdimm(dev));
+	return nvdimm;
+}
+EXPORT_SYMBOL_GPL(to_nvdimm);
+
+const char *nvdimm_name(struct nvdimm *nvdimm)
+{
+	return dev_name(&nvdimm->dev);
+}
+EXPORT_SYMBOL_GPL(nvdimm_name);
+
+void *nvdimm_provider_data(struct nvdimm *nvdimm)
+{
+	return nvdimm->provider_data;
+}
+EXPORT_SYMBOL_GPL(nvdimm_provider_data);
+
+struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
+		const struct attribute_group **groups, unsigned long flags)
+{
+	struct nvdimm *nvdimm = kzalloc(sizeof(*nvdimm), GFP_KERNEL);
+	struct device *dev;
+
+	if (!nvdimm)
+		return NULL;
+
+	nvdimm->id = ida_simple_get(&dimm_ida, 0, 0, GFP_KERNEL);
+	if (nvdimm->id < 0) {
+		kfree(nvdimm);
+		return NULL;
+	}
+	nvdimm->provider_data = provider_data;
+	nvdimm->flags = flags;
+
+	dev = &nvdimm->dev;
+	dev_set_name(dev, "nmem%d", nvdimm->id);
+	dev->parent = &nvdimm_bus->dev;
+	dev->type = &nvdimm_device_type;
+	dev->bus = &nvdimm_bus_type;
+	dev->groups = groups;
+	if (device_register(dev) != 0) {
+		put_device(dev);
+		return NULL;
+	}
+
+	return nvdimm;
+}
+EXPORT_SYMBOL_GPL(nvdimm_create);
diff --git a/drivers/nvdimm/nd-private.h b/drivers/nvdimm/nd-private.h
index f31fc3396683..f64202747fb7 100644
--- a/drivers/nvdimm/nd-private.h
+++ b/drivers/nvdimm/nd-private.h
@@ -15,6 +15,10 @@
 #include <linux/libnvdimm.h>
 #include <linux/device.h>
 
+extern struct list_head nvdimm_bus_list;
+extern struct mutex nvdimm_bus_list_mutex;
+extern struct bus_type nvdimm_bus_type;
+
 struct nvdimm_bus {
 	struct nvdimm_bus_descriptor *nd_desc;
 	struct list_head list;
@@ -22,6 +26,14 @@ struct nvdimm_bus {
 	int id;
 };
 
+struct nvdimm {
+	unsigned long flags;
+	void *provider_data;
+	struct device dev;
+	int id;
+};
+
+struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev);
 int __init nvdimm_bus_init(void);
 void __exit nvdimm_bus_exit(void);
 int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index d375cdc4abd5..07787f0dd7de 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -14,6 +14,12 @@
  */
 #ifndef __LIBNVDIMM_H__
 #define __LIBNVDIMM_H__
+
+enum {
+	/* when a dimm supports both PMEM and BLK access a label is required */
+	NDD_ALIASING = 1 << 0,
+};
+
 extern struct attribute_group nvdimm_bus_attribute_group;
 
 struct nvdimm;
@@ -34,5 +40,10 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 		struct nvdimm_bus_descriptor *nfit_desc);
 void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus);
 struct nvdimm_bus *to_nvdimm_bus(struct device *dev);
+struct nvdimm *to_nvdimm(struct device *dev);
 struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus);
+const char *nvdimm_name(struct nvdimm *nvdimm);
+void *nvdimm_provider_data(struct nvdimm *nvdimm);
+struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
+		const struct attribute_group **groups, unsigned long flags);
 #endif /* __LIBNVDIMM_H__ */

