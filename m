Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31452C80;
	Wed, 13 Apr 2022 18:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649875092; x=1681411092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xCFUJR0nc5jPOvEXzPtBuiu7iwfD2xyQ9QD7Fv5gBes=;
  b=ilMFh4nNhe9o782EUk5hmcJO8x1dz5kJD/sDPJW787WeXYF898h/JBZR
   gSTn5zVHFPQkwBCRG/IgFKgCNjkz51DtBfdtpFXMAk1lGxC4eBxi9seZT
   3lV2V+6e8h3c0J56WfdkEWsUIf5IJLZRnbvpMHHzqx/atzNVtMinAl2R+
   sS2yy9uBGdqJ4Scj4c4thrwATLrcYX3y372K1JmRETrgPQlMd/61B+KWj
   MByLGyCwHgX/kF1euy2/l/FmH3CDawk6gG5ZhZzZdXvcjvSOAJHLDwccz
   hWwHgmzF0+PpQznnAaWkPbC5DrDBZj+D5YoafMfDgCSCZRfc2u5t3epVY
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="244631845"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="244631845"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:49 -0700
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="725013590"
Received: from sushobhi-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.131.238])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:49 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 06/15] cxl/acpi: Manage root decoder's address space
Date: Wed, 13 Apr 2022 11:37:11 -0700
Message-Id: <20220413183720.2444089-7-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413183720.2444089-1-ben.widawsky@intel.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use a gen_pool to manage the physical address space that is routed by
the platform decoder (root decoder). As described in 'cxl/acpi: Resereve
CXL resources from request_free_mem_region' the address space does not
coexist well if part of all of it is conveyed in the memory map to the
kernel.

Since the existing resource APIs of interest all rely on the root
decoder's address space being in iomem_resource, the choices are to roll
a new allocator because on struct resource, or use gen_pool. gen_pool is
a good choice because it already has all the capabilities needed to
satisfy CXL programming.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/acpi.c | 36 ++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h  |  2 ++
 2 files changed, 38 insertions(+)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 0870904fe4b5..a6b0c3181d0e 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2021 Intel Corporation. All rights reserved. */
 #include <linux/platform_device.h>
+#include <linux/genalloc.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -79,6 +80,25 @@ struct cxl_cfmws_context {
 	struct acpi_cedt_cfmws *high_cfmws;
 };
 
+static int cfmws_cookie;
+
+static int fill_busy_mem(struct resource *res, void *_window)
+{
+	struct gen_pool *window = _window;
+	struct genpool_data_fixed gpdf;
+	unsigned long addr;
+	void *type;
+
+	gpdf.offset = res->start;
+	addr = gen_pool_alloc_algo_owner(window, resource_size(res),
+					 gen_pool_fixed_alloc, &gpdf, &type);
+	if (addr != res->start || (res->start == 0 && type != &cfmws_cookie))
+		return -ENXIO;
+
+	pr_devel("%pR removed from CFMWS\n", res);
+	return 0;
+}
+
 static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
 			   const unsigned long end)
 {
@@ -88,6 +108,8 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
 	struct device *dev = ctx->dev;
 	struct acpi_cedt_cfmws *cfmws;
 	struct cxl_decoder *cxld;
+	struct gen_pool *window;
+	char name[64];
 	int rc, i;
 
 	cfmws = (struct acpi_cedt_cfmws *) header;
@@ -116,6 +138,20 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
 	cxld->interleave_ways = CFMWS_INTERLEAVE_WAYS(cfmws);
 	cxld->interleave_granularity = CFMWS_INTERLEAVE_GRANULARITY(cfmws);
 
+	sprintf(name, "cfmws@%#llx", cfmws->base_hpa);
+	window = devm_gen_pool_create(dev, ilog2(SZ_256M), NUMA_NO_NODE, name);
+	if (IS_ERR(window))
+		return 0;
+
+	gen_pool_add_owner(window, cfmws->base_hpa, -1, cfmws->window_size,
+			   NUMA_NO_NODE, &cfmws_cookie);
+
+	/* Area claimed by other resources, remove those from the gen_pool. */
+	walk_iomem_res_desc(IORES_DESC_NONE, 0, cfmws->base_hpa,
+			    cfmws->base_hpa + cfmws->window_size - 1, window,
+			    fill_busy_mem);
+	to_cxl_root_decoder(cxld)->window = window;
+
 	rc = cxl_decoder_add(cxld, target_map);
 	if (rc)
 		put_device(&cxld->dev);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 85fd5e84f978..0e1c65761ead 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -246,10 +246,12 @@ struct cxl_switch_decoder {
 /**
  * struct cxl_root_decoder - A toplevel/platform decoder
  * @base: Base class decoder
+ * @window: host address space allocator
  * @targets: Downstream targets (ie. hostbridges).
  */
 struct cxl_root_decoder {
 	struct cxl_decoder base;
+	struct gen_pool *window;
 	struct cxl_decoder_targets *targets;
 };
 
-- 
2.35.1

