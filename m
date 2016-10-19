Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ABD0C1A1E8D
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 09:51:27 -0700 (PDT)
Subject: [ndctl PATCH 4/8] ndctl: merge {enable,
 disable}-dimm with label commands
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Oct 2016 09:48:09 -0700
Message-ID: <147689568972.11015.17207071929007183833.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Combine builtin-xable-dimm.c and builtin-label.c into builtin-dimm.c to
give glob support to the enable-dimm and disable-dimm commands. The
command calling conventions already share a <DIMM> argument, so for
consistency enable glob support across the set.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/Makefile.am          |    3 -
 ndctl/builtin-dimm.c       |   40 +++++++++++++++
 ndctl/builtin-xable-dimm.c |  115 --------------------------------------------
 3 files changed, 39 insertions(+), 119 deletions(-)
 rename ndctl/{builtin-labels.c => builtin-dimm.c} (90%)
 delete mode 100644 ndctl/builtin-xable-dimm.c

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index dc990988ed43..263a8c4337dd 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -6,11 +6,10 @@ ndctl_SOURCES = ndctl.c \
 		builtin-create-nfit.c \
 		builtin-xaction-namespace.c \
 		builtin-xable-region.c \
-		builtin-xable-dimm.c \
+		builtin-dimm.c \
 		builtin-list.c \
 		builtin-test.c \
 		builtin-help.c \
-		builtin-labels.c \
 		util/json.c
 
 if ENABLE_SMART
diff --git a/ndctl/builtin-labels.c b/ndctl/builtin-dimm.c
similarity index 90%
rename from ndctl/builtin-labels.c
rename to ndctl/builtin-dimm.c
index ddd3eb578341..6d0c343a29e3 100644
--- a/ndctl/builtin-labels.c
+++ b/ndctl/builtin-dimm.c
@@ -70,6 +70,22 @@ struct action_context {
 	FILE *f_out;
 };
 
+static int action_disable(struct ndctl_dimm *dimm, struct action_context *actx)
+{
+	if (ndctl_dimm_is_active(dimm)) {
+		fprintf(stderr, "%s is active, skipping...\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EBUSY;
+	}
+
+	return ndctl_dimm_disable(dimm);
+}
+
+static int action_enable(struct ndctl_dimm *dimm, struct action_context *actx)
+{
+	return ndctl_dimm_enable(dimm);
+}
+
 static int action_zero(struct ndctl_dimm *dimm, struct action_context *actx)
 {
 	return ndctl_dimm_zero_labels(dimm);
@@ -335,7 +351,7 @@ static const struct option read_options[] = {
 	OPT_END(),
 };
 
-static const struct option zero_options[] = {
+static const struct option base_options[] = {
 	BASE_OPTIONS(),
 	OPT_END(),
 };
@@ -496,10 +512,30 @@ int cmd_read_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
 
 int cmd_zero_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
-	int count = dimm_action(argc, argv, ctx, action_zero, zero_options,
+	int count = dimm_action(argc, argv, ctx, action_zero, base_options,
 			"ndctl zero-labels <nmem0> [<nmem1>..<nmemN>] [<options>]");
 
 	fprintf(stderr, "zeroed %d nmem%s\n", count >= 0 ? count : 0,
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_disable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_disable, base_options,
+			"ndctl disable-dimm <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "disabled %d nmem%s\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
+
+int cmd_enable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_enable, base_options,
+			"ndctl enable-dimm <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "enabled %d nmem%s\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/ndctl/builtin-xable-dimm.c b/ndctl/builtin-xable-dimm.c
deleted file mode 100644
index f0d298837aeb..000000000000
--- a/ndctl/builtin-xable-dimm.c
+++ /dev/null
@@ -1,115 +0,0 @@
-#include <stdio.h>
-#include <errno.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <util/filter.h>
-#include <util/parse-options.h>
-#include <ndctl/libndctl.h>
-
-static const char *dimm_bus;
-
-static const struct option dimm_options[] = {
-	OPT_STRING('b', "bus", &dimm_bus, "bus-id",
-			"<dimm> must be on a bus with an id/provider of <bus-id>"),
-	OPT_END(),
-};
-
-static const char *parse_dimm_options(int argc, const char **argv,
-		char *xable_usage)
-{
-	const char * const u[] = {
-		xable_usage,
-		NULL
-	};
-	int i;
-
-        argc = parse_options(argc, argv, dimm_options, u, 0);
-
-	if (argc == 0)
-		error("specify a dimm to disable, or \"all\"\n");
-	for (i = 1; i < argc; i++)
-		error("unknown extra parameter \"%s\"\n", argv[i]);
-	if (argc == 0 || argc > 1) {
-		usage_with_options(u, dimm_options);
-		return NULL; /* we won't return from usage_with_options() */
-	}
-	return argv[0];
-}
-
-static int do_xable_dimm(const char *dimm_arg,
-		int (*xable_fn)(struct ndctl_dimm *), struct ndctl_ctx *ctx)
-{
-	int rc = -ENXIO, skip = 0, success = 0;
-	struct ndctl_dimm *dimm;
-	struct ndctl_bus *bus;
-
-	if (!dimm_arg)
-		goto out;
-
-        ndctl_bus_foreach(ctx, bus) {
-		if (!util_bus_filter(bus, dimm_bus))
-			continue;
-
-		ndctl_dimm_foreach(bus, dimm) {
-			if (!util_dimm_filter(dimm, dimm_arg))
-				continue;
-			if (xable_fn == ndctl_dimm_disable
-					&& ndctl_dimm_is_active(dimm)) {
-				fprintf(stderr, "%s is active, skipping...\n",
-						ndctl_dimm_get_devname(dimm));
-				skip++;
-				continue;
-			}
-			if (xable_fn(dimm) == 0)
-				success++;
-		}
-	}
-
-	rc = success;
-	if (!success && skip)
-		rc = -EBUSY;
- out:
-	dimm_bus = NULL;
-	return rc;
-}
-
-int cmd_disable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx)
-{
-	char *xable_usage = "ndctl disable-dimm <dimm> [<options>]";
-	const char *dimm = parse_dimm_options(argc, argv, xable_usage);
-	int disabled = do_xable_dimm(dimm, ndctl_dimm_disable,
-			ctx);
-
-	if (disabled < 0) {
-		fprintf(stderr, "error disabling dimms: %s\n",
-				strerror(-disabled));
-		return disabled;
-	} else if (disabled == 0) {
-		fprintf(stderr, "disabled 0 dimms\n");
-		return 0;
-	} else {
-		fprintf(stderr, "disabled %d dimm%s\n", disabled,
-				disabled > 1 ? "s" : "");
-		return 0;
-	}
-}
-
-int cmd_enable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx)
-{
-	char *xable_usage = "ndctl enable-dimm <dimm> [<options>]";
-	const char *dimm = parse_dimm_options(argc, argv, xable_usage);
-	int enabled = do_xable_dimm(dimm, ndctl_dimm_enable, ctx);
-
-	if (enabled < 0) {
-		fprintf(stderr, "error enabling dimms: %s\n",
-				strerror(-enabled));
-		return enabled;
-	} else if (enabled == 0) {
-		fprintf(stderr, "enabled 0 dimms\n");
-		return 0;
-	} else {
-		fprintf(stderr, "enabled %d dimm%s\n", enabled,
-				enabled > 1 ? "s" : "");
-		return 0;
-	}
-}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
