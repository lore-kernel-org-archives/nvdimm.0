Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737A6631
	for <nvdimm@lists.linux.dev>; Thu, 18 Jan 2024 00:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705537701; cv=none; b=gtDPhU7+d6lodMq93MxxAGyyXYPp9cAOSDaRaGXKPlVODHj2GDrHuPK9npC6vcKTzzZZX6YSM4rKh30sLKNZqd0NxSDyI97+sHHI31DeYSTsmGl6kBPnOXduhQCpb7LeT9l5n1XlMtkUWWS805ajO3sSxV+YLWrIHfT/KL7ETBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705537701; c=relaxed/simple;
	bh=dD7zlqPt0y2qe8Ho4ZS/d8EbHIfCNsOxxrOlJJZs6Ew=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding; b=hDZ3/dFji52HBlKtI15pvO4Ije9RvA1qePHIUNM6POye2Wf7TL/pUpcnf7SQe4bz8WNx9KG3SNdnOs7NrGpD5HCBlzPAlycA+MiDsVvDzKI5bgGC7DCp4JCuyDSqxoD9z/mSEiTgZfTkv2cruIRyGYlfaA9ltOBbc/4HHJDld/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dNslMTuv; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dNslMTuv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705537699; x=1737073699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dD7zlqPt0y2qe8Ho4ZS/d8EbHIfCNsOxxrOlJJZs6Ew=;
  b=dNslMTuvrtBfNudROgptn3PKEROYdArO0t590sXM8t8tGOgDW5IBH39c
   tRgyixHsmln27DkKzlBWYdwfwOoIcijlv+BvSOqHRPdTBl8ww+I7teQ3T
   Qyx6p/4DvlrWtNJAs7LikpRyORHZ4qknpSqprRG8D/YEiTEyk/VewPU49
   VN1dHBBgIHRUhx2eCr6gn8BSr0jkgH0hNnfVFYkuuDwkFDGLmr3Y4JCKG
   xhMosyR/aACJP6Nihnll9I1hdrIFg9yZ1JRgIXSkNv0I3s1d2Q3hOUJRx
   v0wxogEQ03SIUxPMUgf6J+VLMnZ49XB6ldZDEZVAZP8ayG/jx+qcP714P
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="18904555"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="18904555"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 16:28:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="777577241"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="777577241"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.110.93])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 16:28:18 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [PATCH v6 5/7] cxl/list: collect and parse media_error records
Date: Wed, 17 Jan 2024 16:28:04 -0800
Message-Id: <17f5eccf769f97b7d2450890a5a185eaaf69be32.1705534719.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1705534719.git.alison.schofield@intel.com>
References: <cover.1705534719.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Media_error records are logged as events in the kernel tracing
subsystem. To prepare the media_error records for cxl list, enable
tracing, trigger the poison list read, and parse the generated
cxl_poison events into a json representation.

Use the event_trace private parsing option to customize the json
representation based on cxl-list calling options and event field
settings.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/json.c | 218 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 218 insertions(+)

diff --git a/cxl/json.c b/cxl/json.c
index 7678d02020b6..abe77e1f86d3 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -1,16 +1,20 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (C) 2015-2021 Intel Corporation. All rights reserved.
 #include <limits.h>
+#include <errno.h>
 #include <util/json.h>
+#include <util/bitmap.h>
 #include <uuid/uuid.h>
 #include <cxl/libcxl.h>
 #include <json-c/json.h>
 #include <json-c/printbuf.h>
 #include <ccan/short_types/short_types.h>
+#include <tracefs/tracefs.h>
 
 #include "filter.h"
 #include "json.h"
 #include "../daxctl/json.h"
+#include "event_trace.h"
 
 #define CXL_FW_VERSION_STR_LEN	16
 #define CXL_FW_MAX_SLOTS	4
@@ -571,6 +575,208 @@ err_jobj:
 	return NULL;
 }
 
+/* CXL Spec 3.1 Table 8-140 Media Error Record */
+#define CXL_POISON_SOURCE_UNKNOWN 0
+#define CXL_POISON_SOURCE_EXTERNAL 1
+#define CXL_POISON_SOURCE_INTERNAL 2
+#define CXL_POISON_SOURCE_INJECTED 3
+#define CXL_POISON_SOURCE_VENDOR 7
+
+/* CXL Spec 3.1 Table 8-139 Get Poison List Output Payload */
+#define CXL_POISON_FLAG_MORE BIT(0)
+#define CXL_POISON_FLAG_OVERFLOW BIT(1)
+#define CXL_POISON_FLAG_SCANNING BIT(2)
+
+struct poison_event_ctx {
+	struct json_object *jpoison;
+	const char *region_name;
+	unsigned long flags;
+};
+
+int poison_event_to_json(struct tep_event *event, struct tep_record *record,
+			 void *ctx)
+{
+	struct poison_event_ctx *p_ctx = (struct poison_event_ctx *)ctx;
+	struct json_object *jobj, *jp, *jpoison = p_ctx->jpoison;
+	const char *region_name = p_ctx->region_name;
+	unsigned long flags = p_ctx->flags;
+	bool overflow = false;
+	unsigned char *data;
+	int pflags;
+	char *str;
+
+	jp = json_object_new_object();
+	if (!jp)
+		return -ENOMEM;
+
+	str = cxl_get_field_string(event, record, "region");
+
+	/* Skip records not in this region when listing by region */
+	if ((region_name) && (strcmp(region_name, str) != 0)) {
+		json_object_put(jp);
+		return 0;
+	}
+	/* Only display region name in by memdev listings */
+	if (!region_name && strlen(str)) {
+		jobj = json_object_new_string(str);
+		if (jobj)
+			json_object_object_add(jp, "region", jobj);
+	}
+	/* Only display memdev name in by region listings */
+	if (region_name) {
+		str = cxl_get_field_string(event, record, "memdev");
+		jobj = json_object_new_string(str);
+		if (jobj)
+			json_object_object_add(jp, "memdev", jobj);
+	}
+
+	data = cxl_get_field_data(event, record, "dpa");
+	jobj = util_json_object_hex(*(uint64_t *)data, flags);
+	if (jobj)
+		json_object_object_add(jp, "dpa", jobj);
+
+	data = cxl_get_field_data(event, record, "dpa_length");
+	jobj = util_json_object_size(*(uint32_t *)data, flags);
+	if (jobj)
+		json_object_object_add(jp, "dpa_length", jobj);
+
+	data = cxl_get_field_data(event, record, "hpa");
+	if (*(uint64_t *)data != ULLONG_MAX) {
+		jobj = util_json_object_hex(*(uint64_t *)data, flags);
+		if (jobj)
+			json_object_object_add(jp, "hpa", jobj);
+	}
+
+	str = cxl_get_field_string(event, record, "source");
+	switch (*(uint8_t *)str) {
+	case CXL_POISON_SOURCE_UNKNOWN:
+		jobj = json_object_new_string("Unknown");
+		break;
+	case CXL_POISON_SOURCE_EXTERNAL:
+		jobj = json_object_new_string("External");
+		break;
+	case CXL_POISON_SOURCE_INTERNAL:
+		jobj = json_object_new_string("Internal");
+		break;
+	case CXL_POISON_SOURCE_INJECTED:
+		jobj = json_object_new_string("Injected");
+		break;
+	case CXL_POISON_SOURCE_VENDOR:
+		jobj = json_object_new_string("Vendor");
+		break;
+	default:
+		jobj = json_object_new_string("Reserved");
+	}
+	json_object_object_add(jp, "source", jobj);
+
+	str = cxl_get_field_string(event, record, "flags");
+	pflags = *(uint8_t *)str;
+	if (pflags) {
+		char flag_str[32] = { '\0' };
+
+		if (pflags & CXL_POISON_FLAG_MORE)
+			strcat(flag_str, "More,");
+		if (pflags & CXL_POISON_FLAG_SCANNING)
+			strcat(flag_str, "Scanning,");
+		if (pflags & CXL_POISON_FLAG_OVERFLOW) {
+			strcat(flag_str, "Overflow,");
+			overflow = true;
+		}
+		jobj = json_object_new_string(flag_str);
+		if (jobj)
+			json_object_object_add(jp, "flags", jobj);
+	}
+	if (overflow) {
+		data = cxl_get_field_data(event, record, "overflow_ts");
+		jobj = util_json_object_hex(*(uint64_t *)data, flags);
+		if (jobj)
+			json_object_object_add(jp, "overflow_t", jobj);
+	}
+
+	json_object_array_add(jpoison, jp);
+
+	return 0;
+}
+
+static struct json_object *
+util_cxl_poison_events_to_json(struct tracefs_instance *inst,
+			       const char *region_name, unsigned long flags)
+{
+	struct poison_event_ctx p_ctx = {
+		.region_name = region_name,
+		.flags = flags,
+	};
+	struct event_ctx ectx = {
+		.event_name = "cxl_poison",
+		.event_pid = getpid(),
+		.system = "cxl",
+		.private_ctx = &p_ctx,
+		.parse_event = poison_event_to_json,
+	};
+	int rc = 0;
+
+	p_ctx.jpoison = json_object_new_array();
+	if (!p_ctx.jpoison)
+		return NULL;
+
+	rc = cxl_parse_events(inst, &ectx);
+	if (rc < 0) {
+		fprintf(stderr, "Failed to parse events: %d\n", rc);
+		json_object_put(p_ctx.jpoison);
+		return NULL;
+	}
+
+	if (json_object_array_length(p_ctx.jpoison) == 0) {
+		json_object_put(p_ctx.jpoison);
+		return NULL;
+	}
+
+	return p_ctx.jpoison;
+}
+
+static struct json_object *
+util_cxl_poison_list_to_json(struct cxl_region *region,
+			     struct cxl_memdev *memdev,
+			     unsigned long flags)
+{
+	struct json_object *jpoison = NULL;
+	struct tracefs_instance *inst;
+	const char *region_name;
+	int rc;
+
+	inst = tracefs_instance_create("cxl list");
+	if (!inst) {
+		fprintf(stderr, "tracefs_instance_create() failed\n");
+		return NULL;
+	}
+
+	rc = cxl_event_tracing_enable(inst, "cxl", "cxl_poison");
+	if (rc < 0) {
+		fprintf(stderr, "Failed to enable trace: %d\n", rc);
+		goto err_free;
+	}
+
+	if (region)
+		rc = cxl_region_trigger_poison_list(region);
+	else
+		rc = cxl_memdev_trigger_poison_list(memdev);
+	if (rc)
+		goto err_free;
+
+	rc = cxl_event_tracing_disable(inst);
+	if (rc < 0) {
+		fprintf(stderr, "Failed to disable trace: %d\n", rc);
+		goto err_free;
+	}
+
+	region_name = region ? cxl_region_get_devname(region) : NULL;
+	jpoison = util_cxl_poison_events_to_json(inst, region_name, flags);
+
+err_free:
+	tracefs_instance_free(inst);
+	return jpoison;
+}
+
 struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		unsigned long flags)
 {
@@ -649,6 +855,12 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 			json_object_object_add(jdev, "firmware", jobj);
 	}
 
+	if (flags & UTIL_JSON_MEDIA_ERRORS) {
+		jobj = util_cxl_poison_list_to_json(NULL, memdev, flags);
+		if (jobj)
+			json_object_object_add(jdev, "media_errors", jobj);
+	}
+
 	json_object_set_userdata(jdev, memdev, NULL);
 	return jdev;
 }
@@ -987,6 +1199,12 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 			json_object_object_add(jregion, "state", jobj);
 	}
 
+	if (flags & UTIL_JSON_MEDIA_ERRORS) {
+		jobj = util_cxl_poison_list_to_json(region, NULL, flags);
+		if (jobj)
+			json_object_object_add(jregion, "media_errors", jobj);
+	}
+
 	util_cxl_mappings_append_json(jregion, region, flags);
 
 	if (flags & UTIL_JSON_DAX) {
-- 
2.37.3

