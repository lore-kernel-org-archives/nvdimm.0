Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9632B361
	for <nvdimm@lists.linux.dev>; Thu, 10 Nov 2022 00:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668038878; x=1699574878;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SmObFSUKhAvOi9RG1lZX2VYePNpLXwzKEIb2Ji9XQOg=;
  b=mgmpU79t/Bs0OecYEvHgsGFeP4arbx34trSWfBSifgBW+hwY5Ln0a/Tp
   EF7U2iyPkeLQqb01URY+EHyhFIwAt874CZN5TEY0NH0WUkwOt1q/lGAa0
   6CX2yTo52T0YecaWn7LiDmRac5+sHPDyaSkEOEjtKAqOG0o9MJut3Ajn2
   7QS5dUrJwKWgVeVfJ3wJK+yJndee4T0aLxa5GqIZ34P0cE9E8VP6QdmwD
   i98EtW6iYMma18dOlVsCZup0ZmJsxRIfChNZyXCqglb7DWMcVGfMB+6rY
   rVa+Jv/z20iS0YALyTMYDh2kbZN6OUtzr4mcy9nlDA1sUvmvefiaetGtq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="294502085"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="294502085"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 16:07:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="882130254"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="882130254"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 16:07:57 -0800
Subject: [PATCH v5 5/7] ndctl: cxl: add monitor command for event trace events
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, rostedt@goodmis.org
Date: Wed, 09 Nov 2022 17:07:57 -0700
Message-ID: 
 <166803887731.145141.12691742774548909895.stgit@djiang5-desk3.ch.intel.com>
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

Add function that creates an event trace instance and utilize the cxl event
trace common functions to extract interested events from the trace buffer.
The monitoring function will pend on an epoll fd and wait for new events
to appear in the trace buffer.

Connect the monitoring functionality to the cxl monitor command. Add basic
functionality to the cxl monitor command where it can be launched as a daemon
and logging can be designated to stdout or a file.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/builtin.h   |    1 
 cxl/cxl.c       |    1 
 cxl/meson.build |    1 
 cxl/monitor.c   |  215 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 218 insertions(+)
 create mode 100644 cxl/monitor.c

diff --git a/cxl/builtin.h b/cxl/builtin.h
index b28c2213993b..34c5cfb49051 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -22,4 +22,5 @@ int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_enable_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_destroy_region(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx);
 #endif /* _CXL_BUILTIN_H_ */
diff --git a/cxl/cxl.c b/cxl/cxl.c
index dd1be7a054a1..3be7026f43d3 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -76,6 +76,7 @@ static struct cmd_struct commands[] = {
 	{ "enable-region", .c_fn = cmd_enable_region },
 	{ "disable-region", .c_fn = cmd_disable_region },
 	{ "destroy-region", .c_fn = cmd_destroy_region },
+	{ "monitor", .c_fn = cmd_monitor },
 };
 
 int main(int argc, const char **argv)
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
index 000000000000..31e6f98f5299
--- /dev/null
+++ b/cxl/monitor.c
@@ -0,0 +1,215 @@
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
+const char *default_log = "/var/log/cxl-monitor.log";
+
+static struct monitor {
+	const char *log;
+	struct log_ctx ctx;
+	FILE *log_file;
+	bool human;
+	bool verbose;
+	bool daemon;
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
+		err(&monitor, "tracefs_instance_create( failed: %d\n", rc);
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
+	rc = cxl_event_tracing_enable(inst, cxl_system, NULL);
+	if (rc < 0) {
+		err(&monitor, "cxl_trace_event_enable() failed: %d\n", rc);
+		goto event_en_err;
+	}
+
+	memset(&ectx, 0, sizeof(ectx));
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
+
+int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	const struct option options[] = {
+		OPT_FILENAME('l', "log", &monitor.log,
+				"<file> | standard",
+				"where to output the monitor's notification"),
+		OPT_BOOLEAN('\0', "daemon", &monitor.daemon,
+				"run cxl monitor as a daemon"),
+		OPT_BOOLEAN('u', "human", &monitor.human,
+				"use human friendly output formats"),
+		OPT_BOOLEAN('v', "verbose", &monitor.verbose,
+				"emit extra debug messages to log"),
+		OPT_END(),
+	};
+	const char * const u[] = {
+		"cxl monitor [<options>]",
+		NULL
+	};
+	const char *prefix ="./";
+	int rc = 0, i;
+
+	argc = parse_options_prefix(argc, argv, prefix, options, u, 0);
+	for (i = 0; i < argc; i++)
+		error("unknown parameter \"%s\"\n", argv[i]);
+	if (argc)
+		usage_with_options(u, options);
+
+	log_init(&monitor.ctx, "cxl/monitor", "CXL_MONITOR_LOG");
+	monitor.ctx.log_fn = log_standard;
+
+	if (monitor.verbose)
+		monitor.ctx.log_priority = LOG_DEBUG;
+	else
+		monitor.ctx.log_priority = LOG_INFO;
+
+	if (monitor.log) {
+		if (strncmp(monitor.log, "./", 2) != 0)
+			fix_filename(prefix, (const char **)&monitor.log);
+		if (strncmp(monitor.log, "./standard", 10) == 0 && !monitor.daemon) {
+			monitor.ctx.log_fn = log_standard;
+		} else {
+			const char *log = monitor.log;
+
+			if (!monitor.log)
+				log = default_log;
+			monitor.log_file = fopen(log, "a+");
+			if (!monitor.log_file) {
+				rc = -errno;
+				error("open %s failed: %d\n", monitor.log, rc);
+				goto out;
+			}
+			monitor.ctx.log_fn = log_file;
+		}
+	}
+
+	if (monitor.daemon) {
+		if (daemon(0, 0) != 0) {
+			err(&monitor, "daemon start failed\n");
+			goto out;
+		}
+		info(&monitor, "cxl monitor daemon started.\n");
+	}
+
+	rc = monitor_event(ctx);
+
+out:
+	if (monitor.log_file)
+		fclose(monitor.log_file);
+	return rc;
+}


