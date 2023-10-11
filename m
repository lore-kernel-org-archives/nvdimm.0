Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2D21A711
	for <nvdimm@lists.linux.dev>; Wed, 11 Oct 2023 08:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EqnPvV3A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697013246; x=1728549246;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9GeUK2SGN9OGtW6dMn16QDj8PfFEO9Do3zKwnp3cbpk=;
  b=EqnPvV3Aj7dP5U2L+jn407ohs3XkMEs/6ogno6QeZ4AP8ONZ2IXTVCOM
   su/ymOdub9R3qbkxYOQMNsxF86u665W4h4TXIvMg7jpSRzmIJIAu7oy3s
   zoz8sA7dIAnH8naEfY/efFC8XfFKxEJu4F60le7VoBoQjczKfMZHc4f49
   rC7266FYMEqpuAXE0RQ5pp8FK9YLulbSp4EkjMYQ/Ft6IFMVJshvvreMc
   wyAYkSiChdIHlJtKhtlgayQrkJpD86zPz5FIkbJ08EGpdUNepcMn7CHwj
   F8jxVchniDnupsRcgffEcFyGfxgRghPLbnBKxspHVOEVcPhGJbUi5cmDh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10859"; a="388480171"
X-IronPort-AV: E=Sophos;i="6.03,214,1694761200"; 
   d="scan'208";a="388480171"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 01:34:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10859"; a="897548199"
X-IronPort-AV: E=Sophos;i="6.03,214,1694761200"; 
   d="scan'208";a="897548199"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 01:32:16 -0700
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
	Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v3 2/6] ACPI: AC: Use string_choices API instead of ternary operator
Date: Wed, 11 Oct 2023 11:33:30 +0300
Message-ID: <20231011083334.3987477-3-michal.wilczynski@intel.com>
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

Use modern string_choices API instead of manually determining the
output using ternary operator.

Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/ac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 83d45c681121..f809f6889b4a 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
+#include <linux/string_choices.h>
 #include <linux/acpi.h>
 #include <acpi/battery.h>
 
@@ -243,8 +244,8 @@ static int acpi_ac_add(struct acpi_device *device)
 		goto err_release_ac;
 	}
 
-	pr_info("%s [%s] (%s)\n", acpi_device_name(device),
-		acpi_device_bid(device), ac->state ? "on-line" : "off-line");
+	pr_info("%s [%s] (%s-line)\n", acpi_device_name(device),
+		acpi_device_bid(device), str_on_off(ac->state));
 
 	ac->battery_nb.notifier_call = acpi_ac_battery_notify;
 	register_acpi_notifier(&ac->battery_nb);
-- 
2.41.0

