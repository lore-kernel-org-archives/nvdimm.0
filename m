Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FC018E28
	for <nvdimm@lists.linux.dev>; Sat,  6 Jul 2024 06:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720247102; cv=none; b=L+BD0AMBGuYgNaZPryzKzwv4LFD2T9aLmqEMj0G3oTEtNv6q+f7hB8jorVJ3MQ8dcdsp94GAugPc53fq2gPyZ3q/Ya/vUDRfPMnl84otiMHCCyKWZkl6TixNJqozMAN1sk48HQPGmcpxcYSNh4jNRyTnrclc5uGS8wzF1EnSCeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720247102; c=relaxed/simple;
	bh=rpaGUWaLvO4l8WKxDOXBPIRDuftOU8PVos6GfauBuQA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h3gQpvzHU088eh7S+pXt+60jfPAPWctY96KAfjQcqmk15NtsPsLuY/mZAhg5qo5I2gAHnGZnAdCIH5zJL2oaWmatwzlYi/Y34p8Tp0AYu0dB/qVlgbpz7FEP4arx36MVGppHJyOOSpFWDincQEs1ulq/9oFszlLXVinSYsqMVmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pb0EJRfF; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pb0EJRfF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720247101; x=1751783101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rpaGUWaLvO4l8WKxDOXBPIRDuftOU8PVos6GfauBuQA=;
  b=Pb0EJRfFUQBY6jxFoWX1kC5ANITg8aB7rySAj2lRUDxG8r6/dsixFjk8
   ur/3zlatX8ISD5uon6t0z5b4YJsfBqlCcImBGSWTC2bHq6YDNnlSHtBWq
   8D2Es/ZnTKz+E2/J44gNzva1Y8cIioiYMzmnTwZKmMUgFdib2UOowfUVg
   KYVWK9ZpC5W6FDk54NzCn/WiQdG6bqk4j8DeUPkSajx/zGlVnK2YPMU+g
   HUYR2ZlaeYFIAA234wxwveYFZ40gqQg6Oob9+bH2SH3KXPMtwISoQP21z
   UXfLfJvHOSxD6Q1jZQbVZjUf7VG6T6+jsW/sHxW2Q5/hIZerhKjDIso81
   w==;
X-CSE-ConnectionGUID: DHIwNoosQS2oje4UNc5+ag==
X-CSE-MsgGUID: xV4Iw9qOR0iXlWcs7spVqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="17166929"
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="17166929"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 23:24:59 -0700
X-CSE-ConnectionGUID: 1R2VyW2WTKO91mVvG3xZVw==
X-CSE-MsgGUID: TUxLEhG5RDyzB7C7A8leGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="78172487"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.72.84])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 23:24:59 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v13 1/8] util/trace: move trace helpers from ndctl/cxl/ to ndctl/util/
Date: Fri,  5 Jul 2024 23:24:47 -0700
Message-Id: <d1d60f8f475684e398fd0c415358c48105b42b45.1720241079.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1720241079.git.alison.schofield@intel.com>
References: <cover.1720241079.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

A set of helpers used to parse kernel trace events were introduced
in ndctl/cxl/ in support of the CXL monitor command. The work these
helpers perform may be useful beyond CXL.

Move them to the ndctl/util/ where other generic helpers reside.
Replace cxl-ish naming with generic names and update the single
user, cxl/monitor.c, to match.

This move is in preparation for extending the helpers in support
of cxl_poison trace events.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/meson.build             |  2 +-
 cxl/monitor.c               | 11 +++++------
 {cxl => util}/event_trace.c | 21 ++++++++++-----------
 {cxl => util}/event_trace.h | 12 ++++++------
 4 files changed, 22 insertions(+), 24 deletions(-)
 rename {cxl => util}/event_trace.c (88%)
 rename {cxl => util}/event_trace.h (61%)

diff --git a/cxl/meson.build b/cxl/meson.build
index 61b4d8762b42..e4d1683ce8c6 100644
--- a/cxl/meson.build
+++ b/cxl/meson.build
@@ -27,7 +27,7 @@ deps = [
 
 if get_option('libtracefs').enabled()
   cxl_src += [
-    'event_trace.c',
+    '../util/event_trace.c',
     'monitor.c',
   ]
   deps += [
diff --git a/cxl/monitor.c b/cxl/monitor.c
index a85452a4dc82..2066f984668d 100644
--- a/cxl/monitor.c
+++ b/cxl/monitor.c
@@ -28,8 +28,7 @@
 #define ENABLE_DEBUG
 #endif
 #include <util/log.h>
-
-#include "event_trace.h"
+#include <util/event_trace.h>
 
 static const char *cxl_system = "cxl";
 const char *default_log = "/var/log/cxl-monitor.log";
@@ -87,9 +86,9 @@ static int monitor_event(struct cxl_ctx *ctx)
 		goto epoll_ctl_err;
 	}
 
-	rc = cxl_event_tracing_enable(inst, cxl_system, NULL);
+	rc = trace_event_enable(inst, cxl_system, NULL);
 	if (rc < 0) {
-		err(&monitor, "cxl_trace_event_enable() failed: %d\n", rc);
+		err(&monitor, "trace_event_enable() failed: %d\n", rc);
 		goto event_en_err;
 	}
 
@@ -112,7 +111,7 @@ static int monitor_event(struct cxl_ctx *ctx)
 		}
 
 		list_head_init(&ectx.jlist_head);
-		rc = cxl_parse_events(inst, &ectx);
+		rc = trace_event_parse(inst, &ectx);
 		if (rc < 0)
 			goto parse_err;
 
@@ -129,7 +128,7 @@ static int monitor_event(struct cxl_ctx *ctx)
 	}
 
 parse_err:
-	if (cxl_event_tracing_disable(inst) < 0)
+	if (trace_event_disable(inst) < 0)
 		err(&monitor, "failed to disable tracing\n");
 event_en_err:
 epoll_ctl_err:
diff --git a/cxl/event_trace.c b/util/event_trace.c
similarity index 88%
rename from cxl/event_trace.c
rename to util/event_trace.c
index 1b5aa09de8b2..16013412bc06 100644
--- a/cxl/event_trace.c
+++ b/util/event_trace.c
@@ -59,8 +59,8 @@ static struct json_object *num_to_json(void *num, int elem_size, unsigned long f
 	return json_object_new_int64(val);
 }
 
-static int cxl_event_to_json(struct tep_event *event, struct tep_record *record,
-			     struct list_head *jlist_head)
+static int event_to_json(struct tep_event *event, struct tep_record *record,
+			 struct list_head *jlist_head)
 {
 	struct json_object *jevent, *jobj, *jarray;
 	struct tep_format_field **fields;
@@ -200,8 +200,8 @@ err_jnode:
 	return rc;
 }
 
-static int cxl_event_parse(struct tep_event *event, struct tep_record *record,
-			   int cpu, void *ctx)
+static int event_parse(struct tep_event *event, struct tep_record *record,
+		       int cpu, void *ctx)
 {
 	struct event_ctx *event_ctx = (struct event_ctx *)ctx;
 
@@ -218,10 +218,10 @@ static int cxl_event_parse(struct tep_event *event, struct tep_record *record,
 		return event_ctx->parse_event(event, record,
 					      &event_ctx->jlist_head);
 
-	return cxl_event_to_json(event, record, &event_ctx->jlist_head);
+	return event_to_json(event, record, &event_ctx->jlist_head);
 }
 
-int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx)
+int trace_event_parse(struct tracefs_instance *inst, struct event_ctx *ectx)
 {
 	struct tep_handle *tep;
 	int rc;
@@ -230,14 +230,13 @@ int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx)
 	if (!tep)
 		return -ENOMEM;
 
-	rc = tracefs_iterate_raw_events(tep, inst, NULL, 0, cxl_event_parse,
-					ectx);
+	rc = tracefs_iterate_raw_events(tep, inst, NULL, 0, event_parse, ectx);
 	tep_free(tep);
 	return rc;
 }
 
-int cxl_event_tracing_enable(struct tracefs_instance *inst, const char *system,
-		const char *event)
+int trace_event_enable(struct tracefs_instance *inst, const char *system,
+		       const char *event)
 {
 	int rc;
 
@@ -252,7 +251,7 @@ int cxl_event_tracing_enable(struct tracefs_instance *inst, const char *system,
 	return 0;
 }
 
-int cxl_event_tracing_disable(struct tracefs_instance *inst)
+int trace_event_disable(struct tracefs_instance *inst)
 {
 	return tracefs_trace_off(inst);
 }
diff --git a/cxl/event_trace.h b/util/event_trace.h
similarity index 61%
rename from cxl/event_trace.h
rename to util/event_trace.h
index ec6267202c8b..37c39aded871 100644
--- a/cxl/event_trace.h
+++ b/util/event_trace.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (C) 2022 Intel Corporation. All rights reserved. */
-#ifndef __CXL_EVENT_TRACE_H__
-#define __CXL_EVENT_TRACE_H__
+#ifndef __UTIL_EVENT_TRACE_H__
+#define __UTIL_EVENT_TRACE_H__
 
 #include <json-c/json.h>
 #include <ccan/list/list.h>
@@ -19,9 +19,9 @@ struct event_ctx {
 			   struct list_head *jlist_head); /* optional */
 };
 
-int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx);
-int cxl_event_tracing_enable(struct tracefs_instance *inst, const char *system,
-		const char *event);
-int cxl_event_tracing_disable(struct tracefs_instance *inst);
+int trace_event_parse(struct tracefs_instance *inst, struct event_ctx *ectx);
+int trace_event_enable(struct tracefs_instance *inst, const char *system,
+		       const char *event);
+int trace_event_disable(struct tracefs_instance *inst);
 
 #endif
-- 
2.37.3

