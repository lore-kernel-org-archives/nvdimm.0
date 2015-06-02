Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v5 11/21] libnvdimm,
 nfit: add interleave-set state-tracking infrastructure
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 01 Jun 2015 20:15:09 -0400
Message-ID: <20150602001508.4506.38702.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
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
interleave set is always possible via sysfs.

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
 drivers/acpi/nfit.c          |   91 ++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/bus.c         |   41 ++++++++++++++++++-
 drivers/nvdimm/core.c        |   17 ++++++++
 drivers/nvdimm/dimm_devs.c   |   19 ++++++++-
 drivers/nvdimm/nd-private.h  |   11 +++++
 drivers/nvdimm/nd.h          |    1 
 drivers/nvdimm/region_devs.c |   85 +++++++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h    |    6 +++
 8 files changed, 267 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index b8e0a762692f..2eb26069c1da 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -16,6 +16,7 @@
 #include <linux/ndctl.h>
 #include <linux/list.h>
 #include <linux/acpi.h>
+#include <linux/sort.h>
 #include "nfit.h"
 
 static bool force_enable_dimms;
@@ -743,6 +744,91 @@ static const struct attribute_group *acpi_nfit_region_attribute_groups[] = {
 	NULL,
 };
 
+/* enough info to uniquely specify an interleave set */
+struct nfit_set_info {
+	struct nfit_set_info_map {
+		u64 region_offset;
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
+	return memcmp(&map0->region_offset, &map1->region_offset,
+			sizeof(u64));
+}
+
+/* Retrieve the nth entry referencing this spa */
+static struct acpi_nfit_memory_map *memdev_from_spa(
+		struct acpi_nfit_desc *acpi_desc, u16 range_index, int n)
+{
+	struct nfit_memdev *nfit_memdev;
+
+	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list)
+		if (nfit_memdev->memdev->range_index == range_index)
+			if (n-- == 0)
+				return nfit_memdev->memdev;
+	return NULL;
+}
+
+static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
+		struct nd_region_desc *ndr_desc,
+		struct acpi_nfit_system_address *spa)
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
+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+		struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+		struct acpi_nfit_memory_map *memdev = memdev_from_spa(acpi_desc,
+				spa->range_index, i);
+
+		if (!memdev || !nfit_mem->dcr) {
+			dev_err(dev, "%s: failed to find DCR\n", __func__);
+			return -ENODEV;
+		}
+
+		map->region_offset = memdev->region_offset;
+		map->serial_number = nfit_mem->dcr->serial_number;
+	}
+
+	sort(&info->mapping[0], num_mappings, sizeof(struct nfit_set_info_map),
+			cmp_map, NULL);
+	nd_set->cookie = nd_fletcher64(info, sizeof_nfit_set_info(num_mappings), 0);
+	ndr_desc->nd_set = nd_set;
+	devm_kfree(dev, info);
+
+	return 0;
+}
+
 static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_spa *nfit_spa)
 {
@@ -750,7 +836,7 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 	struct acpi_nfit_system_address *spa = nfit_spa->spa;
 	struct nfit_memdev *nfit_memdev;
 	struct nd_region_desc ndr_desc;
-	int spa_type, count = 0;
+	int spa_type, count = 0, rc;
 	struct resource res;
 	u16 range_index;
 
@@ -816,6 +902,9 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 
 	ndr_desc.nd_mapping = nd_mappings;
 	ndr_desc.num_mappings = count;
+	rc = acpi_nfit_init_interleave_set(acpi_desc, &ndr_desc, spa);
+	if (rc)
+		return rc;
 	if (spa_type == NFIT_SPA_PM) {
 		if (!nvdimm_pmem_region_create(acpi_desc->nvdimm_bus, &ndr_desc))
 			return -ENOMEM;
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index eeffe9498275..54bf593043c7 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -78,7 +78,10 @@ static int nvdimm_bus_probe(struct device *dev)
 	if (!try_module_get(provider))
 		return -ENXIO;
 
+	nd_region_probe_start(nvdimm_bus, dev);
 	rc = nd_drv->probe(dev);
+	nd_region_probe_end(nvdimm_bus, dev, rc);
+
 	dev_dbg(&nvdimm_bus->dev, "%s.probe(%s) = %d\n", dev->driver->name,
 			dev_name(dev), rc);
 	if (rc != 0)
@@ -94,6 +97,8 @@ static int nvdimm_bus_remove(struct device *dev)
 	int rc;
 
 	rc = nd_drv->remove(dev);
+	nd_region_notify_remove(nvdimm_bus, dev, rc);
+
 	dev_dbg(&nvdimm_bus->dev, "%s.remove(%s) = %d\n", dev->driver->name,
 			dev_name(dev), rc);
 	module_put(provider);
@@ -359,6 +364,33 @@ u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
 }
 EXPORT_SYMBOL_GPL(nd_cmd_out_size);
 
+static void wait_nvdimm_bus_probe_idle(struct nvdimm_bus *nvdimm_bus)
+{
+	do {
+		if (nvdimm_bus->probe_active == 0)
+			break;
+		nvdimm_bus_unlock(&nvdimm_bus->dev);
+		wait_event(nvdimm_bus->probe_wait, nvdimm_bus->probe_active == 0);
+		nvdimm_bus_lock(&nvdimm_bus->dev);
+	} while (true);
+}
+
+/* set_config requires an idle interleave set */
+static int nd_cmd_clear_to_send(struct nvdimm *nvdimm, unsigned int cmd)
+{
+	struct nvdimm_bus *nvdimm_bus;
+
+	if (!nvdimm || cmd != ND_CMD_SET_CONFIG_DATA)
+		return 0;
+
+	nvdimm_bus = walk_to_nvdimm_bus(&nvdimm->dev);
+	wait_nvdimm_bus_probe_idle(nvdimm_bus);
+
+	if (atomic_read(&nvdimm->busy))
+		return -EBUSY;
+	return 0;
+}
+
 static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		int read_only, unsigned int ioctl_cmd, unsigned long arg)
 {
@@ -469,11 +501,18 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		goto out;
 	}
 
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	rc = nd_cmd_clear_to_send(nvdimm, cmd);
+	if (rc)
+		goto out_unlock;
+
 	rc = nd_desc->ndctl(nd_desc, nvdimm, cmd, buf, buf_len);
 	if (rc < 0)
-		goto out;
+		goto out_unlock;
 	if (copy_to_user(p, buf, buf_len))
 		rc = -EFAULT;
+ out_unlock:
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
  out:
 	vfree(buf);
 	return rc;
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index df1a36565fb3..c128b949a500 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -54,6 +54,22 @@ bool is_nvdimm_bus_locked(struct device *dev)
 }
 EXPORT_SYMBOL(is_nvdimm_bus_locked);
 
+u64 nd_fletcher64(void *addr, size_t len, bool le)
+{
+	u32 *buf = addr;
+	u32 lo32 = 0;
+	u64 hi32 = 0;
+	int i;
+
+	for (i = 0; i < len / sizeof(u32); i++) {
+		lo32 += le ? le32_to_cpu(buf[i]) : buf[i];
+		hi32 += lo32;
+	}
+
+	return hi32 << 32 | lo32;
+}
+EXPORT_SYMBOL_GPL(nd_fletcher64);
+
 static void nvdimm_bus_release(struct device *dev)
 {
 	struct nvdimm_bus *nvdimm_bus = container_of(dev, struct nvdimm_bus, dev);
@@ -172,6 +188,7 @@ struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
 	if (!nvdimm_bus)
 		return NULL;
 	INIT_LIST_HEAD(&nvdimm_bus->list);
+	init_waitqueue_head(&nvdimm_bus->probe_wait);
 	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
 	mutex_init(&nvdimm_bus->reconfig_mutex);
 	if (nvdimm_bus->id < 0) {
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index cb531a4c480d..55405d70f56a 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -185,7 +185,24 @@ static ssize_t commands_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(commands);
 
+static ssize_t state_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	/*
+	 * The state may be in the process of changing, userspace should
+	 * quiesce probing if it wants a static answer
+	 */
+	nvdimm_bus_lock(dev);
+	nvdimm_bus_unlock(dev);
+	return sprintf(buf, "%s\n", atomic_read(&nvdimm->busy)
+			? "active" : "idle");
+}
+static DEVICE_ATTR_RO(state);
+
 static struct attribute *nvdimm_attributes[] = {
+	&dev_attr_state.attr,
 	&dev_attr_commands.attr,
 	NULL,
 };
@@ -213,7 +230,7 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 	nvdimm->provider_data = provider_data;
 	nvdimm->flags = flags;
 	nvdimm->dsm_mask = dsm_mask;
-
+	atomic_set(&nvdimm->busy, 0);
 	dev = &nvdimm->dev;
 	dev_set_name(dev, "nmem%d", nvdimm->id);
 	dev->parent = &nvdimm_bus->dev;
diff --git a/drivers/nvdimm/nd-private.h b/drivers/nvdimm/nd-private.h
index 85536c3556a1..5d5a406e60f8 100644
--- a/drivers/nvdimm/nd-private.h
+++ b/drivers/nvdimm/nd-private.h
@@ -14,6 +14,9 @@
 #define __ND_PRIVATE_H__
 #include <linux/libnvdimm.h>
 #include <linux/device.h>
+#include <linux/libnvdimm.h>
+#include <linux/sizes.h>
+#include <linux/mutex.h>
 
 extern struct list_head nvdimm_bus_list;
 extern struct mutex nvdimm_bus_list_mutex;
@@ -21,10 +24,11 @@ extern int nvdimm_major;
 
 struct nvdimm_bus {
 	struct nvdimm_bus_descriptor *nd_desc;
+	wait_queue_head_t probe_wait;
 	struct module *module;
 	struct list_head list;
 	struct device dev;
-	int id;
+	int id, probe_active;
 	struct mutex reconfig_mutex;
 };
 
@@ -33,6 +37,7 @@ struct nvdimm {
 	void *provider_data;
 	unsigned long *dsm_mask;
 	struct device dev;
+	atomic_t busy;
 	int id;
 };
 
@@ -42,10 +47,14 @@ bool is_nd_pmem(struct device *dev);
 struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev);
 int __init nvdimm_bus_init(void);
 void nvdimm_bus_exit(void);
+void nd_region_probe_start(struct nvdimm_bus *nvdimm_bus, struct device *dev);
+void nd_region_probe_end(struct nvdimm_bus *nvdimm_bus, struct device *dev, int rc);
+void nd_region_notify_remove(struct nvdimm_bus *nvdimm_bus, struct device *dev, int rc);
 int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nd_synchronize(void);
 int nvdimm_bus_register_dimms(struct nvdimm_bus *nvdimm_bus);
 int nvdimm_bus_register_regions(struct nvdimm_bus *nvdimm_bus);
+int nvdimm_bus_init_interleave_sets(struct nvdimm_bus *nvdimm_bus);
 int nd_match_dimm(struct device *dev, void *data);
 #endif /* __ND_PRIVATE_H__ */
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 9d0c03e0d71e..6bc0a233b6bd 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -35,6 +35,7 @@ struct nd_region {
 	u64 ndr_start;
 	int id;
 	void *provider_data;
+	struct nd_interleave_set *nd_set;
 	struct nd_mapping mapping[0];
 };
 
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 497177d91257..c99546ee10ab 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
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
@@ -154,15 +172,81 @@ static struct attribute *nd_region_attributes[] = {
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
+static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
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
+			struct nvdimm *nvdimm = nd_mapping->nvdimm;
+
+			if (probe)
+				atomic_inc(&nvdimm->busy);
+			else
+				atomic_dec(&nvdimm->busy);
+		}
+	}
+}
+
+void nd_region_probe_start(struct nvdimm_bus *nvdimm_bus, struct device *dev)
+{
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	nvdimm_bus->probe_active++;
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
+}
+
+void nd_region_probe_end(struct nvdimm_bus *nvdimm_bus, struct device *dev, int rc)
+{
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	nd_region_notify_driver_action(nvdimm_bus, dev, rc, true);
+	if (--nvdimm_bus->probe_active == 0)
+		wake_up(&nvdimm_bus->probe_wait);
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
+}
+
+void nd_region_notify_remove(struct nvdimm_bus *nvdimm_bus, struct device *dev, int rc)
+{
+	nvdimm_bus_lock(dev);
+	nd_region_notify_driver_action(nvdimm_bus, dev, rc, false);
+	nvdimm_bus_unlock(dev);
+}
+
 static ssize_t mappingN(struct device *dev, char *buf, int n)
 {
 	struct nd_region *nd_region = to_nd_region(dev);
@@ -322,6 +406,7 @@ static noinline struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus
 	}
 	nd_region->ndr_mappings = ndr_desc->num_mappings;
 	nd_region->provider_data = ndr_desc->provider_data;
+	nd_region->nd_set = ndr_desc->nd_set;
 	dev = &nd_region->dev;
 	dev_set_name(dev, "region%d", nd_region->id);
 	dev->parent = &nvdimm_bus->dev;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 883466f730c8..0f3a6c6c1b73 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -61,11 +61,16 @@ struct nd_cmd_desc {
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
 
@@ -101,4 +106,5 @@ struct nd_region *nvdimm_blk_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_region_desc *ndr_desc);
 struct nd_region *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_region_desc *ndr_desc);
+u64 nd_fletcher64(void *addr, size_t len, bool le);
 #endif /* __LIBNVDIMM_H__ */

