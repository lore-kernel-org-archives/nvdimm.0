Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C6F6D22
	for <nvdimm@lists.linux.dev>; Fri, 10 Dec 2021 22:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639175694; x=1670711694;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C2HRgDQaTo4vCgLeABo1Ufw3+kLfZDQdDYhJPRn5HIU=;
  b=MO1Wadu4KDTd7aZc3Jx7lXo5gQyI8nICcOG2tGht6bqEaLuorHlKV6jE
   BbsGjCoV6piicvWWqNXW4pGWEs3zM9Uvsh6fzR0JpAMhLp5E/jdhApReU
   Zbksr1cCAQmtxMcw3U8Ut3wvyJbKVBbPC7aca7/DQol31f0ihRBJ5/c6x
   9F+k8vj3i8nRlWfWC2yGzE5Rfykel935wbtKKUEE8Rm9MdbPRKh/I211H
   X9BRAGwB+5svJSMmVktmj9g+x4s3+Fgkd3fF0rWSOlwFYPK/Lpe8TNGZB
   IegCqEXvo/ed+nQqe1vIj3wW4S5qETLS0KYPsEoEpcPNkfzhL0lsFaieW
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="301843359"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="301843359"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:45 -0800
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="504113664"
Received: from fpchan-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.0.94])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:45 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	QI Fuli <qi.fuli@fujitsu.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 04/11] ndctl, monitor: refator monitor for supporting multiple config files
Date: Fri, 10 Dec 2021 15:34:33 -0700
Message-Id: <20211210223440.3946603-5-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210223440.3946603-1-vishal.l.verma@intel.com>
References: <20211210223440.3946603-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7007; i=vishal.l.verma@intel.com; h=from:subject; bh=GCZH7H1P2UxIODaOXhGfHUVvz6W0Ya4ZKwo5mBwTlAA=; b=owGbwMvMwCXGf25diOft7jLG02pJDImbr/4TuvfEtjee7/HSFQdeN003vhh/eD7fzIdvmT+vKlnw mNfxZUcpC4MYF4OsmCLL3z0fGY/Jbc/nCUxwhJnDygQyhIGLUwAmskCW4X/2ljTp06+8v716fEfGqX tyWKbdho9xhRaSASHdyuEF038w/JX8LOV5T9Hzqvdz3a5rbw6ySPUfLNJg28eu/9XSf1e2LRcA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

Refactor ndctl monitor by using parse-configs helper to support multiple
configuration files.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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
index ca36179..0e9b65c 100644
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
+	ndctl_configs = ndctl_get_config_path(ctx);
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

