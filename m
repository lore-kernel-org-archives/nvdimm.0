Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B5833EE
	for <nvdimm@lists.linux.dev>; Sun,  1 Oct 2023 22:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696199501; x=1727735501;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ss2qGh5tc1nEVr3jP5K92uooA1Rp/4DXxMWMqYFg+wU=;
  b=LAItyVWBmKz6n2+OLndWi/VrIOfuyJHcUAuCLxtZn4JywsANvUTIgNTz
   k8i/V4tXKcFFnKGIB8n6RT4HoKZrJYC+XYLGyMeynS32ZN6+/vlisttQp
   +E4xMi2CRV9nj5J5HC/DjKt6NOj+y7vuKOkr9hfJmssnTeyWYSUffhOTI
   9gkwlapRBlp3QQDYH7vY5qpV8rOg2s34SdlAi9Ccf+3+PBANuHxbxo04r
   1HEGhJrHtyZLCNJQp5cZogaoe3U1mfTsJy9PIs6FehC+5Ua96YdQ/obj6
   uBrvmU/9IIcn+gJTtrr8extNiCk/2SIAMNdjsyxn52TFSiP29Vqjf3Z+k
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="367618321"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="367618321"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2023 15:31:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="779781963"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="779781963"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.251.20.198])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2023 15:31:39 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v2 3/5] cxl/list: collect and parse the poison list records
Date: Sun,  1 Oct 2023 15:31:33 -0700
Message-Id: <80f60f513ced74bc5eed7d0082faf74783fa41d7.1696196382.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1696196382.git.alison.schofield@intel.com>
References: <cover.1696196382.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Poison list records are logged as events in the kernel tracing
subsystem. To prepare the poison list for cxl list, enable tracing,
trigger the poison list read, and parse the generated cxl_poison
events into a json representation.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/json.c  | 208 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 util/json.h |   1 +
 2 files changed, 209 insertions(+)

diff --git a/cxl/json.c b/cxl/json.c
index 7678d02020b6..36db73de4f8f 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -2,15 +2,19 @@
 // Copyright (C) 2015-2021 Intel Corporation. All rights reserved.
 #include <limits.h>
 #include <util/json.h>
+#include <util/bitmap.h>
 #include <uuid/uuid.h>
 #include <cxl/libcxl.h>
 #include <json-c/json.h>
 #include <json-c/printbuf.h>
 #include <ccan/short_types/short_types.h>
+#include <traceevent/event-parse.h>
+#include <tracefs/tracefs.h>
 
 #include "filter.h"
 #include "json.h"
 #include "../daxctl/json.h"
+#include "event_trace.h"
 
 #define CXL_FW_VERSION_STR_LEN	16
 #define CXL_FW_MAX_SLOTS	4
@@ -571,6 +575,190 @@ err_jobj:
 	return NULL;
 }
 
+/* CXL 8.2.9.5.4.1 Get Poison List: Poison Source */
+#define CXL_POISON_SOURCE_UNKNOWN 0
+#define CXL_POISON_SOURCE_EXTERNAL 1
+#define CXL_POISON_SOURCE_INTERNAL 2
+#define CXL_POISON_SOURCE_INJECTED 3
+#define CXL_POISON_SOURCE_VENDOR 7
+
+/* CXL 8.2.9.5.4.1 Get Poison List: Payload out flags */
+#define CXL_POISON_FLAG_MORE BIT(0)
+#define CXL_POISON_FLAG_OVERFLOW BIT(1)
+#define CXL_POISON_FLAG_SCANNING BIT(2)
+
+static struct json_object *
+util_cxl_poison_events_to_json(struct tracefs_instance *inst, bool is_region,
+			       unsigned long flags)
+{
+	struct json_object *jerrors, *jmedia, *jobj = NULL;
+	struct jlist_node *jnode, *next;
+	struct event_ctx ectx = {
+		.event_name = "cxl_poison",
+		.event_pid = getpid(),
+		.system = "cxl",
+	};
+	int rc, count = 0;
+
+	list_head_init(&ectx.jlist_head);
+	rc = cxl_parse_events(inst, &ectx);
+	if (rc < 0) {
+		fprintf(stderr, "Failed to parse events: %d\n", rc);
+		return NULL;
+	}
+	/* Add nr_poison_records:0 to json */
+	if (list_empty(&ectx.jlist_head))
+		goto out;
+
+	jerrors = json_object_new_array();
+	if (!jerrors)
+		return NULL;
+
+	list_for_each_safe(&ectx.jlist_head, jnode, next, list) {
+		struct json_object *jval = NULL;
+		struct json_object *jp = NULL;
+		int source, pflags;
+		u64 addr, len;
+
+		jp = json_object_new_object();
+		if (!jp)
+			return NULL;
+
+		if (is_region) {
+			/* Add the memdev name in a by region list */
+			if (json_object_object_get_ex(jnode->jobj, "memdev",
+						      &jval))
+				json_object_object_add(jp, "memdev", jval);
+		}
+
+		/*
+		 * When listing is by memdev, region names and valid HPAs
+		 * will appear if the poison address is part of a region.
+		 * Pick up those valid region names and HPAs but ignore the
+		 * empties and invalids.
+		 */
+
+		/* Only add non NULL region names */
+		if (json_object_object_get_ex(jnode->jobj, "region", &jval)) {
+			if (strlen(json_object_get_string(jval)) != 0)
+				json_object_object_add(jp, "region", jval);
+		}
+		/* Only display valid HPAs */
+		if (json_object_object_get_ex(jnode->jobj, "hpa", &jval)) {
+			addr = json_object_get_uint64(jval);
+			if (addr != ULLONG_MAX) {
+				jobj = util_json_object_hex(addr, flags);
+				json_object_object_add(jp, "hpa", jobj);
+			}
+		}
+		if (json_object_object_get_ex(jnode->jobj, "dpa", &jval)) {
+			addr = json_object_get_int64(jval);
+			jobj = util_json_object_hex(addr, flags);
+			json_object_object_add(jp, "dpa", jobj);
+		}
+		if (json_object_object_get_ex(jnode->jobj, "dpa_length", &jval)) {
+			len = json_object_get_int64(jval);
+			jobj = util_json_object_size(len, flags);
+			json_object_object_add(jp, "dpa_length", jobj);
+		}
+		if (json_object_object_get_ex(jnode->jobj, "source", &jval)) {
+			source = json_object_get_int(jval);
+			if (source == CXL_POISON_SOURCE_UNKNOWN)
+				jobj = json_object_new_string("Unknown");
+			else if (source == CXL_POISON_SOURCE_EXTERNAL)
+				jobj = json_object_new_string("External");
+			else if (source == CXL_POISON_SOURCE_INTERNAL)
+				jobj = json_object_new_string("Internal");
+			else if (source == CXL_POISON_SOURCE_INJECTED)
+				jobj = json_object_new_string("Injected");
+			else if (source == CXL_POISON_SOURCE_VENDOR)
+				jobj = json_object_new_string("Vendor");
+			else
+				jobj = json_object_new_string("Reserved");
+			json_object_object_add(jp, "source", jobj);
+		}
+		if (json_object_object_get_ex(jnode->jobj, "flags", &jval)) {
+			char flag_str[32] = { '\0' };
+
+			pflags = json_object_get_int(jval);
+			if (pflags & CXL_POISON_FLAG_MORE)
+				strcat(flag_str, "More,");
+			if (pflags & CXL_POISON_FLAG_OVERFLOW)
+				strcat(flag_str, "Overflow,");
+			if (pflags & CXL_POISON_FLAG_SCANNING)
+				strcat(flag_str, "Scanning,");
+			jobj = json_object_new_string(flag_str);
+			if (jobj)
+				json_object_object_add(jp, "flags", jobj);
+		}
+		if (json_object_object_get_ex(jnode->jobj, "overflow_t", &jval))
+			json_object_object_add(jp, "overflow_time", jval);
+
+		json_object_array_add(jerrors, jp);
+		count++;
+	} /* list_for_each_safe */
+
+out:
+	jmedia = json_object_new_object();
+	if (!jmedia)
+		return NULL;
+
+	/* Always include the count. If count is zero, no records follow. */
+	jobj = json_object_new_int(count);
+	if (jobj)
+		json_object_object_add(jmedia, "nr_poison_records", jobj);
+	if (count)
+		json_object_object_add(jmedia, "poison_records", jerrors);
+
+	return jmedia;
+}
+
+struct cxl_poison_ctx {
+	void *dev;
+	bool is_region;
+};
+
+static struct json_object *
+util_cxl_poison_list_to_json(struct cxl_poison_ctx *pctx,
+			     unsigned long flags)
+{
+	struct json_object *jmedia = NULL;
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
+	if (pctx->is_region)
+		rc = cxl_region_trigger_poison_list(pctx->dev);
+	else
+		rc = cxl_memdev_trigger_poison_list(pctx->dev);
+	if (rc) {
+		fprintf(stderr, "Failed write of sysfs attribute: %d\n", rc);
+		goto err_free;
+	}
+
+	rc = cxl_event_tracing_disable(inst);
+	if (rc < 0) {
+		fprintf(stderr, "Failed to disable trace: %d\n", rc);
+		goto err_free;
+	}
+
+	jmedia = util_cxl_poison_events_to_json(inst, pctx->is_region, flags);
+err_free:
+	tracefs_instance_free(inst);
+	return jmedia;
+}
+
 struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		unsigned long flags)
 {
@@ -649,6 +837,16 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 			json_object_object_add(jdev, "firmware", jobj);
 	}
 
+	if (flags & UTIL_JSON_POISON_LIST) {
+		struct cxl_poison_ctx pctx = {
+			.dev = memdev,
+			.is_region = false,
+		};
+		jobj = util_cxl_poison_list_to_json(&pctx, flags);
+		if (jobj)
+			json_object_object_add(jdev, "poison", jobj);
+	}
+
 	json_object_set_userdata(jdev, memdev, NULL);
 	return jdev;
 }
@@ -987,6 +1185,16 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 			json_object_object_add(jregion, "state", jobj);
 	}
 
+	if (flags & UTIL_JSON_POISON_LIST) {
+		struct cxl_poison_ctx pectx = {
+			.dev = region,
+			.is_region = true,
+		};
+		jobj = util_cxl_poison_list_to_json(&pectx, flags);
+		if (jobj)
+			json_object_object_add(jregion, "poison", jobj);
+	}
+
 	util_cxl_mappings_append_json(jregion, region, flags);
 
 	if (flags & UTIL_JSON_DAX) {
diff --git a/util/json.h b/util/json.h
index ea370df4d1b7..3ae4074a95c3 100644
--- a/util/json.h
+++ b/util/json.h
@@ -21,6 +21,7 @@ enum util_json_flags {
 	UTIL_JSON_TARGETS	= (1 << 11),
 	UTIL_JSON_PARTITION	= (1 << 12),
 	UTIL_JSON_ALERT_CONFIG	= (1 << 13),
+	UTIL_JSON_POISON_LIST	= (1 << 14),
 };
 
 void util_display_json_array(FILE *f_out, struct json_object *jarray,
-- 
2.37.3

