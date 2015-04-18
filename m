Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 07/21] nd: dimm devices (nfit "memory-devices")
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Apr 2015 21:35:52 -0400
Message-ID: <20150418013551.25237.76215.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Register the dimms described in the nfit as devices on a nd_bus, named
"dimmN" where N is a global ida index.  The dimm numbering per-bus may
appear contiguous, since we only allow a single nd_bus to be registered
at at a time.  However, eventually, dimm-hotplug invalidates this
property and dimms should be addressed via NFIT-handle.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/Makefile     |    1 
 drivers/block/nd/bus.c        |   62 +++++++++-
 drivers/block/nd/core.c       |   55 +++++++++
 drivers/block/nd/dimm_devs.c  |  243 +++++++++++++++++++++++++++++++++++++++++
 drivers/block/nd/nd-private.h |   19 +++
 5 files changed, 373 insertions(+), 7 deletions(-)
 create mode 100644 drivers/block/nd/dimm_devs.c

diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
index 7772fb599809..6b34dd4d4df8 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -21,3 +21,4 @@ nd_acpi-y := acpi.o
 
 nd-y := core.o
 nd-y += bus.o
+nd-y += dimm_devs.o
diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
index c27db50511f2..e24db67001d0 100644
--- a/drivers/block/nd/bus.c
+++ b/drivers/block/nd/bus.c
@@ -13,18 +13,59 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/uaccess.h>
 #include <linux/fcntl.h>
+#include <linux/async.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/io.h>
 #include "nd-private.h"
 #include "nfit.h"
 
-static int nd_major;
+static int nd_bus_major;
 static struct class *nd_class;
 
+struct bus_type nd_bus_type = {
+	.name = "nd",
+};
+
+static ASYNC_DOMAIN_EXCLUSIVE(nd_async_domain);
+
+static void nd_async_dimm_delete(void *d, async_cookie_t cookie)
+{
+	u32 nfit_handle;
+	struct nd_dimm_delete *del_info = d;
+	struct nd_bus *nd_bus = del_info->nd_bus;
+	struct nd_mem *nd_mem = del_info->nd_mem;
+
+	nfit_handle = readl(&nd_mem->nfit_mem_dcr->nfit_handle);
+
+	mutex_lock(&nd_bus_list_mutex);
+	radix_tree_delete(&nd_bus->dimm_radix, nfit_handle);
+	mutex_unlock(&nd_bus_list_mutex);
+
+	put_device(&nd_bus->dev);
+	kfree(del_info);
+}
+
+void nd_dimm_delete(struct nd_dimm *nd_dimm)
+{
+	struct nd_bus *nd_bus = walk_to_nd_bus(&nd_dimm->dev);
+	struct nd_dimm_delete *del_info = nd_dimm->del_info;
+
+	del_info->nd_bus = nd_bus;
+	get_device(&nd_bus->dev);
+	del_info->nd_mem = nd_dimm->nd_mem;
+	async_schedule_domain(nd_async_dimm_delete, del_info,
+			&nd_async_domain);
+}
+
+void nd_synchronize(void)
+{
+	async_synchronize_full_domain(&nd_async_domain);
+}
+
 int nd_bus_create_ndctl(struct nd_bus *nd_bus)
 {
-	dev_t devt = MKDEV(nd_major, nd_bus->id);
+	dev_t devt = MKDEV(nd_bus_major, nd_bus->id);
 	struct device *dev;
 
 	dev = device_create(nd_class, &nd_bus->dev, devt, nd_bus, "ndctl%d",
@@ -40,7 +81,7 @@ int nd_bus_create_ndctl(struct nd_bus *nd_bus)
 
 void nd_bus_destroy_ndctl(struct nd_bus *nd_bus)
 {
-	device_destroy(nd_class, MKDEV(nd_major, nd_bus->id));
+	device_destroy(nd_class, MKDEV(nd_bus_major, nd_bus->id));
 }
 
 static long nd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
@@ -60,10 +101,14 @@ int __init nd_bus_init(void)
 {
 	int rc;
 
+	rc = bus_register(&nd_bus_type);
+	if (rc)
+		return rc;
+
 	rc = register_chrdev(0, "ndctl", &nd_bus_fops);
 	if (rc < 0)
-		return rc;
-	nd_major = rc;
+		goto err_chrdev;
+	nd_bus_major = rc;
 
 	nd_class = class_create(THIS_MODULE, "nd");
 	if (IS_ERR(nd_class))
@@ -72,7 +117,9 @@ int __init nd_bus_init(void)
 	return 0;
 
  err_class:
-	unregister_chrdev(nd_major, "ndctl");
+	unregister_chrdev(nd_bus_major, "ndctl");
+ err_chrdev:
+	bus_unregister(&nd_bus_type);
 
 	return rc;
 }
@@ -80,5 +127,6 @@ int __init nd_bus_init(void)
 void __exit nd_bus_exit(void)
 {
 	class_destroy(nd_class);
-	unregister_chrdev(nd_major, "ndctl");
+	unregister_chrdev(nd_bus_major, "ndctl");
+	bus_unregister(&nd_bus_type);
 }
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
index d6a666b9228b..a0d1623b3641 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -29,6 +29,24 @@ static bool warn_checksum;
 module_param(warn_checksum, bool, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(warn_checksum, "Turn checksum errors into warnings");
 
+/**
+ * nd_dimm_by_handle - lookup an nd_dimm by its corresponding nfit_handle
+ * @nd_bus: parent bus of the dimm
+ * @nfit_handle: handle from the memory-device-to-spa (nfit_mem) structure
+ *
+ * LOCKING: expect nd_bus_list_mutex() held at entry
+ */
+struct nd_dimm *nd_dimm_by_handle(struct nd_bus *nd_bus, u32 nfit_handle)
+{
+	struct nd_dimm *nd_dimm;
+
+	WARN_ON_ONCE(!mutex_is_locked(&nd_bus_list_mutex));
+	nd_dimm = radix_tree_lookup(&nd_bus->dimm_radix, nfit_handle);
+	if (nd_dimm)
+		get_device(&nd_dimm->dev);
+	return nd_dimm;
+}
+
 static void nd_bus_release(struct device *dev)
 {
 	struct nd_bus *nd_bus = container_of(dev, struct nd_bus, dev);
@@ -71,6 +89,19 @@ struct nd_bus *to_nd_bus(struct device *dev)
 	return nd_bus;
 }
 
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
 	struct nfit_bus_descriptor *nfit_desc = nd_bus->nfit_desc;
@@ -132,6 +163,7 @@ static void *nd_bus_new(struct device *parent,
 	INIT_LIST_HEAD(&nd_bus->memdevs);
 	INIT_LIST_HEAD(&nd_bus->dimms);
 	INIT_LIST_HEAD(&nd_bus->list);
+	INIT_RADIX_TREE(&nd_bus->dimm_radix, GFP_KERNEL);
 	nd_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
 	if (nd_bus->id < 0) {
 		kfree(nd_bus);
@@ -431,6 +463,21 @@ static int nd_mem_init(struct nd_bus *nd_bus)
 	return 0;
 }
 
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
 static struct nd_bus *nd_bus_probe(struct nd_bus *nd_bus)
 {
 	struct nfit_bus_descriptor *nfit_desc = nd_bus->nfit_desc;
@@ -484,11 +531,18 @@ static struct nd_bus *nd_bus_probe(struct nd_bus *nd_bus)
 	if (rc)
 		goto err;
 
+	rc = nd_bus_register_dimms(nd_bus);
+	if (rc)
+		goto err_child;
+
 	mutex_lock(&nd_bus_list_mutex);
 	list_add_tail(&nd_bus->list, &nd_bus_list);
 	mutex_unlock(&nd_bus_list_mutex);
 
 	return nd_bus;
+ err_child:
+	device_for_each_child(&nd_bus->dev, NULL, child_unregister);
+	nd_bus_destroy_ndctl(nd_bus);
  err:
 	put_device(&nd_bus->dev);
 	return NULL;
@@ -523,6 +577,7 @@ void nfit_bus_unregister(struct nd_bus *nd_bus)
 	list_del_init(&nd_bus->list);
 	mutex_unlock(&nd_bus_list_mutex);
 
+	device_for_each_child(&nd_bus->dev, NULL, child_unregister);
 	nd_bus_destroy_ndctl(nd_bus);
 
 	device_unregister(&nd_bus->dev);
diff --git a/drivers/block/nd/dimm_devs.c b/drivers/block/nd/dimm_devs.c
new file mode 100644
index 000000000000..b74b23c297fb
--- /dev/null
+++ b/drivers/block/nd/dimm_devs.c
@@ -0,0 +1,243 @@
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
+#include "nfit.h"
+
+static DEFINE_IDA(dimm_ida);
+
+static void nd_dimm_release(struct device *dev)
+{
+	struct nd_dimm *nd_dimm = to_nd_dimm(dev);
+
+	ida_simple_remove(&dimm_ida, nd_dimm->id);
+	nd_dimm_delete(nd_dimm);
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
+
+static struct nfit_mem __iomem *to_nfit_mem(struct device *dev)
+{
+	struct nd_dimm *nd_dimm = to_nd_dimm(dev);
+	struct nd_mem *nd_mem = nd_dimm->nd_mem;
+	struct nfit_mem __iomem *nfit_mem = nd_mem->nfit_mem_dcr;
+
+	return nfit_mem;
+}
+
+static struct nfit_dcr __iomem *to_nfit_dcr(struct device *dev)
+{
+	struct nd_dimm *nd_dimm = to_nd_dimm(dev);
+	struct nd_mem *nd_mem = nd_dimm->nd_mem;
+	struct nfit_dcr __iomem *nfit_dcr = nd_mem->nfit_dcr;
+
+	return nfit_dcr;
+}
+
+static ssize_t handle_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nfit_mem __iomem *nfit_mem = to_nfit_mem(dev);
+
+	return sprintf(buf, "%#x\n", readl(&nfit_mem->nfit_handle));
+}
+static DEVICE_ATTR_RO(handle);
+
+static ssize_t phys_id_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nfit_mem __iomem *nfit_mem = to_nfit_mem(dev);
+
+	return sprintf(buf, "%#x\n", readw(&nfit_mem->phys_id));
+}
+static DEVICE_ATTR_RO(phys_id);
+
+static ssize_t vendor_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nfit_dcr __iomem *nfit_dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "%#x\n", readw(&nfit_dcr->vendor_id));
+}
+static DEVICE_ATTR_RO(vendor);
+
+static ssize_t revision_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nfit_dcr __iomem *nfit_dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "%#x\n", readw(&nfit_dcr->revision_id));
+}
+static DEVICE_ATTR_RO(revision);
+
+static ssize_t device_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nfit_dcr __iomem *nfit_dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "%#x\n", readw(&nfit_dcr->device_id));
+}
+static DEVICE_ATTR_RO(device);
+
+static ssize_t format_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nfit_dcr __iomem *nfit_dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "%#x\n", readw(&nfit_dcr->fic));
+}
+static DEVICE_ATTR_RO(format);
+
+static ssize_t serial_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nfit_dcr __iomem *nfit_dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "%#x\n", readl(&nfit_dcr->serial_number));
+}
+static DEVICE_ATTR_RO(serial);
+
+static struct attribute *nd_dimm_attributes[] = {
+	&dev_attr_handle.attr,
+	&dev_attr_phys_id.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_device.attr,
+	&dev_attr_format.attr,
+	&dev_attr_serial.attr,
+	&dev_attr_revision.attr,
+	NULL,
+};
+
+static umode_t nd_dimm_attr_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct nd_dimm *nd_dimm = to_nd_dimm(dev);
+
+	if (a == &dev_attr_handle.attr || a == &dev_attr_phys_id.attr
+			|| to_nfit_dcr(&nd_dimm->dev))
+		return a->mode;
+	else
+		return 0;
+}
+
+static struct attribute_group nd_dimm_attribute_group = {
+	.attrs = nd_dimm_attributes,
+	.is_visible = nd_dimm_attr_visible,
+};
+
+static const struct attribute_group *nd_dimm_attribute_groups[] = {
+	&nd_dimm_attribute_group,
+	NULL,
+};
+
+static struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus,
+		struct nd_mem *nd_mem)
+{
+	struct nd_dimm *nd_dimm = kzalloc(sizeof(*nd_dimm), GFP_KERNEL);
+	struct device *dev;
+	u32 nfit_handle;
+
+	if (!nd_dimm)
+		return NULL;
+
+	nd_dimm->del_info = kzalloc(sizeof(struct nd_dimm_delete), GFP_KERNEL);
+	if (!nd_dimm->del_info)
+		goto err_del_info;
+	nd_dimm->del_info->nd_bus = nd_bus;
+	nd_dimm->del_info->nd_mem = nd_mem;
+
+	nfit_handle = readl(&nd_mem->nfit_mem_dcr->nfit_handle);
+	if (radix_tree_insert(&nd_bus->dimm_radix, nfit_handle, nd_dimm) != 0)
+		goto err_radix;
+
+	nd_dimm->id = ida_simple_get(&dimm_ida, 0, 0, GFP_KERNEL);
+	if (nd_dimm->id < 0)
+		goto err_ida;
+
+	nd_dimm->nd_mem = nd_mem;
+	dev = &nd_dimm->dev;
+	dev_set_name(dev, "nmem%d", nd_dimm->id);
+	dev->parent = &nd_bus->dev;
+	dev->type = &nd_dimm_device_type;
+	dev->bus = &nd_bus_type;
+	dev->groups = nd_dimm_attribute_groups;
+	if (device_register(dev) != 0) {
+		put_device(dev);
+		return NULL;
+	}
+
+	return nd_dimm;
+ err_ida:
+	radix_tree_delete(&nd_bus->dimm_radix, nfit_handle);
+ err_radix:
+	kfree(nd_dimm->del_info);
+ err_del_info:
+	kfree(nd_dimm);
+	return NULL;
+}
+
+int nd_bus_register_dimms(struct nd_bus *nd_bus)
+{
+	int rc = 0, dimm_count = 0;
+	struct nd_mem *nd_mem;
+
+	mutex_lock(&nd_bus_list_mutex);
+	list_for_each_entry(nd_mem, &nd_bus->dimms, list) {
+		struct nd_dimm *nd_dimm;
+		u32 nfit_handle;
+
+		nfit_handle = readl(&nd_mem->nfit_mem_dcr->nfit_handle);
+		nd_dimm = nd_dimm_by_handle(nd_bus, nfit_handle);
+		if (nd_dimm) {
+			/*
+			 * If for some reason we find multiple DCRs the
+			 * first one wins
+			 */
+			dev_err(&nd_bus->dev, "duplicate DCR detected: %s\n",
+				dev_name(&nd_dimm->dev));
+			put_device(&nd_dimm->dev);
+			continue;
+		}
+
+		if (!nd_dimm_create(nd_bus, nd_mem)) {
+			rc = -ENOMEM;
+			break;
+		}
+		dimm_count++;
+	}
+	mutex_unlock(&nd_bus_list_mutex);
+
+	return rc;
+}
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index 4bcc9c96cb4d..58a52c03f5ee 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -12,12 +12,15 @@
  */
 #ifndef __ND_PRIVATE_H__
 #define __ND_PRIVATE_H__
+#include <linux/radix-tree.h>
 #include <linux/device.h>
 extern struct list_head nd_bus_list;
 extern struct mutex nd_bus_list_mutex;
+extern struct bus_type nd_bus_type;
 
 struct nd_bus {
 	struct nfit_bus_descriptor *nfit_desc;
+	struct radix_tree_root dimm_radix;
 	struct list_head memdevs;
 	struct list_head dimms;
 	struct list_head spas;
@@ -28,6 +31,16 @@ struct nd_bus {
 	int id;
 };
 
+struct nd_dimm {
+	struct nd_mem *nd_mem;
+	struct device dev;
+	int id;
+	struct nd_dimm_delete {
+		struct nd_bus *nd_bus;
+		struct nd_mem *nd_mem;
+	} *del_info;
+};
+
 struct nd_spa {
 	struct nfit_spa __iomem *nfit_spa;
 	struct list_head list;
@@ -58,9 +71,15 @@ struct nd_mem {
 	struct list_head list;
 };
 
+struct nd_dimm *nd_dimm_by_handle(struct nd_bus *nd_bus, u32 nfit_handle);
 struct nd_bus *to_nd_bus(struct device *dev);
+struct nd_dimm *to_nd_dimm(struct device *dev);
+struct nd_bus *walk_to_nd_bus(struct device *nd_dev);
+void nd_synchronize(void);
 int __init nd_bus_init(void);
 void __exit nd_bus_exit(void);
+void nd_dimm_delete(struct nd_dimm *nd_dimm);
 int nd_bus_create_ndctl(struct nd_bus *nd_bus);
 void nd_bus_destroy_ndctl(struct nd_bus *nd_bus);
+int nd_bus_register_dimms(struct nd_bus *nd_bus);
 #endif /* __ND_PRIVATE_H__ */

