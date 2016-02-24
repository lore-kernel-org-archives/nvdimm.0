Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 5/8] nfit, libnvdimm: async region scrub workqueue
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Feb 2016 18:17:24 -0800
Message-ID: <20160224021724.22776.70050.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160224021655.22776.87952.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160224021655.22776.87952.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Introduce a workqueue that will be used to run address range scrub
asynchronously with the rest of nvdimm device probing.

Userspace still wants notification when probing operations complete, so
introduce a new callback to flush this workqueue when userspace is
awaiting probe completion.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c       |   49 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit.h       |    3 +++
 drivers/nvdimm/core.c     |    9 ++++++++
 include/linux/libnvdimm.h |    1 +
 4 files changed, 62 insertions(+)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 76c9444c9c60..4aa2bd54fc1d 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -34,6 +34,8 @@ static bool force_enable_dimms;
 module_param(force_enable_dimms, bool, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(force_enable_dimms, "Ignore _STA (ACPI DIMM device) status");
 
+static struct workqueue_struct *nfit_wq;
+
 struct nfit_table_prev {
 	struct list_head spas;
 	struct list_head memdevs;
@@ -1961,6 +1963,39 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 }
 EXPORT_SYMBOL_GPL(acpi_nfit_init);
 
+struct acpi_nfit_flush_work {
+	struct work_struct work;
+	struct completion cmp;
+};
+
+static void flush_probe(struct work_struct *work)
+{
+	struct acpi_nfit_flush_work *flush;
+
+	flush = container_of(work, typeof(*flush), work);
+	complete(&flush->cmp);
+}
+
+static int acpi_nfit_flush_probe(struct nvdimm_bus_descriptor *nd_desc)
+{
+	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
+	struct device *dev = acpi_desc->dev;
+	struct acpi_nfit_flush_work flush;
+
+	/* bounce the device lock to flush acpi_nfit_add / acpi_nfit_notify */
+	device_lock(dev);
+	device_unlock(dev);
+
+	/*
+	 * Scrub work could take 10s of seconds, userspace may give up so we
+	 * need to be interruptible while waiting.
+	 */
+	INIT_WORK_ONSTACK(&flush.work, flush_probe);
+	COMPLETION_INITIALIZER_ONSTACK(flush.cmp);
+	queue_work(nfit_wq, &flush.work);
+	return wait_for_completion_interruptible(&flush.cmp);
+}
+
 void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
 {
 	struct nvdimm_bus_descriptor *nd_desc;
@@ -1971,6 +2006,7 @@ void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
 	nd_desc = &acpi_desc->nd_desc;
 	nd_desc->provider_name = "ACPI.NFIT";
 	nd_desc->ndctl = acpi_nfit_ctl;
+	nd_desc->flush_probe = acpi_nfit_flush_probe;
 	nd_desc->attr_groups = acpi_nfit_attribute_groups;
 
 	INIT_LIST_HEAD(&acpi_desc->spa_maps);
@@ -2048,6 +2084,8 @@ static int acpi_nfit_remove(struct acpi_device *adev)
 {
 	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(&adev->dev);
 
+	acpi_desc->cancel = 1;
+	flush_workqueue(nfit_wq);
 	nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
 	return 0;
 }
@@ -2079,6 +2117,12 @@ static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
 		acpi_desc->nvdimm_bus = nvdimm_bus_register(dev, &acpi_desc->nd_desc);
 		if (!acpi_desc->nvdimm_bus)
 			goto out_unlock;
+	} else {
+		/*
+		 * Finish previous registration before considering new
+		 * regions.
+		 */
+		flush_workqueue(nfit_wq);
 	}
 
 	/* Evaluate _FIT */
@@ -2146,12 +2190,17 @@ static __init int nfit_init(void)
 	acpi_str_to_uuid(UUID_NFIT_BUS, nfit_uuid[NFIT_DEV_BUS]);
 	acpi_str_to_uuid(UUID_NFIT_DIMM, nfit_uuid[NFIT_DEV_DIMM]);
 
+	nfit_wq = create_singlethread_workqueue("nfit");
+	if (!nfit_wq)
+		return -ENOMEM;
+
 	return acpi_bus_register_driver(&acpi_nfit_driver);
 }
 
 static __exit void nfit_exit(void)
 {
 	acpi_bus_unregister_driver(&acpi_nfit_driver);
+	destroy_workqueue(nfit_wq);
 }
 
 module_init(nfit_init);
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 524dec0a3adb..e8388fee4cc6 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -14,6 +14,7 @@
  */
 #ifndef __NFIT_H__
 #define __NFIT_H__
+#include <linux/workqueue.h>
 #include <linux/libnvdimm.h>
 #include <linux/types.h>
 #include <linux/uuid.h>
@@ -123,6 +124,8 @@ struct acpi_nfit_desc {
 	struct list_head idts;
 	struct nvdimm_bus *nvdimm_bus;
 	struct device *dev;
+	struct work_struct work;
+	unsigned int cancel:1;
 	unsigned long dimm_dsm_force_en;
 	unsigned long bus_dsm_force_en;
 	int (*blk_do_io)(struct nd_blk_region *ndbr, resource_size_t dpa,
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index f309e6bf6833..79646d0c3277 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -298,6 +298,15 @@ static int flush_regions_dimms(struct device *dev, void *data)
 static ssize_t wait_probe_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
+	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
+	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
+	int rc;
+
+	if (nd_desc->flush_probe) {
+		rc = nd_desc->flush_probe(nd_desc);
+		if (rc)
+			return rc;
+	}
 	nd_synchronize();
 	device_for_each_child(dev, NULL, flush_regions_dimms);
 	return sprintf(buf, "1\n");
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index f398953270d1..2299f8742f7f 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -71,6 +71,7 @@ struct nvdimm_bus_descriptor {
 	unsigned long dsm_mask;
 	char *provider_name;
 	ndctl_fn ndctl;
+	int (*flush_probe)(struct nvdimm_bus_descriptor *nd_desc);
 };
 
 struct nd_cmd_desc {
