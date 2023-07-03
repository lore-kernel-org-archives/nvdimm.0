Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A36820EF
	for <nvdimm@lists.linux.dev>; Mon,  3 Jul 2023 08:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688371420; x=1719907420;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+KEWHKPpqNaiI+WNm1olqE9/TBQfa5bBD6OIb1rqfsw=;
  b=BbkJoKxLvvN6eDEe2q0v8TG4DzG7e52YWak2cTLwKKnI3Ums547kXORw
   EpctEI1QahswjcHXi15/UN46RIEuQuzeIGVcEStmdHLEC0r5JgOppvwco
   HkwFNckvQubv5TnergqoFGjvukL+g+n1QDtHQX7HQY8z99jumjTuKqzFg
   PsDY9iPJrEs0O1DkCFbuZQMbVs0GfXVJzhktOxGWSxHTIXma2CF84LrY/
   ga8Y2r3G73ynYnQNWMnKRxLoGr2uXMo6pZBxyEjHSEiLtwmdzDBq1eBWH
   ApNHsQxN4/S3t5KxhFGdavgfXoZ7keJSibiEJ17xEl1BHG+qg49/PhlOe
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="366304102"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="366304102"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 01:03:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="862994575"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="862994575"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2023 01:03:36 -0700
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
Subject: [PATCH v7 8/9] acpi/nfit: Remove unnecessary .remove callback
Date: Mon,  3 Jul 2023 11:02:51 +0300
Message-ID: <20230703080252.2899090-9-michal.wilczynski@intel.com>
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

Nfit driver doesn't use .remove() callback and provide an empty function
as it's .remove() callback. Remove empty acpi_nfit_remove() and
initialization of callback.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/nfit/core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 124e928647d3..16bf17a3d6ff 100644
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

