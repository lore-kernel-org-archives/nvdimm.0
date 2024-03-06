Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AEB13E7DB
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 18:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709750556; cv=none; b=N2yuNuOlT272Qr1VfO6nTyeCTw1giCyzde0EPCoUb3/PRztl7iKht6CPTov8mmiVf6zz/zONAFNNDgrp7rmZLkNlQld0dO+R/N+1n+vPXjj83XRT0L5f1jV645jb3a5cEW3dKH7rhiLhZG4rg+yWWayjIwol+JGjhaVLcY5AnTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709750556; c=relaxed/simple;
	bh=iWHnk1neQZIKAqWfpW+1RZrwfjWKjuOzgV4aWEXbwE8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DEdmtE8P6+0flZQe+RmSS4CEOUnucBm0gCQoBA2CB6R+Kg/od9CoOPQM2dTMkztO/eX2OGJ1iMMYS4bbXKw4RlfTxJj/ZKQFiIHnZ5zu9lCKpcdoSrJR8jftTTdkInK9kzF4KOFYkml036PNd2V/bnDb7W0WIIbXIvGLSP9Xeas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ChCjS2y2; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ChCjS2y2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709750554; x=1741286554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iWHnk1neQZIKAqWfpW+1RZrwfjWKjuOzgV4aWEXbwE8=;
  b=ChCjS2y25Aywb+oN/icJNWvpYsB03EcH1YSb+j0EiSWwaMJ2X8iZIvBe
   5k/xojA5Yi1YAyTdQqKQg9XriCzOrjZC804vcKE3lyS/wfZt4OdShzKQ1
   rgCQA4IMR+fEJrR2PnpcRqqwuisKDZ6hPvdhKtH8O178ttASeiudMCKHn
   bEKjttPnCSVgxpmZn9erttrTQx/NacF0n+oN+4uOEIP7GKf6z67ZjAdLx
   qNPV/Spo+iNG+aVSG67EbFR64gLdCex9gIC2CfcrYA1+EiZyTfupTrrm+
   PHng7p341/0ckgkXHfscHa+vjgHd1A8M6tV/ARPaXgwMc7Nr84nTZxe89
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="15819830"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="15819830"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 10:42:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9925978"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.251.9.155])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 10:42:33 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v10 5/7] cxl/list: collect and parse media_error records
Date: Wed,  6 Mar 2024 10:42:24 -0800
Message-Id: <9e3916d77162b4cbf6ee2636f13454f239f979c7.1709748564.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1709748564.git.alison.schofield@intel.com>
References: <cover.1709748564.git.alison.schofield@intel.com>
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
 cxl/json.c | 257 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 257 insertions(+)

diff --git a/cxl/json.c b/cxl/json.c
index fbe41c78e82a..435747de384d 100644
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
@@ -571,6 +575,247 @@ err_jobj:
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
+struct poison_ctx {
+	struct json_object *jpoison;
+	struct cxl_region *region;
+	struct cxl_memdev *memdev;
+	unsigned long flags;
+};
+
+static struct cxl_memdev *find_memdev(struct cxl_region *region,
+				      const char *memdev_name)
+{
+	struct cxl_memdev_mapping *mapping;
+	struct cxl_decoder *decoder;
+	struct cxl_memdev *memdev;
+
+	cxl_mapping_foreach(region, mapping)
+	{
+		decoder = cxl_mapping_get_decoder(mapping);
+		if (!decoder)
+			continue;
+
+		memdev = cxl_decoder_get_memdev(decoder);
+		if (strcmp(memdev_name, cxl_memdev_get_devname(memdev)) == 0)
+			break;
+
+		memdev = NULL;
+	}
+	return memdev;
+}
+
+static const char *find_decoder_name(struct poison_ctx *ctx,
+				     const char *memdev_name, u64 addr)
+{
+	struct cxl_memdev *memdev = ctx->memdev;
+	const char *decoder_name = NULL;
+	struct cxl_endpoint *endpoint;
+	struct cxl_decoder *decoder;
+	struct cxl_port *port;
+	u64 start, end;
+
+	if (!memdev)
+		memdev = find_memdev(ctx->region, memdev_name);
+
+	if (!memdev)
+		return NULL;
+
+	endpoint = cxl_memdev_get_endpoint(memdev);
+	port = cxl_endpoint_get_port(endpoint);
+
+	cxl_decoder_foreach(port, decoder) {
+		start =  cxl_decoder_get_resource(decoder);
+		end = start + cxl_decoder_get_size(decoder) - 1;
+		if (start <= addr && addr <= end) {
+			decoder_name = cxl_decoder_get_devname(decoder);
+			break;
+		}
+	}
+	return decoder_name;
+}
+
+static int poison_event_to_json(struct tep_event *event,
+				struct tep_record *record, void *ctx)
+{
+	struct poison_ctx *p_ctx = (struct poison_ctx *)ctx;
+	struct json_object *jobj, *jp, *jpoison = p_ctx->jpoison;
+	unsigned long flags = p_ctx->flags;
+	const char *decoder_name = NULL;
+	const char *region_name = NULL;
+	const char *memdev_name = NULL;
+	char flag_str[32] = { '\0' };
+	bool overflow = false;
+	u8 source, pflags;
+	u64 addr, ts;
+	u32 length;
+	char *str;
+
+	jp = json_object_new_object();
+	if (!jp)
+		return -ENOMEM;
+
+	/* Skip records not in this region when listing by region */
+	if (p_ctx->region)
+		region_name = cxl_region_get_devname(p_ctx->region);
+	if (region_name)
+		str = cxl_get_field_string(event, record, "region");
+
+	if ((region_name) && (strcmp(region_name, str) != 0)) {
+		json_object_put(jp);
+		return 0;
+	}
+
+	/* Include endpoint decoder name with hpa, when present */
+	addr = cxl_get_field_u64(event, record, "hpa");
+	if (addr != ULLONG_MAX) {
+		memdev_name = cxl_get_field_string(event, record, "memdev");
+		decoder_name = find_decoder_name(p_ctx, memdev_name, addr);
+	}
+	if (decoder_name) {
+		jobj = json_object_new_string(decoder_name);
+		if (jobj)
+			json_object_object_add(jp, "decoder", jobj);
+
+		jobj = util_json_object_hex(addr, flags);
+		if (jobj)
+			json_object_object_add(jp, "hpa", jobj);
+	}
+
+	addr = cxl_get_field_u64(event, record, "dpa");
+	jobj = util_json_object_hex(addr, flags);
+	if (jobj)
+		json_object_object_add(jp, "dpa", jobj);
+
+	length = cxl_get_field_u32(event, record, "dpa_length");
+	jobj = util_json_object_size(length, flags);
+	if (jobj)
+		json_object_object_add(jp, "length", jobj);
+
+	source = cxl_get_field_u8(event, record, "source");
+	if (source <= CXL_POISON_SOURCE_MAX)
+		jobj = json_object_new_string(poison_source[source]);
+	else
+		jobj = json_object_new_string("Reserved");
+
+	if (jobj)
+		json_object_object_add(jp, "source", jobj);
+
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
+
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
+		.private_ctx = p_ctx,
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
@@ -664,6 +909,12 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
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
@@ -1012,6 +1263,12 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
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

