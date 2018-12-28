Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 140F521198CC2
 for <linux-nvdimm@lists.01.org>; Thu, 27 Dec 2018 19:43:13 -0800 (PST)
Subject: [ndctl PATCH 7/7] ndctl/monitor: Kill usage of ndctl/lib/private.h
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Dec 2018 19:30:36 -0800
Message-ID: <154596783680.164521.15442430231238691380.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154596779833.164521.12632457592535372923.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <154596779833.164521.12632457592535372923.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The 'private.h' header is only to be consumed internally by libndctl.
The monitor should be using its own log context, not reusing the
library context which might be injecting it's own messages into the log
stream.

Cc: Qi Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/inject-error.c |    1 -
 ndctl/inject-smart.c |    1 -
 ndctl/monitor.c      |   89 ++++++++++++++++++++++++++------------------------
 3 files changed, 47 insertions(+), 44 deletions(-)

diff --git a/ndctl/inject-error.c b/ndctl/inject-error.c
index fef6f75716be..fe599efc31a6 100644
--- a/ndctl/inject-error.c
+++ b/ndctl/inject-error.c
@@ -33,7 +33,6 @@
 #include <ccan/array_size/array_size.h>
 #include <ccan/short_types/short_types.h>
 
-#include "private.h"
 #include <builtin.h>
 #include <test.h>
 
diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index 7a44a684d630..eaa137aaede1 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -24,7 +24,6 @@
 #include <ccan/array_size/array_size.h>
 #include <ccan/short_types/short_types.h>
 
-#include "private.h"
 #include <builtin.h>
 #include <test.h>
 
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index e38a570fe960..233f2bbd9b55 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -5,17 +5,25 @@
 #include <json-c/json.h>
 #include <libgen.h>
 #include <dirent.h>
-#include <util/log.h>
 #include <util/json.h>
 #include <util/filter.h>
 #include <util/util.h>
 #include <util/parse-options.h>
 #include <util/strbuf.h>
-#include <ndctl/lib/private.h>
+#include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
 #include <sys/epoll.h>
 #define BUF_SIZE 2048
 
+/* reuse the core log helpers for the monitor logger */
+#ifndef ENABLE_LOGGING
+#define ENABLE_LOGGING
+#endif
+#ifndef ENABLE_DEBUG
+#define ENABLE_DEBUG
+#endif
+#include <util/log.h>
+
 static struct monitor {
 	const char *log;
 	const char *config_file;
@@ -25,6 +33,7 @@ static struct monitor {
 	bool human;
 	bool verbose;
 	unsigned int event_flags;
+	struct log_ctx ctx;
 } monitor;
 
 struct monitor_dimm {
@@ -42,17 +51,17 @@ static int did_fail;
 #define fail(fmt, ...) \
 do { \
 	did_fail = 1; \
-	dbg(ctx, "ndctl-%s:%s:%d: " fmt, \
+	dbg(&monitor, "ndctl-%s:%s:%d: " fmt, \
 			VERSION, __func__, __LINE__, ##__VA_ARGS__); \
 } while (0)
 
-static void log_syslog(struct ndctl_ctx *ctx, int priority, const char *file,
+static void log_syslog(struct log_ctx *ctx, int priority, const char *file,
 		int line, const char *fn, const char *format, va_list args)
 {
 	vsyslog(priority, format, args);
 }
 
-static void log_standard(struct ndctl_ctx *ctx, int priority, const char *file,
+static void log_standard(struct log_ctx *ctx, int priority, const char *file,
 		int line, const char *fn, const char *format, va_list args)
 {
 	if (priority == 6)
@@ -61,7 +70,7 @@ static void log_standard(struct ndctl_ctx *ctx, int priority, const char *file,
 		vfprintf(stderr, format, args);
 }
 
-static void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
+static void log_file(struct log_ctx *ctx, int priority, const char *file,
 		int line, const char *fn, const char *format, va_list args)
 {
 	FILE *f = monitor.log_file;
@@ -83,7 +92,6 @@ static struct json_object *dimm_event_to_json(struct monitor_dimm *mdimm)
 	struct json_object *jevent, *jobj;
 	bool spares_flag, media_temp_flag, ctrl_temp_flag,
 			health_state_flag, unclean_shutdown_flag;
-	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(mdimm->dimm);
 
 	jevent = json_object_new_object();
 	if (!jevent) {
@@ -144,7 +152,6 @@ static int notify_dimm_event(struct monitor_dimm *mdimm)
 	struct json_object *jmsg, *jdimm, *jobj;
 	struct timespec ts;
 	char timestamp[32];
-	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(mdimm->dimm);
 
 	jmsg = json_object_new_object();
 	if (!jmsg) {
@@ -175,10 +182,10 @@ static int notify_dimm_event(struct monitor_dimm *mdimm)
 		json_object_object_add(jdimm, "health", jobj);
 
 	if (monitor.human)
-		notice(ctx, "%s\n", json_object_to_json_string_ext(jmsg,
+		notice(&monitor, "%s\n", json_object_to_json_string_ext(jmsg,
 						JSON_C_TO_STRING_PRETTY));
 	else
-		notice(ctx, "%s\n", json_object_to_json_string_ext(jmsg,
+		notice(&monitor, "%s\n", json_object_to_json_string_ext(jmsg,
 						JSON_C_TO_STRING_PLAIN));
 
 	free(jobj);
@@ -213,21 +220,20 @@ static int enable_dimm_supported_threshold_alarms(struct ndctl_dimm *dimm)
 	int rc = -EOPNOTSUPP;
 	struct ndctl_cmd *st_cmd = NULL, *sst_cmd = NULL;
 	const char *name = ndctl_dimm_get_devname(dimm);
-	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 
 	st_cmd = ndctl_dimm_cmd_new_smart_threshold(dimm);
 	if (!st_cmd) {
-		err(ctx, "%s: no smart threshold command support\n", name);
+		err(&monitor, "%s: no smart threshold command support\n", name);
 		goto out;
 	}
 	if (ndctl_cmd_submit(st_cmd)) {
-		err(ctx, "%s: smart threshold command failed\n", name);
+		err(&monitor, "%s: smart threshold command failed\n", name);
 		goto out;
 	}
 
 	sst_cmd = ndctl_dimm_cmd_new_smart_set_threshold(st_cmd);
 	if (!sst_cmd) {
-		err(ctx, "%s: no smart set threshold command support\n", name);
+		err(&monitor, "%s: no smart set threshold command support\n", name);
 		goto out;
 	}
 
@@ -242,7 +248,7 @@ static int enable_dimm_supported_threshold_alarms(struct ndctl_dimm *dimm)
 
 	rc = ndctl_cmd_submit(sst_cmd);
 	if (rc) {
-		err(ctx, "%s: smart set threshold command failed\n", name);
+		err(&monitor, "%s: smart set threshold command failed\n", name);
 		goto out;
 	}
 
@@ -262,31 +268,30 @@ static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *fctx)
 {
 	struct monitor_dimm *mdimm;
 	struct monitor_filter_arg *mfa = fctx->monitor;
-	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	const char *name = ndctl_dimm_get_devname(dimm);
 
 	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART)) {
-		err(ctx, "%s: no smart support\n", name);
+		err(&monitor, "%s: no smart support\n", name);
 		return;
 	}
 	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART_THRESHOLD)) {
-		err(ctx, "%s: no smart threshold support\n", name);
+		err(&monitor, "%s: no smart threshold support\n", name);
 		return;
 	}
 
 	if (!ndctl_dimm_is_flag_supported(dimm, ND_SMART_ALARM_VALID)) {
-		err(ctx, "%s: smart alarm invalid\n", name);
+		err(&monitor, "%s: smart alarm invalid\n", name);
 		return;
 	}
 
 	if (enable_dimm_supported_threshold_alarms(dimm)) {
-		err(ctx, "%s: enable supported threshold alarms failed\n", name);
+		err(&monitor, "%s: enable supported threshold alarms failed\n", name);
 		return;
 	}
 
 	mdimm = calloc(1, sizeof(struct monitor_dimm));
 	if (!mdimm) {
-		err(ctx, "%s: calloc for monitor dimm failed\n", name);
+		err(&monitor, "%s: calloc for monitor dimm failed\n", name);
 		return;
 	}
 
@@ -298,7 +303,7 @@ static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *fctx)
 	if (mdimm->event_flags
 			&& util_dimm_event_filter(mdimm, monitor.event_flags)) {
 		if (notify_dimm_event(mdimm)) {
-			err(ctx, "%s: notify dimm event failed\n", name);
+			err(&monitor, "%s: notify dimm event failed\n", name);
 			free(mdimm);
 			return;
 		}
@@ -326,12 +331,12 @@ static int monitor_event(struct ndctl_ctx *ctx,
 
 	events = calloc(mfa->num_dimm, sizeof(struct epoll_event));
 	if (!events) {
-		err(ctx, "malloc for events error\n");
+		err(&monitor, "malloc for events error\n");
 		return -ENOMEM;
 	}
 	epollfd = epoll_create1(0);
 	if (epollfd == -1) {
-		err(ctx, "epoll_create1 error\n");
+		err(&monitor, "epoll_create1 error\n");
 		rc = -errno;
 		goto out;
 	}
@@ -339,14 +344,14 @@ static int monitor_event(struct ndctl_ctx *ctx,
 		memset(&ev, 0, sizeof(ev));
 		rc = pread(mdimm->health_eventfd, &buf, sizeof(buf), 0);
 		if (rc < 0) {
-			err(ctx, "pread error\n");
+			err(&monitor, "pread error\n");
 			rc = -errno;
 			goto out;
 		}
 		ev.data.ptr = mdimm;
 		if (epoll_ctl(epollfd, EPOLL_CTL_ADD,
 				mdimm->health_eventfd, &ev) != 0) {
-			err(ctx, "epoll_ctl error\n");
+			err(&monitor, "epoll_ctl error\n");
 			rc = -errno;
 			goto out;
 		}
@@ -356,7 +361,7 @@ static int monitor_event(struct ndctl_ctx *ctx,
 		did_fail = 0;
 		nfds = epoll_wait(epollfd, events, mfa->num_dimm, -1);
 		if (nfds <= 0) {
-			err(ctx, "epoll_wait error\n");
+			err(&monitor, "epoll_wait error\n");
 			rc = -errno;
 			goto out;
 		}
@@ -365,7 +370,7 @@ static int monitor_event(struct ndctl_ctx *ctx,
 			if (util_dimm_event_filter(mdimm, monitor.event_flags)) {
 				rc = notify_dimm_event(mdimm);
 				if (rc) {
-					err(ctx, "%s: notify dimm event failed\n",
+					err(&monitor, "%s: notify dimm event failed\n",
 						ndctl_dimm_get_devname(mdimm->dimm));
 					did_fail = 1;
 					goto out;
@@ -373,7 +378,7 @@ static int monitor_event(struct ndctl_ctx *ctx,
 			}
 			rc = pread(mdimm->health_eventfd, &buf, sizeof(buf), 0);
 			if (rc < 0) {
-				err(ctx, "pread error\n");
+				err(&monitor, "pread error\n");
 				rc = -errno;
 				goto out;
 			}
@@ -427,7 +432,7 @@ static int parse_monitor_event(struct monitor *_monitor, struct ndctl_ctx *ctx)
 		else if (strcmp(event, "dimm-unclean-shutdown") == 0)
 			_monitor->event_flags |= ND_EVENT_UNCLEAN_SHUTDOWN;
 		else {
-			err(ctx, "no dimm-event named %s\n", event);
+			err(&monitor, "no dimm-event named %s\n", event);
 			rc = -EINVAL;
 			goto out;
 		}
@@ -482,7 +487,7 @@ static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
 
 	f = fopen(config_file, "r");
 	if (!f) {
-		err(ctx, "config-file: %s cannot be opened\n", config_file);
+		err(&monitor, "config-file: %s cannot be opened\n", config_file);
 		rc = -errno;
 		goto out;
 	}
@@ -583,13 +588,13 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 	if (argc)
 		usage_with_options(u, options);
 
-	/* default to log_standard */
-	ndctl_set_log_fn(ctx, log_standard);
+	log_init(&monitor.ctx, "ndctl/monitor", "NDCTL_MONITOR_LOG");
+	monitor.ctx.log_fn = log_standard;
 
 	if (monitor.verbose)
-		ndctl_set_log_priority(ctx, LOG_DEBUG);
+		monitor.ctx.log_priority = LOG_DEBUG;
 	else
-		ndctl_set_log_priority(ctx, LOG_INFO);
+		monitor.ctx.log_priority = LOG_INFO;
 
 	rc = read_config_file(ctx, &monitor, &param);
 	if (rc)
@@ -599,9 +604,9 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 		if (strncmp(monitor.log, "./", 2) != 0)
 			fix_filename(prefix, (const char **)&monitor.log);
 		if (strncmp(monitor.log, "./syslog", 8) == 0)
-			ndctl_set_log_fn(ctx, log_syslog);
+			monitor.ctx.log_fn = log_syslog;
 		else if (strncmp(monitor.log, "./standard", 10) == 0)
-			; /*default, already set */
+			monitor.ctx.log_fn = log_standard;
 		else {
 			monitor.log_file = fopen(monitor.log, "a+");
 			if (!monitor.log_file) {
@@ -609,18 +614,18 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 				rc = -errno;
 				goto out;
 			}
-			ndctl_set_log_fn(ctx, log_file);
+			monitor.ctx.log_fn = log_file;
 		}
 	}
 
 	if (monitor.daemon) {
 		if (!monitor.log || strncmp(monitor.log, "./", 2) == 0)
-			ndctl_set_log_fn(ctx, log_syslog);
+			monitor.ctx.log_fn = log_syslog;
 		if (daemon(0, 0) != 0) {
-			err(ctx, "daemon start failed\n");
+			err(&monitor, "daemon start failed\n");
 			goto out;
 		}
-		info(ctx, "ndctl monitor daemon started\n");
+		info(&monitor, "ndctl monitor daemon started\n");
 	}
 
 	if (parse_monitor_event(&monitor, ctx))
@@ -641,7 +646,7 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 		goto out;
 
 	if (!mfa.num_dimm) {
-		dbg(ctx, "no dimms to monitor\n");
+		dbg(&monitor, "no dimms to monitor\n");
 		if (!monitor.daemon)
 			rc = -ENXIO;
 		goto out;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
