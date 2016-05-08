Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 7BE7B1A1E96
 for <linux-nvdimm@lists.01.org>; Sun,  8 May 2016 15:36:15 -0700 (PDT)
Subject: [PATCH 2/7] libnvdimm, dax: introduce device-dax infrastructure
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 08 May 2016 15:35:21 -0700
Message-ID: <146274692109.10891.2851263545727809769.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Device DAX is the device-centric analogue of Filesystem DAX
(CONFIG_FS_DAX).  It allows persistent memory ranges to be allocated and
mapped without need of an intervening file system.  This initial
infrastructure arranges for a libnvdimm pfn-device to be represented as
a different device-type so that it can be attached to a driver other
than the pmem driver.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/Kconfig          |   13 +++++
 drivers/nvdimm/Makefile         |    1 
 drivers/nvdimm/bus.c            |    4 ++
 drivers/nvdimm/claim.c          |    2 +
 drivers/nvdimm/dax_devs.c       |   99 +++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/namespace_devs.c |   19 +++++++
 drivers/nvdimm/nd-core.h        |    1 
 drivers/nvdimm/nd.h             |   25 ++++++++++
 drivers/nvdimm/pfn_devs.c       |  100 ++++++++++++++++++++++++++-------------
 drivers/nvdimm/region.c         |    2 +
 drivers/nvdimm/region_devs.c    |   29 +++++++++++
 include/uapi/linux/ndctl.h      |    2 +
 tools/testing/nvdimm/Kbuild     |    1 
 13 files changed, 264 insertions(+), 34 deletions(-)
 create mode 100644 drivers/nvdimm/dax_devs.c

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 53c11621d5b1..7c8a3bf07884 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -88,4 +88,17 @@ config NVDIMM_PFN
 
 	  Select Y if unsure
 
+config NVDIMM_DAX
+	bool "NVDIMM DAX: Raw access to persistent memory"
+	default LIBNVDIMM
+	depends on NVDIMM_PFN
+	help
+	  Support raw device dax access to a persistent memory
+	  namespace.  For environments that want to hard partition
+	  peristent memory, this capability provides a mechanism to
+	  sub-divide a namespace into character devices that can only be
+	  accessed via DAX (mmap(2)).
+
+	  Select Y if unsure
+
 endif
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index ea84d3c4e8e5..909554c3f955 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -23,3 +23,4 @@ libnvdimm-y += label.o
 libnvdimm-$(CONFIG_ND_CLAIM) += claim.o
 libnvdimm-$(CONFIG_BTT) += btt_devs.o
 libnvdimm-$(CONFIG_NVDIMM_PFN) += pfn_devs.o
+libnvdimm-$(CONFIG_NVDIMM_DAX) += dax_devs.o
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 19f822d7f652..97589e3cb852 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -40,6 +40,8 @@ static int to_nd_device_type(struct device *dev)
 		return ND_DEVICE_REGION_PMEM;
 	else if (is_nd_blk(dev))
 		return ND_DEVICE_REGION_BLK;
+	else if (is_nd_dax(dev))
+		return ND_DEVICE_DAX_PMEM;
 	else if (is_nd_pmem(dev->parent) || is_nd_blk(dev->parent))
 		return nd_region_to_nstype(to_nd_region(dev->parent));
 
@@ -246,6 +248,8 @@ static void nd_async_device_unregister(void *d, async_cookie_t cookie)
 
 void __nd_device_register(struct device *dev)
 {
+	if (!dev)
+		return;
 	dev->bus = &nvdimm_bus_type;
 	get_device(dev);
 	async_schedule_domain(nd_async_device_register, dev,
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 6bbd0a36994a..5f53db59a058 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -85,6 +85,8 @@ static bool is_idle(struct device *dev, struct nd_namespace_common *ndns)
 		seed = nd_region->btt_seed;
 	else if (is_nd_pfn(dev))
 		seed = nd_region->pfn_seed;
+	else if (is_nd_dax(dev))
+		seed = nd_region->dax_seed;
 
 	if (seed == dev || ndns || dev->driver)
 		return false;
diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
new file mode 100644
index 000000000000..f90f7549e7f4
--- /dev/null
+++ b/drivers/nvdimm/dax_devs.c
@@ -0,0 +1,99 @@
+/*
+ * Copyright(c) 2013-2016 Intel Corporation. All rights reserved.
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
+#include <linux/device.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include "nd-core.h"
+#include "nd.h"
+
+static void nd_dax_release(struct device *dev)
+{
+	struct nd_region *nd_region = to_nd_region(dev->parent);
+	struct nd_dax *nd_dax = to_nd_dax(dev);
+	struct nd_pfn *nd_pfn = &nd_dax->nd_pfn;
+
+	dev_dbg(dev, "%s\n", __func__);
+	nd_detach_ndns(dev, &nd_pfn->ndns);
+	ida_simple_remove(&nd_region->dax_ida, nd_pfn->id);
+	kfree(nd_pfn->uuid);
+	kfree(nd_dax);
+}
+
+static struct device_type nd_dax_device_type = {
+	.name = "nd_dax",
+	.release = nd_dax_release,
+};
+
+bool is_nd_dax(struct device *dev)
+{
+	return dev ? dev->type == &nd_dax_device_type : false;
+}
+EXPORT_SYMBOL(is_nd_dax);
+
+struct nd_dax *to_nd_dax(struct device *dev)
+{
+	struct nd_dax *nd_dax = container_of(dev, struct nd_dax, nd_pfn.dev);
+
+	WARN_ON(!is_nd_dax(dev));
+	return nd_dax;
+}
+EXPORT_SYMBOL(to_nd_dax);
+
+static const struct attribute_group *nd_dax_attribute_groups[] = {
+	&nd_pfn_attribute_group,
+	&nd_device_attribute_group,
+	&nd_numa_attribute_group,
+	NULL,
+};
+
+static struct nd_dax *nd_dax_alloc(struct nd_region *nd_region)
+{
+	struct nd_pfn *nd_pfn;
+	struct nd_dax *nd_dax;
+	struct device *dev;
+
+	nd_dax = kzalloc(sizeof(*nd_dax), GFP_KERNEL);
+	if (!nd_dax)
+		return NULL;
+
+	nd_pfn = &nd_dax->nd_pfn;
+	nd_pfn->id = ida_simple_get(&nd_region->dax_ida, 0, 0, GFP_KERNEL);
+	if (nd_pfn->id < 0) {
+		kfree(nd_dax);
+		return NULL;
+	}
+
+	dev = &nd_pfn->dev;
+	dev_set_name(dev, "dax%d.%d", nd_region->id, nd_pfn->id);
+	dev->groups = nd_dax_attribute_groups;
+	dev->type = &nd_dax_device_type;
+	dev->parent = &nd_region->dev;
+
+	return nd_dax;
+}
+
+struct device *nd_dax_create(struct nd_region *nd_region)
+{
+	struct device *dev = NULL;
+	struct nd_dax *nd_dax;
+
+	if (!is_nd_pmem(&nd_region->dev))
+		return NULL;
+
+	nd_dax = nd_dax_alloc(nd_region);
+	if (nd_dax)
+		dev = nd_pfn_devinit(&nd_dax->nd_pfn, NULL);
+	__nd_device_register(dev);
+	return dev;
+}
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index e5ad5162bf34..c5e3196c45b0 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1288,6 +1288,8 @@ static ssize_t mode_show(struct device *dev,
 		mode = "safe";
 	else if (claim && is_nd_pfn(claim))
 		mode = "memory";
+	else if (claim && is_nd_dax(claim))
+		mode = "dax";
 	else if (!claim && pmem_should_map_pages(dev))
 		mode = "memory";
 	else
@@ -1379,14 +1381,17 @@ struct nd_namespace_common *nvdimm_namespace_common_probe(struct device *dev)
 {
 	struct nd_btt *nd_btt = is_nd_btt(dev) ? to_nd_btt(dev) : NULL;
 	struct nd_pfn *nd_pfn = is_nd_pfn(dev) ? to_nd_pfn(dev) : NULL;
+	struct nd_dax *nd_dax = is_nd_dax(dev) ? to_nd_dax(dev) : NULL;
 	struct nd_namespace_common *ndns = NULL;
 	resource_size_t size;
 
-	if (nd_btt || nd_pfn) {
+	if (nd_btt || nd_pfn || nd_dax) {
 		if (nd_btt)
 			ndns = nd_btt->ndns;
 		else if (nd_pfn)
 			ndns = nd_pfn->ndns;
+		else if (nd_dax)
+			ndns = nd_dax->nd_pfn.ndns;
 
 		if (!ndns)
 			return ERR_PTR(-ENODEV);
@@ -1779,6 +1784,18 @@ void nd_region_create_blk_seed(struct nd_region *nd_region)
 		nd_device_register(nd_region->ns_seed);
 }
 
+void nd_region_create_dax_seed(struct nd_region *nd_region)
+{
+	WARN_ON(!is_nvdimm_bus_locked(&nd_region->dev));
+	nd_region->dax_seed = nd_dax_create(nd_region);
+	/*
+	 * Seed creation failures are not fatal, provisioning is simply
+	 * disabled until memory becomes available
+	 */
+	if (!nd_region->dax_seed)
+		dev_err(&nd_region->dev, "failed to create dax namespace\n");
+}
+
 void nd_region_create_pfn_seed(struct nd_region *nd_region)
 {
 	WARN_ON(!is_nvdimm_bus_locked(&nd_region->dev));
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 1d1500f3d8b5..cb65308c0329 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -54,6 +54,7 @@ struct nd_region;
 void nd_region_create_blk_seed(struct nd_region *nd_region);
 void nd_region_create_btt_seed(struct nd_region *nd_region);
 void nd_region_create_pfn_seed(struct nd_region *nd_region);
+void nd_region_create_dax_seed(struct nd_region *nd_region);
 void nd_region_disable(struct nvdimm_bus *nvdimm_bus, struct device *dev);
 int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 6c36509662e4..46910b8f32b1 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -101,10 +101,12 @@ struct nd_region {
 	struct ida ns_ida;
 	struct ida btt_ida;
 	struct ida pfn_ida;
+	struct ida dax_ida;
 	unsigned long flags;
 	struct device *ns_seed;
 	struct device *btt_seed;
 	struct device *pfn_seed;
+	struct device *dax_seed;
 	u16 ndr_mappings;
 	u64 ndr_size;
 	u64 ndr_start;
@@ -161,6 +163,10 @@ struct nd_pfn {
 	struct nd_namespace_common *ndns;
 };
 
+struct nd_dax {
+	struct nd_pfn nd_pfn;
+};
+
 enum nd_async_mode {
 	ND_SYNC,
 	ND_ASYNC,
@@ -224,7 +230,10 @@ struct nd_pfn *to_nd_pfn(struct device *dev);
 int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns);
 bool is_nd_pfn(struct device *dev);
 struct device *nd_pfn_create(struct nd_region *nd_region);
+struct device *nd_pfn_devinit(struct nd_pfn *nd_pfn,
+		struct nd_namespace_common *ndns);
 int nd_pfn_validate(struct nd_pfn *nd_pfn);
+extern struct attribute_group nd_pfn_attribute_group;
 #else
 static inline int nd_pfn_probe(struct device *dev,
 		struct nd_namespace_common *ndns)
@@ -248,6 +257,22 @@ static inline int nd_pfn_validate(struct nd_pfn *nd_pfn)
 }
 #endif
 
+struct nd_dax *to_nd_dax(struct device *dev);
+#if IS_ENABLED(CONFIG_NVDIMM_DAX)
+bool is_nd_dax(struct device *dev);
+struct device *nd_dax_create(struct nd_region *nd_region);
+#else
+static inline bool is_nd_dax(struct device *dev)
+{
+	return false;
+}
+
+static inline struct device *nd_dax_create(struct nd_region *nd_region)
+{
+	return NULL;
+}
+#endif
+
 struct nd_region *to_nd_region(struct device *dev);
 int nd_region_to_nstype(struct nd_region *nd_region);
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index e8693fe65e49..6ade2eb7615d 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013-2016 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -54,10 +54,29 @@ struct nd_pfn *to_nd_pfn(struct device *dev)
 }
 EXPORT_SYMBOL(to_nd_pfn);
 
+static struct nd_pfn *to_nd_pfn_safe(struct device *dev)
+{
+	/*
+	 * pfn device attributes are re-used by dax device instances, so we
+	 * need to be careful to correct device-to-nd_pfn conversion.
+	 */
+	if (is_nd_pfn(dev))
+		return to_nd_pfn(dev);
+
+	if (is_nd_dax(dev)) {
+		struct nd_dax *nd_dax = to_nd_dax(dev);
+
+		return &nd_dax->nd_pfn;
+	}
+
+	WARN_ON(1);
+	return NULL;
+}
+
 static ssize_t mode_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nd_pfn *nd_pfn = to_nd_pfn(dev);
+	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
 
 	switch (nd_pfn->mode) {
 	case PFN_MODE_RAM:
@@ -72,7 +91,7 @@ static ssize_t mode_show(struct device *dev,
 static ssize_t mode_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
-	struct nd_pfn *nd_pfn = to_nd_pfn(dev);
+	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
 	ssize_t rc = 0;
 
 	device_lock(dev);
@@ -106,7 +125,7 @@ static DEVICE_ATTR_RW(mode);
 static ssize_t align_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nd_pfn *nd_pfn = to_nd_pfn(dev);
+	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
 
 	return sprintf(buf, "%lx\n", nd_pfn->align);
 }
@@ -134,7 +153,7 @@ static ssize_t __align_store(struct nd_pfn *nd_pfn, const char *buf)
 static ssize_t align_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
-	struct nd_pfn *nd_pfn = to_nd_pfn(dev);
+	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
 	ssize_t rc;
 
 	device_lock(dev);
@@ -152,7 +171,7 @@ static DEVICE_ATTR_RW(align);
 static ssize_t uuid_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nd_pfn *nd_pfn = to_nd_pfn(dev);
+	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
 
 	if (nd_pfn->uuid)
 		return sprintf(buf, "%pUb\n", nd_pfn->uuid);
@@ -162,7 +181,7 @@ static ssize_t uuid_show(struct device *dev,
 static ssize_t uuid_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
-	struct nd_pfn *nd_pfn = to_nd_pfn(dev);
+	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
 	ssize_t rc;
 
 	device_lock(dev);
@@ -178,7 +197,7 @@ static DEVICE_ATTR_RW(uuid);
 static ssize_t namespace_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nd_pfn *nd_pfn = to_nd_pfn(dev);
+	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
 	ssize_t rc;
 
 	nvdimm_bus_lock(dev);
@@ -191,7 +210,7 @@ static ssize_t namespace_show(struct device *dev,
 static ssize_t namespace_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
-	struct nd_pfn *nd_pfn = to_nd_pfn(dev);
+	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
 	ssize_t rc;
 
 	device_lock(dev);
@@ -209,7 +228,7 @@ static DEVICE_ATTR_RW(namespace);
 static ssize_t resource_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nd_pfn *nd_pfn = to_nd_pfn(dev);
+	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
 	ssize_t rc;
 
 	device_lock(dev);
@@ -235,7 +254,7 @@ static DEVICE_ATTR_RO(resource);
 static ssize_t size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nd_pfn *nd_pfn = to_nd_pfn(dev);
+	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
 	ssize_t rc;
 
 	device_lock(dev);
@@ -270,7 +289,7 @@ static struct attribute *nd_pfn_attributes[] = {
 	NULL,
 };
 
-static struct attribute_group nd_pfn_attribute_group = {
+struct attribute_group nd_pfn_attribute_group = {
 	.attrs = nd_pfn_attributes,
 };
 
@@ -281,15 +300,31 @@ static const struct attribute_group *nd_pfn_attribute_groups[] = {
 	NULL,
 };
 
-static struct device *__nd_pfn_create(struct nd_region *nd_region,
+struct device *nd_pfn_devinit(struct nd_pfn *nd_pfn,
 		struct nd_namespace_common *ndns)
 {
-	struct nd_pfn *nd_pfn;
-	struct device *dev;
+	struct device *dev = &nd_pfn->dev;
 
-	/* we can only create pages for contiguous ranged of pmem */
-	if (!is_nd_pmem(&nd_region->dev))
+	if (!nd_pfn)
+		return NULL;
+
+	nd_pfn->mode = PFN_MODE_NONE;
+	nd_pfn->align = HPAGE_SIZE;
+	dev = &nd_pfn->dev;
+	device_initialize(&nd_pfn->dev);
+	if (ndns && !__nd_attach_ndns(&nd_pfn->dev, ndns, &nd_pfn->ndns)) {
+		dev_dbg(&ndns->dev, "%s failed, already claimed by %s\n",
+				__func__, dev_name(ndns->claim));
+		put_device(dev);
 		return NULL;
+	}
+	return dev;
+}
+
+static struct nd_pfn *nd_pfn_alloc(struct nd_region *nd_region)
+{
+	struct nd_pfn *nd_pfn;
+	struct device *dev;
 
 	nd_pfn = kzalloc(sizeof(*nd_pfn), GFP_KERNEL);
 	if (!nd_pfn)
@@ -301,29 +336,27 @@ static struct device *__nd_pfn_create(struct nd_region *nd_region,
 		return NULL;
 	}
 
-	nd_pfn->mode = PFN_MODE_NONE;
-	nd_pfn->align = HPAGE_SIZE;
 	dev = &nd_pfn->dev;
 	dev_set_name(dev, "pfn%d.%d", nd_region->id, nd_pfn->id);
-	dev->parent = &nd_region->dev;
-	dev->type = &nd_pfn_device_type;
 	dev->groups = nd_pfn_attribute_groups;
-	device_initialize(&nd_pfn->dev);
-	if (ndns && !__nd_attach_ndns(&nd_pfn->dev, ndns, &nd_pfn->ndns)) {
-		dev_dbg(&ndns->dev, "%s failed, already claimed by %s\n",
-				__func__, dev_name(ndns->claim));
-		put_device(dev);
-		return NULL;
-	}
-	return dev;
+	dev->type = &nd_pfn_device_type;
+	dev->parent = &nd_region->dev;
+
+	return nd_pfn;
 }
 
 struct device *nd_pfn_create(struct nd_region *nd_region)
 {
-	struct device *dev = __nd_pfn_create(nd_region, NULL);
+	struct nd_pfn *nd_pfn;
+	struct device *dev;
+
+	if (!is_nd_pmem(&nd_region->dev))
+		return NULL;
+
+	nd_pfn = nd_pfn_alloc(nd_region);
+	dev = nd_pfn_devinit(nd_pfn, NULL);
 
-	if (dev)
-		__nd_device_register(dev);
+	__nd_device_register(dev);
 	return dev;
 }
 
@@ -423,7 +456,8 @@ int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns)
 		return -ENODEV;
 
 	nvdimm_bus_lock(&ndns->dev);
-	pfn_dev = __nd_pfn_create(nd_region, ndns);
+	nd_pfn = nd_pfn_alloc(nd_region);
+	pfn_dev = nd_pfn_devinit(nd_pfn, ndns);
 	nvdimm_bus_unlock(&ndns->dev);
 	if (!pfn_dev)
 		return -ENOMEM;
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 4b7715e29cff..05a912359939 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -54,6 +54,7 @@ static int nd_region_probe(struct device *dev)
 
 	nd_region->btt_seed = nd_btt_create(nd_region);
 	nd_region->pfn_seed = nd_pfn_create(nd_region);
+	nd_region->dax_seed = nd_dax_create(nd_region);
 	if (err == 0)
 		return 0;
 
@@ -86,6 +87,7 @@ static int nd_region_remove(struct device *dev)
 	nd_region->ns_seed = NULL;
 	nd_region->btt_seed = NULL;
 	nd_region->pfn_seed = NULL;
+	nd_region->dax_seed = NULL;
 	dev_set_drvdata(dev, NULL);
 	nvdimm_bus_unlock(dev);
 
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 139bf71ca549..9e1b054e0e61 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -306,6 +306,23 @@ static ssize_t pfn_seed_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(pfn_seed);
 
+static ssize_t dax_seed_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+	ssize_t rc;
+
+	nvdimm_bus_lock(dev);
+	if (nd_region->dax_seed)
+		rc = sprintf(buf, "%s\n", dev_name(nd_region->dax_seed));
+	else
+		rc = sprintf(buf, "\n");
+	nvdimm_bus_unlock(dev);
+
+	return rc;
+}
+static DEVICE_ATTR_RO(dax_seed);
+
 static ssize_t read_only_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -335,6 +352,7 @@ static struct attribute *nd_region_attributes[] = {
 	&dev_attr_mappings.attr,
 	&dev_attr_btt_seed.attr,
 	&dev_attr_pfn_seed.attr,
+	&dev_attr_dax_seed.attr,
 	&dev_attr_read_only.attr,
 	&dev_attr_set_cookie.attr,
 	&dev_attr_available_size.attr,
@@ -353,6 +371,9 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 	if (!is_nd_pmem(dev) && a == &dev_attr_pfn_seed.attr)
 		return 0;
 
+	if (!is_nd_pmem(dev) && a == &dev_attr_dax_seed.attr)
+		return 0;
+
 	if (a != &dev_attr_set_cookie.attr
 			&& a != &dev_attr_available_size.attr)
 		return a->mode;
@@ -441,6 +462,13 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
 			nd_region_create_pfn_seed(nd_region);
 		nvdimm_bus_unlock(dev);
 	}
+	if (is_nd_dax(dev) && probe) {
+		nd_region = to_nd_region(dev->parent);
+		nvdimm_bus_lock(dev);
+		if (nd_region->dax_seed == dev)
+			nd_region_create_dax_seed(nd_region);
+		nvdimm_bus_unlock(dev);
+	}
 }
 
 void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev)
@@ -718,6 +746,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 	ida_init(&nd_region->ns_ida);
 	ida_init(&nd_region->btt_ida);
 	ida_init(&nd_region->pfn_ida);
+	ida_init(&nd_region->dax_ida);
 	dev = &nd_region->dev;
 	dev_set_name(dev, "region%d", nd_region->id);
 	dev->parent = &nvdimm_bus->dev;
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 7cc28ab05b87..4f29d247f709 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -206,6 +206,7 @@ static inline const char *nvdimm_cmd_name(unsigned cmd)
 #define ND_DEVICE_NAMESPACE_IO 4    /* legacy persistent memory */
 #define ND_DEVICE_NAMESPACE_PMEM 5  /* PMEM namespace (may alias with BLK) */
 #define ND_DEVICE_NAMESPACE_BLK 6   /* BLK namespace (may alias with PMEM) */
+#define ND_DEVICE_DAX_PMEM 7        /* Device DAX interface to pmem */
 
 enum nd_driver_flags {
 	ND_DRIVER_DIMM            = 1 << ND_DEVICE_DIMM,
@@ -214,6 +215,7 @@ enum nd_driver_flags {
 	ND_DRIVER_NAMESPACE_IO    = 1 << ND_DEVICE_NAMESPACE_IO,
 	ND_DRIVER_NAMESPACE_PMEM  = 1 << ND_DEVICE_NAMESPACE_PMEM,
 	ND_DRIVER_NAMESPACE_BLK   = 1 << ND_DEVICE_NAMESPACE_BLK,
+	ND_DRIVER_DAX_PMEM	  = 1 << ND_DEVICE_DAX_PMEM,
 };
 
 enum {
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index d5bc8c080b44..5ff6d3c126a9 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -50,6 +50,7 @@ libnvdimm-y += $(NVDIMM_SRC)/label.o
 libnvdimm-$(CONFIG_ND_CLAIM) += $(NVDIMM_SRC)/claim.o
 libnvdimm-$(CONFIG_BTT) += $(NVDIMM_SRC)/btt_devs.o
 libnvdimm-$(CONFIG_NVDIMM_PFN) += $(NVDIMM_SRC)/pfn_devs.o
+libnvdimm-$(CONFIG_NVDIMM_DAX) += $(NVDIMM_SRC)/dax_devs.o
 libnvdimm-y += config_check.o
 
 obj-m += test/

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
