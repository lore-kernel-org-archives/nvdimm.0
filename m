Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 88DB321198CC2
 for <linux-nvdimm@lists.01.org>; Thu, 27 Dec 2018 19:43:01 -0800 (PST)
Subject: [ndctl PATCH 5/7] ndctl/monitor: Fix / cleanup log_file()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Dec 2018 19:30:25 -0800
Message-ID: <154596782507.164521.14912344768619698318.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154596779833.164521.12632457592535372923.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <154596779833.164521.12632457592535372923.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The log_file() helper opens the log file for each message. Avoid the
scenario where the fopen() fails and just open it at init time.

This usage is also broken because if the vasprintf() fails it will try
to print via log_file again via fail(), and potentially lead to infinite
recursion.

Cc: Qi Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/monitor.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index cef70d06beae..8a16c9664e0a 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -20,6 +20,7 @@ static struct monitor {
 	const char *log;
 	const char *config_file;
 	const char *dimm_event;
+	FILE *log_file;
 	bool daemon;
 	bool human;
 	bool verbose;
@@ -82,7 +83,7 @@ static void log_standard(struct ndctl_ctx *ctx, int priority, const char *file,
 static void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
 		int line, const char *fn, const char *format, va_list args)
 {
-	FILE *f;
+	FILE *f = monitor.log_file;
 	char *buf;
 	struct timespec ts;
 	char timestamp[32];
@@ -92,16 +93,6 @@ static void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
 		return;
 	}
 
-	f = fopen(monitor.log, "a+");
-	if (!f) {
-		ndctl_set_log_fn(ctx, log_syslog);
-		err(ctx, "open logfile %s failed, forward messages to syslog\n",
-				monitor.log);
-		did_fail = 1;
-		notice(ctx, "%s\n", buf);
-		goto end;
-	}
-
 	if (priority != LOG_NOTICE) {
 		clock_gettime(CLOCK_REALTIME, &ts);
 		sprintf(timestamp, "%10ld.%09ld", ts.tv_sec, ts.tv_nsec);
@@ -110,8 +101,6 @@ static void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
 		fprintf(f, "%s", buf);
 
 	fflush(f);
-	fclose(f);
-end:
 	free(buf);
 	return;
 }
@@ -613,7 +602,6 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 	struct util_filter_ctx fctx = { 0 };
 	struct monitor_filter_arg mfa = { 0 };
 	int i, rc;
-	FILE *f;
 
 	argc = parse_options_prefix(argc, argv, prefix, options, u, 0);
 	for (i = 0; i < argc; i++) {
@@ -642,13 +630,12 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 		else if (strncmp(monitor.log, "./standard", 10) == 0)
 			; /*default, already set */
 		else {
-			f = fopen(monitor.log, "a+");
-			if (!f) {
+			monitor.log_file = fopen(monitor.log, "a+");
+			if (!monitor.log_file) {
 				error("open %s failed\n", monitor.log);
 				rc = -errno;
 				goto out;
 			}
-			fclose(f);
 			ndctl_set_log_fn(ctx, log_file);
 		}
 	}
@@ -689,5 +676,7 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 
 	rc = monitor_event(ctx, &mfa);
 out:
+	if (monitor.log_file)
+		fclose(monitor.log_file);
 	return rc;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
