Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v3 2/3] nfit, libnvdimm: allow an ARS scrub to be triggered on demand
Date: Fri, 22 Jul 2016 17:21:32 -0600
Message-Id: <1469229693-17980-3-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1469229693-17980-1-git-send-email-vishal.l.verma@intel.com>
References: <1469229693-17980-1-git-send-email-vishal.l.verma@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Dan Williams <dan.j.williams@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Normally, an ARS (Address Range Scrub) only happens at
boot/initialization time. There can however arise situations where a
bus-wide rescan is needed - notably, in the case of discovering a latent
media error, we should do a full rescan to figure out what other sectors
are bad, and thus potentially avoid triggering an mce on them in the
future. Also provide a sysfs trigger to start a bus-wide scrub.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: <linux-acpi@vger.kernel.org>
Cc: <linux-nvdimm@lists.01.org>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/acpi/nfit.c       | 134 +++++++++++++++++++++++++++++++++++++++++++---
 drivers/acpi/nfit.h       |   4 +-
 drivers/nvdimm/core.c     |   7 +++
 include/linux/libnvdimm.h |   1 +
 4 files changed, 138 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index c0e1c3a..6e45183 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/ndctl.h>
+#include <linux/sysfs.h>
 #include <linux/delay.h>
 #include <linux/list.h>
 #include <linux/acpi.h>
@@ -874,14 +875,76 @@ static ssize_t revision_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(revision);
 
+/*
+ * This shows the number of full Address Range Scrubs that have been
+ * completed since driver load time. Userspace can wait on this using
+ * select/poll etc. A '+' at the end indicates an ARS is in progress
+ */
+static ssize_t scrub_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
+
+	return sprintf(buf, "%d%s", acpi_desc->scrub_count,
+		(work_busy(&acpi_desc->work)) ? "+\n" : "\n");
+}
+
+static int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc);
+
+static ssize_t scrub_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
+	int rc;
+
+	rc = acpi_nfit_ars_rescan(acpi_desc);
+	if (rc)
+		return rc;
+	return size;
+}
+static DEVICE_ATTR_RW(scrub);
+
+static bool acpi_nfit_ars_supported(struct nvdimm_bus *nvdimm_bus)
+{
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+
+	if (test_bit(ND_CMD_ARS_CAP, &nd_desc->cmd_mask))
+		return true;
+
+	return false;
+}
+
+static umode_t nfit_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
+
+	if (a == &dev_attr_revision.attr)
+		return a->mode;
+
+	/* check if scrub is supported */
+	if (a == &dev_attr_scrub.attr) {
+		if (!acpi_nfit_ars_supported(nvdimm_bus))
+			return 0;
+	}
+
+	return a->mode;
+}
+
 static struct attribute *acpi_nfit_attributes[] = {
 	&dev_attr_revision.attr,
+	&dev_attr_scrub.attr,
 	NULL,
 };
 
 static struct attribute_group acpi_nfit_attribute_group = {
 	.name = "nfit",
 	.attrs = acpi_nfit_attributes,
+	.is_visible = nfit_visible,
 };
 
 static const struct attribute_group *acpi_nfit_attribute_groups[] = {
@@ -2055,7 +2118,7 @@ static void acpi_nfit_async_scrub(struct acpi_nfit_desc *acpi_desc,
 	unsigned int tmo = scrub_timeout;
 	int rc;
 
-	if (nfit_spa->ars_done || !nfit_spa->nd_region)
+	if (!nfit_spa->ars_required || !nfit_spa->nd_region)
 		return;
 
 	rc = ars_start(acpi_desc, nfit_spa);
@@ -2144,7 +2207,9 @@ static void acpi_nfit_scrub(struct work_struct *work)
 	 * firmware initiated scrubs to complete and then we go search for the
 	 * affected spa regions to mark them scanned.  In the second phase we
 	 * initiate a directed scrub for every range that was not scrubbed in
-	 * phase 1.
+	 * phase 1. If we're called for a 'rescan', we harmlessly pass through
+	 * the first phase, but really only care about running phase 2, where
+	 * regions can be notified of new poison.
 	 */
 
 	/* process platform firmware initiated scrubs */
@@ -2247,14 +2312,17 @@ static void acpi_nfit_scrub(struct work_struct *work)
 		 * Flag all the ranges that still need scrubbing, but
 		 * register them now to make data available.
 		 */
-		if (nfit_spa->nd_region)
-			nfit_spa->ars_done = 1;
-		else
+		if (!nfit_spa->nd_region) {
+			nfit_spa->ars_required = 1;
 			acpi_nfit_register_region(acpi_desc, nfit_spa);
+		}
 	}
 
 	list_for_each_entry(nfit_spa, &acpi_desc->spas, list)
 		acpi_nfit_async_scrub(acpi_desc, nfit_spa);
+	acpi_desc->scrub_count++;
+	if (acpi_desc->scrub_count_state)
+		sysfs_notify_dirent(acpi_desc->scrub_count_state);
 	mutex_unlock(&acpi_desc->init_mutex);
 }
 
@@ -2292,12 +2360,39 @@ static int acpi_nfit_check_deletions(struct acpi_nfit_desc *acpi_desc,
 	return 0;
 }
 
+static int acpi_nfit_desc_init_scrub_attr(struct acpi_nfit_desc *acpi_desc)
+{
+	struct device *dev = acpi_desc->dev;
+
+	if (acpi_nfit_ars_supported(acpi_desc->nvdimm_bus)) {
+		struct kernfs_node *nfit;
+		struct device *bus_dev;
+
+		bus_dev = to_nvdimm_bus_dev(acpi_desc->nvdimm_bus);
+		nfit = sysfs_get_dirent(bus_dev->kobj.sd, "nfit");
+		if (!nfit) {
+			dev_err(dev, "sysfs_get_dirent 'nfit' failed\n");
+			return -ENODEV;
+		}
+		acpi_desc->scrub_count_state = sysfs_get_dirent(nfit, "scrub");
+		sysfs_put(nfit);
+		if (!acpi_desc->scrub_count_state) {
+			dev_err(dev, "sysfs_get_dirent 'scrub' failed\n");
+			return -ENODEV;
+		}
+	}
+
+	return 0;
+}
+
 static void acpi_nfit_destruct(void *data)
 {
 	struct acpi_nfit_desc *acpi_desc = data;
 
 	acpi_desc->cancel = 1;
 	flush_workqueue(nfit_wq);
+	if (acpi_desc->scrub_count_state)
+		sysfs_put(acpi_desc->scrub_count_state);
 	nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
 	acpi_desc->nvdimm_bus = NULL;
 }
@@ -2309,6 +2404,8 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
 	const void *end;
 	int rc;
 
+	acpi_nfit_init_dsms(acpi_desc);
+
 	if (!acpi_desc->nvdimm_bus) {
 		acpi_desc->nvdimm_bus = nvdimm_bus_register(dev,
 				&acpi_desc->nd_desc);
@@ -2320,6 +2417,10 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
 			return rc;
 	}
 
+	rc = acpi_nfit_desc_init_scrub_attr(acpi_desc);
+	if (rc)
+		return rc;
+
 	mutex_lock(&acpi_desc->init_mutex);
 
 	INIT_LIST_HEAD(&prev.spas);
@@ -2361,8 +2462,6 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
 	if (rc)
 		goto out_unlock;
 
-	acpi_nfit_init_dsms(acpi_desc);
-
 	rc = acpi_nfit_register_dimms(acpi_desc);
 	if (rc)
 		goto out_unlock;
@@ -2430,6 +2529,27 @@ static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
 	return 0;
 }
 
+static int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc)
+{
+	struct device *dev = acpi_desc->dev;
+	struct nfit_spa *nfit_spa;
+
+	if (work_busy(&acpi_desc->work))
+		return -EBUSY;
+
+	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
+		struct acpi_nfit_system_address *spa = nfit_spa->spa;
+
+		if (nfit_spa_type(spa) != NFIT_SPA_PM)
+			continue;
+
+		nfit_spa->ars_required = 1;
+	}
+	queue_work(nfit_wq, &acpi_desc->work);
+	dev_info(dev, "%s: ars_scan triggered\n", __func__);
+	return 0;
+}
+
 void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
 {
 	struct nvdimm_bus_descriptor *nd_desc;
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 9696e7a..33fc2e9 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -80,7 +80,7 @@ enum {
 struct nfit_spa {
 	struct list_head list;
 	struct nd_region *nd_region;
-	unsigned int ars_done:1;
+	unsigned int ars_required:1;
 	u32 clear_err_unit;
 	u32 max_ars;
 	struct acpi_nfit_system_address spa[0];
@@ -148,6 +148,8 @@ struct acpi_nfit_desc {
 	struct nd_cmd_ars_status *ars_status;
 	size_t ars_status_size;
 	struct work_struct work;
+	struct kernfs_node *scrub_count_state;
+	unsigned int scrub_count;
 	unsigned int cancel:1;
 	unsigned long dimm_cmd_force_en;
 	unsigned long bus_cmd_force_en;
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index e852875..c128674 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -221,6 +221,13 @@ struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus)
 }
 EXPORT_SYMBOL_GPL(to_nd_desc);
 
+struct device *to_nvdimm_bus_dev(struct nvdimm_bus *nvdimm_bus)
+{
+	/* struct nvdimm_bus definition is private to libnvdimm */
+	return &nvdimm_bus->dev;
+}
+EXPORT_SYMBOL_GPL(to_nvdimm_bus_dev);
+
 struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev)
 {
 	struct device *dev;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 2ab869d..b519e13 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -137,6 +137,7 @@ struct nvdimm *to_nvdimm(struct device *dev);
 struct nd_region *to_nd_region(struct device *dev);
 struct nd_blk_region *to_nd_blk_region(struct device *dev);
 struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus);
+struct device *to_nvdimm_bus_dev(struct nvdimm_bus *nvdimm_bus);
 const char *nvdimm_name(struct nvdimm *nvdimm);
 unsigned long nvdimm_cmd_mask(struct nvdimm *nvdimm);
 void *nvdimm_provider_data(struct nvdimm *nvdimm);
-- 
2.7.4
