Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A639185B58
	for <nvdimm@lists.linux.dev>; Fri, 15 Nov 2024 18:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731696052; cv=none; b=UmJJ3inVGzTM/Y6FlKlZaAOUuWYTcNnBQwW4pVgkQ2nlJn64mrAI3gFlV0fuiTJwep0oilp6/jG1dbEgnnn+F070yYAkyt2QLk9hNTzEh3Nmkzt7bE9ZRjufqOr83YrY8NypcSjdU1sG95fJUti3V/K26PnmR3wQOy9UaAy6pnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731696052; c=relaxed/simple;
	bh=HgvcFJJlwID2rYxZWQTHetcFY5nTyif5z/Ba07c9JXA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AfZCiapvfdfFdo3XY1HE9chPPUzI5i6V2ab8/CLCtwt88scA5ZiuPAeoAbmPxlQaqxm/OsuQHAgoZBvkVPhlMJi6r5biVX/rJyiTiP58/3JP4GLHiIEZzWJ1Vyc2Y0IGAdAuKeIQLkN783WL/H7hRC3dbvyfc1jc7opYbfQzJY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fShWN+jY; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fShWN+jY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731696050; x=1763232050;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=HgvcFJJlwID2rYxZWQTHetcFY5nTyif5z/Ba07c9JXA=;
  b=fShWN+jYAUv3/XMn3x7Qy4R8dFaeRUUfSV3cZxV7gMa50BioT6fs9lTS
   xsoNtuyEcc0bj4bSSqquRfic81fSLUDG/rDTVz5RqjnZrLHdEfrBw3GfJ
   GnDWUbV8OiOTucsjtG6m4V+ehQK/u7uaw7BKzvmoNFCpASwaluuQdtjuM
   tAgFlPXusEetdkoGduPj+BXaxz4x9g6l4OstsBaUMZhJGRz4pSaCepbSe
   Y/qUvWsCzwhx44oYNgsGQYD6SdddWya4UtNP7V3gViPmEMb2hDUpg+EIc
   d/Fo3P1pFRnxHT6c0S9xVlkxm0wCPxYcpY7dCdASmqmsSqH+OTBaPaGSi
   w==;
X-CSE-ConnectionGUID: g0TzbdDmS3KpCzIsAyd8jg==
X-CSE-MsgGUID: 7iZBJwhpT+u15URJf/OCaA==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="31127899"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="31127899"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:40:44 -0800
X-CSE-ConnectionGUID: 43sXkUWkR9+0pdOkHN3LwQ==
X-CSE-MsgGUID: O5rn/XxAT36rMzHzCWax0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="88522623"
Received: from ehanks-mobl1.amr.corp.intel.com (HELO localhost) ([10.125.108.112])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:40:43 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Fri, 15 Nov 2024 12:40:37 -0600
Subject: [ndctl PATCH v3 4/9] cxl/region: Use new region mode in cxl-cli
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241115-dcd-region2-v3-4-326cd4e34dcd@intel.com>
References: <20241115-dcd-region2-v3-0-326cd4e34dcd@intel.com>
In-Reply-To: <20241115-dcd-region2-v3-0-326cd4e34dcd@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Navneet Singh <navneet.singh@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731696034; l=6905;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=HgvcFJJlwID2rYxZWQTHetcFY5nTyif5z/Ba07c9JXA=;
 b=qO/rzPWEGA8Ou489arr08zclwOB50wbT+pcrzOjFVw7iWFmsJ0/SWpSt7yES6jS9eW18bG1n3
 2gMulejD6R9A2WFV1szzaG385DOBABs8MWhSBNTC9Npk/Pr7MooYt/h
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
Changes:
[Alison: split libcxl and cxl-cli changes]
[iweiny: Process region mode based on --type]
[iweiny: s/mode/decoder_mode for clarity]
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
2.47.0

