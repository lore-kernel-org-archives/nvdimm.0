Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7397030FA7
	for <nvdimm@lists.linux.dev>; Tue, 19 Sep 2023 23:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695167550; x=1726703550;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=37L/MlNcYtMxuHg0ZEF1Lu/hFaYYcERlvMSwjX73R/U=;
  b=EMHYWJzQ/djvIuvMURaruOsZHHwyh9SLbYJHsEzevjrsJ+6Imvb+edzH
   TjfMp0eaqm8WbMupf1pMVO1xQT2CObuGLjEqHlkcYHUHZMLI+poMrvlPX
   2DNgHiMf9VX9kAWWjjj4xyFpXVniNv8iKNc4+bZ3OySK/2/+lxrG8TlDc
   kukFud8sGk5cO/EK4XUUeHNmd2mMavcSmdZ2LmofFEh4V3gujtLVp7T9x
   za+V+o/+ZVdsj1/nWOmqv4IryUHcCt/6YTsMuSF0CruPCjRFCd1eJUP2p
   oNd/62aRmelBZVRiGHdkHkylMrmth7B8cXU7pRyDBjAi1weTSVPtiErd9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="359470141"
X-IronPort-AV: E=Sophos;i="6.02,160,1688454000"; 
   d="scan'208";a="359470141"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2023 16:52:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="749671811"
X-IronPort-AV: E=Sophos;i="6.02,160,1688454000"; 
   d="scan'208";a="749671811"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.212.121.236])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2023 16:52:29 -0700
Subject: [NDCTL PATCH] cxl/region: Add -f option for disable-region
From: Dave Jiang <dave.jiang@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Tue, 19 Sep 2023 16:52:28 -0700
Message-ID: <169516754868.2998393.297443133671590500.stgit@djiang5-mobl3>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The current operation for disable_region does not check if the memory
covered by a region is online before attempting to disable the cxl region.
Provide a -f option for the region to force offlining of currently online
memory before disabling the region. Also add a check to fail the operation
entirely if the memory is non-movable.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/cxl/cxl-disable-region.txt |    5 +++
 cxl/region.c                             |   49 +++++++++++++++++++++++++++++-
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/Documentation/cxl/cxl-disable-region.txt b/Documentation/cxl/cxl-disable-region.txt
index 6a39aee6ea69..1778ec3a0f3f 100644
--- a/Documentation/cxl/cxl-disable-region.txt
+++ b/Documentation/cxl/cxl-disable-region.txt
@@ -25,6 +25,11 @@ OPTIONS
 -------
 include::bus-option.txt[]
 
+-f::
+--force::
+	Force offline of memory if they are online before disabling the active
+	region. This does not allow offline of unmovable memory.
+
 include::decoder-option.txt[]
 
 include::debug-option.txt[]
diff --git a/cxl/region.c b/cxl/region.c
index bcd703956207..79a5fb81c257 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -14,6 +14,7 @@
 #include <util/parse-options.h>
 #include <ccan/minmax/minmax.h>
 #include <ccan/short_types/short_types.h>
+#include <daxctl/libdaxctl.h>
 
 #include "filter.h"
 #include "json.h"
@@ -95,6 +96,8 @@ static const struct option enable_options[] = {
 
 static const struct option disable_options[] = {
 	BASE_OPTIONS(),
+	OPT_BOOLEAN('f', "force", &param.force,
+		    "disable region even if memory currently online"),
 	OPT_END(),
 };
 
@@ -789,13 +792,57 @@ static int destroy_region(struct cxl_region *region)
 	return cxl_region_delete(region);
 }
 
+static int disable_region(struct cxl_region *region)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct daxctl_region *dax_region;
+	struct daxctl_memory *mem;
+	struct daxctl_dev *dev;
+	int rc;
+
+	dax_region = cxl_region_get_daxctl_region(region);
+	if (!dax_region)
+		goto out;
+
+	daxctl_dev_foreach(dax_region, dev) {
+		mem = daxctl_dev_get_memory(dev);
+		if (!mem)
+			return -ENXIO;
+
+		if (daxctl_memory_online_no_movable(mem)) {
+			log_err(&rl, "%s: memory unmovable for %s\n",
+					devname,
+					daxctl_dev_get_devname(dev));
+			return -EPERM;
+		}
+
+		/*
+		 * If memory is still online and user wants to force it, attempt
+		 * to offline it.
+		 */
+		if (daxctl_memory_is_online(mem) && param.force) {
+			rc = daxctl_memory_offline(mem);
+			if (rc) {
+				log_err(&rl, "%s: unable to offline %s: %s\n",
+					devname,
+					daxctl_dev_get_devname(dev),
+					strerror(abs(rc)));
+				return rc;
+			}
+		}
+	}
+
+out:
+	return cxl_region_disable(region);
+}
+
 static int do_region_xable(struct cxl_region *region, enum region_actions action)
 {
 	switch (action) {
 	case ACTION_ENABLE:
 		return cxl_region_enable(region);
 	case ACTION_DISABLE:
-		return cxl_region_disable(region);
+		return disable_region(region);
 	case ACTION_DESTROY:
 		return destroy_region(region);
 	default:


