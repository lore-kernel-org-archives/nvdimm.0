Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064755A0E1
	for <nvdimm@lists.linux.dev>; Tue, 21 Nov 2023 18:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HIxX69VT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700593138; x=1732129138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1HiFS6FENpqAFJKMqcAIx2DJoKRQ3U0cKHV50rxrN7o=;
  b=HIxX69VT81zk4/PJ8NPqao3qSFAf63pTsDKxm3cuRjdDQqHfc1nX0czb
   esF6le7WfRvAv+8aL4Zig9Z/3w25LkhYaXFFrqd/gNg4w7eDcKINUDbqo
   2EPxClFOUvOGdJ4rrZZ/Y+KaAV/jgtg8pn+GjYzxqfcOI7LhaYQEYxmaY
   TEv+VIj7MHJJ+OBO9N6/DSsBHyovGMZCjZfH425mrf+ELzO4Jigswqifo
   GuNPBmyQ+T6Ks4u/FssVgTXcn59ARXIAYra4JajI8cqCJL21YcPSIlVjz
   L21hadzvBIEAz1m4MMVeTvcMmPol5kPOH++2ijtJwITb3c6pvzw/MMPcS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="376939711"
X-IronPort-AV: E=Sophos;i="6.04,216,1695711600"; 
   d="scan'208";a="376939711"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 10:58:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="743139574"
X-IronPort-AV: E=Sophos;i="6.04,216,1695711600"; 
   d="scan'208";a="743139574"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.90.75])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 10:58:55 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v4 3/5] cxl/list: collect and parse the poison list records
Date: Tue, 21 Nov 2023 10:58:49 -0800
Message-Id: <bf65d11d6388bcdce2e6dc35064edf4094c0c5a8.1700591754.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1700591754.git.alison.schofield@intel.com>
References: <cover.1700591754.git.alison.schofield@intel.com>
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
 cxl/json.c | 211 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 211 insertions(+)

diff --git a/cxl/json.c b/cxl/json.c
index 7678d02020b6..6fb17582a1cb 100644
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
@@ -571,6 +575,201 @@ err_jobj:
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
+static struct json_object *
+util_cxl_poison_events_to_json(struct tracefs_instance *inst,
+			       const char *region_name, unsigned long flags)
+{
+	struct json_object *jerrors, *jpoison, *jobj = NULL;
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
+	/* Add nr_records:0 to json */
+	if (list_empty(&ectx.jlist_head))
+		goto out;
+
+	jerrors = json_object_new_array();
+	if (!jerrors)
+		return NULL;
+
+	list_for_each_safe(&ectx.jlist_head, jnode, next, list) {
+		struct json_object *jp, *jval;
+		int source, pflags = 0;
+		u64 addr, len;
+
+		jp = json_object_new_object();
+		if (!jp)
+			return NULL;
+
+		/* Skip records not in this region when listing by region */
+		if (json_object_object_get_ex(jnode->jobj, "region", &jval)) {
+			const char *name;
+
+			name = json_object_get_string(jval);
+			if ((region_name) && (strcmp(region_name, name) != 0))
+				continue;
+
+			if (strlen(name))
+				json_object_object_add(jp, "region", jval);
+		}
+
+		/* Memdev name is only needed when listing by region */
+		if (region_name) {
+			if (json_object_object_get_ex(jnode->jobj, "memdev",
+						      &jval))
+				json_object_object_add(jp, "memdev", jval);
+		}
+
+		/*
+		 * When listing by memdev, region names and valid HPAs
+		 * will appear if the poisoned address is part of a region.
+		 * Pick up those valid region names and HPAs and ignore
+		 * any empties and invalids.
+		 */
+
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
+			switch (source) {
+			case CXL_POISON_SOURCE_UNKNOWN:
+				jobj = json_object_new_string("Unknown");
+				break;
+			case CXL_POISON_SOURCE_EXTERNAL:
+				jobj = json_object_new_string("External");
+				break;
+			case CXL_POISON_SOURCE_INTERNAL:
+				jobj = json_object_new_string("Internal");
+				break;
+			case CXL_POISON_SOURCE_INJECTED:
+				jobj = json_object_new_string("Injected");
+				break;
+			case CXL_POISON_SOURCE_VENDOR:
+				jobj = json_object_new_string("Vendor");
+				break;
+			default:
+				jobj = json_object_new_string("Reserved");
+			}
+			json_object_object_add(jp, "source", jobj);
+		}
+		if (json_object_object_get_ex(jnode->jobj, "flags", &jval))
+			pflags = json_object_get_int(jval);
+
+		if (pflags) {
+			char flag_str[32] = { '\0' };
+
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
+	jpoison = json_object_new_object();
+	if (!jpoison)
+		return NULL;
+
+	/* Always include the count. If count is zero, no records follow. */
+	jobj = json_object_new_int(count);
+	if (jobj)
+		json_object_object_add(jpoison, "nr_records", jobj);
+	if (count)
+		json_object_object_add(jpoison, "records", jerrors);
+
+	return jpoison;
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
@@ -649,6 +848,12 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 			json_object_object_add(jdev, "firmware", jobj);
 	}
 
+	if (flags & UTIL_JSON_MEDIA_ERRORS) {
+		jobj = util_cxl_poison_list_to_json(NULL, memdev, flags);
+		if (jobj)
+			json_object_object_add(jdev, "poison", jobj);
+	}
+
 	json_object_set_userdata(jdev, memdev, NULL);
 	return jdev;
 }
@@ -987,6 +1192,12 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 			json_object_object_add(jregion, "state", jobj);
 	}
 
+	if (flags & UTIL_JSON_MEDIA_ERRORS) {
+		jobj = util_cxl_poison_list_to_json(region, NULL, flags);
+		if (jobj)
+			json_object_object_add(jregion, "poison", jobj);
+	}
+
 	util_cxl_mappings_append_json(jregion, region, flags);
 
 	if (flags & UTIL_JSON_DAX) {
-- 
2.37.3

