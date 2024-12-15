Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E3FC13D
	for <nvdimm@lists.linux.dev>; Sun, 15 Dec 2024 02:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734231531; cv=none; b=s/sCdUSjZZ6nRofxEAqKH4nsdIe2XakXcRLDwucMRTdEVoy/DncCbIoq5wuWaQnh0cQ1XTryrh+bGWGcGdFnAfQFMnHhdCQobN2xReoCDkn7e60kHXeklpiOb2jFs8yAvnIOqMTTFA4PWHrw12BwNfF43qfVQpr1GAv0rTi0Z30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734231531; c=relaxed/simple;
	bh=sm9ZEyQlWPLDP0W5A+dsrr3jMpJLe/ZSc4iBQSQg6i0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=E0O7u42QlzwQYMKaOlPZRk92bwyJctQ7aZjGFClqxsrCroOo6uVYy1wZeXb1M3Bfjz0GVG6vbhAsY9VUtDlinrDTbyC2oqIZfnCtNde7FByu98P3rCCFZ22FsKZKYL3llxQzbnLrDAJlb6+5LFuorDHucvzppgYA2VNnq5tphbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jw/e/0MS; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jw/e/0MS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734231531; x=1765767531;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=sm9ZEyQlWPLDP0W5A+dsrr3jMpJLe/ZSc4iBQSQg6i0=;
  b=jw/e/0MSY/WlJ6KU45FyUjdVKf1JbNhZFQBZFVgkHfhU3R1gRGUnTSdb
   mT939QPnZUJf3R/kpmhjK0oA1EJngGxQmcwxn5tHfLGphdvCi4roJQrdd
   yRPVJs1rjtQCbcDO97Q/aQit5PEOQ5MlmWmidJP600/gKmEFaQtxpV7WK
   +liiBLAv3aCjet6nxBkEewM0vcKWaXvNDfbqKrnQngGMWOZF6LuEGk39E
   ig+W818kLrMXL6U77jZJ0qA1MM4QbrtdGahi5aRL0/7IhS+8hKim2aCSB
   I3yktruy7l7nAnc314qixvJW5uR1Sih1v72XhbUGChM4uYPrD/4tExYjH
   Q==;
X-CSE-ConnectionGUID: N5o0iHLlS/GU/Td2MVTJtQ==
X-CSE-MsgGUID: y0keyeyNT4OQk2l10JnI2Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11286"; a="38424570"
X-IronPort-AV: E=Sophos;i="6.12,235,1728975600"; 
   d="scan'208";a="38424570"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 18:58:50 -0800
X-CSE-ConnectionGUID: MZQOdjXkQFqT5lJyikHJ1g==
X-CSE-MsgGUID: o/D8OPIYRZGfiST0dLakuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="101462516"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.111.42])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 18:58:48 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Sat, 14 Dec 2024 20:58:35 -0600
Subject: [ndctl PATCH v4 8/9] cxl/region: Add extent output to region query
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241214-dcd-region2-v4-8-36550a97f8e2@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734231510; l=6589;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=sm9ZEyQlWPLDP0W5A+dsrr3jMpJLe/ZSc4iBQSQg6i0=;
 b=XhUJg4SCi2SiSKk2dkOhkvi12aIjOGvLfiS5odedKclDEFGYo+KjhpsJYp/7BGb4WRu9IaIBQ
 mz0y7ojrzl4DML19iJEBMhYfD5HBlQZlFaCKu9zN2oRHuFavGCC3Te1
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

DCD regions have 0 or more extents.  The ability to list those and their
properties is useful to end users.

Add an option for extent output to region queries.  An example of this
is:

	$ ./build/cxl/cxl list -r 8 -Nu
	{
	  "region":"region8",
	  ...
	  "type":"dc",
	  ...
	  "extents":[
	    {
	      "offset":"0x10000000",
	      "length":"64.00 MiB (67.11 MB)",
	      "tag":"00000000-0000-0000-0000-000000000000"
	    },
	    {
	      "offset":"0x8000000",
	      "length":"64.00 MiB (67.11 MB)",
	      "tag":"00000000-0000-0000-0000-000000000000"
	    }
	  ]
	}

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 Documentation/cxl/cxl-list.txt | 29 ++++++++++++++++++++++++++
 cxl/filter.h                   |  3 +++
 cxl/json.c                     | 47 ++++++++++++++++++++++++++++++++++++++++++
 cxl/json.h                     |  3 +++
 cxl/list.c                     |  3 +++
 util/json.h                    |  1 +
 6 files changed, 86 insertions(+)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 9a9911e7dd9bba561c6202784017db1bb4b9f4bd..43453cc72245f586070f8c4f31b3ee475e3c6cd2 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -411,6 +411,35 @@ OPTIONS
 }
 ----
 
+-N::
+--extents::
+	Append Dynamic Capacity extent information.
+----
+13:34:28 > ./build/cxl/cxl list -r 8 -Nu
+{
+  "region":"region8",
+  "resource":"0xf030000000",
+  "size":"512.00 MiB (536.87 MB)",
+  "type":"dc",
+  "interleave_ways":1,
+  "interleave_granularity":256,
+  "decode_state":"commit",
+  "extents":[
+    {
+      "offset":"0x10000000",
+      "length":"64.00 MiB (67.11 MB)",
+      "tag":"00000000-0000-0000-0000-000000000000"
+    },
+    {
+      "offset":"0x8000000",
+      "length":"64.00 MiB (67.11 MB)",
+      "tag":"00000000-0000-0000-0000-000000000000"
+    }
+  ]
+}
+----
+
+
 -r::
 --region::
 	Specify CXL region device name(s), or device id(s), to filter the listing.
diff --git a/cxl/filter.h b/cxl/filter.h
index 956a46e0c7a9f05abf696cce97a365164e95e50d..a31b80c87ccac407bd4ff98b302a23b33cbe413c 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -31,6 +31,7 @@ struct cxl_filter_params {
 	bool alert_config;
 	bool dax;
 	bool media_errors;
+	bool extents;
 	int verbose;
 	struct log_ctx ctx;
 };
@@ -91,6 +92,8 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
 		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
 	if (param->media_errors)
 		flags |= UTIL_JSON_MEDIA_ERRORS;
+	if (param->extents)
+		flags |= UTIL_JSON_EXTENTS;
 	return flags;
 }
 
diff --git a/cxl/json.c b/cxl/json.c
index c5391be84fba51da57fc15ece7c1f94cce139276..450e62243ecdfec1aa011241ff7257ac3b37196f 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -1169,6 +1169,50 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
 	json_object_object_add(jregion, "mappings", jmappings);
 }
 
+void util_cxl_extents_append_json(struct json_object *jregion,
+				  struct cxl_region *region,
+				  unsigned long flags)
+{
+	struct json_object *jextents;
+	struct cxl_region_extent *extent;
+
+	jextents = json_object_new_array();
+	if (!jextents)
+		return;
+
+	cxl_extent_foreach(region, extent) {
+		struct json_object *jextent, *jobj;
+		unsigned long long val;
+		char tag_str[40];
+		uuid_t tag;
+
+		jextent = json_object_new_object();
+		if (!jextent)
+			continue;
+
+		val = cxl_extent_get_offset(extent);
+		jobj = util_json_object_hex(val, flags);
+		if (jobj)
+			json_object_object_add(jextent, "offset", jobj);
+
+		val = cxl_extent_get_length(extent);
+		jobj = util_json_object_size(val, flags);
+		if (jobj)
+			json_object_object_add(jextent, "length", jobj);
+
+		cxl_extent_get_tag(extent, tag);
+		uuid_unparse(tag, tag_str);
+		jobj = json_object_new_string(tag_str);
+		if (jobj)
+			json_object_object_add(jextent, "tag", jobj);
+
+		json_object_array_add(jextents, jextent);
+		json_object_set_userdata(jextent, extent, NULL);
+	}
+
+	json_object_object_add(jregion, "extents", jextents);
+}
+
 struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 					     unsigned long flags)
 {
@@ -1255,6 +1299,9 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 		}
 	}
 
+	if (flags & UTIL_JSON_EXTENTS)
+		util_cxl_extents_append_json(jregion, region, flags);
+
 	if (cxl_region_qos_class_mismatch(region)) {
 		jobj = json_object_new_boolean(true);
 		if (jobj)
diff --git a/cxl/json.h b/cxl/json.h
index eb7572be4106baf0469ba9243a9a767d07df8882..f9c07ab41a337838b75ffee4486f6c48ddc99863 100644
--- a/cxl/json.h
+++ b/cxl/json.h
@@ -20,6 +20,9 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 void util_cxl_mappings_append_json(struct json_object *jregion,
 				  struct cxl_region *region,
 				  unsigned long flags);
+void util_cxl_extents_append_json(struct json_object *jregion,
+				  struct cxl_region *region,
+				  unsigned long flags);
 void util_cxl_targets_append_json(struct json_object *jdecoder,
 				  struct cxl_decoder *decoder,
 				  const char *ident, const char *serial,
diff --git a/cxl/list.c b/cxl/list.c
index 0b25d78248d5f4f529fd2c2e073e43895c722568..47d135166212b87449f960e94ee75657f7040ca9 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -59,6 +59,8 @@ static const struct option options[] = {
 		    "include alert configuration information"),
 	OPT_BOOLEAN('L', "media-errors", &param.media_errors,
 		    "include media-error information "),
+	OPT_BOOLEAN('N', "extents", &param.extents,
+		    "include extent information (Dynamic Capacity regions only)"),
 	OPT_INCR('v', "verbose", &param.verbose, "increase output detail"),
 #ifdef ENABLE_DEBUG
 	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
@@ -135,6 +137,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 		param.decoders = true;
 		param.targets = true;
 		param.regions = true;
+		param.extents = true;
 		/*fallthrough*/
 	case 0:
 		break;
diff --git a/util/json.h b/util/json.h
index 560f845c6753ee176f7c64b4310fe1f9b1ce6d39..79ae3240e7ce151be75f6666fcaba0ba90aba7fc 100644
--- a/util/json.h
+++ b/util/json.h
@@ -21,6 +21,7 @@ enum util_json_flags {
 	UTIL_JSON_TARGETS	= (1 << 11),
 	UTIL_JSON_PARTITION	= (1 << 12),
 	UTIL_JSON_ALERT_CONFIG	= (1 << 13),
+	UTIL_JSON_EXTENTS	= (1 << 14),
 };
 
 void util_display_json_array(FILE *f_out, struct json_object *jarray,

-- 
2.47.1

