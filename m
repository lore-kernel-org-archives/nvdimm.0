Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E951ACAC
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 16:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686934284; x=1718470284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=emz658PjIxfLyOXE/dk153c9iFAvP6G35Gbvjj3+QzQ=;
  b=bXfdk3UF9kp9/AP5Wbhr18RulItAD2BDVSuNgmRw3As0IsJD/UzUIKjW
   99zFonYrVdPBAUSfuJqn3tubGFWRu8cdcHeXetpoyEE7cSMubhm4TlYKA
   Lq+HtYaogAP2CIAx/uJJUY3DoaGrKjOqqso7Pd17UF9EpE3BXENt/nYSO
   ISzssdNGNhJX5DlDB5ScDtPQTUUcDzhVvfV7AEWxsXV8AdPsA5jMGNzni
   koVAP2ZM6BQP0AYQuJDHKyS8ZOVq9kFaAQQCoCuJ2x4cVOjGg1T/E3Qiv
   hrHzBuLZgPV6w7wDmTTIVEKRNGagvwrYkwMnE8cSWVWRfp3QnrnCkiDKL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="422913079"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="422913079"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:51:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="707154219"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="707154219"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:51:21 -0700
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
Subject: [PATCH v5 08/10] acpi/nfit: Improve terminator line in acpi_nfit_ids
Date: Fri, 16 Jun 2023 19:50:32 +0300
Message-ID: <20230616165034.3630141-9-michal.wilczynski@intel.com>
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

Currently terminator line contains redunant characters. Remove them and
also remove a comma at the end.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index aff79cbc2190..95930e9d776c 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3455,7 +3455,7 @@ EXPORT_SYMBOL_GPL(__acpi_nfit_notify);
 
 static const struct acpi_device_id acpi_nfit_ids[] = {
 	{ "ACPI0012", 0 },
-	{ "", 0 },
+	{}
 };
 MODULE_DEVICE_TABLE(acpi, acpi_nfit_ids);
 
-- 
2.41.0

