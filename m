Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00EA421967BEB
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 11:36:19 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 2/2] acpi/nfit: Issue Start ARS to retrieve existing records
Date: Thu,  8 Jun 2017 12:36:58 -0600
Message-Id: <20170608183658.24731-3-toshi.kani@hpe.com>
In-Reply-To: <20170608183658.24731-1-toshi.kani@hpe.com>
References: <20170608183658.24731-1-toshi.kani@hpe.com>
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
 drivers/acpi/nfit/core.c   |   14 +++++++++++---
 drivers/acpi/nfit/mce.c    |    2 +-
 drivers/acpi/nfit/nfit.h   |    3 ++-
 include/uapi/linux/ndctl.h |    1 +
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index cc22778..d820d72 100644
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
@@ -2057,6 +2057,10 @@ static int ars_start(struct acpi_nfit_desc *acpi_desc, struct nfit_spa *nfit_spa
 		ars_start.type = ND_ARS_VOLATILE;
 	else
 		return -ENOTTY;
+	if (nfit_spa->ars_prev_data) {
+		ars_start.flags |= ND_ARS_RETURN_PREV_DATA;
+		nfit_spa->ars_prev_data = 0;
+	}
 
 	rc = nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_START, &ars_start,
 			sizeof(ars_start), &cmd_rc);
@@ -2817,7 +2821,7 @@ static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
 	return 0;
 }
 
-int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc)
+int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc, int flags)
 {
 	struct device *dev = acpi_desc->dev;
 	struct nfit_spa *nfit_spa;
@@ -2838,6 +2842,8 @@ int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc)
 			continue;
 
 		nfit_spa->ars_required = 1;
+		if (flags & ND_ARS_RETURN_PREV_DATA)
+			nfit_spa->ars_prev_data = 1;
 	}
 	queue_work(nfit_wq, &acpi_desc->work);
 	dev_dbg(dev, "%s: ars_scan triggered\n", __func__);
@@ -3015,8 +3021,10 @@ static void acpi_nfit_update_notify(struct device *dev, acpi_handle handle)
 static void acpi_nfit_uc_error_notify(struct device *dev, acpi_handle handle)
 {
 	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(dev);
+	int flags = (acpi_desc->scrub_mode == HW_ERROR_SCRUB_ON) ?
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
index 6cf9d21..a6f8833 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -91,6 +91,7 @@ struct nfit_spa {
 	struct list_head list;
 	struct nd_region *nd_region;
 	unsigned int ars_required:1;
+	unsigned int ars_prev_data:1;
 	u32 clear_err_unit;
 	u32 max_ars;
 	struct acpi_nfit_system_address spa[0];
@@ -208,7 +209,7 @@ struct nfit_blk {
 
 extern struct list_head acpi_descs;
 extern struct mutex acpi_desc_lock;
-int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc);
+int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc, int flags);
 
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
