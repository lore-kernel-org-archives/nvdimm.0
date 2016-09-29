Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 03D691A1E3D
 for <linux-nvdimm@lists.01.org>; Wed, 28 Sep 2016 17:11:01 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 1/3] nfit: don't start a full scrub by default for an MCE
Date: Wed, 28 Sep 2016 18:10:09 -0600
Message-Id: <1475107811-8880-2-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1475107811-8880-1-git-send-email-vishal.l.verma@intel.com>
References: <1475107811-8880-1-git-send-email-vishal.l.verma@intel.com>
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
 drivers/acpi/nfit/core.c | 23 ++++++++++++++++++++---
 drivers/acpi/nfit/mce.c  | 24 +++++++++++++++++++-----
 drivers/acpi/nfit/nfit.h |  6 ++++++
 3 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 80cc7c0..ec1069e 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -901,6 +901,14 @@ static ssize_t scrub_show(struct device *dev,
 	return rc;
 }
 
+/*
+ * The 'scrub' attribute can only have following values written to it:
+ * '1': Start an on-demand scrub, and enable a full scrub to happen if a
+ *      machine check exception for a memory error is received.
+ * '2': Switch to the default mode where a machine check will only insert
+ *      the address on which the memory error was received into the poison
+ *      and badblocks lists.
+ */
 static ssize_t scrub_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
@@ -911,15 +919,24 @@ static ssize_t scrub_store(struct device *dev,
 	rc = kstrtol(buf, 0, &val);
 	if (rc)
 		return rc;
-	if (val != 1)
-		return -EINVAL;
 
 	device_lock(dev);
 	nd_desc = dev_get_drvdata(dev);
 	if (nd_desc) {
 		struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
 
-		rc = acpi_nfit_ars_rescan(acpi_desc);
+		switch (val) {
+		case MCE_SCRUB_ON:
+			rc = acpi_nfit_ars_rescan(acpi_desc);
+			acpi_desc->scrub_mode = MCE_SCRUB_ON;
+			break;
+		case MCE_SCRUB_OFF:
+			acpi_desc->scrub_mode = MCE_SCRUB_OFF;
+			break;
+		default:
+			rc = -EINVAL;
+			break;
+		}
 	}
 	device_unlock(dev);
 	if (rc)
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
