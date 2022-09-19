Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B4F7481
	for <nvdimm@lists.linux.dev>; Mon, 19 Sep 2022 23:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663631201; x=1695167201;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wxHvp86GJD8bYcGle+ijwYCUQIn4oAnCr/tWh5NO3/Q=;
  b=edJftiiznVtb4tudwwETpcNosHaUzjwobp396IdwrXMch3kmm8EW6yj/
   X1vZU+mFmg/G/rGNHZRrhX7KPAIN4FRLPXcRzH8cwgudtFy2YqaFh0qYK
   H7vOyWP24397RzOQ/aDUrfPG7avU2fpoLU7Wa8LUYAf46i7D2fdZyaCtn
   A1u6FWFraNMiNZrqJkZSHgdXpsD8P1Em5j4qvtRAwgr01i+VnotuMamHj
   Mi4w8BupFiGIbAnqL42mCTLFN1JhlKbpIwR2G6qg3wDrYJNYiPm/8xdYt
   Jaaa4cReS7UH1O/pBZ5IdJF7af737A9KYmCbQvyS5/npxfucVvLtL2497
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="385838511"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="385838511"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:46:40 -0700
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="722504484"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:46:40 -0700
Subject: [PATCH v2 1/9] cxl: add helper function to parse trace event to json
 object
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 bwidawsk@kernel.org, dan.j.williams@intel.com, nafonten@amd.com,
 nvdimm@lists.linux.dev
Date: Mon, 19 Sep 2022 16:46:40 -0700
Message-ID: 
 <166363120028.3861186.15658213147992814983.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166363103019.3861186.3067220004819656109.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166363103019.3861186.3067220004819656109.stgit@djiang5-desk3.ch.intel.com>
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

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/event_trace.c |  166 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 cxl/event_trace.h |   14 ++++
 cxl/meson.build   |    2 +
 meson.build       |    1 
 4 files changed, 183 insertions(+)
 create mode 100644 cxl/event_trace.c
 create mode 100644 cxl/event_trace.h

diff --git a/cxl/event_trace.c b/cxl/event_trace.c
new file mode 100644
index 000000000000..ffa2a9b9b036
--- /dev/null
+++ b/cxl/event_trace.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2022, Intel Corp. All rights reserved.
+#include <stdio.h>
+#include <json-c/json.h>
+#include <util/json.h>
+#include <util/util.h>
+#include <util/parse-options.h>
+#include <util/parse-configs.h>
+#include <util/strbuf.h>
+#include <util/sysfs.h>
+#include <ccan/list/list.h>
+#include <ndctl/ndctl.h>
+#include <ndctl/libndctl.h>
+#include <sys/epoll.h>
+#include <sys/stat.h>
+#include <libcxl.h>
+#include <uuid/uuid.h>
+#include <traceevent/event-parse.h>
+#include "json.h"
+#include "event_trace.h"
+
+#define _GNU_SOURCE
+#include <string.h>
+
+static struct json_object *num_to_json(void *num, int size)
+{
+	if (size <= 4)
+		return json_object_new_int(*(int *)num);
+
+	return util_json_object_hex(*(unsigned long long *)num, 0);
+}
+
+static int cxl_event_to_json_callback(struct tep_event *event,
+		struct tep_record *record, struct list_head *jlist_head)
+{
+	struct tep_format_field **fields;
+	struct json_object *jevent, *jobj, *jarray;
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
+		goto err_jevent;
+	}
+	jnode->jobj = jevent;
+
+	fields = tep_event_fields(event);
+	if (!fields) {
+		rc = -ENOENT;
+		goto err;
+	}
+
+	jobj = json_object_new_string(event->system);
+	if (!jobj) {
+		rc = -ENOMEM;
+		goto err;
+	}
+	json_object_object_add(jevent, "system", jobj);
+
+	jobj = json_object_new_string(event->name);
+	if (!jobj) {
+		rc = -ENOMEM;
+		goto err;
+	}
+	json_object_object_add(jevent, "event", jobj);
+
+	jobj = json_object_new_uint64(record->ts);
+	if (!jobj) {
+		rc = -ENOMEM;
+		goto err;
+	}
+	json_object_object_add(jevent, "timestamp", jobj);
+
+	for (i = 0; fields[i]; i++) {
+		struct tep_format_field *f = fields[i];
+		int len;
+		char *tmp;
+
+		tmp = strcasestr(f->type, "char[]");
+		if (tmp) { /* event field is a string */
+			char *str;
+
+			str = tep_get_field_raw(NULL, event, f->name, record, &len, 0);
+			if (!str)
+				continue;
+
+			jobj = json_object_new_string(str);
+			if (!jobj) {
+				rc = -ENOMEM;
+				goto err;
+			}
+
+			json_object_object_add(jevent, f->name, jobj);
+		} else if (f->arraylen) { /* data array */
+			unsigned char *data;
+			int chunks;
+
+			data = tep_get_field_raw(NULL, event, f->name, record, &len, 0);
+			if (!data)
+				continue;
+
+			/* check to see if we have a UUID */
+			tmp = strcasestr(f->name, "uuid");
+			if (tmp && f->arraylen == 16) {
+				char uuid[SYSFS_ATTR_SIZE];
+
+				uuid_unparse(data, uuid);
+				jobj = json_object_new_string(uuid);
+				if (!jobj) {
+					rc = -ENOMEM;
+					goto err;
+				}
+
+				json_object_object_add(jevent, f->name, jobj);
+				continue;
+			}
+
+			jarray = json_object_new_array();
+			if (!jarray) {
+				rc = -ENOMEM;
+				goto err;
+			}
+
+			chunks = f->size / f->elementsize;
+			for (j = 0; j < chunks; j++) {
+				jobj = num_to_json(data, f->elementsize);
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
+			char *data;
+
+			data = tep_get_field_raw(NULL, event, f->name, record, &len, 0);
+			if (!data)
+				continue;
+
+			jobj = num_to_json(data, f->elementsize);
+			if (!jobj) {
+				rc = -ENOMEM;
+				goto err;
+			}
+
+			json_object_object_add(jevent, f->name, jobj);
+		}
+	}
+
+	list_add_tail(jlist_head, &jnode->list);
+	return 0;
+
+err:
+	json_object_put(jevent);
+err_jevent:
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


