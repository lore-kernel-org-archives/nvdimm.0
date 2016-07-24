Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 87D851A1DF6
 for <linux-nvdimm@lists.01.org>; Sat, 23 Jul 2016 22:29:02 -0700 (PDT)
Subject: [PATCH v4 1/4] libnvdimm: register nvdimm_bus devices with an
 nd_bus driver
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Jul 2016 22:26:38 -0700
Message-ID: <146933799806.26196.12134730376101293848.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146933799257.26196.10157809349693736359.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146933799257.26196.10157809349693736359.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

A recent effort to add a new nvdimm bus provider attribute highlighted a
race between interrogating nvdimm_bus->nd_desc and nvdimm_bus tear down.
The typical way to handle these races is to take the device_lock() in
the attribute method and validate that the device is still active.  In
order for a device to be 'active' it needs to be associated with a
driver.  So, we create the small boilerplate for a driver and register
nvdimm_bus devices on the 'nvdimm_bus_type' bus.

A result of this change is that ndbusX devices now appear under
/sys/bus/nd/devices.  In fact this makes /sys/class/nd somewhat
redundant, but removing that will need to take a long deprecation period
given its use by ndctl binaries in the field.

This change naturally pulls code from drivers/nvdimm/core.c to
drivers/nvdimm/bus.c, so it is a nice code organization clean-up as
well.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c  |  188 +++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/nvdimm/core.c |  127 ---------------------------------
 2 files changed, 181 insertions(+), 134 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 275dd5c0a301..46d7e555b044 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -31,6 +31,7 @@
 int nvdimm_major;
 static int nvdimm_bus_major;
 static struct class *nd_class;
+static DEFINE_IDA(nd_ida);
 
 static int to_nd_device_type(struct device *dev)
 {
@@ -60,13 +61,6 @@ static int nvdimm_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 			to_nd_device_type(dev));
 }
 
-static int nvdimm_bus_match(struct device *dev, struct device_driver *drv)
-{
-	struct nd_device_driver *nd_drv = to_nd_device_driver(drv);
-
-	return !!test_bit(to_nd_device_type(dev), &nd_drv->type);
-}
-
 static struct module *to_bus_provider(struct device *dev)
 {
 	/* pin bus providers while regions are enabled */
@@ -223,6 +217,8 @@ long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 }
 EXPORT_SYMBOL_GPL(nvdimm_clear_poison);
 
+static int nvdimm_bus_match(struct device *dev, struct device_driver *drv);
+
 static struct bus_type nvdimm_bus_type = {
 	.name = "nd",
 	.uevent = nvdimm_bus_uevent,
@@ -232,6 +228,176 @@ static struct bus_type nvdimm_bus_type = {
 	.shutdown = nvdimm_bus_shutdown,
 };
 
+static void nvdimm_bus_release(struct device *dev)
+{
+	struct nvdimm_bus *nvdimm_bus;
+
+	nvdimm_bus = container_of(dev, struct nvdimm_bus, dev);
+	ida_simple_remove(&nd_ida, nvdimm_bus->id);
+	kfree(nvdimm_bus);
+}
+
+static bool is_nvdimm_bus(struct device *dev)
+{
+	return dev->release == nvdimm_bus_release;
+}
+
+struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev)
+{
+	struct device *dev;
+
+	for (dev = nd_dev; dev; dev = dev->parent)
+		if (is_nvdimm_bus(dev))
+			break;
+	dev_WARN_ONCE(nd_dev, !dev, "invalid dev, not on nd bus\n");
+	if (dev)
+		return to_nvdimm_bus(dev);
+	return NULL;
+}
+
+struct nvdimm_bus *to_nvdimm_bus(struct device *dev)
+{
+	struct nvdimm_bus *nvdimm_bus;
+
+	nvdimm_bus = container_of(dev, struct nvdimm_bus, dev);
+	WARN_ON(!is_nvdimm_bus(dev));
+	return nvdimm_bus;
+}
+EXPORT_SYMBOL_GPL(to_nvdimm_bus);
+
+struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
+		struct nvdimm_bus_descriptor *nd_desc)
+{
+	struct nvdimm_bus *nvdimm_bus;
+	int rc;
+
+	nvdimm_bus = kzalloc(sizeof(*nvdimm_bus), GFP_KERNEL);
+	if (!nvdimm_bus)
+		return NULL;
+	INIT_LIST_HEAD(&nvdimm_bus->list);
+	INIT_LIST_HEAD(&nvdimm_bus->mapping_list);
+	INIT_LIST_HEAD(&nvdimm_bus->poison_list);
+	init_waitqueue_head(&nvdimm_bus->probe_wait);
+	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
+	mutex_init(&nvdimm_bus->reconfig_mutex);
+	if (nvdimm_bus->id < 0) {
+		kfree(nvdimm_bus);
+		return NULL;
+	}
+	nvdimm_bus->nd_desc = nd_desc;
+	nvdimm_bus->dev.parent = parent;
+	nvdimm_bus->dev.release = nvdimm_bus_release;
+	nvdimm_bus->dev.groups = nd_desc->attr_groups;
+	nvdimm_bus->dev.bus = &nvdimm_bus_type;
+	dev_set_name(&nvdimm_bus->dev, "ndbus%d", nvdimm_bus->id);
+	rc = device_register(&nvdimm_bus->dev);
+	if (rc) {
+		dev_dbg(&nvdimm_bus->dev, "registration failed: %d\n", rc);
+		goto err;
+	}
+
+	return nvdimm_bus;
+ err:
+	put_device(&nvdimm_bus->dev);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(nvdimm_bus_register);
+
+void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus)
+{
+	if (!nvdimm_bus)
+		return;
+	device_unregister(&nvdimm_bus->dev);
+}
+EXPORT_SYMBOL_GPL(nvdimm_bus_unregister);
+
+static int child_unregister(struct device *dev, void *data)
+{
+	/*
+	 * the singular ndctl class device per bus needs to be
+	 * "device_destroy"ed, so skip it here
+	 *
+	 * i.e. remove classless children
+	 */
+	if (dev->class)
+		/* pass */;
+	else
+		nd_device_unregister(dev, ND_SYNC);
+	return 0;
+}
+
+static void free_poison_list(struct list_head *poison_list)
+{
+	struct nd_poison *pl, *next;
+
+	list_for_each_entry_safe(pl, next, poison_list, list) {
+		list_del(&pl->list);
+		kfree(pl);
+	}
+	list_del_init(poison_list);
+}
+
+static int nd_bus_remove(struct device *dev)
+{
+	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
+
+	mutex_lock(&nvdimm_bus_list_mutex);
+	list_del_init(&nvdimm_bus->list);
+	mutex_unlock(&nvdimm_bus_list_mutex);
+
+	nd_synchronize();
+	device_for_each_child(&nvdimm_bus->dev, NULL, child_unregister);
+
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	free_poison_list(&nvdimm_bus->poison_list);
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
+
+	nvdimm_bus_destroy_ndctl(nvdimm_bus);
+
+	return 0;
+}
+
+static int nd_bus_probe(struct device *dev)
+{
+	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
+	int rc;
+
+	rc = nvdimm_bus_create_ndctl(nvdimm_bus);
+	if (rc)
+		return rc;
+
+	mutex_lock(&nvdimm_bus_list_mutex);
+	list_add_tail(&nvdimm_bus->list, &nvdimm_bus_list);
+	mutex_unlock(&nvdimm_bus_list_mutex);
+
+	/* enable bus provider attributes to look up their local context */
+	dev_set_drvdata(dev, nvdimm_bus->nd_desc);
+
+	return 0;
+}
+
+static struct nd_device_driver nd_bus_driver = {
+	.probe = nd_bus_probe,
+	.remove = nd_bus_remove,
+	.drv = {
+		.name = "nd_bus",
+		.suppress_bind_attrs = true,
+		.bus = &nvdimm_bus_type,
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+	},
+};
+
+static int nvdimm_bus_match(struct device *dev, struct device_driver *drv)
+{
+	struct nd_device_driver *nd_drv = to_nd_device_driver(drv);
+
+	if (is_nvdimm_bus(dev) && nd_drv == &nd_bus_driver)
+		return true;
+
+	return !!test_bit(to_nd_device_type(dev), &nd_drv->type);
+}
+
 static ASYNC_DOMAIN_EXCLUSIVE(nd_async_domain);
 
 void nd_synchronize(void)
@@ -864,8 +1030,14 @@ int __init nvdimm_bus_init(void)
 		goto err_class;
 	}
 
+	rc = driver_register(&nd_bus_driver.drv);
+	if (rc)
+		goto err_nd_bus;
+
 	return 0;
 
+ err_nd_bus:
+	class_destroy(nd_class);
  err_class:
 	unregister_chrdev(nvdimm_major, "dimmctl");
  err_dimm_chrdev:
@@ -878,8 +1050,10 @@ int __init nvdimm_bus_init(void)
 
 void nvdimm_bus_exit(void)
 {
+	driver_unregister(&nd_bus_driver.drv);
 	class_destroy(nd_class);
 	unregister_chrdev(nvdimm_bus_major, "ndctl");
 	unregister_chrdev(nvdimm_major, "dimmctl");
 	bus_unregister(&nvdimm_bus_type);
+	ida_destroy(&nd_ida);
 }
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index e8528756f54f..2c98f958fabb 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -26,7 +26,6 @@
 
 LIST_HEAD(nvdimm_bus_list);
 DEFINE_MUTEX(nvdimm_bus_list_mutex);
-static DEFINE_IDA(nd_ida);
 
 void nvdimm_bus_lock(struct device *dev)
 {
@@ -195,25 +194,6 @@ u64 nd_fletcher64(void *addr, size_t len, bool le)
 }
 EXPORT_SYMBOL_GPL(nd_fletcher64);
 
-static void nvdimm_bus_release(struct device *dev)
-{
-	struct nvdimm_bus *nvdimm_bus;
-
-	nvdimm_bus = container_of(dev, struct nvdimm_bus, dev);
-	ida_simple_remove(&nd_ida, nvdimm_bus->id);
-	kfree(nvdimm_bus);
-}
-
-struct nvdimm_bus *to_nvdimm_bus(struct device *dev)
-{
-	struct nvdimm_bus *nvdimm_bus;
-
-	nvdimm_bus = container_of(dev, struct nvdimm_bus, dev);
-	WARN_ON(nvdimm_bus->dev.release != nvdimm_bus_release);
-	return nvdimm_bus;
-}
-EXPORT_SYMBOL_GPL(to_nvdimm_bus);
-
 struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus)
 {
 	/* struct nvdimm_bus definition is private to libnvdimm */
@@ -221,19 +201,6 @@ struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus)
 }
 EXPORT_SYMBOL_GPL(to_nd_desc);
 
-struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev)
-{
-	struct device *dev;
-
-	for (dev = nd_dev; dev; dev = dev->parent)
-		if (dev->release == nvdimm_bus_release)
-			break;
-	dev_WARN_ONCE(nd_dev, !dev, "invalid dev, not on nd bus\n");
-	if (dev)
-		return to_nvdimm_bus(dev);
-	return NULL;
-}
-
 static bool is_uuid_sep(char sep)
 {
 	if (sep == '\n' || sep == '-' || sep == ':' || sep == '\0')
@@ -447,51 +414,6 @@ struct attribute_group nvdimm_bus_attribute_group = {
 };
 EXPORT_SYMBOL_GPL(nvdimm_bus_attribute_group);
 
-struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
-		struct nvdimm_bus_descriptor *nd_desc)
-{
-	struct nvdimm_bus *nvdimm_bus;
-	int rc;
-
-	nvdimm_bus = kzalloc(sizeof(*nvdimm_bus), GFP_KERNEL);
-	if (!nvdimm_bus)
-		return NULL;
-	INIT_LIST_HEAD(&nvdimm_bus->list);
-	INIT_LIST_HEAD(&nvdimm_bus->mapping_list);
-	INIT_LIST_HEAD(&nvdimm_bus->poison_list);
-	init_waitqueue_head(&nvdimm_bus->probe_wait);
-	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
-	mutex_init(&nvdimm_bus->reconfig_mutex);
-	if (nvdimm_bus->id < 0) {
-		kfree(nvdimm_bus);
-		return NULL;
-	}
-	nvdimm_bus->nd_desc = nd_desc;
-	nvdimm_bus->dev.parent = parent;
-	nvdimm_bus->dev.release = nvdimm_bus_release;
-	nvdimm_bus->dev.groups = nd_desc->attr_groups;
-	dev_set_name(&nvdimm_bus->dev, "ndbus%d", nvdimm_bus->id);
-	rc = device_register(&nvdimm_bus->dev);
-	if (rc) {
-		dev_dbg(&nvdimm_bus->dev, "registration failed: %d\n", rc);
-		goto err;
-	}
-
-	rc = nvdimm_bus_create_ndctl(nvdimm_bus);
-	if (rc)
-		goto err;
-
-	mutex_lock(&nvdimm_bus_list_mutex);
-	list_add_tail(&nvdimm_bus->list, &nvdimm_bus_list);
-	mutex_unlock(&nvdimm_bus_list_mutex);
-
-	return nvdimm_bus;
- err:
-	put_device(&nvdimm_bus->dev);
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(nvdimm_bus_register);
-
 static void set_badblock(struct badblocks *bb, sector_t s, int num)
 {
 	dev_dbg(bb->dev, "Found a poison range (0x%llx, 0x%llx)\n",
@@ -667,54 +589,6 @@ int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
 }
 EXPORT_SYMBOL_GPL(nvdimm_bus_add_poison);
 
-static void free_poison_list(struct list_head *poison_list)
-{
-	struct nd_poison *pl, *next;
-
-	list_for_each_entry_safe(pl, next, poison_list, list) {
-		list_del(&pl->list);
-		kfree(pl);
-	}
-	list_del_init(poison_list);
-}
-
-static int child_unregister(struct device *dev, void *data)
-{
-	/*
-	 * the singular ndctl class device per bus needs to be
-	 * "device_destroy"ed, so skip it here
-	 *
-	 * i.e. remove classless children
-	 */
-	if (dev->class)
-		/* pass */;
-	else
-		nd_device_unregister(dev, ND_SYNC);
-	return 0;
-}
-
-void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus)
-{
-	if (!nvdimm_bus)
-		return;
-
-	mutex_lock(&nvdimm_bus_list_mutex);
-	list_del_init(&nvdimm_bus->list);
-	mutex_unlock(&nvdimm_bus_list_mutex);
-
-	nd_synchronize();
-	device_for_each_child(&nvdimm_bus->dev, NULL, child_unregister);
-
-	nvdimm_bus_lock(&nvdimm_bus->dev);
-	free_poison_list(&nvdimm_bus->poison_list);
-	nvdimm_bus_unlock(&nvdimm_bus->dev);
-
-	nvdimm_bus_destroy_ndctl(nvdimm_bus);
-
-	device_unregister(&nvdimm_bus->dev);
-}
-EXPORT_SYMBOL_GPL(nvdimm_bus_unregister);
-
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 int nd_integrity_init(struct gendisk *disk, unsigned long meta_size)
 {
@@ -773,7 +647,6 @@ static __exit void libnvdimm_exit(void)
 	nvdimm_bus_exit();
 	nd_region_devs_exit();
 	nvdimm_devs_exit();
-	ida_destroy(&nd_ida);
 }
 
 MODULE_LICENSE("GPL v2");

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
