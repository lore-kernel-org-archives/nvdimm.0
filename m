Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F4B101FD
	for <nvdimm@lists.linux.dev>; Fri, 13 Oct 2023 08:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E9UnSiM+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697187465; x=1728723465;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=h5m5ctsCvAex9DpLpCjOPM49S/+k402kl9JdKLI4A4U=;
  b=E9UnSiM+m2L+c6p+Esi+4XywqYvjDDM69RZvD2vN9qmnA5BcUtG6JxjI
   2tWHN1a22hCrG0Ad+Xzln3LM+nyc5r111umAEuKnCNFYIYFXQk2+j8gXQ
   ydYCcdde8ovBn5dCQ+H4vL3R25q1z5S9thCThEJkhz4hpImexjLnIPdnH
   SDinmC7QjB1M6TtuMTO9yYXHU1/mHO03I45L1LAGf9qaDnRdxtk9SLLJR
   7J96UkjoFNLtTAyO6rCvWDpvEbmETcJVFeXvSyCxllZPFRtP/cnIXikU1
   aypb2u3hERdgmUtFE4K/sc+OGv2ahs/fyZhzVm8nGowd7q/HcMRDpqDyF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="365397259"
X-IronPort-AV: E=Sophos;i="6.03,221,1694761200"; 
   d="scan'208";a="365397259"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 01:57:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="1086060791"
X-IronPort-AV: E=Sophos;i="6.03,221,1694761200"; 
   d="scan'208";a="1086060791"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 01:57:41 -0700
From: Michal Wilczynski <michal.wilczynski@intel.com>
To: nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	dan.j.williams@intel.com
Cc: rafael@kernel.org,
	vishal.l.verma@intel.com,
	lenb@kernel.org,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	linux-kernel@vger.kernel.org,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v2] ACPI: NFIT: Fix local use of devm_*()
Date: Fri, 13 Oct 2023 11:57:22 +0300
Message-ID: <20231013085722.3031537-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

devm_*() family of functions purpose is managing memory attached to a
device. So in general it should only be used for allocations that should
last for the whole lifecycle of the device. This is not the case for
acpi_nfit_init_interleave_set(). There are two allocations that are only
used locally in this function.

Fix this by switching from devm_kcalloc() to kcalloc(), and adding
modern scope based rollback. This is similar to C++ RAII and is
preferred way for handling local memory allocations.

Reported-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Suggested-by: Dave Jiang <dave.jiang@intel.com>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
v2:
 - removed first commit from the patchset, as the commit couldn't
   be marked as a fix
 - squashed those commits together, since the second one were
   mostly overwriting the previous one

 drivers/acpi/nfit/core.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 3826f49d481b..67a844a705c4 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2257,26 +2257,23 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
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
 	int i;
 
+	if (!info || !info2)
+		return -ENOMEM;
+
 	nd_set = devm_kzalloc(dev, sizeof(*nd_set), GFP_KERNEL);
 	if (!nd_set)
 		return -ENOMEM;
 	import_guid(&nd_set->type_guid, spa->range_guid);
 
-	info = devm_kcalloc(dev, nr, sizeof(*info), GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
-
-	info2 = devm_kcalloc(dev, nr, sizeof(*info2), GFP_KERNEL);
-	if (!info2)
-		return -ENOMEM;
-
 	for (i = 0; i < nr; i++) {
 		struct nd_mapping_desc *mapping = &ndr_desc->mapping[i];
 		struct nvdimm *nvdimm = mapping->nvdimm;
@@ -2337,8 +2334,6 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 	}
 
 	ndr_desc->nd_set = nd_set;
-	devm_kfree(dev, info);
-	devm_kfree(dev, info2);
 
 	return 0;
 }
-- 
2.41.0

