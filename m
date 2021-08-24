Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749183FD3
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 09:51:44 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id x4so19266854pgh.1
        for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 02:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f1D2+AEArEhW2gM4q5VlXsUVZD8mb0A6TWokPtbcWJc=;
        b=mEHrLeSX2RRGqAivmK0q7pw0VWpsYu+fi/rjC4rXeFLN3Lhk0ELpwt1mJmWO7YNo6K
         NBtVgOXvk8EZ52SJtA1ihuVFc/alMndBcrTuO/WAo9wWsGMCF2AoJa2DaSUht/xZ0f6P
         iZBDImGgB8OOTGY5qguDVLsnJJgwNhfGEyafo/50kmMpkp/9In67iaoHTEIhRE7fgpdj
         G4fuxdYFYNB3AHZ2gyo8buJlevTrYmF09YA1Pl0Cb64eu5/OHnnTlz4Dmt1ePVtSowAr
         LZxozGH1jUSUGNCkq6zdsGZMeZQ9/B5KtDMi0rD/RZs5E7VBoy38WknRjfEI1k2b7atP
         Zk3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f1D2+AEArEhW2gM4q5VlXsUVZD8mb0A6TWokPtbcWJc=;
        b=oUhbIju0Xwsrau5kPv47nCzcqeL08r7PFg+zxnNMp6YmZxmw9X0tne9POhC+67Y9uD
         Jf7Vxa7EYCRb+cLg02mZuCGPH6UeOXqJk6WySjLHSFabgGi8k+JjIauutBZB97ABSs8u
         JL+casv5WghYDRQApgIgrlLjRfXj/x51/KTj+ceoBkiR1pezkP98hdI+ZNkKOVTSE1zQ
         erAJv/pYl+51ky7B/FqQr1wDErU5j/EEXW/TxLkpdAF9bZpZtUBuGj2SNkKpS06WVHG6
         uBzh38l48Er/KkpJJ1Fj1xLj6Cv+Fihab2Pu4yGSF1OePV27r9BSK+AT08g91sJELMu1
         R8lQ==
X-Gm-Message-State: AOAM531U/VHdE0Jzdqrjxs80lU6JupCCC1WhGhsfY93/yQOcwbPhGL8u
	nylBpvdrgMNLoZzhhrVoKP0R/QR5/ffdXQ==
X-Google-Smtp-Source: ABdhPJzLrfL7TFXRSwePc1X4wm876WNqu7/qT3Qk8C/8LF4yCBw0M61JOFDicpaMvQ0sPKpQAPRqZg==
X-Received: by 2002:a63:ff51:: with SMTP id s17mr36213569pgk.415.1629798704150;
        Tue, 24 Aug 2021 02:51:44 -0700 (PDT)
Received: from localhost.localdomain (125x103x255x1.ap125.ftth.ucom.ne.jp. [125.103.255.1])
        by smtp.gmail.com with ESMTPSA id l19sm1873881pjq.10.2021.08.24.02.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 02:51:43 -0700 (PDT)
From: QI Fuli <fukuri.sai@gmail.com>
X-Google-Original-From: QI Fuli <qi.fuli@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH v2 5/5] ndctl, monitor: refator monitor for supporting multiple config files
Date: Tue, 24 Aug 2021 18:51:06 +0900
Message-Id: <20210824095106.104808-6-qi.fuli@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210824095106.104808-1-qi.fuli@fujitsu.com>
References: <20210824095106.104808-1-qi.fuli@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

Refactor ndctl monitor by using parse-configs helper to support multiple
configuration files.

Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
---
 Documentation/ndctl/Makefile.am       |  2 +-
 Documentation/ndctl/ndctl-monitor.txt |  8 ++--
 ndctl/monitor.c                       | 69 ++++++++++++++-------------
 3 files changed, 41 insertions(+), 38 deletions(-)

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
index ca36179..e944c90 100644
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
@@ -601,6 +587,19 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 		"ndctl monitor [<options>]",
 		NULL
 	};
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
 	const char *prefix = "./";
 	struct util_filter_ctx fctx = { 0 };
 	struct monitor_filter_arg mfa = { 0 };
@@ -621,7 +620,11 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 	else
 		monitor.ctx.log_priority = LOG_INFO;
 
-	rc = read_config_file(ctx, &monitor, &param);
+	if (monitor.configs)
+		rc = parse_configs_prefix(monitor.configs, prefix, configs);
+	else
+		rc = parse_configs_prefix(
+				ndctl_get_configs(ctx), prefix, configs);
 	if (rc)
 		goto out;
 
-- 
2.31.1

