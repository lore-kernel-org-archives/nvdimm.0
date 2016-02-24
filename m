Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 3/8] libnvdimm: async notification support
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Feb 2016 18:17:14 -0800
Message-ID: <20160224021714.22776.50929.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160224021655.22776.87952.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160224021655.22776.87952.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for asynchronous address range scrub support add an ability for
the pmem driver to dynamically consume address range scrub results.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c    |   26 ++++++++++++++++++++++++++
 drivers/nvdimm/nd.h     |    2 ++
 drivers/nvdimm/pmem.c   |   15 +++++++++++++++
 drivers/nvdimm/region.c |   12 ++++++++++++
 include/linux/nd.h      |    7 +++++++
 5 files changed, 62 insertions(+)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index c3ba888e3e3a..2508251439e7 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -133,6 +133,32 @@ static int nvdimm_bus_remove(struct device *dev)
 	return rc;
 }
 
+void nd_device_notify(struct device *dev, enum nvdimm_event event)
+{
+	device_lock(dev);
+	if (dev->driver) {
+		struct nd_device_driver *nd_drv;
+
+		nd_drv = to_nd_device_driver(dev->driver);
+		if (nd_drv->notify)
+			nd_drv->notify(dev, event);
+	}
+	device_unlock(dev);
+}
+EXPORT_SYMBOL(nd_device_notify);
+
+void nvdimm_region_notify(struct nd_region *nd_region, enum nvdimm_event event)
+{
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
+
+	if (!nvdimm_bus)
+		return;
+
+	/* caller is responsible for holding a reference on the device */
+	nd_device_notify(&nd_region->dev, event);
+}
+EXPORT_SYMBOL_GPL(nvdimm_region_notify);
+
 static struct bus_type nvdimm_bus_type = {
 	.name = "nd",
 	.uevent = nvdimm_bus_uevent,
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index ba1633b9da31..78b82f6dd191 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -18,6 +18,7 @@
 #include <linux/mutex.h>
 #include <linux/ndctl.h>
 #include <linux/types.h>
+#include <linux/nd.h>
 #include "label.h"
 
 enum {
@@ -168,6 +169,7 @@ int nd_integrity_init(struct gendisk *disk, unsigned long meta_size);
 void wait_nvdimm_bus_probe_idle(struct device *dev);
 void nd_device_register(struct device *dev);
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode);
+void nd_device_notify(struct device *dev, enum nvdimm_event event);
 int nd_uuid_store(struct device *dev, u8 **uuid_out, const char *buf,
 		size_t len);
 ssize_t nd_sector_size_show(unsigned long current_lbasize,
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 8d0b54670184..efc2a5e671c6 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -488,12 +488,27 @@ static int nd_pmem_remove(struct device *dev)
 	return 0;
 }
 
+static void nd_pmem_notify(struct device *dev, enum nvdimm_event event)
+{
+	struct pmem_device *pmem = dev_get_drvdata(dev);
+	struct nd_namespace_common *ndns = pmem->ndns;
+
+	if (event != NVDIMM_REVALIDATE_POISON)
+		return;
+
+	if (is_nd_btt(dev))
+		nvdimm_namespace_add_poison(ndns, &pmem->bb, 0);
+	else
+		nvdimm_namespace_add_poison(ndns, &pmem->bb, pmem->data_offset);
+}
+
 MODULE_ALIAS("pmem");
 MODULE_ALIAS_ND_DEVICE(ND_DEVICE_NAMESPACE_IO);
 MODULE_ALIAS_ND_DEVICE(ND_DEVICE_NAMESPACE_PMEM);
 static struct nd_device_driver nd_pmem_driver = {
 	.probe = nd_pmem_probe,
 	.remove = nd_pmem_remove,
+	.notify = nd_pmem_notify,
 	.drv = {
 		.name = "nd_pmem",
 	},
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 7da63eac78ee..4b7715e29cff 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -93,9 +93,21 @@ static int nd_region_remove(struct device *dev)
 	return 0;
 }
 
+static int child_notify(struct device *dev, void *data)
+{
+	nd_device_notify(dev, *(enum nvdimm_event *) data);
+	return 0;
+}
+
+static void nd_region_notify(struct device *dev, enum nvdimm_event event)
+{
+	device_for_each_child(dev, &event, child_notify);
+}
+
 static struct nd_device_driver nd_region_driver = {
 	.probe = nd_region_probe,
 	.remove = nd_region_remove,
+	.notify = nd_region_notify,
 	.drv = {
 		.name = "nd_region",
 	},
diff --git a/include/linux/nd.h b/include/linux/nd.h
index 507e47c86737..5489ab756d1a 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -16,11 +16,16 @@
 #include <linux/ndctl.h>
 #include <linux/device.h>
 
+enum nvdimm_event {
+	NVDIMM_REVALIDATE_POISON,
+};
+
 struct nd_device_driver {
 	struct device_driver drv;
 	unsigned long type;
 	int (*probe)(struct device *dev);
 	int (*remove)(struct device *dev);
+	void (*notify)(struct device *dev, enum nvdimm_event event);
 };
 
 static inline struct nd_device_driver *to_nd_device_driver(
@@ -144,6 +149,8 @@ static inline int nvdimm_write_bytes(struct nd_namespace_common *ndns,
 	MODULE_ALIAS("nd:t" __stringify(type) "*")
 #define ND_DEVICE_MODALIAS_FMT "nd:t%d"
 
+struct nd_region;
+void nvdimm_region_notify(struct nd_region *nd_region, enum nvdimm_event event);
 int __must_check __nd_driver_register(struct nd_device_driver *nd_drv,
 		struct module *module, const char *mod_name);
 #define nd_driver_register(driver) \
