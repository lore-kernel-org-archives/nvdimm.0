Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 05/20] libnd, nd_acpi: dimm/memory-devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Apr 2015 14:24:39 -0400
Message-ID: <20150428182439.35812.81191.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Register the memory devices described in the nfit as libnd 'dimm'
devices on an nd bus.  The kernel assigned device id for dimms is
dynamic.  If userspace needs a more static identifier it should consult
a provider-specific attribute.  In the case where NFIT is the provider,
the 'nmemX/nfit/handle' or 'nmemX/nfit/serial' attributes may be used
for this purpose.

Cc: Neil Brown <neilb@suse.de>
Cc: <linux-acpi@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/Makefile     |    1 
 drivers/block/nd/acpi.c       |  160 +++++++++++++++++++++++++++++++++++++++++
 drivers/block/nd/acpi_nfit.h  |    1 
 drivers/block/nd/bus.c        |   14 +++-
 drivers/block/nd/core.c       |   29 +++++++
 drivers/block/nd/dimm_devs.c  |   92 ++++++++++++++++++++++++
 drivers/block/nd/libnd.h      |   11 +++
 drivers/block/nd/nd-private.h |   12 +++
 8 files changed, 318 insertions(+), 2 deletions(-)
 create mode 100644 drivers/block/nd/dimm_devs.c

diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
index 7defe18ed009..35e4c1a7a8ff 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -20,3 +20,4 @@ nd_acpi-y := acpi.o
 
 libnd-y := core.o
 libnd-y += bus.o
+libnd-y += dimm_devs.o
diff --git a/drivers/block/nd/acpi.c b/drivers/block/nd/acpi.c
index dd8505f766ed..af6684341c9b 100644
--- a/drivers/block/nd/acpi.c
+++ b/drivers/block/nd/acpi.c
@@ -369,6 +369,164 @@ const struct attribute_group *nd_acpi_attribute_groups[] = {
 };
 EXPORT_SYMBOL_GPL(nd_acpi_attribute_groups);
 
+static struct acpi_nfit_memdev *to_nfit_memdev(struct device *dev)
+{
+	struct nd_dimm *nd_dimm = to_nd_dimm(dev);
+	struct nfit_mem *nfit_mem = nd_dimm_provider_data(nd_dimm);
+
+	return __to_nfit_memdev(nfit_mem);
+}
+
+static struct acpi_nfit_dcr *to_nfit_dcr(struct device *dev)
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
+	struct acpi_nfit_memdev *memdev = to_nfit_memdev(dev);
+
+	return sprintf(buf, "%#x\n", memdev->nfit_handle);
+}
+static DEVICE_ATTR_RO(handle);
+
+static ssize_t phys_id_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_memdev *memdev = to_nfit_memdev(dev);
+
+	return sprintf(buf, "%#x\n", memdev->phys_id);
+}
+static DEVICE_ATTR_RO(phys_id);
+
+static ssize_t vendor_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_dcr *dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "%#x\n", dcr->vendor_id);
+}
+static DEVICE_ATTR_RO(vendor);
+
+static ssize_t rev_id_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_dcr *dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "%#x\n", dcr->revision_id);
+}
+static DEVICE_ATTR_RO(rev_id);
+
+static ssize_t device_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_dcr *dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "%#x\n", dcr->device_id);
+}
+static DEVICE_ATTR_RO(device);
+
+static ssize_t format_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_dcr *dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "%#x\n", dcr->fic);
+}
+static DEVICE_ATTR_RO(format);
+
+static ssize_t serial_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_dcr *dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "%#x\n", dcr->serial_number);
+}
+static DEVICE_ATTR_RO(serial);
+
+static struct attribute *nd_acpi_dimm_attributes[] = {
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
+static umode_t nd_acpi_dimm_attr_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+
+	if (to_nfit_dcr(dev))
+		return a->mode;
+	else
+		return 0;
+}
+
+static struct attribute_group nd_acpi_dimm_attribute_group = {
+	.name = "nfit",
+	.attrs = nd_acpi_dimm_attributes,
+	.is_visible = nd_acpi_dimm_attr_visible,
+};
+
+static const struct attribute_group *nd_acpi_dimm_attribute_groups[] = {
+	&nd_acpi_dimm_attribute_group,
+	NULL,
+};
+
+static struct nd_dimm *nd_acpi_dimm_by_handle(struct acpi_nfit_desc *acpi_desc,
+		u32 nfit_handle)
+{
+	struct nfit_mem *nfit_mem;
+
+	list_for_each_entry(nfit_mem, &acpi_desc->dimms, list)
+		if (__to_nfit_memdev(nfit_mem)->nfit_handle == nfit_handle)
+			return nfit_mem->nd_dimm;
+
+	return NULL;
+}
+
+static int nd_acpi_register_dimms(struct acpi_nfit_desc *acpi_desc)
+{
+	struct nfit_mem *nfit_mem;
+
+	list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
+		struct nd_dimm *nd_dimm;
+		unsigned long flags = 0;
+		u32 nfit_handle;
+
+		nfit_handle = __to_nfit_memdev(nfit_mem)->nfit_handle;
+		nd_dimm = nd_acpi_dimm_by_handle(acpi_desc, nfit_handle);
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
+				nd_acpi_dimm_attribute_groups, flags);
+		if (!nd_dimm)
+			return -ENOMEM;
+
+		nfit_mem->nd_dimm = nd_dimm;
+	}
+
+	return 0;
+}
+
 int nd_acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 {
 	struct device *dev = acpi_desc->dev;
@@ -406,7 +564,7 @@ int nd_acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 	if (nfit_mem_init(acpi_desc) != 0)
 		return -ENOMEM;
 
-	return 0;
+	return nd_acpi_register_dimms(acpi_desc);
 }
 EXPORT_SYMBOL_GPL(nd_acpi_nfit_init);
 
diff --git a/drivers/block/nd/acpi_nfit.h b/drivers/block/nd/acpi_nfit.h
index b65745ca3cbc..00aaaee5953b 100644
--- a/drivers/block/nd/acpi_nfit.h
+++ b/drivers/block/nd/acpi_nfit.h
@@ -233,6 +233,7 @@ struct nfit_memdev {
 
 /* assembled tables for a given dimm/memory-device */
 struct nfit_mem {
+	struct nd_dimm *nd_dimm;
 	struct acpi_nfit_memdev *memdev_dcr;
 	struct acpi_nfit_memdev *memdev_pmem;
 	struct acpi_nfit_dcr *dcr;
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
index 55603ff264ff..24046db897c1 100644
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
diff --git a/drivers/block/nd/libnd.h b/drivers/block/nd/libnd.h
index 86cf3e0573b0..4f8f2ebbcf7b 100644
--- a/drivers/block/nd/libnd.h
+++ b/drivers/block/nd/libnd.h
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
@@ -34,5 +40,10 @@ struct nd_bus *nd_bus_register(struct device *parent,
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
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index 960dd2f29cdd..cfb5a7241ed1 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -15,6 +15,10 @@
 #include <linux/device.h>
 #include "libnd.h"
 
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

