Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 255911A1E05
 for <linux-nvdimm@lists.01.org>; Sat, 23 Jul 2016 22:29:18 -0700 (PDT)
Subject: [PATCH v4 4/4] nfit: do an ARS scrub on hitting a latent media error
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Jul 2016 22:26:54 -0700
Message-ID: <146933801396.26196.11174859237975758395.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Tony Luck <tony.luck@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Vishal Verma <vishal.l.verma@intel.com>

When a latent (unknown to 'badblocks') error is encountered, it will
trigger a machine check exception. On a system with machine check
recovery, this will only SIGBUS the process(es) which had the bad page
mapped (as opposed to a kernel panic on platforms without machine
check recovery features). In the former case, we want to trigger a full
rescan of that nvdimm bus. This will allow any additional, new errors
to be captured in the block devices' badblocks lists, and offending
operations on them can be trapped early, avoiding machine checks.

This is done by registering a callback function with the
x86_mce_decoder_chain and calling the new ars_rescan functionality with
the address in the mce notificatiion.

Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/Makefile  |    1 
 drivers/acpi/nfit/core.c    |   26 +++++++++++--
 drivers/acpi/nfit/mce.c     |   89 +++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit/nfit.h    |   20 ++++++++++
 tools/testing/nvdimm/Kbuild |    1 
 5 files changed, 133 insertions(+), 4 deletions(-)
 create mode 100644 drivers/acpi/nfit/mce.c

diff --git a/drivers/acpi/nfit/Makefile b/drivers/acpi/nfit/Makefile
index eb95c5aff83b..a407e769f103 100644
--- a/drivers/acpi/nfit/Makefile
+++ b/drivers/acpi/nfit/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_ACPI_NFIT) := nfit.o
 nfit-y := core.o
+nfit-$(CONFIG_X86_MCE) += mce.o
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 2eaa03dc185a..686837e8358f 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -51,6 +51,9 @@ module_param(disable_vendor_specific, bool, S_IRUGO);
 MODULE_PARM_DESC(disable_vendor_specific,
 		"Limit commands to the publicly specified set\n");
 
+LIST_HEAD(acpi_descs);
+DEFINE_MUTEX(acpi_desc_lock);
+
 static struct workqueue_struct *nfit_wq;
 
 struct nfit_table_prev {
@@ -361,7 +364,7 @@ static const char *spa_type_name(u16 type)
 	return to_name[type];
 }
 
-static int nfit_spa_type(struct acpi_nfit_system_address *spa)
+int nfit_spa_type(struct acpi_nfit_system_address *spa)
 {
 	int i;
 
@@ -898,8 +901,6 @@ static ssize_t scrub_show(struct device *dev,
 	return rc;
 }
 
-static int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc);
-
 static ssize_t scrub_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
@@ -2400,6 +2401,11 @@ static void acpi_nfit_destruct(void *data)
 	struct acpi_nfit_desc *acpi_desc = data;
 	struct device *bus_dev = to_nvdimm_bus_dev(acpi_desc->nvdimm_bus);
 
+	/*
+	 * Destruct under acpi_desc_lock so that nfit_handle_mce does not
+	 * race teardown
+	 */
+	mutex_lock(&acpi_desc_lock);
 	acpi_desc->cancel = 1;
 	/*
 	 * Bounce the nvdimm bus lock to make sure any in-flight
@@ -2414,6 +2420,8 @@ static void acpi_nfit_destruct(void *data)
 		sysfs_put(acpi_desc->scrub_count_state);
 	nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
 	acpi_desc->nvdimm_bus = NULL;
+	list_del(&acpi_desc->list);
+	mutex_unlock(&acpi_desc_lock);
 }
 
 int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
@@ -2441,6 +2449,11 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
 		rc = acpi_nfit_desc_init_scrub_attr(acpi_desc);
 		if (rc)
 			return rc;
+
+		/* register this acpi_desc for mce notifications */
+		mutex_lock(&acpi_desc_lock);
+		list_add_tail(&acpi_desc->list, &acpi_descs);
+		mutex_unlock(&acpi_desc_lock);
 	}
 
 	rc = acpi_nfit_desc_init_scrub_attr(acpi_desc);
@@ -2555,7 +2568,7 @@ static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
 	return 0;
 }
 
-static int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc)
+int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc)
 {
 	struct device *dev = acpi_desc->dev;
 	struct nfit_spa *nfit_spa;
@@ -2604,6 +2617,7 @@ void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
 	INIT_LIST_HEAD(&acpi_desc->flushes);
 	INIT_LIST_HEAD(&acpi_desc->memdevs);
 	INIT_LIST_HEAD(&acpi_desc->dimms);
+	INIT_LIST_HEAD(&acpi_desc->list);
 	mutex_init(&acpi_desc->init_mutex);
 	INIT_WORK(&acpi_desc->work, acpi_nfit_scrub);
 }
@@ -2756,13 +2770,17 @@ static __init int nfit_init(void)
 	if (!nfit_wq)
 		return -ENOMEM;
 
+	nfit_mce_register();
+
 	return acpi_bus_register_driver(&acpi_nfit_driver);
 }
 
 static __exit void nfit_exit(void)
 {
+	nfit_mce_unregister();
 	acpi_bus_unregister_driver(&acpi_nfit_driver);
 	destroy_workqueue(nfit_wq);
+	WARN_ON(!list_empty(&acpi_descs));
 }
 
 module_init(nfit_init);
diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
new file mode 100644
index 000000000000..4c745bf389fe
--- /dev/null
+++ b/drivers/acpi/nfit/mce.c
@@ -0,0 +1,89 @@
+/*
+ * NFIT - Machine Check Handler
+ *
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
+#include <linux/notifier.h>
+#include <linux/acpi.h>
+#include <asm/mce.h>
+#include "nfit.h"
+
+static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
+			void *data)
+{
+	struct mce *mce = (struct mce *)data;
+	struct acpi_nfit_desc *acpi_desc;
+	struct nfit_spa *nfit_spa;
+
+	/* We only care about memory errors */
+	if (!(mce->status & MCACOD))
+		return NOTIFY_DONE;
+
+	/*
+	 * mce->addr contains the physical addr accessed that caused the
+	 * machine check. We need to walk through the list of NFITs, and see
+	 * if any of them matches that address, and only then start a scrub.
+	 */
+	mutex_lock(&acpi_desc_lock);
+	list_for_each_entry(acpi_desc, &acpi_descs, list) {
+		struct device *dev = acpi_desc->dev;
+		int found_match = 0;
+
+		mutex_lock(&acpi_desc->init_mutex);
+		list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
+			struct acpi_nfit_system_address *spa = nfit_spa->spa;
+
+			if (nfit_spa_type(spa) == NFIT_SPA_PM)
+				continue;
+			/* find the spa that covers the mce addr */
+			if (spa->address > mce->addr)
+				continue;
+			if ((spa->address + spa->length - 1) < mce->addr)
+				continue;
+			found_match = 1;
+			dev_dbg(dev, "%s: addr in SPA %d (0x%llx, 0x%llx)\n",
+				__func__, spa->range_index, spa->address,
+				spa->length);
+			/*
+			 * We can break at the first match because we're going
+			 * to rescan all the SPA ranges. There shouldn't be any
+			 * aliasing anyway.
+			 */
+			break;
+		}
+		mutex_unlock(&acpi_desc->init_mutex);
+
+		/*
+		 * We can ignore an -EBUSY here because if an ARS is already
+		 * in progress, just let that be the last authoritative one
+		 */
+		if (found_match)
+			acpi_nfit_ars_rescan(acpi_desc);
+	}
+
+	mutex_unlock(&acpi_desc_lock);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block nfit_mce_dec = {
+	.notifier_call	= nfit_handle_mce,
+};
+
+void nfit_mce_register(void)
+{
+	mce_register_decode_chain(&nfit_mce_dec);
+}
+
+void nfit_mce_unregister(void)
+{
+	mce_unregister_decode_chain(&nfit_mce_dec);
+}
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 6ecf337c97aa..ba6074a06958 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -16,6 +16,7 @@
 #define __NFIT_H__
 #include <linux/workqueue.h>
 #include <linux/libnvdimm.h>
+#include <linux/ndctl.h>
 #include <linux/types.h>
 #include <linux/uuid.h>
 #include <linux/acpi.h>
@@ -148,6 +149,7 @@ struct acpi_nfit_desc {
 	struct nd_cmd_ars_status *ars_status;
 	size_t ars_status_size;
 	struct work_struct work;
+	struct list_head list;
 	struct kernfs_node *scrub_count_state;
 	unsigned int scrub_count;
 	unsigned int cancel:1;
@@ -187,6 +189,24 @@ struct nfit_blk {
 	u32 dimm_flags;
 };
 
+extern struct list_head acpi_descs;
+extern struct mutex acpi_desc_lock;
+int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc);
+
+#ifdef CONFIG_X86_MCE
+void nfit_mce_register(void);
+void nfit_mce_unregister(void);
+#else
+static inline void nfit_mce_register(void)
+{
+}
+static inline void nfit_mce_unregister(void)
+{
+}
+#endif
+
+int nfit_spa_type(struct acpi_nfit_system_address *spa);
+
 static inline struct acpi_nfit_memory_map *__to_nfit_memdev(
 		struct nfit_mem *nfit_mem)
 {
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 0dca8ff7557b..ad6dd0543019 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -30,6 +30,7 @@ obj-$(CONFIG_DEV_DAX) += dax.o
 obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
 
 nfit-y := $(ACPI_SRC)/core.o
+nfit-$(CONFIG_X86_MCE) += $(ACPI_SRC)/mce.o
 nfit-y += config_check.o
 
 nd_pmem-y := $(NVDIMM_SRC)/pmem.o

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
