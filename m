Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A0301209688F3
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jul 2018 07:18:23 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 5372CAC009C
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jul 2018 23:18:17 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH v10 2/4] ndctl,
 monitor: add main ndctl monitor configuration file
Date: Mon,  9 Jul 2018 23:17:16 +0900
Message-Id: <20180709141718.6205-3-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180709141718.6205-1-qi.fuli@jp.fujitsu.com>
References: <20180709141718.6205-1-qi.fuli@jp.fujitsu.com>
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

This patch adds the main configuration file(/etc/ndctl/monitor.conf)
of ndctl monitor. It contains the configuration directives that give
ndctl monitor instructions. Users can change the configuration by
editing this file or using [--config-file] option to override this
file. The changed value will work after restart ndctl monitor service.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 ndctl/Makefile.am  |   5 ++
 ndctl/monitor.c    | 115 +++++++++++++++++++++++++++++++++++++++++++++
 ndctl/monitor.conf |  41 ++++++++++++++++
 3 files changed, 161 insertions(+)
 create mode 100644 ndctl/monitor.conf

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 7dbf223..ae3d894 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -42,3 +42,8 @@ ndctl_SOURCES += ../test/libndctl.c \
 		 ../test/multi-pmem.c \
 		 ../test/core.c
 endif
+
+monitor_config_file = monitor.conf
+monitor_configdir = /etc/ndctl/
+monitor_config_DATA = $(monitor_config_file)
+EXTRA_DIST += $(monitor_config_file)
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 700bd22..83f22af 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -19,6 +19,7 @@
 
 static struct monitor {
 	const char *logfile;
+	const char *config_file;
 	const char *dimm_event;
 	bool daemon;
 	unsigned int event_flags;
@@ -429,6 +430,109 @@ dimm_event_all:
 	return 0;
 }
 
+static void parse_config(const char **arg, char *key, char *val, char *ident)
+{
+	struct strbuf value = STRBUF_INIT;
+	size_t arg_len = *arg ? strlen(*arg) : 0;
+
+	if (!ident || !key || (strcmp(ident, key) != 0))
+		return;
+
+	if (arg_len) {
+		strbuf_add(&value, *arg, arg_len);
+		strbuf_addstr(&value, " ");
+	}
+	strbuf_addstr(&value, val);
+	*arg = strbuf_detach(&value, NULL);
+}
+
+static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
+		struct util_filter_params *_param)
+{
+	FILE *f;
+	int line = 0;
+	size_t len = 0;
+	char *buf, *value, *config_file;
+	const char *def_config_file = "/etc/ndctl/monitor.conf";
+
+	if (_monitor->config_file)
+		config_file = strdup(_monitor->config_file);
+	else
+		config_file = strdup(def_config_file);
+	if (!config_file) {
+		fail("strdup default config file failed\n");
+		goto out;
+	}
+
+	buf = malloc(BUF_SIZE);
+	if (!buf) {
+		fail("malloc read config-file buf error\n");
+		goto out;
+	}
+
+	f = fopen(config_file, "r");
+	if (!f) {
+		fail("config-file: %s cannot be opened\n", config_file);
+		goto out;
+	}
+
+	while (fgets(buf, BUF_SIZE, f)) {
+		value = NULL;
+		line++;
+
+		while (isspace(*buf))
+			buf++;
+
+		if (*buf == '#' || *buf == '\0')
+			continue;
+
+		value = strchr(buf, '=');
+		if (!value) {
+			fail("config-file syntax error, skip line[%i]\n", line);
+			continue;
+		}
+
+		value[0] = '\0';
+		value++;
+
+		while (isspace(value[0]))
+			value++;
+
+		len = strlen(buf);
+		if (len == 0)
+			continue;
+		while (isspace(buf[len-1]))
+			len--;
+		buf[len] = '\0';
+
+		len = strlen(value);
+		if (len == 0)
+			continue;
+		while (isspace(value[len-1]))
+			len--;
+		value[len] = '\0';
+
+		if (len == 0)
+			continue;
+
+		parse_config(&_param->bus, "bus", value, buf);
+		parse_config(&_param->dimm, "dimm", value, buf);
+		parse_config(&_param->region, "region", value, buf);
+		parse_config(&_param->namespace, "namespace", value, buf);
+		parse_config(&_monitor->dimm_event, "dimm-event", value, buf);
+
+		if (!_monitor->logfile)
+			parse_config(&_monitor->logfile, "logfile", value, buf);
+	}
+	fclose(f);
+	free(config_file);
+	return 0;
+out:
+	if (config_file)
+		free(config_file);
+	return 1;
+}
+
 int cmd_monitor(int argc, const char **argv, void *ctx)
 {
 	const struct option options[] = {
@@ -441,6 +545,8 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 				"namespace-id", "filter by namespace id"),
 		OPT_FILENAME('l', "logfile", &monitor.logfile, "file | syslog",
 				"where to output the monitor's notification"),
+		OPT_FILENAME('c', "config-file", &monitor.config_file,
+				"config-file", "override the default config"),
 		OPT_BOOLEAN('f', "daemon", &monitor.daemon,
 				"run ndctl monitor as a daemon"),
 		OPT_STRING('D', "dimm-event", &monitor.dimm_event,
@@ -470,6 +576,15 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 		ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
 	ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_NOTICE);
 
+	if (read_config_file((struct ndctl_ctx *)ctx, &monitor, &param))
+		goto out;
+
+	if (monitor.logfile && (strcmp(monitor.logfile, "./syslog") != 0)
+			&& (strcmp(monitor.logfile, "syslog") != 0)) {
+		fix_filename(prefix, (const char **)&monitor.logfile);
+		ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_file);
+	}
+
 	if (monitor.daemon) {
 		if (daemon(0, 0) != 0) {
 			err((struct ndctl_ctx *)ctx, "daemon start failed\n");
diff --git a/ndctl/monitor.conf b/ndctl/monitor.conf
new file mode 100644
index 0000000..5c10a8d
--- /dev/null
+++ b/ndctl/monitor.conf
@@ -0,0 +1,41 @@
+# This is the main ndctl monitor configuration file. It contains the
+# configuration directives that give ndctl monitor instructions.
+# You can change the configuration of ndctl monitor by editing this
+# file or using [--config-file=<file>] option to override this one.
+# The changed value will work after restart ndctl monitor service.
+
+# In this file, lines starting with a hash (#) are comments.
+# The configurations should follow <key> = <value> style.
+# Multiple space-separated values are allowed, but except the following
+# characters: : ? / \ % " ' $ & ! * { } [ ] ( ) = < > @
+
+# The objects to monitor are filtered via dimm's name by setting key "dimm".
+# If this value is different from the value of [--dimm=<value>] option,
+# both of the values will work.
+# dimm = all
+
+# The objects to monitor are filtered via its parent bus by setting key "bus".
+# If this value is different from the value of [--bus=<value>] option,
+# both of the values will work.
+# bus = all
+
+# The objects to monitor are filtered via region by setting key "region".
+# If this value is different from the value of [--region=<value>] option,
+# both of the values will work.
+# region = all
+
+# The objects to monitor are filtered via namespace by setting key "namespace".
+# If this value is different from the value of [--namespace=<value>] option,
+# both of the values will work.
+# namespace = all
+
+# The DIMM events to monitor are filtered via event type by setting key
+# "dimm-event". If this value is different from the value of
+# [--dimm-event=<value>] option, both of the values will work.
+# dimm-event = all
+
+# Users can choose to output the notifications to syslog (logfile=syslog)
+# or to write into a special file (logfile=<file>) by setting key "logfile".
+# If this value is in conflict with the value of [--logfile=<value>] option,
+# this value will be ignored.
+# logfile = /var/log/ndctl/monitor.log
-- 
2.18.0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
