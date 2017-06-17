Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6705921A07AA4
 for <linux-nvdimm@lists.01.org>; Sat, 17 Jun 2017 01:21:37 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3] acpi/nfit: Issue Start ARS to retrieve existing records
Date: Sat, 17 Jun 2017 02:22:18 -0600
Message-Id: <20170617082218.8955-1-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.2 defines in section 9.20.7.2 that the OSPM may call a Start
ARS with Flags Bit [1] set upon receiving the 0x81 notification.

  Upon receiving the notification, the OSPM may decide to issue
  a Start ARS with Flags Bit [1] set to prepare for the retrieval
  of existing records and issue the Query ARS Status function to
  retrieve the records.

Add support to call a Start ARS from acpi_nfit_uc_error_notify()
with ND_ARS_RETURN_PREV_DATA set when HW_ERROR_SCRUB_ON is not set.

Link: http://www.uefi.org/sites/default/files/resources/ACPI_6_2.pdf
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linda Knippers <linda.knippers@hpe.com>
---
v3 (2/2): Add flags info to acpi_nfit_desc (Dan Williams)
---
 drivers/acpi/nfit/core.c   |   11 ++++++++---
 drivers/acpi/nfit/mce.c    |    2 +-
 drivers/acpi/nfit/nfit.h   |    3 ++-
 include/uapi/linux/ndctl.h |    1 +
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index cc22778..7e08ee0 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1031,7 +1031,7 @@ static ssize_t scrub_store(struct device *dev,
 	if (nd_desc) {
 		struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
 
-		rc = acpi_nfit_ars_rescan(acpi_desc);
+		rc = acpi_nfit_ars_rescan(acpi_desc, 0);
 	}
 	device_unlock(dev);
 	if (rc)
@@ -2051,6 +2051,7 @@ static int ars_start(struct acpi_nfit_desc *acpi_desc, struct nfit_spa *nfit_spa
 	memset(&ars_start, 0, sizeof(ars_start));
 	ars_start.address = spa->address;
 	ars_start.length = spa->length;
+	ars_start.flags = acpi_desc->ars_start_flags;
 	if (nfit_spa_type(spa) == NFIT_SPA_PM)
 		ars_start.type = ND_ARS_PERSISTENT;
 	else if (nfit_spa_type(spa) == NFIT_SPA_VOLATILE)
@@ -2613,6 +2614,7 @@ static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
 				return rc;
 		}
 
+	acpi_desc->ars_start_flags = 0;
 	if (!acpi_desc->cancel)
 		queue_work(nfit_wq, &acpi_desc->work);
 	return 0;
@@ -2817,7 +2819,7 @@ static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
 	return 0;
 }
 
-int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc)
+int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc, u8 flags)
 {
 	struct device *dev = acpi_desc->dev;
 	struct nfit_spa *nfit_spa;
@@ -2839,6 +2841,7 @@ int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc)
 
 		nfit_spa->ars_required = 1;
 	}
+	acpi_desc->ars_start_flags = flags;
 	queue_work(nfit_wq, &acpi_desc->work);
 	dev_dbg(dev, "%s: ars_scan triggered\n", __func__);
 	mutex_unlock(&acpi_desc->init_mutex);
@@ -3015,8 +3018,10 @@ static void acpi_nfit_update_notify(struct device *dev, acpi_handle handle)
 static void acpi_nfit_uc_error_notify(struct device *dev, acpi_handle handle)
 {
 	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(dev);
+	u8 flags = (acpi_desc->scrub_mode == HW_ERROR_SCRUB_ON) ?
+			0 : ND_ARS_RETURN_PREV_DATA;
 
-	acpi_nfit_ars_rescan(acpi_desc);
+	acpi_nfit_ars_rescan(acpi_desc, flags);
 }
 
 void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event)
diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
index fd86bec..feeb95d 100644
--- a/drivers/acpi/nfit/mce.c
+++ b/drivers/acpi/nfit/mce.c
@@ -79,7 +79,7 @@ static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
 			 * already in progress, just let that be the last
 			 * authoritative one
 			 */
-			acpi_nfit_ars_rescan(acpi_desc);
+			acpi_nfit_ars_rescan(acpi_desc, 0);
 		}
 		break;
 	}
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 6cf9d21..d98f0db 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -156,6 +156,7 @@ struct acpi_nfit_desc {
 	struct list_head idts;
 	struct nvdimm_bus *nvdimm_bus;
 	struct device *dev;
+	u8 ars_start_flags;
 	struct nd_cmd_ars_status *ars_status;
 	size_t ars_status_size;
 	struct work_struct work;
@@ -208,7 +209,7 @@ struct nfit_blk {
 
 extern struct list_head acpi_descs;
 extern struct mutex acpi_desc_lock;
-int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc);
+int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc, u8 flags);
 
 #ifdef CONFIG_X86_MCE
 void nfit_mce_register(void);
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 7ad3863..70a89f7 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -169,6 +169,7 @@ enum {
 enum {
 	ND_ARS_VOLATILE = 1,
 	ND_ARS_PERSISTENT = 2,
+	ND_ARS_RETURN_PREV_DATA = 1 << 1,
 	ND_CONFIG_LOCKED = 1,
 };
 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
