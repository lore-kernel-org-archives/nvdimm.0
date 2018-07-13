Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E73320988742
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 08:54:52 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id B239AAC021E
 for <linux-nvdimm@lists.01.org>; Sat, 14 Jul 2018 00:54:44 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH v12 1/5] ndctl, monitor: add a new command - monitor
Date: Sat, 14 Jul 2018 00:53:59 +0900
Message-Id: <20180713155403.30020-2-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180713155403.30020-1-qi.fuli@jp.fujitsu.com>
References: <20180713155403.30020-1-qi.fuli@jp.fujitsu.com>
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
Cc: tokunaga.keiich@jp.fujitsu.com
List-ID: <linux-nvdimm@lists.01.org>

Ndctl monitor is used for monitoring the smart events of NVDIMMs.
When a smart event fires, monitor will output the notifications which
include dimm health status and event information to syslog, standard
output or a file by setting [--log] option. The notifications follow
json format and can be consumed by log collectors like Fluentd.

The objects to monitor can be selected by setting [--dimm] [--region]
[--namespace] [--bus] options and the event type can be filtered by
setting [--dimm-event] option. These options support multiple
space-separated arguments.

Ndctl monitor can be forked as a daemon by using [--daemon] option,
such as:
   # ndctl monitor --daemon --log /var/log/ndctl/monitor.log

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 builtin.h              |   1 +
 ndctl/Makefile.am      |   3 +-
 ndctl/lib/libndctl.c   |  82 +++++++
 ndctl/lib/libndctl.sym |   4 +
 ndctl/libndctl.h       |  10 +
 ndctl/monitor.c        | 539 +++++++++++++++++++++++++++++++++++++++++
 ndctl/ndctl.c          |   1 +
 util/filter.h          |   9 +
 8 files changed, 648 insertions(+), 1 deletion(-)
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
index 0f56871..083609a 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -15,7 +15,8 @@ ndctl_SOURCES = ndctl.c \
 		util/json-smart.c \
 		util/json-firmware.c \
 		inject-error.c \
-		inject-smart.c
+		inject-smart.c \
+		monitor.c
 
 if ENABLE_DESTRUCTIVE
 ndctl_SOURCES += ../test/blk_namespaces.c \
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 47e005e..969e4aa 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1635,6 +1635,88 @@ NDCTL_EXPORT int ndctl_dimm_get_health_eventfd(struct ndctl_dimm *dimm)
 	return dimm->health_eventfd;
 }
 
+NDCTL_EXPORT unsigned int ndctl_dimm_get_health(struct ndctl_dimm *dimm)
+{
+	struct ndctl_cmd *cmd = NULL;
+	unsigned int health;
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	const char *devname = ndctl_dimm_get_devname(dimm);
+
+	cmd = ndctl_dimm_cmd_new_smart(dimm);
+	if (!cmd) {
+		err(ctx, "%s: no smart command support\n", devname);
+		return UINT_MAX;
+	}
+	if (ndctl_cmd_submit(cmd)) {
+		err(ctx, "%s: smart command failed\n", devname);
+		return UINT_MAX;
+	}
+
+	health = ndctl_cmd_smart_get_health(cmd);
+	ndctl_cmd_unref(cmd);
+	return health;
+}
+
+NDCTL_EXPORT unsigned int ndctl_dimm_get_flags(struct ndctl_dimm *dimm)
+{
+	struct ndctl_cmd *cmd = NULL;
+	unsigned int flags;
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	const char *devname = ndctl_dimm_get_devname(dimm);
+
+	cmd = ndctl_dimm_cmd_new_smart(dimm);
+	if (!cmd) {
+		dbg(ctx, "%s: no smart command support\n", devname);
+		return UINT_MAX;
+	}
+	if (ndctl_cmd_submit(cmd)) {
+		dbg(ctx, "%s: smart command failed\n", devname);
+		return UINT_MAX;
+	}
+
+	flags = ndctl_cmd_smart_get_flags(cmd);
+	ndctl_cmd_unref(cmd);
+	return flags;
+}
+
+NDCTL_EXPORT int ndctl_dimm_is_flag_supported(struct ndctl_dimm *dimm,
+		unsigned int flag)
+{
+	unsigned int flags = ndctl_dimm_get_flags(dimm);
+	return (flags ==  UINT_MAX) ? 0 : !!(flags & flag);
+}
+
+NDCTL_EXPORT unsigned int ndctl_dimm_get_event_flags(struct ndctl_dimm *dimm)
+{
+	struct ndctl_cmd *cmd = NULL;
+	unsigned int alarm_flags, event_flags = 0;
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	const char *devname = ndctl_dimm_get_devname(dimm);
+
+	cmd = ndctl_dimm_cmd_new_smart(dimm);
+	if (!cmd) {
+		err(ctx, "%s: no smart command support\n", devname);
+		return UINT_MAX;
+	}
+	if (ndctl_cmd_submit(cmd)) {
+		err(ctx, "%s: smart command failed\n", devname);
+		return UINT_MAX;
+	}
+
+	alarm_flags = ndctl_cmd_smart_get_alarm_flags(cmd);
+	if (alarm_flags & ND_SMART_SPARE_TRIP)
+		event_flags |= ND_EVENT_SPARES_REMAINING;
+	if (alarm_flags & ND_SMART_MTEMP_TRIP)
+		event_flags |= ND_EVENT_MEDIA_TEMPERATURE;
+	if (alarm_flags & ND_SMART_CTEMP_TRIP)
+		event_flags |= ND_EVENT_CTRL_TEMPERATURE;
+	if (ndctl_cmd_smart_get_shutdown_state(cmd))
+		event_flags |= ND_EVENT_UNCLEAN_SHUTDOWN;
+
+	ndctl_cmd_unref(cmd);
+	return event_flags;
+}
+
 NDCTL_EXPORT unsigned int ndctl_dimm_handle_get_node(struct ndctl_dimm *dimm)
 {
 	return dimm->handle >> 16 & 0xfff;
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 8932ef6..9b36960 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -371,4 +371,8 @@ global:
 LIBNDCTL_17 {
 global:
 	ndctl_dimm_smart_inject_supported;
+	ndctl_dimm_get_health;
+	ndctl_dimm_get_flags;
+	ndctl_dimm_get_event_flags;
+	ndctl_dimm_is_flag_supported;
 } LIBNDCTL_16;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 8a96c84..6a6bb0d 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -73,6 +73,12 @@ typedef unsigned char uuid_t[16];
 extern "C" {
 #endif
 
+#define ND_EVENT_SPARES_REMAINING	(1 << 0)
+#define ND_EVENT_MEDIA_TEMPERATURE	(1 << 1)
+#define ND_EVENT_CTRL_TEMPERATURE	(1 << 2)
+#define ND_EVENT_HEALTH_STATE		(1 << 3)
+#define ND_EVENT_UNCLEAN_SHUTDOWN	(1 << 4)
+
 size_t ndctl_min_namespace_size(void);
 size_t ndctl_sizeof_namespace_index(void);
 size_t ndctl_sizeof_namespace_label(void);
@@ -170,6 +176,10 @@ int ndctl_dimm_failed_map(struct ndctl_dimm *dimm);
 int ndctl_dimm_smart_pending(struct ndctl_dimm *dimm);
 int ndctl_dimm_failed_flush(struct ndctl_dimm *dimm);
 int ndctl_dimm_get_health_eventfd(struct ndctl_dimm *dimm);
+unsigned int ndctl_dimm_get_health(struct ndctl_dimm *dimm);
+unsigned int ndctl_dimm_get_flags(struct ndctl_dimm *dimm);
+unsigned int ndctl_dimm_get_event_flags(struct ndctl_dimm *dimm);
+int ndctl_dimm_is_flag_supported(struct ndctl_dimm *dimm, unsigned int flag);
 unsigned int ndctl_dimm_handle_get_node(struct ndctl_dimm *dimm);
 unsigned int ndctl_dimm_handle_get_socket(struct ndctl_dimm *dimm);
 unsigned int ndctl_dimm_handle_get_imc(struct ndctl_dimm *dimm);
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
new file mode 100644
index 0000000..caf8c3d
--- /dev/null
+++ b/ndctl/monitor.c
@@ -0,0 +1,539 @@
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
+#include <sys/epoll.h>
+#define BUF_SIZE 2048
+
+
+static struct monitor {
+	const char *log;
+	const char *dimm_event;
+	bool daemon;
+	bool human;
+	unsigned int event_flags;
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
+struct util_filter_params param;
+
+static int did_fail;
+
+#define fail(fmt, ...) \
+do { \
+	did_fail = 1; \
+	dbg(ctx, "ndctl-%s:%s:%d: " fmt, \
+			VERSION, __func__, __LINE__, ##__VA_ARGS__); \
+} while (0)
+
+static void log_syslog(struct ndctl_ctx *ctx, int priority, const char *file,
+		int line, const char *fn, const char *format, va_list args)
+{
+	char *buf;
+
+	if (vasprintf(&buf, format, args) < 0) {
+		fail("vasprintf error\n");
+		return;
+	}
+	syslog(priority, "%s\n", buf);
+
+	free(buf);
+	return;
+}
+
+static void log_standard(struct ndctl_ctx *ctx, int priority, const char *file,
+		int line, const char *fn, const char *format, va_list args)
+{
+	char *buf;
+
+	if (vasprintf(&buf, format, args) < 0) {
+		fail("vasprintf error\n");
+		return;
+	}
+
+	if (priority == 6)
+		fprintf(stdout, "%s\n", buf);
+	else
+		fprintf(stderr, "%s\n", buf);
+
+	free(buf);
+	return;
+}
+
+static void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
+		int line, const char *fn, const char *format, va_list args)
+{
+	FILE *f;
+	char *buf;
+
+	if (vasprintf(&buf, format, args) < 0) {
+		fail("vasprintf error\n");
+		return;
+	}
+
+	f = fopen(monitor.log, "a+");
+	if (!f) {
+		ndctl_set_log_fn(ctx, log_syslog);
+		fail("open logfile %s failed\n%s", monitor.log, buf);
+		goto end;
+	}
+	fprintf(f, "%s\n", buf);
+	fflush(f);
+	fclose(f);
+end:
+	free(buf);
+	return;
+}
+
+static struct json_object *dimm_event_to_json(struct monitor_dimm *mdimm)
+{
+	struct json_object *jevent, *jobj;
+	bool spares_flag, media_temp_flag, ctrl_temp_flag,
+			health_state_flag, unclean_shutdown_flag;
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(mdimm->dimm);
+
+	jevent = json_object_new_object();
+	if (!jevent) {
+		fail("\n");
+		return NULL;
+	}
+
+	if (monitor.event_flags & ND_EVENT_SPARES_REMAINING) {
+		spares_flag = !!(mdimm->event_flags
+				& ND_EVENT_SPARES_REMAINING);
+		jobj = json_object_new_boolean(spares_flag);
+		if (jobj)
+			json_object_object_add(jevent,
+				"dimm-spares-remaining", jobj);
+	}
+
+	if (monitor.event_flags & ND_EVENT_MEDIA_TEMPERATURE) {
+		media_temp_flag = !!(mdimm->event_flags
+				& ND_EVENT_MEDIA_TEMPERATURE);
+		jobj = json_object_new_boolean(media_temp_flag);
+		if (jobj)
+			json_object_object_add(jevent,
+				"dimm-media-temperature", jobj);
+	}
+
+	if (monitor.event_flags & ND_EVENT_CTRL_TEMPERATURE) {
+		ctrl_temp_flag = !!(mdimm->event_flags
+				& ND_EVENT_CTRL_TEMPERATURE);
+		jobj = json_object_new_boolean(ctrl_temp_flag);
+		if (jobj)
+			json_object_object_add(jevent,
+				"dimm-controller-temperature", jobj);
+	}
+
+	if (monitor.event_flags & ND_EVENT_HEALTH_STATE) {
+		health_state_flag = !!(mdimm->event_flags
+				& ND_EVENT_HEALTH_STATE);
+		jobj = json_object_new_boolean(health_state_flag);
+		if (jobj)
+			json_object_object_add(jevent,
+				"dimm-health-state", jobj);
+	}
+
+	if (monitor.event_flags & ND_EVENT_UNCLEAN_SHUTDOWN) {
+		unclean_shutdown_flag = !!(mdimm->event_flags
+				& ND_EVENT_UNCLEAN_SHUTDOWN);
+		jobj = json_object_new_boolean(unclean_shutdown_flag);
+		if (jobj)
+			json_object_object_add(jevent,
+				"dimm-unclean-shutdown", jobj);
+	}
+
+	return jevent;
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
+	if (monitor.human)
+		notice(ctx, "%s", json_object_to_json_string_ext(jmsg,
+						JSON_C_TO_STRING_PRETTY));
+	else
+		notice(ctx, "%s", json_object_to_json_string_ext(jmsg,
+						JSON_C_TO_STRING_PLAIN));
+
+	free(jobj);
+	free(jdimm);
+	free(jmsg);
+	return 0;
+}
+
+static struct monitor_dimm *util_dimm_event_filter(struct monitor_dimm *mdimm,
+		unsigned int event_flags)
+{
+	unsigned int health;
+
+	mdimm->event_flags = ndctl_dimm_get_event_flags(mdimm->dimm);
+	if (mdimm->event_flags == UINT_MAX)
+		return NULL;
+
+	health = ndctl_dimm_get_health(mdimm->dimm);
+	if (health == UINT_MAX)
+		return NULL;
+	if (mdimm->health != health)
+		mdimm->event_flags |= ND_EVENT_HEALTH_STATE;
+
+	if (mdimm->event_flags & event_flags)
+		return mdimm;
+	return NULL;
+}
+
+static int enable_dimm_supported_threshold_alarms(struct ndctl_dimm *dimm)
+{
+	unsigned int alarm;
+	int rc = -EOPNOTSUPP;
+	struct ndctl_cmd *st_cmd = NULL, *sst_cmd = NULL;
+	const char *name = ndctl_dimm_get_devname(dimm);
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+
+	st_cmd = ndctl_dimm_cmd_new_smart_threshold(dimm);
+	if (!st_cmd) {
+		err(ctx, "%s: no smart threshold command support\n", name);
+		goto out;
+	}
+	if (ndctl_cmd_submit(st_cmd)) {
+		err(ctx, "%s: smart threshold command failed\n", name);
+		goto out;
+	}
+
+	sst_cmd = ndctl_dimm_cmd_new_smart_set_threshold(st_cmd);
+	if (!sst_cmd) {
+		err(ctx, "%s: no smart set threshold command support\n", name);
+		goto out;
+	}
+
+	alarm = ndctl_cmd_smart_threshold_get_alarm_control(st_cmd);
+	if (monitor.event_flags & ND_EVENT_SPARES_REMAINING)
+		alarm |= ND_SMART_SPARE_TRIP;
+	if (monitor.event_flags & ND_EVENT_MEDIA_TEMPERATURE)
+		alarm |= ND_SMART_TEMP_TRIP;
+	if (monitor.event_flags & ND_EVENT_CTRL_TEMPERATURE)
+		alarm |= ND_SMART_CTEMP_TRIP;
+	ndctl_cmd_smart_threshold_set_alarm_control(sst_cmd, alarm);
+
+	rc = ndctl_cmd_submit(sst_cmd);
+	if (rc) {
+		err(ctx, "%s: smart set threshold command failed\n", name);
+		goto out;
+	}
+
+out:
+	ndctl_cmd_unref(sst_cmd);
+	ndctl_cmd_unref(st_cmd);
+	return rc;
+}
+
+static bool filter_region(struct ndctl_region *region,
+		struct util_filter_ctx *fctx)
+{
+	return true;
+}
+
+static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *fctx)
+{
+	struct monitor_dimm *mdimm;
+	struct monitor_filter_arg *mfa = fctx->monitor;
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	const char *name = ndctl_dimm_get_devname(dimm);
+
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART)) {
+		err(ctx, "%s: no smart support\n", name);
+		return;
+	}
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART_THRESHOLD)) {
+		err(ctx, "%s: no smart threshold support\n", name);
+		return;
+	}
+
+	if (!ndctl_dimm_is_flag_supported(dimm, ND_SMART_ALARM_VALID)) {
+		err(ctx, "%s: smart alarm invalid\n", name);
+		return;
+	}
+
+	if (enable_dimm_supported_threshold_alarms(dimm)) {
+		err(ctx, "%s: enable supported threshold alarms failed\n", name);
+		return;
+	}
+
+	mdimm = calloc(1, sizeof(struct monitor_dimm));
+	if (!mdimm) {
+		err(ctx, "%s: calloc for monitor dimm failed\n", name);
+		return;
+	}
+
+	mdimm->dimm = dimm;
+	mdimm->health_eventfd = ndctl_dimm_get_health_eventfd(dimm);
+	mdimm->health = ndctl_dimm_get_health(dimm);
+	mdimm->event_flags = ndctl_dimm_get_event_flags(dimm);
+
+	if (mdimm->event_flags
+			&& util_dimm_event_filter(mdimm, monitor.event_flags)) {
+		if (notify_dimm_event(mdimm)) {
+			err(ctx, "%s: notify dimm event failed\n", name);
+			free(mdimm);
+			return;
+		}
+	}
+
+	list_add_tail(&mfa->dimms, &mdimm->list);
+	if (mdimm->health_eventfd > mfa->maxfd_dimm)
+		mfa->maxfd_dimm = mdimm->health_eventfd;
+	mfa->num_dimm++;
+	return;
+}
+
+static bool filter_bus(struct ndctl_bus *bus, struct util_filter_ctx *fctx)
+{
+	return true;
+}
+
+static int monitor_event(struct ndctl_ctx *ctx,
+		struct monitor_filter_arg *mfa)
+{
+	struct epoll_event ev, *events;
+	int nfds, epollfd, i, rc;
+	struct monitor_dimm *mdimm;
+	char buf;
+
+	events = calloc(mfa->num_dimm, sizeof(struct epoll_event));
+	if (!events) {
+		err(ctx, "malloc for events error\n");
+		return 1;
+	}
+	epollfd = epoll_create1(0);
+	if (epollfd == -1) {
+		err(ctx, "epoll_create1 error\n");
+		return 1;
+	}
+	list_for_each(&mfa->dimms, mdimm, list) {
+		memset(&ev, 0, sizeof(ev));
+		rc = pread(mdimm->health_eventfd, &buf, sizeof(buf), 0);
+		if (rc < 0) {
+			err(ctx, "pread error\n");
+			return 1;
+		}
+		ev.data.ptr = mdimm;
+		if (epoll_ctl(epollfd, EPOLL_CTL_ADD,
+				mdimm->health_eventfd, &ev) != 0) {
+			err(ctx, "epoll_ctl error\n");
+			return 1;
+		}
+	}
+
+	while (1) {
+		did_fail = 0;
+		nfds = epoll_wait(epollfd, events, mfa->num_dimm, -1);
+		if (nfds <= 0) {
+			err(ctx, "epoll_wait error\n");
+			return 1;
+		}
+		for (i = 0; i < nfds; i++) {
+			mdimm = events[i].data.ptr;
+			if (util_dimm_event_filter(mdimm, monitor.event_flags)) {
+				if (notify_dimm_event(mdimm))
+					fail("%s: notify dimm event failed\n",
+						ndctl_dimm_get_devname(mdimm->dimm));
+			}
+			rc = pread(mdimm->health_eventfd, &buf, sizeof(buf), 0);
+			if (rc < 0)
+				fail("pread error\n");
+		}
+		if (did_fail)
+			return 1;
+	}
+	return 0;
+}
+
+static int parse_monitor_event(struct monitor *_monitor)
+{
+	char *dimm_event, *save;
+	const char *event;
+
+	if (!_monitor->dimm_event)
+		goto dimm_event_all;
+	dimm_event = strdup(_monitor->dimm_event);
+	if (!dimm_event)
+		return 1;
+
+	for (event = strtok_r(dimm_event, " ", &save); event;
+			event = strtok_r(NULL, " ", &save)) {
+		if (strcmp(event, "all") == 0) {
+			free(dimm_event);
+			goto dimm_event_all;
+		}
+		if (strcmp(event, "dimm-spares-remaining") == 0)
+			_monitor->event_flags |= ND_EVENT_SPARES_REMAINING;
+		if (strcmp(event, "dimm-media-temperature") == 0)
+			_monitor->event_flags |= ND_EVENT_MEDIA_TEMPERATURE;
+		if (strcmp(event, "dimm-controller-temperature") == 0)
+			_monitor->event_flags |= ND_EVENT_CTRL_TEMPERATURE;
+		if (strcmp(event, "dimm-health-state") == 0)
+			_monitor->event_flags |= ND_EVENT_HEALTH_STATE;
+		if (strcmp(event, "dimm-unclean-shutdown") == 0)
+			_monitor->event_flags |= ND_EVENT_UNCLEAN_SHUTDOWN;
+	}
+
+	free(dimm_event);
+	return 0;
+
+dimm_event_all:
+	_monitor->event_flags = ND_EVENT_SPARES_REMAINING
+			| ND_EVENT_MEDIA_TEMPERATURE
+			| ND_EVENT_CTRL_TEMPERATURE
+			| ND_EVENT_HEALTH_STATE
+			| ND_EVENT_UNCLEAN_SHUTDOWN;
+	return 0;
+}
+
+int cmd_monitor(int argc, const char **argv, void *ctx)
+{
+	const struct option options[] = {
+		OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
+		OPT_STRING('r', "region", &param.region, "region-id",
+				"filter by region"),
+		OPT_STRING('d', "dimm", &param.dimm, "dimm-id",
+				"filter by dimm"),
+		OPT_STRING('n', "namespace", &param.namespace,
+				"namespace-id", "filter by namespace id"),
+		OPT_STRING('D', "dimm-event", &monitor.dimm_event,
+			"name of event type", "filter by DIMM event type"),
+		OPT_FILENAME('l', "log", &monitor.log,
+				"<file> | syslog | standard",
+				"where to output the monitor's notification"),
+		OPT_BOOLEAN('x', "daemon", &monitor.daemon,
+				"run ndctl monitor as a daemon"),
+		OPT_BOOLEAN('u', "human", &monitor.human,
+				"use human friendly output formats"),
+		OPT_END(),
+	};
+	const char * const u[] = {
+		"ndctl monitor [<options>]",
+		NULL
+	};
+	const char *prefix = "./";
+	struct util_filter_ctx fctx = { 0 };
+	struct monitor_filter_arg mfa = { 0 };
+	int i;
+
+	argc = parse_options_prefix(argc, argv, prefix, options, u, 0);
+	for (i = 0; i < argc; i++) {
+		error("unknown parameter \"%s\"\n", argv[i]);
+	}
+	if (argc)
+		usage_with_options(u, options);
+
+	ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_standard);
+	ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_NOTICE);
+
+	if (monitor.log) {
+		if (strcmp(monitor.log, "./syslog") == 0)
+			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
+		else if (strcmp(monitor.log, "./standard") != 0)
+			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_file);
+	}
+
+	if (monitor.daemon) {
+		if (daemon(0, 0) != 0) {
+			err((struct ndctl_ctx *)ctx, "daemon start failed\n");
+			goto out;
+		}
+		notice((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
+	}
+
+	if (parse_monitor_event(&monitor))
+		goto out;
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
+		err((struct ndctl_ctx *)ctx, "no dimms to monitor\n");
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
diff --git a/util/filter.h b/util/filter.h
index effda24..c2cdddf 100644
--- a/util/filter.h
+++ b/util/filter.h
@@ -13,6 +13,7 @@
 #ifndef _UTIL_FILTER_H_
 #define _UTIL_FILTER_H_
 #include <stdbool.h>
+#include <ccan/list/list.h>
 
 struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *ident);
 struct ndctl_region *util_region_filter(struct ndctl_region *region,
@@ -50,6 +51,13 @@ struct list_filter_arg {
 	unsigned long flags;
 };
 
+struct monitor_filter_arg {
+	struct list_head dimms;
+	int maxfd_dimm;
+	int num_dimm;
+	unsigned long flags;
+};
+
 /*
  * struct util_filter_ctx - control and callbacks for util_filter_walk()
  * ->filter_bus() and ->filter_region() return bool because the
@@ -67,6 +75,7 @@ struct util_filter_ctx {
 	union {
 		void *arg;
 		struct list_filter_arg *list;
+		struct monitor_filter_arg *monitor;
 	};
 };
 
-- 
2.18.0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
