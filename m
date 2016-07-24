Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id DAAD61A1DFF
 for <linux-nvdimm@lists.01.org>; Sat, 23 Jul 2016 22:29:07 -0700 (PDT)
Subject: [PATCH v4 2/4] nfit,
 libnvdimm: allow an ARS scrub to be triggered on demand
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Jul 2016 22:26:43 -0700
Message-ID: <146933800343.26196.11707211474975930425.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Vishal Verma <vishal.l.verma@intel.com>

Normally, an ARS (Address Range Scrub) only happens at
boot/initialization time. There can however arise situations where a
bus-wide rescan is needed - notably, in the case of discovering a latent
media error, we should do a full rescan to figure out what other sectors
are bad, and thus potentially avoid triggering an mce on them in the
future. Also provide a sysfs trigger to start a bus-wide scrub.

Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c       |  167 +++++++++++++++++++++++++++++++++++++++++++--
 drivers/acpi/nfit.h       |    4 +
 drivers/nvdimm/core.c     |    7 ++
 include/linux/libnvdimm.h |    1 
 4 files changed, 171 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index be7c2fde16e7..2eaa03dc185a 100644
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
@@ -874,14 +875,87 @@ static ssize_t revision_show(struct device *dev,
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
+	struct nvdimm_bus_descriptor *nd_desc;
+	ssize_t rc = -ENXIO;
+
+	device_lock(dev);
+	nd_desc = dev_get_drvdata(dev);
+	if (nd_desc) {
+		struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
+
+		rc = sprintf(buf, "%d%s", acpi_desc->scrub_count,
+				(work_busy(&acpi_desc->work)) ? "+\n" : "\n");
+	}
+	device_unlock(dev);
+	return rc;
+}
+
+static int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc);
+
+static ssize_t scrub_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct nvdimm_bus_descriptor *nd_desc;
+	ssize_t rc;
+	long val;
+
+	rc = kstrtol(buf, 0, &val);
+	if (rc)
+		return rc;
+	if (val != 1)
+		return -EINVAL;
+
+	device_lock(dev);
+	nd_desc = dev_get_drvdata(dev);
+	if (nd_desc) {
+		struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
+
+		rc = acpi_nfit_ars_rescan(acpi_desc);
+	}
+	device_unlock(dev);
+	if (rc)
+		return rc;
+	return size;
+}
+static DEVICE_ATTR_RW(scrub);
+
+static bool ars_supported(struct nvdimm_bus *nvdimm_bus)
+{
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	const unsigned long mask = 1 << ND_CMD_ARS_CAP | 1 << ND_CMD_ARS_START
+		| 1 << ND_CMD_ARS_STATUS;
+
+	return (nd_desc->cmd_mask & mask) == mask;
+}
+
+static umode_t nfit_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
+
+	if (a == &dev_attr_scrub.attr && !ars_supported(nvdimm_bus))
+		return 0;
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
@@ -2054,7 +2128,7 @@ static void acpi_nfit_async_scrub(struct acpi_nfit_desc *acpi_desc,
 	unsigned int tmo = scrub_timeout;
 	int rc;
 
-	if (nfit_spa->ars_done || !nfit_spa->nd_region)
+	if (!nfit_spa->ars_required || !nfit_spa->nd_region)
 		return;
 
 	rc = ars_start(acpi_desc, nfit_spa);
@@ -2143,7 +2217,9 @@ static void acpi_nfit_scrub(struct work_struct *work)
 	 * firmware initiated scrubs to complete and then we go search for the
 	 * affected spa regions to mark them scanned.  In the second phase we
 	 * initiate a directed scrub for every range that was not scrubbed in
-	 * phase 1.
+	 * phase 1. If we're called for a 'rescan', we harmlessly pass through
+	 * the first phase, but really only care about running phase 2, where
+	 * regions can be notified of new poison.
 	 */
 
 	/* process platform firmware initiated scrubs */
@@ -2246,14 +2322,17 @@ static void acpi_nfit_scrub(struct work_struct *work)
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
 
@@ -2291,12 +2370,48 @@ static int acpi_nfit_check_deletions(struct acpi_nfit_desc *acpi_desc,
 	return 0;
 }
 
+static int acpi_nfit_desc_init_scrub_attr(struct acpi_nfit_desc *acpi_desc)
+{
+	struct device *dev = acpi_desc->dev;
+	struct kernfs_node *nfit;
+	struct device *bus_dev;
+
+	if (!ars_supported(acpi_desc->nvdimm_bus))
+		return 0;
+
+	bus_dev = to_nvdimm_bus_dev(acpi_desc->nvdimm_bus);
+	nfit = sysfs_get_dirent(bus_dev->kobj.sd, "nfit");
+	if (!nfit) {
+		dev_err(dev, "sysfs_get_dirent 'nfit' failed\n");
+		return -ENODEV;
+	}
+	acpi_desc->scrub_count_state = sysfs_get_dirent(nfit, "scrub");
+	sysfs_put(nfit);
+	if (!acpi_desc->scrub_count_state) {
+		dev_err(dev, "sysfs_get_dirent 'scrub' failed\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static void acpi_nfit_destruct(void *data)
 {
 	struct acpi_nfit_desc *acpi_desc = data;
+	struct device *bus_dev = to_nvdimm_bus_dev(acpi_desc->nvdimm_bus);
 
 	acpi_desc->cancel = 1;
+	/*
+	 * Bounce the nvdimm bus lock to make sure any in-flight
+	 * acpi_nfit_ars_rescan() submissions have had a chance to
+	 * either submit or see ->cancel set.
+	 */
+	device_lock(bus_dev);
+	device_unlock(bus_dev);
+
 	flush_workqueue(nfit_wq);
+	if (acpi_desc->scrub_count_state)
+		sysfs_put(acpi_desc->scrub_count_state);
 	nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
 	acpi_desc->nvdimm_bus = NULL;
 }
@@ -2308,17 +2423,30 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
 	const void *end;
 	int rc;
 
+	acpi_nfit_init_dsms(acpi_desc);
+
 	if (!acpi_desc->nvdimm_bus) {
+		acpi_nfit_init_dsms(acpi_desc);
+
 		acpi_desc->nvdimm_bus = nvdimm_bus_register(dev,
 				&acpi_desc->nd_desc);
 		if (!acpi_desc->nvdimm_bus)
 			return -ENOMEM;
+
 		rc = devm_add_action_or_reset(dev, acpi_nfit_destruct,
 				acpi_desc);
 		if (rc)
 			return rc;
+
+		rc = acpi_nfit_desc_init_scrub_attr(acpi_desc);
+		if (rc)
+			return rc;
 	}
 
+	rc = acpi_nfit_desc_init_scrub_attr(acpi_desc);
+	if (rc)
+		return rc;
+
 	mutex_lock(&acpi_desc->init_mutex);
 
 	INIT_LIST_HEAD(&prev.spas);
@@ -2360,8 +2488,6 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
 	if (rc)
 		goto out_unlock;
 
-	acpi_nfit_init_dsms(acpi_desc);
-
 	rc = acpi_nfit_register_dimms(acpi_desc);
 	if (rc)
 		goto out_unlock;
@@ -2429,6 +2555,33 @@ static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
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
+	if (acpi_desc->cancel)
+		return 0;
+
+	mutex_lock(&acpi_desc->init_mutex);
+	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
+		struct acpi_nfit_system_address *spa = nfit_spa->spa;
+
+		if (nfit_spa_type(spa) != NFIT_SPA_PM)
+			continue;
+
+		nfit_spa->ars_required = 1;
+	}
+	queue_work(nfit_wq, &acpi_desc->work);
+	dev_dbg(dev, "%s: ars_scan triggered\n", __func__);
+	mutex_unlock(&acpi_desc->init_mutex);
+
+	return 0;
+}
+
 void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
 {
 	struct nvdimm_bus_descriptor *nd_desc;
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index b63a583a678f..6ecf337c97aa 100644
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
index 2c98f958fabb..715583f69d28 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -201,6 +201,13 @@ struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus)
 }
 EXPORT_SYMBOL_GPL(to_nd_desc);
 
+struct device *to_nvdimm_bus_dev(struct nvdimm_bus *nvdimm_bus)
+{
+	/* struct nvdimm_bus definition is private to libnvdimm */
+	return &nvdimm_bus->dev;
+}
+EXPORT_SYMBOL_GPL(to_nvdimm_bus_dev);
+
 static bool is_uuid_sep(char sep)
 {
 	if (sep == '\n' || sep == '-' || sep == ':' || sep == '\0')
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 2ab869dece4a..b519e137b9b7 100644
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

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
