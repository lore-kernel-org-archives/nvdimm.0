Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0CD491A1E2B
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 14:56:46 -0700 (PDT)
Subject: [PATCH 2/3] acpi, nfit: add dimm device notification support
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Aug 2016 14:54:22 -0700
Message-ID: <147198926249.3136.6163137762013359047.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147198925154.3136.14739108342311837939.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147198925154.3136.14739108342311837939.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Per "ACPI 6.1 Section 9.20.3" NVDIMM devices, children of the ACPI0012
NVDIMM Root device, can receive health event notifications.

Given that these devices are precluded from registering a notification
handler via acpi_driver.acpi_device_ops (due to no _HID), we use
acpi_install_notify_handler() directly.  The registered handler,
acpi_nvdimm_notify(), triggers a poll(2) event on the nmemX/nfit/flags
sysfs attribute when a health event notification is received.

Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c   |   83 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/acpi/nfit/nfit.h   |    5 +++
 drivers/nvdimm/dimm_devs.c |    6 +++
 include/linux/libnvdimm.h  |    1 +
 4 files changed, 91 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 8120e8218f93..65f155db4283 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1248,6 +1248,43 @@ static struct nvdimm *acpi_nfit_dimm_by_handle(struct acpi_nfit_desc *acpi_desc,
 	return NULL;
 }
 
+static void __acpi_nvdimm_notify(struct device *dev, u32 event)
+{
+	struct nfit_mem *nfit_mem;
+	struct acpi_nfit_desc *acpi_desc;
+
+	dev_dbg(dev->parent, "%s: %s: event: %d\n", dev_name(dev), __func__,
+			event);
+
+	if (event != NFIT_NOTIFY_DIMM_HEALTH) {
+		dev_dbg(dev->parent, "%s: unknown event: %d\n", dev_name(dev),
+				event);
+		return;
+	}
+
+	acpi_desc = dev_get_drvdata(dev->parent);
+	if (!acpi_desc)
+		return;
+
+	/*
+	 * If we successfully retrieved acpi_desc, then we know nfit_mem data
+	 * is still valid.
+	 */
+	nfit_mem = dev_get_drvdata(dev);
+	if (nfit_mem && nfit_mem->flags_attr)
+		sysfs_notify_dirent(nfit_mem->flags_attr);
+}
+
+static void acpi_nvdimm_notify(acpi_handle handle, u32 event, void *data)
+{
+	struct acpi_device *adev = data;
+	struct device *dev = &adev->dev;
+
+	device_lock(dev->parent);
+	__acpi_nvdimm_notify(dev, event);
+	device_unlock(dev->parent);
+}
+
 static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_mem *nfit_mem, u32 device_handle)
 {
@@ -1272,6 +1309,13 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		return force_enable_dimms ? 0 : -ENODEV;
 	}
 
+	if (ACPI_FAILURE(acpi_install_notify_handler(adev_dimm->handle,
+		ACPI_DEVICE_NOTIFY, acpi_nvdimm_notify, adev_dimm))) {
+		dev_err(dev, "%s: notification registration failed\n",
+				dev_name(&adev_dimm->dev));
+		return -ENXIO;
+	}
+
 	/*
 	 * Until standardization materializes we need to consider 4
 	 * different command sets.  Note, that checking for function0 (bit0)
@@ -1313,15 +1357,14 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 {
 	struct nfit_mem *nfit_mem;
-	int dimm_count = 0;
+	int dimm_count = 0, rc;
+	struct nvdimm *nvdimm;
 
 	list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
 		struct acpi_nfit_flush_address *flush;
 		unsigned long flags = 0, cmd_mask;
-		struct nvdimm *nvdimm;
 		u32 device_handle;
 		u16 mem_flags;
-		int rc;
 
 		device_handle = __to_nfit_memdev(nfit_mem)->device_handle;
 		nvdimm = acpi_nfit_dimm_by_handle(acpi_desc, device_handle);
@@ -1374,7 +1417,28 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 
 	}
 
-	return nvdimm_bus_check_dimm_count(acpi_desc->nvdimm_bus, dimm_count);
+	rc = nvdimm_bus_check_dimm_count(acpi_desc->nvdimm_bus, dimm_count);
+	if (rc)
+		return rc;
+
+	/*
+	 * Now that dimms are successfully registered, and async registration
+	 * is flushed, attempt to enable event notification.
+	 */
+	list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
+		struct kernfs_node *nfit_kernfs;
+
+		nvdimm = nfit_mem->nvdimm;
+		nfit_kernfs = sysfs_get_dirent(nvdimm_kobj(nvdimm)->sd, "nfit");
+		if (nfit_kernfs)
+			nfit_mem->flags_attr = sysfs_get_dirent(nfit_kernfs,
+					"flags");
+		sysfs_put(nfit_kernfs);
+		if (!nfit_mem->flags_attr)
+			dev_warn(acpi_desc->dev, "%s: notifications disabled\n",
+					nvdimm_name(nvdimm));
+	}
+	return 0;
 }
 
 static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
@@ -2400,6 +2464,7 @@ static int acpi_nfit_desc_init_scrub_attr(struct acpi_nfit_desc *acpi_desc)
 
 static void acpi_nfit_destruct(void *data)
 {
+	struct nfit_mem *nfit_mem;
 	struct acpi_nfit_desc *acpi_desc = data;
 	struct device *bus_dev = to_nvdimm_bus_dev(acpi_desc->nvdimm_bus);
 
@@ -2415,6 +2480,16 @@ static void acpi_nfit_destruct(void *data)
 	 * either submit or see ->cancel set.
 	 */
 	device_lock(bus_dev);
+	/*
+	 * Clear out the nfit_mem->flags_attr and shut down dimm event
+	 * notifications.
+	 */
+	list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
+		sysfs_put(nfit_mem->flags_attr);
+		nfit_mem->flags_attr = NULL;
+		acpi_remove_notify_handler(nfit_mem->adev->handle,
+				ACPI_DEVICE_NOTIFY, acpi_nvdimm_notify);
+	}
 	device_unlock(bus_dev);
 
 	flush_workqueue(nfit_wq);
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 52370347fb0e..13195824778c 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -82,6 +82,10 @@ enum nfit_root_notifiers {
 	NFIT_NOTIFY_UPDATE = 0x80,
 };
 
+enum nfit_dimm_notifiers {
+	NFIT_NOTIFY_DIMM_HEALTH = 0x81,
+};
+
 struct nfit_spa {
 	struct list_head list;
 	struct nd_region *nd_region;
@@ -128,6 +132,7 @@ struct nfit_mem {
 	struct acpi_nfit_system_address *spa_bdw;
 	struct acpi_nfit_interleave *idt_dcr;
 	struct acpi_nfit_interleave *idt_bdw;
+	struct kernfs_node *flags_attr;
 	struct nfit_flush *nfit_flush;
 	struct list_head list;
 	struct acpi_device *adev;
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index d9bba5edd8dc..ce75cc3f41fb 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -263,6 +263,12 @@ const char *nvdimm_name(struct nvdimm *nvdimm)
 }
 EXPORT_SYMBOL_GPL(nvdimm_name);
 
+struct kobject *nvdimm_kobj(struct nvdimm *nvdimm)
+{
+	return &nvdimm->dev.kobj;
+}
+EXPORT_SYMBOL_GPL(nvdimm_kobj);
+
 unsigned long nvdimm_cmd_mask(struct nvdimm *nvdimm)
 {
 	return nvdimm->cmd_mask;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index b519e137b9b7..ad18d0531b6e 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -139,6 +139,7 @@ struct nd_blk_region *to_nd_blk_region(struct device *dev);
 struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus);
 struct device *to_nvdimm_bus_dev(struct nvdimm_bus *nvdimm_bus);
 const char *nvdimm_name(struct nvdimm *nvdimm);
+struct kobject *nvdimm_kobj(struct nvdimm *nvdimm);
 unsigned long nvdimm_cmd_mask(struct nvdimm *nvdimm);
 void *nvdimm_provider_data(struct nvdimm *nvdimm);
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
