Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30091C295
	for <nvdimm@lists.linux.dev>; Mon, 25 Sep 2023 14:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695653391; x=1727189391;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=84m75FsmmCxHAs5Vy3y5UlBCIG1MzYs7Y5oMZFaEZNo=;
  b=PPliPTRYiWutXQRnH+SS2qS0dz3S0dZF04BfpK+qpTXcK778PhJuiUxN
   /+cWRoELWJdKYvtiT0Gy1NhmOyO1yJyMbjh0drpewkWM+/uo6d0jxmU2Q
   WwBWB3f48NWweQ1j0xx9/UuTCgEd2SnmolDr6S5xzzralceNHSzmwtuIi
   dYapuildU1x1FwLvG6cf4AbKMWgnPivaVBKuh4I02QpIBAtFcAJkKcKus
   b+WoRcavklTnjeMoDXW3dHWboqiLQ3d/6nyVhe3RCkACXpx6J4/Ws41sR
   7nzjl6GVXIP1qfB6m6Ig84evbZ2eqoiIqVsIADZBYnNCBu98SpSltzzGZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="378548127"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="378548127"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 07:49:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="995409563"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="995409563"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 07:49:41 -0700
From: Michal Wilczynski <michal.wilczynski@intel.com>
To: linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: rafael.j.wysocki@intel.com,
	andriy.shevchenko@intel.com,
	lenb@kernel.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	rui.zhang@intel.com,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v1 9/9] ACPI: NFIT: Don't use KBUILD_MODNAME for driver name
Date: Mon, 25 Sep 2023 17:48:42 +0300
Message-ID: <20230925144842.586829-10-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230925144842.586829-1-michal.wilczynski@intel.com>
References: <20230925144842.586829-1-michal.wilczynski@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Driver name is part of the ABI, so it should be hard-coded, as ABI
should be always kept backward compatible. Prevent ABI from changing
accidentally in case KBUILD_MODNAME change.

Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index f09530d2520a..987eb5567036 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3478,7 +3478,7 @@ MODULE_DEVICE_TABLE(acpi, acpi_nfit_ids);
 static struct platform_driver acpi_nfit_driver = {
 	.probe = acpi_nfit_probe,
 	.driver = {
-		.name = KBUILD_MODNAME,
+		.name = "nfit",
 		.acpi_match_table = acpi_nfit_ids,
 	},
 };
-- 
2.41.0

