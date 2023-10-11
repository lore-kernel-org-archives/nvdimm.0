Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B264199CD
	for <nvdimm@lists.linux.dev>; Wed, 11 Oct 2023 08:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LZpkix2j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697013255; x=1728549255;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KeBW7OgXXmtrM6WG1jnUdssaNB2R2i0a8/3uS3pL1AU=;
  b=LZpkix2jlDW3Xw0LjB9jvU8dxRfJ24qRc46U1OcTFOCyyuucY+Trz2gu
   4SjdAIrz0lPRg7xab/3H9XUHyxH3G7Ws23pqfJVmAHKGe6xvP6zw9BG68
   u6JRw8tHY7f+MCTcQ5gqmjLRnt3R3/wpv3Yq7/8HeG89bOyjdSisRB8ds
   KgrXMcAQZjsPLRb9KYs28oixvsxn95UBl+AE+d1qMxA6Y680oMx+K2P1P
   WXw3vy9Y3+AeT5HqmLrUxi07tuRRaMNTuLGRRSAv7ToEPNYBkIo8F3eqP
   Nmrz76osH/iMbhBpOUiFMdqo977RF28rQmJcG2TTxzKEAx6avE1rwztCm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10859"; a="388480264"
X-IronPort-AV: E=Sophos;i="6.03,214,1694761200"; 
   d="scan'208";a="388480264"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 01:34:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10859"; a="897548222"
X-IronPort-AV: E=Sophos;i="6.03,214,1694761200"; 
   d="scan'208";a="897548222"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 01:32:26 -0700
From: Michal Wilczynski <michal.wilczynski@intel.com>
To: linux-acpi@vger.kernel.org
Cc: rafael@kernel.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	lenb@kernel.org,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	rui.zhang@intel.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v3 5/6] ACPI: NFIT: Replace acpi_driver with platform_driver
Date: Wed, 11 Oct 2023 11:33:33 +0300
Message-ID: <20231011083334.3987477-6-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231011083334.3987477-1-michal.wilczynski@intel.com>
References: <20231011083334.3987477-1-michal.wilczynski@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NFIT driver uses struct acpi_driver incorrectly to register itself.
This is wrong as the instances of the ACPI devices are not meant
to be literal devices, they're supposed to describe ACPI entry of a
particular device.

Use platform_driver instead of acpi_driver. In relevant places call
platform devices instances pdev to make a distinction with ACPI
devices instances.

NFIT driver uses devm_*() family of functions extensively. This change
has no impact on correct functioning of the whole devm_*() family of
functions, since the lifecycle of the device stays the same. It is still
being created during the enumeration, and destroyed on platform device
removal.

Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/nfit/core.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 3826f49d481b..6b9d10cae92c 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -15,6 +15,7 @@
 #include <linux/sort.h>
 #include <linux/io.h>
 #include <linux/nd.h>
+#include <linux/platform_device.h>
 #include <asm/cacheflush.h>
 #include <acpi/nfit.h>
 #include "intel.h"
@@ -98,7 +99,7 @@ static struct acpi_device *to_acpi_dev(struct acpi_nfit_desc *acpi_desc)
 			|| strcmp(nd_desc->provider_name, "ACPI.NFIT") != 0)
 		return NULL;
 
-	return to_acpi_device(acpi_desc->dev);
+	return ACPI_COMPANION(acpi_desc->dev);
 }
 
 static int xlat_bus_status(void *buf, unsigned int cmd, u32 status)
@@ -3284,11 +3285,11 @@ static void acpi_nfit_put_table(void *table)
 
 static void acpi_nfit_notify(acpi_handle handle, u32 event, void *data)
 {
-	struct acpi_device *adev = data;
+	struct device *dev = data;
 
-	device_lock(&adev->dev);
-	__acpi_nfit_notify(&adev->dev, handle, event);
-	device_unlock(&adev->dev);
+	device_lock(dev);
+	__acpi_nfit_notify(dev, handle, event);
+	device_unlock(dev);
 }
 
 static void acpi_nfit_remove_notify_handler(void *data)
@@ -3329,11 +3330,12 @@ void acpi_nfit_shutdown(void *data)
 }
 EXPORT_SYMBOL_GPL(acpi_nfit_shutdown);
 
-static int acpi_nfit_add(struct acpi_device *adev)
+static int acpi_nfit_probe(struct platform_device *pdev)
 {
 	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
 	struct acpi_nfit_desc *acpi_desc;
-	struct device *dev = &adev->dev;
+	struct device *dev = &pdev->dev;
+	struct acpi_device *adev = ACPI_COMPANION(dev);
 	struct acpi_table_header *tbl;
 	acpi_status status = AE_OK;
 	acpi_size sz;
@@ -3360,7 +3362,7 @@ static int acpi_nfit_add(struct acpi_device *adev)
 	acpi_desc = devm_kzalloc(dev, sizeof(*acpi_desc), GFP_KERNEL);
 	if (!acpi_desc)
 		return -ENOMEM;
-	acpi_nfit_desc_init(acpi_desc, &adev->dev);
+	acpi_nfit_desc_init(acpi_desc, dev);
 
 	/* Save the acpi header for exporting the revision via sysfs */
 	acpi_desc->acpi_header = *tbl;
@@ -3391,7 +3393,7 @@ static int acpi_nfit_add(struct acpi_device *adev)
 		return rc;
 
 	rc = acpi_dev_install_notify_handler(adev, ACPI_DEVICE_NOTIFY,
-					     acpi_nfit_notify, adev);
+					     acpi_nfit_notify, dev);
 	if (rc)
 		return rc;
 
@@ -3475,11 +3477,11 @@ static const struct acpi_device_id acpi_nfit_ids[] = {
 };
 MODULE_DEVICE_TABLE(acpi, acpi_nfit_ids);
 
-static struct acpi_driver acpi_nfit_driver = {
-	.name = KBUILD_MODNAME,
-	.ids = acpi_nfit_ids,
-	.ops = {
-		.add = acpi_nfit_add,
+static struct platform_driver acpi_nfit_driver = {
+	.probe = acpi_nfit_probe,
+	.driver = {
+		.name = KBUILD_MODNAME,
+		.acpi_match_table = acpi_nfit_ids,
 	},
 };
 
@@ -3517,7 +3519,7 @@ static __init int nfit_init(void)
 		return -ENOMEM;
 
 	nfit_mce_register();
-	ret = acpi_bus_register_driver(&acpi_nfit_driver);
+	ret = platform_driver_register(&acpi_nfit_driver);
 	if (ret) {
 		nfit_mce_unregister();
 		destroy_workqueue(nfit_wq);
@@ -3530,7 +3532,7 @@ static __init int nfit_init(void)
 static __exit void nfit_exit(void)
 {
 	nfit_mce_unregister();
-	acpi_bus_unregister_driver(&acpi_nfit_driver);
+	platform_driver_unregister(&acpi_nfit_driver);
 	destroy_workqueue(nfit_wq);
 	WARN_ON(!list_empty(&acpi_descs));
 }
-- 
2.41.0

