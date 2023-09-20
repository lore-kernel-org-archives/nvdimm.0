Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6565623CF
	for <nvdimm@lists.linux.dev>; Wed, 20 Sep 2023 22:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695250668; x=1726786668;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QkC/y4/2NQg3uYm6BWWtgtb4APj7mQXM+aIwQ9VqJNk=;
  b=NzBf2JuepvwBuU0G/vZIHBQXS0AQrKnVnoa8YtQh8khB85mPvYYx3GK3
   cpcZku3IWSEyL/yvDmGeqncJRI8UaRjci2tGZPSWjsQkUkRAjK1sBiAGn
   C0597Y+oSpBWBj/lntBtApyBJzFYH/KJnx6iYnYfa6wB0gZatkcozX2EJ
   w/qznOdaYjB5y4/DE0hC6C7foxPPV/XXQSbjCyUQWpoC+FZ08opSUe9Km
   15UIn3HaXJYqQvyd+I06d4lHWN45GR65deLjXOKOA2rT0jnvilZUKnxc+
   2srDWDf5lnfV8kgpg/ukFQOL/sq4eXFBERTVhUZArBysaPg8Tf9g0r6+L
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="444462140"
X-IronPort-AV: E=Sophos;i="6.03,162,1694761200"; 
   d="scan'208";a="444462140"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2023 15:57:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="781905440"
X-IronPort-AV: E=Sophos;i="6.03,162,1694761200"; 
   d="scan'208";a="781905440"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.212.114.229])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2023 15:57:29 -0700
Subject: [NDCTL PATCH v2] cxl/region: Add -f option for disable-region
From: Dave Jiang <dave.jiang@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Wed, 20 Sep 2023 15:57:29 -0700
Message-ID: <169525064907.3085225.2583864429793298106.stgit@djiang5-mobl3>
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
v2:
- Update documentation and help output. (Vishal)
---
 Documentation/cxl/cxl-disable-region.txt |    7 ++++
 cxl/region.c                             |   49 +++++++++++++++++++++++++++++-
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/Documentation/cxl/cxl-disable-region.txt b/Documentation/cxl/cxl-disable-region.txt
index 6a39aee6ea69..9b98d4d8745a 100644
--- a/Documentation/cxl/cxl-disable-region.txt
+++ b/Documentation/cxl/cxl-disable-region.txt
@@ -25,6 +25,13 @@ OPTIONS
 -------
 include::bus-option.txt[]
 
+-f::
+--force::
+	Attempt to offline any memory that has been hot-added into the system
+	via the CXL region before disabling the region. This won't be attempted
+	if the memory was not added as 'movable', and may still fail even if it
+	was movable.
+
 include::decoder-option.txt[]
 
 include::debug-option.txt[]
diff --git a/cxl/region.c b/cxl/region.c
index bcd703956207..f8303869727a 100644
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
+		    "attempt to offline memory before disabling the region"),
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


