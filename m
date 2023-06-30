Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00EB174CA
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 18:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688150075; x=1719686075;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K9mqNpqtx0jsUV9AUHZdlk1cbbq1gO+NmVFGsw3m+lE=;
  b=YGzie9RJDuvsiz+6pN9tcrnjzFX7Tke4kI68hh7pdBlXvBOef+1HVAdb
   G6R9EghvktLdvx32TORP3kllftgfdl4JP9dov9317OnK6xR94LjW+7XCa
   BquaJjff5NwYp1v2rdHX0GPp5v3v1URKk6M5uCAvAMQTnhhqAb/w81ecV
   l93+CpVMRJYxpd+LRxgktUMx0NX2ER7kKspX/N3VcMJRJVLhKqA59srad
   Dn7Pql0pBaY7VcMr1qHalP349Z/2m4cd2vGhl6i/o9LdA2Kl6beYu3OW4
   WvxgvuAdG9TOWfw8eUwBsQ9sGD8J0WsCHwqTqaLBrH09R5Vf+hkCaqvYw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="365950024"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="365950024"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 11:34:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="717896476"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="717896476"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 11:34:32 -0700
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
Subject: [PATCH v6 8/9] acpi/nfit: Remove unnecessary .remove callback
Date: Fri, 30 Jun 2023 21:33:43 +0300
Message-ID: <20230630183344.891077-9-michal.wilczynski@intel.com>
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

Nfit driver doesn't use .remove() callback and provide an empty function
as it's .remove() callback. Remove empty acpi_nfit_remove() and
initialization of callback.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/nfit/core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index ee2365a80aa1..daaea23cacfd 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3402,11 +3402,6 @@ static int acpi_nfit_add(struct acpi_device *adev)
 					adev);
 }
 
-static void acpi_nfit_remove(struct acpi_device *adev)
-{
-	/* see acpi_nfit_unregister */
-}
-
 static void acpi_nfit_update_notify(struct device *dev, acpi_handle handle)
 {
 	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(dev);
@@ -3488,7 +3483,6 @@ static struct acpi_driver acpi_nfit_driver = {
 	.ids = acpi_nfit_ids,
 	.ops = {
 		.add = acpi_nfit_add,
-		.remove = acpi_nfit_remove,
 	},
 };
 
-- 
2.41.0

