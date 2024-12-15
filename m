Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03298BE65
	for <nvdimm@lists.linux.dev>; Sun, 15 Dec 2024 02:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734231521; cv=none; b=j4aifwMhBRiF53pV87O5Q53IoVgEM7D6RWezSrbFixlRXtBqvlpnCJDf3UdVp98A7mLqu5p3riTJRAu0QB/laCCFKXDnOAOGnbw5aNo0PMZ3l0TnmFZu4WR7kyUevTv8JJW4sDgRfc47iZ1j1dYddcSueybzKywXDl/AdWfrPK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734231521; c=relaxed/simple;
	bh=xwh5QIFiEZatH/op9hzPR9Y0hPludvE5/P/bczp99iw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=W+FWQjToEsZ+3sknEdLj2ZvCDsK1YIhUsZb6LNoqURYYkQJ29T9lcFyuIvzjAP7fHxqwzZ2me1IdFjat5EeR3crVA9Y6D/EREjbQKG77hhXEvpkTxEUNukGejbxOkzK0TyHGtCSh1Dd+Twu4LGWRAaCZp77GLN2mERpwNHCf4uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AzwU2UfO; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AzwU2UfO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734231520; x=1765767520;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=xwh5QIFiEZatH/op9hzPR9Y0hPludvE5/P/bczp99iw=;
  b=AzwU2UfOy6iGPhvoLnMdq9WcjNBnRUO8UQgQOpwIdoxuKfy6VcfjnTbb
   NskX5xMAXSDWhUqcNhZ6h6WT/PQK5Eh704htk4ystzGRMQ/V+/sNkoYyH
   Wi6W794ISMDE4iHmm1fjaW7RKIir6JBsZ9MCVWFW1jScGTyjSShDp3AeH
   1mj6pIM85Hd+b2TrQKqMBJ47Qw+Omp2MfJNfOfn0adHopqcXMtvWLJA+p
   4XUjBG/to6Y+gedkTFGxjp8Swp74pAwynnS8IsNXUqVtOOZzJ4zlMaOtb
   jomE4Vag392HaWpGNwPd9/WLasK4wnh282D2/k47FCJqUO88cSt8QzMGk
   w==;
X-CSE-ConnectionGUID: aXKFeLOiStGAdzfLG08SEg==
X-CSE-MsgGUID: OBUGgBlxSJyheJFEkjGCqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11286"; a="52166952"
X-IronPort-AV: E=Sophos;i="6.12,235,1728975600"; 
   d="scan'208";a="52166952"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 18:58:39 -0800
X-CSE-ConnectionGUID: hwqGEvIRQzq1o+uKMnYgQw==
X-CSE-MsgGUID: QZXMFqrVQ6GatnSHehobdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="97309321"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.111.42])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 18:58:38 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Sat, 14 Dec 2024 20:58:31 -0600
Subject: [ndctl PATCH v4 4/9] cxl/region: Use new region mode in cxl-cli
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241214-dcd-region2-v4-4-36550a97f8e2@intel.com>
References: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
In-Reply-To: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Sushant1 Kumar <sushant1.kumar@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734231510; l=6754;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=xwh5QIFiEZatH/op9hzPR9Y0hPludvE5/P/bczp99iw=;
 b=d4Qpf8+1pwVcJ9sb4yT8SJ4sNrtVTbcbFWCjtKIXimjPx9z2maO8vibaZvbf8vnRwEhrzxiVN
 H7Qy+7J8A1lCtfFC0pIh0KZDAdvXxmcJaO2RKBIudcjyNgN+G5ZeUja
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

With the introduction of DCD, region mode and decoder mode no longer
remain a 1:1 relation.  An interleaved region may be made up of Dynamic
Capacity partitions with different indexes on each of the target
devices.

Modify cxl-cli to use the new region mode interface from libcxl.  Modify
parameter processing and variable name changes for clarity in the
future.

Functionality remains the same.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 cxl/json.c   |  6 +++---
 cxl/region.c | 50 ++++++++++++++++++++++++++++++++------------------
 2 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/cxl/json.c b/cxl/json.c
index 5066d3bed13f8fcc36ab8f0ea127685c246d94d7..dcd3cc28393faf7e8adf299a857531ecdeaac50a 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -1147,7 +1147,7 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
 struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 					     unsigned long flags)
 {
-	enum cxl_decoder_mode mode = cxl_region_get_mode(region);
+	enum cxl_region_mode mode = cxl_region_get_region_mode(region);
 	const char *devname = cxl_region_get_devname(region);
 	struct json_object *jregion, *jobj;
 	u64 val;
@@ -1174,8 +1174,8 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 			json_object_object_add(jregion, "size", jobj);
 	}
 
-	if (mode != CXL_DECODER_MODE_NONE) {
-		jobj = json_object_new_string(cxl_decoder_mode_name(mode));
+	if (mode != CXL_REGION_MODE_NONE) {
+		jobj = json_object_new_string(cxl_region_mode_name(mode));
 		if (jobj)
 			json_object_object_add(jregion, "type", jobj);
 	}
diff --git a/cxl/region.c b/cxl/region.c
index 207cf2d003148992255c715f286bc0f38de2ca84..527bd6708b162815068a95ddb360fce3914347de 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -49,7 +49,8 @@ struct parsed_params {
 	int argc;
 	const char **argv;
 	struct cxl_decoder *root_decoder;
-	enum cxl_decoder_mode mode;
+	enum cxl_decoder_mode decoder_mode;
+	enum cxl_region_mode region_mode;
 	bool enforce_qos;
 };
 
@@ -301,19 +302,28 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
 		return -ENXIO;
 	p->num_memdevs = json_object_array_length(p->memdevs);
 
+	p->region_mode = CXL_REGION_MODE_NONE;
 	if (param.type) {
-		p->mode = cxl_decoder_mode_from_ident(param.type);
-		if (p->mode == CXL_DECODER_MODE_RAM && param.uuid) {
+		p->region_mode = cxl_region_mode_from_ident(param.type);
+		if (p->region_mode == CXL_REGION_MODE_RAM && param.uuid) {
 			log_err(&rl,
 				"can't set UUID for ram / volatile regions");
 			goto err;
 		}
-		if (p->mode == CXL_DECODER_MODE_NONE) {
+		if (p->region_mode == CXL_REGION_MODE_NONE) {
 			log_err(&rl, "unsupported type: %s\n", param.type);
 			goto err;
 		}
-	} else {
-		p->mode = CXL_DECODER_MODE_PMEM;
+	}
+
+	switch (p->region_mode) {
+	case CXL_REGION_MODE_RAM:
+		p->decoder_mode = CXL_DECODER_MODE_RAM;
+		break;
+	case CXL_REGION_MODE_PMEM:
+	default:
+		p->decoder_mode = CXL_DECODER_MODE_PMEM;
+		break;
 	}
 
 	if (param.size) {
@@ -410,7 +420,7 @@ static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
 		struct cxl_memdev *memdev = json_object_get_userdata(jobj);
 		u64 size = 0;
 
-		switch(p->mode) {
+		switch(p->decoder_mode) {
 		case CXL_DECODER_MODE_RAM:
 			size = cxl_memdev_get_ram_size(memdev);
 			break;
@@ -446,7 +456,7 @@ static int create_region_validate_qos_class(struct parsed_params *p)
 			json_object_array_get_idx(p->memdevs, i);
 		struct cxl_memdev *memdev = json_object_get_userdata(jobj);
 
-		if (p->mode == CXL_DECODER_MODE_RAM)
+		if (p->decoder_mode == CXL_DECODER_MODE_RAM)
 			qos_class = cxl_memdev_get_ram_qos_class(memdev);
 		else
 			qos_class = cxl_memdev_get_pmem_qos_class(memdev);
@@ -475,7 +485,7 @@ static int validate_decoder(struct cxl_decoder *decoder,
 	const char *devname = cxl_decoder_get_devname(decoder);
 	int rc;
 
-	switch(p->mode) {
+	switch(p->decoder_mode) {
 	case CXL_DECODER_MODE_RAM:
 		if (!cxl_decoder_is_volatile_capable(decoder)) {
 			log_err(&rl, "%s is not volatile capable\n", devname);
@@ -512,10 +522,14 @@ static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
 	 * default to pmem if both types are set, otherwise the single
 	 * capability dominates.
 	 */
-	if (cxl_decoder_is_volatile_capable(p->root_decoder))
-		p->mode = CXL_DECODER_MODE_RAM;
-	if (cxl_decoder_is_pmem_capable(p->root_decoder))
-		p->mode = CXL_DECODER_MODE_PMEM;
+	if (cxl_decoder_is_volatile_capable(p->root_decoder)) {
+		p->decoder_mode = CXL_DECODER_MODE_RAM;
+		p->region_mode = CXL_REGION_MODE_RAM;
+	}
+	if (cxl_decoder_is_pmem_capable(p->root_decoder)) {
+		p->decoder_mode = CXL_DECODER_MODE_PMEM;
+		p->region_mode = CXL_REGION_MODE_PMEM;
+	}
 }
 
 static int create_region_validate_config(struct cxl_ctx *ctx,
@@ -685,14 +699,14 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 	if (size > max_extent)
 		size = ALIGN_DOWN(max_extent, SZ_256M * p->ways);
 
-	if (p->mode == CXL_DECODER_MODE_PMEM) {
+	if (p->region_mode == CXL_REGION_MODE_PMEM) {
 		region = cxl_decoder_create_pmem_region(p->root_decoder);
 		if (!region) {
 			log_err(&rl, "failed to create region under %s\n",
 				param.root_decoder);
 			return -ENXIO;
 		}
-	} else if (p->mode == CXL_DECODER_MODE_RAM) {
+	} else if (p->region_mode == CXL_REGION_MODE_RAM) {
 		region = cxl_decoder_create_ram_region(p->root_decoder);
 		if (!region) {
 			log_err(&rl, "failed to create region under %s\n",
@@ -714,7 +728,7 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 
 	try(cxl_region, set_interleave_granularity, region, granularity);
 	try(cxl_region, set_interleave_ways, region, p->ways);
-	if (p->mode == CXL_DECODER_MODE_PMEM) {
+	if (p->region_mode == CXL_REGION_MODE_PMEM) {
 		if (!param.uuid)
 			uuid_generate(p->uuid);
 		try(cxl_region, set_uuid, region, p->uuid);
@@ -732,14 +746,14 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 			rc = -ENXIO;
 			goto out;
 		}
-		if (cxl_decoder_get_mode(ep_decoder) != p->mode) {
+		if (cxl_decoder_get_mode(ep_decoder) != p->decoder_mode) {
 			/*
 			 * The cxl_memdev_find_decoder() helper returns a free
 			 * decoder whose size has been checked for 0.
 			 * Thus it is safe to change the mode here if needed.
 			 */
 			try(cxl_decoder, set_dpa_size, ep_decoder, 0);
-			try(cxl_decoder, set_mode, ep_decoder, p->mode);
+			try(cxl_decoder, set_mode, ep_decoder, p->decoder_mode);
 		}
 		try(cxl_decoder, set_dpa_size, ep_decoder, size/p->ways);
 		rc = cxl_region_set_target(region, i, ep_decoder);

-- 
2.47.1

