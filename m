Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E773FC3
	for <nvdimm@lists.linux.dev>; Sun, 22 Aug 2021 20:30:59 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id k24so14691863pgh.8
        for <nvdimm@lists.linux.dev>; Sun, 22 Aug 2021 13:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CCjMEjtReEZhcF8HyF8lnL8RuIHQrRWYKAQ9ulEmCzo=;
        b=qWtK2N3e9Bdo+lEyFWOrbT9K9PUI+dCxDg6IraGgdIFqLUxP8dhs31847Q1rFObIS2
         6M5vg/pphzNWINvW2Dt2jXQzQBP1k7wKthavMjsbQV7qGh6i2H4zjsbJKTW8/CJohoei
         31a/W5pCAgViepAPBqjubjQN1kMiq7OsNzxxR6m4VJSNVa9XegxkRup3X3W9jLvyIXF4
         B3Xe7/ysO7cSFCr8XGWO/dnf2YK0OvgssHGyIYkFKCsyHjDClGsOcAKJF1ygr0Kjt7ic
         vilN6asB0Z5/DL2iRjyOeLKSuPp6zsISPu3GCUi101r5H8c6nvvB9gkX9j1N1aDAUa8+
         BrBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CCjMEjtReEZhcF8HyF8lnL8RuIHQrRWYKAQ9ulEmCzo=;
        b=B5tEjmh52AzhF4QG0cl3FzT9m3qDqdkNE62QABeCEfBHuWNjGQ/WTlPzjEqIGXSnPr
         DRH2pSrGOjYJ3Gr4yU1N4vWJGb+AyBif/oJtTgZr+hIaYO+wLFujQ8WOWU+qOlwqu7su
         xWezJ716X49cA8fXXsrzBXC2Ym2EuUBktuG4zRJfXau8aS0HmwVSv+1WT0ZX+EkzqqAL
         +9mAl/esqItPK6ho9NaE54ulJUjJzDI3sICU2qgAXaENggfGGZhgaXm6mh+KQLp0AiJg
         m1H0h8tLqXIQ8hanFrWR7+zP64empC9+HQFJCqWDqkL2t10ejYp7yxgVgSh3XpTcHKmb
         40Ow==
X-Gm-Message-State: AOAM530s/sW+pK3a7mDsq028GE4kpcb9gnWttR52iAzSkJ7R2JjquRBh
	iUwodzPnQZoznwLo25DCInamuJOM5Eodag==
X-Google-Smtp-Source: ABdhPJwR+s17nc1PTcEpbcwnTyi0i1q/xPpJnSUhFWKMBgSlCYz8CCN/OFJBAqlhR/cekfexUlFlmg==
X-Received: by 2002:a62:5543:0:b0:3eb:22a3:bb5c with SMTP id j64-20020a625543000000b003eb22a3bb5cmr4307917pfb.61.1629664259476;
        Sun, 22 Aug 2021 13:30:59 -0700 (PDT)
Received: from localhost.localdomain (125x103x255x1.ap125.ftth.ucom.ne.jp. [125.103.255.1])
        by smtp.gmail.com with ESMTPSA id n30sm13587804pfv.87.2021.08.22.13.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 13:30:59 -0700 (PDT)
From: QI Fuli <fukuri.sai@gmail.com>
X-Google-Original-From: QI Fuli <qi.fuli@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH 5/5] ndctl, monitor: refactor monitor for supporting multiple config files
Date: Mon, 23 Aug 2021 05:30:15 +0900
Message-Id: <20210822203015.528438-6-qi.fuli@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210822203015.528438-1-qi.fuli@fujitsu.com>
References: <20210822203015.528438-1-qi.fuli@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

In order to support multiple configration files, refactor ndctl monitor
by using parse-configs helper. 

Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
---
 Documentation/ndctl/Makefile.am       |  2 +-
 Documentation/ndctl/ndctl-monitor.txt |  8 ++--
 ndctl/Makefile.am                     |  1 +
 ndctl/monitor.c                       | 69 ++++++++++++++-------------
 4 files changed, 42 insertions(+), 38 deletions(-)

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
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index fceb3ab..3c59aa7 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -55,6 +55,7 @@ ndctl_LDADD =\
 	lib/libndctl.la \
 	../daxctl/lib/libdaxctl.la \
 	../libutil.a \
+	../libccan.a \
 	$(UUID_LIBS) \
 	$(KMOD_LIBS) \
 	$(JSON_LIBS)
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

