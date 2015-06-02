Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v5 03/21] libnvdimm: control character device and libnvdimm
 bus sysfs attributes
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 01 Jun 2015 20:14:25 -0400
Message-ID: <20150602001424.4506.18549.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The control device for a libnvdimm bus is registered as an "nd" class
device.  The expectation is that there will usually only be one "nd" bus
registered under /sys/class/nd.  However, we allow for the possibility
of multiple buses and they will listed in discovery order as
ndctl0...ndctlN.  This character device hosts the ioctl for passing
control messages.  The initial command set has a 1:1 correlation with
the commands listed in the by the "NFIT DSM Example" document [1], but
this scheme is extensible to future command sets.

Note, nd_ioctl() and the backing ->ndctl() implementation are defined in
a subsequent patch.  This is simply the initial registrations and sysfs
attributes.

[1]: http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf

Cc: Neil Brown <neilb@suse.de>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: <linux-acpi@vger.kernel.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c         |   28 ++++++++++++++
 drivers/acpi/nfit.h         |    5 ++
 drivers/nvdimm/Makefile     |    1 
 drivers/nvdimm/bus.c        |   83 +++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/core.c       |   87 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/nvdimm/nd-private.h |    6 +++
 include/linux/libnvdimm.h   |    6 ++-
 7 files changed, 213 insertions(+), 3 deletions(-)
 create mode 100644 drivers/nvdimm/bus.c

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 314cf9d2522b..ec228ab336b3 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -316,6 +316,33 @@ static int nfit_mem_init(struct acpi_nfit_desc *acpi_desc)
 	return 0;
 }
 
+static ssize_t revision_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
+
+	return sprintf(buf, "%d\n", acpi_desc->nfit->header.revision);
+}
+static DEVICE_ATTR_RO(revision);
+
+static struct attribute *acpi_nfit_attributes[] = {
+	&dev_attr_revision.attr,
+	NULL,
+};
+
+static struct attribute_group acpi_nfit_attribute_group = {
+	.name = "nfit",
+	.attrs = acpi_nfit_attributes,
+};
+
+static const struct attribute_group *acpi_nfit_attribute_groups[] = {
+	&nvdimm_bus_attribute_group,
+	&acpi_nfit_attribute_group,
+	NULL,
+};
+
 static int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 {
 	struct device *dev = acpi_desc->dev;
@@ -372,6 +399,7 @@ static int acpi_nfit_add(struct acpi_device *adev)
 	nd_desc = &acpi_desc->nd_desc;
 	nd_desc->provider_name = "ACPI.NFIT";
 	nd_desc->ndctl = acpi_nfit_ctl;
+	nd_desc->attr_groups = acpi_nfit_attribute_groups;
 
 	acpi_desc->nvdimm_bus = nvdimm_bus_register(dev, nd_desc);
 	if (!acpi_desc->nvdimm_bus)
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 2d98cc1b7b6c..735e463edbf7 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -86,4 +86,9 @@ static inline struct acpi_nfit_memory_map *__to_nfit_memdev(struct nfit_mem *nfi
 		return nfit_mem->memdev_dcr;
 	return nfit_mem->memdev_pmem;
 }
+
+static inline struct acpi_nfit_desc *to_acpi_desc(struct nvdimm_bus_descriptor *nd_desc)
+{
+	return container_of(nd_desc, struct acpi_nfit_desc, nd_desc);
+}
 #endif /* __NFIT_H__ */
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index 10bc7af47992..8a8293c72c7c 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_LIBNVDIMM) += libnvdimm.o
 
 libnvdimm-y := core.o
+libnvdimm-y += bus.o
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
new file mode 100644
index 000000000000..312caef5b0e9
--- /dev/null
+++ b/drivers/nvdimm/bus.c
@@ -0,0 +1,83 @@
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
+#include <linux/uaccess.h>
+#include <linux/fcntl.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/io.h>
+#include "nd-private.h"
+
+static int nvdimm_bus_major;
+static struct class *nd_class;
+
+int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus)
+{
+	dev_t devt = MKDEV(nvdimm_bus_major, nvdimm_bus->id);
+	struct device *dev;
+
+	dev = device_create(nd_class, &nvdimm_bus->dev, devt, nvdimm_bus, "ndctl%d",
+			nvdimm_bus->id);
+
+	if (IS_ERR(dev)) {
+		dev_dbg(&nvdimm_bus->dev, "failed to register ndctl%d: %ld\n",
+				nvdimm_bus->id, PTR_ERR(dev));
+		return PTR_ERR(dev);
+	}
+	return 0;
+}
+
+void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus)
+{
+	device_destroy(nd_class, MKDEV(nvdimm_bus_major, nvdimm_bus->id));
+}
+
+static long nd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	return -ENXIO;
+}
+
+static const struct file_operations nvdimm_bus_fops = {
+	.owner = THIS_MODULE,
+	.open = nonseekable_open,
+	.unlocked_ioctl = nd_ioctl,
+	.compat_ioctl = nd_ioctl,
+	.llseek = noop_llseek,
+};
+
+int __init nvdimm_bus_init(void)
+{
+	int rc;
+
+	rc = register_chrdev(0, "ndctl", &nvdimm_bus_fops);
+	if (rc < 0)
+		return rc;
+	nvdimm_bus_major = rc;
+
+	nd_class = class_create(THIS_MODULE, "nd");
+	if (IS_ERR(nd_class))
+		goto err_class;
+
+	return 0;
+
+ err_class:
+	unregister_chrdev(nvdimm_bus_major, "ndctl");
+
+	return rc;
+}
+
+void __exit nvdimm_bus_exit(void)
+{
+	class_destroy(nd_class);
+	unregister_chrdev(nvdimm_bus_major, "ndctl");
+}
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index eeec6dd2fed1..86b4da096de1 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -14,9 +14,12 @@
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include "nd-private.h"
 
+static LIST_HEAD(nvdimm_bus_list);
+static DEFINE_MUTEX(nvdimm_bus_list_mutex);
 static DEFINE_IDA(nd_ida);
 
 static void nvdimm_bus_release(struct device *dev)
@@ -27,6 +30,54 @@ static void nvdimm_bus_release(struct device *dev)
 	kfree(nvdimm_bus);
 }
 
+struct nvdimm_bus *to_nvdimm_bus(struct device *dev)
+{
+	struct nvdimm_bus *nvdimm_bus = container_of(dev, struct nvdimm_bus, dev);
+
+	WARN_ON(nvdimm_bus->dev.release != nvdimm_bus_release);
+	return nvdimm_bus;
+}
+EXPORT_SYMBOL_GPL(to_nvdimm_bus);
+
+struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus)
+{
+	/* struct nvdimm_bus definition is private to libnvdimm */
+	return nvdimm_bus->nd_desc;
+}
+EXPORT_SYMBOL_GPL(to_nd_desc);
+
+static const char *nvdimm_bus_provider(struct nvdimm_bus *nvdimm_bus)
+{
+	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
+	struct device *parent = nvdimm_bus->dev.parent;
+
+	if (nd_desc->provider_name)
+		return nd_desc->provider_name;
+	else if (parent)
+		return dev_name(parent);
+	else
+		return "unknown";
+}
+
+static ssize_t provider_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
+
+	return sprintf(buf, "%s\n", nvdimm_bus_provider(nvdimm_bus));
+}
+static DEVICE_ATTR_RO(provider);
+
+static struct attribute *nvdimm_bus_attributes[] = {
+	&dev_attr_provider.attr,
+	NULL,
+};
+
+struct attribute_group nvdimm_bus_attribute_group = {
+	.attrs = nvdimm_bus_attributes,
+};
+EXPORT_SYMBOL_GPL(nvdimm_bus_attribute_group);
+
 struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 		struct nvdimm_bus_descriptor *nd_desc)
 {
@@ -35,6 +86,7 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 
 	if (!nvdimm_bus)
 		return NULL;
+	INIT_LIST_HEAD(&nvdimm_bus->list);
 	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
 	if (nvdimm_bus->id < 0) {
 		kfree(nvdimm_bus);
@@ -43,15 +95,26 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 	nvdimm_bus->nd_desc = nd_desc;
 	nvdimm_bus->dev.parent = parent;
 	nvdimm_bus->dev.release = nvdimm_bus_release;
+	nvdimm_bus->dev.groups = nd_desc->attr_groups;
 	dev_set_name(&nvdimm_bus->dev, "ndbus%d", nvdimm_bus->id);
 	rc = device_register(&nvdimm_bus->dev);
 	if (rc) {
 		dev_dbg(&nvdimm_bus->dev, "device registration failed: %d\n", rc);
-		put_device(&nvdimm_bus->dev);
-		return NULL;
+		goto err;
 	}
 
+	rc = nvdimm_bus_create_ndctl(nvdimm_bus);
+	if (rc)
+		goto err;
+
+	mutex_lock(&nvdimm_bus_list_mutex);
+	list_add_tail(&nvdimm_bus->list, &nvdimm_bus_list);
+	mutex_unlock(&nvdimm_bus_list_mutex);
+
 	return nvdimm_bus;
+ err:
+	put_device(&nvdimm_bus->dev);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(nvdimm_bus_register);
 
@@ -59,9 +122,29 @@ void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus)
 {
 	if (!nvdimm_bus)
 		return;
+
+	mutex_lock(&nvdimm_bus_list_mutex);
+	list_del_init(&nvdimm_bus->list);
+	mutex_unlock(&nvdimm_bus_list_mutex);
+
+	nvdimm_bus_destroy_ndctl(nvdimm_bus);
+
 	device_unregister(&nvdimm_bus->dev);
 }
 EXPORT_SYMBOL_GPL(nvdimm_bus_unregister);
 
+static __init int libnvdimm_init(void)
+{
+	return nvdimm_bus_init();
+}
+
+static __exit void libnvdimm_exit(void)
+{
+	WARN_ON(!list_empty(&nvdimm_bus_list));
+	nvdimm_bus_exit();
+}
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Intel Corporation");
+module_init(libnvdimm_init);
+module_exit(libnvdimm_exit);
diff --git a/drivers/nvdimm/nd-private.h b/drivers/nvdimm/nd-private.h
index e7c4e99a22a4..f31fc3396683 100644
--- a/drivers/nvdimm/nd-private.h
+++ b/drivers/nvdimm/nd-private.h
@@ -17,7 +17,13 @@
 
 struct nvdimm_bus {
 	struct nvdimm_bus_descriptor *nd_desc;
+	struct list_head list;
 	struct device dev;
 	int id;
 };
+
+int __init nvdimm_bus_init(void);
+void __exit nvdimm_bus_exit(void);
+int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus);
+void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus);
 #endif /* __ND_PRIVATE_H__ */
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 2b3c63950c91..d375cdc4abd5 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -14,6 +14,8 @@
  */
 #ifndef __LIBNVDIMM_H__
 #define __LIBNVDIMM_H__
+extern struct attribute_group nvdimm_bus_attribute_group;
+
 struct nvdimm;
 struct nvdimm_bus_descriptor;
 typedef int (*ndctl_fn)(struct nvdimm_bus_descriptor *nd_desc,
@@ -21,14 +23,16 @@ typedef int (*ndctl_fn)(struct nvdimm_bus_descriptor *nd_desc,
 		unsigned int buf_len);
 
 struct nvdimm_bus_descriptor {
+	const struct attribute_group **attr_groups;
 	unsigned long dsm_mask;
 	char *provider_name;
 	ndctl_fn ndctl;
 };
 
 struct device;
-struct nvdimm_bus;
 struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 		struct nvdimm_bus_descriptor *nfit_desc);
 void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus);
+struct nvdimm_bus *to_nvdimm_bus(struct device *dev);
+struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus);
 #endif /* __LIBNVDIMM_H__ */

