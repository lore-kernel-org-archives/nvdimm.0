Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 12/20] libnd,
 nd_acpi: add interleave-set state-tracking infrastructure
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Apr 2015 14:25:19 -0400
Message-ID: <20150428182519.35812.16187.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On platforms that have firmware support for reading/writing per-dimm
label space, a portion of the dimm may be accessible via an interleave
set PMEM mapping in addition to the dimm's BLK (block-data-window
aperture(s)) interface.  A label, stored in a "configuration data
region" on the dimm, disambiguates which dimm addresses are accessed
through which exclusive interface.

Add infrastructure that allows the kernel to block modifications to a
label in the set while any member dimm is active.  Note that this is
meant only for enforcing "no modifications of active labels" via the
coarse ioctl command.  Adding/deleting namespaces from an active
interleave set will only be possible via sysfs.

Another aspect of tracking interleave sets is tracking their integrity
when DIMMs in a set are physically re-ordered.  For this purpose we
generate an "interleave-set cookie" that can be recorded in a label and
validated against the current configuration.  It is the bus provider
implementation's responsibility to calculate the interleave set cookie
and attach it to a given region.

Cc: Neil Brown <neilb@suse.de>
Cc: <linux-acpi@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/acpi.c        |   90 ++++++++++++++++++++++++++++++++++++++++
 drivers/block/nd/bus.c         |   41 ++++++++++++++++++
 drivers/block/nd/core.c        |   47 +++++++++++++++++++++
 drivers/block/nd/dimm_devs.c   |   19 ++++++++
 drivers/block/nd/libnd.h       |    6 +++
 drivers/block/nd/nd-private.h  |   11 ++++-
 drivers/block/nd/nd.h          |    4 ++
 drivers/block/nd/region_devs.c |   85 ++++++++++++++++++++++++++++++++++++++
 8 files changed, 299 insertions(+), 4 deletions(-)

diff --git a/drivers/block/nd/acpi.c b/drivers/block/nd/acpi.c
index c3dda74f73d7..d34cefe38e2f 100644
--- a/drivers/block/nd/acpi.c
+++ b/drivers/block/nd/acpi.c
@@ -15,6 +15,7 @@
 #include <linux/ndctl.h>
 #include <linux/list.h>
 #include <linux/acpi.h>
+#include <linux/sort.h>
 #include "acpi_nfit.h"
 #include "libnd.h"
 
@@ -779,6 +780,90 @@ static const struct attribute_group *nd_acpi_region_attribute_groups[] = {
 	NULL,
 };
 
+/* enough info to uniquely specify an interleave set */
+struct nfit_set_info {
+	struct nfit_set_info_map {
+		u64 region_spa_offset;
+		u32 serial_number;
+		u32 pad;
+	} mapping[0];
+};
+
+static size_t sizeof_nfit_set_info(int num_mappings)
+{
+	return sizeof(struct nfit_set_info)
+		+ num_mappings * sizeof(struct nfit_set_info_map);
+}
+
+static int cmp_map(const void *m0, const void *m1)
+{
+	const struct nfit_set_info_map *map0 = m0;
+	const struct nfit_set_info_map *map1 = m1;
+
+	return memcmp(&map0->region_spa_offset, &map1->region_spa_offset,
+			sizeof(u64));
+}
+
+/* Retrieve the nth entry referencing this spa */
+static struct acpi_nfit_memdev *memdev_from_spa(
+		struct acpi_nfit_desc *acpi_desc, u16 spa_index, int n)
+{
+        struct nfit_memdev *nfit_memdev;
+
+        list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list)
+                if (nfit_memdev->memdev->spa_index == spa_index)
+                        if (n-- == 0)
+                                return nfit_memdev->memdev;
+        return NULL;
+}
+
+static int nd_acpi_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
+		struct nd_region_desc *ndr_desc, struct acpi_nfit_spa *spa)
+{
+	u16 num_mappings = ndr_desc->num_mappings;
+	int i, spa_type = nfit_spa_type(spa);
+	struct device *dev = acpi_desc->dev;
+	struct nd_interleave_set *nd_set;
+	struct nfit_set_info *info;
+
+	if (spa_type == NFIT_SPA_PM || spa_type == NFIT_SPA_VOLATILE)
+		/* pass */;
+	else
+		return 0;
+
+	nd_set = devm_kzalloc(dev, sizeof(*nd_set), GFP_KERNEL);
+	if (!nd_set)
+		return -ENOMEM;
+
+	info = devm_kzalloc(dev, sizeof_nfit_set_info(num_mappings), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+	for (i = 0; i < num_mappings; i++) {
+		struct nd_mapping *nd_mapping = &ndr_desc->nd_mapping[i];
+		struct nfit_set_info_map *map = &info->mapping[i];
+		struct nd_dimm *nd_dimm = nd_mapping->nd_dimm;
+		struct nfit_mem *nfit_mem = nd_dimm_provider_data(nd_dimm);
+		struct acpi_nfit_memdev *memdev = memdev_from_spa(acpi_desc,
+				spa->spa_index, i);
+
+		if (!memdev || !nfit_mem->dcr) {
+			dev_err(dev, "%s: failed to find DCR\n", __func__);
+			return -ENODEV;
+		}
+
+		map->region_spa_offset = memdev->region_spa_offset;
+		map->serial_number = nfit_mem->dcr->serial_number;
+	}
+
+	sort(&info->mapping[0], num_mappings, sizeof(struct nfit_set_info_map),
+			cmp_map, NULL);
+	nd_set->cookie = nd_fletcher64(info, sizeof_nfit_set_info(num_mappings));
+	ndr_desc->nd_set = nd_set;
+	devm_kfree(dev, info);
+
+	return 0;
+}
+
 static int nd_acpi_register_region(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_spa *nfit_spa)
 {
@@ -786,7 +871,7 @@ static int nd_acpi_register_region(struct acpi_nfit_desc *acpi_desc,
 	struct acpi_nfit_spa *spa = nfit_spa->spa;
 	struct nfit_memdev *nfit_memdev;
 	struct nd_region_desc ndr_desc;
-	int spa_type, count = 0;
+	int spa_type, count = 0, rc;
 	struct resource res;
 	u16 spa_index;
 
@@ -852,6 +937,9 @@ static int nd_acpi_register_region(struct acpi_nfit_desc *acpi_desc,
 
 	ndr_desc.nd_mapping = nd_mappings;
 	ndr_desc.num_mappings = count;
+	rc = nd_acpi_init_interleave_set(acpi_desc, &ndr_desc, spa);
+	if (rc)
+		return rc;
 	if (spa_type == NFIT_SPA_PM) {
 		if (!nd_pmem_region_create(acpi_desc->nd_bus, &ndr_desc))
 			return -ENOMEM;
diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
index 46568d182559..8afb8d4a7e81 100644
--- a/drivers/block/nd/bus.c
+++ b/drivers/block/nd/bus.c
@@ -78,7 +78,10 @@ static int nd_bus_probe(struct device *dev)
 	if (!try_module_get(provider))
 		return -ENXIO;
 
+	nd_region_probe_start(nd_bus, dev);
 	rc = nd_drv->probe(dev);
+	nd_region_probe_end(nd_bus, dev, rc);
+
 	dev_dbg(&nd_bus->dev, "%s.probe(%s) = %d\n", dev->driver->name,
 			dev_name(dev), rc);
 	if (rc != 0)
@@ -94,6 +97,8 @@ static int nd_bus_remove(struct device *dev)
 	int rc;
 
 	rc = nd_drv->remove(dev);
+	nd_region_notify_remove(nd_bus, dev, rc);
+
 	dev_dbg(&nd_bus->dev, "%s.remove(%s) = %d\n", dev->driver->name,
 			dev_name(dev), rc);
 	module_put(provider);
@@ -359,6 +364,33 @@ u32 nd_cmd_out_size(struct nd_dimm *nd_dimm, int cmd,
 }
 EXPORT_SYMBOL_GPL(nd_cmd_out_size);
 
+static void wait_nd_bus_probe_idle(struct nd_bus *nd_bus)
+{
+	do {
+		if (nd_bus->probe_active == 0)
+			break;
+		nd_bus_unlock(&nd_bus->dev);
+		wait_event(nd_bus->probe_wait, nd_bus->probe_active == 0);
+		nd_bus_lock(&nd_bus->dev);
+	} while (true);
+}
+
+/* set_config requires an idle interleave set */
+static int nd_cmd_clear_to_send(struct nd_dimm *nd_dimm, unsigned int cmd)
+{
+	struct nd_bus *nd_bus;
+
+	if (!nd_dimm || cmd != ND_CMD_SET_CONFIG_DATA)
+		return 0;
+
+	nd_bus = walk_to_nd_bus(&nd_dimm->dev);
+	wait_nd_bus_probe_idle(nd_bus);
+
+	if (atomic_read(&nd_dimm->busy))
+		return -EBUSY;
+	return 0;
+}
+
 static int __nd_ioctl(struct nd_bus *nd_bus, struct nd_dimm *nd_dimm,
 		int read_only, unsigned int ioctl_cmd, unsigned long arg)
 {
@@ -469,11 +501,18 @@ static int __nd_ioctl(struct nd_bus *nd_bus, struct nd_dimm *nd_dimm,
 		goto out;
 	}
 
+	nd_bus_lock(&nd_bus->dev);
+	rc = nd_cmd_clear_to_send(nd_dimm, cmd);
+	if (rc)
+		goto out_unlock;
+
 	rc = nd_desc->ndctl(nd_desc, nd_dimm, cmd, buf, buf_len);
 	if (rc < 0)
-		goto out;
+		goto out_unlock;
 	if (copy_to_user(p, buf, buf_len))
 		rc = -EFAULT;
+ out_unlock:
+	nd_bus_unlock(&nd_bus->dev);
  out:
 	vfree(buf);
 	return rc;
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
index 646e424ae36c..603970d0ef3a 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -24,6 +24,51 @@ LIST_HEAD(nd_bus_list);
 DEFINE_MUTEX(nd_bus_list_mutex);
 static DEFINE_IDA(nd_ida);
 
+void nd_bus_lock(struct device *dev)
+{
+	struct nd_bus *nd_bus = walk_to_nd_bus(dev);
+
+	if (!nd_bus)
+		return;
+	mutex_lock(&nd_bus->reconfig_mutex);
+}
+EXPORT_SYMBOL(nd_bus_lock);
+
+void nd_bus_unlock(struct device *dev)
+{
+	struct nd_bus *nd_bus = walk_to_nd_bus(dev);
+
+	if (!nd_bus)
+		return;
+	mutex_unlock(&nd_bus->reconfig_mutex);
+}
+EXPORT_SYMBOL(nd_bus_unlock);
+
+bool is_nd_bus_locked(struct device *dev)
+{
+	struct nd_bus *nd_bus = walk_to_nd_bus(dev);
+
+	if (!nd_bus)
+		return false;
+	return mutex_is_locked(&nd_bus->reconfig_mutex);
+}
+EXPORT_SYMBOL(is_nd_bus_locked);
+
+u64 nd_fletcher64(void __iomem *addr, size_t len)
+{
+	u32 lo32 = 0;
+	u64 hi32 = 0;
+	int i;
+
+	for (i = 0; i < len; i += 4) {
+		lo32 = readl(addr + i);
+		hi32 += lo32;
+	}
+
+	return hi32 << 32 | lo32;
+}
+EXPORT_SYMBOL_GPL(nd_fletcher64);
+
 static void nd_bus_release(struct device *dev)
 {
 	struct nd_bus *nd_bus = container_of(dev, struct nd_bus, dev);
@@ -142,7 +187,9 @@ struct nd_bus *__nd_bus_register(struct device *parent,
 	if (!nd_bus)
 		return NULL;
 	INIT_LIST_HEAD(&nd_bus->list);
+	init_waitqueue_head(&nd_bus->probe_wait);
 	nd_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
+	mutex_init(&nd_bus->reconfig_mutex);
 	if (nd_bus->id < 0) {
 		kfree(nd_bus);
 		return NULL;
diff --git a/drivers/block/nd/dimm_devs.c b/drivers/block/nd/dimm_devs.c
index 33b6d5336096..8981adc59ba4 100644
--- a/drivers/block/nd/dimm_devs.c
+++ b/drivers/block/nd/dimm_devs.c
@@ -185,7 +185,24 @@ static ssize_t commands_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(commands);
 
+static ssize_t state_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct nd_dimm *nd_dimm = to_nd_dimm(dev);
+
+	/*
+	 * The state may be in the process of changing, userspace should
+	 * quiesce probing if it wants a static answer
+	 */
+	nd_bus_lock(dev);
+	nd_bus_unlock(dev);
+	return sprintf(buf, "%s\n", atomic_read(&nd_dimm->busy)
+			? "active" : "idle");
+}
+static DEVICE_ATTR_RO(state);
+
 static struct attribute *nd_dimm_attributes[] = {
+	&dev_attr_state.attr,
 	&dev_attr_commands.attr,
 	NULL,
 };
@@ -213,7 +230,7 @@ struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus, void *provider_data,
 	nd_dimm->provider_data = provider_data;
 	nd_dimm->flags = flags;
 	nd_dimm->dsm_mask = dsm_mask;
-
+	atomic_set(&nd_dimm->busy, 0);
 	dev = &nd_dimm->dev;
 	dev_set_name(dev, "nmem%d", nd_dimm->id);
 	dev->parent = &nd_bus->dev;
diff --git a/drivers/block/nd/libnd.h b/drivers/block/nd/libnd.h
index 8c6f07696f30..deb29eff5b61 100644
--- a/drivers/block/nd/libnd.h
+++ b/drivers/block/nd/libnd.h
@@ -60,11 +60,16 @@ struct nd_cmd_desc {
 	int out_sizes[ND_CMD_MAX_ELEM];
 };
 
+struct nd_interleave_set {
+	u64 cookie;
+};
+
 struct nd_region_desc {
 	struct resource *res;
 	struct nd_mapping *nd_mapping;
 	u16 num_mappings;
 	const struct attribute_group **attr_groups;
+	struct nd_interleave_set *nd_set;
 	void *provider_data;
 };
 
@@ -98,4 +103,5 @@ struct nd_region *nd_blk_region_create(struct nd_bus *nd_bus,
 		struct nd_region_desc *ndr_desc);
 struct nd_region *nd_volatile_region_create(struct nd_bus *nd_bus,
 		struct nd_region_desc *ndr_desc);
+u64 nd_fletcher64(void __iomem *addr, size_t len);
 #endif /* __LIBND_H__ */
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index 131fc66ce7ab..5d8249be3415 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -13,6 +13,8 @@
 #ifndef __ND_PRIVATE_H__
 #define __ND_PRIVATE_H__
 #include <linux/device.h>
+#include <linux/sizes.h>
+#include <linux/mutex.h>
 #include "libnd.h"
 
 extern struct list_head nd_bus_list;
@@ -21,10 +23,12 @@ extern int nd_dimm_major;
 
 struct nd_bus {
 	struct nd_bus_descriptor *nd_desc;
+	wait_queue_head_t probe_wait;
 	struct module *module;
 	struct list_head list;
 	struct device dev;
-	int id;
+	int id, probe_active;
+	struct mutex reconfig_mutex;
 };
 
 struct nd_dimm {
@@ -32,6 +36,7 @@ struct nd_dimm {
 	void *provider_data;
 	unsigned long *dsm_mask;
 	struct device dev;
+	atomic_t busy;
 	int id;
 };
 
@@ -45,10 +50,14 @@ int __init nd_dimm_init(void);
 int __init nd_region_init(void);
 void nd_dimm_exit(void);
 int nd_region_exit(void);
+void nd_region_probe_start(struct nd_bus *nd_bus, struct device *dev);
+void nd_region_probe_end(struct nd_bus *nd_bus, struct device *dev, int rc);
+void nd_region_notify_remove(struct nd_bus *nd_bus, struct device *dev, int rc);
 int nd_bus_create_ndctl(struct nd_bus *nd_bus);
 void nd_bus_destroy_ndctl(struct nd_bus *nd_bus);
 void nd_synchronize(void);
 int nd_bus_register_dimms(struct nd_bus *nd_bus);
 int nd_bus_register_regions(struct nd_bus *nd_bus);
+int nd_bus_init_interleave_sets(struct nd_bus *nd_bus);
 int nd_match_dimm(struct device *dev, void *data);
 #endif /* __ND_PRIVATE_H__ */
diff --git a/drivers/block/nd/nd.h b/drivers/block/nd/nd.h
index 23469513f4c0..c69707dbd272 100644
--- a/drivers/block/nd/nd.h
+++ b/drivers/block/nd/nd.h
@@ -35,6 +35,7 @@ struct nd_region {
 	u64 ndr_start;
 	int id;
 	void *provider_data;
+	struct nd_interleave_set *nd_set;
 	struct nd_mapping mapping[0];
 };
 
@@ -50,4 +51,7 @@ int nd_dimm_init_config_data(struct nd_dimm_drvdata *ndd);
 struct nd_region *to_nd_region(struct device *dev);
 int nd_region_to_namespace_type(struct nd_region *nd_region);
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
+void nd_bus_lock(struct device *dev);
+void nd_bus_unlock(struct device *dev);
+bool is_nd_bus_locked(struct device *dev);
 #endif /* __ND_H__ */
diff --git a/drivers/block/nd/region_devs.c b/drivers/block/nd/region_devs.c
index 49ebce0c97be..c1cea42d0473 100644
--- a/drivers/block/nd/region_devs.c
+++ b/drivers/block/nd/region_devs.c
@@ -10,7 +10,10 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
+#include <linux/scatterlist.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/sort.h>
 #include <linux/io.h>
 #include "nd-private.h"
 #include "nd.h"
@@ -133,6 +136,21 @@ static ssize_t nstype_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(nstype);
 
+static ssize_t set_cookie_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
+
+	if (is_nd_pmem(dev) && nd_set)
+		/* pass, should be precluded by nd_region_visible */;
+	else
+		return -ENXIO;
+
+	return sprintf(buf, "%#llx\n", nd_set->cookie);
+}
+static DEVICE_ATTR_RO(set_cookie);
+
 static ssize_t init_namespaces_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -149,15 +167,81 @@ static struct attribute *nd_region_attributes[] = {
 	&dev_attr_size.attr,
 	&dev_attr_nstype.attr,
 	&dev_attr_mappings.attr,
+	&dev_attr_set_cookie.attr,
 	&dev_attr_init_namespaces.attr,
 	NULL,
 };
 
+static umode_t nd_region_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, typeof(*dev), kobj);
+	struct nd_region *nd_region = to_nd_region(dev);
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
+
+	if (a != &dev_attr_set_cookie.attr)
+		return a->mode;
+
+	if (is_nd_pmem(dev) && nd_set)
+			return a->mode;
+
+	return 0;
+}
+
 struct attribute_group nd_region_attribute_group = {
 	.attrs = nd_region_attributes,
+	.is_visible = nd_region_visible,
 };
 EXPORT_SYMBOL_GPL(nd_region_attribute_group);
 
+/*
+ * Upon successful probe/remove, take/release a reference on the
+ * associated interleave set (if present)
+ */
+static void nd_region_notify_driver_action(struct nd_bus *nd_bus,
+		struct device *dev, int rc, bool probe)
+{
+	if (rc)
+		return;
+
+	if (is_nd_pmem(dev) || is_nd_blk(dev)) {
+		struct nd_region *nd_region = to_nd_region(dev);
+		int i;
+
+		for (i = 0; i < nd_region->ndr_mappings; i++) {
+			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+			struct nd_dimm *nd_dimm = nd_mapping->nd_dimm;
+
+			if (probe)
+				atomic_inc(&nd_dimm->busy);
+			else
+				atomic_dec(&nd_dimm->busy);
+		}
+	}
+}
+
+void nd_region_probe_start(struct nd_bus *nd_bus, struct device *dev)
+{
+	nd_bus_lock(&nd_bus->dev);
+	nd_bus->probe_active++;
+	nd_bus_unlock(&nd_bus->dev);
+}
+
+void nd_region_probe_end(struct nd_bus *nd_bus, struct device *dev, int rc)
+{
+	nd_bus_lock(&nd_bus->dev);
+	nd_region_notify_driver_action(nd_bus, dev, rc, true);
+	if (--nd_bus->probe_active == 0)
+		wake_up(&nd_bus->probe_wait);
+	nd_bus_unlock(&nd_bus->dev);
+}
+
+void nd_region_notify_remove(struct nd_bus *nd_bus, struct device *dev, int rc)
+{
+	nd_bus_lock(dev);
+	nd_region_notify_driver_action(nd_bus, dev, rc, false);
+	nd_bus_unlock(dev);
+}
+
 static ssize_t mappingN(struct device *dev, char *buf, int n)
 {
 	struct nd_region *nd_region = to_nd_region(dev);
@@ -317,6 +401,7 @@ static noinline struct nd_region *nd_region_create(struct nd_bus *nd_bus,
 	}
 	nd_region->ndr_mappings = ndr_desc->num_mappings;
 	nd_region->provider_data = ndr_desc->provider_data;
+	nd_region->nd_set = ndr_desc->nd_set;
 	dev = &nd_region->dev;
 	dev_set_name(dev, "region%d", nd_region->id);
 	dev->parent = &nd_bus->dev;

