Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9244917724
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 18:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688150079; x=1719686079;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8UyXWfKO7yUPN8MnLg1ywaUXI/b1qFb1tKTsv4NWR/I=;
  b=KWL3Ym52pbr8LyjIE+R3lePiMfze7kPsVZWvLWqKXlKSTdlwuXrHZjJi
   iZk+g7HmEXkEjphEIPfCiwJoISUTr+ocHiAhMUvZzUm+Z3ZE7urZ6haKw
   zKZjldzF2ekYc4LjwqDL8n8STBYPnmYq/X27YDKvHTYsmghshLmzbyRmf
   uDv+6pmTKs1dXEoCpHr7PDUUzGkQURoJ5Ta4O6dlZ4W4l66YPpa7Fgolv
   quqGhvdQFJnb4gLSzTTCQJHcoLY8Nuvp93GlThYu3yAE8gy5inG4D+8Mq
   nVx5mMhNJip84kPVQt56bQgmX4ad4zQDV3qGgNhxdFSpvUyj4W7kgAbRt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="365950057"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="365950057"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 11:34:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="717896493"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="717896493"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 11:34:35 -0700
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
Subject: [PATCH v6 9/9] acpi/thermal: Move handler installing logic to driver
Date: Fri, 30 Jun 2023 21:33:44 +0300
Message-ID: <20230630183344.891077-10-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230630183344.891077-1-michal.wilczynski@intel.com>
References: <20230630183344.891077-1-michal.wilczynski@intel.com>
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
what's required by acpi_dev_install_notify_handler(). Remove .notify
callback initialization in acpi_driver.

While at it, fix whitespaces in .remove() callback.

Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/thermal.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index f9f6ebb08fdb..97858ad59d68 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -825,8 +825,9 @@ static void acpi_queue_thermal_check(struct acpi_thermal *tz)
 		queue_work(acpi_thermal_pm_queue, &tz->thermal_check_work);
 }
 
-static void acpi_thermal_notify(struct acpi_device *device, u32 event)
+static void acpi_thermal_notify(acpi_handle handle, u32 event, void *data)
 {
+	struct acpi_device *device = data;
 	struct acpi_thermal *tz = acpi_driver_data(device);
 
 	if (!tz)
@@ -997,11 +998,21 @@ static int acpi_thermal_add(struct acpi_device *device)
 
 	pr_info("%s [%s] (%ld C)\n", acpi_device_name(device),
 		acpi_device_bid(device), deci_kelvin_to_celsius(tz->temperature));
-	goto end;
 
+	result = acpi_dev_install_notify_handler(device,
+						 ACPI_DEVICE_NOTIFY,
+						 acpi_thermal_notify);
+	if (result)
+		goto flush_wq;
+
+	return 0;
+
+flush_wq:
+	flush_workqueue(acpi_thermal_pm_queue);
+	acpi_thermal_unregister_thermal_zone(tz);
 free_memory:
 	kfree(tz);
-end:
+
 	return result;
 }
 
@@ -1012,10 +1023,15 @@ static void acpi_thermal_remove(struct acpi_device *device)
 	if (!device || !acpi_driver_data(device))
 		return;
 
-	flush_workqueue(acpi_thermal_pm_queue);
 	tz = acpi_driver_data(device);
 
+	acpi_dev_remove_notify_handler(device,
+				       ACPI_DEVICE_NOTIFY,
+				       acpi_thermal_notify);
+
+	flush_workqueue(acpi_thermal_pm_queue);
 	acpi_thermal_unregister_thermal_zone(tz);
+
 	kfree(tz);
 }
 
@@ -1078,7 +1094,6 @@ static struct acpi_driver acpi_thermal_driver = {
 	.ops = {
 		.add = acpi_thermal_add,
 		.remove = acpi_thermal_remove,
-		.notify = acpi_thermal_notify,
 		},
 	.drv.pm = &acpi_thermal_pm,
 };
-- 
2.41.0

