Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AAFA3D
	for <nvdimm@lists.linux.dev>; Tue, 26 Sep 2023 18:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695753945; x=1727289945;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UsIV3Q3gcUAc21rNqcq+g99sj4f1HzfeIQJnfu00KFE=;
  b=Vok4jHA8e/wohyXZ+WrOyxtozkz2O8k9VuScxpHxqSuGHA78llb3dunh
   8+6+Vk9mozitvN1JyTe9knwfNN4cRWeQeus+/4peak/wdG2Es91fiRlyB
   Pllp3y4BTs3CEJ05ge20oebBTU4LzEVqHOg+X/Jev+gxxLumyL9AlOjkw
   i6HrBqPhcX7FKZqHHRHGempEOMjYL97jnuXbB/vmDtyYx9f6+eMlkIHh6
   kuJi/hsRFS31wjvHdTHq781RSwfRIQaqAygeIySid2yaF70jV6qSqdtWy
   qB2KFwRYwtRXuwTmAEG77OB3IwE4ZwxnfHW9Tx3wHo3Aq/OItUP50285n
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="378920274"
X-IronPort-AV: E=Sophos;i="6.03,178,1694761200"; 
   d="scan'208";a="378920274"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 11:45:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="752279646"
X-IronPort-AV: E=Sophos;i="6.03,178,1694761200"; 
   d="scan'208";a="752279646"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 11:45:34 -0700
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
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v1 2/2] ACPI: NFIT: Use modern scope based rollback
Date: Tue, 26 Sep 2023 21:45:20 +0300
Message-ID: <20230926184520.2239723-3-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230926184520.2239723-1-michal.wilczynski@intel.com>
References: <20230926184520.2239723-1-michal.wilczynski@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change rollback in acpi_nfit_init_interleave_set() to use modern scope
based attribute __free(). This is similar to C++ RAII and is a preferred
way for handling local memory allocations.

Suggested-by: Dave Jiang <dave.jiang@intel.com>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/nfit/core.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 78f0f855c4de..079bd663495f 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2257,29 +2257,23 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 		struct nd_region_desc *ndr_desc,
 		struct acpi_nfit_system_address *spa)
 {
+	u16 nr = ndr_desc->num_mappings;
+	struct nfit_set_info2 *info2 __free(kfree) =
+		kcalloc(nr, sizeof(*info2), GFP_KERNEL);
+	struct nfit_set_info *info __free(kfree) =
+		kcalloc(nr, sizeof(*info), GFP_KERNEL);
 	struct device *dev = acpi_desc->dev;
 	struct nd_interleave_set *nd_set;
-	u16 nr = ndr_desc->num_mappings;
-	struct nfit_set_info2 *info2;
-	struct nfit_set_info *info;
-	int err = 0;
 	int i;
 
+	if (!info || !info2)
+		return -ENOMEM;
+
 	nd_set = devm_kzalloc(dev, sizeof(*nd_set), GFP_KERNEL);
 	if (!nd_set)
 		return -ENOMEM;
 	import_guid(&nd_set->type_guid, spa->range_guid);
 
-	info = kcalloc(nr, sizeof(*info), GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
-
-	info2 = kcalloc(nr, sizeof(*info2), GFP_KERNEL);
-	if (!info2) {
-		err = -ENOMEM;
-		goto free_info;
-	}
-
 	for (i = 0; i < nr; i++) {
 		struct nd_mapping_desc *mapping = &ndr_desc->mapping[i];
 		struct nvdimm *nvdimm = mapping->nvdimm;
@@ -2292,8 +2286,7 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 
 		if (!memdev || !nfit_mem->dcr) {
 			dev_err(dev, "%s: failed to find DCR\n", __func__);
-			err = -ENODEV;
-			goto free_info2;
+			return -ENODEV;
 		}
 
 		map->region_offset = memdev->region_offset;
@@ -2342,12 +2335,7 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 
 	ndr_desc->nd_set = nd_set;
 
-free_info2:
-	kfree(info2);
-free_info:
-	kfree(info);
-
-	return err;
+	return 0;
 }
 
 static int ars_get_cap(struct acpi_nfit_desc *acpi_desc,
-- 
2.41.0

