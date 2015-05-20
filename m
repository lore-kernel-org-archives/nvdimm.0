Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 04/21] libnd, nfit: dimm/memory-devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 May 2015 16:56:32 -0400
Message-ID: <20150520205632.32249.3607.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: mingo@kernel.org, linux-nvdimm@lists.01.org, neilb@suse.de, gregkh@linuxfoundation.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Enable dimm devices to be registered on a libnd bus.  The kernel
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
 drivers/acpi/nfit.c           |  160 +++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit.h           |    1 
 drivers/block/nd/Makefile     |    1 
 drivers/block/nd/bus.c        |   14 +++-
 drivers/block/nd/core.c       |   29 +++++++
 drivers/block/nd/dimm_devs.c  |   92 ++++++++++++++++++++++++
 drivers/block/nd/nd-private.h |   12 +++
 include/linux/libnd.h         |   11 +++
 8 files changed, 318 insertions(+), 2 deletions(-)
 create mode 100644 drivers/block/nd/dimm_devs.c

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index d31a0fffafcc..b26e1a4a59e3 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -344,6 +344,164 @@ const struct attribute_group *acpi_nfit_attribute_groups[] = {
 };
 EXPORT_SYMBOL_GPL(acpi_nfit_attribute_groups);
 
+static struct acpi_nfit_memory_map *to_nfit_memdev(struct device *dev)
+{
+	struct nd_dimm *nd_dimm = to_nd_dimm(dev);
+	struct nfit_mem *nfit_mem = nd_dimm_provider_data(nd_dimm);
+
+	return __to_nfit_memdev(nfit_mem);
+}
+
+static struct acpi_nfit_control_region *to_nfit_dcr(struct device *dev)
+{
+	struct nd_dimm *nd_dimm = to_nd_dimm(dev);
+	struct nfit_mem *nfit_mem = nd_dimm_provider_data(nd_dimm);
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
+static struct nd_dimm *acpi_nfit_dimm_by_handle(struct acpi_nfit_desc *acpi_desc,
+		u32 device_handle)
+{
+	struct nfit_mem *nfit_mem;
+
+	list_for_each_entry(nfit_mem, &acpi_desc->dimms, list)
+		if (__to_nfit_memdev(nfit_mem)->device_handle == device_handle)
+			return nfit_mem->nd_dimm;
+
+	return NULL;
+}
+
+static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
+{
+	struct nfit_mem *nfit_mem;
+
+	list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
+		struct nd_dimm *nd_dimm;
+		unsigned long flags = 0;
+		u32 device_handle;
+
+		device_handle = __to_nfit_memdev(nfit_mem)->device_handle;
+		nd_dimm = acpi_nfit_dimm_by_handle(acpi_desc, device_handle);
+		if (nd_dimm) {
+			/*
+			 * If for some reason we find multiple DCRs the
+			 * first one wins
+			 */
+			dev_err(acpi_desc->dev, "duplicate DCR detected: %s\n",
+					nd_dimm_name(nd_dimm));
+			continue;
+		}
+
+		if (nfit_mem->bdw && nfit_mem->memdev_pmem)
+			flags |= NDD_ALIASING;
+
+		nd_dimm = nd_dimm_create(acpi_desc->nd_bus, nfit_mem,
+				acpi_nfit_dimm_attribute_groups, flags);
+		if (!nd_dimm)
+			return -ENOMEM;
+
+		nfit_mem->nd_dimm = nd_dimm;
+	}
+
+	return 0;
+}
+
 static int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 {
 	struct device *dev = acpi_desc->dev;
@@ -371,7 +529,7 @@ static int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 	if (nfit_mem_init(acpi_desc) != 0)
 		return -ENOMEM;
 
-	return 0;
+	return acpi_nfit_register_dimms(acpi_desc);
 }
 
 static int acpi_nfit_add(struct acpi_device *adev)
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index b6c85d773ca1..9d4c1634cb0e 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -59,6 +59,7 @@ struct nfit_memdev {
 
 /* assembled tables for a given dimm/memory-device */
 struct nfit_mem {
+	struct nd_dimm *nd_dimm;
 	struct acpi_nfit_memory_map *memdev_dcr;
 	struct acpi_nfit_memory_map *memdev_pmem;
 	struct acpi_nfit_control_region *dcr;
diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
index 34d1b58b3258..2954b9543bec 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_LIBND) += libnd.o
 
 libnd-y := core.o
 libnd-y += bus.o
+libnd-y += dimm_devs.o
diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
index 635f2e926426..ee56aa1ab2ad 100644
--- a/drivers/block/nd/bus.c
+++ b/drivers/block/nd/bus.c
@@ -13,6 +13,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/uaccess.h>
 #include <linux/fcntl.h>
+#include <linux/async.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/io.h>
@@ -21,6 +22,10 @@
 static int nd_bus_major;
 static struct class *nd_class;
 
+struct bus_type nd_bus_type = {
+	.name = "nd",
+};
+
 int nd_bus_create_ndctl(struct nd_bus *nd_bus)
 {
 	dev_t devt = MKDEV(nd_bus_major, nd_bus->id);
@@ -59,9 +64,13 @@ int __init nd_bus_init(void)
 {
 	int rc;
 
+	rc = bus_register(&nd_bus_type);
+	if (rc)
+		return rc;
+
 	rc = register_chrdev(0, "ndctl", &nd_bus_fops);
 	if (rc < 0)
-		return rc;
+		goto err_chrdev;
 	nd_bus_major = rc;
 
 	nd_class = class_create(THIS_MODULE, "nd");
@@ -72,6 +81,8 @@ int __init nd_bus_init(void)
 
  err_class:
 	unregister_chrdev(nd_bus_major, "ndctl");
+ err_chrdev:
+	bus_unregister(&nd_bus_type);
 
 	return rc;
 }
@@ -80,4 +91,5 @@ void __exit nd_bus_exit(void)
 {
 	class_destroy(nd_class);
 	unregister_chrdev(nd_bus_major, "ndctl");
+	bus_unregister(&nd_bus_type);
 }
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
index 49b7ac8f7606..4d0e53ecdcb0 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -46,6 +46,19 @@ struct nd_bus_descriptor *to_nd_desc(struct nd_bus *nd_bus)
 }
 EXPORT_SYMBOL_GPL(to_nd_desc);
 
+struct nd_bus *walk_to_nd_bus(struct device *nd_dev)
+{
+	struct device *dev;
+
+	for (dev = nd_dev; dev; dev = dev->parent)
+		if (dev->release == nd_bus_release)
+			break;
+	dev_WARN_ONCE(nd_dev, !dev, "invalid dev, not on nd bus\n");
+	if (dev)
+		return to_nd_bus(dev);
+	return NULL;
+}
+
 static const char *nd_bus_provider(struct nd_bus *nd_bus)
 {
 	struct nd_bus_descriptor *nd_desc = nd_bus->nd_desc;
@@ -118,6 +131,21 @@ struct nd_bus *nd_bus_register(struct device *parent,
 }
 EXPORT_SYMBOL_GPL(nd_bus_register);
 
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
 void nd_bus_unregister(struct nd_bus *nd_bus)
 {
 	if (!nd_bus)
@@ -127,6 +155,7 @@ void nd_bus_unregister(struct nd_bus *nd_bus)
 	list_del_init(&nd_bus->list);
 	mutex_unlock(&nd_bus_list_mutex);
 
+	device_for_each_child(&nd_bus->dev, NULL, child_unregister);
 	nd_bus_destroy_ndctl(nd_bus);
 
 	device_unregister(&nd_bus->dev);
diff --git a/drivers/block/nd/dimm_devs.c b/drivers/block/nd/dimm_devs.c
new file mode 100644
index 000000000000..19b081392f2f
--- /dev/null
+++ b/drivers/block/nd/dimm_devs.c
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
+static void nd_dimm_release(struct device *dev)
+{
+	struct nd_dimm *nd_dimm = to_nd_dimm(dev);
+
+	ida_simple_remove(&dimm_ida, nd_dimm->id);
+	kfree(nd_dimm);
+}
+
+static struct device_type nd_dimm_device_type = {
+	.name = "nd_dimm",
+	.release = nd_dimm_release,
+};
+
+static bool is_nd_dimm(struct device *dev)
+{
+	return dev->type == &nd_dimm_device_type;
+}
+
+struct nd_dimm *to_nd_dimm(struct device *dev)
+{
+	struct nd_dimm *nd_dimm = container_of(dev, struct nd_dimm, dev);
+
+	WARN_ON(!is_nd_dimm(dev));
+	return nd_dimm;
+}
+EXPORT_SYMBOL_GPL(to_nd_dimm);
+
+const char *nd_dimm_name(struct nd_dimm *nd_dimm)
+{
+	return dev_name(&nd_dimm->dev);
+}
+EXPORT_SYMBOL_GPL(nd_dimm_name);
+
+void *nd_dimm_provider_data(struct nd_dimm *nd_dimm)
+{
+	return nd_dimm->provider_data;
+}
+EXPORT_SYMBOL_GPL(nd_dimm_provider_data);
+
+struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus, void *provider_data,
+		const struct attribute_group **groups, unsigned long flags)
+{
+	struct nd_dimm *nd_dimm = kzalloc(sizeof(*nd_dimm), GFP_KERNEL);
+	struct device *dev;
+
+	if (!nd_dimm)
+		return NULL;
+
+	nd_dimm->id = ida_simple_get(&dimm_ida, 0, 0, GFP_KERNEL);
+	if (nd_dimm->id < 0) {
+		kfree(nd_dimm);
+		return NULL;
+	}
+	nd_dimm->provider_data = provider_data;
+	nd_dimm->flags = flags;
+
+	dev = &nd_dimm->dev;
+	dev_set_name(dev, "nmem%d", nd_dimm->id);
+	dev->parent = &nd_bus->dev;
+	dev->type = &nd_dimm_device_type;
+	dev->bus = &nd_bus_type;
+	dev->groups = groups;
+	if (device_register(dev) != 0) {
+		put_device(dev);
+		return NULL;
+	}
+
+	return nd_dimm;
+}
+EXPORT_SYMBOL_GPL(nd_dimm_create);
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index 884601f65a15..251ecdd77153 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -15,6 +15,10 @@
 #include <linux/device.h>
 #include <linux/libnd.h>
 
+extern struct list_head nd_bus_list;
+extern struct mutex nd_bus_list_mutex;
+extern struct bus_type nd_bus_type;
+
 struct nd_bus {
 	struct nd_bus_descriptor *nd_desc;
 	struct list_head list;
@@ -22,6 +26,14 @@ struct nd_bus {
 	int id;
 };
 
+struct nd_dimm {
+	unsigned long flags;
+	void *provider_data;
+	struct device dev;
+	int id;
+};
+
+struct nd_bus *walk_to_nd_bus(struct device *nd_dev);
 int __init nd_bus_init(void);
 void __exit nd_bus_exit(void);
 int nd_bus_create_ndctl(struct nd_bus *nd_bus);
diff --git a/include/linux/libnd.h b/include/linux/libnd.h
index 04a97653d56c..76d5839fb50e 100644
--- a/include/linux/libnd.h
+++ b/include/linux/libnd.h
@@ -14,6 +14,12 @@
  */
 #ifndef __LIBND_H__
 #define __LIBND_H__
+
+enum {
+	/* when a dimm supports both PMEM and BLK access a label is required */
+	NDD_ALIASING = 1 << 0,
+};
+
 extern struct attribute_group nd_bus_attribute_group;
 
 struct nd_dimm;
@@ -35,5 +41,10 @@ struct nd_bus *nd_bus_register(struct device *parent,
 		struct nd_bus_descriptor *nfit_desc);
 void nd_bus_unregister(struct nd_bus *nd_bus);
 struct nd_bus *to_nd_bus(struct device *dev);
+struct nd_dimm *to_nd_dimm(struct device *dev);
 struct nd_bus_descriptor *to_nd_desc(struct nd_bus *nd_bus);
+const char *nd_dimm_name(struct nd_dimm *nd_dimm);
+void *nd_dimm_provider_data(struct nd_dimm *nd_dimm);
+struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus, void *provider_data,
+		const struct attribute_group **groups, unsigned long flags);
 #endif /* __LIBND_H__ */

