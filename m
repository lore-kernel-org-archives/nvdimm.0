Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B47261B91
	for <nvdimm@lists.linux.dev>; Thu, 25 Sep 2025 07:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758786886; cv=none; b=lAWsxU6zEzzzIpZlX5hn04T1TRAxsZDvUjzmJ7li99jN7gynab99BmKyUwlBUvEHj7OwvzxoQMsnMUuWHQlDoL8Q3UXmDwQF10e2TBm7g+CUdcFlQ321b2tRciQstB4FCxzjWOUWoLcqn5c5YS3Sb6qaqVP9zCc0D4lrxvxHH0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758786886; c=relaxed/simple;
	bh=jjCZ044ybAB6usxVpAr6EuCIruUqAxNhXLxyF0Cy2H4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pb51qJGsklvdEWZvPTWggNleg5UwBocLOlUdEIB6kA7XtYiNR7KJoAziF3DhJtryt3io1vXTyBSsRywtf6G6CtMoWImI2aoYrgfhsIT+nc7GKLDTXUEFeSs7gt5DmlFnGM4LmJguADhrxayNwHM4tuva7xPpdr/OpJwqd1LwLSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oCpY1+sn; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oCpY1+sn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758786885; x=1790322885;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jjCZ044ybAB6usxVpAr6EuCIruUqAxNhXLxyF0Cy2H4=;
  b=oCpY1+sni0TvgAMwtaDlmhAxX441/GYBs44hLhwBoefXXsNkkrR9PIjG
   6u6dzXO4kcsnFeu13pxYG6rgxcuMtLW472J/L/uDUzvbWUKvzelMFdiC0
   5MQ5XkwO5yaiHyQnxROieoBHFcHQHWF4Axq3KQM8WOqY7rHouOy6FOE5S
   awBtbb6bTUKBN5dh/N1OjhD0yI6DbPBQIj5lghrirfENHTAY2ye8FRtYi
   p+tF9DaqV1u6yqVWlorNuyPIj6OJdzL+YmxAN1xdz4GriYXUs3n+mMDHI
   6pGIVs6vT/8EtVKFQQmEFYTJSdlNxlmqZfrdmqBXG4jNv9K0cL5TeBb3b
   w==;
X-CSE-ConnectionGUID: UZfGKn8fT9a9PCA8ryQtrA==
X-CSE-MsgGUID: JZJgoMpoRMqL4LLZjrmTGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="83704652"
X-IronPort-AV: E=Sophos;i="6.18,292,1751266800"; 
   d="scan'208";a="83704652"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 00:54:44 -0700
X-CSE-ConnectionGUID: MJRmZ1mBS+2DCVBwKgLTSw==
X-CSE-MsgGUID: n2ui3W3FR9Geu4bzaG690w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,292,1751266800"; 
   d="scan'208";a="176863059"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.115])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 00:54:43 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Andreas Hasenack <andreas.hasenack@canonical.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v3] cxl/list: remove libtracefs build dependency for --media-errors
Date: Thu, 25 Sep 2025 00:54:29 -0700
Message-ID: <20250925075438.148935-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the --media-errors option was added to cxl list it inadvertently
changed the optional libtracefs requirement into a mandatory one.
Ndctl versions 80,81,82 no longer build without libtracefs.

Remove that dependency.

When libtracefs is disabled the user will see a this message logged
to stderr:
	$ cxl list -r region0 --media-errors --targets
	cxl list: --media-errors support disabled at build time

...followed by the region listing including the output for any other
valid command line options, like --targets in the example above.

When libtracefs is disabled the cxl-poison.sh unit test is omitted.

The man page gets a note:
	The media-error option is only available with -Dlibtracefs=enabled.

Reported-by: Andreas Hasenack <andreas.hasenack@canonical.com>
Fixes: d7532bb049e0 ("cxl/list: add --media-errors option to cxl list")
Closes: https://github.com/pmem/ndctl/issues/289
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20250924045302.90074-1-alison.schofield@intel.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Changes in v3:
- Remove ifdef's from .c files (Dan)
  Move ifdef chunk in json.c to a new conditionally compiled json_poison.c.
  Move ifdef notice message to !ENABLE_LIBTRACEFS stub in event_trace.h.
Changes in v2:
- Notify and continue when --media-error info is unavailable (Dan)

 Documentation/cxl/cxl-list.txt |   2 +
 config.h.meson                 |   2 +-
 cxl/json.c                     | 180 --------------------------------
 cxl/json_poison.c              | 185 +++++++++++++++++++++++++++++++++
 cxl/meson.build                |   1 +
 test/meson.build               |   9 +-
 util/event_trace.h             |  14 +++
 7 files changed, 210 insertions(+), 183 deletions(-)
 create mode 100644 cxl/json_poison.c

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 9a9911e7dd9b..0595638ee054 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -425,6 +425,8 @@ OPTIONS
 	"source:" is one of: External, Internal, Injected, Vendor Specific,
 	or Unknown, as defined in CXL Specification v3.1 Table 8-140.
 
+The media-errors option is only available with '-Dlibtracefs=enabled'.
+
 ----
 # cxl list -m mem9 --media-errors -u
 {
diff --git a/config.h.meson b/config.h.meson
index f75db3e6360f..e8539f8d04df 100644
--- a/config.h.meson
+++ b/config.h.meson
@@ -19,7 +19,7 @@
 /* ndctl test support */
 #mesondefine ENABLE_TEST
 
-/* cxl monitor support */
+/* cxl monitor and cxl list --media-errors support */
 #mesondefine ENABLE_LIBTRACEFS
 
 /* Define to 1 if big-endian-arch */
diff --git a/cxl/json.c b/cxl/json.c
index e65bd803b706..bde4589065e7 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -9,7 +9,6 @@
 #include <json-c/json.h>
 #include <json-c/printbuf.h>
 #include <ccan/short_types/short_types.h>
-#include <tracefs.h>
 
 #include "filter.h"
 #include "json.h"
@@ -575,185 +574,6 @@ err_jobj:
 	return NULL;
 }
 
-/* CXL Spec 3.1 Table 8-140 Media Error Record */
-#define CXL_POISON_SOURCE_MAX 7
-static const char *const poison_source[] = { "Unknown", "External", "Internal",
-					     "Injected", "Reserved", "Reserved",
-					     "Reserved", "Vendor Specific" };
-
-/* CXL Spec 3.1 Table 8-139 Get Poison List Output Payload */
-#define CXL_POISON_FLAG_MORE BIT(0)
-#define CXL_POISON_FLAG_OVERFLOW BIT(1)
-#define CXL_POISON_FLAG_SCANNING BIT(2)
-
-static int poison_event_to_json(struct tep_event *event,
-				struct tep_record *record,
-				struct event_ctx *e_ctx)
-{
-	struct cxl_poison_ctx *p_ctx = e_ctx->poison_ctx;
-	struct json_object *jp, *jobj, *jpoison = p_ctx->jpoison;
-	struct cxl_memdev *memdev = p_ctx->memdev;
-	struct cxl_region *region = p_ctx->region;
-	unsigned long flags = e_ctx->json_flags;
-	const char *region_name = NULL;
-	char flag_str[32] = { '\0' };
-	bool overflow = false;
-	u8 source, pflags;
-	u64 offset, ts;
-	u32 length;
-	char *str;
-	int len;
-
-	jp = json_object_new_object();
-	if (!jp)
-		return -ENOMEM;
-
-	/* Skip records not in this region when listing by region */
-	if (region)
-		region_name = cxl_region_get_devname(region);
-	if (region_name)
-		str = tep_get_field_raw(NULL, event, "region", record, &len, 0);
-	if ((region_name) && (strcmp(region_name, str) != 0)) {
-		json_object_put(jp);
-		return 0;
-	}
-	/* Include offset,length by region (hpa) or by memdev (dpa) */
-	if (region) {
-		offset = trace_get_field_u64(event, record, "hpa");
-		if (offset != ULLONG_MAX) {
-			offset = offset - cxl_region_get_resource(region);
-			jobj = util_json_object_hex(offset, flags);
-			if (jobj)
-				json_object_object_add(jp, "offset", jobj);
-		}
-	} else if (memdev) {
-		offset = trace_get_field_u64(event, record, "dpa");
-		if (offset != ULLONG_MAX) {
-			jobj = util_json_object_hex(offset, flags);
-			if (jobj)
-				json_object_object_add(jp, "offset", jobj);
-		}
-	}
-	length = trace_get_field_u32(event, record, "dpa_length");
-	jobj = util_json_object_size(length, flags);
-	if (jobj)
-		json_object_object_add(jp, "length", jobj);
-
-	/* Always include the poison source */
-	source = trace_get_field_u8(event, record, "source");
-	if (source <= CXL_POISON_SOURCE_MAX)
-		jobj = json_object_new_string(poison_source[source]);
-	else
-		jobj = json_object_new_string("Reserved");
-	if (jobj)
-		json_object_object_add(jp, "source", jobj);
-
-	/* Include flags and overflow time if present */
-	pflags = trace_get_field_u8(event, record, "flags");
-	if (pflags && pflags < UCHAR_MAX) {
-		if (pflags & CXL_POISON_FLAG_MORE)
-			strcat(flag_str, "More,");
-		if (pflags & CXL_POISON_FLAG_SCANNING)
-			strcat(flag_str, "Scanning,");
-		if (pflags & CXL_POISON_FLAG_OVERFLOW) {
-			strcat(flag_str, "Overflow,");
-			overflow = true;
-		}
-		jobj = json_object_new_string(flag_str);
-		if (jobj)
-			json_object_object_add(jp, "flags", jobj);
-	}
-	if (overflow) {
-		ts = trace_get_field_u64(event, record, "overflow_ts");
-		jobj = util_json_object_hex(ts, flags);
-		if (jobj)
-			json_object_object_add(jp, "overflow_t", jobj);
-	}
-	json_object_array_add(jpoison, jp);
-
-	return 0;
-}
-
-static struct json_object *
-util_cxl_poison_events_to_json(struct tracefs_instance *inst,
-			       struct cxl_poison_ctx *p_ctx,
-			       unsigned long flags)
-{
-	struct event_ctx ectx = {
-		.event_name = "cxl_poison",
-		.event_pid = getpid(),
-		.system = "cxl",
-		.poison_ctx = p_ctx,
-		.json_flags = flags,
-		.parse_event = poison_event_to_json,
-	};
-	int rc;
-
-	p_ctx->jpoison = json_object_new_array();
-	if (!p_ctx->jpoison)
-		return NULL;
-
-	rc = trace_event_parse(inst, &ectx);
-	if (rc < 0) {
-		fprintf(stderr, "Failed to parse events: %d\n", rc);
-		goto put_jobj;
-	}
-	if (json_object_array_length(p_ctx->jpoison) == 0)
-		goto put_jobj;
-
-	return p_ctx->jpoison;
-
-put_jobj:
-	json_object_put(p_ctx->jpoison);
-	return NULL;
-}
-
-static struct json_object *
-util_cxl_poison_list_to_json(struct cxl_region *region,
-			     struct cxl_memdev *memdev,
-			     unsigned long flags)
-{
-	struct json_object *jpoison = NULL;
-	struct cxl_poison_ctx p_ctx;
-	struct tracefs_instance *inst;
-	int rc;
-
-	inst = tracefs_instance_create("cxl list");
-	if (!inst) {
-		fprintf(stderr, "tracefs_instance_create() failed\n");
-		return NULL;
-	}
-
-	rc = trace_event_enable(inst, "cxl", "cxl_poison");
-	if (rc < 0) {
-		fprintf(stderr, "Failed to enable trace: %d\n", rc);
-		goto err_free;
-	}
-
-	if (region)
-		rc = cxl_region_trigger_poison_list(region);
-	else
-		rc = cxl_memdev_trigger_poison_list(memdev);
-	if (rc)
-		goto err_free;
-
-	rc = trace_event_disable(inst);
-	if (rc < 0) {
-		fprintf(stderr, "Failed to disable trace: %d\n", rc);
-		goto err_free;
-	}
-
-	p_ctx = (struct cxl_poison_ctx){
-		.region = region,
-		.memdev = memdev,
-	};
-	jpoison = util_cxl_poison_events_to_json(inst, &p_ctx, flags);
-
-err_free:
-	tracefs_instance_free(inst);
-	return jpoison;
-}
-
 struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		unsigned long flags)
 {
diff --git a/cxl/json_poison.c b/cxl/json_poison.c
new file mode 100644
index 000000000000..c8f18c73b83d
--- /dev/null
+++ b/cxl/json_poison.c
@@ -0,0 +1,185 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2015-2025 Intel Corporation. All rights reserved.
+#include <errno.h>
+#include <util/bitmap.h>
+#include <util/json.h>
+#include <cxl/libcxl.h>
+
+#include "../util/event_trace.h"
+
+/* CXL Spec 3.1 Table 8-140 Media Error Record */
+#define CXL_POISON_SOURCE_MAX 7
+static const char *const poison_source[] = { "Unknown", "External", "Internal",
+					     "Injected", "Reserved", "Reserved",
+					     "Reserved", "Vendor Specific" };
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
+struct json_object *util_cxl_poison_list_to_json(struct cxl_region *region,
+			struct cxl_memdev *memdev, unsigned long flags)
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
diff --git a/cxl/meson.build b/cxl/meson.build
index e4d1683ce8c6..b9924ae8efea 100644
--- a/cxl/meson.build
+++ b/cxl/meson.build
@@ -29,6 +29,7 @@ if get_option('libtracefs').enabled()
   cxl_src += [
     '../util/event_trace.c',
     'monitor.c',
+    'json_poison.c',
   ]
   deps += [
     traceevent,
diff --git a/test/meson.build b/test/meson.build
index 775542c1b787..615376ea635a 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -167,7 +167,6 @@ cxl_events = find_program('cxl-events.sh')
 cxl_sanitize = find_program('cxl-sanitize.sh')
 cxl_destroy_region = find_program('cxl-destroy-region.sh')
 cxl_qos_class = find_program('cxl-qos-class.sh')
-cxl_poison = find_program('cxl-poison.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -200,7 +199,6 @@ tests = [
   [ 'cxl-sanitize.sh',        cxl_sanitize,       'cxl'   ],
   [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
   [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
-  [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
@@ -253,6 +251,13 @@ if get_option('fwctl').enabled()
   ]
 endif
 
+if get_option('libtracefs').enabled()
+  cxl_poison = find_program('cxl-poison.sh')
+  tests += [
+    [ 'cxl-poison.sh', cxl_poison, 'cxl' ],
+  ]
+endif
+
 test_env = [
     'LC_ALL=C',
     'NDCTL=@0@'.format(ndctl_tool.full_path()),
diff --git a/util/event_trace.h b/util/event_trace.h
index a87407ff8296..989c02ec2259 100644
--- a/util/event_trace.h
+++ b/util/event_trace.h
@@ -7,6 +7,9 @@
 #include <ccan/list/list.h>
 #include <ccan/short_types/short_types.h>
 
+#ifdef ENABLE_LIBTRACEFS
+#include <tracefs.h>
+
 struct jlist_node {
 	struct json_object *jobj;
 	struct list_node list;
@@ -39,4 +42,15 @@ u32 trace_get_field_u32(struct tep_event *event, struct tep_record *record,
 			const char *name);
 u64 trace_get_field_u64(struct tep_event *event, struct tep_record *record,
 			const char *name);
+struct json_object *util_cxl_poison_list_to_json(struct cxl_region *region,
+			struct cxl_memdev *memdev, unsigned long flags);
+#else
+struct json_object *util_cxl_poison_list_to_json(struct cxl_region *region,
+			struct cxl_memdev *memdev, unsigned long flags)
+{
+	fprintf(stderr, "cxl list --media-errors support disabled at build time\n");
+	return NULL;
+}
+#endif /* ENABLE_LIBTRACEFS */
+
 #endif
-- 
2.37.3

