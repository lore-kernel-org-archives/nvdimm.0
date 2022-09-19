Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0A9747F
	for <nvdimm@lists.linux.dev>; Mon, 19 Sep 2022 23:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663631224; x=1695167224;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F57d+zjzoIt1Q65Wd0kg5lHTWfixkFLgMu7yJySmvpU=;
  b=CsDNz8wZYWGMSNbYr4vctkr9VJorpNv3uAH1j2b/2HHWnk74wyyU6ZIl
   BHpe0p1YRP8D3zzIT904IBRtfxykoHl/pvhN8xd2xgoilhetthDqO9pxS
   E2TAdfd8X9QljBxawkXx7mLCTJBGEA/N6dQ3c0cySO5gKvRbH3U8CSf/s
   Q5vDRrAEgR29pWZK83YpB4QQ4hyXIevaO6O4sDpvGGfq32fX2iLvVDz0S
   ecm84KkSJT7k0YTPGU9LX349k3V3UZ+ZsYpfLvDcWq/eAspnYsXBL+UDF
   prWwgfQ88Hiwyor+X3Rkqz8Ffm+zHoR+m/DAaS9nQZj4phZVGYd5iYifS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="300369302"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="300369302"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:47:04 -0700
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="618690475"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:47:04 -0700
Subject: [PATCH v2 5/9] cxl: add monitor function for event trace events
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 bwidawsk@kernel.org, dan.j.williams@intel.com, nafonten@amd.com,
 nvdimm@lists.linux.dev
Date: Mon, 19 Sep 2022 16:47:03 -0700
Message-ID: 
 <166363122375.3861186.15421184860713862858.stgit@djiang5-desk3.ch.intel.com>
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

Add function that creates an event trace instance and utilize the cxl event
trace common functions to extract interested events from the trace buffer.
The monitoring function will pend on an epoll fd and wait for new events
to appear in the trace buffer.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/meson.build |    1 
 cxl/monitor.c   |  139 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 140 insertions(+)
 create mode 100644 cxl/monitor.c

diff --git a/cxl/meson.build b/cxl/meson.build
index c59876262e76..eb8b2b1070ed 100644
--- a/cxl/meson.build
+++ b/cxl/meson.build
@@ -8,6 +8,7 @@ cxl_src = [
   'json.c',
   'filter.c',
   'event_trace.c',
+  'monitor.c',
 ]
 
 cxl_tool = executable('cxl',
diff --git a/cxl/monitor.c b/cxl/monitor.c
new file mode 100644
index 000000000000..759246926e05
--- /dev/null
+++ b/cxl/monitor.c
@@ -0,0 +1,139 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2022, Intel Corp. All rights reserved.
+/* Some bits copied from ndctl monitor code */
+#include <stdio.h>
+#include <unistd.h>
+#include <errno.h>
+#include <json-c/json.h>
+#include <libgen.h>
+#include <time.h>
+#include <dirent.h>
+#include <ccan/list/list.h>
+#include <util/json.h>
+#include <util/util.h>
+#include <util/parse-options.h>
+#include <util/parse-configs.h>
+#include <util/strbuf.h>
+#include <sys/epoll.h>
+#include <sys/stat.h>
+#include <traceevent/event-parse.h>
+#include <tracefs/tracefs.h>
+#include <cxl/libcxl.h>
+
+/* reuse the core log helpers for the monitor logger */
+#ifndef ENABLE_LOGGING
+#define ENABLE_LOGGING
+#endif
+#ifndef ENABLE_DEBUG
+#define ENABLE_DEBUG
+#endif
+#include <util/log.h>
+
+#include "event_trace.h"
+
+static const char *cxl_system = "cxl";
+
+static struct monitor {
+	struct log_ctx ctx;
+	FILE *log_file;
+	bool human;
+} monitor;
+
+static int monitor_event(struct cxl_ctx *ctx)
+{
+	int fd, epollfd, rc = 0, timeout = -1;
+	struct epoll_event ev, *events;
+	struct tracefs_instance *inst;
+	struct event_ctx ectx;
+	int jflag;
+
+	events = calloc(1, sizeof(struct epoll_event));
+	if (!events) {
+		err(&monitor, "alloc for events error\n");
+		return -ENOMEM;
+	}
+
+	epollfd = epoll_create1(0);
+	if (epollfd == -1) {
+		rc = -errno;
+		err(&monitor, "epoll_create1() error: %d\n", rc);
+		goto epoll_err;
+	}
+
+	inst = tracefs_instance_create("cxl_monitor");
+	if (!inst) {
+		rc = -errno;
+		err(&monitor, "tracefs_instance_crate( failed: %d\n", rc);
+		goto inst_err;
+	}
+
+	fd = tracefs_instance_file_open(inst, "trace_pipe", -1);
+	if (fd < 0) {
+		rc = fd;
+		err(&monitor, "tracefs_instance_file_open() err: %d\n", rc);
+		goto inst_file_err;
+	}
+
+	memset(&ev, 0, sizeof(ev));
+	ev.events = EPOLLIN;
+	ev.data.fd = fd;
+
+	if (epoll_ctl(epollfd, EPOLL_CTL_ADD, fd, &ev) != 0) {
+		rc = -errno;
+		err(&monitor, "epoll_ctl() error: %d\n", rc);
+		goto epoll_ctl_err;
+	}
+
+	rc = cxl_event_tracing_enable(inst, cxl_system);
+	if (rc < 0) {
+		err(&monitor, "cxl_trace_event_enable() failed: %d\n", rc);
+		goto event_en_err;
+	}
+
+	ectx.system = cxl_system;
+	if (monitor.human)
+		jflag = JSON_C_TO_STRING_PRETTY;
+	else
+		jflag = JSON_C_TO_STRING_PLAIN;
+
+	while (1) {
+		struct jlist_node *jnode, *next;
+
+		rc = epoll_wait(epollfd, events, 1, timeout);
+		if (rc < 0) {
+			rc = -errno;
+			if (errno != EINTR)
+				err(&monitor, "epoll_wait error: %d\n", -errno);
+			break;
+		}
+
+		list_head_init(&ectx.jlist_head);
+		rc = cxl_parse_events(inst, &ectx);
+		if (rc < 0)
+			goto parse_err;
+
+		if (list_empty(&ectx.jlist_head))
+			continue;
+
+		list_for_each_safe(&ectx.jlist_head, jnode, next, list) {
+			notice(&monitor, "%s\n",
+				json_object_to_json_string_ext(jnode->jobj, jflag));
+			list_del(&jnode->list);
+			json_object_put(jnode->jobj);
+			free(jnode);
+		}
+	}
+
+parse_err:
+	rc = cxl_event_tracing_disable(inst);
+event_en_err:
+epoll_ctl_err:
+	close(fd);
+inst_file_err:
+	tracefs_instance_free(inst);
+inst_err:
+	close(epollfd);
+epoll_err:
+	free(events);
+	return rc;
+}


