Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6821ACA9
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 16:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686934272; x=1718470272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YgJs53JcsAi+GPoM5qs7RjcNG38TJwxYF403LVi9ZLQ=;
  b=NBMg3ZZAmKcFc0Gl47tLxF+FPK/BNuV70fOXZObRZ+oTMR7h/RGx+mwI
   yO2rXY/gXvT4XtQS0BAOgKu3bN3K0meAdWF0K0tUrqpsVTKqZslfZXGRs
   gNMKLo8FwckDVhFBrC67mcV8T0lfteWBFYjGZblMKYcYqL5aZeaJHRgW4
   cHkeZQEzg5iNvfVR4eexFA0m9zjMySbbejK09yyihuL8CRGdj07R+H6Te
   ozScPKLF1MHtUNjz5OpcxBtkp2fBOb7KZJcTZ2a04dW7VFqsM6Hh2sUQz
   fKsZcIhLsu19WfZlTEV+S9OoGlqYIORyg4VgE1OzQuRkBlTvMeY1Zgeb6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="422913029"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="422913029"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:51:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="707154175"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="707154175"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:51:08 -0700
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
Subject: [PATCH v5 05/10] acpi/battery: Move handler installing logic to driver
Date: Fri, 16 Jun 2023 19:50:29 +0300
Message-ID: <20230616165034.3630141-6-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230616165034.3630141-1-michal.wilczynski@intel.com>
References: <20230616165034.3630141-1-michal.wilczynski@intel.com>
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

Call acpi_dev_install_notify_handler() at the end of .add() callback.
Call acpi_dev_remove_notify_handler() at the beginning of .remove()
callback. Change arguments passed to the notify function to match with
what's required by acpi_install_notify_handler(). Remove .notify
callback initialization in acpi_driver.

While at it, fix lack of whitespaces in .remove() callback.

Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/battery.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 9c67ed02d797..6337e7b1f6e1 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -1034,11 +1034,14 @@ static void acpi_battery_refresh(struct acpi_battery *battery)
 }
 
 /* Driver Interface */
-static void acpi_battery_notify(struct acpi_device *device, u32 event)
+static void acpi_battery_notify(acpi_handle handle, u32 event, void *data)
 {
-	struct acpi_battery *battery = acpi_driver_data(device);
+	struct acpi_device *device = data;
+	struct acpi_battery *battery;
 	struct power_supply *old;
 
+	battery = acpi_driver_data(device);
+
 	if (!battery)
 		return;
 	old = battery->bat;
@@ -1212,13 +1215,23 @@ static int acpi_battery_add(struct acpi_device *device)
 
 	device_init_wakeup(&device->dev, 1);
 
-	return result;
+	result = acpi_dev_install_notify_handler(device,
+						 ACPI_ALL_NOTIFY,
+						 acpi_battery_notify);
+	if (result)
+		goto fail_deinit_wakup_and_unregister;
+
+	return 0;
 
+fail_deinit_wakup_and_unregister:
+	device_init_wakeup(&device->dev, 0);
+	unregister_pm_notifier(&battery->pm_nb);
 fail:
 	sysfs_remove_battery(battery);
 	mutex_destroy(&battery->lock);
 	mutex_destroy(&battery->sysfs_lock);
 	kfree(battery);
+
 	return result;
 }
 
@@ -1228,10 +1241,17 @@ static void acpi_battery_remove(struct acpi_device *device)
 
 	if (!device || !acpi_driver_data(device))
 		return;
-	device_init_wakeup(&device->dev, 0);
+
 	battery = acpi_driver_data(device);
+
+	acpi_dev_remove_notify_handler(device,
+				       ACPI_ALL_NOTIFY,
+				       acpi_battery_notify);
+
+	device_init_wakeup(&device->dev, 0);
 	unregister_pm_notifier(&battery->pm_nb);
 	sysfs_remove_battery(battery);
+
 	mutex_destroy(&battery->lock);
 	mutex_destroy(&battery->sysfs_lock);
 	kfree(battery);
@@ -1264,11 +1284,9 @@ static struct acpi_driver acpi_battery_driver = {
 	.name = "battery",
 	.class = ACPI_BATTERY_CLASS,
 	.ids = battery_device_ids,
-	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
 	.ops = {
 		.add = acpi_battery_add,
 		.remove = acpi_battery_remove,
-		.notify = acpi_battery_notify,
 		},
 	.drv.pm = &acpi_battery_pm,
 };
-- 
2.41.0

