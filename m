Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B49152DE5
	for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 19:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711569162; cv=none; b=fNYK7kNwM24kuMW9V9uUiCjtDsaaxe9498sGftyrGzV9MI5CbbekkNwfAcrzPwC4JKIHHu+PwIOVFa/kFXDffm0JWyoC5dg0yWsPECaaGGke3jU02s9fMLBAiGFEtk5avPJFIN8idR3kXbAi9+WjqkozZEO2OjoGBxKdpN4CWtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711569162; c=relaxed/simple;
	bh=YE203KzykANWnXmnYKkmOcjHVLEf4WznovEK9X8MIGY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gEgqcorwCVzQIlbpeZBml3TN4VGyY3oGWohf2jo2mMBodlhlTbQrSUsUvk1yenG7iSQ+eQr6VKIzYu0k8h4OuxzhaUB1rCs+M6dSlI+L0amf9zM8OCAn26oIqPmpwHEQZLzNBbkRdZR1eZSVQML9jQJdRRlkpt1tZODGn1ojd5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RdCV9Hgi; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RdCV9Hgi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711569160; x=1743105160;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YE203KzykANWnXmnYKkmOcjHVLEf4WznovEK9X8MIGY=;
  b=RdCV9HgiDIZ05lSDtMjQ5OuRm94rDEBinSbZMrb9iu8ZUVANNsuQeNqu
   jpVhonv6Bls/s4O8Yj5X3py3wadP2Nka5sBoMO3vpK7C7EVJhKnalGplJ
   JGPbltdwYL8fAULTU6VuoslgLM7sqyQh3HFttdEwOA38RpMBRaWqPWkbi
   a/UPkQ+eo41/Br1EdC77Mygz1kMoNqunLd6x3ga9yPiIOEnTYb6v1hsjs
   qTJXVeXZBcrPQGsirOk1DoMeVPBBBpjxEu8ZAJ4c4cmUw4Y+04G26w6PT
   kuq0Q3TiKjfaobXJegd0qEQ6QytIjLgRQIkbGPx9IGxCcXH7SMiQwyz2w
   w==;
X-CSE-ConnectionGUID: MlzWfmmhTVikc15stSK4Dw==
X-CSE-MsgGUID: tCVzRudDRhus8heJNxGeZA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6560223"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="6560223"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 12:52:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="47616355"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.82.250])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 12:52:40 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v12 6/8] cxl/list: collect and parse media_error records
Date: Wed, 27 Mar 2024 12:52:27 -0700
Message-Id: <c692d920f136e76802e3627142934b4eea9bf97c.1711519822.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1711519822.git.alison.schofield@intel.com>
References: <cover.1711519822.git.alison.schofield@intel.com>
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
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/json.c         | 195 +++++++++++++++++++++++++++++++++++++++++++++
 util/event_trace.h |   8 ++
 2 files changed, 203 insertions(+)

diff --git a/cxl/json.c b/cxl/json.c
index fbe41c78e82a..e3f54cc2568c 100644
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
+#include "../util/event_trace.h"
 
 #define CXL_FW_VERSION_STR_LEN	16
 #define CXL_FW_MAX_SLOTS	4
@@ -571,6 +575,185 @@ err_jobj:
 	return NULL;
 }
 
+/* CXL Spec 3.1 Table 8-140 Media Error Record */
+#define CXL_POISON_SOURCE_MAX 7
+static const char * const poison_source[] = { "Unknown", "External", "Internal",
+					     "Injected", "Reserved", "Reserved",
+					     "Reserved", "Vendor" };
+
+/* CXL Spec 3.1 Table 8-139 Get Poison List Output Payload */
+#define CXL_POISON_FLAG_MORE BIT(0)
+#define CXL_POISON_FLAG_OVERFLOW BIT(1)
+#define CXL_POISON_FLAG_SCANNING BIT(2)
+
+static int poison_event_to_json(struct tep_event *event,
+				struct tep_record *record,
+				struct event_ctx *e_ctx)
+{
+	struct cxl_poison_ctx *p_ctx = e_ctx->poison_ctx;
+	struct json_object *jp, *jobj, *jpoison = p_ctx->jpoison;
+	struct cxl_memdev *memdev = p_ctx->memdev;
+	struct cxl_region *region = p_ctx->region;
+	unsigned long flags = e_ctx->json_flags;
+	const char *region_name = NULL;
+	char flag_str[32] = { '\0' };
+	bool overflow = false;
+	u8 source, pflags;
+	u64 offset, ts;
+	u32 length;
+	char *str;
+	int len;
+
+	jp = json_object_new_object();
+	if (!jp)
+		return -ENOMEM;
+
+	/* Skip records not in this region when listing by region */
+	if (region)
+		region_name = cxl_region_get_devname(region);
+	if (region_name)
+		str = tep_get_field_raw(NULL, event, "region", record, &len, 0);
+	if ((region_name) && (strcmp(region_name, str) != 0)) {
+		json_object_put(jp);
+		return 0;
+	}
+	/* Include offset,length by region (hpa) or by memdev (dpa) */
+	if (region) {
+		offset = trace_get_field_u64(event, record, "hpa");
+		if (offset != ULLONG_MAX) {
+			offset = offset - cxl_region_get_resource(region);
+			jobj = util_json_object_hex(offset, flags);
+			if (jobj)
+				json_object_object_add(jp, "offset", jobj);
+		}
+	} else if (memdev) {
+		offset = trace_get_field_u64(event, record, "dpa");
+		if (offset != ULLONG_MAX) {
+			jobj = util_json_object_hex(offset, flags);
+			if (jobj)
+				json_object_object_add(jp, "offset", jobj);
+		}
+	}
+	length = trace_get_field_u32(event, record, "dpa_length");
+	jobj = util_json_object_size(length, flags);
+	if (jobj)
+		json_object_object_add(jp, "length", jobj);
+
+	/* Always include the poison source */
+	source = trace_get_field_u8(event, record, "source");
+	if (source <= CXL_POISON_SOURCE_MAX)
+		jobj = json_object_new_string(poison_source[source]);
+	else
+		jobj = json_object_new_string("Reserved");
+	if (jobj)
+		json_object_object_add(jp, "source", jobj);
+
+	/* Include flags and overflow time if present */
+	pflags = trace_get_field_u8(event, record, "flags");
+	if (pflags && pflags < UCHAR_MAX) {
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
+		ts = trace_get_field_u64(event, record, "overflow_ts");
+		jobj = util_json_object_hex(ts, flags);
+		if (jobj)
+			json_object_object_add(jp, "overflow_t", jobj);
+	}
+	json_object_array_add(jpoison, jp);
+
+	return 0;
+}
+
+static struct json_object *
+util_cxl_poison_events_to_json(struct tracefs_instance *inst,
+			       struct cxl_poison_ctx *p_ctx,
+			       unsigned long flags)
+{
+	struct event_ctx ectx = {
+		.event_name = "cxl_poison",
+		.event_pid = getpid(),
+		.system = "cxl",
+		.poison_ctx = p_ctx,
+		.json_flags = flags,
+		.parse_event = poison_event_to_json,
+	};
+	int rc;
+
+	p_ctx->jpoison = json_object_new_array();
+	if (!p_ctx->jpoison)
+		return NULL;
+
+	rc = trace_event_parse(inst, &ectx);
+	if (rc < 0) {
+		fprintf(stderr, "Failed to parse events: %d\n", rc);
+		goto put_jobj;
+	}
+	if (json_object_array_length(p_ctx->jpoison) == 0)
+		goto put_jobj;
+
+	return p_ctx->jpoison;
+
+put_jobj:
+	json_object_put(p_ctx->jpoison);
+	return NULL;
+}
+
+static struct json_object *
+util_cxl_poison_list_to_json(struct cxl_region *region,
+			     struct cxl_memdev *memdev,
+			     unsigned long flags)
+{
+	struct json_object *jpoison = NULL;
+	struct cxl_poison_ctx p_ctx;
+	struct tracefs_instance *inst;
+	int rc;
+
+	inst = tracefs_instance_create("cxl list");
+	if (!inst) {
+		fprintf(stderr, "tracefs_instance_create() failed\n");
+		return NULL;
+	}
+
+	rc = trace_event_enable(inst, "cxl", "cxl_poison");
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
+	rc = trace_event_disable(inst);
+	if (rc < 0) {
+		fprintf(stderr, "Failed to disable trace: %d\n", rc);
+		goto err_free;
+	}
+
+	p_ctx = (struct cxl_poison_ctx){
+		.region = region,
+		.memdev = memdev,
+	};
+	jpoison = util_cxl_poison_events_to_json(inst, &p_ctx, flags);
+
+err_free:
+	tracefs_instance_free(inst);
+	return jpoison;
+}
+
 struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		unsigned long flags)
 {
@@ -664,6 +847,12 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
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
@@ -1012,6 +1201,12 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
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
diff --git a/util/event_trace.h b/util/event_trace.h
index 4d498577a00f..a87407ff8296 100644
--- a/util/event_trace.h
+++ b/util/event_trace.h
@@ -12,11 +12,19 @@ struct jlist_node {
 	struct list_node list;
 };
 
+struct cxl_poison_ctx {
+	struct json_object *jpoison;
+	struct cxl_region *region;
+	struct cxl_memdev *memdev;
+};
+
 struct event_ctx {
 	const char *system;
 	struct list_head jlist_head;
 	const char *event_name; /* optional */
 	int event_pid; /* optional */
+	struct cxl_poison_ctx *poison_ctx; /* optional */
+	unsigned long json_flags;
 	int (*parse_event)(struct tep_event *event, struct tep_record *record,
 			   struct event_ctx *ctx);
 };
-- 
2.37.3

