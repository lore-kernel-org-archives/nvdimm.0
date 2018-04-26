Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 247D42035D6CC
 for <linux-nvdimm@lists.01.org>; Thu, 26 Apr 2018 04:33:31 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 3FFD4AC02AC
 for <linux-nvdimm@lists.01.org>; Thu, 26 Apr 2018 20:33:24 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH v5 2/4] ndctl, monitor: add ndctl monitor daemon
Date: Thu, 26 Apr 2018 20:30:48 +0900
Message-Id: <20180426113050.11424-3-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180426113050.11424-1-qi.fuli@jp.fujitsu.com>
References: <20180426113050.11424-1-qi.fuli@jp.fujitsu.com>
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

This patch adds the body file of ndctl monitor daemon.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>

---
 builtin.h         |   1 +
 ndctl/Makefile.am |   3 +-
 ndctl/monitor.c   | 460 ++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/ndctl.c     |   1 +
 4 files changed, 464 insertions(+), 1 deletion(-)
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
index 0000000..ab6e701
--- /dev/null
+++ b/ndctl/monitor.c
@@ -0,0 +1,460 @@
+/*
+ * Copyright(c) 2018, FUJITSU LIMITED. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
+ * more details.
+ */
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
+static enum log_destination {
+	LOG_DESTINATION_STDERR = 1,
+	LOG_DESTINATION_SYSLOG = 2,
+	LOG_DESTINATION_FILE = 3,
+} log_destination = LOG_DESTINATION_SYSLOG;
+
+static struct {
+	const char *logfile;
+	const char *config_file;
+	bool daemon;
+} monitor;
+
+struct monitor_dimm_node {
+	struct ndctl_dimm *dimm;
+	int health_eventfd;
+	struct list_node list;
+};
+
+struct monitor_filter_arg {
+	struct list_head mdimm;
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
+	err(ctx, "ndctl-%s:%s:%d: " fmt, \
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
+static int recur_mkdir(char *filepath, mode_t mode)
+{
+	char *p;
+	char *buf = (char *)malloc(strlen(filepath) + 4);
+
+	strcpy(buf, filepath);
+	for (p = strchr(buf + 1, '/'); p; p = strchr(p + 1, '/')) {
+		*p = '\0';
+		if (!is_dir(buf)) {
+			if (mkdir(buf, mode) < 0) {
+				free(buf);
+				return -1;
+			}
+		}
+		*p = '/';
+	}
+
+	free(buf);
+	return 0;
+}
+
+static void set_value(const char **arg, char *val)
+{
+	struct strbuf value = STRBUF_INIT;
+	size_t arg_len = *arg ? strlen(*arg) : 0;
+
+	if (arg_len) {
+		strbuf_add(&value, *arg, arg_len);
+		strbuf_addstr(&value, " ");
+	}
+	strbuf_addstr(&value, val);
+	*arg = strbuf_detach(&value, NULL);
+}
+
+static void logreport(struct ndctl_ctx *ctx, int priority, const char *file,
+		int line, const char *fn, const char *format, va_list args)
+{
+	char *log_dir;
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
+		if (!is_dir(log_dir) && recur_mkdir(log_dir, 0744) != 0)
+			goto log_file_err;
+		FILE *f = fopen(monitor.logfile, "a+");
+		if (!f)
+			goto log_file_err;
+		fprintf(f, "%s\n", buf);
+		fclose(f);
+		free(log_dir);
+		goto end;
+
+	log_file_err:
+		log_destination = LOG_DESTINATION_SYSLOG;
+		fail("open logfile %s failed\n%s", monitor.logfile, buf);
+		free(log_dir);
+	}
+end:
+	free(buf);
+	return;
+}
+
+static void notify_json_msg(struct ndctl_ctx *ctx, struct ndctl_dimm *dimm)
+{
+	struct json_object *jmsg, *jdatetime, *jpid, *jdimm, *jhealth;
+	struct timespec ts;
+	char datetime[32];
+
+	jmsg = json_object_new_object();
+	if (!jmsg) {
+		fail("\n");
+		return;
+	}
+
+	clock_gettime(CLOCK_REALTIME, &ts);
+	sprintf(datetime, "%10ld.%09ld", ts.tv_sec, ts.tv_nsec);
+	jdatetime = json_object_new_string(datetime);
+	if (!jdatetime) {
+		fail("\n");
+		return;
+	}
+	json_object_object_add(jmsg, "datetime", jdatetime);
+
+	jpid = json_object_new_int((int)getpid());
+	if (!jpid) {
+		fail("\n");
+		return;
+	}
+	json_object_object_add(jmsg, "pid", jpid);
+
+	jdimm = util_dimm_to_json(dimm, 0);
+	if (!dimm) {
+		fail("\n");
+		return;
+	}
+	json_object_object_add(jmsg, "dimm", jdimm);
+
+	jhealth = util_dimm_health_to_json(dimm);
+	if (!jhealth) {
+		fail("\n");
+		return;
+	}
+	json_object_object_add(jdimm, "health", jhealth);
+
+	notice(ctx, "%s",
+		json_object_to_json_string_ext(jmsg, JSON_C_TO_STRING_PLAIN));
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
+	struct monitor_filter_arg *mfa = (struct monitor_filter_arg *)ctx->arg;
+
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART_THRESHOLD))
+		return;
+
+	struct monitor_dimm_node *mdn = malloc(sizeof(*mdn));
+	mdn->dimm = dimm;
+	int fd = ndctl_dimm_get_health_eventfd(dimm);
+	mdn->health_eventfd = fd;
+	list_add_tail(&mfa->mdimm, &mdn->list);
+	if (fd > mfa->maxfd_dimm)
+		mfa->maxfd_dimm = fd;
+	mfa->num_dimm++;
+}
+
+static bool filter_bus(struct ndctl_bus *bus, struct util_filter_ctx *ctx)
+{
+	return true;
+}
+
+static int monitor_dimm_event(struct ndctl_ctx *ctx,
+		struct monitor_filter_arg *mfa)
+{
+	struct epoll_event ev, events[mfa->num_dimm];
+	struct ndctl_dimm **dimms;
+	int nfds, epollfd;
+	struct monitor_dimm_node *mdn;
+	char buf;
+
+	dimms = calloc(mfa->maxfd_dimm + 1, sizeof(struct ndctl_dimm *));
+	if (!dimms) {
+		fail("\n");
+		goto out;
+	}
+
+	epollfd = epoll_create1(0);
+	if (epollfd == -1) {
+		err(ctx, "epoll_create1 error\n");
+		goto out;
+	}
+	list_for_each(&mfa->mdimm, mdn, list) {
+		memset(&ev, 0, sizeof(ev));
+		pread(mdn->health_eventfd, &buf, 1, 0);
+		ev.data.fd = mdn->health_eventfd;
+		if (epoll_ctl(epollfd, EPOLL_CTL_ADD,
+				mdn->health_eventfd, &ev) != 0) {
+			err(ctx, "epoll_ctl error\n");
+			goto out;
+		}
+		dimms[mdn->health_eventfd] = mdn->dimm;
+	}
+
+	while(1){
+		nfds = epoll_wait(epollfd, events, mfa->num_dimm, -1);
+		if (nfds <= 0) {
+			err(ctx, "epoll_wait error\n");
+			goto out;
+		}
+		for (int i = 0; i < nfds; i++) {
+			memset(&ev, 0, sizeof(ev));
+			ev = events[i];
+			notify_json_msg(ctx, dimms[ev.data.fd]);
+			pread(ev.data.fd, &buf, 1, 0);
+		}
+		if (did_fail)
+			goto out;
+	}
+	return 0;
+out:
+	free(dimms);
+	return 1;
+}
+
+static int read_config_file(struct ndctl_ctx *ctx, const char *prefix)
+{
+	FILE *f;
+	int line_nr = 0;
+	char buf[BUF_SIZE];
+	char *config_file = "/etc/ndctl/monitor.conf";
+
+	if (monitor.config_file)
+		f = fopen(monitor.config_file, "r");
+	else
+		f = fopen(config_file, "r");
+
+	if (f == NULL) {
+		error("config-file: %s cannot be opened\n", config_file);
+		return -1;
+	}
+
+	while (fgets(buf, BUF_SIZE, f)) {
+		size_t len;
+		char *key;
+		char *val;
+
+		line_nr++;
+
+		/* find key */
+		key = buf;
+		while (isspace(key[0]))
+			key++;
+
+		/* comment or empty line */
+		if (key[0] == '#' || key[0] == '\0')
+			continue;
+
+		/* split key/value */
+		val = strchr(key, '=');
+		if (!val) {
+			err(ctx, "missing <key>=<value> in '%s'[%i], skip line\n",
+					config_file, line_nr);
+			continue;
+		}
+
+		val[0] = '\0';
+		val++;
+
+		/* find value */
+		while (isspace(val[0]))
+			val++;
+
+		/* terminate key */
+		len = strlen(key);
+		if (len == 0)
+			continue;
+		while (isspace(key[len-1]))
+			len--;
+		key[len] = '\0';
+
+		/*terminate value */
+		len = strlen(val);
+		if (len == 0)
+			continue;
+		while (isspace(val[len-1]))
+			len--;
+		val[len] = '\0';
+
+		if (len == 0)
+			continue;
+
+		/* unquote */
+		if (val[0] == '"' || val[0] == '\'') {
+			if (val[len-1] != val[0]) {
+				err(ctx, "inconsistent quoting in '%s'[%i], skip line\n",
+						config_file, line_nr);
+				continue;
+			}
+			val[len-1] = '\0';
+			val++;
+		}
+
+		if (strcmp(key, "bus") == 0) {
+			set_value((const char **)&param.bus, val);
+			continue;
+		}
+		if (strcmp(key, "dimm") == 0) {
+			set_value((const char **)&param.dimm, val);
+			continue;
+		}
+		if (strcmp(key, "region") == 0) {
+			set_value((const char **)&param.region, val);
+			continue;
+		}
+		if (strcmp(key, "namespace") == 0) {
+			set_value((const char **)&param.namespace, val);
+			continue;
+		}
+		if (strcmp(key, "logfile") == 0) {
+			if (monitor.logfile)
+				continue;
+			set_value((const char **)&monitor.logfile, val);
+			fix_filename(prefix, (const char **)&monitor.logfile);
+		}
+	}
+	fclose(f);
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
+		OPT_FILENAME('l', "logfile", &monitor.logfile, "file|syslog|stderr",
+				"the place to output the monitor's notification"),
+		OPT_FILENAME('c',"config-file", &monitor.config_file, "config-file",
+				"use file to override the default configuration"),
+		OPT_BOOLEAN('D',"daemon", &monitor.daemon,
+				"run ndctl monitor as a daemon"),
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
+	for (int i = 0; i < argc; i++) {
+		error("unknown parameter \"%s\"\n", argv[i]);
+	}
+	if (argc)
+		usage_with_options(u, options);
+
+	ndctl_set_log_fn((struct ndctl_ctx *)ctx, logreport);
+	ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_INFO);
+
+	if (read_config_file((struct ndctl_ctx *)ctx, prefix))
+		goto out;
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
+			err((struct ndctl_ctx *)ctx, "daemon start failed\n");
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
+	list_head_init(&mfa.mdimm);
+	mfa.num_dimm = 0;
+	mfa.maxfd_dimm = -1;
+	mfa.flags = 0;
+
+	if (util_filter_walk(ctx, &fctx, &param))
+		goto out;
+
+	if (!mfa.num_dimm) {
+		err((struct ndctl_ctx *)ctx, "no dimms can be monitored\n");
+		goto out;
+	}
+
+	if (monitor_dimm_event(ctx, &mfa))
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
2.17.0.140.g0b0cc9f86


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
