Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2CE468C
	for <nvdimm@lists.linux.dev>; Thu, 13 Oct 2022 23:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665704349; x=1697240349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zEnApGXAQUYNutX4bVTfa5XihJiaaxkbJafnX9zSAH8=;
  b=KYz22xicaUc2YPFmddZQvR+p82VM/2WGJ71VJrK2Fq+19o57OyAC7Mf5
   U1+HKpFcCbTF/rifVHhLkXWip3Pqek7DPS9V7R7sFBQ6gJnLdLI6CiCyT
   Etk+LjdBlyyJXms4xtmIubZfl6uPUsG0vnc8E9HzFohD6zUovgVaWtA5C
   8MFgqx6j4kVORKFBXRnYD4jsmFQUOBEi9v/mLoqBzX6CP7SG/+Kdbmb3c
   425zAGbTjX5YnSK5/r0Oeo+P2BWIpaTQC2TRsOnAoEJPsw28K48HPQ22t
   9pt5qBZWpWLL+CUORxKsHG4Amys58zP6JEuZv8tq51n9puWmbDcZOqjfV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="285620551"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="285620551"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 16:39:09 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="872527645"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="872527645"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.212.171.186])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 16:39:08 -0700
From: alison.schofield@intel.com
To: Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [RFC 2/3] cxl/list: collect and parse the poison list records
Date: Thu, 13 Oct 2022 16:39:02 -0700
Message-Id: <ea11e8f1d0f3a6642fbf569002604074a9c7e391.1665699750.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1665699750.git.alison.schofield@intel.com>
References: <cover.1665699750.git.alison.schofield@intel.com>
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

Include memdev names and dpa->hpa address translation when
the --media-error request is made by region.

Otherwise, the "media-error records" matches the definition
in the CXL Spec 3.0 Table 8.107.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/json.c | 197 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 197 insertions(+)

diff --git a/cxl/json.c b/cxl/json.c
index 63c17519aba1..bf51b618cd72 100644
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
@@ -300,6 +304,179 @@ err_jobj:
 	return NULL;
 }
 
+/* CXL 8.2.9.5.4.1 Get Poison List: Poison Source */
+#define        CXL_POISON_SOURCE_UNKNOWN       0
+#define        CXL_POISON_SOURCE_EXTERNAL      1
+#define        CXL_POISON_SOURCE_INTERNAL      2
+#define        CXL_POISON_SOURCE_INJECTED      3
+#define        CXL_POISON_SOURCE_VENDOR        7
+
+/* CXL 8.2.9.5.4.1 Get Poison List: Payload out flags */
+#define CXL_POISON_FLAG_MORE            BIT(0)
+#define CXL_POISON_FLAG_OVERFLOW        BIT(1)
+#define CXL_POISON_FLAG_SCANNING        BIT(2)
+
+static struct
+json_object *util_cxl_poison_events_to_json(struct tracefs_instance *inst,
+					    bool is_memdev, unsigned long flags)
+{
+	struct json_object *jerrors, *jmedia, *jobj = NULL;
+	struct jlist_node *jnode, *next;
+	struct event_ctx ectx = {
+		.event_name = "cxl_poison",
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
+	/* jerrors will hold the ndctl-format-friendly json */
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
+		/* Is this event we're looking for */
+		json_object_object_get_ex(jnode->jobj, "pid", &jval);
+		if (getpid() != json_object_get_int(jval))
+			continue;
+
+		jp = json_object_new_object();
+		if (!jp)
+			return NULL;
+		if (is_memdev)
+			goto skip_to_memdev;
+
+		/* Add a memdev name to region records */
+		if (json_object_object_get_ex(jnode->jobj, "memdev", &jval))
+			json_object_object_add(jp, "memdev", jval);
+		/* Add the HPA to region records */
+		if (json_object_object_get_ex(jnode->jobj, "hpa", &jval)) {
+			addr = json_object_get_int(jval);
+			jobj = util_json_object_hex(addr, flags);
+			json_object_object_add(jp, "hpa", jobj);
+		}
+skip_to_memdev:
+		if (json_object_object_get_ex(jnode->jobj, "dpa", &jval)) {
+			addr = json_object_get_int(jval);
+			jobj = util_json_object_hex(addr, flags);
+			json_object_object_add(jp, "dpa", jobj);
+		}
+		if (json_object_object_get_ex(jnode->jobj, "length", &jval)) {
+			len = json_object_get_int(jval);
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
+		if (json_object_object_get_ex(jnode->jobj, "overflow_t",
+					      &jval))
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
+		json_object_object_add(jmedia, "nr media-errors", jobj);
+	if (count)
+		json_object_object_add(jmedia, "media-error records", jerrors);
+
+	return jmedia;
+}
+
+struct cxl_media_err_ctx {
+	void *dev;
+	bool is_memdev;
+};
+
+static struct
+json_object *util_cxl_media_errors_to_json(struct cxl_media_err_ctx *mectx,
+					   unsigned long flags)
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
+	rc = cxl_event_tracing_enable(inst, "cxl/cxl_poison");
+	if (rc < 0) {
+		fprintf(stderr, "Failed to enable trace: %d\n", rc);
+		goto err_free;
+	}
+
+	if (mectx->is_memdev)
+		rc = cxl_memdev_trigger_poison_list(mectx->dev);
+	else
+		rc = cxl_region_trigger_poison_list(mectx->dev);
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
+	jmedia = util_cxl_poison_events_to_json(inst, mectx->is_memdev, flags);
+err_free:
+	tracefs_instance_free(inst);
+	return jmedia;
+}
+
 struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		unsigned long flags)
 {
@@ -359,6 +536,16 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		if (jobj)
 			json_object_object_add(jdev, "partition_info", jobj);
 	}
+
+	if (flags & UTIL_JSON_MEDIA_ERRORS) {
+		struct cxl_media_err_ctx mectx = {
+			.dev = memdev,
+			.is_memdev = true,
+		};
+		jobj = util_cxl_media_errors_to_json(&mectx, flags);
+		if (jobj)
+			json_object_object_add(jdev, "media_errors", jobj);
+	}
 	return jdev;
 }
 
@@ -678,6 +865,16 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 			json_object_object_add(jregion, "state", jobj);
 	}
 
+	if (flags & UTIL_JSON_MEDIA_ERRORS) {
+		struct cxl_media_err_ctx mectx = {
+			.dev = region,
+			.is_memdev = false,
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

