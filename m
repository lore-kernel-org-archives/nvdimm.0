Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CBA0D2095DC98
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jun 2018 01:27:54 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 1F578AC0115
 for <linux-nvdimm@lists.01.org>;
 Mon, 18 Jun 2018 17:27:47 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH v7 2/3] ndctl,
 monitor: add main ndctl monitor configuration file
Date: Mon, 18 Jun 2018 17:27:00 +0900
Message-Id: <20180618082701.12326-3-qi.fuli@jp.fujitsu.com>
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

This patch adds the main configuration file(/etc/ndctl/monitor.conf)
of ndctl monitor. It contains the configuration directives that give
ndctl monitor instructions. Users can change the configuration by
editing this file or by using [--config-file=<file>] option to
override this file. The changed value will work after resetart ndctl
monitor service.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 ndctl/Makefile.am  |   5 ++
 ndctl/monitor.c    | 115 +++++++++++++++++++++++++++++++++++++++++++++
 ndctl/monitor.conf |  42 +++++++++++++++++
 3 files changed, 162 insertions(+)
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
index 12aa499..8ac20ac 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -31,6 +31,7 @@ static enum log_destination {
 
 static struct {
 	const char *logfile;
+	const char *config_file;
 	const char *dimm_event;
 	bool daemon;
 } monitor;
@@ -71,6 +72,19 @@ static bool is_dir(char *filepath)
 	return false;
 }
 
+static void set_config(const char **arg, char *val)
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
 static void logreport(struct ndctl_ctx *ctx, int priority, const char *file,
 		int line, const char *fn, const char *format, va_list args)
 {
@@ -449,6 +463,102 @@ out:
 	return 1;
 }
 
+static int read_config_file(struct ndctl_ctx *ctx, const char *prefix)
+{
+	FILE *f;
+	int line = 0;
+	size_t len = 0;
+	char *buf, *value;
+	char *config_file = "/etc/ndctl/monitor.conf";
+
+	buf = (char *)malloc(BUF_SIZE);
+	if (!buf) {
+		fail("malloc read config-file buf error\n");
+		goto out;
+	}
+	if (monitor.config_file) {
+		fix_filename(prefix, (const char **)&monitor.config_file);
+		config_file = (char *)monitor.config_file;
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
+		if (strcmp(buf, "bus") == 0) {
+			set_config((const char **)&param.bus, value);
+			continue;
+		}
+		if (strcmp(buf, "dimm") == 0) {
+			set_config((const char **)&param.dimm, value);
+			continue;
+		}
+		if (strcmp(buf, "region") == 0) {
+			set_config((const char **)&param.region, value);
+			continue;
+		}
+		if (strcmp(buf, "namespace") == 0) {
+			set_config((const char **)&param.namespace, value);
+			continue;
+		}
+		if (strcmp(buf, "dimm-event") == 0) {
+			set_config((const char **)&monitor.dimm_event, value);
+			continue;
+		}
+		if (strcmp(buf, "logfile") == 0) {
+			if (monitor.logfile)
+				continue;
+			set_config((const char **)&monitor.logfile, value);
+			fix_filename(prefix, (const char **)&monitor.logfile);
+		}
+	}
+	fclose(f);
+	return 0;
+out:
+	return 1;
+}
+
 int cmd_monitor(int argc, const char **argv, void *ctx)
 {
 	int i;
@@ -463,6 +573,8 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 		OPT_FILENAME('l', "logfile", &monitor.logfile,
 				"file | syslog | stderr",
 				"where to output the monitor's notification"),
+		OPT_FILENAME('c', "config-file", &monitor.config_file,
+				"config-file", "override the default config"),
 		OPT_BOOLEAN('f', "daemon", &monitor.daemon,
 				"run ndctl monitor as a daemon"),
 		OPT_STRING('D', "dimm-event", &monitor.dimm_event,
@@ -488,6 +600,9 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 	ndctl_set_log_fn((struct ndctl_ctx *)ctx, logreport);
 	ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_INFO);
 
+	if (read_config_file((struct ndctl_ctx *)ctx, prefix))
+		goto out;
+
 	if (monitor.logfile) {
 		if (strcmp(monitor.logfile, "./stderr") == 0)
 			log_destination = LOG_DESTINATION_STDERR;
diff --git a/ndctl/monitor.conf b/ndctl/monitor.conf
new file mode 100644
index 0000000..590f1c4
--- /dev/null
+++ b/ndctl/monitor.conf
@@ -0,0 +1,42 @@
+# This is the main ndctl monitor configuration file. It contains the
+# configuration directives that give ndctl monitor instructions.
+# You can change the configuration of ndctl monitor by editing this
+# file or by using [--config-file=<file>] option to override this one.
+# The changed value will work after restart ndctl monitor service.
+
+# In this file, lines starting with a hash (#) are comments.
+# The configurations shold follow <key> = <value> style.
+# Multiple space-seperated values are allowed, but except the following
+# charecters: : # ? / \ % " '
+
+# The dimms to monitor are filtered via dimm's name by setting key "dimm".
+# If this value is different from the value of [--dimm=<value>] option,
+# both of the values will work.
+# dimm = all
+
+# The dimms to monitor are filtered via its parent bus by setting key "bus".
+# If this value is different from the value of [--bus=<value>] option,
+# both of the values will work.
+# bus = all
+
+# The dimms to monitor are filtered via region by setting key "region".
+# If this value is different from the value of [--region=<value>] option,
+# both of the values will work.
+# region = all
+
+# The dimms to monitor are filtered via namespace by setting key "namespace".
+# If this value is different from the value of [--namespace=<value>] option,
+# both of the values will work.
+# namespace = all
+
+# The DIMM events to monitor are filtered via event type by setting key
+# "dimm-event". If this value is different from the value of
+# [--dimm-event=<value>] option, both of the values will work.
+# dimm-event = all
+
+# Users can choose to output the notifications to syslog (logfile=syslog),
+# stderr (logfile=stderr) or to write into a special file (logfile=<file>)
+# by setting key "logfile".
+# If this value is in conflict with the value of [--logfile=<value>] option,
+# this value will be ignored.
+# logfile = /var/log/ndctl/monitor.log
-- 
2.17.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
