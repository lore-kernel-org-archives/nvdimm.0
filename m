Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BCA361
	for <nvdimm@lists.linux.dev>; Thu, 10 Nov 2022 00:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668038873; x=1699574873;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0Kq7b8Z3+KZEttxPX6Z4PVMSmmT8ijpwlx3QuzqVpc0=;
  b=Y/kpF7N3+WQxq9DwpmMGoqzFncmBGSxLg2dwocIVxK6HziYe9JBtaj0J
   vtH2bINvenrCNmPYdADTylrCr/pMpjVt4Gb/qTe6aDjj05D2BCCS5hU6O
   f3HjaAls+mORWjpOXhocJqJ62TkvEqryFMacUTLRE37pMFgC+5SKoCXJV
   w/dul1ujxa3TuqlfA9qiO+55fxX9LwHQHIBZPXxh8u8txUiqDIjdpu+ID
   33C6A96K8F5AZtmGBcmTPKzLNVmPi7LTwXjUBBTPJDc/MB+tofID2bYqP
   wT1Zey4LtNfOHzlQh2IoUUdg2PyDQ1USLUphV3arEWQkg+Uodv4rc5Xm8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="312928041"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="312928041"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 16:07:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="882130216"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="882130216"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 16:07:51 -0800
Subject: [PATCH v5 4/7] ndctl: move common logging functions from
 ndctl/monitor.c to util/log.c
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, rostedt@goodmis.org
Date: Wed, 09 Nov 2022 17:07:51 -0700
Message-ID: 
 <166803887168.145141.3780565277727044591.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166803877747.145141.11853418648969334939.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166803877747.145141.11853418648969334939.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Since cxl/monitor.c will be using same logging functions that
ndctl/monitor.c will be using, move common functions to util/log.c.

Signed-off-by: Dave Jiang <dave.jiang@gmail.com>
---
 ndctl/monitor.c |   41 ++++-------------------------------------
 util/log.c      |   34 ++++++++++++++++++++++++++++++++++
 util/log.h      |    8 +++++++-
 3 files changed, 45 insertions(+), 38 deletions(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 54678d6100b9..89903def63d4 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -33,7 +33,6 @@ static struct monitor {
 	const char *log;
 	const char *configs;
 	const char *dimm_event;
-	FILE *log_file;
 	bool daemon;
 	bool human;
 	bool verbose;
@@ -61,38 +60,6 @@ do { \
 			VERSION, __func__, __LINE__, ##__VA_ARGS__); \
 } while (0)
 
-static void log_syslog(struct log_ctx *ctx, int priority, const char *file,
-		int line, const char *fn, const char *format, va_list args)
-{
-	vsyslog(priority, format, args);
-}
-
-static void log_standard(struct log_ctx *ctx, int priority, const char *file,
-		int line, const char *fn, const char *format, va_list args)
-{
-	if (priority == 6)
-		vfprintf(stdout, format, args);
-	else
-		vfprintf(stderr, format, args);
-}
-
-static void log_file(struct log_ctx *ctx, int priority, const char *file,
-		int line, const char *fn, const char *format, va_list args)
-{
-	FILE *f = monitor.log_file;
-
-	if (priority != LOG_NOTICE) {
-		struct timespec ts;
-
-		clock_gettime(CLOCK_REALTIME, &ts);
-		fprintf(f, "[%10ld.%09ld] [%d] ", ts.tv_sec, ts.tv_nsec, getpid());
-		vfprintf(f, format, args);
-	} else
-		vfprintf(f, format, args);
-
-	fflush(f);
-}
-
 static struct json_object *dimm_event_to_json(struct monitor_dimm *mdimm)
 {
 	struct json_object *jevent, *jobj;
@@ -648,8 +615,8 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 		else if (strncmp(monitor.log, "./standard", 10) == 0)
 			monitor.ctx.log_fn = log_standard;
 		else {
-			monitor.log_file = fopen(monitor.log, "a+");
-			if (!monitor.log_file) {
+			monitor.ctx.log_file = fopen(monitor.log, "a+");
+			if (!monitor.ctx.log_file) {
 				error("open %s failed\n", monitor.log);
 				rc = -errno;
 				goto out;
@@ -694,8 +661,8 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 
 	rc = monitor_event(ctx, &mfa);
 out:
-	if (monitor.log_file)
-		fclose(monitor.log_file);
+	if (monitor.ctx.log_file)
+		fclose(monitor.ctx.log_file);
 	if (path)
 		free(path);
 	return rc;
diff --git a/util/log.c b/util/log.c
index 61ac509f4ac5..d4eef0a1fc5c 100644
--- a/util/log.c
+++ b/util/log.c
@@ -2,11 +2,45 @@
 // Copyright (C) 2016-2020, Intel Corporation. All rights reserved.
 #include <syslog.h>
 #include <stdlib.h>
+#include <unistd.h>
 #include <ctype.h>
 #include <string.h>
 #include <errno.h>
+#include <time.h>
 #include <util/log.h>
 
+void log_syslog(struct log_ctx *ctx, int priority, const char *file, int line,
+		const char *fn, const char *format, va_list args)
+{
+	vsyslog(priority, format, args);
+}
+
+void log_standard(struct log_ctx *ctx, int priority, const char *file, int line,
+		  const char *fn, const char *format, va_list args)
+{
+	if (priority == 6)
+		vfprintf(stdout, format, args);
+	else
+		vfprintf(stderr, format, args);
+}
+
+void log_file(struct log_ctx *ctx, int priority, const char *file, int line,
+	      const char *fn, const char *format, va_list args)
+{
+	FILE *f = ctx->log_file;
+
+	if (priority != LOG_NOTICE) {
+		struct timespec ts;
+
+		clock_gettime(CLOCK_REALTIME, &ts);
+		fprintf(f, "[%10ld.%09ld] [%d] ", ts.tv_sec, ts.tv_nsec,
+			getpid());
+	}
+
+	vfprintf(f, format, args);
+	fflush(f);
+}
+
 void do_log(struct log_ctx *ctx, int priority, const char *file,
 		int line, const char *fn, const char *format, ...)
 {
diff --git a/util/log.h b/util/log.h
index 28f1c7bfcea4..6e09b0dc6494 100644
--- a/util/log.h
+++ b/util/log.h
@@ -14,9 +14,15 @@ struct log_ctx {
 	log_fn log_fn;
 	const char *owner;
 	int log_priority;
+	FILE *log_file;
 };
 
-
+void log_syslog(struct log_ctx *ctx, int priority, const char *file, int line,
+		const char *fn, const char *format, va_list args);
+void log_standard(struct log_ctx *ctx, int priority, const char *file, int line,
+		  const char *fn, const char *format, va_list args);
+void log_file(struct log_ctx *ctx, int priority, const char *file, int line,
+	      const char *fn, const char *format, va_list args);
 void do_log(struct log_ctx *ctx, int priority, const char *file, int line,
 		const char *fn, const char *format, ...)
 	__attribute__((format(printf, 6, 7)));


