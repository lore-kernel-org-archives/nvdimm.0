Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34892C9D
	for <nvdimm@lists.linux.dev>; Wed,  1 Dec 2021 16:48:20 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id E937C21155;
	Wed,  1 Dec 2021 16:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1638377298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OZKC77PkRmt0LF81L8tNeddd6Z7fS1292wB4TtyQg1o=;
	b=BDgmDpkH4W7WQpvgcXPUYreKRjV8CBYXaZvvz7d4YmZYBVZoRAwZJCuY6S5CEt1KNpXGmO
	nC6OHc+C8E5N8nvfXvZRGz703P0tGe94v4925o/HOqYChqnDQbJ7dzQJ7994SSxffjXGWD
	9XiNYSG/iLr/+iOIo0Hq8xAzId7gaKc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1638377298;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OZKC77PkRmt0LF81L8tNeddd6Z7fS1292wB4TtyQg1o=;
	b=36bl7d/jZZkE7z8kXDPz4wrhx+4roLTD0OTQmCIfFr82u5MaT0StNMjtaRtaj6Itc9UK4M
	5yz3hCqGze51ryDQ==
Received: from suse.localdomain (unknown [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id A6C74A3B8D;
	Wed,  1 Dec 2021 16:48:16 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: dan.williams@intel.com
Cc: nvdimm@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Santosh Sivaraj <santosh@fossix.org>
Subject: [PATCH] [PATCH v2] libnvdimm: call devm_namespace_disable() on error
Date: Thu,  2 Dec 2021 00:47:52 +0800
Message-Id: <20211201164752.125238-1-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hannes Reinecke <hare@suse.de>

Once devm_namespace_enable() has been called the error path in the
calling function will not call devm_namespace_disable(), leaving the
namespace enabled on error.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Santosh Sivaraj <santosh@fossix.org>
---
Changelog,
v2: fix the errors by review comments from Santosh,
    - don't call devm_namespace_disable() in nd_pfn_clear_memmap_errors().
    - change EOPNOTSUPP to -EOPNOTSUPP in nd_pmem_probe()
    rebase the patch against latest mainline kernel.
v1: the initial version for review.

 drivers/dax/pmem/core.c |  2 +-
 drivers/nvdimm/btt.c    |  5 ++++-
 drivers/nvdimm/claim.c  |  9 +++++++--
 drivers/nvdimm/pmem.c   | 20 ++++++++++----------
 4 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/dax/pmem/core.c b/drivers/dax/pmem/core.c
index 062e8bc14223..215ce6ed5693 100644
--- a/drivers/dax/pmem/core.c
+++ b/drivers/dax/pmem/core.c
@@ -32,9 +32,9 @@ struct dev_dax *__dax_pmem_probe(struct device *dev, enum dev_dax_subsys subsys)
 	if (rc)
 		return ERR_PTR(rc);
 	rc = nvdimm_setup_pfn(nd_pfn, &pgmap);
+	devm_namespace_disable(dev, ndns);
 	if (rc)
 		return ERR_PTR(rc);
-	devm_namespace_disable(dev, ndns);
 
 	/* reserve the metadata area, device-dax will reserve the data */
 	pfn_sb = nd_pfn->pfn_sb;
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index da3f007a1211..4c47f629a06c 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1695,13 +1695,16 @@ int nvdimm_namespace_attach_btt(struct nd_namespace_common *ndns)
 		dev_dbg(&nd_btt->dev, "%s must be at least %ld bytes\n",
 				dev_name(&ndns->dev),
 				ARENA_MIN_SIZE + nd_btt->initial_offset);
+		devm_namespace_disable(&nd_btt->dev, ndns);
 		return -ENXIO;
 	}
 	nd_region = to_nd_region(nd_btt->dev.parent);
 	btt = btt_init(nd_btt, rawsize, nd_btt->lbasize, nd_btt->uuid,
 		       nd_region);
-	if (!btt)
+	if (!btt) {
+		devm_namespace_disable(&nd_btt->dev, ndns);
 		return -ENOMEM;
+	}
 	nd_btt->btt = btt;
 
 	return 0;
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 030dbde6b088..cd9aa41d526b 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -318,13 +318,18 @@ int devm_nsio_enable(struct device *dev, struct nd_namespace_io *nsio,
 	}
 
 	ndns->rw_bytes = nsio_rw_bytes;
-	if (devm_init_badblocks(dev, &nsio->bb))
+	if (devm_init_badblocks(dev, &nsio->bb)) {
+		devm_release_mem_region(dev, range.start, size);
 		return -ENOMEM;
+	}
 	nvdimm_badblocks_populate(to_nd_region(ndns->dev.parent), &nsio->bb,
 			&range);
 
 	nsio->addr = devm_memremap(dev, range.start, size, ARCH_MEMREMAP_PMEM);
-
+	if (IS_ERR(nsio->addr)) {
+		devm_exit_badblocks(dev, &nsio->bb);
+		devm_release_mem_region(dev, range.start, size);
+	}
 	return PTR_ERR_OR_ZERO(nsio->addr);
 }
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index fe7ece1534e1..5230dd04e349 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -416,8 +416,10 @@ static int pmem_attach_disk(struct device *dev,
 	if (is_nd_pfn(dev)) {
 		nd_pfn = to_nd_pfn(dev);
 		rc = nvdimm_setup_pfn(nd_pfn, &pmem->pgmap);
-		if (rc)
+		if (rc) {
+			devm_namespace_disable(dev, ndns);
 			return rc;
+		}
 	}
 
 	/* we're attaching a block device, disable raw namespace access */
@@ -564,17 +566,15 @@ static int nd_pmem_probe(struct device *dev)
 	ret = nd_pfn_probe(dev, ndns);
 	if (ret == 0)
 		return -ENXIO;
-	else if (ret == -EOPNOTSUPP)
-		return ret;
-
-	ret = nd_dax_probe(dev, ndns);
-	if (ret == 0)
-		return -ENXIO;
-	else if (ret == -EOPNOTSUPP)
-		return ret;
-
+	else if (ret != -EOPNOTSUPP) {
+		ret = nd_dax_probe(dev, ndns);
+		if (ret == 0)
+			return -ENXIO;
+	}
 	/* probe complete, attach handles namespace enabling */
 	devm_namespace_disable(dev, ndns);
+	if (ret == -EOPNOTSUPP)
+		return ret;
 
 	return pmem_attach_disk(dev, ndns);
 }
-- 
2.31.1

