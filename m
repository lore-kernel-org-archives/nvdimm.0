Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 04/20] libnd: ndctl class device, and nd bus attributes
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Apr 2015 14:24:34 -0400
Message-ID: <20150428182434.35812.49091.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This is the position (device topology) independent method to find all
the libnd buses in the system.  The expectation is that there will only
ever be one "nd" bus discovered via /sys/class/nd/ndctl0.  However, we
allow for the possibility of multiple buses and they will listed in
discovery order as ndctl0...ndctlN.  This character device hosts the
ioctl for passing control messages (inspired by the ACPI-NFIT DSM
interface commands).

Note, nd_ioctl() and the backing ->ndctl() implementation are defined in
a subsequent patch.

Cc: Neil Brown <neilb@suse.de>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: <linux-acpi@vger.kernel.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/Makefile     |    1 
 drivers/block/nd/acpi.c       |   29 ++++++++++++++
 drivers/block/nd/acpi_nfit.h  |    5 ++
 drivers/block/nd/bus.c        |   83 +++++++++++++++++++++++++++++++++++++++
 drivers/block/nd/core.c       |   87 ++++++++++++++++++++++++++++++++++++++++-
 drivers/block/nd/libnd.h      |    5 ++
 drivers/block/nd/nd-private.h |    6 +++
 drivers/block/nd/test/nfit.c  |    3 +
 8 files changed, 217 insertions(+), 2 deletions(-)
 create mode 100644 drivers/block/nd/bus.c

diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
index cf064db92589..7defe18ed009 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_NFIT_TEST) += test/
 nd_acpi-y := acpi.o
 
 libnd-y := core.o
+libnd-y += bus.o
diff --git a/drivers/block/nd/acpi.c b/drivers/block/nd/acpi.c
index 54344ef9c837..dd8505f766ed 100644
--- a/drivers/block/nd/acpi.c
+++ b/drivers/block/nd/acpi.c
@@ -341,6 +341,34 @@ static int nfit_mem_init(struct acpi_nfit_desc *acpi_desc)
 	return 0;
 }
 
+static ssize_t revision_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_bus *nd_bus = to_nd_bus(dev);
+	struct nd_bus_descriptor *nd_desc = to_nd_desc(nd_bus);
+	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
+
+	return sprintf(buf, "%d\n", acpi_desc->nfit->revision);
+}
+static DEVICE_ATTR_RO(revision);
+
+static struct attribute *nd_acpi_attributes[] = {
+	&dev_attr_revision.attr,
+	NULL,
+};
+
+static struct attribute_group nd_acpi_attribute_group = {
+	.name = "nfit",
+	.attrs = nd_acpi_attributes,
+};
+
+const struct attribute_group *nd_acpi_attribute_groups[] = {
+	&nd_bus_attribute_group,
+	&nd_acpi_attribute_group,
+	NULL,
+};
+EXPORT_SYMBOL_GPL(nd_acpi_attribute_groups);
+
 int nd_acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 {
 	struct device *dev = acpi_desc->dev;
@@ -408,6 +436,7 @@ static int nd_acpi_add(struct acpi_device *adev)
 	nd_desc = &acpi_desc->nd_desc;
 	nd_desc->provider_name = "ACPI.NFIT";
 	nd_desc->ndctl = nd_acpi_ctl;
+	nd_desc->attr_groups = nd_acpi_attribute_groups;
 
 	acpi_desc->nd_bus = nd_bus_register(dev, nd_desc);
 	if (!acpi_desc->nd_bus)
diff --git a/drivers/block/nd/acpi_nfit.h b/drivers/block/nd/acpi_nfit.h
index a26f69e32244..b65745ca3cbc 100644
--- a/drivers/block/nd/acpi_nfit.h
+++ b/drivers/block/nd/acpi_nfit.h
@@ -261,5 +261,10 @@ static inline struct acpi_nfit_memdev *__to_nfit_memdev(struct nfit_mem *nfit_me
 	return nfit_mem->memdev_pmem;
 }
 
+static inline struct acpi_nfit_desc *to_acpi_desc(struct nd_bus_descriptor *nd_desc)
+{
+	return container_of(nd_desc, struct acpi_nfit_desc, nd_desc);
+}
+
 int nd_acpi_nfit_init(struct acpi_nfit_desc *nfit, acpi_size sz);
 #endif /* __NFIT_H__ */
diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
new file mode 100644
index 000000000000..635f2e926426
--- /dev/null
+++ b/drivers/block/nd/bus.c
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
+static int nd_bus_major;
+static struct class *nd_class;
+
+int nd_bus_create_ndctl(struct nd_bus *nd_bus)
+{
+	dev_t devt = MKDEV(nd_bus_major, nd_bus->id);
+	struct device *dev;
+
+	dev = device_create(nd_class, &nd_bus->dev, devt, nd_bus, "ndctl%d",
+			nd_bus->id);
+
+	if (IS_ERR(dev)) {
+		dev_dbg(&nd_bus->dev, "failed to register ndctl%d: %ld\n",
+				nd_bus->id, PTR_ERR(dev));
+		return PTR_ERR(dev);
+	}
+	return 0;
+}
+
+void nd_bus_destroy_ndctl(struct nd_bus *nd_bus)
+{
+	device_destroy(nd_class, MKDEV(nd_bus_major, nd_bus->id));
+}
+
+static long nd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	return -ENXIO;
+}
+
+static const struct file_operations nd_bus_fops = {
+	.owner = THIS_MODULE,
+	.open = nonseekable_open,
+	.unlocked_ioctl = nd_ioctl,
+	.compat_ioctl = nd_ioctl,
+	.llseek = noop_llseek,
+};
+
+int __init nd_bus_init(void)
+{
+	int rc;
+
+	rc = register_chrdev(0, "ndctl", &nd_bus_fops);
+	if (rc < 0)
+		return rc;
+	nd_bus_major = rc;
+
+	nd_class = class_create(THIS_MODULE, "nd");
+	if (IS_ERR(nd_class))
+		goto err_class;
+
+	return 0;
+
+ err_class:
+	unregister_chrdev(nd_bus_major, "ndctl");
+
+	return rc;
+}
+
+void __exit nd_bus_exit(void)
+{
+	class_destroy(nd_class);
+	unregister_chrdev(nd_bus_major, "ndctl");
+}
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
index 3cccdbc0f3b7..55603ff264ff 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -13,10 +13,13 @@
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include "nd-private.h"
 #include "libnd.h"
 
+LIST_HEAD(nd_bus_list);
+DEFINE_MUTEX(nd_bus_list_mutex);
 static DEFINE_IDA(nd_ida);
 
 static void nd_bus_release(struct device *dev)
@@ -27,6 +30,54 @@ static void nd_bus_release(struct device *dev)
 	kfree(nd_bus);
 }
 
+struct nd_bus *to_nd_bus(struct device *dev)
+{
+	struct nd_bus *nd_bus = container_of(dev, struct nd_bus, dev);
+
+	WARN_ON(nd_bus->dev.release != nd_bus_release);
+	return nd_bus;
+}
+EXPORT_SYMBOL_GPL(to_nd_bus);
+
+struct nd_bus_descriptor *to_nd_desc(struct nd_bus *nd_bus)
+{
+	/* struct nd_bus definition is private to libnd */
+	return nd_bus->nd_desc;
+}
+EXPORT_SYMBOL_GPL(to_nd_desc);
+
+static const char *nd_bus_provider(struct nd_bus *nd_bus)
+{
+	struct nd_bus_descriptor *nd_desc = nd_bus->nd_desc;
+	struct device *parent = nd_bus->dev.parent;
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
+	struct nd_bus *nd_bus = to_nd_bus(dev);
+
+	return sprintf(buf, "%s\n", nd_bus_provider(nd_bus));
+}
+static DEVICE_ATTR_RO(provider);
+
+static struct attribute *nd_bus_attributes[] = {
+	&dev_attr_provider.attr,
+	NULL,
+};
+
+struct attribute_group nd_bus_attribute_group = {
+	.attrs = nd_bus_attributes,
+};
+EXPORT_SYMBOL_GPL(nd_bus_attribute_group);
+
 struct nd_bus *nd_bus_register(struct device *parent,
 		struct nd_bus_descriptor *nd_desc)
 {
@@ -35,6 +86,7 @@ struct nd_bus *nd_bus_register(struct device *parent,
 
 	if (!nd_bus)
 		return NULL;
+	INIT_LIST_HEAD(&nd_bus->list);
 	nd_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
 	if (nd_bus->id < 0) {
 		kfree(nd_bus);
@@ -43,15 +95,26 @@ struct nd_bus *nd_bus_register(struct device *parent,
 	nd_bus->nd_desc = nd_desc;
 	nd_bus->dev.parent = parent;
 	nd_bus->dev.release = nd_bus_release;
+	nd_bus->dev.groups = nd_desc->attr_groups;
 	dev_set_name(&nd_bus->dev, "ndbus%d", nd_bus->id);
 	rc = device_register(&nd_bus->dev);
 	if (rc) {
 		dev_dbg(&nd_bus->dev, "device registration failed: %d\n", rc);
-		put_device(&nd_bus->dev);
-		return NULL;
+		goto err;
 	}
 
+	rc = nd_bus_create_ndctl(nd_bus);
+	if (rc)
+		goto err;
+
+	mutex_lock(&nd_bus_list_mutex);
+	list_add_tail(&nd_bus->list, &nd_bus_list);
+	mutex_unlock(&nd_bus_list_mutex);
+
 	return nd_bus;
+ err:
+	put_device(&nd_bus->dev);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(nd_bus_register);
 
@@ -59,9 +122,29 @@ void nd_bus_unregister(struct nd_bus *nd_bus)
 {
 	if (!nd_bus)
 		return;
+
+	mutex_lock(&nd_bus_list_mutex);
+	list_del_init(&nd_bus->list);
+	mutex_unlock(&nd_bus_list_mutex);
+
+	nd_bus_destroy_ndctl(nd_bus);
+
 	device_unregister(&nd_bus->dev);
 }
 EXPORT_SYMBOL_GPL(nd_bus_unregister);
 
+static __init int libnd_init(void)
+{
+	return nd_bus_init();
+}
+
+static __exit void libnd_exit(void)
+{
+	WARN_ON(!list_empty(&nd_bus_list));
+	nd_bus_exit();
+}
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Intel Corporation");
+module_init(libnd_init);
+module_exit(libnd_exit);
diff --git a/drivers/block/nd/libnd.h b/drivers/block/nd/libnd.h
index 163832937e9c..86cf3e0573b0 100644
--- a/drivers/block/nd/libnd.h
+++ b/drivers/block/nd/libnd.h
@@ -14,6 +14,8 @@
  */
 #ifndef __LIBND_H__
 #define __LIBND_H__
+extern struct attribute_group nd_bus_attribute_group;
+
 struct nd_dimm;
 struct nd_bus_descriptor;
 typedef int (*ndctl_fn)(struct nd_bus_descriptor *nd_desc,
@@ -21,6 +23,7 @@ typedef int (*ndctl_fn)(struct nd_bus_descriptor *nd_desc,
 		unsigned int buf_len);
 
 struct nd_bus_descriptor {
+	const struct attribute_group **attr_groups;
 	unsigned long dsm_mask;
 	char *provider_name;
 	ndctl_fn ndctl;
@@ -30,4 +33,6 @@ struct nd_bus;
 struct nd_bus *nd_bus_register(struct device *parent,
 		struct nd_bus_descriptor *nfit_desc);
 void nd_bus_unregister(struct nd_bus *nd_bus);
+struct nd_bus *to_nd_bus(struct device *dev);
+struct nd_bus_descriptor *to_nd_desc(struct nd_bus *nd_bus);
 #endif /* __LIBND_H__ */
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index 3dbab29fa0f9..960dd2f29cdd 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -17,7 +17,13 @@
 
 struct nd_bus {
 	struct nd_bus_descriptor *nd_desc;
+	struct list_head list;
 	struct device dev;
 	int id;
 };
+
+int __init nd_bus_init(void);
+void __exit nd_bus_exit(void);
+int nd_bus_create_ndctl(struct nd_bus *nd_bus);
+void nd_bus_destroy_ndctl(struct nd_bus *nd_bus);
 #endif /* __ND_PRIVATE_H__ */
diff --git a/drivers/block/nd/test/nfit.c b/drivers/block/nd/test/nfit.c
index 8691a903515b..1c79f32376fc 100644
--- a/drivers/block/nd/test/nfit.c
+++ b/drivers/block/nd/test/nfit.c
@@ -833,6 +833,8 @@ static void nfit_test1_setup(struct nfit_test *t)
 	nfit->checksum = nfit_checksum(nfit_buf, size);
 }
 
+extern const struct attribute_group *nd_acpi_attribute_groups[];
+
 static int nfit_test_probe(struct platform_device *pdev)
 {
 	struct nd_bus_descriptor *nd_desc;
@@ -882,6 +884,7 @@ static int nfit_test_probe(struct platform_device *pdev)
 	acpi_desc->dev = &pdev->dev;
 	acpi_desc->nfit = nfit_test->nfit_buf;
 	nd_desc = &acpi_desc->nd_desc;
+	nd_desc->attr_groups = nd_acpi_attribute_groups;
 	acpi_desc->nd_bus = nd_bus_register(&pdev->dev, nd_desc);
 	if (!acpi_desc->nd_bus)
 		return -ENXIO;

