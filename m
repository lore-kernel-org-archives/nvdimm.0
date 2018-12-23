Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ABF9621B02822
 for <linux-nvdimm@lists.01.org>; Sun, 23 Dec 2018 11:08:46 -0800 (PST)
Subject: [ndctl PATCH] ndctl/monitor: Drop 'struct ndctl_ctx *' casts
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 23 Dec 2018 10:56:10 -0800
Message-ID: <154559137045.4076221.14167624874916967075.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Functions that take a 'struct ndctl_ctx *' are fine to take the 'void *'
argument representing a library context that is passed to all commands.
However, the shared logging macros need a defined type to dereference
and retrieve the log_ctx. Introduce _gen_ctx to generically represent
'struct ndctl_ctx *' and 'struct daxctl_ctx *' to the log helpers, and
drop the remaining casts in ndctl/monitor.c. Add a couple BUILD_BUG_ON()
statements to backup the log_ctx expectations.

Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/lib/libdaxctl.c |    4 ++++
 ndctl/lib/libndctl.c   |    4 ++++
 ndctl/monitor.c        |   22 +++++++++++-----------
 util/log.h             |   16 ++++++++++++----
 4 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 22f4210a7ea0..7b233b8d43f1 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -23,6 +23,7 @@
 #include <ccan/array_size/array_size.h>
 
 #include <util/log.h>
+#include <util/util.h>
 #include <util/sysfs.h>
 #include <daxctl/libdaxctl.h>
 #include "libdaxctl-private.h"
@@ -86,6 +87,9 @@ DAXCTL_EXPORT int daxctl_new(struct daxctl_ctx **ctx)
 {
 	struct daxctl_ctx *c;
 
+	/* Sanity check for the expectations of the shared log functions */
+	BUILD_BUG_ON(offsetof(struct daxctl_ctx, ctx) != 0);
+
 	c = calloc(1, sizeof(struct daxctl_ctx));
 	if (!c)
 		return -ENOMEM;
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 0c3a35e5bcc9..77b29454a253 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -31,6 +31,7 @@
 #include <ccan/build_assert/build_assert.h>
 
 #include <ndctl.h>
+#include <util/util.h>
 #include <util/sysfs.h>
 #include <ndctl/libndctl.h>
 #include <ndctl/namespace.h>
@@ -287,6 +288,9 @@ NDCTL_EXPORT int ndctl_new(struct ndctl_ctx **ctx)
 	const char *env;
 	int rc = 0;
 
+	/* Sanity check for the expectations of the shared log functions */
+	BUILD_BUG_ON(offsetof(struct ndctl_ctx, ctx) != 0);
+
 	udev = udev_new();
 	if (check_udev(udev) != 0)
 		return -ENXIO;
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index b92a133b7b94..73d75286e90b 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -623,14 +623,14 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 		usage_with_options(u, options);
 
 	/* default to log_standard */
-	ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_standard);
+	ndctl_set_log_fn(ctx, log_standard);
 
 	if (monitor.verbose)
-		ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_DEBUG);
+		ndctl_set_log_priority(ctx, LOG_DEBUG);
 	else
-		ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_INFO);
+		ndctl_set_log_priority(ctx, LOG_INFO);
 
-	rc = read_config_file((struct ndctl_ctx *)ctx, &monitor, &param);
+	rc = read_config_file(ctx, &monitor, &param);
 	if (rc)
 		goto out;
 
@@ -638,7 +638,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 		if (strncmp(monitor.log, "./", 2) != 0)
 			fix_filename(prefix, (const char **)&monitor.log);
 		if (strncmp(monitor.log, "./syslog", 8) == 0)
-			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
+			ndctl_set_log_fn(ctx, log_syslog);
 		else if (strncmp(monitor.log, "./standard", 10) == 0)
 			; /*default, already set */
 		else {
@@ -649,21 +649,21 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 				goto out;
 			}
 			fclose(f);
-			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_file);
+			ndctl_set_log_fn(ctx, log_file);
 		}
 	}
 
 	if (monitor.daemon) {
 		if (!monitor.log || strncmp(monitor.log, "./", 2) == 0)
-			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
+			ndctl_set_log_fn(ctx, log_syslog);
 		if (daemon(0, 0) != 0) {
-			err((struct ndctl_ctx *)ctx, "daemon start failed\n");
+			err(ctx, "daemon start failed\n");
 			goto out;
 		}
-		info((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
+		info(ctx, "ndctl monitor daemon started\n");
 	}
 
-	if (parse_monitor_event(&monitor, (struct ndctl_ctx *)ctx))
+	if (parse_monitor_event(&monitor, ctx))
 		goto out;
 
 	fctx.filter_bus = filter_bus;
@@ -681,7 +681,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 		goto out;
 
 	if (!mfa.num_dimm) {
-		dbg((struct ndctl_ctx *)ctx, "no dimms to monitor\n");
+		dbg(ctx, "no dimms to monitor\n");
 		if (!monitor.daemon)
 			rc = -ENXIO;
 		goto out;
diff --git a/util/log.h b/util/log.h
index 495e0d33c7f5..881971522690 100644
--- a/util/log.h
+++ b/util/log.h
@@ -56,10 +56,18 @@ do { \
 #  define log_notice(ctx, arg...) log_null(ctx, ## arg)
 #endif
 
-#define dbg(x, arg...) log_dbg(&(x)->ctx, ## arg)
-#define info(x, arg...) log_info(&(x)->ctx, ## arg)
-#define err(x, arg...) log_err(&(x)->ctx, ## arg)
-#define notice(x, arg...) log_notice(&(x)->ctx, ## arg)
+struct _gen_ctx {
+	/*
+	 * Requires ndctl_ctx and daxctl_ctx keep their log_ctx as their
+	 * first element
+	 */
+	struct log_ctx ctx;
+};
+
+#define dbg(x, arg...) log_dbg(&((struct _gen_ctx *)(x))->ctx, ## arg)
+#define info(x, arg...) log_info(&((struct _gen_ctx *)(x))->ctx, ## arg)
+#define err(x, arg...) log_err(&((struct _gen_ctx *)(x))->ctx, ## arg)
+#define notice(x, arg...) log_notice(&((struct _gen_ctx *)(x))->ctx, ## arg)
 
 #ifndef HAVE_SECURE_GETENV
 #  ifdef HAVE___SECURE_GETENV

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
