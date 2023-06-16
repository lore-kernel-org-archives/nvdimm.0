Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4681ACAC
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 16:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686934282; x=1718470282;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KUa89HHIfqiRuH33Slfb9eUQnsMLPp8P5obcJE6sL2I=;
  b=LaDJmPh/NTe/S0NAVaItbV1I2DQr9LAhYspP1XbGkF4EL3AX1u9/p31W
   Xtop+C2nWzwaeCPCfmMSJuo72YO/X3QPdexYB/CfzV4vEOAxmSUgzxOWf
   yOdQva2XXrxk2tlv6TrJwmwf+WkLhTXFCyarY36Lto8SuECTPH8K/UhDh
   QKkJVnVRoPZvUmBC06VsOo0KTX5ClT0s0oNpOtHYMbnwB5GPSo7LerXAS
   6loOfdPNt5GxhODtQ/5H4m8XwDnXBOeSnaMHn1L5sl1k+EhQO7+Un9snV
   Mdrt4aqzsz8oA+nMXt9itjGXTElqoYUGJYB4Utpm/ncnWXNpH60MGooR4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="422913062"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="422913062"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:51:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="707154203"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="707154203"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:51:17 -0700
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
	Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH v5 07/10] acpi/nfit: Move acpi_nfit_notify() before acpi_nfit_add()
Date: Fri, 16 Jun 2023 19:50:31 +0300
Message-ID: <20230616165034.3630141-8-michal.wilczynski@intel.com>
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

To use new style of installing event handlers acpi_nfit_notify() needs
to be known inside acpi_nfit_add(). Move acpi_nfit_notify() upwards in
the file, so it can be used inside acpi_nfit_add().

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/nfit/core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 07204d482968..aff79cbc2190 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3312,6 +3312,13 @@ void acpi_nfit_shutdown(void *data)
 }
 EXPORT_SYMBOL_GPL(acpi_nfit_shutdown);
 
+static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
+{
+	device_lock(&adev->dev);
+	__acpi_nfit_notify(&adev->dev, adev->handle, event);
+	device_unlock(&adev->dev);
+}
+
 static int acpi_nfit_add(struct acpi_device *adev)
 {
 	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
@@ -3446,13 +3453,6 @@ void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event)
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
-- 
2.41.0

