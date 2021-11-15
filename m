Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A497A68
	for <nvdimm@lists.linux.dev>; Mon, 15 Nov 2021 21:20:59 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="294354234"
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="294354234"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 13:20:58 -0800
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="548172850"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 13:20:58 -0800
Subject: [PATCH v2] dax: Kill DEV_DAX_PMEM_COMPAT
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Jane Chu <jane.chu@oracle.com>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, linux-mm@kvack.org
Date: Mon, 15 Nov 2021 13:20:57 -0800
Message-ID: <163701116195.3784476.726128179293466337.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <163543595723.2281838.11942022992765100714.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163543595723.2281838.11942022992765100714.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The /sys/class/dax compatibility option has shipped in the kernel for 4
years now which should be sufficient time for tools to abandon the old
ABI in favor of the /sys/bus/dax device-model. Delete it now and see if
anyone screams.

Since this compatibility option shipped there has been more reports of
users being surprised by the compat ABI than surprised by the "new", so
the compat infrastructure has outlived its usefulness. Recall that
/sys/bus/dax device-model is required for the dax kmem driver which
allows PMEM to be used as "System RAM".

The following projects were known to have a dependency on /sys/class/dax
and have dropped their dependency as of the listed version:

- ndctl (including libndctl, daxctl, and libdaxctl): v64+
- fio: v3.13+
- pmdk: v1.5.2+

As further evidence this option is no longer needed some distributions
have already stopped enabling CONFIG_DEV_DAX_PMEM_COMPAT.

Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>
Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes in v2:

- Update the changelog to list userspace packages that have dropped
  their dependency and note that some distributions have already dropped
  this option.

- Delete the sysfs-class-dax ABI entry.

 Documentation/ABI/obsolete/sysfs-class-dax  |   22 --------
 drivers/dax/Kconfig                         |    9 ---
 drivers/dax/Makefile                        |    3 +
 drivers/dax/bus.c                           |   21 +-------
 drivers/dax/bus.h                           |   13 -----
 drivers/dax/device.c                        |    6 --
 drivers/dax/pmem.c                          |   36 +++++++++++---
 drivers/dax/pmem/Makefile                   |    1 
 drivers/dax/pmem/compat.c                   |   72 ---------------------------
 drivers/dax/pmem/pmem.c                     |   30 -----------
 tools/testing/nvdimm/Kbuild                 |    8 ---
 tools/testing/nvdimm/dax_pmem_compat_test.c |    8 ---
 tools/testing/nvdimm/dax_pmem_core_test.c   |    8 ---
 tools/testing/nvdimm/test/ndtest.c          |    4 --
 tools/testing/nvdimm/test/nfit.c            |    4 --
 15 files changed, 36 insertions(+), 209 deletions(-)
 delete mode 100644 Documentation/ABI/obsolete/sysfs-class-dax
 rename drivers/dax/{pmem/core.c => pmem.c} (75%)
 delete mode 100644 drivers/dax/pmem/compat.c
 delete mode 100644 tools/testing/nvdimm/dax_pmem_compat_test.c
 delete mode 100644 tools/testing/nvdimm/dax_pmem_core_test.c

diff --git a/Documentation/ABI/obsolete/sysfs-class-dax b/Documentation/ABI/obsolete/sysfs-class-dax
deleted file mode 100644
index 5bcce27458e3..000000000000
--- a/Documentation/ABI/obsolete/sysfs-class-dax
+++ /dev/null
@@ -1,22 +0,0 @@
-What:           /sys/class/dax/
-Date:           May, 2016
-KernelVersion:  v4.7
-Contact:        nvdimm@lists.linux.dev
-Description:	Device DAX is the device-centric analogue of Filesystem
-		DAX (CONFIG_FS_DAX).  It allows memory ranges to be
-		allocated and mapped without need of an intervening file
-		system.  Device DAX is strict, precise and predictable.
-		Specifically this interface:
-
-		1. Guarantees fault granularity with respect to a given
-		   page size (pte, pmd, or pud) set at configuration time.
-
-		2. Enforces deterministic behavior by being strict about
-		   what fault scenarios are supported.
-
-		The /sys/class/dax/ interface enumerates all the
-		device-dax instances in the system. The ABI is
-		deprecated and will be removed after 2020. It is
-		replaced with the DAX bus interface /sys/bus/dax/ where
-		device-dax instances can be found under
-		/sys/bus/dax/devices/
diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index d2834c2cfa10..15b442ef7b93 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -70,13 +70,4 @@ config DEV_DAX_KMEM
 
 	  Say N if unsure.
 
-config DEV_DAX_PMEM_COMPAT
-	tristate "PMEM DAX: support the deprecated /sys/class/dax interface"
-	depends on m && DEV_DAX_PMEM=m
-	default DEV_DAX_PMEM
-	help
-	  Older versions of the libdaxctl library expect to find all
-	  device-dax instances under /sys/class/dax. If libdaxctl in
-	  your distribution is older than v58 say M, otherwise say N.
-
 endif
diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
index 9d4ba672d305..90a56ca3b345 100644
--- a/drivers/dax/Makefile
+++ b/drivers/dax/Makefile
@@ -2,10 +2,11 @@
 obj-$(CONFIG_DAX) += dax.o
 obj-$(CONFIG_DEV_DAX) += device_dax.o
 obj-$(CONFIG_DEV_DAX_KMEM) += kmem.o
+obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
 
 dax-y := super.o
 dax-y += bus.o
 device_dax-y := device.o
+dax_pmem-y := pmem.o
 
-obj-y += pmem/
 obj-y += hmem/
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 6cc4da4c713d..452cf7860926 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -10,8 +10,6 @@
 #include "dax-private.h"
 #include "bus.h"
 
-static struct class *dax_class;
-
 static DEFINE_MUTEX(dax_bus_lock);
 
 #define DAX_NAME_LEN 30
@@ -1343,10 +1341,7 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
 
 	inode = dax_inode(dax_dev);
 	dev->devt = inode->i_rdev;
-	if (data->subsys == DEV_DAX_BUS)
-		dev->bus = &dax_bus_type;
-	else
-		dev->class = dax_class;
+	dev->bus = &dax_bus_type;
 	dev->parent = parent;
 	dev->type = &dev_dax_type;
 
@@ -1445,22 +1440,10 @@ EXPORT_SYMBOL_GPL(dax_driver_unregister);
 
 int __init dax_bus_init(void)
 {
-	int rc;
-
-	if (IS_ENABLED(CONFIG_DEV_DAX_PMEM_COMPAT)) {
-		dax_class = class_create(THIS_MODULE, "dax");
-		if (IS_ERR(dax_class))
-			return PTR_ERR(dax_class);
-	}
-
-	rc = bus_register(&dax_bus_type);
-	if (rc)
-		class_destroy(dax_class);
-	return rc;
+	return bus_register(&dax_bus_type);
 }
 
 void __exit dax_bus_exit(void)
 {
 	bus_unregister(&dax_bus_type);
-	class_destroy(dax_class);
 }
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index 1e946ad7780a..381cec9ff05c 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -16,24 +16,15 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		struct range *range, int target_node, unsigned int align,
 		unsigned long flags);
 
-enum dev_dax_subsys {
-	DEV_DAX_BUS = 0, /* zeroed dev_dax_data picks this by default */
-	DEV_DAX_CLASS,
-};
-
 struct dev_dax_data {
 	struct dax_region *dax_region;
 	struct dev_pagemap *pgmap;
-	enum dev_dax_subsys subsys;
 	resource_size_t size;
 	int id;
 };
 
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
 
-/* to be deleted when DEV_DAX_CLASS is removed */
-struct dev_dax *__dax_pmem_probe(struct device *dev, enum dev_dax_subsys subsys);
-
 struct dax_device_driver {
 	struct device_driver drv;
 	struct list_head ids;
@@ -49,10 +40,6 @@ int __dax_driver_register(struct dax_device_driver *dax_drv,
 void dax_driver_unregister(struct dax_device_driver *dax_drv);
 void kill_dev_dax(struct dev_dax *dev_dax);
 
-#if IS_ENABLED(CONFIG_DEV_DAX_PMEM_COMPAT)
-int dev_dax_probe(struct dev_dax *dev_dax);
-#endif
-
 /*
  * While run_dax() is potentially a generic operation that could be
  * defined in include/linux/dax.h we don't want to grow any users
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index dd8222a42808..e58d597f0415 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -433,11 +433,7 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 	inode = dax_inode(dax_dev);
 	cdev = inode->i_cdev;
 	cdev_init(cdev, &dax_fops);
-	if (dev->class) {
-		/* for the CONFIG_DEV_DAX_PMEM_COMPAT case */
-		cdev->owner = dev->parent->driver->owner;
-	} else
-		cdev->owner = dev->driver->owner;
+	cdev->owner = dev->driver->owner;
 	cdev_set_parent(cdev, &dev->kobj);
 	rc = cdev_add(cdev, dev->devt, 1);
 	if (rc)
diff --git a/drivers/dax/pmem/core.c b/drivers/dax/pmem.c
similarity index 75%
rename from drivers/dax/pmem/core.c
rename to drivers/dax/pmem.c
index 062e8bc14223..f050ea78bb83 100644
--- a/drivers/dax/pmem/core.c
+++ b/drivers/dax/pmem.c
@@ -3,11 +3,11 @@
 #include <linux/memremap.h>
 #include <linux/module.h>
 #include <linux/pfn_t.h>
-#include "../../nvdimm/pfn.h"
-#include "../../nvdimm/nd.h"
-#include "../bus.h"
+#include "../nvdimm/pfn.h"
+#include "../nvdimm/nd.h"
+#include "bus.h"
 
-struct dev_dax *__dax_pmem_probe(struct device *dev, enum dev_dax_subsys subsys)
+static struct dev_dax *__dax_pmem_probe(struct device *dev)
 {
 	struct range range;
 	int rc, id, region_id;
@@ -63,7 +63,6 @@ struct dev_dax *__dax_pmem_probe(struct device *dev, enum dev_dax_subsys subsys)
 		.dax_region = dax_region,
 		.id = id,
 		.pgmap = &pgmap,
-		.subsys = subsys,
 		.size = range_len(&range),
 	};
 	dev_dax = devm_create_dev_dax(&data);
@@ -73,7 +72,32 @@ struct dev_dax *__dax_pmem_probe(struct device *dev, enum dev_dax_subsys subsys)
 
 	return dev_dax;
 }
-EXPORT_SYMBOL_GPL(__dax_pmem_probe);
+
+static int dax_pmem_probe(struct device *dev)
+{
+	return PTR_ERR_OR_ZERO(__dax_pmem_probe(dev));
+}
+
+static struct nd_device_driver dax_pmem_driver = {
+	.probe = dax_pmem_probe,
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
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Intel Corporation");
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_DAX_PMEM);
diff --git a/drivers/dax/pmem/Makefile b/drivers/dax/pmem/Makefile
index 010269f61d41..191c31f0d4f0 100644
--- a/drivers/dax/pmem/Makefile
+++ b/drivers/dax/pmem/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
 obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem_core.o
-obj-$(CONFIG_DEV_DAX_PMEM_COMPAT) += dax_pmem_compat.o
 
 dax_pmem-y := pmem.o
 dax_pmem_core-y := core.o
diff --git a/drivers/dax/pmem/compat.c b/drivers/dax/pmem/compat.c
deleted file mode 100644
index d81dc35fd65d..000000000000
--- a/drivers/dax/pmem/compat.c
+++ /dev/null
@@ -1,72 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright(c) 2016 - 2018 Intel Corporation. All rights reserved. */
-#include <linux/percpu-refcount.h>
-#include <linux/memremap.h>
-#include <linux/module.h>
-#include <linux/pfn_t.h>
-#include <linux/nd.h>
-#include "../bus.h"
-
-/* we need the private definitions to implement compat suport */
-#include "../dax-private.h"
-
-static int dax_pmem_compat_probe(struct device *dev)
-{
-	struct dev_dax *dev_dax = __dax_pmem_probe(dev, DEV_DAX_CLASS);
-	int rc;
-
-	if (IS_ERR(dev_dax))
-		return PTR_ERR(dev_dax);
-
-        if (!devres_open_group(&dev_dax->dev, dev_dax, GFP_KERNEL))
-		return -ENOMEM;
-
-	device_lock(&dev_dax->dev);
-	rc = dev_dax_probe(dev_dax);
-	device_unlock(&dev_dax->dev);
-
-	devres_close_group(&dev_dax->dev, dev_dax);
-	if (rc)
-		devres_release_group(&dev_dax->dev, dev_dax);
-
-	return rc;
-}
-
-static int dax_pmem_compat_release(struct device *dev, void *data)
-{
-	device_lock(dev);
-	devres_release_group(dev, to_dev_dax(dev));
-	device_unlock(dev);
-
-	return 0;
-}
-
-static void dax_pmem_compat_remove(struct device *dev)
-{
-	device_for_each_child(dev, NULL, dax_pmem_compat_release);
-}
-
-static struct nd_device_driver dax_pmem_compat_driver = {
-	.probe = dax_pmem_compat_probe,
-	.remove = dax_pmem_compat_remove,
-	.drv = {
-		.name = "dax_pmem_compat",
-	},
-	.type = ND_DRIVER_DAX_PMEM,
-};
-
-static int __init dax_pmem_compat_init(void)
-{
-	return nd_driver_register(&dax_pmem_compat_driver);
-}
-module_init(dax_pmem_compat_init);
-
-static void __exit dax_pmem_compat_exit(void)
-{
-	driver_unregister(&dax_pmem_compat_driver.drv);
-}
-module_exit(dax_pmem_compat_exit);
-
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Intel Corporation");
-MODULE_ALIAS_ND_DEVICE(ND_DEVICE_DAX_PMEM);
diff --git a/drivers/dax/pmem/pmem.c b/drivers/dax/pmem/pmem.c
index 0ae4238a0ef8..dfe91a2990fe 100644
--- a/drivers/dax/pmem/pmem.c
+++ b/drivers/dax/pmem/pmem.c
@@ -7,34 +7,4 @@
 #include <linux/nd.h>
 #include "../bus.h"
 
-static int dax_pmem_probe(struct device *dev)
-{
-	return PTR_ERR_OR_ZERO(__dax_pmem_probe(dev, DEV_DAX_BUS));
-}
 
-static struct nd_device_driver dax_pmem_driver = {
-	.probe = dax_pmem_probe,
-	.drv = {
-		.name = "dax_pmem",
-	},
-	.type = ND_DRIVER_DAX_PMEM,
-};
-
-static int __init dax_pmem_init(void)
-{
-	return nd_driver_register(&dax_pmem_driver);
-}
-module_init(dax_pmem_init);
-
-static void __exit dax_pmem_exit(void)
-{
-	driver_unregister(&dax_pmem_driver.drv);
-}
-module_exit(dax_pmem_exit);
-
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Intel Corporation");
-#if !IS_ENABLED(CONFIG_DEV_DAX_PMEM_COMPAT)
-/* For compat builds, don't load this module by default */
-MODULE_ALIAS_ND_DEVICE(ND_DEVICE_DAX_PMEM);
-#endif
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 47f9cc9dcd94..c57d9e9d4480 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -35,8 +35,6 @@ obj-$(CONFIG_DAX) += dax.o
 endif
 obj-$(CONFIG_DEV_DAX) += device_dax.o
 obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
-obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem_core.o
-obj-$(CONFIG_DEV_DAX_PMEM_COMPAT) += dax_pmem_compat.o
 
 nfit-y := $(ACPI_SRC)/core.o
 nfit-y += $(ACPI_SRC)/intel.o
@@ -67,12 +65,8 @@ device_dax-y += dax-dev.o
 device_dax-y += device_dax_test.o
 device_dax-y += config_check.o
 
-dax_pmem-y := $(DAX_SRC)/pmem/pmem.o
+dax_pmem-y := $(DAX_SRC)/pmem.o
 dax_pmem-y += dax_pmem_test.o
-dax_pmem_core-y := $(DAX_SRC)/pmem/core.o
-dax_pmem_core-y += dax_pmem_core_test.o
-dax_pmem_compat-y := $(DAX_SRC)/pmem/compat.o
-dax_pmem_compat-y += dax_pmem_compat_test.o
 dax_pmem-y += config_check.o
 
 libnvdimm-y := $(NVDIMM_SRC)/core.o
diff --git a/tools/testing/nvdimm/dax_pmem_compat_test.c b/tools/testing/nvdimm/dax_pmem_compat_test.c
deleted file mode 100644
index 7cd1877f3765..000000000000
--- a/tools/testing/nvdimm/dax_pmem_compat_test.c
+++ /dev/null
@@ -1,8 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-// Copyright(c) 2019 Intel Corporation. All rights reserved.
-
-#include <linux/module.h>
-#include <linux/printk.h>
-#include "watermark.h"
-
-nfit_test_watermark(dax_pmem_compat);
diff --git a/tools/testing/nvdimm/dax_pmem_core_test.c b/tools/testing/nvdimm/dax_pmem_core_test.c
deleted file mode 100644
index a4249cdbeec1..000000000000
--- a/tools/testing/nvdimm/dax_pmem_core_test.c
+++ /dev/null
@@ -1,8 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-// Copyright(c) 2019 Intel Corporation. All rights reserved.
-
-#include <linux/module.h>
-#include <linux/printk.h>
-#include "watermark.h"
-
-nfit_test_watermark(dax_pmem_core);
diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 6862915f1fb0..3ca7c32e9362 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -1054,10 +1054,6 @@ static __init int ndtest_init(void)
 	libnvdimm_test();
 	device_dax_test();
 	dax_pmem_test();
-	dax_pmem_core_test();
-#ifdef CONFIG_DEV_DAX_PMEM_COMPAT
-	dax_pmem_compat_test();
-#endif
 
 	nfit_test_setup(ndtest_resource_lookup, NULL);
 
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index b1bff5fb0f65..0bc91ffee257 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -3300,10 +3300,6 @@ static __init int nfit_test_init(void)
 	acpi_nfit_test();
 	device_dax_test();
 	dax_pmem_test();
-	dax_pmem_core_test();
-#ifdef CONFIG_DEV_DAX_PMEM_COMPAT
-	dax_pmem_compat_test();
-#endif
 
 	nfit_test_setup(nfit_test_lookup, nfit_test_evaluate_dsm);
 

