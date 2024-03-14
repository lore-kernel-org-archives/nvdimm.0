Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42DC8BF8
	for <nvdimm@lists.linux.dev>; Thu, 14 Mar 2024 04:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710389135; cv=none; b=TRx0E8oU0mF6FsB3aVzjL10zt//0beI/fIDhO/oq9wbvFZHUrQSIYAS2W12y+i6b65SaYUZwHJF01txz1sBgh0bVJRaiunbXs9ZUfnkDzmiqL8Jf4T1jxCaZCAv2jwg/jG8WaK4yIJBsX23aiRE4gcmwepxbMVXCm8zsblmMWLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710389135; c=relaxed/simple;
	bh=EmtUglyaKsNLMLpS4ME1KW7w3APTbjkZOU4AFJkGcNw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f6vy2hcca8mjgyz0Wz+ZWhMykOD+dHOHBhW/Yth725dqRnui1LKtrmHt/9r7OmT/4Nnoh1312iEJ3w7l6aFDNUpwMOZr5ARlu5NoTiRfFIsYSSlVY3BvX00isWdNf4OmwN4pyaQmlM2HgrJ2bkva//Ctd+PVBYpbGeqyDaXP8Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N6cRb6yU; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N6cRb6yU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710389132; x=1741925132;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EmtUglyaKsNLMLpS4ME1KW7w3APTbjkZOU4AFJkGcNw=;
  b=N6cRb6yUsVegHwo+TDsLzVndCPU4VCU5YQuJD8Dpz9KEiWCKHGktaew5
   xlnWijBp2DF/zNtLaLbLkMvYbjFTtXkUj17ZDm2l/5yQKEpkHLSXxNjAc
   tB6C7NYDGkqdhEJdenJC/wM/KmmQ5rArhEM8WEPVBnrcHosrbeZKcaoul
   Dk7IElnpfHMQ00ehBwHL9iZWKaYCyDCNCgy/y4AqJ9fl7eUcGQZCYFMBN
   uHRYAI3JBcjZkiVyoz3ZzHhNC7CmfCdMH9/yZgIsprazaHfPAyh5do8s7
   vguwQjStF7tEC35zN0dxEHdkE5IHhC8VL1JAUMGEBNmFM2PoKDyQQDDI3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="22648805"
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="22648805"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 21:05:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="12080695"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.86.131])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 21:05:31 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v11 5/7] cxl/list: collect and parse media_error records
Date: Wed, 13 Mar 2024 21:05:21 -0700
Message-Id: <20c83daf14ac45542e9b6ed4cddfaf659e0ce7b0.1710386468.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1710386468.git.alison.schofield@intel.com>
References: <cover.1710386468.git.alison.schofield@intel.com>
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
 cxl/json.c | 194 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 194 insertions(+)

diff --git a/cxl/json.c b/cxl/json.c
index fbe41c78e82a..974e98f13cec 100644
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
@@ -571,6 +575,184 @@ err_jobj:
 	return NULL;
 }
 
+/* CXL Spec 3.1 Table 8-140 Media Error Record */
+#define CXL_POISON_SOURCE_MAX 7
+static const char *poison_source[] = { "Unknown",  "External", "Internal",
+				       "Injected", "Reserved", "Reserved",
+				       "Reserved", "Vendor" };
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
+	struct poison_ctx *p_ctx = e_ctx->poison_ctx;
+	struct json_object *jp, *jobj, *jpoison = p_ctx->jpoison;
+	struct cxl_memdev *memdev = p_ctx->memdev;
+	struct cxl_region *region = p_ctx->region;
+	unsigned long flags = p_ctx->flags;
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
+		offset = cxl_get_field_u64(event, record, "hpa");
+		if (offset != ULLONG_MAX) {
+			offset = offset - cxl_region_get_resource(region);
+			jobj = util_json_object_hex(offset, flags);
+			if (jobj)
+				json_object_object_add(jp, "offset", jobj);
+		}
+	} else if (memdev) {
+		offset = cxl_get_field_u64(event, record, "dpa");
+		if (offset != ULLONG_MAX) {
+			jobj = util_json_object_hex(offset, flags);
+			if (jobj)
+				json_object_object_add(jp, "offset", jobj);
+		}
+	}
+	length = cxl_get_field_u32(event, record, "dpa_length");
+	jobj = util_json_object_size(length, flags);
+	if (jobj)
+		json_object_object_add(jp, "length", jobj);
+
+	/* Always include the poison source */
+	source = cxl_get_field_u8(event, record, "source");
+	if (source <= CXL_POISON_SOURCE_MAX)
+		jobj = json_object_new_string(poison_source[source]);
+	else
+		jobj = json_object_new_string("Reserved");
+	if (jobj)
+		json_object_object_add(jp, "source", jobj);
+
+	/* Include flags and overflow time if present */
+	pflags = cxl_get_field_u8(event, record, "flags");
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
+		ts = cxl_get_field_u64(event, record, "overflow_ts");
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
+			       struct poison_ctx *p_ctx)
+{
+	struct event_ctx ectx = {
+		.event_name = "cxl_poison",
+		.event_pid = getpid(),
+		.system = "cxl",
+		.poison_ctx = p_ctx,
+		.parse_event = poison_event_to_json,
+	};
+	int rc = 0;
+
+	p_ctx->jpoison = json_object_new_array();
+	if (!p_ctx->jpoison)
+		return NULL;
+
+	rc = cxl_parse_events(inst, &ectx);
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
+	struct poison_ctx p_ctx;
+	struct tracefs_instance *inst;
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
+	p_ctx = (struct poison_ctx) {
+		.region = region,
+		.memdev = memdev,
+		.flags = flags,
+	};
+	jpoison = util_cxl_poison_events_to_json(inst, &p_ctx);
+
+err_free:
+	tracefs_instance_free(inst);
+	return jpoison;
+}
+
 struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		unsigned long flags)
 {
@@ -664,6 +846,12 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
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
@@ -1012,6 +1200,12 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
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

