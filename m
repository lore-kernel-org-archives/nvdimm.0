Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8EF539C
	for <nvdimm@lists.linux.dev>; Mon, 15 Aug 2022 19:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660591346; x=1692127346;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WDNXlB354Po247leSI7+Prye1anfCbOBQGC3r3VATvY=;
  b=dj+oymRMz6aeANe6bFCbHIEMhWI2tNFkouJ04O61S+Uy1SVjNtFCapAZ
   QU2nJFyRreJN/QzW+cb7Wwlv4YH/KqvbCB/s3Yzl0dMFK7GxywjKCTNGr
   zpV/6c+dV+wd6inIaZjnXEL4OZtVRjwJzJAKNBt0yyFx3YdGYeqWrQ1yl
   FdTx7d0Jea7ZxY65qJ3DH8gT2Cw5836m5WwuJckEih6DRLB5QbWlvWLYY
   wNXT/tkzKi3qLsyXIElhhAY3FCyTGsN3ke2sd0VpyNWLZo/4MPa8RneIP
   nXNMepYemAqe+HPthT/K2dj86gyooe9fSVBGsksHtM5IWPmwgd6jf13ng
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="292038729"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="292038729"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:22 -0700
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="606758272"
Received: from smadiset-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.5.99])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:22 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 11/11] cxl/decoder: add a max_available_extent attribute
Date: Mon, 15 Aug 2022 13:22:14 -0600
Message-Id: <20220815192214.545800-12-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220815192214.545800-1-vishal.l.verma@intel.com>
References: <20220815192214.545800-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7823; h=from:subject; bh=WDNXlB354Po247leSI7+Prye1anfCbOBQGC3r3VATvY=; b=owGbwMvMwCXGf25diOft7jLG02pJDEm/5jzb+sp1C/vBJVtiFa3rHVWTfxYeEhWNUPvxdsPi3CoB 3RqpjlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEzkFy/DX9HTc690bT3w/9bGmHcNrw XXSeYLnFnzQKnBfyuzVZRew1NGhrXLnxobKCfWbS1i/t/he4gn+efx3qWhCf7Ttwcs1Tl0mQcA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a max_available_extent attribute to cxl_decoder. In order to aid in
its calculation, change the order of regions in the root decoder's list
to be sorted by start HPA of the region.

Additionally, emit this attribute in decoder listings, and consult it
for available space before creating a new region.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h  |  1 +
 cxl/lib/libcxl.c   | 84 +++++++++++++++++++++++++++++++++++++++++++++-
 cxl/libcxl.h       |  3 ++
 cxl/json.c         |  8 +++++
 cxl/region.c       | 14 +++++++-
 cxl/lib/libcxl.sym |  1 +
 6 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 8bc9620..437eade 100644
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
index 2b1cf7e..a40b0e6 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -455,6 +455,16 @@ CXL_EXPORT int cxl_region_delete(struct cxl_region *region)
 	return 0;
 }
 
+static int region_start_cmp(struct cxl_region *r1, struct cxl_region *r2)
+{
+	if (r1->start == r2->start)
+		return 0;
+	else if (r1->start < r2->start)
+		return -1;
+	else
+		return 1;
+}
+
 static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 {
 	const char *devname = devpath_to_devname(cxlregion_base);
@@ -539,7 +549,7 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 			break;
 		}
 
-	list_add(&decoder->regions, &region->list);
+	list_add_sorted(&decoder->regions, region, list, region_start_cmp);
 
 	return region;
 err:
@@ -1617,6 +1627,70 @@ cxl_endpoint_get_memdev(struct cxl_endpoint *endpoint)
 	return NULL;
 }
 
+static bool cxl_region_is_configured(struct cxl_region *region)
+{
+	return region->size && (region->decode_state != CXL_DECODE_RESET);
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
+	u64 prev_end, decoder_end, cur_extent, max_extent = 0;
+	struct cxl_port *port = cxl_decoder_get_port(decoder);
+	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
+	struct cxl_region *region;
+
+	if (!cxl_port_is_root(port)) {
+		err(ctx, "%s: not a root decoder\n",
+		    cxl_decoder_get_devname(decoder));
+		return ULLONG_MAX;
+	}
+
+	/*
+	 * Preload prev_end with an imaginary region that ends just before
+	 * the decoder's start, so that the extent calculation for the
+	 * first region Just Works
+	 */
+	prev_end = decoder->start - 1;
+
+	cxl_region_foreach(decoder, region) {
+		if (!cxl_region_is_configured(region))
+			continue;
+
+		/*
+		 * region->start - prev_end would get the difference in
+		 * addresses, but a difference of 1 in addresses implies
+		 * an extent of 0. Hence the '-1'.
+		 */
+		cur_extent = region->start - prev_end - 1;
+		max_extent = max(max_extent, cur_extent);
+		prev_end = region->start + region->size - 1;
+	}
+
+	/*
+	 * Finally, consider the extent after the last region, up to the end
+	 * of the decoder's address space, if any. If there were no regions,
+	 * this simply reduces to decoder->size.
+	 * Subtracting two addrs gets us a 'size' directly, no need for +/- 1.
+	 */
+	decoder_end = decoder->start + decoder->size - 1;
+	cur_extent = decoder_end - prev_end;
+	max_extent = max(max_extent, cur_extent);
+
+	return max_extent;
+}
+
 static int decoder_id_cmp(struct cxl_decoder *d1, struct cxl_decoder *d2)
 {
 	return d1->id - d2->id;
@@ -1747,6 +1821,8 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 			if (sysfs_read_attr(ctx, path, buf) == 0)
 				*(flag->flag) = !!strtoul(buf, NULL, 0);
 		}
+		decoder->max_available_extent =
+			cxl_decoder_calc_max_available_extent(decoder);
 		break;
 	}
 	}
@@ -1911,6 +1987,12 @@ cxl_decoder_get_dpa_size(struct cxl_decoder *decoder)
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
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 69d9c09..61c7fc4 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -134,6 +134,9 @@ unsigned long long cxl_decoder_get_resource(struct cxl_decoder *decoder);
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
index 9dc99df..9cec58b 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -499,6 +499,14 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 	}
 
 	if (cxl_port_is_root(port) && cxl_decoder_is_mem_capable(decoder)) {
+		size = cxl_decoder_get_max_available_extent(decoder);
+		if (size < ULLONG_MAX) {
+			jobj = util_json_object_size(size, flags);
+			if (jobj)
+				json_object_object_add(jdecoder,
+						       "max_available_extent",
+						       jobj);
+		}
 		if (cxl_decoder_is_pmem_capable(decoder)) {
 			jobj = json_object_new_boolean(true);
 			if (jobj)
diff --git a/cxl/region.c b/cxl/region.c
index b22d3c8..a30313c 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -438,9 +438,9 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 	struct json_object *jregion;
 	unsigned int i, granularity;
 	struct cxl_region *region;
+	u64 size, max_extent;
 	const char *devname;
 	uuid_t uuid;
-	u64 size;
 	int rc;
 
 	rc = create_region_validate_config(ctx, p);
@@ -455,6 +455,18 @@ static int create_region(struct cxl_ctx *ctx, int *count,
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
index cb23a0b..549f88d 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -213,4 +213,5 @@ global:
 	cxl_decoder_get_memdev;
 	cxl_decoder_get_interleave_granularity;
 	cxl_decoder_get_interleave_ways;
+	cxl_decoder_get_max_available_extent;
 } LIBCXL_2;
-- 
2.37.1

