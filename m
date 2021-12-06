Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD77F2CA6
	for <nvdimm@lists.linux.dev>; Mon,  6 Dec 2021 22:28:43 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="300804830"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="300804830"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:43 -0800
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="502310438"
Received: from ponufryk-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.29])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:42 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	QI Fuli <qi.fuli@fujitsu.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 05/12] ndctl, monitor: refator monitor for supporting multiple config files
Date: Mon,  6 Dec 2021 15:28:23 -0700
Message-Id: <20211206222830.2266018-6-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211206222830.2266018-1-vishal.l.verma@intel.com>
References: <20211206222830.2266018-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7030; i=vishal.l.verma@intel.com; h=from:subject; bh=0FNwwOkFG0eXJo4s9p4HFwxBhDNBFB7cH2qRCHR5rwc=; b=owGbwMvMwCXGf25diOft7jLG02pJDInr+nq2sWZFH6vjfP59blToriDJQ9u42YvWnZzkb/7DceVb m2K/jlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEzkhgEjwyMT18Bgvrqsc52WCzasex qeKFA0c/pJnmVCdloN3psM1Bj+FwrUh0/e7vLI3D9NxPPH7X+VbJ+c57311A8OOi5XotTMDQA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

Refactor ndctl monitor by using parse-configs helper to support multiple
configuration files.

Link: https://lore.kernel.org/r/20210824095106.104808-6-qi.fuli@fujitsu.com
Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/ndctl-monitor.txt |  8 +--
 ndctl/monitor.c                       | 73 ++++++++++++++-------------
 Documentation/ndctl/Makefile.am       |  2 +-
 3 files changed, 44 insertions(+), 39 deletions(-)

diff --git a/Documentation/ndctl/ndctl-monitor.txt b/Documentation/ndctl/ndctl-monitor.txt
index dbc9070..8c8c35b 100644
--- a/Documentation/ndctl/ndctl-monitor.txt
+++ b/Documentation/ndctl/ndctl-monitor.txt
@@ -21,8 +21,8 @@ objects and dumping the json format notifications to syslog, standard
 output or a logfile.
 
 The objects to monitor and smart events to notify can be selected by
-setting options and/or the configuration file at
-{ndctl_monitorconfdir}/{ndctl_monitorconf}
+setting options and/or configuration files with .conf suffix under
+{ndctl_confdir}
 
 Both, the values in configuration file and in options will work. If
 there is a conflict, the values in options will override the values in
@@ -81,8 +81,8 @@ will not work if "--daemon" is specified.
 
 -c::
 --config-file=::
-	Provide the config file to use. This overrides the default config
-	typically found in {ndctl_monitorconfdir}
+	Provide the config file(s) to use. This overrides the default config
+	typically found in {ndctl_confdir}
 
 --daemon::
 	Run a monitor as a daemon.
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index ca36179..6bf3160 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -10,6 +10,7 @@
 #include <util/filter.h>
 #include <util/util.h>
 #include <util/parse-options.h>
+#include <util/parse-configs.h>
 #include <util/strbuf.h>
 #include <ndctl/config.h>
 #include <ndctl/ndctl.h>
@@ -28,7 +29,7 @@
 
 static struct monitor {
 	const char *log;
-	const char *config_file;
+	const char *configs;
 	const char *dimm_event;
 	FILE *log_file;
 	bool daemon;
@@ -463,7 +464,7 @@ out:
 	return rc;
 }
 
-static void parse_config(const char **arg, char *key, char *val, char *ident)
+static void set_monitor_conf(const char **arg, char *key, char *val, char *ident)
 {
 	struct strbuf value = STRBUF_INIT;
 	size_t arg_len = *arg ? strlen(*arg) : 0;
@@ -479,39 +480,25 @@ static void parse_config(const char **arg, char *key, char *val, char *ident)
 	*arg = strbuf_detach(&value, NULL);
 }
 
-static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
-		struct util_filter_params *_param)
+static int parse_monitor_config(const struct config *configs,
+					const char *config_file)
 {
 	FILE *f;
 	size_t len = 0;
 	int line = 0, rc = 0;
-	char *buf = NULL, *seek, *value, *config_file;
-
-	if (_monitor->config_file)
-		config_file = strdup(_monitor->config_file);
-	else
-		config_file = strdup(NDCTL_CONF_FILE);
-	if (!config_file) {
-		fail("strdup default config file failed\n");
-		rc = -ENOMEM;
-		goto out;
-	}
+	char *buf = NULL, *seek, *value;
 
 	buf = malloc(BUF_SIZE);
 	if (!buf) {
 		fail("malloc read config-file buf error\n");
-		rc = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 	seek = buf;
 
 	f = fopen(config_file, "r");
 	if (!f) {
-		if (_monitor->config_file) {
-			err(&monitor, "config-file: %s cannot be opened\n",
-				config_file);
-			rc = -errno;
-		}
+		err(&monitor, "%s cannot be opened\n", config_file);
+		rc = -errno;
 		goto out;
 	}
 
@@ -554,19 +541,18 @@ static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
 		if (len == 0)
 			continue;
 
-		parse_config(&_param->bus, "bus", value, seek);
-		parse_config(&_param->dimm, "dimm", value, seek);
-		parse_config(&_param->region, "region", value, seek);
-		parse_config(&_param->namespace, "namespace", value, seek);
-		parse_config(&_monitor->dimm_event, "dimm-event", value, seek);
+		set_monitor_conf(&param.bus, "bus", value, seek);
+		set_monitor_conf(&param.dimm, "dimm", value, seek);
+		set_monitor_conf(&param.region, "region", value, seek);
+		set_monitor_conf(&param.namespace, "namespace", value, seek);
+		set_monitor_conf(&monitor.dimm_event, "dimm-event", value, seek);
 
-		if (!_monitor->log)
-			parse_config(&_monitor->log, "log", value, seek);
+		if (!monitor.log)
+			set_monitor_conf(&monitor.log, "log", value, seek);
 	}
 	fclose(f);
 out:
 	free(buf);
-	free(config_file);
 	return rc;
 }
 
@@ -585,8 +571,8 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 		OPT_FILENAME('l', "log", &monitor.log,
 				"<file> | syslog | standard",
 				"where to output the monitor's notification"),
-		OPT_FILENAME('c', "config-file", &monitor.config_file,
-				"config-file", "override the default config"),
+		OPT_STRING('c', "config-file", &monitor.configs,
+				"config-file", "override default configs"),
 		OPT_BOOLEAN('\0', "daemon", &monitor.daemon,
 				"run ndctl monitor as a daemon"),
 		OPT_BOOLEAN('u', "human", &monitor.human,
@@ -601,7 +587,20 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 		"ndctl monitor [<options>]",
 		NULL
 	};
-	const char *prefix = "./";
+	const struct config configs[] = {
+		CONF_MONITOR(NDCTL_CONF_FILE, parse_monitor_config),
+		CONF_STR("core:bus", &param.bus, NULL),
+		CONF_STR("core:region", &param.region, NULL),
+		CONF_STR("core:dimm", &param.dimm, NULL),
+		CONF_STR("core:namespace", &param.namespace, NULL),
+		CONF_STR("monitor:bus", &param.bus, NULL),
+		CONF_STR("monitor:region", &param.region, NULL),
+		CONF_STR("monitor:dimm", &param.dimm, NULL),
+		CONF_STR("monitor:namespace", &param.namespace, NULL),
+		CONF_STR("monitor:dimm-event", &monitor.dimm_event, NULL),
+		CONF_END(),
+	};
+	const char *prefix = "./", *ndctl_configs;
 	struct util_filter_ctx fctx = { 0 };
 	struct monitor_filter_arg mfa = { 0 };
 	int i, rc;
@@ -621,7 +620,13 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 	else
 		monitor.ctx.log_priority = LOG_INFO;
 
-	rc = read_config_file(ctx, &monitor, &param);
+	ndctl_configs = ndctl_get_configs_dir(ctx);
+	if (monitor.configs)
+		rc = parse_configs_prefix(monitor.configs, prefix, configs);
+	else if (ndctl_configs)
+		rc = parse_configs_prefix(ndctl_configs, prefix, configs);
+	else
+		rc = 0;
 	if (rc)
 		goto out;
 
diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index f0d5b21..37855cc 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -59,7 +59,7 @@ CLEANFILES = $(man1_MANS)
 .ONESHELL:
 attrs.adoc: $(srcdir)/Makefile.am
 	$(AM_V_GEN) cat <<- EOF >$@
-		:ndctl_monitorconfdir: $(ndctl_monitorconfdir)
+		:ndctl_confdir: $(ndctl_confdir)
 		:ndctl_monitorconf: $(ndctl_monitorconf)
 		:ndctl_keysdir: $(ndctl_keysdir)
 		EOF
-- 
2.33.1

