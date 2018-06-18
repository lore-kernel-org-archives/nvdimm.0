Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 16A79203B99CA
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jun 2018 01:27:41 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 091EDAC0137
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jun 2018 17:27:38 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH v7 1/3] ndctl, monitor: add ndctl monitor
Date: Mon, 18 Jun 2018 17:26:59 +0900
Message-Id: <20180618082701.12326-2-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180618082701.12326-1-qi.fuli@jp.fujitsu.com>
References: <20180618082701.12326-1-qi.fuli@jp.fujitsu.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Ndctl monitor is used for monitoring the smart events of nvdimm DIMMs.
When a smart event fires, monitor will output the notifications which
including dimm health status and event infomations to syslog, stderr
or a logfile by setting [--logfile] option. The notifications follow
json format and can be consumed by log collectors like Fluentd.
DIMMsto monitor can be selected by [--dimm] [--region] [--namespace]
[--bus] options, and event type can be filtered by [--dimm-event] option,
these options support mutiple space-seperated arguments.

Ndctl monitor can be forked as a daemon by using [--daemon] option, like:
   # ndctl monitor --daemon --logfile /var/log/ndctl/monitor.log

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 builtin.h         |   1 +
 ndctl/Makefile.am |   3 +-
 ndctl/monitor.c   | 532 ++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/ndctl.c     |   1 +
 4 files changed, 536 insertions(+), 1 deletion(-)
 create mode 100644 ndctl/monitor.c

diff --git a/builtin.h b/builtin.h
index d3cc723..675a6ce 100644
--- a/builtin.h
+++ b/builtin.h
@@ -39,6 +39,7 @@ int cmd_inject_error(int argc, const char **argv, void *ctx);
 int cmd_wait_scrub(int argc, const char **argv, void *ctx);
 int cmd_start_scrub(int argc, const char **argv, void *ctx);
 int cmd_list(int argc, const char **argv, void *ctx);
+int cmd_monitor(int argc, const char **argv, void *ctx);
 #ifdef ENABLE_TEST
 int cmd_test(int argc, const char **argv, void *ctx);
 #endif
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index d22a379..7dbf223 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -16,7 +16,8 @@ ndctl_SOURCES = ndctl.c \
 		util/json-smart.c \
 		util/json-firmware.c \
 		inject-error.c \
-		inject-smart.c
+		inject-smart.c \
+		monitor.c
 
 if ENABLE_DESTRUCTIVE
 ndctl_SOURCES += ../test/blk_namespaces.c \
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
new file mode 100644
index 0000000..12aa499
--- /dev/null
+++ b/ndctl/monitor.c
@@ -0,0 +1,532 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018, FUJITSU LIMITED. All rights reserved. */
+
+#include <stdio.h>
+#include <json-c/json.h>
+#include <libgen.h>
+#include <dirent.h>
+#include <util/log.h>
+#include <util/json.h>
+#include <util/filter.h>
+#include <util/util.h>
+#include <util/parse-options.h>
+#include <util/strbuf.h>
+#include <ndctl/lib/private.h>
+#include <ndctl/libndctl.h>
+#include <sys/stat.h>
+#include <sys/epoll.h>
+#define BUF_SIZE 2048
+
+#define DIMM_SPARES_REMAINING	(1 << 0)
+#define DIMM_MEDIA_TEMPERATURE	(1 << 1)
+#define DIMM_CTRL_TEMPERATURE	(1 << 2)
+#define DIMM_HEALTH_STATE	(1 << 3)
+#define DIMM_UNCLEAN_SHUTDOWN	(1 << 4)
+
+static enum log_destination {
+	LOG_DESTINATION_STDERR = 1,
+	LOG_DESTINATION_SYSLOG = 2,
+	LOG_DESTINATION_FILE = 3,
+} log_destination = LOG_DESTINATION_SYSLOG;
+
+static struct {
+	const char *logfile;
+	const char *dimm_event;
+	bool daemon;
+} monitor;
+
+struct monitor_dimm {
+	struct ndctl_dimm *dimm;
+	int health_eventfd;
+	unsigned int health;
+	unsigned int event_flags;
+	struct list_node list;
+};
+
+struct monitor_filter_arg {
+	struct list_head dimms;
+	int maxfd_dimm;
+	int num_dimm;
+	unsigned long flags;
+};
+
+struct util_filter_params param;
+
+static int did_fail;
+
+#define fail(fmt, ...) \
+do { \
+	did_fail = 1; \
+	err((struct ndctl_ctx *)ctx, "ndctl-%s:%s:%d: " fmt, \
+			VERSION, __func__, __LINE__, ##__VA_ARGS__); \
+} while (0)
+
+static bool is_dir(char *filepath)
+{
+	DIR *dir = opendir(filepath);
+	if (dir) {
+		closedir(dir);
+		return true;
+	}
+	return false;
+}
+
+static void logreport(struct ndctl_ctx *ctx, int priority, const char *file,
+		int line, const char *fn, const char *format, va_list args)
+{
+	char *log_dir;
+	FILE *f;
+	char *buf = (char *)malloc(BUF_SIZE);
+	vsnprintf(buf, BUF_SIZE, format, args);
+
+	switch (log_destination) {
+	case LOG_DESTINATION_STDERR:
+		fprintf(stderr, "%s\n", buf);
+		goto end;
+
+	case LOG_DESTINATION_SYSLOG:
+		syslog(priority, "%s\n", buf);
+		goto end;
+
+	case LOG_DESTINATION_FILE:
+		log_dir = dirname(strdup(monitor.logfile));
+		if (!log_dir) {
+			log_destination = LOG_DESTINATION_SYSLOG;
+			fail("strdup %s failed\n%s", monitor.logfile, buf);
+			goto end;
+		}
+		if (!is_dir(log_dir)) {
+			log_destination = LOG_DESTINATION_SYSLOG;
+			fail("dir: %s is required\n%s", log_dir, buf);
+			free(log_dir);
+			goto end;
+		}
+		f = fopen(monitor.logfile, "a+");
+		if (!f) {
+			log_destination = LOG_DESTINATION_SYSLOG;
+			fail("open logfile %s failed\n%s", monitor.logfile, buf);
+			free(log_dir);
+			goto end;
+		}
+		fprintf(f, "%s\n", buf);
+		fclose(f);
+		free(log_dir);
+		goto end;
+	}
+end:
+	free(buf);
+	return;
+}
+
+static int get_monitor_dimm_data(struct monitor_dimm *mdimm)
+{
+	struct ndctl_cmd *cmd;
+	unsigned int alarm_flags;
+
+	cmd = ndctl_dimm_cmd_new_smart(mdimm->dimm);
+	if (!cmd)
+		goto out;
+
+	if (ndctl_cmd_submit(cmd))
+		goto out;
+
+	mdimm->health_eventfd = ndctl_dimm_get_health_eventfd(mdimm->dimm);
+
+	alarm_flags = ndctl_cmd_smart_get_alarm_flags(cmd);
+	if (alarm_flags & ND_SMART_SPARE_TRIP)
+		mdimm->event_flags |= DIMM_SPARES_REMAINING;
+	if (alarm_flags & ND_SMART_MTEMP_TRIP)
+		mdimm->event_flags |= DIMM_MEDIA_TEMPERATURE;
+	if (alarm_flags & ND_SMART_CTEMP_TRIP)
+		mdimm->event_flags |= DIMM_CTRL_TEMPERATURE;
+
+	mdimm->health = ndctl_cmd_smart_get_health(cmd);
+
+	if (ndctl_cmd_smart_get_shutdown_state(cmd))
+		mdimm->event_flags |= DIMM_UNCLEAN_SHUTDOWN;
+
+	ndctl_cmd_unref(cmd);
+	return 0;
+out:
+	if (cmd)
+		ndctl_cmd_unref(cmd);
+	return 1;
+}
+
+static struct json_object *dimm_event_to_json(struct monitor_dimm *mdimm)
+{
+	struct json_object *jevent, *jobj, *jdimm_health, *jdimm_detect;
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(mdimm->dimm);
+
+	jevent = json_object_new_object();
+	if (!jevent) {
+		fail("\n");
+		return NULL;
+	}
+
+	jdimm_health = json_object_new_array();
+	jdimm_detect = json_object_new_array();
+	if (!jdimm_health || !jdimm_detect) {
+		fail("\n");
+		goto out;
+	}
+
+	if (mdimm->event_flags & DIMM_SPARES_REMAINING) {
+		jobj = json_object_new_string("dimm-spares-remaining");
+		if (!jobj)
+			goto out;
+		json_object_array_add(jdimm_health, jobj);
+	}
+	if (mdimm->event_flags & DIMM_MEDIA_TEMPERATURE) {
+		jobj = json_object_new_string("dimm-media-temperature");
+		if (!jobj)
+			goto out;
+		json_object_array_add(jdimm_health, jobj);
+	}
+	if (mdimm->event_flags & DIMM_CTRL_TEMPERATURE) {
+		jobj = json_object_new_string("dimm-controller-temperature");
+		if (!jobj)
+			goto out;
+		json_object_array_add(jdimm_health, jobj);
+	}
+	if (mdimm->event_flags & DIMM_HEALTH_STATE) {
+		jobj = json_object_new_string("dimm-health-state");
+		if (!jobj)
+			goto out;
+		json_object_array_add(jdimm_health, jobj);
+	}
+	if (mdimm->event_flags & DIMM_UNCLEAN_SHUTDOWN) {
+		jobj = json_object_new_string("dimm-unclean-shutdown");
+		if (!jobj)
+			goto out;
+		json_object_array_add(jdimm_detect, jobj);
+	}
+
+	if (json_object_array_length(jdimm_health) > 0)
+		json_object_object_add(jevent, "dimm-health", jdimm_health);
+	else
+		free (jdimm_health);
+
+	if (json_object_array_length(jdimm_detect) > 0)
+		json_object_object_add(jevent, "dimm-detect", jdimm_detect);
+	else
+		free (jdimm_detect);
+
+	return jevent;
+out:
+	if (jdimm_health)
+		free(jdimm_health);
+	if (jdimm_detect)
+		free(jdimm_detect);
+	free(jevent);
+	return NULL;
+}
+
+static int notify_dimm_event(struct monitor_dimm *mdimm)
+{
+	struct json_object *jmsg, *jdimm, *jobj;
+	struct timespec ts;
+	char timestamp[32];
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(mdimm->dimm);
+
+	jmsg = json_object_new_object();
+	if (!jmsg) {
+		fail("\n");
+		return -1;
+	}
+
+	clock_gettime(CLOCK_REALTIME, &ts);
+	sprintf(timestamp, "%10ld.%09ld", ts.tv_sec, ts.tv_nsec);
+	jobj = json_object_new_string(timestamp);
+	if (!jobj) {
+		fail("\n");
+		return -1;
+	}
+	json_object_object_add(jmsg, "timestamp", jobj);
+
+	jobj = json_object_new_int(getpid());
+	if (!jobj) {
+		fail("\n");
+		return -1;
+	}
+	json_object_object_add(jmsg, "pid", jobj);
+
+	jobj = dimm_event_to_json(mdimm);
+	if (!jobj) {
+		fail("\n");
+		return -1;
+	}
+	json_object_object_add(jmsg, "event", jobj);
+
+	jdimm = util_dimm_to_json(mdimm->dimm, 0);
+	if (!jdimm) {
+		fail("\n");
+		return -1;
+	}
+	json_object_object_add(jmsg, "dimm", jdimm);
+
+	jobj = util_dimm_health_to_json(mdimm->dimm);
+	if (!jobj) {
+		fail("\n");
+		return -1;
+	}
+	json_object_object_add(jdimm, "health", jobj);
+
+	notice(ctx, "%s",
+		json_object_to_json_string_ext(jmsg, JSON_C_TO_STRING_PLAIN));
+	return 0;
+}
+
+static struct monitor_dimm *util_dimm_event_filter(struct monitor_dimm *mdimm,
+		const char *__ident)
+{
+	char *ident, *save;
+	const char *name;
+	struct monitor_dimm *__mdimm;
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(mdimm->dimm);
+
+	__mdimm = calloc(1, sizeof(struct monitor_dimm));
+	if (!__mdimm) {
+		fail("\n");
+		return NULL;
+	}
+
+	__mdimm->dimm = mdimm->dimm;
+	if (get_monitor_dimm_data(__mdimm)) {
+		fail("\n");
+		goto out;
+	}
+	if (mdimm->health != __mdimm->health)
+		__mdimm->event_flags |= DIMM_HEALTH_STATE;
+
+	if (!__ident)
+		return __mdimm;
+
+	ident = strdup(__ident);
+	if (!ident)
+		goto out;
+
+	for (name = strtok_r(ident, " ", &save); name;
+			name = strtok_r(NULL, " ", &save)) {
+		if (strcmp(name, "all") == 0)
+			break;
+
+		if (strcmp(name, "dimm-spares-remaining") == 0) {
+			if (__mdimm->event_flags & DIMM_SPARES_REMAINING)
+				break;
+		} else if (strcmp(name, "dimm-media-temperature") == 0) {
+			if (__mdimm->event_flags & DIMM_MEDIA_TEMPERATURE)
+				break;
+		} else if (strcmp(name, "dimm-controller-temperature") == 0) {
+			if (__mdimm->event_flags & DIMM_CTRL_TEMPERATURE)
+				break;
+		} else if (strcmp(name, "dimm-health-state") == 0) {
+			if (__mdimm->event_flags & DIMM_HEALTH_STATE)
+				break;
+		} else if (strcmp(name, "dimm-unclean-shutdown") == 0) {
+			if (__mdimm->event_flags & DIMM_UNCLEAN_SHUTDOWN)
+				break;
+		}
+	}
+	free(ident);
+
+	if (name)
+		return __mdimm;
+out:
+	free(__mdimm);
+	return NULL;
+}
+
+static bool filter_region(struct ndctl_region *region,
+		struct util_filter_ctx *ctx)
+{
+	return true;
+}
+
+static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *ctx)
+{
+	struct monitor_dimm *mdimm, *__mdimm;
+	struct monitor_filter_arg *mfa = (struct monitor_filter_arg *)ctx->arg;
+
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART_THRESHOLD))
+		return;
+
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART))
+		return;
+
+	mdimm = calloc(1, sizeof(struct monitor_dimm));
+	if (!mdimm)
+		return;
+
+	mdimm->dimm = dimm;
+	if (get_monitor_dimm_data(mdimm))
+		goto out;
+
+	if (mdimm->event_flags) {
+		__mdimm = util_dimm_event_filter(mdimm, monitor.dimm_event);
+		if (__mdimm) {
+			if (notify_dimm_event(__mdimm))
+				fail("notify dimm event failed\n");
+			free(__mdimm);
+		}
+	}
+
+	list_add_tail(&mfa->dimms, &mdimm->list);
+	if (mdimm->health_eventfd > mfa->maxfd_dimm)
+		mfa->maxfd_dimm = mdimm->health_eventfd;
+	mfa->num_dimm++;
+	return;
+out:
+	free(mdimm);
+	return;
+}
+
+static bool filter_bus(struct ndctl_bus *bus, struct util_filter_ctx *ctx)
+{
+	return true;
+}
+
+static int monitor_event(struct ndctl_ctx *ctx,
+		struct monitor_filter_arg *mfa)
+{
+	struct epoll_event ev, *events;
+	int nfds, epollfd, i, rc;
+	struct monitor_dimm *mdimm, *__mdimm;
+	char buf;
+
+	events = malloc(sizeof(struct epoll_event) * mfa->num_dimm);
+	if (!events) {
+		fail("malloc for events error\n");
+		goto out;
+	}
+	epollfd = epoll_create1(0);
+	if (epollfd == -1) {
+		fail("epoll_create1 error\n");
+		goto out;
+	}
+	list_for_each(&mfa->dimms, mdimm, list) {
+		memset(&ev, 0, sizeof(ev));
+		rc = pread(mdimm->health_eventfd, &buf, sizeof(buf), 0);
+		if (rc < 0) {
+			fail("pread error\n");
+			goto out;
+		}
+		ev.data.ptr = mdimm;
+		if (epoll_ctl(epollfd, EPOLL_CTL_ADD,
+				mdimm->health_eventfd, &ev) != 0) {
+			fail("epoll_ctl error\n");
+			goto out;
+		}
+	}
+
+	while (1) {
+		did_fail = 0;
+		nfds = epoll_wait(epollfd, events, mfa->num_dimm, -1);
+		if (nfds <= 0) {
+			fail("epoll_wait error\n");
+			goto out;
+		}
+		for (i = 0; i < nfds; i++) {
+			mdimm = events[i].data.ptr;
+			__mdimm = util_dimm_event_filter(mdimm,
+					monitor.dimm_event);
+			if (__mdimm) {
+				if (notify_dimm_event(__mdimm))
+					fail("notify dimm event failed\n");
+				free(__mdimm);
+			}
+			rc = pread(mdimm->health_eventfd, &buf, sizeof(buf), 0);
+			if (rc < 0) {
+				fail("pread error\n");
+				goto out;
+			}
+		}
+		if (did_fail)
+			goto out;
+	}
+	return 0;
+out:
+	return 1;
+}
+
+int cmd_monitor(int argc, const char **argv, void *ctx)
+{
+	int i;
+	const struct option options[] = {
+		OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
+		OPT_STRING('r', "region", &param.region, "region-id",
+				"filter by region"),
+		OPT_STRING('d', "dimm", &param.dimm, "dimm-id",
+				"filter by dimm"),
+		OPT_STRING('n', "namespace", &param.namespace,
+				"namespace-id", "filter by namespace id"),
+		OPT_FILENAME('l', "logfile", &monitor.logfile,
+				"file | syslog | stderr",
+				"where to output the monitor's notification"),
+		OPT_BOOLEAN('f', "daemon", &monitor.daemon,
+				"run ndctl monitor as a daemon"),
+		OPT_STRING('D', "dimm-event", &monitor.dimm_event,
+			"dimm-spares-remaining | dimm-media-temperature | dimm-controller-temperature | dimm-health-state | dimm-unclean-shutdown",
+			"filter by DIMM event type"),
+		OPT_END(),
+	};
+	const char * const u[] = {
+		"ndctl monitor [<options>]",
+		NULL
+	};
+	const char *prefix = "./";
+	struct util_filter_ctx fctx = { 0 };
+	struct monitor_filter_arg mfa = { 0 };
+
+	argc = parse_options_prefix(argc, argv, prefix, options, u, 0);
+	for (i = 0; i < argc; i++) {
+		error("unknown parameter \"%s\"\n", argv[i]);
+	}
+	if (argc)
+		usage_with_options(u, options);
+
+	ndctl_set_log_fn((struct ndctl_ctx *)ctx, logreport);
+	ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_INFO);
+
+	if (monitor.logfile) {
+		if (strcmp(monitor.logfile, "./stderr") == 0)
+			log_destination = LOG_DESTINATION_STDERR;
+		else if (strcmp(monitor.logfile, "./syslog") == 0)
+			log_destination = LOG_DESTINATION_SYSLOG;
+		else
+			log_destination = LOG_DESTINATION_FILE;
+	}
+
+	if (monitor.daemon) {
+		if (daemon(0, 0) != 0) {
+			fail("daemon start failed\n");
+			goto out;
+		}
+		info((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
+	}
+
+	fctx.filter_bus = filter_bus;
+	fctx.filter_dimm = filter_dimm;
+	fctx.filter_region = filter_region;
+	fctx.filter_namespace = NULL;
+	fctx.arg = &mfa;
+	list_head_init(&mfa.dimms);
+	mfa.num_dimm = 0;
+	mfa.maxfd_dimm = -1;
+	mfa.flags = 0;
+
+	if (util_filter_walk(ctx, &fctx, &param))
+		goto out;
+
+	if (!mfa.num_dimm) {
+		fail("no dimms can be monitored\n");
+		goto out;
+	}
+
+	if (monitor_event(ctx, &mfa))
+		goto out;
+
+	return 0;
+out:
+	return 1;
+}
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 7daadeb..73dabfa 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -89,6 +89,7 @@ static struct cmd_struct commands[] = {
 	{ "wait-scrub", cmd_wait_scrub },
 	{ "start-scrub", cmd_start_scrub },
 	{ "list", cmd_list },
+	{ "monitor", cmd_monitor},
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST
 	{ "test", cmd_test },
-- 
2.17.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
