Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BCC747E
	for <nvdimm@lists.linux.dev>; Mon, 19 Sep 2022 23:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663631207; x=1695167207;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9gaF7ojex/AWmcWNUcltPV8CEfpBA4/ub1OftBXVZhE=;
  b=hn9sMPGaouffT5Z4sMlOA+QhbCsl0IT5xHFfOHEmITIs3WGKGFzDYoN/
   HA5ZUKz1aMBzRMPPHQm7/iZAwQmsxR22hgU/jQBLdBMTuAA6o6sgfOC0H
   Zduu4J7HzQsT3z8dGXnKSHsqMoBfMJMaZhT1Pp9BJlG9q0GRV8UP3QuCp
   46Ie2mOekclH3SV6fVQTuzmnNR/+1ZRTBNWSiNz5xtoY3WU0DBDNU7/nU
   kj0GOcWivXCvb/eJ+xTEJVQ9LMQHAgxjLAO8XaQvxlhfmoqp4XUoXLkJF
   y5U15v9rGQ6RZkqtPDLTNRvY/2TkwR0hby+tY+nTzWIYWlRjgSslxyliQ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="286596927"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="286596927"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:46:46 -0700
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="722504506"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:46:46 -0700
Subject: [PATCH v2 2/9] cxl: add helper to parse through all current events
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 bwidawsk@kernel.org, dan.j.williams@intel.com, nafonten@amd.com,
 nvdimm@lists.linux.dev
Date: Mon, 19 Sep 2022 16:46:46 -0700
Message-ID: 
 <166363120598.3861186.12071132915910252601.stgit@djiang5-desk3.ch.intel.com>
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

Add common function to iterate through and extract the events in the
current trace buffer. The function uses tracefs_iterate_raw_events() from
libtracefs to go through all the events loaded into a tep_handle. A
callback is provided to the API call in order to parse the event. For cxl
monitor, an array of interested "systems" is provided in order to filter
for the interested events.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/event_trace.c |   33 +++++++++++++++++++++++++++++++++
 cxl/event_trace.h |    7 +++++++
 cxl/meson.build   |    1 +
 meson.build       |    2 ++
 4 files changed, 43 insertions(+)

diff --git a/cxl/event_trace.c b/cxl/event_trace.c
index ffa2a9b9b036..430146ce66f5 100644
--- a/cxl/event_trace.c
+++ b/cxl/event_trace.c
@@ -16,6 +16,7 @@
 #include <libcxl.h>
 #include <uuid/uuid.h>
 #include <traceevent/event-parse.h>
+#include <tracefs/tracefs.h>
 #include "json.h"
 #include "event_trace.h"
 
@@ -164,3 +165,35 @@ err_jevent:
 	free(jnode);
 	return rc;
 }
+
+static int cxl_event_parse_cb(struct tep_event *event, struct tep_record *record,
+		int cpu, void *ctx)
+{
+	struct event_ctx *event_ctx = (struct event_ctx *)ctx;
+	int rc;
+
+	/* Filter out all the events that the caller isn't interested in. */
+	if (strcmp(event->system, event_ctx->system) != 0)
+		return 0;
+
+	rc = cxl_event_to_json_callback(event, record, &event_ctx->jlist_head);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
+int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx)
+{
+	struct tep_handle *tep;
+	int rc;
+
+	tep = tracefs_local_events(NULL);
+	if (!tep)
+		return -ENOMEM;
+
+	rc = tracefs_iterate_raw_events(tep, inst, NULL, 0,
+			cxl_event_parse_cb, ectx);
+	tep_free(tep);
+	return rc;
+}
diff --git a/cxl/event_trace.h b/cxl/event_trace.h
index 00975a0b5680..2fbefa1586d9 100644
--- a/cxl/event_trace.h
+++ b/cxl/event_trace.h
@@ -11,4 +11,11 @@ struct jlist_node {
 	struct list_node list;
 };
 
+struct event_ctx {
+	const char *system;
+	struct list_head jlist_head;
+};
+
+int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx);
+
 #endif
diff --git a/cxl/meson.build b/cxl/meson.build
index 8c7733431613..c59876262e76 100644
--- a/cxl/meson.build
+++ b/cxl/meson.build
@@ -21,6 +21,7 @@ cxl_tool = executable('cxl',
     json,
     versiondep,
     traceevent,
+    tracefs,
   ],
   install : true,
   install_dir : rootbindir,
diff --git a/meson.build b/meson.build
index f611e0bdd7f3..c204c8ac52de 100644
--- a/meson.build
+++ b/meson.build
@@ -143,6 +143,8 @@ libudev = dependency('libudev')
 uuid = dependency('uuid')
 json = dependency('json-c')
 traceevent = dependency('libtraceevent')
+tracefs = dependency('libtracefs')
+
 if get_option('docs').enabled()
   if get_option('asciidoctor').enabled()
     asciidoc = find_program('asciidoctor', required : true)


