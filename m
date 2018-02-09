Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym01.jp.fujitsu.com (mgwym01.jp.fujitsu.com [211.128.242.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D1DDA223DB78C
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 23:56:54 -0800 (PST)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id A5C07AC03BE
 for <linux-nvdimm@lists.01.org>;
 Fri,  9 Feb 2018 17:02:36 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [RFC PATCH v3 2/5] ndctl: monitor: add ndctl create-monitor command
Date: Fri,  9 Feb 2018 17:02:22 +0900
Message-Id: <20180209080225.5137-3-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180209080225.5137-1-qi.fuli@jp.fujitsu.com>
References: <20180209080225.5137-1-qi.fuli@jp.fujitsu.com>
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

This patch is used to add $ndctl create-monitor command, by which users can
create a new monitor. Users can select the DIMMS to be monitored by using
[--dimm] [--bus] [--region] [--namespace] options. The notifications can
be outputed to a special file or syslog by using [--output] option, the
special file will be placed under /var/log/ndctl. A name is also required for
a monitor,so users can destroy the monitor by the name. When a monitor is
created successfully, a file with same name will be created under
/var/ndctl/monitor.
Example: 
#ndctl create-monitor --monitor m_nmem1 --dimm nmem1 --output m_nmem.log

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 builtin.h         |   1 +
 configure.ac      |   3 +
 ndctl/Makefile.am |   3 +-
 ndctl/monitor.c   | 342 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/ndctl.c     |   1 +
 5 files changed, 349 insertions(+), 1 deletion(-)
 create mode 100644 ndctl/monitor.c

diff --git a/builtin.h b/builtin.h
index 5e1b7ef..850f6a8 100644
--- a/builtin.h
+++ b/builtin.h
@@ -36,6 +36,7 @@ int cmd_write_labels(int argc, const char **argv, void *ctx);
 int cmd_init_labels(int argc, const char **argv, void *ctx);
 int cmd_check_labels(int argc, const char **argv, void *ctx);
 int cmd_inject_error(int argc, const char **argv, void *ctx);
+int cmd_create_monitor(int argc, const char **argv, void *ctx);
 int cmd_list(int argc, const char **argv, void *ctx);
 #ifdef ENABLE_TEST
 int cmd_test(int argc, const char **argv, void *ctx);
diff --git a/configure.ac b/configure.ac
index 70ba360..e859e04 100644
--- a/configure.ac
+++ b/configure.ac
@@ -160,6 +160,9 @@ AC_CONFIG_FILES([
         Documentation/daxctl/Makefile
 ])
 
+AC_CONFIG_COMMANDS([monitorlogdir], [$MKDIR_P /var/log/ndctl])
+AC_CONFIG_COMMANDS([monitorprocdir], [$MKDIR_P /var/ndctl/monitor])
+
 AC_OUTPUT
 AC_MSG_RESULT([
         $PACKAGE $VERSION
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 6677607..d9a484d 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -13,7 +13,8 @@ ndctl_SOURCES = ndctl.c \
 		test.c \
 		../util/json.c \
 		util/json-smart.c \
-		inject-error.c
+		inject-error.c \
+		monitor.c
 
 if ENABLE_DESTRUCTIVE
 ndctl_SOURCES += ../test/blk_namespaces.c \
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
new file mode 100644
index 0000000..cf1cd6e
--- /dev/null
+++ b/ndctl/monitor.c
@@ -0,0 +1,342 @@
+/*
+ * Copyright (c) 2018, FUJITSU LIMITED. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for
+ * more details.
+ */
+#include <stdio.h>
+#include <json-c/json.h>
+#include <signal.h>
+#include <dirent.h>
+#include <util/parse-options.h>
+#include <util/log.h>
+#include <util/filter.h>
+#include <util/json.h>
+#include <ndctl/lib/private.h>
+#include <ndctl/libndctl.h>
+#include <sys/stat.h>
+#define NUM_MAX_DIMM 1024
+#define BUF_SIZE 4096
+
+struct monitor_dimm {
+	struct ndctl_dimm *dimm;
+	const char *devname;
+	int health_eventfd;
+};
+
+static struct parameter {
+	const char *bus;
+	const char *region;
+	const char *dimm;
+	const char *namespace;
+	const char *event;
+	const char *output;
+	const char *monitor;
+	bool all;
+} param;
+
+static const char *proc_path = "/var/ndctl/monitor/";
+
+static char *get_full_path_filename(const char *path, const char *name)
+{
+	char *filename;
+	int len = strlen(path) + strlen (name) +1;
+	filename = (char *) malloc(len);
+	if (!filename)
+		return NULL;
+	filename[0] = '\0';
+	strcpy(filename, path);
+	strcat(filename, name);
+	return filename;
+}
+
+static void log_syslog(struct ndctl_ctx *ctx, int priority, const char *file,
+	int line, const char *fn, const char *format, va_list args)
+{
+	char *buf;
+	buf = (char *)malloc(BUF_SIZE);
+	if (!buf) {
+		syslog(LOG_ERR, "could not get memory for log_syslog\n");
+		exit(EXIT_FAILURE);
+	}
+	vsnprintf(buf, BUF_SIZE, format, args);
+	syslog(priority, "%s", buf);
+	free(buf);
+}
+
+static void log_output(struct ndctl_ctx *ctx, int priority, const char *file,
+	int line, const char *fn, const char *format, va_list args)
+{
+	FILE *f;
+	char *filename, *buf;
+	const char *log_path = "/var/log/ndctl/";
+	filename = get_full_path_filename(log_path, param.output);
+
+	f = fopen(filename, "a+");
+	if (!f) {
+		syslog(LOG_ERR, "open %s failed\n", filename);
+		exit(EXIT_FAILURE);
+	}
+
+	buf = (char *)malloc(BUF_SIZE);
+	if (!buf) {
+		syslog(LOG_ERR, "could not get memory for log_output\n");
+		exit(EXIT_FAILURE);
+	}
+	vsnprintf(buf, BUF_SIZE, format, args);
+	fprintf(f, "%s\n", buf);
+	free(buf);
+	fclose(f);
+}
+
+static int notify_json_msg(struct ndctl_ctx *ctx, struct monitor_dimm *m_dimm)
+{
+	time_t c_time;
+	char date[32];
+	struct json_object *jmsg, *jdatetime, *jpid, *jdimm, *jhealth;
+
+	jmsg = json_object_new_object();
+
+	c_time = time(NULL);
+	strftime(date, sizeof(date), "%Y-%m-%d %H:%M:%S", localtime(&c_time));
+	jdatetime = json_object_new_string(date);
+	json_object_object_add(jmsg, "datetime", jdatetime);
+
+	jpid = json_object_new_int((int)getpid());
+	json_object_object_add(jmsg, "pid", jpid);
+
+	jdimm = util_dimm_to_json(m_dimm->dimm, 0);
+	json_object_object_add(jmsg, "dimm", jdimm);
+
+	jhealth = util_dimm_health_to_json(m_dimm->dimm);
+	if (jhealth)
+		json_object_object_add(jdimm, "health", jhealth);
+
+	notice(ctx, "%s",
+		json_object_to_json_string_ext(jmsg, JSON_C_TO_STRING_PLAIN));
+	return 0;
+}
+
+#define add_param_to_json(field) \
+if (param.field) { \
+	j##field = json_object_new_string(param.field); \
+	json_object_object_add(jmonitors, #field, j##field); \
+}
+
+static int create_monitor_proc(struct ndctl_ctx *ctx)
+{
+	time_t c_time;
+	char date[32];
+	char *filename;
+	struct json_object *jmonitors, *jmonitor, *jpid, *jcreate, *jbus,
+		*jdimm, *jregion, *jnamespace, *joutput, *jevent;
+	jmonitors = json_object_new_object();
+	add_param_to_json(monitor);
+	c_time = time(NULL);
+	strftime(date, sizeof(date), "%Y-%m-%d %H:%M:%S", localtime(&c_time));
+	jcreate = json_object_new_string(date);
+	json_object_object_add(jmonitors, "create", jcreate);
+	jpid = json_object_new_int((int)getpid());
+	json_object_object_add(jmonitors, "pid", jpid);
+	add_param_to_json(dimm);
+	add_param_to_json(bus);
+	add_param_to_json(region);
+	add_param_to_json(namespace);
+	add_param_to_json(event);
+	add_param_to_json(output);
+
+	filename = get_full_path_filename(proc_path, param.monitor);
+	return json_object_to_file(filename, jmonitors);
+}
+
+static int destroy_monitor_proc(void)
+{
+	char *filename;
+	filename = get_full_path_filename(proc_path, param.monitor);
+	return remove(filename);
+}
+
+static int set_monitor_dimm(struct ndctl_ctx *ctx, fd_set *fds, int *maxfd,
+				struct monitor_dimm *m_dimm)
+{
+	struct ndctl_bus *bus;
+	int fd, num_dimm = 0;
+	char buf[BUF_SIZE];
+
+	ndctl_bus_foreach(ctx, bus) {
+		struct ndctl_dimm *dimm;
+		if(!util_bus_filter(bus, param.bus)
+			|| !util_bus_filter_by_dimm(bus, param.dimm)
+			|| !util_bus_filter_by_region(bus, param.region)
+			|| !util_bus_filter_by_namespace(bus, param.namespace))
+			continue;
+		ndctl_dimm_foreach(bus, dimm) {
+			if(!util_dimm_filter(dimm, param.dimm)
+				|| !util_dimm_filter_by_region(dimm,
+						param.region)
+				|| !util_dimm_filter_by_namespace(dimm,
+						param.namespace))
+				continue;
+			if (!ndctl_dimm_is_cmd_supported(dimm,
+					ND_CMD_SMART_THRESHOLD))
+				continue;
+			m_dimm[num_dimm].dimm = dimm;
+			m_dimm[num_dimm].devname = ndctl_dimm_get_devname(dimm);
+			fd = ndctl_dimm_get_health_eventfd(dimm);
+			pread(fd, buf, sizeof(buf), 0);
+			m_dimm[num_dimm].health_eventfd = fd;
+
+			if (fds)
+				FD_SET(fd, fds);
+			if (maxfd) {
+				if (*maxfd < fd)
+					*maxfd = fd;
+			}
+			num_dimm++;
+		}
+	}
+	return num_dimm;
+}
+
+static bool check_monitor_exist(void)
+{
+	FILE *f;
+	char *filename;
+	filename = get_full_path_filename(proc_path, param.monitor);
+	f = fopen(filename, "r");
+	if (!f)
+		return false;
+	fclose(f);
+	return true;
+}
+static int monitor_dimm_event(struct ndctl_ctx *ctx)
+{
+	int rc, maxfd, num_dimm;
+	struct monitor_dimm *m_dimm;
+	char buf[BUF_SIZE];
+	m_dimm = calloc(NUM_MAX_DIMM, sizeof(struct monitor_dimm));
+	if (!m_dimm) {
+		error("monitor_dimm memory space cannot be allocated\n");
+		goto out;
+	}
+
+	fd_set fds;
+	FD_ZERO(&fds);
+
+	num_dimm = set_monitor_dimm(ctx, &fds, &maxfd, m_dimm);
+	if (num_dimm == 0) {
+		error("no monitor dimms can be found\n");
+		goto out;
+	}
+
+
+	if (daemon(0, 0) != 0) {
+		err(ctx, "daemon start failed\n");
+		goto out;
+	}
+
+	printf("ndctl create-monitor %s started\n", param.monitor);
+	if (create_monitor_proc(ctx) != 0) {
+		err(ctx, "daemon start failed\n");
+		goto out;
+	}
+
+	while(1){
+		rc = select(maxfd + 1, NULL, NULL, &fds, NULL);
+		if (rc < 1) {
+			if (rc == 0)
+				err(ctx, "select unexpected timeout\n");
+			else
+				err(ctx, "select %s\n", strerror(errno));
+			goto out_clean;
+		}
+		for (int i = 0; i < num_dimm; i++) {
+			if (!FD_ISSET(m_dimm[i].health_eventfd, &fds)){
+				FD_SET(m_dimm[i].health_eventfd, &fds);
+				continue;
+			}
+			if (notify_json_msg(ctx, &m_dimm[i]) != 0)
+				goto out_clean;
+			pread(m_dimm[i].health_eventfd, buf, sizeof(buf), 0);
+		}
+	}
+	free(m_dimm);
+	return 0;
+out:
+	printf("ndctl create-monitor %s failed\n", param.monitor);
+	return 1;
+
+out_clean:
+	err(ctx, "ndctl monitor %s stoped\n", param.monitor);
+	if (destroy_monitor_proc() != 0)
+		err(ctx, "failed to clean temp file");
+	return 1;
+
+}
+
+int cmd_create_monitor(int argc, const char **argv, void *ctx)
+{
+	const struct option options[] = {
+		OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
+		OPT_STRING('r', "region", &param.region, "region-id",
+				"filter by region"),
+		OPT_STRING('d', "dimm", &param.dimm, "dimm-id",
+				"filter by dimm"),
+		OPT_STRING('n', "namespace", &param.namespace,
+				"namespace-id", "filter by namespace id"),
+		OPT_STRING('e', "event", &param.event, "event-id",
+				"filter by event"),
+		OPT_STRING('o', "output", &param.output, "output file name",
+				"monitor output file name"),
+		OPT_STRING('m', "monitor", &param.monitor, "monitor name",
+				"monitor name")
+	};
+	const char * const u[] = {
+		"ndctl create-monitor <monitor> <output> [<options>]",
+		NULL
+	};
+	argc = parse_options(argc, argv, options, u, 0);
+	for (int i = 0; i < argc; i++) {
+		error("unknown parameter \"%s\"\n", argv[i]);
+		goto out;
+	}
+	if (!param.monitor) {
+		error("monitor name --monitor is required\n");
+		goto out;
+	}
+	if (check_monitor_exist()) {
+		error("monitor %s is exist\n", param.monitor);
+		goto out;
+	}
+	if (!param.output) {
+		error("output file name --output is required\n");
+		goto out;
+	}
+
+	ndctl_set_log_priority((struct ndctl_ctx*)ctx, LOG_NOTICE);
+
+	if (strcmp(param.output, "syslog") == 0)
+		ndctl_set_log_fn((struct ndctl_ctx*)ctx, log_syslog);
+	else
+		ndctl_set_log_fn((struct ndctl_ctx*)ctx, log_output);
+
+	if (monitor_dimm_event((struct ndctl_ctx*)ctx) != 0)
+		goto out;
+
+	char *filename;
+	filename = get_full_path_filename(proc_path, param.monitor);
+	if (remove(filename) != 0) {
+		err((struct ndctl_ctx*)ctx, "failed to delete %s\n", filename);
+		goto out;
+	}
+	return 0;
+
+out:
+	return 1;
+}
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 0f748e1..6c63d79 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -84,6 +84,7 @@ static struct cmd_struct commands[] = {
 	{ "init-labels", cmd_init_labels },
 	{ "check-labels", cmd_check_labels },
 	{ "inject-error", cmd_inject_error },
+	{ "create-monitor", cmd_create_monitor },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST
-- 
2.9.5


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
