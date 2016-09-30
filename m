Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2AF141A1DEF
 for <linux-nvdimm@lists.01.org>; Fri, 30 Sep 2016 13:10:54 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 1/3] nfit: don't start a full scrub by default for an MCE
Date: Fri, 30 Sep 2016 14:10:01 -0600
Message-Id: <1475266203-18559-2-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1475266203-18559-1-git-send-email-vishal.l.verma@intel.com>
References: <1475266203-18559-1-git-send-email-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Starting a full Address Range Scrub (ARS) on hitting a memory error
machine check exception may not always be desirable. Provide a way
through sysfs to toggle the behavior between just adding the address
(cache line) where the MCE happened to the poison list and doing a full
scrub. The former (selective insertion of the address) is done
unconditionally.

Cc: linux-acpi@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Linda Knippers <linda.knippers@hpe.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/acpi/nfit/core.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit/mce.c  | 24 ++++++++++++++++-----
 drivers/acpi/nfit/nfit.h |  6 ++++++
 3 files changed, 79 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 80cc7c0..6a12bc2 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -878,6 +878,58 @@ static ssize_t revision_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(revision);
 
+static ssize_t hw_error_scrub_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
+
+	return sprintf(buf, "%d\n", acpi_desc->scrub_mode);
+}
+
+/*
+ * The 'hw_error_scrub' attribute can have the following values written to it:
+ * '1': Enable a full scrub to happen if an exception for a memory error is
+ *      received.
+ * '2': Switch to the default mode where an exception will only insert
+ *      the address of the memory error into the poison and badblocks lists.
+ */
+static ssize_t hw_error_scrub_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct nvdimm_bus_descriptor *nd_desc;
+	ssize_t rc;
+	long val;
+
+	rc = kstrtol(buf, 0, &val);
+	if (rc)
+		return rc;
+
+	device_lock(dev);
+	nd_desc = dev_get_drvdata(dev);
+	if (nd_desc) {
+		struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
+
+		switch (val) {
+		case MCE_SCRUB_ON:
+			acpi_desc->scrub_mode = MCE_SCRUB_ON;
+			break;
+		case MCE_SCRUB_OFF:
+			acpi_desc->scrub_mode = MCE_SCRUB_OFF;
+			break;
+		default:
+			rc = -EINVAL;
+			break;
+		}
+	}
+	device_unlock(dev);
+	if (rc)
+		return rc;
+	return size;
+}
+static DEVICE_ATTR_RW(hw_error_scrub);
+
 /*
  * This shows the number of full Address Range Scrubs that have been
  * completed since driver load time. Userspace can wait on this using
@@ -950,6 +1002,7 @@ static umode_t nfit_visible(struct kobject *kobj, struct attribute *a, int n)
 static struct attribute *acpi_nfit_attributes[] = {
 	&dev_attr_revision.attr,
 	&dev_attr_scrub.attr,
+	&dev_attr_hw_error_scrub.attr,
 	NULL,
 };
 
@@ -2489,6 +2542,7 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
 		goto out_unlock;
 	}
 
+	acpi_desc->scrub_mode = MCE_SCRUB_OFF;
 	rc = acpi_nfit_check_deletions(acpi_desc, &prev);
 	if (rc)
 		goto out_unlock;
diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
index 161f915..05005e2 100644
--- a/drivers/acpi/nfit/mce.c
+++ b/drivers/acpi/nfit/mce.c
@@ -14,6 +14,7 @@
  */
 #include <linux/notifier.h>
 #include <linux/acpi.h>
+#include <linux/nd.h>
 #include <asm/mce.h>
 #include "nfit.h"
 
@@ -62,12 +63,25 @@ static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
 		}
 		mutex_unlock(&acpi_desc->init_mutex);
 
-		/*
-		 * We can ignore an -EBUSY here because if an ARS is already
-		 * in progress, just let that be the last authoritative one
-		 */
-		if (found_match)
+		if (!found_match)
+			continue;
+
+		/* If this fails due to an -ENOMEM, there is little we can do */
+		nvdimm_bus_add_poison(acpi_desc->nvdimm_bus,
+				ALIGN(mce->addr, L1_CACHE_BYTES),
+				L1_CACHE_BYTES);
+		nvdimm_region_notify(nfit_spa->nd_region,
+				NVDIMM_REVALIDATE_POISON);
+
+		if (acpi_desc->scrub_mode == MCE_SCRUB_ON) {
+			/*
+			 * We can ignore an -EBUSY here because if an ARS is
+			 * already in progress, just let that be the last
+			 * authoritative one
+			 */
 			acpi_nfit_ars_rescan(acpi_desc);
+		}
+		break;
 	}
 
 	mutex_unlock(&acpi_desc_lock);
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index e894ded..487dc0a 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -152,6 +152,7 @@ struct acpi_nfit_desc {
 	struct list_head list;
 	struct kernfs_node *scrub_count_state;
 	unsigned int scrub_count;
+	unsigned int scrub_mode;
 	unsigned int cancel:1;
 	unsigned long dimm_cmd_force_en;
 	unsigned long bus_cmd_force_en;
@@ -159,6 +160,11 @@ struct acpi_nfit_desc {
 			void *iobuf, u64 len, int rw);
 };
 
+enum scrub_mode {
+	MCE_SCRUB_ON = 1,
+	MCE_SCRUB_OFF = 2,
+};
+
 enum nd_blk_mmio_selector {
 	BDW,
 	DCR,
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
