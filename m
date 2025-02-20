Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB46CA935;
	Thu, 20 Feb 2025 00:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740012350; cv=none; b=TEaj1ql9y0BzrZv8XvqPt5sFFCmzp9FhEDBkyqHiUsWH2usYxvbcAZPakseBZkBA0T234vix0SWtPH4x6Ya/qBePj0mqCEl98YK8LjVDXLnvYxqmvt/18BNhfIxdhAq61nvkfl4qo8tHrhPVrQbeIgVDn4+DOdFuJUcQayz3cPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740012350; c=relaxed/simple;
	bh=kpFMB3ExamHBGUkK85FA3xRAy1kfwWMW/56xticRSoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxk+lpGzKGI2UUji9jxc24NJgEA7SUXk7DSfOpBjMLXf169atnpLMLAtE7/6ITKGveKKemt+UD/UAHlXn+8T30x+Sfl+2aJ4dch6GOmAYwhfY8EOUS1QlXUg709AS3tSsyDl5ITvIu5jjT52g8TDOqzcv0F7dvsi87+SB9BxuEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=jDemdvGX; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="jDemdvGX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=2q3WviUZXHlogJ2l+bxgrrEemfXxErdX7+HM+mBaq9c=; b=jDemdvGXSEKkPqq2
	ZgI2/pNh7FMJ7w3xL46aKWq4NTJAYoUFoGW40ML2bGgxH55cKxa0TgE3Sx9qNN+gfaY9ZmuW7oPI7
	XWb9m9cDtgcqc3lTfbkLJUx4enBHkA2gYzkSsY8AMI3Kj8yGtiV5KhSetTODC9m7dLZY367dbt7hg
	E/R7C7qY4Y/m9rHXp4hB53HsRo22Za+YwcOLkbPU5Kik9YkzdI6WmbGAlwAgLzmtOEnzFBRNRraoP
	6Y/R9poSRPSo3mazDiR7sfT/XXks9XoRSQDGPTJdT7e57ojNUWjOt+1Jjp37loptCWEgPNWAtskVi
	bk81cIejWxyPfpPJNA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tkuhA-00H2o0-24;
	Thu, 20 Feb 2025 00:45:40 +0000
From: linux@treblig.org
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 1/2] libnvdimm: Remove unused nd_region_conflict
Date: Thu, 20 Feb 2025 00:45:37 +0000
Message-ID: <20250220004538.84585-2-linux@treblig.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250220004538.84585-1-linux@treblig.org>
References: <20250220004538.84585-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

nd_region_conflict() has been unused since 2019's
commit a3619190d62e ("libnvdimm/pfn: stop padding pmem namespaces to
section alignment")

Remove it, and the region_confict() helper it uses, and the associated
struct conflict_context.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/nvdimm/nd-core.h     |  2 --
 drivers/nvdimm/region_devs.c | 41 ------------------------------------
 2 files changed, 43 deletions(-)

diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 86976a9e8a15..2b37b7fc4fef 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -127,8 +127,6 @@ resource_size_t nd_region_allocatable_dpa(struct nd_region *nd_region);
 resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
 				      struct nd_mapping *nd_mapping);
 resource_size_t nd_region_available_dpa(struct nd_region *nd_region);
-int nd_region_conflict(struct nd_region *nd_region, resource_size_t start,
-		resource_size_t size);
 resource_size_t nvdimm_allocated_dpa(struct nvdimm_drvdata *ndd,
 		struct nd_label_id *label_id);
 int nvdimm_num_label_slots(struct nvdimm_drvdata *ndd);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 37417ce5ec7b..de1ee5ebc851 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1229,45 +1229,4 @@ bool is_nvdimm_sync(struct nd_region *nd_region)
 }
 EXPORT_SYMBOL_GPL(is_nvdimm_sync);
 
-struct conflict_context {
-	struct nd_region *nd_region;
-	resource_size_t start, size;
-};
-
-static int region_conflict(struct device *dev, void *data)
-{
-	struct nd_region *nd_region;
-	struct conflict_context *ctx = data;
-	resource_size_t res_end, region_end, region_start;
-
-	if (!is_memory(dev))
-		return 0;
-
-	nd_region = to_nd_region(dev);
-	if (nd_region == ctx->nd_region)
-		return 0;
-
-	res_end = ctx->start + ctx->size;
-	region_start = nd_region->ndr_start;
-	region_end = region_start + nd_region->ndr_size;
-	if (ctx->start >= region_start && ctx->start < region_end)
-		return -EBUSY;
-	if (res_end > region_start && res_end <= region_end)
-		return -EBUSY;
-	return 0;
-}
-
-int nd_region_conflict(struct nd_region *nd_region, resource_size_t start,
-		resource_size_t size)
-{
-	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
-	struct conflict_context ctx = {
-		.nd_region = nd_region,
-		.start = start,
-		.size = size,
-	};
-
-	return device_for_each_child(&nvdimm_bus->dev, &ctx, region_conflict);
-}
-
 MODULE_IMPORT_NS("DEVMEM");
-- 
2.48.1

