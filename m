Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7918B1D8E07
	for <nvdimm@lists.linux.dev>; Fri, 15 Nov 2024 18:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731696400; cv=none; b=ahYlG0SO2Ze0MtqzK7lvKHNTmX4eHwPK3+lVljhd8U+U2cVNKL4l00FCSsOLegIF1e59HATaIopoEkKZNx43k2bz80yLCt4cjXQxAnleOsRSp/mC0/bkk9i8tLV+RbuZ2TSaQnqfBPZbZWGNELDXowccZZkJ/bBsK6EvvWD5Pro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731696400; c=relaxed/simple;
	bh=t6GbvHI3ED9i2ASzhEVWbtZHqnu1k8IUNk7QpOyXA30=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=biT/cDlkqmr/XeeYh5UOqSih+DJuyxuyYTgwv0ZM5yEfs7dwXu1lvFutiTe8IR2lSO8brCs/cphpyczq5v6+wDkJPIAgqGQSQFu68v097ciAMSGfwBO9dtwQfSbWHKAI4rwP6r50G0wk0f0EYH+QXIFCxoMqsfLSEAgsTGR5Rko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UNXFkeku; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UNXFkeku"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731696399; x=1763232399;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=t6GbvHI3ED9i2ASzhEVWbtZHqnu1k8IUNk7QpOyXA30=;
  b=UNXFkekuLAegUacmDTXrsoKjMnfqAsnL9aU7UbFcQkdRyfK7DV4c9bZY
   pChx110jQ2QHhxZyav8hqNUKRcYDOSy2RiYBXTb74U+9GYG3E3uzrhEkR
   voGEIlRPA2Vc3oJ7s6uBciXrFlSDxq3W4Cx5udN9GT+rbGA5J2hW95ELZ
   fdFcDivmrQCITanEwLvyuR2hBy8yYI6Xlnuz72TUpdy29J8IWFDYOuJ65
   tqw1W9ET8B+3C+OHtY/Pm3UF9Rtcr2iV0ZZ9rjoJy2yYpF2PsxlXKdpF1
   flNPyYW9ThJCBbmT2SQAOQxwANrZPtoE2AsWpF6DQ6j1KXkt+ezoShiNn
   g==;
X-CSE-ConnectionGUID: awZ6VOrjTXyoxNhx92FNJQ==
X-CSE-MsgGUID: lgo5eh7sStWhQ3l3gmNjnQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="31848475"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="31848475"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:46:38 -0800
X-CSE-ConnectionGUID: Q/CsOw7hRaC1SlFyv2onjg==
X-CSE-MsgGUID: VIg71eHLRBa34xMaViv/nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="89392907"
Received: from ehanks-mobl1.amr.corp.intel.com (HELO localhost) ([10.125.108.112])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:46:36 -0800
From: ira.weiny@intel.com
Date: Fri, 15 Nov 2024 12:46:24 -0600
Subject: [ndctl PATCH v3 6/9] cxl/region: Add cxl-cli support for DCD
 regions
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241115-dcd-region2-v3-6-585d480ccdab@intel.com>
References: <20241115-dcd-region2-v3-0-585d480ccdab@intel.com>
In-Reply-To: <20241115-dcd-region2-v3-0-585d480ccdab@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Navneet Singh <navneet.singh@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>, Sushant1 Kumar <sushant1.kumar@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731696382; l=9701;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=6kbMCnC7Z99b+GpG47OCrOAiIaFJjRZF6qdh4ygC3Hg=;
 b=W3j80PsL0dpp47qUm4VKbtudyCTqgBD1wIFn2/xdK2WwXbg/x9+KDVfU1Ymk0Aru2IWTsm6nX
 xnU9YF2gyPfBnjilnvQPG3PvE2twb9sC8cTAapvlYx+UwTJql9R0sf3
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

CXL Dynamic Capacity Devices (DCDs) optionally support dynamic capacity
with up to eight partitions (Regions) (dc0-dc7).  CXL regions can now be
sparse and defined as dynamic capacity (dc).

DCD region creation requires a specific partition, or decoder mode, to
be supplied.  Introduce a required option for dc regions to specify the
decoder mode.

Add support for dynamic capacity region creation.

Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Co-developed-by: Sushant1 Kumar <sushant1.kumar@intel.com>
Signed-off-by: Sushant1 Kumar <sushant1.kumar@intel.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[djiang: remove errant white space changes]
[djiang: use for loop for dc capability sets]
[djiang/iweiny: change cxl_memdev_get_dc_size() to take mode]
[djiang/iweiny: change cxl_decoder_is_dc_capable() to take mode]
[Alison: s/Co-Authored-by/Co-developed-by/]
[Alison: document new libcxl calls]
[Alison: reduce indentation]
[Alison: Fix libcxl export symbols]
[iweiny: Add get mode documentation]
[iweiny: add docs for DC support]
[iweiny: Add -M option to clarify region vs decoder mode]
---
 Documentation/cxl/cxl-create-region.txt | 11 ++++++++--
 cxl/json.c                              | 27 ++++++++++++++++++++++-
 cxl/memdev.c                            |  4 +++-
 cxl/region.c                            | 39 ++++++++++++++++++++++++++++++++-
 4 files changed, 76 insertions(+), 5 deletions(-)

diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
index b244af60b8a63281ed63d0d6f4027ea729ad51b0..a12cc8d3f19fa582376599ecc8512640f15ce42c 100644
--- a/Documentation/cxl/cxl-create-region.txt
+++ b/Documentation/cxl/cxl-create-region.txt
@@ -75,8 +75,9 @@ include::bus-option.txt[]
 
 -t::
 --type=::
-	Specify the region type - 'pmem' or 'ram'. Default to root decoder
-	capability, and if that is ambiguous, default to 'pmem'.
+	Specify the region type - 'pmem', 'ram', or 'dc'.  Default to root
+	decoder capability including the first of any DC partition found.  If
+	the decoder capability is ambiguous, default to 'pmem'.
 
 -U::
 --uuid=::
@@ -105,6 +106,12 @@ include::bus-option.txt[]
 	supplied, the first cross-host bridge (if available), decoder that
 	supports the largest interleave will be chosen.
 
+-M::
+--decoder-mode=::
+	For a 'dc' region type, specify the dynamic capacity partition to be
+	used on each device, 'dcX' [where X is 0-7].  Ignored for region type
+	of 'ram' or 'pmem'.
+
 -Q::
 --enforce-qos::
 	Parameter to enforce qos_class mismatch failure. Region create operation
diff --git a/cxl/json.c b/cxl/json.c
index dcd3cc28393faf7e8adf299a857531ecdeaac50a..c5391be84fba51da57fc15ece7c1f94cce139276 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -754,12 +754,15 @@ err_free:
 	return jpoison;
 }
 
+#define DC_SIZE_NAME_LEN 64
 struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		unsigned long flags)
 {
 	const char *devname = cxl_memdev_get_devname(memdev);
+	char size_name[DC_SIZE_NAME_LEN];
 	struct json_object *jdev, *jobj;
 	unsigned long long serial, size;
+	enum cxl_decoder_mode mode;
 	const char *fw_version;
 	int numa_node;
 	int qos_class;
@@ -800,6 +803,16 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		}
 	}
 
+	for (mode = CXL_DECODER_MODE_DC0; mode <= CXL_DECODER_MODE_DC7; mode++) {
+		size = cxl_memdev_get_dc_size(memdev, mode);
+		if (!size)
+			continue;
+		jobj = util_json_object_size(size, flags);
+		if (!jobj)
+			continue;
+		sprintf(size_name, "%s_size", cxl_decoder_mode_name(mode));
+		json_object_object_add(jdev, size_name, jobj);
+	}
 	if (flags & UTIL_JSON_HEALTH) {
 		jobj = util_cxl_memdev_health_to_json(memdev, flags);
 		if (jobj)
@@ -948,12 +961,15 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
 	return jbus;
 }
 
+#define DC_CAPABILITY_NAME_LEN 16
 struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 					     unsigned long flags)
 {
 	const char *devname = cxl_decoder_get_devname(decoder);
 	struct cxl_port *port = cxl_decoder_get_port(decoder);
+	char dc_capable_name[DC_CAPABILITY_NAME_LEN];
 	struct json_object *jdecoder, *jobj;
+	enum cxl_decoder_mode mode;
 	struct cxl_region *region;
 	u64 val, size;
 
@@ -1013,7 +1029,7 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 	}
 
 	if (cxl_port_is_endpoint(port)) {
-		enum cxl_decoder_mode mode = cxl_decoder_get_mode(decoder);
+		mode = cxl_decoder_get_mode(decoder);
 
 		size = cxl_decoder_get_dpa_size(decoder);
 		val = cxl_decoder_get_dpa_resource(decoder);
@@ -1059,6 +1075,15 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 				json_object_object_add(
 					jdecoder, "volatile_capable", jobj);
 		}
+		for (mode = CXL_DECODER_MODE_DC0; mode <= CXL_DECODER_MODE_DC7; mode++) {
+			if (!cxl_decoder_is_dc_capable(decoder, mode))
+				continue;
+			jobj = json_object_new_boolean(true);
+			if (!jobj)
+				continue;
+			sprintf(dc_capable_name, "%s_capable", cxl_decoder_mode_name(mode));
+			json_object_object_add(jdecoder, dc_capable_name, jobj);
+		}
 	}
 
 	if (cxl_port_is_root(port) &&
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 6e44d1578d03b6af998502e54714635b8f31b556..b132527d7c21e99c9da75ea7cbf1497fd924a142 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -269,8 +269,10 @@ static int __reserve_dpa(struct cxl_memdev *memdev,
 
 	if (mode == CXL_DECODER_MODE_RAM)
 		avail_dpa = cxl_memdev_get_ram_size(memdev);
-	else
+	else if (mode == CXL_DECODER_MODE_PMEM)
 		avail_dpa = cxl_memdev_get_pmem_size(memdev);
+	else if (cxl_decoder_mode_is_dc(mode))
+		avail_dpa = cxl_memdev_get_dc_size(memdev, mode);
 
 	cxl_decoder_foreach(port, decoder) {
 		size = cxl_decoder_get_dpa_size(decoder);
diff --git a/cxl/region.c b/cxl/region.c
index 527bd6708b162815068a95ddb360fce3914347de..79f434b0c99545523f3b8209f90ff2f02111881c 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -26,6 +26,7 @@ static struct region_params {
 	const char *uuid;
 	const char *root_decoder;
 	const char *region;
+	const char *decoder_mode;
 	int ways;
 	int granularity;
 	bool memdevs;
@@ -79,9 +80,11 @@ OPT_INTEGER('w', "ways", &param.ways, \
 OPT_INTEGER('g', "granularity", &param.granularity,  \
 	    "granularity of the interleave set"), \
 OPT_STRING('t', "type", &param.type, \
-	   "region type", "region type - 'pmem' or 'ram'"), \
+	   "region type", "region type - 'pmem', 'ram', or 'dc'"), \
 OPT_STRING('U', "uuid", &param.uuid, \
 	   "region uuid", "uuid for the new region (default: autogenerate)"), \
+OPT_STRING('M', "decoder-mode", &param.decoder_mode, "decoder mode", \
+	   "decoder mode for dc regions - 'dcX' [where X is 0-7]"), \
 OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
 	    "non-option arguments are memdevs"), \
 OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats"), \
@@ -314,12 +317,19 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
 			log_err(&rl, "unsupported type: %s\n", param.type);
 			goto err;
 		}
+		if (p->region_mode == CXL_REGION_MODE_DC && !param.decoder_mode) {
+			log_err(&rl, "dc type requires a decoder mode\n");
+			goto err;
+		}
 	}
 
 	switch (p->region_mode) {
 	case CXL_REGION_MODE_RAM:
 		p->decoder_mode = CXL_DECODER_MODE_RAM;
 		break;
+	case CXL_REGION_MODE_DC:
+		p->decoder_mode = cxl_decoder_mode_from_ident(param.decoder_mode);
+		break;
 	case CXL_REGION_MODE_PMEM:
 	default:
 		p->decoder_mode = CXL_DECODER_MODE_PMEM;
@@ -427,6 +437,9 @@ static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
 		case CXL_DECODER_MODE_PMEM:
 			size = cxl_memdev_get_pmem_size(memdev);
 			break;
+		case CXL_DECODER_MODE_DC0 ... CXL_DECODER_MODE_DC7:
+			size = cxl_memdev_get_dc_size(memdev, p->decoder_mode);
+			break;
 		default:
 			/* Shouldn't ever get here */ ;
 		}
@@ -498,6 +511,13 @@ static int validate_decoder(struct cxl_decoder *decoder,
 			return -EINVAL;
 		}
 		break;
+	case CXL_DECODER_MODE_DC0 ... CXL_DECODER_MODE_DC7:
+		if (!cxl_decoder_is_dc_capable(decoder, p->decoder_mode)) {
+			log_err(&rl, "%s is not %s capable\n", devname,
+				cxl_decoder_mode_name(p->decoder_mode));
+			return -EINVAL;
+		}
+		break;
 	default:
 		log_err(&rl, "unknown type: %s\n", param.type);
 		return -EINVAL;
@@ -514,10 +534,20 @@ static int validate_decoder(struct cxl_decoder *decoder,
 
 static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
 {
+	enum cxl_decoder_mode mode;
+
 	/* if param.type was explicitly specified, nothing to do here */
 	if (param.type)
 		return;
 
+	for (mode = CXL_DECODER_MODE_DC0; mode <= CXL_DECODER_MODE_DC7; mode++) {
+		if (cxl_decoder_is_dc_capable(p->root_decoder, mode)) {
+			p->decoder_mode = mode;
+			p->region_mode = CXL_REGION_MODE_DC;
+			break;
+		}
+	}
+
 	/*
 	 * default to pmem if both types are set, otherwise the single
 	 * capability dominates.
@@ -713,6 +743,13 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 				param.root_decoder);
 			return -ENXIO;
 		}
+	} else if (p->region_mode == CXL_REGION_MODE_DC) {
+		region = cxl_decoder_create_dc_region(p->root_decoder);
+		if (!region) {
+			log_err(&rl, "failed to create region under %s\n",
+				param.root_decoder);
+			return -ENXIO;
+		}
 	} else {
 		log_err(&rl, "region type '%s' is not supported\n",
 			param.type);

-- 
2.47.0

