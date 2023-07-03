Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A299720EF
	for <nvdimm@lists.linux.dev>; Mon,  3 Jul 2023 08:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688371413; x=1719907413;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OLu9Y5+jm3VDC/cj5GwgBm61aIT2JGxMD1esABlzzPE=;
  b=d8ez2/P4DvFq4/jrQB4TVsErpYIYEStPAh8EXCPvLsneOjUWPu07Ewj3
   dGQ+UH1Ckw/Y/OteZ/QBoT7C0UJCQuVXAe9DTHozq2FfA1jPsrYEaawYm
   8WndqkGgQ5Pp1E3CAF1XwO8uvUfs7QTrlx04q+5QYH+Hczf9/keqhYkgJ
   +x6ZK6orY791I1vDBT0r3iR0atqsTHox4DUmJMUJG98/ixx5nPagMbf9U
   xpa7VXn1XoQ2gH0TwUMWpig7Kn8/+Ckp9Do9flAVEWhaADtNHWhM/EFOY
   8SVXy50HTor+JmTApeeh9vPs3DuAmx+E7m1Z5VJpGSuMW3B78bnKb6yBG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="366304075"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="366304075"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 01:03:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="862994563"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="862994563"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 01:03:30 -0700
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
Subject: [PATCH v7 6/9] acpi/hed: Move handler installing logic to driver
Date: Mon,  3 Jul 2023 11:02:49 +0300
Message-ID: <20230703080252.2899090-7-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230703080252.2899090-1-michal.wilczynski@intel.com>
References: <20230703080252.2899090-1-michal.wilczynski@intel.com>
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

Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/hed.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/hed.c b/drivers/acpi/hed.c
index 78d44e3fe129..8f54560c6d1c 100644
--- a/drivers/acpi/hed.c
+++ b/drivers/acpi/hed.c
@@ -42,22 +42,34 @@ EXPORT_SYMBOL_GPL(unregister_acpi_hed_notifier);
  * it is used by HEST Generic Hardware Error Source with notify type
  * SCI.
  */
-static void acpi_hed_notify(struct acpi_device *device, u32 event)
+static void acpi_hed_notify(acpi_handle handle, u32 event, void *data)
 {
 	blocking_notifier_call_chain(&acpi_hed_notify_list, 0, NULL);
 }
 
 static int acpi_hed_add(struct acpi_device *device)
 {
+	int err;
+
 	/* Only one hardware error device */
 	if (hed_handle)
 		return -EINVAL;
 	hed_handle = device->handle;
-	return 0;
+
+	err = acpi_dev_install_notify_handler(device,
+					      ACPI_DEVICE_NOTIFY,
+					      acpi_hed_notify);
+	if (err)
+		hed_handle = NULL;
+
+	return err;
 }
 
 static void acpi_hed_remove(struct acpi_device *device)
 {
+	acpi_dev_remove_notify_handler(device,
+				       ACPI_DEVICE_NOTIFY,
+				       acpi_hed_notify);
 	hed_handle = NULL;
 }
 
@@ -68,7 +80,6 @@ static struct acpi_driver acpi_hed_driver = {
 	.ops = {
 		.add = acpi_hed_add,
 		.remove = acpi_hed_remove,
-		.notify = acpi_hed_notify,
 	},
 };
 module_acpi_driver(acpi_hed_driver);
-- 
2.41.0

