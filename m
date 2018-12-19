Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C5AAA2119AC07
 for <linux-nvdimm@lists.01.org>; Wed, 19 Dec 2018 02:32:21 -0800 (PST)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 02138AC0195
 for <linux-nvdimm@lists.01.org>; Wed, 19 Dec 2018 19:32:17 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH 2/2] ndctl, monitor: refactor parse_config_file
Date: Wed, 19 Dec 2018 19:31:44 +0900
Message-Id: <20181219103144.23215-2-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20181219103144.23215-1-qi.fuli@jp.fujitsu.com>
References: <20181219103144.23215-1-qi.fuli@jp.fujitsu.com>
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

This patch is used for refactoring parse_config_file by replacing the
open coded implementation with ccan/ciniparser library.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 ndctl/Makefile.am  |   1 +
 ndctl/monitor.c    | 114 ++++++++++++---------------------------------
 ndctl/monitor.conf |   2 +
 3 files changed, 32 insertions(+), 85 deletions(-)

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 8a5e5f8..3da1c0e 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -28,6 +28,7 @@ ndctl_LDADD =\
 	lib/libndctl.la \
 	../daxctl/lib/libdaxctl.la \
 	../libutil.a \
+	../libccan.a \
 	$(UUID_LIBS) \
 	$(KMOD_LIBS) \
 	$(JSON_LIBS)
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index b92a133..a4e8048 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -14,6 +14,7 @@
 #include <ndctl/lib/private.h>
 #include <ndctl/libndctl.h>
 #include <sys/epoll.h>
+#include <ccan/ciniparser/ciniparser.h>
 #define BUF_SIZE 2048
 
 static struct monitor {
@@ -476,12 +477,12 @@ out:
 	return rc;
 }
 
-static void parse_config(const char **arg, char *key, char *val, char *ident)
+static void parse_config(const char **arg, char *val)
 {
 	struct strbuf value = STRBUF_INIT;
 	size_t arg_len = *arg ? strlen(*arg) : 0;
 
-	if (!ident || !key || (strcmp(ident, key) != 0))
+	if (!val)
 		return;
 
 	if (arg_len) {
@@ -492,92 +493,32 @@ static void parse_config(const char **arg, char *key, char *val, char *ident)
 	*arg = strbuf_detach(&value, NULL);
 }
 
-static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
-		struct util_filter_params *_param)
+static int parse_config_file(const char *config_file)
 {
-	FILE *f;
-	size_t len = 0;
-	int line = 0, rc = 0;
-	char *buf = NULL, *seek, *value, *config_file;
-
-	if (_monitor->config_file)
-		config_file = strdup(_monitor->config_file);
-	else
-		config_file = strdup(DEF_CONF_FILE);
-	if (!config_file) {
-		fail("strdup default config file failed\n");
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	buf = malloc(BUF_SIZE);
-	if (!buf) {
-		fail("malloc read config-file buf error\n");
-		rc = -ENOMEM;
+	dictionary *dic;
+
+	dic = ciniparser_load(config_file);
+	if (!dic)
+		return -errno;
+
+	parse_config(&param.bus,
+			ciniparser_getstring(dic, "monitor:bus", NULL));
+	parse_config(&param.dimm,
+			ciniparser_getstring(dic, "monitor:dimm", NULL));
+	parse_config(&param.region,
+			ciniparser_getstring(dic, "monitor:region", NULL));
+	parse_config(&param.namespace,
+			ciniparser_getstring(dic, "monitor:namespace", NULL));
+	parse_config(&monitor.dimm_event,
+			ciniparser_getstring(dic, "monitor:dimm-event", NULL));
+	if (monitor.log)
 		goto out;
-	}
-	seek = buf;
-
-	f = fopen(config_file, "r");
-	if (!f) {
-		err(ctx, "config-file: %s cannot be opened\n", config_file);
-		rc = -errno;
-		goto out;
-	}
-
-	while (fgets(seek, BUF_SIZE, f)) {
-		value = NULL;
-		line++;
-
-		while (isspace(*seek))
-			seek++;
-
-		if (*seek == '#' || *seek == '\0')
-			continue;
+	parse_config(&monitor.log,
+			ciniparser_getstring(dic, "monitor:log", NULL));
 
-		value = strchr(seek, '=');
-		if (!value) {
-			fail("config-file syntax error, skip line[%i]\n", line);
-			continue;
-		}
-
-		value[0] = '\0';
-		value++;
-
-		while (isspace(value[0]))
-			value++;
-
-		len = strlen(seek);
-		if (len == 0)
-			continue;
-		while (isspace(seek[len-1]))
-			len--;
-		seek[len] = '\0';
-
-		len = strlen(value);
-		if (len == 0)
-			continue;
-		while (isspace(value[len-1]))
-			len--;
-		value[len] = '\0';
-
-		if (len == 0)
-			continue;
-
-		parse_config(&_param->bus, "bus", value, seek);
-		parse_config(&_param->dimm, "dimm", value, seek);
-		parse_config(&_param->region, "region", value, seek);
-		parse_config(&_param->namespace, "namespace", value, seek);
-		parse_config(&_monitor->dimm_event, "dimm-event", value, seek);
-
-		if (!_monitor->log)
-			parse_config(&_monitor->log, "log", value, seek);
-	}
-	fclose(f);
 out:
-	free(buf);
-	free(config_file);
-	return rc;
+	ciniparser_freedict(dic);
+	return 0;
 }
 
 int cmd_monitor(int argc, const char **argv, void *ctx)
@@ -630,7 +571,10 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 	else
 		ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_INFO);
 
-	rc = read_config_file((struct ndctl_ctx *)ctx, &monitor, &param);
+	if (monitor.config_file)
+		rc = parse_config_file(monitor.config_file);
+	else
+		rc = parse_config_file(DEF_CONF_FILE);
 	if (rc)
 		goto out;
 
diff --git a/ndctl/monitor.conf b/ndctl/monitor.conf
index 934e2c0..edcf8e2 100644
--- a/ndctl/monitor.conf
+++ b/ndctl/monitor.conf
@@ -9,6 +9,8 @@
 # Multiple space-separated values are allowed, but except the following
 # characters: : ? / \ % " ' $ & ! * { } [ ] ( ) = < > @
 
+[monitor]
+
 # The objects to monitor are filtered via dimm's name by setting key "dimm".
 # If this value is different from the value of [--dimm=<value>] option,
 # both of the values will work.
-- 
2.20.0.rc2


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
