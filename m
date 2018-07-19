Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5322121B02845
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 16:00:15 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/4] ndctl, monitor: fix memory leak in read_config_file
Date: Thu, 19 Jul 2018 16:59:56 -0600
Message-Id: <20180719225958.6814-3-vishal.l.verma@intel.com>
In-Reply-To: <20180719225958.6814-1-vishal.l.verma@intel.com>
References: <20180719225958.6814-1-vishal.l.verma@intel.com>
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

Static analysis reports that we leak 'buf' in the above function. Free
that, and refactor some of the error reporting to clean up the flow.
Since the parser loop was modifying 'buf', it wasn't possible to
directly free it. Introduce a 'seek' variable to seek within the buf so
that buf itself remains untouched, and can later be freed.

Fixes: 80dd56d82dd3 ("ndctl, monitor: add main ndctl monitor configuration file")
Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/monitor.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index abab45f..4d25c2b 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -478,9 +478,9 @@ static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
 		struct util_filter_params *_param)
 {
 	FILE *f;
-	int line = 0;
 	size_t len = 0;
-	char *buf, *value, *config_file;
+	int line = 0, rc = 0;
+	char *buf = NULL, *seek, *value, *config_file;
 
 	if (_monitor->config_file)
 		config_file = strdup(_monitor->config_file);
@@ -488,32 +488,36 @@ static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
 		config_file = strdup(DEF_CONF_FILE);
 	if (!config_file) {
 		fail("strdup default config file failed\n");
+		rc = -ENOMEM;
 		goto out;
 	}
 
 	buf = malloc(BUF_SIZE);
 	if (!buf) {
 		fail("malloc read config-file buf error\n");
+		rc = -ENOMEM;
 		goto out;
 	}
+	seek = buf;
 
 	f = fopen(config_file, "r");
 	if (!f) {
 		fail("config-file: %s cannot be opened\n", config_file);
+		rc = -errno;
 		goto out;
 	}
 
-	while (fgets(buf, BUF_SIZE, f)) {
+	while (fgets(seek, BUF_SIZE, f)) {
 		value = NULL;
 		line++;
 
-		while (isspace(*buf))
-			buf++;
+		while (isspace(*seek))
+			seek++;
 
-		if (*buf == '#' || *buf == '\0')
+		if (*seek == '#' || *seek == '\0')
 			continue;
 
-		value = strchr(buf, '=');
+		value = strchr(seek, '=');
 		if (!value) {
 			fail("config-file syntax error, skip line[%i]\n", line);
 			continue;
@@ -525,12 +529,12 @@ static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
 		while (isspace(value[0]))
 			value++;
 
-		len = strlen(buf);
+		len = strlen(seek);
 		if (len == 0)
 			continue;
-		while (isspace(buf[len-1]))
+		while (isspace(seek[len-1]))
 			len--;
-		buf[len] = '\0';
+		seek[len] = '\0';
 
 		len = strlen(value);
 		if (len == 0)
@@ -542,22 +546,20 @@ static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
 		if (len == 0)
 			continue;
 
-		parse_config(&_param->bus, "bus", value, buf);
-		parse_config(&_param->dimm, "dimm", value, buf);
-		parse_config(&_param->region, "region", value, buf);
-		parse_config(&_param->namespace, "namespace", value, buf);
-		parse_config(&_monitor->dimm_event, "dimm-event", value, buf);
+		parse_config(&_param->bus, "bus", value, seek);
+		parse_config(&_param->dimm, "dimm", value, seek);
+		parse_config(&_param->region, "region", value, seek);
+		parse_config(&_param->namespace, "namespace", value, seek);
+		parse_config(&_monitor->dimm_event, "dimm-event", value, seek);
 
 		if (!_monitor->log)
-			parse_config(&_monitor->log, "log", value, buf);
+			parse_config(&_monitor->log, "log", value, seek);
 	}
 	fclose(f);
-	free(config_file);
-	return 0;
 out:
-	if (config_file)
-		free(config_file);
-	return 1;
+	free(buf);
+	free(config_file);
+	return rc;
 }
 
 int cmd_monitor(int argc, const char **argv, void *ctx)
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
