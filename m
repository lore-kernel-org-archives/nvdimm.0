Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 13/21] nd: add interleave-set state-tracking infrastructure
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Apr 2015 21:36:23 -0400
Message-ID: <20150418013623.25237.94475.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
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
validated against the current configuration.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/bus.c         |   41 +++++++++
 drivers/block/nd/core.c        |   51 ++++++++++++
 drivers/block/nd/dimm_devs.c   |   18 ++++
 drivers/block/nd/nd-private.h  |   17 ++++
 drivers/block/nd/nd.h          |    4 +
 drivers/block/nd/region_devs.c |  176 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 305 insertions(+), 2 deletions(-)

diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
index c98fe05a4c9b..944d7d7845fe 100644
--- a/drivers/block/nd/bus.c
+++ b/drivers/block/nd/bus.c
@@ -79,7 +79,10 @@ static int nd_bus_probe(struct device *dev)
 	if (!try_module_get(provider))
 		return -ENXIO;
 
+	nd_region_probe_start(nd_bus, dev);
 	rc = nd_drv->probe(dev);
+	nd_region_probe_end(nd_bus, dev, rc);
+
 	dev_dbg(&nd_bus->dev, "%s.probe(%s) = %d\n", dev->driver->name,
 			dev_name(dev), rc);
 	if (rc != 0)
@@ -95,6 +98,8 @@ static int nd_bus_remove(struct device *dev)
 	int rc;
 
 	rc = nd_drv->remove(dev);
+	nd_region_notify_remove(nd_bus, dev, rc);
+
 	dev_dbg(&nd_bus->dev, "%s.remove(%s) = %d\n", dev->driver->name,
 			dev_name(dev), rc);
 	module_put(provider);
@@ -269,6 +274,33 @@ void nd_bus_destroy_ndctl(struct nd_bus *nd_bus)
 	device_destroy(nd_class, MKDEV(nd_bus_major, nd_bus->id));
 }
 
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
+	if (!nd_dimm || cmd != NFIT_CMD_SET_CONFIG_DATA)
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
 		int read_only, unsigned int cmd, unsigned long arg)
 {
@@ -399,11 +431,18 @@ static int __nd_ioctl(struct nd_bus *nd_bus, struct nd_dimm *nd_dimm,
 		goto out;
 	}
 
+	nd_bus_lock(&nd_bus->dev);
+	rc = nd_cmd_clear_to_send(nd_dimm, _IOC_NR(cmd));
+	if (rc)
+		goto out_unlock;
+
 	rc = nfit_desc->nfit_ctl(nfit_desc, nd_dimm, _IOC_NR(cmd), buf, buf_len);
 	if (rc < 0)
-		goto out;
+		goto out_unlock;
 	if (copy_to_user(p, buf, buf_len))
 		rc = -EFAULT;
+ out_unlock:
+	nd_bus_unlock(&nd_bus->dev);
  out:
 	if (is_vmalloc_addr(buf))
 		vfree(buf);
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
index c795e8057061..976cd5e3ebaf 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -31,6 +31,36 @@ static bool warn_checksum;
 module_param(warn_checksum, bool, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(warn_checksum, "Turn checksum errors into warnings");
 
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
 /**
  * nd_dimm_by_handle - lookup an nd_dimm by its corresponding nfit_handle
  * @nd_bus: parent bus of the dimm
@@ -49,6 +79,20 @@ struct nd_dimm *nd_dimm_by_handle(struct nd_bus *nd_bus, u32 nfit_handle)
 	return nd_dimm;
 }
 
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
+
 static void nd_bus_release(struct device *dev)
 {
 	struct nd_bus *nd_bus = container_of(dev, struct nd_bus, dev);
@@ -60,6 +104,7 @@ static void nd_bus_release(struct device *dev)
 
 	list_for_each_entry_safe(nd_spa, _spa, &nd_bus->spas, list) {
 		list_del_init(&nd_spa->list);
+		kfree(nd_spa->nd_set);
 		kfree(nd_spa);
 	}
 	list_for_each_entry_safe(nd_dcr, _dcr, &nd_bus->dcrs, list) {
@@ -205,8 +250,10 @@ static void *nd_bus_new(struct device *parent,
 	INIT_LIST_HEAD(&nd_bus->memdevs);
 	INIT_LIST_HEAD(&nd_bus->dimms);
 	INIT_LIST_HEAD(&nd_bus->list);
+	init_waitqueue_head(&nd_bus->probe_wait);
 	INIT_RADIX_TREE(&nd_bus->dimm_radix, GFP_KERNEL);
 	nd_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
+	mutex_init(&nd_bus->reconfig_mutex);
 	if (nd_bus->id < 0) {
 		kfree(nd_bus);
 		return NULL;
@@ -570,6 +617,10 @@ static struct nd_bus *nd_bus_probe(struct nd_bus *nd_bus)
 	if (rc)
 		goto err;
 
+	rc = nd_bus_init_interleave_sets(nd_bus);
+	if (rc)
+		goto err;
+
 	rc = nd_bus_create_ndctl(nd_bus);
 	if (rc)
 		goto err;
diff --git a/drivers/block/nd/dimm_devs.c b/drivers/block/nd/dimm_devs.c
index d15ca75804ac..6192d9c82b9b 100644
--- a/drivers/block/nd/dimm_devs.c
+++ b/drivers/block/nd/dimm_devs.c
@@ -287,6 +287,22 @@ static ssize_t commands_show(struct device *dev,
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
 	&dev_attr_handle.attr,
 	&dev_attr_phys_id.attr,
@@ -294,6 +310,7 @@ static struct attribute *nd_dimm_attributes[] = {
 	&dev_attr_device.attr,
 	&dev_attr_format.attr,
 	&dev_attr_serial.attr,
+	&dev_attr_state.attr,
 	&dev_attr_revision.attr,
 	&dev_attr_commands.attr,
 	NULL,
@@ -364,6 +381,7 @@ static struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus,
 	if (nd_dimm->id < 0)
 		goto err_ida;
 
+	atomic_set(&nd_dimm->busy, 0);
 	nd_dimm->nd_mem = nd_mem;
 	dev = &nd_dimm->dev;
 	dev_set_name(dev, "nmem%d", nd_dimm->id);
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index db68e013b9d0..15ca7be507ce 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -15,6 +15,9 @@
 #include <linux/radix-tree.h>
 #include <linux/device.h>
 #include <linux/sizes.h>
+#include <linux/mutex.h>
+#include <linux/io.h>
+#include "nfit.h"
 
 extern struct list_head nd_bus_list;
 extern struct mutex nd_bus_list_mutex;
@@ -33,6 +36,7 @@ enum {
 struct nd_bus {
 	struct nfit_bus_descriptor *nfit_desc;
 	struct radix_tree_root dimm_radix;
+	wait_queue_head_t probe_wait;
 	struct module *module;
 	struct list_head memdevs;
 	struct list_head dimms;
@@ -41,7 +45,8 @@ struct nd_bus {
 	struct list_head bdws;
 	struct list_head list;
 	struct device dev;
-	int id;
+	int id, probe_active;
+	struct mutex reconfig_mutex;
 };
 
 struct nd_dimm {
@@ -50,14 +55,20 @@ struct nd_dimm {
 	struct device dev;
 	void *provider_data;
 	int id, nfit_status;
+	atomic_t busy;
 	struct nd_dimm_delete {
 		struct nd_bus *nd_bus;
 		struct nd_mem *nd_mem;
 	} *del_info;
 };
 
+struct nd_interleave_set {
+	u64 cookie;
+};
+
 struct nd_spa {
 	struct nfit_spa __iomem *nfit_spa;
+	struct nd_interleave_set *nd_set;
 	struct list_head list;
 };
 
@@ -103,9 +114,13 @@ int __init nd_dimm_init(void);
 int __init nd_region_init(void);
 void nd_dimm_exit(void);
 int nd_region_exit(void);
+void nd_region_probe_start(struct nd_bus *nd_bus, struct device *dev);
+void nd_region_probe_end(struct nd_bus *nd_bus, struct device *dev, int rc);
+void nd_region_notify_remove(struct nd_bus *nd_bus, struct device *dev, int rc);
 int nd_bus_create_ndctl(struct nd_bus *nd_bus);
 void nd_bus_destroy_ndctl(struct nd_bus *nd_bus);
 int nd_bus_register_dimms(struct nd_bus *nd_bus);
 int nd_bus_register_regions(struct nd_bus *nd_bus);
+int nd_bus_init_interleave_sets(struct nd_bus *nd_bus);
 int nd_match_dimm(struct device *dev, void *data);
 #endif /* __ND_PRIVATE_H__ */
diff --git a/drivers/block/nd/nd.h b/drivers/block/nd/nd.h
index 4ac7ff2af4c8..4deed46884c1 100644
--- a/drivers/block/nd/nd.h
+++ b/drivers/block/nd/nd.h
@@ -50,6 +50,7 @@ enum nd_async_mode {
 
 void nd_device_register(struct device *dev);
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode);
+u64 nd_fletcher64(void __iomem *addr, size_t len);
 extern struct attribute_group nd_device_attribute_group;
 struct nd_dimm;
 u32 to_nfit_handle(struct nd_dimm *nd_dimm);
@@ -63,4 +64,7 @@ int nd_dimm_firmware_status(struct device *dev);
 struct nd_region *to_nd_region(struct device *dev);
 int nd_region_to_namespace_type(struct nd_region *nd_region);
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
+void nd_bus_lock(struct device *dev);
+void nd_bus_unlock(struct device *dev);
+bool is_nd_bus_locked(struct device *dev);
 #endif /* __ND_H__ */
diff --git a/drivers/block/nd/region_devs.c b/drivers/block/nd/region_devs.c
index 03b192368e1a..13f45be755a5 100644
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
 #include "nfit.h"
@@ -137,6 +140,21 @@ static ssize_t nstype_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(nstype);
 
+static ssize_t set_cookie_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+	struct nd_spa *nd_spa = nd_region->nd_spa;
+
+	if (is_nd_pmem(dev) && nd_spa->nd_set)
+		/* pass, should be precluded by nd_region_visible */;
+	else
+		return -ENXIO;
+
+	return sprintf(buf, "%#llx\n", nd_spa->nd_set->cookie);
+}
+static DEVICE_ATTR_RO(set_cookie);
+
 static ssize_t init_namespaces_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -154,12 +172,29 @@ static struct attribute *nd_region_attributes[] = {
 	&dev_attr_nstype.attr,
 	&dev_attr_mappings.attr,
 	&dev_attr_spa_index.attr,
+	&dev_attr_set_cookie.attr,
 	&dev_attr_init_namespaces.attr,
 	NULL,
 };
 
+static umode_t nd_region_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, typeof(*dev), kobj);
+	struct nd_region *nd_region = to_nd_region(dev);
+	struct nd_spa *nd_spa = nd_region->nd_spa;
+
+	if (a != &dev_attr_set_cookie.attr)
+		return a->mode;
+
+	if (is_nd_pmem(dev) && nd_spa->nd_set)
+			return a->mode;
+
+	return 0;
+}
+
 static struct attribute_group nd_region_attribute_group = {
 	.attrs = nd_region_attributes,
+	.is_visible = nd_region_visible,
 };
 
 /*
@@ -203,6 +238,147 @@ static struct nd_mem *nd_memdev_to_mem(struct nd_bus *nd_bus,
 	return NULL;
 }
 
+/* enough info to uniquely specify an interleave set */
+struct nd_set_info {
+	struct nd_set_info_map {
+		u64 region_spa_offset;
+		u32 serial_number;
+		u32 pad;
+	} mapping[0];
+};
+
+static size_t sizeof_nd_set_info(int num_mappings)
+{
+	return sizeof(struct nd_set_info)
+		+ num_mappings * sizeof(struct nd_set_info_map);
+}
+
+static int cmp_map(const void *m0, const void *m1)
+{
+	const struct nd_set_info_map *map0 = m0;
+	const struct nd_set_info_map *map1 = m1;
+
+	return memcmp(&map0->region_spa_offset, &map1->region_spa_offset,
+			sizeof(u64));
+}
+
+static int init_interleave_set(struct nd_bus *nd_bus,
+		struct nd_interleave_set *nd_set, struct nd_spa *nd_spa)
+{
+	u16 spa_index = readw(&nd_spa->nfit_spa->spa_index);
+	int num_mappings = num_nd_mem(nd_bus, spa_index);
+	struct nd_set_info *info;
+	int i;
+
+	info = kzalloc(sizeof_nd_set_info(num_mappings), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+	for (i = 0; i < num_mappings; i++) {
+		struct nd_set_info_map *map = &info->mapping[i];
+		struct nd_memdev *nd_memdev = nd_memdev_from_spa(nd_bus,
+				spa_index, i);
+		struct nd_mem *nd_mem = nd_memdev_to_mem(nd_bus, nd_memdev);
+
+		if (!nd_mem) {
+			dev_err(&nd_bus->dev, "%s: failed to find DCR\n",
+					__func__);
+			kfree(info);
+			return -ENODEV;
+		}
+
+		map->region_spa_offset = readl(
+				&nd_memdev->nfit_mem->region_spa_offset);
+		map->serial_number = readl(&nd_mem->nfit_dcr->serial_number);
+	}
+
+	sort(&info->mapping[0], num_mappings, sizeof(struct nd_set_info_map),
+			cmp_map, NULL);
+	nd_set->cookie = nd_fletcher64(info, sizeof_nd_set_info(num_mappings));
+
+	kfree(info);
+
+	return 0;
+}
+
+int nd_bus_init_interleave_sets(struct nd_bus *nd_bus)
+{
+	struct nd_spa *nd_spa;
+	int rc = 0;
+
+	/* PMEM interleave sets */
+	list_for_each_entry(nd_spa, &nd_bus->spas, list) {
+		u16 spa_index = readw(&nd_spa->nfit_spa->spa_index);
+		int spa_type = nfit_spa_type(nd_spa->nfit_spa);
+		struct nd_interleave_set *nd_set;
+
+		if (spa_type != NFIT_SPA_PM)
+			continue;
+		if (nd_memdev_from_spa(nd_bus, spa_index, 0) == NULL)
+			continue;
+		nd_set = kzalloc(sizeof(*nd_set), GFP_KERNEL);
+		if (!nd_set) {
+			rc = -ENOMEM;
+			break;
+		}
+		nd_spa->nd_set = nd_set;
+
+		rc = init_interleave_set(nd_bus, nd_set, nd_spa);
+		if (rc)
+			break;
+	}
+
+	return rc;
+}
+
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

