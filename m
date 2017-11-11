Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C272D20359A86
 for <linux-nvdimm@lists.01.org>; Sat, 11 Nov 2017 16:04:01 -0800 (PST)
Subject: [ndctl PATCH] ndctl, disable-region: check for mounted namespaces
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 11 Nov 2017 15:59:50 -0800
Message-ID: <151044479034.16188.1848810831483422153.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Perform a ndctl_namespace_disable_safe loop to disable a region to make
sure we are not ripping out a namespace from underneath an actively
mounted filesystem.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/action.h    |   15 +++++++++++++++
 ndctl/namespace.c |   15 ++++-----------
 ndctl/region.c    |   36 ++++++++++++++++++++++++++++++------
 3 files changed, 49 insertions(+), 17 deletions(-)
 create mode 100644 ndctl/action.h

diff --git a/ndctl/action.h b/ndctl/action.h
new file mode 100644
index 000000000000..43ea62adbcd2
--- /dev/null
+++ b/ndctl/action.h
@@ -0,0 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * SPDX-License-Identifier: GPL-2.0
+ */
+#ifndef __NDCTL_ACTION_H__
+#define __NDCTL_ACTION_H__
+enum device_action {
+	ACTION_ENABLE,
+	ACTION_DISABLE,
+	ACTION_CREATE,
+	ACTION_DESTROY,
+	ACTION_CHECK,
+};
+#endif /* __NDCTL_ACTION_H__ */
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index b780924ecf4c..58f23ad0877a 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -17,6 +17,7 @@
 #include <unistd.h>
 #include <limits.h>
 #include <syslog.h>
+#include "action.h"
 #include <sys/stat.h>
 #include <uuid/uuid.h>
 #include <sys/types.h>
@@ -146,15 +147,7 @@ static const struct option check_options[] = {
 	OPT_END(),
 };
 
-enum namespace_action {
-	ACTION_ENABLE,
-	ACTION_DISABLE,
-	ACTION_CREATE,
-	ACTION_DESTROY,
-	ACTION_CHECK,
-};
-
-static int set_defaults(enum namespace_action mode)
+static int set_defaults(enum device_action mode)
 {
 	int rc = 0;
 
@@ -264,7 +257,7 @@ static int set_defaults(enum namespace_action mode)
  * looking at actual namespace devices and available resources.
  */
 static const char *parse_namespace_options(int argc, const char **argv,
-		enum namespace_action mode, const struct option *options,
+		enum device_action mode, const struct option *options,
 		char *xable_usage)
 {
 	const char * const u[] = {
@@ -989,7 +982,7 @@ int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
 		bool repair);
 
 static int do_xaction_namespace(const char *namespace,
-		enum namespace_action action, struct ndctl_ctx *ctx)
+		enum device_action action, struct ndctl_ctx *ctx)
 {
 	struct ndctl_namespace *ndns, *_n;
 	int rc = -ENXIO, success = 0;
diff --git a/ndctl/region.c b/ndctl/region.c
index cc3c133c3190..1402a7548be8 100644
--- a/ndctl/region.c
+++ b/ndctl/region.c
@@ -14,6 +14,7 @@
 #include <errno.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include "action.h"
 #include <util/filter.h>
 #include <util/parse-options.h>
 #include <ndctl/libndctl.h>
@@ -67,8 +68,32 @@ static const char *parse_region_options(int argc, const char **argv,
 	return argv[0];
 }
 
-static int do_xable_region(const char *region_arg,
-		int (*xable_fn)(struct ndctl_region *), struct ndctl_ctx *ctx)
+static int region_action(struct ndctl_region *region, enum device_action mode)
+{
+	struct ndctl_namespace *ndns;
+	int rc = 0;
+
+	switch (mode) {
+	case ACTION_ENABLE:
+		rc = ndctl_region_enable(region);
+		break;
+	case ACTION_DISABLE:
+		ndctl_namespace_foreach(region, ndns) {
+			rc = ndctl_namespace_disable_safe(ndns);
+			if (rc)
+				return rc;
+		}
+		rc = ndctl_region_disable_invalidate(region);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int do_xable_region(const char *region_arg, enum device_action mode,
+		struct ndctl_ctx *ctx)
 {
 	int rc = -ENXIO, success = 0;
 	struct ndctl_region *region;
@@ -88,7 +113,7 @@ static int do_xable_region(const char *region_arg,
 				continue;
 			if (!util_region_filter(region, region_arg))
 				continue;
-			if (xable_fn(region) == 0)
+			if (region_action(region, mode) == 0)
 				success++;
 		}
 	}
@@ -103,8 +128,7 @@ int cmd_disable_region(int argc, const char **argv, void *ctx)
 {
 	char *xable_usage = "ndctl disable-region <region> [<options>]";
 	const char *region = parse_region_options(argc, argv, xable_usage);
-	int disabled = do_xable_region(region, ndctl_region_disable_invalidate,
-			ctx);
+	int disabled = do_xable_region(region, ACTION_DISABLE, ctx);
 
 	if (disabled < 0) {
 		fprintf(stderr, "error disabling regions: %s\n",
@@ -124,7 +148,7 @@ int cmd_enable_region(int argc, const char **argv, void *ctx)
 {
 	char *xable_usage = "ndctl enable-region <region> [<options>]";
 	const char *region = parse_region_options(argc, argv, xable_usage);
-	int enabled = do_xable_region(region, ndctl_region_enable, ctx);
+	int enabled = do_xable_region(region, ACTION_ENABLE, ctx);
 
 	if (enabled < 0) {
 		fprintf(stderr, "error enabling regions: %s\n",

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
