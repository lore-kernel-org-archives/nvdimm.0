Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5A6EA2119EF2B
 for <linux-nvdimm@lists.01.org>; Thu, 27 Dec 2018 19:43:08 -0800 (PST)
Subject: [ndctl PATCH 6/7] ndctl/monitor: Drop vasprintf usage
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Dec 2018 19:30:31 -0800
Message-ID: <154596783052.164521.17128650712423131724.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Clean up some unnecessary buffer allocations for printing, when
vfprintf() and vsyslog() can be used directly.

Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/monitor.c |   43 ++++++++-----------------------------------
 1 file changed, 8 insertions(+), 35 deletions(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 8a16c9664e0a..e38a570fe960 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -49,60 +49,33 @@ do { \
 static void log_syslog(struct ndctl_ctx *ctx, int priority, const char *file,
 		int line, const char *fn, const char *format, va_list args)
 {
-	char *buf;
-
-	if (vasprintf(&buf, format, args) < 0) {
-		fail("vasprintf error\n");
-		return;
-	}
-	syslog(priority, "%s", buf);
-
-	free(buf);
-	return;
+	vsyslog(priority, format, args);
 }
 
 static void log_standard(struct ndctl_ctx *ctx, int priority, const char *file,
 		int line, const char *fn, const char *format, va_list args)
 {
-	char *buf;
-
-	if (vasprintf(&buf, format, args) < 0) {
-		fail("vasprintf error\n");
-		return;
-	}
-
 	if (priority == 6)
-		fprintf(stdout, "%s", buf);
+		vfprintf(stdout, format, args);
 	else
-		fprintf(stderr, "%s", buf);
-
-	free(buf);
-	return;
+		vfprintf(stderr, format, args);
 }
 
 static void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
 		int line, const char *fn, const char *format, va_list args)
 {
 	FILE *f = monitor.log_file;
-	char *buf;
-	struct timespec ts;
-	char timestamp[32];
-
-	if (vasprintf(&buf, format, args) < 0) {
-		fail("vasprintf error\n");
-		return;
-	}
 
 	if (priority != LOG_NOTICE) {
+		struct timespec ts;
+
 		clock_gettime(CLOCK_REALTIME, &ts);
-		sprintf(timestamp, "%10ld.%09ld", ts.tv_sec, ts.tv_nsec);
-		fprintf(f, "[%s] [%d] %s", timestamp, getpid(), buf);
+		fprintf(f, "[%10ld.%09ld] [%d] ", ts.tv_sec, ts.tv_nsec, getpid());
+		vfprintf(f, format, args);
 	} else
-		fprintf(f, "%s", buf);
+		vfprintf(f, format, args);
 
 	fflush(f);
-	free(buf);
-	return;
 }
 
 static struct json_object *dimm_event_to_json(struct monitor_dimm *mdimm)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
