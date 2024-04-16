Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4EE4317C
	for <nvdimm@lists.linux.dev>; Tue, 16 Apr 2024 21:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713304019; cv=none; b=C5NjByEJH6/slADK3sYcbi/zmsZnRK4r4mgtyo2/JHogaBYXZfUyLEVxYpGU09c2ahllFPygW0aB5OLkZLS1YXsmdj9pfJrbxcwuk1FJJfIGeA/kUZjAUI3z3f8MIdm3h9Da1ePSh6PTKSF1mGjDcJZN9TdZUg1V2Yc/sqMGzp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713304019; c=relaxed/simple;
	bh=cKf+2RkB+2QLuB9jgK5gvYtPl3rZ0edQYbTd4CT+lq4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WErEfHDPMxzOvFRqXI8j9dnu5Xq8s9biDiAu2gMOZa6V1mu+wn7nTGU5HvINLa+EOVZ8nWhWzol4tvVQNqKMR1pjdH+16kSu221BhS2yHiO3FiO8qb1WoO4bNO51Ppr3xkl3vigRMq+PkG1uJOjbjivqT1yzWGr1TrIAwdldDP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nZAF9tXX; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nZAF9tXX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713304018; x=1744840018;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=cKf+2RkB+2QLuB9jgK5gvYtPl3rZ0edQYbTd4CT+lq4=;
  b=nZAF9tXXZszbDYkWU5iBXvUvsCdoUQc5aC/RhJ8CZaJyaSITjYcczvn9
   8ur9YJgKzFjAVsNti4w/tZcMl7Xmvg2mhlhwu1X0rMRVnDl2M918jv59G
   ggaXm6vRR1dS+gVYINcWoXVqON76xzkaghDNU138/RPJXaUFEa2GLOwVZ
   z3nLGfqneafZQfyCpW9QrVPTh6PIZmqJl/xxwVHUsWIziDGVZKYunFqO+
   0xhI34FfoPb5wGhcXdqCwM0k1IJjQeRGdV0D9qeOSukTQqYAH+matLzHC
   73VTypvkrlqRlTPgzmpE8b1G6czaYuCPDl4OmdR7nLOwupO6Zpr0zktf6
   A==;
X-CSE-ConnectionGUID: DCfxiRKfRB6SbCp2H40TBA==
X-CSE-MsgGUID: BepGe0WRTYGDNfvF92WPzQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="12553090"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="12553090"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:46:41 -0700
X-CSE-ConnectionGUID: QApnvFuHQCmKzbH2uOJDEA==
X-CSE-MsgGUID: APj7IGkwQLOA0O8WTSF2jQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22464242"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.14.216])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:46:40 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 16 Apr 2024 15:46:16 -0600
Subject: [PATCH v2 1/4] dax/bus.c: replace WARN_ON_ONCE() with lockdep
 asserts
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240416-vv-dax_abi_fixes-v2-1-d5f0c8ec162e@intel.com>
References: <20240416-vv-dax_abi_fixes-v2-0-d5f0c8ec162e@intel.com>
In-Reply-To: <20240416-vv-dax_abi_fixes-v2-0-d5f0c8ec162e@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.14-dev-5ce50
X-Developer-Signature: v=1; a=openpgp-sha256; l=3458;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=cKf+2RkB+2QLuB9jgK5gvYtPl3rZ0edQYbTd4CT+lq4=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDGlyH/fn3XilbZkpLv6fZRMXX6Bpf9DXFwYKu24abmFZl
 JL098fDjlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEzEL4yRYd+e2R/T2593hk19
 VRNk4DFHQ0379uY/Wx8qSGcasP/53Mfwz2hPuo7rq2o3+5iLHxe/WSbz1f39SplKrSDjxc9+mk+
 /zwIA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

In [1], Dan points out that all of the WARN_ON_ONCE() usage in the
referenced patch should be replaced with lockdep_assert_held, or
lockdep_held_assert_write(). Replace these as appropriate.

Link: https://lore.kernel.org/r/65f0b5ef41817_aa222941a@dwillia2-mobl3.amr.corp.intel.com.notmuch [1]
Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Cc: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/dax/bus.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 797e1ebff299..7924dd542a13 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -192,7 +192,7 @@ static u64 dev_dax_size(struct dev_dax *dev_dax)
 	u64 size = 0;
 	int i;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_dev_rwsem));
+	lockdep_assert_held(&dax_dev_rwsem);
 
 	for (i = 0; i < dev_dax->nr_range; i++)
 		size += range_len(&dev_dax->ranges[i].range);
@@ -302,7 +302,7 @@ static unsigned long long dax_region_avail_size(struct dax_region *dax_region)
 	resource_size_t size = resource_size(&dax_region->res);
 	struct resource *res;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held(&dax_region_rwsem);
 
 	for_each_dax_region_resource(dax_region, res)
 		size -= resource_size(res);
@@ -447,7 +447,7 @@ static void trim_dev_dax_range(struct dev_dax *dev_dax)
 	struct range *range = &dev_dax->ranges[i].range;
 	struct dax_region *dax_region = dev_dax->region;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 	dev_dbg(&dev_dax->dev, "delete range[%d]: %#llx:%#llx\n", i,
 		(unsigned long long)range->start,
 		(unsigned long long)range->end);
@@ -507,7 +507,7 @@ static int __free_dev_dax_id(struct dev_dax *dev_dax)
 	struct dax_region *dax_region;
 	int rc = dev_dax->id;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_dev_rwsem));
+	lockdep_assert_held_write(&dax_dev_rwsem);
 
 	if (!dev_dax->dyn_id || dev_dax->id < 0)
 		return -1;
@@ -713,7 +713,7 @@ static void __unregister_dax_mapping(void *data)
 
 	dev_dbg(dev, "%s\n", __func__);
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	dev_dax->ranges[mapping->range_id].mapping = NULL;
 	mapping->range_id = -1;
@@ -830,7 +830,7 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
 	struct device *dev;
 	int rc;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	if (dev_WARN_ONCE(&dev_dax->dev, !dax_region->dev->driver,
 				"region disabled\n"))
@@ -876,7 +876,7 @@ static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
 	struct resource *alloc;
 	int i, rc;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	/* handle the seed alloc special case */
 	if (!size) {
@@ -935,7 +935,7 @@ static int adjust_dev_dax_range(struct dev_dax *dev_dax, struct resource *res, r
 	struct device *dev = &dev_dax->dev;
 	int rc;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	if (dev_WARN_ONCE(dev, !size, "deletion is handled by dev_dax_shrink\n"))
 		return -EINVAL;

-- 
2.44.0

