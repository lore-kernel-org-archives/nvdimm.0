Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id A8AFF1A1EBE
 for <linux-nvdimm@lists.01.org>; Sun,  8 May 2016 15:36:24 -0700 (PDT)
Subject: [PATCH 5/7] /dev/dax, pmem: direct access to persistent memory
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 08 May 2016 15:35:36 -0700
Message-ID: <146274693670.10891.14182763683222309275.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146274690999.10891.10714722986208180484.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146274690999.10891.10714722986208180484.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Device DAX is the device-centric analogue of Filesystem DAX
(CONFIG_FS_DAX).  It allows memory ranges to be allocated and mapped
without need of an intervening file system.  Device DAX is strict,
precise and predictable.  Specifically this interface:

1/ Guarantees fault granularity with respect to a given page size (pte,
pmd, or pud) set at configuration time.

2/ Enforces deterministic behavior by being strict about what fault
scenarios are supported.

For example, by forcing MADV_DONTFORK semantics and omitting MAP_PRIVATE
support device-dax guarantees that a mapping always behaves/performs the
same once established.  It is the "what you see is what you get" access
mechanism to differentiated memory vs filesystem DAX which has
filesystem specific implementation semantics.

Persistent memory is the first target, but the mechanism is also
targeted for exclusive allocations of performance differentiated memory
ranges.

This commit is limited to the base device driver infrastructure to
associate a dax device with pmem range.

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/Kconfig                     |    2 
 drivers/Makefile                    |    1 
 drivers/dax/Kconfig                 |   25 ++++
 drivers/dax/Makefile                |    4 +
 drivers/dax/dax.c                   |  223 +++++++++++++++++++++++++++++++++++
 drivers/dax/dax.h                   |   24 ++++
 drivers/dax/pmem.c                  |  168 ++++++++++++++++++++++++++
 tools/testing/nvdimm/Kbuild         |    9 +
 tools/testing/nvdimm/config_check.c |    2 
 9 files changed, 458 insertions(+)
 create mode 100644 drivers/dax/Kconfig
 create mode 100644 drivers/dax/Makefile
 create mode 100644 drivers/dax/dax.c
 create mode 100644 drivers/dax/dax.h
 create mode 100644 drivers/dax/pmem.c

diff --git a/drivers/Kconfig b/drivers/Kconfig
index d2ac339de85f..8298eab84a6f 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -190,6 +190,8 @@ source "drivers/android/Kconfig"
 
 source "drivers/nvdimm/Kconfig"
 
+source "drivers/dax/Kconfig"
+
 source "drivers/nvmem/Kconfig"
 
 source "drivers/hwtracing/stm/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 8f5d076baeb0..0b6f3d60193d 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -66,6 +66,7 @@ obj-$(CONFIG_PARPORT)		+= parport/
 obj-$(CONFIG_NVM)		+= lightnvm/
 obj-y				+= base/ block/ misc/ mfd/ nfc/
 obj-$(CONFIG_LIBNVDIMM)		+= nvdimm/
+obj-$(CONFIG_DEV_DAX)		+= dax/
 obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf/
 obj-$(CONFIG_NUBUS)		+= nubus/
 obj-y				+= macintosh/
diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
new file mode 100644
index 000000000000..86ffbaa891ad
--- /dev/null
+++ b/drivers/dax/Kconfig
@@ -0,0 +1,25 @@
+menuconfig DEV_DAX
+	tristate "DAX: direct access to differentiated memory"
+	default m if NVDIMM_DAX
+	help
+	  Support raw access to differentiated (persistence, bandwidth,
+	  latency...) memory via an mmap(2) capable character
+	  device.  Platform firmware or a device driver may identify a
+	  platform memory resource that is differentiated from the
+	  baseline memory pool.  Mappings of a /dev/daxX.Y device impose
+	  restrictions that make the mapping behavior deterministic.
+
+if DEV_DAX
+
+config DEV_DAX_PMEM
+	tristate "PMEM DAX: direct access to persistent memory"
+	depends on NVDIMM_DAX
+	default DEV_DAX
+	help
+	  Support raw access to persistent memory.  Note that this
+	  driver consumes memory ranges allocated and exported by the
+	  libnvdimm sub-system.
+
+	  Say Y if unsure
+
+endif
diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
new file mode 100644
index 000000000000..27c54e38478a
--- /dev/null
+++ b/drivers/dax/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_DEV_DAX) += dax.o
+obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
+
+dax_pmem-y := pmem.o
diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
new file mode 100644
index 000000000000..e95af4ead357
--- /dev/null
+++ b/drivers/dax/dax.c
@@ -0,0 +1,223 @@
+/*
+ * Copyright(c) 2016 Intel Corporation. All rights reserved.
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
+#include <linux/pagemap.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/pfn_t.h>
+#include <linux/slab.h>
+#include <linux/dax.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+
+static int dax_major;
+static struct class *dax_class;
+static DEFINE_IDA(dax_minor_ida);
+
+struct dax_region {
+	int id;
+	struct ida ida;
+	void *base;
+	struct kref kref;
+	struct device *dev;
+	unsigned int align;
+	struct resource res;
+	unsigned long pfn_flags;
+};
+
+struct dax_dev {
+	struct dax_region *region;
+	struct device *dev;
+	int num_resources;
+	struct resource res[0];
+};
+
+static void dax_region_release(struct kref *kref)
+{
+	struct dax_region *dax_region;
+
+	dax_region = container_of(kref, struct dax_region, kref);
+	kfree(dax_region);
+}
+
+void dax_region_put(struct dax_region *dax_region)
+{
+	kref_put(&dax_region->kref, dax_region_release);
+}
+EXPORT_SYMBOL_GPL(dax_region_put);
+
+static void dax_release(struct device *dev)
+{
+	struct dax_dev *dax_dev = dev_get_drvdata(dev);
+	struct dax_region *dax_region = dax_dev->region;
+	int region_id, id, rc, minor;
+
+	dev_dbg(dev, "%s\n", __func__);
+	rc = sscanf(dev_name(dev), "dax%d.%d", &region_id, &id);
+	WARN_ON(rc != 2 || dax_region->id != region_id);
+
+	ida_simple_remove(&dax_region->ida, id);
+	minor = MINOR(dev->devt);
+	ida_simple_remove(&dax_minor_ida, minor);
+	dax_region_put(dax_region);
+}
+
+struct dax_region *alloc_dax_region(struct device *parent,
+		int region_id, struct resource *res, unsigned int align,
+		void *addr, unsigned long pfn_flags)
+{
+	struct dax_region *dax_region;
+
+	dax_region = kzalloc(sizeof(*dax_region), GFP_KERNEL);
+
+	if (!dax_region)
+		return NULL;
+
+	memcpy(&dax_region->res, res, sizeof(*res));
+	dax_region->pfn_flags = pfn_flags;
+	kref_init(&dax_region->kref);
+	dax_region->id = region_id;
+	ida_init(&dax_region->ida);
+	dax_region->align = align;
+	dax_region->dev = parent;
+	dax_region->base = addr;
+
+	return dax_region;
+}
+EXPORT_SYMBOL_GPL(alloc_dax_region);
+
+static ssize_t size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dax_dev *dax_dev = dev_get_drvdata(dev);
+	unsigned long long size = 0;
+	int i;
+
+	for (i = 0; i < dax_dev->num_resources; i++)
+		size += resource_size(&dax_dev->res[i]);
+
+	return sprintf(buf, "%llu\n", size);
+}
+static DEVICE_ATTR_RO(size);
+
+static struct attribute *dax_device_attributes[] = {
+	&dev_attr_size.attr,
+	NULL,
+};
+
+static const struct attribute_group dax_device_attribute_group = {
+	.attrs = dax_device_attributes,
+};
+
+static const struct attribute_group *dax_attribute_groups[] = {
+	&dax_device_attribute_group,
+	NULL,
+};
+
+static void destroy_dax_dev(void *dev)
+{
+	dev_dbg(dev, "%s\n", __func__);
+	device_unregister(dev);
+}
+
+int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
+		int count)
+{
+	struct device *parent = dax_region->dev;
+	struct dax_dev *dax_dev;
+	struct device *dev;
+	int id, rc, minor;
+	dev_t dev_t;
+
+	dax_dev = kzalloc(sizeof(*dax_dev) + sizeof(*res) * count, GFP_KERNEL);
+	if (!dax_dev)
+		return -ENOMEM;
+	memcpy(dax_dev->res, res, sizeof(*res) * count);
+	dax_dev->num_resources = count;
+	dax_dev->region = dax_region;
+	kref_get(&dax_region->kref);
+
+	id = ida_simple_get(&dax_region->ida, 0, 0, GFP_KERNEL);
+	if (id < 0) {
+		rc = id;
+		goto err_id;
+	}
+
+	minor = ida_simple_get(&dax_minor_ida, 0, 0, GFP_KERNEL);
+	if (minor < 0) {
+		rc = minor;
+		goto err_minor;
+	}
+
+	dev_t = MKDEV(dax_major, id);
+	dev = device_create_with_groups(dax_class, parent, dev_t, dax_dev,
+			dax_attribute_groups, "dax%d.%d", dax_region->id, id);
+	if (IS_ERR(dev)) {
+		rc = PTR_ERR(dev);
+		goto err_create;
+	}
+	dax_dev->dev = dev;
+
+	rc = devm_add_action(dax_region->dev, destroy_dax_dev, dev);
+	if (rc) {
+		destroy_dax_dev(dev);
+		return rc;
+	}
+
+	return 0;
+
+ err_create:
+	ida_simple_remove(&dax_minor_ida, minor);
+ err_minor:
+	ida_simple_remove(&dax_region->ida, id);
+ err_id:
+	dax_region_put(dax_region);
+	kfree(dax_dev);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(devm_create_dax_dev);
+
+static const struct file_operations dax_fops = {
+	.llseek = noop_llseek,
+	.owner = THIS_MODULE,
+};
+
+static int __init dax_init(void)
+{
+	int rc;
+
+	rc = register_chrdev(0, "dax", &dax_fops);
+	if (rc < 0)
+		return rc;
+	dax_major = rc;
+
+	dax_class = class_create(THIS_MODULE, "dax");
+	if (IS_ERR(dax_class)) {
+		unregister_chrdev(dax_major, "dax");
+		return PTR_ERR(dax_class);
+	}
+	dax_class->dev_release = dax_release;
+
+	return 0;
+}
+
+static void __exit dax_exit(void)
+{
+	class_destroy(dax_class);
+	unregister_chrdev(dax_major, "dax");
+}
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
+subsys_initcall(dax_init);
+module_exit(dax_exit);
diff --git a/drivers/dax/dax.h b/drivers/dax/dax.h
new file mode 100644
index 000000000000..d8b8f1f25054
--- /dev/null
+++ b/drivers/dax/dax.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright(c) 2016 Intel Corporation. All rights reserved.
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
+#ifndef __DAX_H__
+#define __DAX_H__
+struct device;
+struct resource;
+struct dax_region;
+void dax_region_put(struct dax_region *dax_region);
+struct dax_region *alloc_dax_region(struct device *parent,
+		int region_id, struct resource *res, unsigned int align,
+		void *addr, unsigned long flags);
+int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
+		int count);
+#endif /* __DAX_H__ */
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
new file mode 100644
index 000000000000..4e97555e1cab
--- /dev/null
+++ b/drivers/dax/pmem.c
@@ -0,0 +1,168 @@
+/*
+ * Copyright(c) 2016 Intel Corporation. All rights reserved.
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
+#include <linux/percpu-refcount.h>
+#include <linux/memremap.h>
+#include <linux/module.h>
+#include <linux/pfn_t.h>
+#include "../nvdimm/pfn.h"
+#include "../nvdimm/nd.h"
+#include "dax.h"
+
+struct dax_pmem {
+	struct device *dev;
+	struct percpu_ref ref;
+	struct completion cmp;
+};
+
+struct dax_pmem *to_dax_pmem(struct percpu_ref *ref)
+{
+	return container_of(ref, struct dax_pmem, ref);
+}
+
+static void dax_pmem_percpu_release(struct percpu_ref *ref)
+{
+	struct dax_pmem *dax_pmem = to_dax_pmem(ref);
+
+	dev_dbg(dax_pmem->dev, "%s\n", __func__);
+	complete(&dax_pmem->cmp);
+}
+
+static void dax_pmem_percpu_exit(void *data)
+{
+	struct percpu_ref *ref = data;
+	struct dax_pmem *dax_pmem = to_dax_pmem(ref);
+
+	dev_dbg(dax_pmem->dev, "%s\n", __func__);
+	percpu_ref_exit(ref);
+	wait_for_completion(&dax_pmem->cmp);
+}
+
+static void dax_pmem_percpu_kill(void *data)
+{
+	struct percpu_ref *ref = data;
+	struct dax_pmem *dax_pmem = to_dax_pmem(ref);
+
+	dev_dbg(dax_pmem->dev, "%s\n", __func__);
+	percpu_ref_kill(ref);
+}
+
+static int dax_pmem_probe(struct device *dev)
+{
+	int rc;
+	void *addr;
+	struct resource res;
+	struct nd_pfn_sb *pfn_sb;
+	struct dax_pmem *dax_pmem;
+	struct nd_region *nd_region;
+	struct nd_namespace_io *nsio;
+	struct dax_region *dax_region;
+	struct nd_namespace_common *ndns;
+	struct nd_dax *nd_dax = to_nd_dax(dev);
+	struct nd_pfn *nd_pfn = &nd_dax->nd_pfn;
+	struct vmem_altmap __altmap, *altmap = NULL;
+
+	ndns = nvdimm_namespace_common_probe(dev);
+	if (IS_ERR(ndns))
+		return PTR_ERR(ndns);
+	nsio = to_nd_namespace_io(&ndns->dev);
+
+	/* parse the 'pfn' info block via ->rw_bytes */
+	devm_nsio_enable(dev, nsio);
+	altmap = nvdimm_setup_pfn(nd_pfn, &res, &__altmap);
+	if (IS_ERR(altmap))
+		return PTR_ERR(altmap);
+	devm_nsio_disable(dev, nsio);
+
+	pfn_sb = nd_pfn->pfn_sb;
+
+	if (!devm_request_mem_region(dev, nsio->res.start,
+				resource_size(&nsio->res), dev_name(dev))) {
+		dev_warn(dev, "could not reserve region %pR\n", &nsio->res);
+		return -EBUSY;
+	}
+
+	dax_pmem = devm_kzalloc(dev, sizeof(*dax_pmem), GFP_KERNEL);
+	if (!dax_pmem)
+		return -ENOMEM;
+
+	dax_pmem->dev = dev;
+	init_completion(&dax_pmem->cmp);
+	rc = percpu_ref_init(&dax_pmem->ref, dax_pmem_percpu_release, 0,
+			GFP_KERNEL);
+	if (rc)
+		return rc;
+
+	rc = devm_add_action(dev, dax_pmem_percpu_exit, &dax_pmem->ref);
+	if (rc) {
+		dax_pmem_percpu_exit(&dax_pmem->ref);
+		return rc;
+	}
+
+	addr = devm_memremap_pages(dev, &res, &dax_pmem->ref, altmap);
+	if (IS_ERR(addr))
+		return PTR_ERR(addr);
+
+	rc = devm_add_action(dev, dax_pmem_percpu_kill, &dax_pmem->ref);
+	if (rc) {
+		dax_pmem_percpu_kill(&dax_pmem->ref);
+		return rc;
+	}
+
+	nd_region = to_nd_region(dev->parent);
+	dax_region = alloc_dax_region(dev, nd_region->id, &res,
+			le32_to_cpu(pfn_sb->align), addr, PFN_DEV|PFN_MAP);
+	if (!dax_region)
+		return -ENOMEM;
+
+	/* TODO: support for subdividing a dax region... */
+	rc = devm_create_dax_dev(dax_region, &res, 1);
+
+	/* child dax_dev instances now own the lifetime of the dax_region */
+	dax_region_put(dax_region);
+
+	return rc;
+}
+
+static int dax_pmem_remove(struct device *dev)
+{
+	/*
+	 * The init path is fully devm-enabled, or child devices
+	 * otherwise hold references on parent resources.
+	 */
+	return 0;
+}
+
+static struct nd_device_driver dax_pmem_driver = {
+	.probe = dax_pmem_probe,
+	.remove = dax_pmem_remove,
+	.drv = {
+		.name = "dax_pmem",
+	},
+	.type = ND_DRIVER_DAX_PMEM,
+};
+
+static int __init dax_pmem_init(void)
+{
+	return nd_driver_register(&dax_pmem_driver);
+}
+module_init(dax_pmem_init);
+
+static void __exit dax_pmem_exit(void)
+{
+	driver_unregister(&dax_pmem_driver.drv);
+}
+module_exit(dax_pmem_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_DAX_PMEM);
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 5ff6d3c126a9..785985677159 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -16,6 +16,7 @@ ldflags-y += --wrap=phys_to_pfn_t
 DRIVERS := ../../../drivers
 NVDIMM_SRC := $(DRIVERS)/nvdimm
 ACPI_SRC := $(DRIVERS)/acpi
+DAX_SRC := $(DRIVERS)/dax
 
 obj-$(CONFIG_LIBNVDIMM) += libnvdimm.o
 obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
@@ -23,6 +24,8 @@ obj-$(CONFIG_ND_BTT) += nd_btt.o
 obj-$(CONFIG_ND_BLK) += nd_blk.o
 obj-$(CONFIG_X86_PMEM_LEGACY) += nd_e820.o
 obj-$(CONFIG_ACPI_NFIT) += nfit.o
+obj-$(CONFIG_DEV_DAX) += dax.o
+obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
 
 nfit-y := $(ACPI_SRC)/nfit.o
 nfit-y += config_check.o
@@ -39,6 +42,12 @@ nd_blk-y += config_check.o
 nd_e820-y := $(NVDIMM_SRC)/e820.o
 nd_e820-y += config_check.o
 
+dax-y := $(DAX_SRC)/dax.o
+dax-y += config_check.o
+
+dax_pmem-y := $(DAX_SRC)/pmem.o
+dax_pmem-y += config_check.o
+
 libnvdimm-y := $(NVDIMM_SRC)/core.o
 libnvdimm-y += $(NVDIMM_SRC)/bus.o
 libnvdimm-y += $(NVDIMM_SRC)/dimm_devs.o
diff --git a/tools/testing/nvdimm/config_check.c b/tools/testing/nvdimm/config_check.c
index f2c7615554eb..adf18bfeca00 100644
--- a/tools/testing/nvdimm/config_check.c
+++ b/tools/testing/nvdimm/config_check.c
@@ -12,4 +12,6 @@ void check(void)
 	BUILD_BUG_ON(!IS_MODULE(CONFIG_ND_BTT));
 	BUILD_BUG_ON(!IS_MODULE(CONFIG_ND_BLK));
 	BUILD_BUG_ON(!IS_MODULE(CONFIG_ACPI_NFIT));
+	BUILD_BUG_ON(!IS_MODULE(CONFIG_DEV_DAX));
+	BUILD_BUG_ON(!IS_MODULE(CONFIG_DEV_DAX_PMEM));
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
