Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0AD4694
	for <nvdimm@lists.linux.dev>; Fri, 14 Oct 2022 23:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665791907; x=1697327907;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C/qZLnXcKAFdw6v16/JSbSW5MEboRqnBqKQbL8OhQjQ=;
  b=DA8AmRzTItZ+VPEIOA1yewgBF9aShEfSaqBYNy9ItcaQ3+2qkVsAVNta
   EHKIudUDyjqlHg32Juqd2TP3OANRw9ZIAfhfFnulw7fxQdVNDp72G5Ndd
   +1FtkGuK+JN8RnwDn5fiVH8RTFqNRGZEdju09hOrX78y77xbSUeyhkXCh
   m9GnTsezhpocFGaHnn/FHoPi6Aw/ciQTe9i7sIsb8xaP6uuB6P1dVWzHc
   KavehPt4QdqNjj4k6QwJmVpaWiaE2Ad2NL8MWIp+3ytMrpei324nRZ73H
   jApUIH7kZVlyDqwmUhelYJqeqFU0ZBg5oH5PmvPWNwz8MG1NgQo0psrYm
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="332018661"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="332018661"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:58:27 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="630113510"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="630113510"
Received: from uyoon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.90.112])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:58:26 -0700
Subject: [PATCH v3 15/25] libnvdimm/pmem: Support pmem block devices without
 dax
From: Dan Williams <dan.j.williams@intel.com>
To: linux-mm@kvack.org
Cc: david@fromorbit.com, hch@lst.de, nvdimm@lists.linux.dev,
 akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org
Date: Fri, 14 Oct 2022 16:58:26 -0700
Message-ID: <166579190607.2236710.1230996282258115812.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
References: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for CONFIG_DAX growing a CONFIG_MMU dependency add
support for pmem to skip dax-device registration in the CONFIG_DAX=n
case.

alloc_dax() returns NULL in the CONFIG_DAX=n case, ERR_PTR() in the
failure case, and a dax-device in the success case.

dax_remove_host(), kill_dax() and put_dax() are safe to call if
setup_dax() returns 0 because it suceeded, or 0 because CONFIG_DAX=n.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/Kconfig |    2 +-
 drivers/nvdimm/pmem.c  |   47 ++++++++++++++++++++++++++++++-----------------
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 5a29046e3319..027acca1bac4 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -19,7 +19,7 @@ if LIBNVDIMM
 config BLK_DEV_PMEM
 	tristate "PMEM: Persistent memory block device support"
 	default LIBNVDIMM
-	select DAX
+	select DAX if MMU
 	select ND_BTT if BTT
 	select ND_PFN if NVDIMM_PFN
 	help
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 7e88cd242380..068183ee9bf6 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -468,6 +468,32 @@ static const struct dev_pagemap_ops fsdax_pagemap_ops = {
 	.memory_failure		= pmem_pagemap_memory_failure,
 };
 
+static int setup_dax(struct pmem_device *pmem, struct gendisk *disk,
+		     struct nd_region *nd_region)
+{
+	struct dax_device *dax_dev;
+	int rc;
+
+	dax_dev = alloc_dax(pmem, &pmem_dax_ops);
+	if (IS_ERR(dax_dev))
+		return PTR_ERR(dax_dev);
+	if (!dax_dev)
+		return 0;
+	set_dax_nocache(dax_dev);
+	set_dax_nomc(dax_dev);
+	if (is_nvdimm_sync(nd_region))
+		set_dax_synchronous(dax_dev);
+	rc = dax_add_host(dax_dev, disk);
+	if (rc) {
+		kill_dax(dax_dev);
+		put_dax(dax_dev);
+		return rc;
+	}
+	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
+	pmem->dax_dev = dax_dev;
+	return 0;
+}
+
 static int pmem_attach_disk(struct device *dev,
 		struct nd_namespace_common *ndns)
 {
@@ -477,7 +503,6 @@ static int pmem_attach_disk(struct device *dev,
 	struct resource *res = &nsio->res;
 	struct range bb_range;
 	struct nd_pfn *nd_pfn = NULL;
-	struct dax_device *dax_dev;
 	struct nd_pfn_sb *pfn_sb;
 	struct pmem_device *pmem;
 	struct request_queue *q;
@@ -578,24 +603,13 @@ static int pmem_attach_disk(struct device *dev,
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
 	disk->bb = &pmem->bb;
 
-	dax_dev = alloc_dax(pmem, &pmem_dax_ops);
-	if (IS_ERR(dax_dev)) {
-		rc = PTR_ERR(dax_dev);
-		goto out;
-	}
-	set_dax_nocache(dax_dev);
-	set_dax_nomc(dax_dev);
-	if (is_nvdimm_sync(nd_region))
-		set_dax_synchronous(dax_dev);
-	rc = dax_add_host(dax_dev, disk);
+	rc = setup_dax(pmem, disk, nd_region);
 	if (rc)
-		goto out_cleanup_dax;
-	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
-	pmem->dax_dev = dax_dev;
+		goto out;
 
 	rc = device_add_disk(dev, disk, pmem_attribute_groups);
 	if (rc)
-		goto out_remove_host;
+		goto out_dax;
 	if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
 		return -ENOMEM;
 
@@ -607,9 +621,8 @@ static int pmem_attach_disk(struct device *dev,
 		dev_warn(dev, "'badblocks' notification disabled\n");
 	return 0;
 
-out_remove_host:
+out_dax:
 	dax_remove_host(pmem->disk);
-out_cleanup_dax:
 	kill_dax(pmem->dax_dev);
 	put_dax(pmem->dax_dev);
 out:

