Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6C31ACA9
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 16:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686934264; x=1718470264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YpXKLkZYqfKoJMlwGjZfZyyB1xoLyflHJUZahcB0DSk=;
  b=Gv4RMOjp9lob4DsVsUpb1s5jFxAlUnll9xtH/0uKPOnyuAQ1dCq/y8gP
   y8M5tjLCuPLQay2nRi4tzQjE0h+x5OZ5uhs3twj2hKmlBtl44ba4y4LsD
   LWL2Z6lYuaQUVasXvvzGwGGa36f6qm+97nOegbdMo7rJ/bKL63KChM4K6
   gCpOa9HGX3GyTnRpZB1nyuDvSIpxQPRA9Xx3U4KNN8b7Bgd4t76eR8YGr
   80BFy5lxkY89dOebyCF1MBczG7yrLJfec15e2pJtM/HIxHgkcsQNV+B1W
   /ib1aX9GzvPW1vcbyRpDzekUK3Hdppx9IwUY59vgpDSYB2hJb9CUH0LFY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="422912995"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="422912995"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:51:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="707154134"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="707154134"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:51:01 -0700
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
Subject: [PATCH v5 03/10] acpi/ac: Move handler installing logic to driver
Date: Fri, 16 Jun 2023 19:50:27 +0300
Message-ID: <20230616165034.3630141-4-michal.wilczynski@intel.com>
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

Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/ac.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 1ace70b831cd..207ee3c85bad 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -34,7 +34,7 @@ MODULE_LICENSE("GPL");
 
 static int acpi_ac_add(struct acpi_device *device);
 static void acpi_ac_remove(struct acpi_device *device);
-static void acpi_ac_notify(struct acpi_device *device, u32 event);
+static void acpi_ac_notify(acpi_handle handle, u32 event, void *data);
 
 static const struct acpi_device_id ac_device_ids[] = {
 	{"ACPI0003", 0},
@@ -54,11 +54,9 @@ static struct acpi_driver acpi_ac_driver = {
 	.name = "ac",
 	.class = ACPI_AC_CLASS,
 	.ids = ac_device_ids,
-	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
 	.ops = {
 		.add = acpi_ac_add,
 		.remove = acpi_ac_remove,
-		.notify = acpi_ac_notify,
 		},
 	.drv.pm = &acpi_ac_pm,
 };
@@ -128,9 +126,12 @@ static enum power_supply_property ac_props[] = {
 };
 
 /* Driver Model */
-static void acpi_ac_notify(struct acpi_device *device, u32 event)
+static void acpi_ac_notify(acpi_handle handle, u32 event, void *data)
 {
-	struct acpi_ac *ac = acpi_driver_data(device);
+	struct acpi_device *device = data;
+	struct acpi_ac *ac;
+
+	ac = acpi_driver_data(device);
 
 	if (!ac)
 		return;
@@ -235,7 +236,7 @@ static int acpi_ac_add(struct acpi_device *device)
 
 	result = acpi_ac_get_state(ac);
 	if (result)
-		goto end;
+		goto err_release_ac;
 
 	psy_cfg.drv_data = ac;
 
@@ -248,7 +249,7 @@ static int acpi_ac_add(struct acpi_device *device)
 					    &ac->charger_desc, &psy_cfg);
 	if (IS_ERR(ac->charger)) {
 		result = PTR_ERR(ac->charger);
-		goto end;
+		goto err_release_ac;
 	}
 
 	pr_info("%s [%s] (%s)\n", acpi_device_name(device),
@@ -256,9 +257,20 @@ static int acpi_ac_add(struct acpi_device *device)
 
 	ac->battery_nb.notifier_call = acpi_ac_battery_notify;
 	register_acpi_notifier(&ac->battery_nb);
-end:
+
+	result = acpi_dev_install_notify_handler(device,
+						 ACPI_ALL_NOTIFY,
+						 acpi_ac_notify);
 	if (result)
-		kfree(ac);
+		goto err_unregister;
+
+	return 0;
+
+err_unregister:
+	power_supply_unregister(ac->charger);
+	unregister_acpi_notifier(&ac->battery_nb);
+err_release_ac:
+	kfree(ac);
 
 	return result;
 }
@@ -297,6 +309,9 @@ static void acpi_ac_remove(struct acpi_device *device)
 
 	ac = acpi_driver_data(device);
 
+	acpi_dev_remove_notify_handler(device,
+				       ACPI_ALL_NOTIFY,
+				       acpi_ac_notify);
 	power_supply_unregister(ac->charger);
 	unregister_acpi_notifier(&ac->battery_nb);
 
-- 
2.41.0

