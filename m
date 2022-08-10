Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC734A09
	for <nvdimm@lists.linux.dev>; Wed, 10 Aug 2022 23:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660172976; x=1691708976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J6sYu8I0Yi7O8OuAuofBxCfGkDn8ldS/h+uwJKUswds=;
  b=WLKaF2HvgFZhsvrGUGJwfJQE6CaFzPnu3gRV8Ik1oG+DZGLELR2nYZ4G
   yBag0ZAkQptHuk4xq4h1EPKFpDwzduyki+KsJ3zKQ6sJNdd/tmbuWZbR7
   +4UATkDTANJNYXJeQ2ay/CqB4tSiMZzP+zvVl6e3rJIFamsbqCPrTKQP2
   jQEKgA/Qe8qOvT0rCmKQ3iKjg1pE8J/TptX7VKOu+kKUXh9bQtgherD6j
   +PfF2FxDZaYd5zOtYh+CmqUxn5gvtnLn/vxNXpUi24GBsreWy8Az3tJ8B
   /AwRDAEUDIhzb2Xa42oCCjo5lQGnzAMxiPFGNXPCYgO3Is0CxczxEZdAR
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="292005866"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="292005866"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 16:09:35 -0700
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="581429465"
Received: from maughenb-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.94.5])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 16:09:34 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 10/10] cxl/decoder: add a max_available_extent attribute
Date: Wed, 10 Aug 2022 17:09:14 -0600
Message-Id: <20220810230914.549611-11-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220810230914.549611-1-vishal.l.verma@intel.com>
References: <20220810230914.549611-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8248; h=from:subject; bh=J6sYu8I0Yi7O8OuAuofBxCfGkDn8ldS/h+uwJKUswds=; b=owGbwMvMwCXGf25diOft7jLG02pJDElfrGbe1bvZJd+p++qx2p6gZV3ltxqTws9t6Z+4um9z4OkY 8+XbO0pZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjARBUNGhmNNn4xerg9euLf6RZrtih evrsifmawSadDkovkiK6i/lY3hf92WJY7Pcub8q9F5J3Sm4PH6LysWhCyN2j1VTOaG2SGxEA4A
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a max_available_extent attribute to cxl_decoder. In order to aid in
its calculation, change the order of regions in the root decoder's list
to be sorted by start HPA of the region.

Additionally, emit this attribute in decoder listings, and consult it
for available space before creating a new region.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h  |  1 +
 cxl/lib/libcxl.c   | 86 +++++++++++++++++++++++++++++++++++++++++++++-
 cxl/libcxl.h       |  3 ++
 cxl/json.c         |  8 +++++
 cxl/region.c       | 14 +++++++-
 cxl/lib/libcxl.sym |  1 +
 6 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 8619bb1..8705e46 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -104,6 +104,7 @@ struct cxl_decoder {
 	u64 size;
 	u64 dpa_resource;
 	u64 dpa_size;
+	u64 max_available_extent;
 	void *dev_buf;
 	size_t buf_len;
 	char *dev_path;
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index b4d7890..3c1a2c3 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -446,6 +446,11 @@ CXL_EXPORT int cxl_region_delete(struct cxl_region *region)
 	return 0;
 }
 
+static int region_start_cmp(struct cxl_region *r1, struct cxl_region *r2)
+{
+	return ((r1->start < r2->start) ? -1 : 1);
+}
+
 static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 {
 	const char *devname = devpath_to_devname(cxlregion_base);
@@ -528,7 +533,7 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 			return region_dup;
 		}
 
-	list_add(&decoder->regions, &region->list);
+	list_add_sorted(&decoder->regions, region, list, region_start_cmp);
 
 	return region;
 err:
@@ -1606,6 +1611,74 @@ cxl_endpoint_get_memdev(struct cxl_endpoint *endpoint)
 	return NULL;
 }
 
+static int cxl_region_is_configured(struct cxl_region *region)
+{
+	if ((region->start == 0) && (region->size == 0) &&
+	    (region->decode_state == CXL_DECODE_RESET))
+		return 0;
+	return 1;
+}
+
+/**
+ * cxl_decoder_calc_max_available_extent() - calculate max available free space
+ * @decoder - the root decoder to calculate the free extents for
+ *
+ * The add_cxl_region() function  adds regions to the parent decoder's list
+ * sorted by the region's start HPAs. It can also be assumed that regions have
+ * no overlapped / aliased HPA space. Therefore, calculating each extent is as
+ * simple as walking the region list in order, and subtracting the previous
+ * region's end HPA from the next region's start HPA (and taking into account
+ * the decoder's start and end HPAs as well).
+ */
+static unsigned long long
+cxl_decoder_calc_max_available_extent(struct cxl_decoder *decoder)
+{
+	struct cxl_port *port = cxl_decoder_get_port(decoder);
+	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
+	u64 prev_end = 0, max_extent = 0;
+	struct cxl_region *region;
+
+	if (!cxl_port_is_root(port)) {
+		err(ctx, "%s: not a root decoder\n",
+		    cxl_decoder_get_devname(decoder));
+		return ULLONG_MAX;
+	}
+
+	/*
+	 * Preload prev_end with decoder's start, so that the extent
+	 * calculation for the first region Just Works
+	 */
+	prev_end = decoder->start;
+
+	cxl_region_foreach(decoder, region) {
+		if (!cxl_region_is_configured(region))
+			continue;
+
+		/*
+		 * Note: Normally, end = (start + size - 1), but since
+		 * this is calculating extents between regions, it can
+		 * skip the '- 1'. For example, if a region ends at 0xfff,
+		 * and the next region immediately starts at 0x1000,
+		 * the 'extent' between them is 0, not 1. With
+		 * end = (start + size), this new 'adjusted' end for the
+		 * first region will have been calculated as 0x1000.
+		 * Subtracting the next region's start (0x1000) from this
+		 * correctly gets the extent size as 0.
+		 */
+		max_extent = max(max_extent, region->start - prev_end);
+		prev_end = region->start + region->size;
+	}
+
+	/*
+	 * Finally, consider the extent after the last region, up to the end
+	 * of the decoder's address space, if any. If there were no regions,
+	 * this simply reduces to decoder->size.
+	 */
+	max_extent = max(max_extent, decoder->start + decoder->size - prev_end);
+
+	return max_extent;
+}
+
 static int decoder_id_cmp(struct cxl_decoder *d1, struct cxl_decoder *d2)
 {
 	return d1->id - d2->id;
@@ -1735,6 +1808,8 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 			if (sysfs_read_attr(ctx, path, buf) == 0)
 				*(flag->flag) = !!strtoul(buf, NULL, 0);
 		}
+		decoder->max_available_extent =
+			cxl_decoder_calc_max_available_extent(decoder);
 		break;
 	}
 	}
@@ -1899,6 +1974,12 @@ cxl_decoder_get_dpa_size(struct cxl_decoder *decoder)
 	return decoder->dpa_size;
 }
 
+CXL_EXPORT unsigned long long
+cxl_decoder_get_max_available_extent(struct cxl_decoder *decoder)
+{
+	return decoder->max_available_extent;
+}
+
 CXL_EXPORT int cxl_decoder_set_dpa_size(struct cxl_decoder *decoder,
 					unsigned long long size)
 {
@@ -2053,6 +2134,9 @@ cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
 		return NULL;
 	}
 
+	/* Force a re-init of regions so that the new one can be discovered */
+	free_regions(decoder);
+
 	/* create_region was successful, walk to the new region */
 	cxl_region_foreach(decoder, region) {
 		const char *devname = cxl_region_get_devname(region);
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 0b84977..6a23238 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -133,6 +133,9 @@ unsigned long long cxl_decoder_get_resource(struct cxl_decoder *decoder);
 unsigned long long cxl_decoder_get_size(struct cxl_decoder *decoder);
 unsigned long long cxl_decoder_get_dpa_resource(struct cxl_decoder *decoder);
 unsigned long long cxl_decoder_get_dpa_size(struct cxl_decoder *decoder);
+unsigned long long
+cxl_decoder_get_max_available_extent(struct cxl_decoder *decoder);
+
 enum cxl_decoder_mode {
 	CXL_DECODER_MODE_NONE,
 	CXL_DECODER_MODE_MIXED,
diff --git a/cxl/json.c b/cxl/json.c
index ad93413..28d9936 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -499,6 +499,14 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 	}
 
 	if (cxl_port_is_root(port) && cxl_decoder_is_mem_capable(decoder)) {
+		size = cxl_decoder_get_max_available_extent(decoder);
+		if (size < ULLONG_MAX) {
+			jobj = util_json_object_hex(size, flags);
+			if (jobj)
+				json_object_object_add(jdecoder,
+						       "max_available_extent",
+						       jobj);
+		}
 		if (cxl_decoder_is_pmem_capable(decoder)) {
 			jobj = json_object_new_boolean(true);
 			if (jobj)
diff --git a/cxl/region.c b/cxl/region.c
index 3f83dd4..cc0f8bc 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -468,9 +468,9 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 	struct json_object *jregion;
 	unsigned int i, granularity;
 	struct cxl_region *region;
+	u64 size, max_extent;
 	const char *devname;
 	uuid_t uuid;
-	u64 size;
 	int rc;
 
 	rc = create_region_validate_config(ctx, p);
@@ -485,6 +485,18 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 		log_err(&rl, "%s: unable to determine region size\n", __func__);
 		return -ENXIO;
 	}
+	max_extent = cxl_decoder_get_max_available_extent(p->root_decoder);
+	if (max_extent == ULLONG_MAX) {
+		log_err(&rl, "%s: unable to determine max extent\n",
+			cxl_decoder_get_devname(p->root_decoder));
+		return -EINVAL;
+	}
+	if (size > max_extent) {
+		log_err(&rl,
+			"%s: region size %#lx exceeds max available space\n",
+			cxl_decoder_get_devname(p->root_decoder), size);
+		return -ENOSPC;
+	}
 
 	if (p->mode == CXL_DECODER_MODE_PMEM) {
 		region = cxl_decoder_create_pmem_region(p->root_decoder);
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 6bf3e91..454bfeb 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -213,4 +213,5 @@ global:
 	cxl_ep_decoder_get_memdev;
 	cxl_decoder_get_interleave_granularity;
 	cxl_decoder_get_interleave_ways;
+	cxl_decoder_get_max_available_extent;
 } LIBCXL_2;
-- 
2.37.1

