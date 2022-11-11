Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5A062A
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 03:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668136815; x=1699672815;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bRrw9/sMALUjvJ5/z2OV7l7YJ62K7WCyf7LWsqcrRRI=;
  b=Wp2o4CBIAlQueUQfOOQiYT/lqYQHl428dmzxTHwCyIkJbTvCTxZDW/Vj
   EP0E9miAP+uklyZDaqoGlnj+JufXEuSjt+Z0aPrKKvTu67AkJKNqQhedl
   2Jna9/yvkOiEoSo455Xri9qFu8dRbp/S4yc0x7n1uCJUtLmzpB/SaJK/I
   8UE+1xE9qYNutmdMxefhPw5NC0UIaOT8J1aOg51xTglKZ92fUmE6RmgX3
   CR1BcCtI2xm8NpdfJhW9Nf9eBZCeMa4TvK4v/fimG65DkpERXbi+lIVaV
   JPiOlmh6yFWh6bWnX3PgouMhcvOiLHsUK0XX+HN5BoI5Ky6escy8Byklm
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="373638353"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="373638353"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:20:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="743129966"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="743129966"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.161.45])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:20:14 -0800
From: alison.schofield@intel.com
To: Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 3/5] cxl/list: collect and parse the poison list records
Date: Thu, 10 Nov 2022 19:20:06 -0800
Message-Id: <b7b615f80c80086f17131b704d6171a0f6b01bea.1668133294.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1668133294.git.alison.schofield@intel.com>
References: <cover.1668133294.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

When triggered, poison list error records are logged as events
in the kernel tracing subsystem. Trace, trigger, and parse the
events when the --media-error option is selected in cxl list.

Include the total number of media-errors, even when zero.

The media-error records matches the definition in the CXL 3.0
Spec Table 8.107.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/json.c | 185 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 185 insertions(+)

diff --git a/cxl/json.c b/cxl/json.c
index 63c17519aba1..1b3c0bda6bda 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -2,14 +2,18 @@
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
+#include "event_trace.h"
 
 static struct json_object *util_cxl_memdev_health_to_json(
 		struct cxl_memdev *memdev, unsigned long flags)
@@ -300,6 +304,167 @@ err_jobj:
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
+	if (list_empty(&ectx.jlist_head))
+		return NULL;
+
+	jerrors = json_object_new_array();
+	if (!jerrors)
+		return NULL;
+
+	list_for_each_safe (&ectx.jlist_head, jnode, next, list) {
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
+			/* Per-region JSON includes memdev names */
+			if (json_object_object_get_ex(jnode->jobj, "memdev",
+						      &jval))
+				json_object_object_add(jp, "memdev", jval);
+		}
+		if (json_object_object_get_ex(jnode->jobj, "dpa", &jval)) {
+			addr = json_object_get_int64(jval);
+			jobj = util_json_object_hex(addr, flags);
+			json_object_object_add(jp, "dpa", jobj);
+		}
+		if (json_object_object_get_ex(jnode->jobj, "length", &jval)) {
+			len = json_object_get_int64(jval);
+			jobj = util_json_object_size(len, flags);
+			json_object_object_add(jp, "length", jobj);
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
+	jmedia = json_object_new_object();
+	if (!jmedia)
+		return NULL;
+
+	/* Always return the count. If count is zero, no records follow. */
+	jobj = json_object_new_int(count);
+	if (jobj)
+		json_object_object_add(jmedia, "nr_media_errors", jobj);
+	if (count)
+		json_object_object_add(jmedia, "media_error_records", jerrors);
+
+	return jmedia;
+}
+
+struct cxl_media_err_ctx {
+	void *dev;
+	bool is_region;
+};
+
+static struct json_object *
+util_cxl_media_errors_to_json(struct cxl_media_err_ctx *mectx,
+			      unsigned long flags)
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
+	if (mectx->is_region)
+		rc = cxl_region_trigger_poison_list(mectx->dev);
+	else
+		rc = cxl_memdev_trigger_poison_list(mectx->dev);
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
+	jmedia = util_cxl_poison_events_to_json(inst, mectx->is_region, flags);
+err_free:
+	tracefs_instance_free(inst);
+	return jmedia;
+}
+
 struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		unsigned long flags)
 {
@@ -359,6 +524,16 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		if (jobj)
 			json_object_object_add(jdev, "partition_info", jobj);
 	}
+
+	if (flags & UTIL_JSON_MEDIA_ERRORS) {
+		struct cxl_media_err_ctx mectx = {
+			.dev = memdev,
+			.is_region = false,
+		};
+		jobj = util_cxl_media_errors_to_json(&mectx, flags);
+		if (jobj)
+			json_object_object_add(jdev, "media_errors", jobj);
+	}
 	return jdev;
 }
 
@@ -678,6 +853,16 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 			json_object_object_add(jregion, "state", jobj);
 	}
 
+	if (flags & UTIL_JSON_MEDIA_ERRORS) {
+		struct cxl_media_err_ctx mectx = {
+			.dev = region,
+			.is_region = true,
+		};
+		jobj = util_cxl_media_errors_to_json(&mectx, flags);
+		if (jobj)
+			json_object_object_add(jregion, "media_errors", jobj);
+	}
+
 	util_cxl_mappings_append_json(jregion, region, flags);
 
 	return jregion;
-- 
2.37.3

