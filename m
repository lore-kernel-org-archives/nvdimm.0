Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15C22F32;
	Wed, 13 Apr 2022 18:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649875093; x=1681411093;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Aw4BdmJs9nutTAxQq4LYU5ScJx7qqBCM2l7xDnAPCjc=;
  b=bFMWwwT7lHtmgaUDDkNUWzaG8E82cRMk/wVgeo2DdqFmIxCmuMa2ob70
   MuB+P6ZaA+DWqbiVaOoiWF/z3RMxvKC94ZdcplH6Ftl/Nb3gK+4QQF/5h
   Bq5DQ+mUyXHRcnZClv2yOJqH4JqbplEXBMeTDnz/E6JJpKoklzqdm95+B
   fx+EtdN1yknZgM6oTTerp2uKI7LUeHw+3AFfAptSMpbTUDX/545WPqa05
   o/4FbzmUBwcRXLsbClgletCEb+UreLeYmI415Pgoz6LtThAyoCM+vxEa6
   8+AvCW3ELpZfwcmCLGUpneol9z0FM6hxFHlW1/ccz3V3jL+jurjcEMBQT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="244631841"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="244631841"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:48 -0700
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="725013573"
Received: from sushobhi-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.131.238])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:48 -0700
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
Subject: [RFC PATCH 03/15] Revert "cxl/core: Convert decoder range to resource"
Date: Wed, 13 Apr 2022 11:37:08 -0700
Message-Id: <20220413183720.2444089-4-ben.widawsky@intel.com>
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

This reverts commit 608135db1b790170d22848815c4671407af74e37. All
decoders do have a host physical address space and the revert allows us
to keep that uniformity. Decoder disambiguation will allow for decoder
type-specific members which is needed, but will be handled separately.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>

---
The explanation for why it is impossible to make CFMWS ranges be
iomem_resources is explain in a later patch.
---
 drivers/cxl/acpi.c      | 17 ++++++++++-------
 drivers/cxl/core/hdm.c  |  2 +-
 drivers/cxl/core/port.c | 28 ++++++----------------------
 drivers/cxl/cxl.h       |  8 ++------
 4 files changed, 19 insertions(+), 36 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index d15a6aec0331..9b69955b90cb 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -108,8 +108,10 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
 
 	cxld->flags = cfmws_to_decoder_flags(cfmws->restrictions);
 	cxld->target_type = CXL_DECODER_EXPANDER;
-	cxld->platform_res = (struct resource)DEFINE_RES_MEM(cfmws->base_hpa,
-							     cfmws->window_size);
+	cxld->range = (struct range){
+		.start = cfmws->base_hpa,
+		.end = cfmws->base_hpa + cfmws->window_size - 1,
+	};
 	cxld->interleave_ways = CFMWS_INTERLEAVE_WAYS(cfmws);
 	cxld->interleave_granularity = CFMWS_INTERLEAVE_GRANULARITY(cfmws);
 
@@ -119,13 +121,14 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
 	else
 		rc = cxl_decoder_autoremove(dev, cxld);
 	if (rc) {
-		dev_err(dev, "Failed to add decoder for %pr\n",
-			&cxld->platform_res);
+		dev_err(dev, "Failed to add decoder for %#llx-%#llx\n",
+			cfmws->base_hpa,
+			cfmws->base_hpa + cfmws->window_size - 1);
 		return 0;
 	}
-	dev_dbg(dev, "add: %s node: %d range %pr\n", dev_name(&cxld->dev),
-		phys_to_target_node(cxld->platform_res.start),
-		&cxld->platform_res);
+	dev_dbg(dev, "add: %s node: %d range %#llx-%#llx\n",
+		dev_name(&cxld->dev), phys_to_target_node(cxld->range.start),
+		cfmws->base_hpa, cfmws->base_hpa + cfmws->window_size - 1);
 
 	return 0;
 }
diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index c3c021b54079..3055e246aab9 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -172,7 +172,7 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 		return -ENXIO;
 	}
 
-	cxld->decoder_range = (struct range) {
+	cxld->range = (struct range) {
 		.start = base,
 		.end = base + size - 1,
 	};
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 74c8e47bf915..86f451ecb7ed 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -73,14 +73,8 @@ static ssize_t start_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
 	struct cxl_decoder *cxld = to_cxl_decoder(dev);
-	u64 start;
 
-	if (is_root_decoder(dev))
-		start = cxld->platform_res.start;
-	else
-		start = cxld->decoder_range.start;
-
-	return sysfs_emit(buf, "%#llx\n", start);
+	return sysfs_emit(buf, "%#llx\n", cxld->range.start);
 }
 static DEVICE_ATTR_ADMIN_RO(start);
 
@@ -88,14 +82,8 @@ static ssize_t size_show(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
 	struct cxl_decoder *cxld = to_cxl_decoder(dev);
-	u64 size;
 
-	if (is_root_decoder(dev))
-		size = resource_size(&cxld->platform_res);
-	else
-		size = range_len(&cxld->decoder_range);
-
-	return sysfs_emit(buf, "%#llx\n", size);
+	return sysfs_emit(buf, "%#llx\n", range_len(&cxld->range));
 }
 static DEVICE_ATTR_RO(size);
 
@@ -1228,7 +1216,10 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
 	cxld->interleave_ways = 1;
 	cxld->interleave_granularity = PAGE_SIZE;
 	cxld->target_type = CXL_DECODER_EXPANDER;
-	cxld->platform_res = (struct resource)DEFINE_RES_MEM(0, 0);
+	cxld->range = (struct range) {
+		.start = 0,
+		.end = -1,
+	};
 
 	return cxld;
 err:
@@ -1342,13 +1333,6 @@ int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map)
 	if (rc)
 		return rc;
 
-	/*
-	 * Platform decoder resources should show up with a reasonable name. All
-	 * other resources are just sub ranges within the main decoder resource.
-	 */
-	if (is_root_decoder(dev))
-		cxld->platform_res.name = dev_name(dev);
-
 	return device_add(dev);
 }
 EXPORT_SYMBOL_NS_GPL(cxl_decoder_add_locked, CXL);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 5102491e8d13..6517d5cdf5ee 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -197,8 +197,7 @@ enum cxl_decoder_type {
  * struct cxl_decoder - CXL address range decode configuration
  * @dev: this decoder's device
  * @id: kernel device name id
- * @platform_res: address space resources considered by root decoder
- * @decoder_range: address space resources considered by midlevel decoder
+ * @range: address range considered by this decoder
  * @interleave_ways: number of cxl_dports in this decode
  * @interleave_granularity: data stride per dport
  * @target_type: accelerator vs expander (type2 vs type3) selector
@@ -210,10 +209,7 @@ enum cxl_decoder_type {
 struct cxl_decoder {
 	struct device dev;
 	int id;
-	union {
-		struct resource platform_res;
-		struct range decoder_range;
-	};
+	struct range range;
 	int interleave_ways;
 	int interleave_granularity;
 	enum cxl_decoder_type target_type;
-- 
2.35.1

