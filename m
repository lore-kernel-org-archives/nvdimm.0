Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D28220EF
	for <nvdimm@lists.linux.dev>; Mon,  3 Jul 2023 08:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688371417; x=1719907417;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=epFJB+pC8Cnb2bJxMzw10oc2jXbHbhRfW4dq8aHrchQ=;
  b=GbKrYpbkZmIUKaeCIbEGyNphXXcow2r7gtt2a3LI66nLamMMQSsG3f0C
   Nm5l/AgO4LquDUltU5+eGZrY36KkYAXha23oxBshoJhhGumEALtKVnvIJ
   uYy1124FjhWjrDeX2gwPL1lcslRlmQ7vjCxwqa2NeWBMgNwOMdbo8bEwO
   be8b4VTbdFKwm5T40SioVcYW/fa3jSxOI3VWvf3Ova5M2YckZ3u4hioY5
   tVU0bJX/i33uEuqfMKQMOJff3xu2Cvfw69giVeri3OfZ5rQAYM4PGlclM
   k01jP2mFHIVG50sLUYKTOBZEwILj0tHAdjSoUhFP7pMirbYNK+T9B2TWJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="366304088"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="366304088"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 01:03:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="862994572"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="862994572"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 01:03:33 -0700
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
Subject: [PATCH v7 7/9] acpi/nfit: Move handler installing logic to driver
Date: Mon,  3 Jul 2023 11:02:50 +0300
Message-ID: <20230703080252.2899090-8-michal.wilczynski@intel.com>
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
Call acpi_dev_remove_notify_handler() at the beginning of
acpi_nfit_shutdown(). Change arguments passed to the notify function to
match with what's required by acpi_dev_install_notify_handler(). Remove
.notify callback initialization in acpi_driver.

Introduce a new devm action acpi_nfit_remove_notify_handler.

Move acpi_nfit_notify() upwards in the file, so it can be used inside
acpi_nfit_add() and acpi_nfit_remove_notify_handler().

Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/nfit/core.c | 41 +++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 07204d482968..124e928647d3 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3282,6 +3282,24 @@ static void acpi_nfit_put_table(void *table)
 	acpi_put_table(table);
 }
 
+static void acpi_nfit_notify(acpi_handle handle, u32 event, void *data)
+{
+	struct acpi_device *adev = data;
+
+	device_lock(&adev->dev);
+	__acpi_nfit_notify(&adev->dev, handle, event);
+	device_unlock(&adev->dev);
+}
+
+static void acpi_nfit_remove_notify_handler(void *data)
+{
+	struct acpi_device *adev = data;
+
+	acpi_dev_remove_notify_handler(adev,
+				       ACPI_DEVICE_NOTIFY,
+				       acpi_nfit_notify);
+}
+
 void acpi_nfit_shutdown(void *data)
 {
 	struct acpi_nfit_desc *acpi_desc = data;
@@ -3368,7 +3386,20 @@ static int acpi_nfit_add(struct acpi_device *adev)
 
 	if (rc)
 		return rc;
-	return devm_add_action_or_reset(dev, acpi_nfit_shutdown, acpi_desc);
+
+	rc = devm_add_action_or_reset(dev, acpi_nfit_shutdown, acpi_desc);
+	if (rc)
+		return rc;
+
+	rc = acpi_dev_install_notify_handler(adev,
+					     ACPI_DEVICE_NOTIFY,
+					     acpi_nfit_notify);
+	if (rc)
+		return rc;
+
+	return devm_add_action_or_reset(dev,
+					acpi_nfit_remove_notify_handler,
+					adev);
 }
 
 static void acpi_nfit_remove(struct acpi_device *adev)
@@ -3446,13 +3477,6 @@ void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event)
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
@@ -3465,7 +3489,6 @@ static struct acpi_driver acpi_nfit_driver = {
 	.ops = {
 		.add = acpi_nfit_add,
 		.remove = acpi_nfit_remove,
-		.notify = acpi_nfit_notify,
 	},
 };
 
-- 
2.41.0

