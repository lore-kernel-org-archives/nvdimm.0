Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EBEC2CD
	for <nvdimm@lists.linux.dev>; Tue, 17 Oct 2023 08:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SN3b4ZO7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697531365; x=1729067365;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LKGg+L3VZMtPvAZYL+/LvBsBcIOUQgV+HkNPICkLuCI=;
  b=SN3b4ZO7barvJCnp4e69s1l2u4f5QZ0mB1DLZ0Kvuto1Pz8QZPUY2HSM
   lNZAyzNHzJyLdXxsOeWM+my8Yhzp83oiarg75We2VmRBPLlr9gVwkCphr
   92imMQKyg1kxx2Qf1vNZSukkrHMRIUw66TOAbTG4V+tZzKY51PGLRotut
   7JtNEfyeSpP5DydxgVy9K/xEFUO8fF0vZ9uIi0VZ00KJ9ulJCB+rPIZ1w
   j8y9vPaowpbKimL7GTtoG/KzQWJrcer9rHLyp9EHEOXzKKm/lw+AIsThF
   1Y/KeGr2JtcjNVv3OUNwpf2mI8rSv6E5ydZSc4yvj938M8s2mLjyKE+2e
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="365989666"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="365989666"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 01:29:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846733946"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="846733946"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 01:29:21 -0700
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
Subject: [PATCH v3] ACPI: NFIT: Use cleanup.h helpers instead of devm_*()
Date: Tue, 17 Oct 2023 11:29:05 +0300
Message-ID: <20231017082905.1673316-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new cleanup.h facilities that arrived in v6.5-rc1 can replace the
the usage of devm semantics in acpi_nfit_init_interleave_set(). That
routine appears to only be using devm to avoid goto statements. The
new __free() annotation at variable declaration time can achieve the same
effect more efficiently.

There is no end user visible side effects of this patch, I was
motivated to send this cleanup to practice using the new helpers.

Suggested-by: Dave Jiang <dave.jiang@intel.com>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---

Dan, would you like me to give you credit for the changelog changes
with Co-developed-by tag ?

v3:
 - changed changelog
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

