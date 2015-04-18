Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 06/21] nd: ndctl class device, and nd bus attributes
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Apr 2015 21:35:46 -0400
Message-ID: <20150418013546.25237.86836.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This is the position (device topology) independent method to find all
the NFIT-defined buses in the system.  The expectation is that there
will only ever be one "nd" bus discovered via /sys/class/nd/ndctl0.
However, we allow for the possibility of multiple buses and they will
listed in discovery order as ndctl0...ndctlN.  This character device
hosts the ioctl for passing control messages (as defined by the NFIT
spec).  The "format" and "revision" attributes of this device identify
the format of the messages.  In the event an NFIT is registered with an
unknown/unsupported control message format then the "format" attribute
will not be visible.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/Makefile     |    1 
 drivers/block/nd/bus.c        |   84 +++++++++++++++++++++++++++++++++++++++++
 drivers/block/nd/core.c       |   71 ++++++++++++++++++++++++++++++++++-
 drivers/block/nd/nd-private.h |    5 ++
 4 files changed, 160 insertions(+), 1 deletion(-)
 create mode 100644 drivers/block/nd/bus.c

diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
index c6bec0c185c5..7772fb599809 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -20,3 +20,4 @@ obj-$(CONFIG_NFIT_ACPI) += nd_acpi.o
 nd_acpi-y := acpi.o
 
 nd-y := core.o
+nd-y += bus.o
diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
new file mode 100644
index 000000000000..c27db50511f2
--- /dev/null
+++ b/drivers/block/nd/bus.c
@@ -0,0 +1,84 @@
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
+#include "nfit.h"
+
+static int nd_major;
+static struct class *nd_class;
+
+int nd_bus_create_ndctl(struct nd_bus *nd_bus)
+{
+	dev_t devt = MKDEV(nd_major, nd_bus->id);
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
+	device_destroy(nd_class, MKDEV(nd_major, nd_bus->id));
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
+	nd_major = rc;
+
+	nd_class = class_create(THIS_MODULE, "nd");
+	if (IS_ERR(nd_class))
+		goto err_class;
+
+	return 0;
+
+ err_class:
+	unregister_chrdev(nd_major, "ndctl");
+
+	return rc;
+}
+
+void __exit nd_bus_exit(void)
+{
+	class_destroy(nd_class);
+	unregister_chrdev(nd_major, "ndctl");
+}
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
index d126799e7ff7..d6a666b9228b 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -14,12 +14,15 @@
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/uuid.h>
 #include <linux/io.h>
 #include "nd-private.h"
 #include "nfit.h"
 
+LIST_HEAD(nd_bus_list);
+DEFINE_MUTEX(nd_bus_list_mutex);
 static DEFINE_IDA(nd_ida);
 
 static bool warn_checksum;
@@ -68,6 +71,53 @@ struct nd_bus *to_nd_bus(struct device *dev)
 	return nd_bus;
 }
 
+static const char *nd_bus_provider(struct nd_bus *nd_bus)
+{
+	struct nfit_bus_descriptor *nfit_desc = nd_bus->nfit_desc;
+	struct device *parent = nd_bus->dev.parent;
+
+	if (nfit_desc->provider_name)
+		return nfit_desc->provider_name;
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
+static ssize_t revision_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_bus *nd_bus = to_nd_bus(dev);
+	struct nfit __iomem *nfit = nd_bus->nfit_desc->nfit_base;
+
+	return sprintf(buf, "%d\n", readb(&nfit->revision));
+}
+static DEVICE_ATTR_RO(revision);
+
+static struct attribute *nd_bus_attributes[] = {
+	&dev_attr_provider.attr,
+	&dev_attr_revision.attr,
+	NULL,
+};
+
+static struct attribute_group nd_bus_attribute_group = {
+	.attrs = nd_bus_attributes,
+};
+
+static const struct attribute_group *nd_bus_attribute_groups[] = {
+	&nd_bus_attribute_group,
+	NULL,
+};
+
 static void *nd_bus_new(struct device *parent,
 		struct nfit_bus_descriptor *nfit_desc)
 {
@@ -81,6 +131,7 @@ static void *nd_bus_new(struct device *parent,
 	INIT_LIST_HEAD(&nd_bus->bdws);
 	INIT_LIST_HEAD(&nd_bus->memdevs);
 	INIT_LIST_HEAD(&nd_bus->dimms);
+	INIT_LIST_HEAD(&nd_bus->list);
 	nd_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
 	if (nd_bus->id < 0) {
 		kfree(nd_bus);
@@ -89,6 +140,7 @@ static void *nd_bus_new(struct device *parent,
 	nd_bus->nfit_desc = nfit_desc;
 	nd_bus->dev.parent = parent;
 	nd_bus->dev.release = nd_bus_release;
+	nd_bus->dev.groups = nd_bus_attribute_groups;
 	dev_set_name(&nd_bus->dev, "ndbus%d", nd_bus->id);
 	rc = device_register(&nd_bus->dev);
 	if (rc) {
@@ -428,6 +480,14 @@ static struct nd_bus *nd_bus_probe(struct nd_bus *nd_bus)
 	if (rc)
 		goto err;
 
+	rc = nd_bus_create_ndctl(nd_bus);
+	if (rc)
+		goto err;
+
+	mutex_lock(&nd_bus_list_mutex);
+	list_add_tail(&nd_bus->list, &nd_bus_list);
+	mutex_unlock(&nd_bus_list_mutex);
+
 	return nd_bus;
  err:
 	put_device(&nd_bus->dev);
@@ -458,6 +518,13 @@ void nfit_bus_unregister(struct nd_bus *nd_bus)
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
 EXPORT_SYMBOL(nfit_bus_unregister);
@@ -472,11 +539,13 @@ static __init int nd_core_init(void)
 	BUILD_BUG_ON(sizeof(struct nfit_dcr) != 80);
 	BUILD_BUG_ON(sizeof(struct nfit_bdw) != 40);
 
-	return 0;
+	return nd_bus_init();
 }
 
 static __exit void nd_core_exit(void)
 {
+	WARN_ON(!list_empty(&nd_bus_list));
+	nd_bus_exit();
 }
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Intel Corporation");
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index 0ede8818f320..4bcc9c96cb4d 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -57,5 +57,10 @@ struct nd_mem {
 	struct nfit_spa __iomem *nfit_spa_bdw;
 	struct list_head list;
 };
+
 struct nd_bus *to_nd_bus(struct device *dev);
+int __init nd_bus_init(void);
+void __exit nd_bus_exit(void);
+int nd_bus_create_ndctl(struct nd_bus *nd_bus);
+void nd_bus_destroy_ndctl(struct nd_bus *nd_bus);
 #endif /* __ND_PRIVATE_H__ */

