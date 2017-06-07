Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5161B21AE30D1
 for <linux-nvdimm@lists.01.org>; Wed,  7 Jun 2017 11:49:07 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH] Add support of NVDIMM memory error notification in ACPI 6.2
Date: Wed,  7 Jun 2017 12:49:47 -0600
Message-Id: <20170607184947.18733-1-toshi.kani@hpe.com>
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

ACPI 6.2 defines a new ACPI notification value to NVDIMM Root Device
in Table 5-169.

 0x81 Unconsumed Uncorrectable Memory Error Detected
      Used to pro-actively notify OSPM of uncorrectable memory errors
      detected (for example a memory scrubbing engine that continuously
      scans the NVDIMMs memory). This is an optional notification. Only
      locations that were mapped in to SPA by the platform will generate
      a notification.

Add support of this notification value by initiating an ARS scan. This
will find new error locations and add their badblocks information.

Link: http://www.uefi.org/sites/default/files/resources/ACPI_6_2.pdf
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/acpi/nfit/core.c |   28 ++++++++++++++++++++++------
 drivers/acpi/nfit/nfit.h |    1 +
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 656acb5..cc22778 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2967,7 +2967,7 @@ static int acpi_nfit_remove(struct acpi_device *adev)
 	return 0;
 }
 
-void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event)
+static void acpi_nfit_update_notify(struct device *dev, acpi_handle handle)
 {
 	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(dev);
 	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
@@ -2975,11 +2975,6 @@ void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event)
 	acpi_status status;
 	int ret;
 
-	dev_dbg(dev, "%s: event: %d\n", __func__, event);
-
-	if (event != NFIT_NOTIFY_UPDATE)
-		return;
-
 	if (!dev->driver) {
 		/* dev->driver may be null if we're being removed */
 		dev_dbg(dev, "%s: no driver found for dev\n", __func__);
@@ -3016,6 +3011,27 @@ void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event)
 		dev_err(dev, "Invalid _FIT\n");
 	kfree(buf.pointer);
 }
+
+static void acpi_nfit_uc_error_notify(struct device *dev, acpi_handle handle)
+{
+	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(dev);
+
+	acpi_nfit_ars_rescan(acpi_desc);
+}
+
+void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event)
+{
+	dev_dbg(dev, "%s: event: 0x%x\n", __func__, event);
+
+	switch (event) {
+	case NFIT_NOTIFY_UPDATE:
+		return acpi_nfit_update_notify(dev, handle);
+	case NFIT_NOTIFY_UC_MEMORY_ERROR:
+		return acpi_nfit_uc_error_notify(dev, handle);
+	default:
+		return;
+	}
+}
 EXPORT_SYMBOL_GPL(__acpi_nfit_notify);
 
 static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 58fb7d6..6cf9d21 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -80,6 +80,7 @@ enum {
 
 enum nfit_root_notifiers {
 	NFIT_NOTIFY_UPDATE = 0x80,
+	NFIT_NOTIFY_UC_MEMORY_ERROR = 0x81,
 };
 
 enum nfit_dimm_notifiers {
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
