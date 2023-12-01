Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403B96AA2
	for <nvdimm@lists.linux.dev>; Fri,  1 Dec 2023 04:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OFcl/nvS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701403578; x=1732939578;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=+g0XwpImUMv/l1eKPhrRYceq1i1i23dKJpdPqyh7l6Y=;
  b=OFcl/nvS2AeyP8klBTKbAQbpuO2lsXLfnwUe/RprFTmS7KT0Q2AjUrSb
   hsFKzcMTAKxLYHRC5BEUR50Yon6lOo2CjjQdQTbyiB1AltKdBQnm+0jUj
   GKd8KWD7ERvtjt5XDdc3j7Y6RkIluCTT2Vi8nAzqLBZmc0QTc051ogll4
   Tt24tWFq/hdNVvR91bKq2CucwSICLe2YIKXzZjfzv8OsgfLXazjTKDcdy
   V+jO6fe352RbXNVk9l51e1idYYgK1fuMS39kQpNLctuI1qisDHl8rfi6h
   JQLwSCA3xQqnfapmW9NSa7mINcf+07fkg4izihSMxMlkvGPwK+vdgKPL/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="433268"
X-IronPort-AV: E=Sophos;i="6.04,240,1695711600"; 
   d="scan'208";a="433268"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 20:06:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="769540364"
X-IronPort-AV: E=Sophos;i="6.04,240,1695711600"; 
   d="scan'208";a="769540364"
Received: from iweiny-desk3.amr.corp.intel.com (HELO localhost) ([10.212.102.178])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 20:06:15 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Thu, 30 Nov 2023 20:06:14 -0800
Subject: [PATCH ndctl RESEND 2/2] cxl/region: Fix memory device teardown in
 disable-region
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-fix-region-destroy-v1-2-7f916d2bd379@intel.com>
References: <20231130-fix-region-destroy-v1-0-7f916d2bd379@intel.com>
In-Reply-To: <20231130-fix-region-destroy-v1-0-7f916d2bd379@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.13-dev-0f7f0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1701403573; l=2983;
 i=ira.weiny@intel.com; s=20221222; h=from:subject:message-id;
 bh=+g0XwpImUMv/l1eKPhrRYceq1i1i23dKJpdPqyh7l6Y=;
 b=6RQH3trDu6Vqg00dg01jtmEBge6ZXp0Usglc6szQ0I/RozJRfvK1EbadE23RNon24ifIh/Cyo
 tpMzABaweBpA/fPZOMJlkXHdYfvb1s6KmU+RBuAtiLbhSIN1W6jqd5Y
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=brwqReAJklzu/xZ9FpSsMPSQ/qkSalbg6scP3w809Ec=

When a region is requested to be disabled, memory devices are normally
automatically torn down.  Commit 9399aa667ab0 prevents tear down if
memory is online without a force flag.  However, daxctl_dev_get_memory()
may return NULL if the memory device in question is not system-ram
capable as is the case for a region with only devdax devices.  Such
devices do not need to be off-lined explicitly.

Skip non-system-ram devices rather than error the operation.

Fixes: 9399aa667ab0 ("cxl/region: Add -f option for disable-region")
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 cxl/region.c             | 3 +++
 daxctl/lib/libdaxctl.c   | 4 ++--
 daxctl/lib/libdaxctl.sym | 5 +++++
 daxctl/libdaxctl.h       | 1 +
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/cxl/region.c b/cxl/region.c
index 5cbbf2749e2d..44ac76b001e9 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -805,6 +805,9 @@ static int disable_region(struct cxl_region *region)
 		goto out;
 
 	daxctl_dev_foreach(dax_region, dev) {
+		if (!daxctl_dev_is_system_ram_capable(dev))
+			continue;
+
 		mem = daxctl_dev_get_memory(dev);
 		if (!mem)
 			return -ENXIO;
diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 4f9aba0b09f2..9fbefe2e8329 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -385,7 +385,7 @@ static bool device_model_is_dax_bus(struct daxctl_dev *dev)
 	return false;
 }
 
-static int dev_is_system_ram_capable(struct daxctl_dev *dev)
+DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev)
 {
 	const char *devname = daxctl_dev_get_devname(dev);
 	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
@@ -432,7 +432,7 @@ static struct daxctl_memory *daxctl_dev_alloc_mem(struct daxctl_dev *dev)
 	char buf[SYSFS_ATTR_SIZE];
 	int node_num;
 
-	if (!dev_is_system_ram_capable(dev))
+	if (!daxctl_dev_is_system_ram_capable(dev))
 		return NULL;
 
 	mem = calloc(1, sizeof(*mem));
diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
index fe68fd0a9cde..309881196c86 100644
--- a/daxctl/lib/libdaxctl.sym
+++ b/daxctl/lib/libdaxctl.sym
@@ -99,3 +99,8 @@ global:
 	daxctl_set_config_path;
 	daxctl_get_config_path;
 } LIBDAXCTL_8;
+
+LIBDAXCTL_10 {
+global:
+	daxctl_dev_is_system_ram_capable;
+} LIBDAXCTL_9;
diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index 6876037a9427..53c6bbdae5c3 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -77,6 +77,7 @@ int daxctl_dev_will_auto_online_memory(struct daxctl_dev *dev);
 int daxctl_dev_has_online_memory(struct daxctl_dev *dev);
 
 struct daxctl_memory;
+int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev);
 struct daxctl_memory *daxctl_dev_get_memory(struct daxctl_dev *dev);
 struct daxctl_dev *daxctl_memory_get_dev(struct daxctl_memory *mem);
 const char *daxctl_memory_get_node_path(struct daxctl_memory *mem);

-- 
2.42.0

