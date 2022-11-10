Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7935318D
	for <nvdimm@lists.linux.dev>; Thu, 10 Nov 2022 00:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668038855; x=1699574855;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KTcf9Jz6Ov8SqHJS+xOJqORQ8ow/mqJlAXNoct1UmG0=;
  b=bKifKZ3eY2E6NzNJFkmX8PEx0Cj+JlsEO5C8RM96sL1jSChTiMlW418s
   wslM9qXLaJ6dpSyPuLsM9tJR2jxolCD3+jspYZndH5o9O9+TOFbXdEPLv
   4PAu+OScv9rzooV2X7f51AcHjNZ8itYCJ86lwLVx0QM9wp0MllmXMvnc3
   uk5kIupY4q7IX5DFr3jphjg+GDshqZOynEEr+LikVzniFdFNtJRResAwV
   9znVfVZuxoGyXRQSprpKaH64BhJy6StlDKZ73mSyGfzay9kI4GWbfwyiH
   WYajgCHUnsNnJc61Irv4iHOjUzWmE06ZYKkGCnFMPD4VxPDrtS/CqlMX0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="298650981"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="298650981"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 16:07:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="631442515"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="631442515"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 16:07:34 -0800
Subject: [PATCH v5 1/7] ndctl: cxl: add helper function to parse trace event
 to json object
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, rostedt@goodmis.org
Date: Wed, 09 Nov 2022 17:07:34 -0700
Message-ID: 
 <166803885399.145141.7371810852032502111.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166803877747.145141.11853418648969334939.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166803877747.145141.11853418648969334939.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add the helper function that parses a trace event captured by
libtraceevent in a tep handle. All the parsed fields are added to a json
object. The json object is added to the provided list in the input parameter.

Tested-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/event_trace.c |  193 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 cxl/event_trace.h |   14 ++++
 cxl/meson.build   |    2 +
 meson.build       |    1 
 4 files changed, 210 insertions(+)
 create mode 100644 cxl/event_trace.c
 create mode 100644 cxl/event_trace.h

diff --git a/cxl/event_trace.c b/cxl/event_trace.c
new file mode 100644
index 000000000000..3c9fb684139a
--- /dev/null
+++ b/cxl/event_trace.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2022, Intel Corp. All rights reserved.
+#include <stdio.h>
+#include <errno.h>
+#include <json-c/json.h>
+#include <util/json.h>
+#include <util/util.h>
+#include <util/strbuf.h>
+#include <ccan/list/list.h>
+#include <uuid/uuid.h>
+#include <traceevent/event-parse.h>
+#include "event_trace.h"
+
+#define _GNU_SOURCE
+#include <string.h>
+
+static struct json_object *num_to_json(void *num, int elem_size, unsigned long flags)
+{
+	bool sign = flags & TEP_FIELD_IS_SIGNED;
+	int64_t val = 0;
+
+	/* special case 64 bit as the call depends on sign */
+	if (elem_size == 8) {
+		if (sign)
+			return json_object_new_int64(*(int64_t *)num);
+		else
+			return json_object_new_uint64(*(uint64_t *)num);
+	}
+
+	/* All others fit in a signed 64 bit */
+	switch (elem_size) {
+	case 1:
+		if (sign)
+			val = *(int8_t *)num;
+		else
+			val = *(uint8_t *)num;
+		break;
+	case 2:
+		if (sign)
+			val = *(int16_t *)num;
+		else
+			val = *(uint16_t *)num;
+		break;
+	case 4:
+		if (sign)
+			val = *(int32_t *)num;
+		else
+			val = *(uint32_t *)num;
+		break;
+	default:
+		/*
+		 * Odd sizes are converted in the kernel to one of the above.
+		 * It is an error to see them here.
+		 */
+		return NULL;
+	}
+
+	return json_object_new_int64(val);
+}
+
+static int cxl_event_to_json(struct tep_event *event, struct tep_record *record,
+			     struct list_head *jlist_head)
+{
+	struct json_object *jevent, *jobj, *jarray;
+	struct tep_format_field **fields;
+	struct jlist_node *jnode;
+	int i, j, rc = 0;
+
+	jnode = malloc(sizeof(*jnode));
+	if (!jnode)
+		return -ENOMEM;
+
+	jevent = json_object_new_object();
+	if (!jevent) {
+		rc = -ENOMEM;
+		goto err_jnode;
+	}
+	jnode->jobj = jevent;
+
+	fields = tep_event_fields(event);
+	if (!fields) {
+		rc = -ENOENT;
+		goto err_jevent;
+	}
+
+	jobj = json_object_new_string(event->system);
+	if (!jobj) {
+		rc = -ENOMEM;
+		goto err_jevent;
+	}
+	json_object_object_add(jevent, "system", jobj);
+
+	jobj = json_object_new_string(event->name);
+	if (!jobj) {
+		rc = -ENOMEM;
+		goto err_jevent;
+	}
+	json_object_object_add(jevent, "event", jobj);
+
+	jobj = json_object_new_uint64(record->ts);
+	if (!jobj) {
+		rc = -ENOMEM;
+		goto err_jevent;
+	}
+	json_object_object_add(jevent, "timestamp", jobj);
+
+	for (i = 0; fields[i]; i++) {
+		struct tep_format_field *f = fields[i];
+		int len;
+
+		if (f->flags & TEP_FIELD_IS_STRING) {
+			char *str;
+
+			str = tep_get_field_raw(NULL, event, f->name, record, &len, 0);
+			if (!str)
+				continue;
+
+			jobj = json_object_new_string(str);
+			if (!jobj) {
+				rc = -ENOMEM;
+				goto err_jevent;
+			}
+
+			json_object_object_add(jevent, f->name, jobj);
+		} else if (f->flags & TEP_FIELD_IS_ARRAY) {
+			unsigned char *data;
+			int chunks;
+
+			data = tep_get_field_raw(NULL, event, f->name, record, &len, 0);
+			if (!data)
+				continue;
+
+			jarray = json_object_new_array();
+			if (!jarray) {
+				rc = -ENOMEM;
+				goto err_jevent;
+			}
+
+			chunks = f->size / f->elementsize;
+			for (j = 0; j < chunks; j++) {
+				jobj = num_to_json(data, f->elementsize, f->flags);
+				if (!jobj) {
+					json_object_put(jarray);
+					return -ENOMEM;
+				}
+				json_object_array_add(jarray, jobj);
+				data += f->elementsize;
+			}
+
+			json_object_object_add(jevent, f->name, jarray);
+		} else { /* single number */
+			unsigned char *data;
+			char *tmp;
+
+			data = tep_get_field_raw(NULL, event, f->name, record, &len, 0);
+			if (!data)
+				continue;
+
+			/* check to see if we have a UUID */
+			tmp = strcasestr(f->type, "uuid_t");
+			if (tmp) {
+				char uuid[40];
+
+				uuid_unparse(data, uuid);
+				jobj = json_object_new_string(uuid);
+				if (!jobj) {
+					rc = -ENOMEM;
+					goto err_jevent;
+				}
+
+				json_object_object_add(jevent, f->name, jobj);
+				continue;
+			}
+
+			jobj = num_to_json(data, f->elementsize, f->flags);
+			if (!jobj) {
+				rc = -ENOMEM;
+				goto err_jevent;
+			}
+
+			json_object_object_add(jevent, f->name, jobj);
+		}
+	}
+
+	list_add_tail(jlist_head, &jnode->list);
+	return 0;
+
+err_jevent:
+	json_object_put(jevent);
+err_jnode:
+	free(jnode);
+	return rc;
+}
diff --git a/cxl/event_trace.h b/cxl/event_trace.h
new file mode 100644
index 000000000000..00975a0b5680
--- /dev/null
+++ b/cxl/event_trace.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2022 Intel Corporation. All rights reserved. */
+#ifndef __CXL_EVENT_TRACE_H__
+#define __CXL_EVENT_TRACE_H__
+
+#include <json-c/json.h>
+#include <ccan/list/list.h>
+
+struct jlist_node {
+	struct json_object *jobj;
+	struct list_node list;
+};
+
+#endif
diff --git a/cxl/meson.build b/cxl/meson.build
index f2474aaa6e2e..8c7733431613 100644
--- a/cxl/meson.build
+++ b/cxl/meson.build
@@ -7,6 +7,7 @@ cxl_src = [
   'memdev.c',
   'json.c',
   'filter.c',
+  'event_trace.c',
 ]
 
 cxl_tool = executable('cxl',
@@ -19,6 +20,7 @@ cxl_tool = executable('cxl',
     kmod,
     json,
     versiondep,
+    traceevent,
   ],
   install : true,
   install_dir : rootbindir,
diff --git a/meson.build b/meson.build
index 20a646d135c7..f611e0bdd7f3 100644
--- a/meson.build
+++ b/meson.build
@@ -142,6 +142,7 @@ kmod = dependency('libkmod')
 libudev = dependency('libudev')
 uuid = dependency('uuid')
 json = dependency('json-c')
+traceevent = dependency('libtraceevent')
 if get_option('docs').enabled()
   if get_option('asciidoctor').enabled()
     asciidoc = find_program('asciidoctor', required : true)


