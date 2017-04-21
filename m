Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 645492195406F
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 00:12:43 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id m34so8478954oik.2
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 00:12:43 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH 2/3] ndctl, create-namespace: read default alignment from sysfs
Date: Fri, 21 Apr 2017 17:12:18 +1000
Message-Id: <20170421071219.18744-2-oohall@gmail.com>
In-Reply-To: <20170421071219.18744-1-oohall@gmail.com>
References: <20170421071219.18744-1-oohall@gmail.com>
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

Read the default alignment from the hpage_pmd_size in sysfs. On PPC the
PMD size depends on the MMU being used. When the traditional hash MMU is
used (P9 and earlier) the PMD size is 16MB while the newer radix MMU
uses a 2MB PMD size. The choice of MMU is done at runtime depending on
what the hardware supports so we need to detect this at runtime rather
than hardcoding it.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 ndctl/Makefile.am                 |  3 ++-
 ndctl/builtin-xaction-namespace.c | 41 +++++++++++++++++++++++++++++----------
 2 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index c563e9411cc3..6d565c643efd 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -10,7 +10,8 @@ ndctl_SOURCES = ndctl.c \
 		 ../util/log.c \
 		builtin-list.c \
 		builtin-test.c \
-		../util/json.c
+		../util/json.c \
+		../util/sysfs.c
 
 if ENABLE_SMART
 ndctl_SOURCES += util/json-smart.c
diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index d6c38dc15984..713a95987d91 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -22,6 +22,7 @@
 #include <sys/types.h>
 #include <util/size.h>
 #include <util/json.h>
+#include <util/sysfs.h>
 #include <json-c/json.h>
 #include <util/filter.h>
 #include <ndctl/libndctl.h>
@@ -54,6 +55,8 @@ static struct parameters {
 	const char *align;
 } param;
 
+char default_align_buf[SYSFS_ATTR_SIZE];
+
 void builtin_xaction_namespace_reset(void)
 {
 	/*
@@ -137,7 +140,24 @@ enum namespace_action {
 	ACTION_DESTROY,
 };
 
-static int set_defaults(enum namespace_action mode)
+const char *sysfs_read_default_align(struct ndctl_ctx *ctx, const char *def,
+		const char *path)
+{
+	/*
+	 * HACK: The command handlers aren't supposed to write into
+	 *       the ndctl command context, but we want the debug
+	 *       output to go somewhere sensible.
+	 */
+	if (__sysfs_read_attr((struct log_ctx *)ctx, path, default_align_buf))
+		return strdup(def);
+
+	if (!strlen(default_align_buf))
+		return def;
+
+	return default_align_buf;
+}
+
+static int set_defaults(enum namespace_action mode, struct ndctl_ctx *ctx)
 {
 	int rc = 0;
 
@@ -213,7 +233,8 @@ static int set_defaults(enum namespace_action mode)
 				param.align);
 		rc = -EINVAL;
 	} else if (!param.align) {
-		param.align = "2M";
+		param.align = sysfs_read_default_align(ctx, "2M",
+			"/sys/kernel/mm/transparent_hugepage/hpage_pmd_size");
 		param.align_default = true;
 	}
 
@@ -254,7 +275,7 @@ static int set_defaults(enum namespace_action mode)
  */
 static const char *parse_namespace_options(int argc, const char **argv,
 		enum namespace_action mode, const struct option *options,
-		char *xable_usage)
+		char *xable_usage, struct ndctl_ctx *ctx)
 {
 	const char * const u[] = {
 		xable_usage,
@@ -265,7 +286,7 @@ static const char *parse_namespace_options(int argc, const char **argv,
 	param.do_scan = argc == 1;
         argc = parse_options(argc, argv, options, u, 0);
 
-	rc = set_defaults(mode);
+	rc = set_defaults(mode, ctx);
 
 	if (argc == 0 && mode != ACTION_CREATE) {
 		error("specify a namespace to %s, or \"all\"\n",
@@ -397,7 +418,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 		struct ndctl_namespace *ndns, struct parsed_parameters *p)
 {
 	const char *region_name = ndctl_region_get_devname(region);
-	unsigned long long size_align, units = 1;
+	unsigned long long size_align = 1, units = 1;
 	unsigned int ways;
 	int rc = 0;
 
@@ -900,7 +921,7 @@ int cmd_disable_namespace(int argc, const char **argv, void *ctx)
 {
 	char *xable_usage = "ndctl disable-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
-			ACTION_DISABLE, base_options, xable_usage);
+			ACTION_DISABLE, base_options, xable_usage, ctx);
 	int disabled = do_xaction_namespace(namespace, ACTION_DISABLE, ctx);
 
 	if (disabled < 0) {
@@ -921,7 +942,7 @@ int cmd_enable_namespace(int argc, const char **argv, void *ctx)
 {
 	char *xable_usage = "ndctl enable-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
-			ACTION_ENABLE, base_options, xable_usage);
+			ACTION_ENABLE, base_options, xable_usage, ctx);
 	int enabled = do_xaction_namespace(namespace, ACTION_ENABLE, ctx);
 
 	if (enabled < 0) {
@@ -942,7 +963,7 @@ int cmd_create_namespace(int argc, const char **argv, void *ctx)
 {
 	char *xable_usage = "ndctl create-namespace [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
-			ACTION_CREATE, create_options, xable_usage);
+			ACTION_CREATE, create_options, xable_usage, ctx);
 	int created = do_xaction_namespace(namespace, ACTION_CREATE, ctx);
 
 	if (created < 1 && param.do_scan) {
@@ -952,7 +973,7 @@ int cmd_create_namespace(int argc, const char **argv, void *ctx)
 		 */
 		memset(&param, 0, sizeof(param));
 		param.type = "blk";
-		set_defaults(ACTION_CREATE);
+		set_defaults(ACTION_CREATE, ctx);
 		created = do_xaction_namespace(NULL, ACTION_CREATE, ctx);
 	}
 
@@ -981,7 +1002,7 @@ int cmd_destroy_namespace(int argc , const char **argv, void *ctx)
 {
 	char *xable_usage = "ndctl destroy-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
-			ACTION_DESTROY, destroy_options, xable_usage);
+			ACTION_DESTROY, destroy_options, xable_usage, ctx);
 	int destroyed = do_xaction_namespace(namespace, ACTION_DESTROY, ctx);
 
 	if (destroyed < 0) {
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
