Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00DF48CDD
	for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 23:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d2Q/Yp1b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701129212; x=1732665212;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qqAfNMp92I6ASYtxhZ9kLQY7o3M3BhohJNX5mW9YtdE=;
  b=d2Q/Yp1biTCIB7Y5cywfesolhjzWz+VBd4W/sXpMJFOPdDWyAfcHUw5L
   CnhTO69WASf2//q7oqppoeRPT/z+8wVWaF1W2YVzu83AMFABnzNC6yBD1
   KA6Omf5jFYGK9XscCsFfwumeRpxmXI9hfOqywyVjWuQ4RCMxXUyEsWUOL
   k1LsGMnzYnHBxa+ypgfcCaXksX1lw2R17+L8fLBzE1yJWF966rKWOWXCY
   m5/cRXylB9KDiZ6I5RdT5/ux3uDCW+ZDLQ7tBroy9/b8fqPuAHTFLVk7N
   drNlBkAsxn2BcNDNwXcYeLHC2vWwTlDMFTmkMM+UIg4OtsEreTbKES67q
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="377843964"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="377843964"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 15:53:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="912245331"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="912245331"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.212.115.112])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 15:53:31 -0800
Subject: [NDCTL PATCH] cxl/region: Move cxl destroy_region() to new
 disable_region() helper
From: Dave Jiang <dave.jiang@intel.com>
To: vishal.l.verma@intel.com
Cc: Quanquan Cao <caoqq@fujitsu.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, caoqq@fujitsu.com
Date: Mon, 27 Nov 2023 16:53:31 -0700
Message-ID: <170112921107.2687457.2741231995154639197.stgit@djiang5-mobl3>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

To keep the behavior consistent with the disable region operation, change
the calling of cxl_region_disable() directly in destroy_region() to the
new disable_region() helper in order to check whether the region is still
online.

Suggested-by: Quanquan Cao <caoqq@fujitsu.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/region.c |  100 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff --git a/cxl/region.c b/cxl/region.c
index 5cbbf2749e2d..4091ee8d2713 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -728,6 +728,55 @@ out:
 	return rc;
 }
 
+static int disable_region(struct cxl_region *region)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct daxctl_region *dax_region;
+	struct daxctl_memory *mem;
+	struct daxctl_dev *dev;
+	int failed = 0, rc;
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
+		/*
+		 * If memory is still online and user wants to force it, attempt
+		 * to offline it.
+		 */
+		if (daxctl_memory_is_online(mem)) {
+			rc = daxctl_memory_offline(mem);
+			if (rc < 0) {
+				log_err(&rl, "%s: unable to offline %s: %s\n",
+					devname,
+					daxctl_dev_get_devname(dev),
+					strerror(abs(rc)));
+				if (!param.force)
+					return rc;
+
+				failed++;
+			}
+		}
+	}
+
+	if (failed) {
+		log_err(&rl, "%s: Forcing region disable without successful offline.\n",
+			devname);
+		log_err(&rl, "%s: Physical address space has now been permanently leaked.\n",
+			devname);
+		log_err(&rl, "%s: Leaked address cannot be recovered until a reboot.\n",
+			devname);
+	}
+
+out:
+	return cxl_region_disable(region);
+}
+
 static int destroy_region(struct cxl_region *region)
 {
 	const char *devname = cxl_region_get_devname(region);
@@ -737,7 +786,7 @@ static int destroy_region(struct cxl_region *region)
 	/* First, unbind/disable the region if needed */
 	if (cxl_region_is_enabled(region)) {
 		if (param.force) {
-			rc = cxl_region_disable(region);
+			rc = disable_region(region);
 			if (rc) {
 				log_err(&rl, "%s: error disabling region: %s\n",
 					devname, strerror(-rc));
@@ -792,55 +841,6 @@ static int destroy_region(struct cxl_region *region)
 	return cxl_region_delete(region);
 }
 
-static int disable_region(struct cxl_region *region)
-{
-	const char *devname = cxl_region_get_devname(region);
-	struct daxctl_region *dax_region;
-	struct daxctl_memory *mem;
-	struct daxctl_dev *dev;
-	int failed = 0, rc;
-
-	dax_region = cxl_region_get_daxctl_region(region);
-	if (!dax_region)
-		goto out;
-
-	daxctl_dev_foreach(dax_region, dev) {
-		mem = daxctl_dev_get_memory(dev);
-		if (!mem)
-			return -ENXIO;
-
-		/*
-		 * If memory is still online and user wants to force it, attempt
-		 * to offline it.
-		 */
-		if (daxctl_memory_is_online(mem)) {
-			rc = daxctl_memory_offline(mem);
-			if (rc < 0) {
-				log_err(&rl, "%s: unable to offline %s: %s\n",
-					devname,
-					daxctl_dev_get_devname(dev),
-					strerror(abs(rc)));
-				if (!param.force)
-					return rc;
-
-				failed++;
-			}
-		}
-	}
-
-	if (failed) {
-		log_err(&rl, "%s: Forcing region disable without successful offline.\n",
-			devname);
-		log_err(&rl, "%s: Physical address space has now been permanently leaked.\n",
-			devname);
-		log_err(&rl, "%s: Leaked address cannot be recovered until a reboot.\n",
-			devname);
-	}
-
-out:
-	return cxl_region_disable(region);
-}
-
 static int do_region_xable(struct cxl_region *region, enum region_actions action)
 {
 	switch (action) {


