Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C400B23423
	for <nvdimm@lists.linux.dev>; Thu,  1 Jun 2023 13:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685626955; x=1717162955;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hM51g4LvmO5TXW4gm++QbkwmPKMxxaZZYt1NUl8p1KA=;
  b=JnXk73K6rKZF3U4PVGqZBA3NFmAFVDafYStdEbLa0JpVwr2EtQ/B1a+d
   8E0zWaxIgrFKcqL2fyjjusOi7+98gX86RSDhPOKnUtxPIdDaWQYoKBVp6
   zjVLhQ/OiykAx40BxIU0D8xnnTzcVW3Kan2Ps4p9wOUiQfxQEC3qSj4+V
   gO5SxZMHTZjN4aY2MXUnx3lO3/V3sktVeS71VAuBnSDSUDbHynG0DUjWl
   U7DnIcNf7HwgpwMEFEEsmEb73C1MGuorZwRiNfOvHbfG9jCtde8u4K/ti
   dwJy1NSItSS4sWul/cG/qmI+ZFRycNGrAOaRMNghEpkJPmkG1O3hSSyuw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="419066882"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="419066882"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 06:18:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="881601530"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="881601530"
Received: from hextor.igk.intel.com ([10.123.220.6])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 06:18:38 -0700
From: Michal Wilczynski <michal.wilczynski@intel.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>
Cc: Michal Wilczynski <michal.wilczynski@intel.com>,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH v4 07/35] acpi/nfit: Move handler installing logic to driver
Date: Thu,  1 Jun 2023 15:17:10 +0200
Message-Id: <20230601131739.300760-8-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230601131739.300760-3-michal.wilczynski@intel.com>
References: <20230601131739.300760-3-michal.wilczynski@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently logic for installing notifications from ACPI devices is
implemented using notify callback in struct acpi_driver. Preparations
are being made to replace acpi_driver with more generic struct
platform_driver, which doesn't contain notify callback. Furthermore
as of now handlers are being called indirectly through
acpi_notify_device(), which decreases performance.

Call acpi_device_install_event_handler() at the end of .add() callback.
Call acpi_device_remove_event_handler() at the beginning of .remove()
callback. Change arguments passed to the notify callback to match with
what's required by acpi_device_install_event_handler().

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/nfit/core.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 07204d482968..633c34513071 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3312,6 +3312,15 @@ void acpi_nfit_shutdown(void *data)
 }
 EXPORT_SYMBOL_GPL(acpi_nfit_shutdown);
 
+static void acpi_nfit_notify(acpi_handle handle, u32 event, void *data)
+{
+	struct acpi_device *device = data;
+
+	device_lock(&device->dev);
+	__acpi_nfit_notify(&device->dev, handle, event);
+	device_unlock(&device->dev);
+}
+
 static int acpi_nfit_add(struct acpi_device *adev)
 {
 	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
@@ -3368,12 +3377,18 @@ static int acpi_nfit_add(struct acpi_device *adev)
 
 	if (rc)
 		return rc;
-	return devm_add_action_or_reset(dev, acpi_nfit_shutdown, acpi_desc);
+
+	rc = devm_add_action_or_reset(dev, acpi_nfit_shutdown, acpi_desc);
+	if (rc)
+		return rc;
+
+	return acpi_device_install_event_handler(adev, ACPI_DEVICE_NOTIFY, acpi_nfit_notify);
 }
 
 static void acpi_nfit_remove(struct acpi_device *adev)
 {
 	/* see acpi_nfit_unregister */
+	acpi_device_remove_event_handler(adev, ACPI_DEVICE_NOTIFY, acpi_nfit_notify);
 }
 
 static void acpi_nfit_update_notify(struct device *dev, acpi_handle handle)
@@ -3446,13 +3461,6 @@ void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event)
 }
 EXPORT_SYMBOL_GPL(__acpi_nfit_notify);
 
-static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
-{
-	device_lock(&adev->dev);
-	__acpi_nfit_notify(&adev->dev, adev->handle, event);
-	device_unlock(&adev->dev);
-}
-
 static const struct acpi_device_id acpi_nfit_ids[] = {
 	{ "ACPI0012", 0 },
 	{ "", 0 },
@@ -3465,7 +3473,6 @@ static struct acpi_driver acpi_nfit_driver = {
 	.ops = {
 		.add = acpi_nfit_add,
 		.remove = acpi_nfit_remove,
-		.notify = acpi_nfit_notify,
 	},
 };
 
-- 
2.40.1

