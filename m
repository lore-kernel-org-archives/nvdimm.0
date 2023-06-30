Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1F616405
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 18:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688150050; x=1719686050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Lc4+OfSbvvX57NjX05OtAekCe3S3QQ2eQi+GYzBA354=;
  b=InWwJTbUmsfWpo4CLZDPv+lQD71q02QMO5FZqITbu1fFiUYMoO0XFNbH
   3ZyFORhU75I5ujD0XLZkcMx/Ldy5KNGCoAclif6MNYJyUQUiWFaGll8/s
   bKe6aOFBGHCo4zDlBZC2HaOF9a/tLuQqdrusxoufCqtDfbkMBYQT/2FPP
   J+YeBxRG6bPITz7xCuICe5gDrhbeoHmFNnBHkpz5i7OjVTf1Y++yu2tvo
   QSxoHbnrOSvdS7yoeWNtm0cO7VdEkSJXoTV2D3pt4WxVHn3WNDyMzhTSC
   4XEUE/IJcOiHQCCkdUpY/6EDloLBe924uJAEzYBEZGGITWcvUWizzFu6f
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="365949925"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="365949925"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 11:34:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="717896425"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="717896425"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 11:34:06 -0700
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
Subject: [PATCH v6 1/9] acpi/bus: Introduce wrappers for ACPICA event handler install/remove
Date: Fri, 30 Jun 2023 21:33:36 +0300
Message-ID: <20230630183344.891077-2-michal.wilczynski@intel.com>
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

Introduce new acpi_dev_install_notify_handler() and
acpi_dev_remove_notify_handler(). Those functions are replacing old
installers, and after all drivers switch to the new model, old installers
will be removed.

Make acpi_dev_install_notify_handler() and acpi_dev_remove_notify_handler()
non-static, and export symbols. This will allow the drivers to call them
directly, instead of relying on .notify callback.

Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/bus.c      | 26 ++++++++++++++++++++++++++
 include/acpi/acpi_bus.h |  6 ++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 20cdfb37da79..2d6f1f45d44e 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -554,6 +554,32 @@ static void acpi_device_remove_notify_handler(struct acpi_device *device,
 	acpi_os_wait_events_complete();
 }
 
+int acpi_dev_install_notify_handler(struct acpi_device *adev,
+				    u32 handler_type,
+				    acpi_notify_handler handler)
+{
+	acpi_status status;
+
+	status = acpi_install_notify_handler(adev->handle,
+					     handler_type,
+					     handler,
+					     adev);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	return 0;
+}
+EXPORT_SYMBOL(acpi_dev_install_notify_handler);
+
+void acpi_dev_remove_notify_handler(struct acpi_device *adev,
+				    u32 handler_type,
+				    acpi_notify_handler handler)
+{
+	acpi_remove_notify_handler(adev->handle, handler_type, handler);
+	acpi_os_wait_events_complete();
+}
+EXPORT_SYMBOL(acpi_dev_remove_notify_handler);
+
 /* Handle events targeting \_SB device (at present only graceful shutdown) */
 
 #define ACPI_SB_NOTIFY_SHUTDOWN_REQUEST 0x81
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index c941d99162c0..23fbe4a16972 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -515,6 +515,12 @@ void acpi_bus_private_data_handler(acpi_handle, void *);
 int acpi_bus_get_private_data(acpi_handle, void **);
 int acpi_bus_attach_private_data(acpi_handle, void *);
 void acpi_bus_detach_private_data(acpi_handle);
+int acpi_dev_install_notify_handler(struct acpi_device *adev,
+				    u32 handler_type,
+				    acpi_notify_handler handler);
+void acpi_dev_remove_notify_handler(struct acpi_device *adev,
+				    u32 handler_type,
+				    acpi_notify_handler handler);
 extern int acpi_notifier_call_chain(struct acpi_device *, u32, u32);
 extern int register_acpi_notifier(struct notifier_block *);
 extern int unregister_acpi_notifier(struct notifier_block *);
-- 
2.41.0

