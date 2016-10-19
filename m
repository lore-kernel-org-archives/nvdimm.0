Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B9E941A1E6E
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 09:51:01 -0700 (PDT)
Subject: [ndctl PATCH 2/8] ndctl: consolidate label commands into a single file
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Oct 2016 09:47:59 -0700
Message-ID: <147689567927.11015.16338248621049060172.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Merge ndctl/builtin-zero-labels.c and ndctl/builtin-read-labels.c into a
single file, but no functional change.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/Makefile.am           |    3 -
 ndctl/builtin-labels.c      |   84 +++++++++++++++++++++++++++++++++++++++
 ndctl/builtin-zero-labels.c |   92 -------------------------------------------
 3 files changed, 84 insertions(+), 95 deletions(-)
 rename ndctl/{builtin-read-labels.c => builtin-labels.c} (83%)
 delete mode 100644 ndctl/builtin-zero-labels.c

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 29237b76713a..dc990988ed43 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -10,8 +10,7 @@ ndctl_SOURCES = ndctl.c \
 		builtin-list.c \
 		builtin-test.c \
 		builtin-help.c \
-		builtin-zero-labels.c \
-		builtin-read-labels.c \
+		builtin-labels.c \
 		util/json.c
 
 if ENABLE_SMART
diff --git a/ndctl/builtin-read-labels.c b/ndctl/builtin-labels.c
similarity index 83%
rename from ndctl/builtin-read-labels.c
rename to ndctl/builtin-labels.c
index 207d44ce7f68..c85069d97655 100644
--- a/ndctl/builtin-read-labels.c
+++ b/ndctl/builtin-labels.c
@@ -1,4 +1,3 @@
-
 /*
  * Copyright (c) 2016, Intel Corporation.
  *
@@ -64,6 +63,89 @@ struct namespace_label {
 	le32 unused;
 };
 
+static int do_zero_dimm(struct ndctl_dimm *dimm, const char **argv, int argc,
+		bool verbose)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	int i, rc, log;
+
+	for (i = 0; i < argc; i++)
+		if (util_dimm_filter(dimm, argv[i]))
+			break;
+	if (i >= argc)
+		return -ENODEV;
+
+	log = ndctl_get_log_priority(ctx);
+	if (verbose)
+		ndctl_set_log_priority(ctx, LOG_DEBUG);
+	rc = ndctl_dimm_zero_labels(dimm);
+	ndctl_set_log_priority(ctx, log);
+
+	return rc;
+}
+
+int cmd_zero_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	const char *nmem_bus = NULL;
+	bool verbose = false;
+	const struct option nmem_options[] = {
+		OPT_STRING('b', "bus", &nmem_bus, "bus-id",
+				"<nmem> must be on a bus with an id/provider of <bus-id>"),
+		OPT_BOOLEAN('v',"verbose", &verbose, "turn on debug"),
+		OPT_END(),
+	};
+	const char * const u[] = {
+		"ndctl zero-labels <nmem0> [<nmem1>..<nmemN>] [<options>]",
+		NULL
+	};
+	struct ndctl_dimm *dimm;
+	struct ndctl_bus *bus;
+	int i, rc, count, err = 0;
+
+        argc = parse_options(argc, argv, nmem_options, u, 0);
+
+	if (argc == 0)
+		usage_with_options(u, nmem_options);
+	for (i = 0; i < argc; i++) {
+		unsigned long id;
+
+		if (strcmp(argv[i], "all") == 0)
+			continue;
+		if (sscanf(argv[i], "nmem%lu", &id) != 1) {
+			fprintf(stderr, "unknown extra parameter \"%s\"\n",
+					argv[i]);
+			usage_with_options(u, nmem_options);
+		}
+	}
+
+	count = 0;
+        ndctl_bus_foreach(ctx, bus) {
+		if (!util_bus_filter(bus, nmem_bus))
+			continue;
+
+		ndctl_dimm_foreach(bus, dimm) {
+			rc = do_zero_dimm(dimm, argv, argc, verbose);
+			if (rc == 0)
+				count++;
+			else if (rc && !err)
+				err = rc;
+		}
+	}
+	rc = err;
+
+	fprintf(stderr, "zeroed %d nmem%s\n", count, count > 1 ? "s" : "");
+
+	/*
+	 * 0 if all dimms zeroed, count if at least 1 dimm zeroed, < 0
+	 * if all errors
+	 */
+	if (rc == 0)
+		return 0;
+	if (count)
+		return count;
+	return rc;
+}
+
 static struct json_object *dump_label_json(struct ndctl_cmd *cmd_read, ssize_t size)
 {
 	struct json_object *jarray = json_object_new_array();
diff --git a/ndctl/builtin-zero-labels.c b/ndctl/builtin-zero-labels.c
deleted file mode 100644
index 2fe466e6ba34..000000000000
--- a/ndctl/builtin-zero-labels.c
+++ /dev/null
@@ -1,92 +0,0 @@
-#include <stdio.h>
-#include <errno.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <limits.h>
-#include <syslog.h>
-#include <util/filter.h>
-#include <util/parse-options.h>
-#include <ndctl/libndctl.h>
-
-static int do_zero_dimm(struct ndctl_dimm *dimm, const char **argv, int argc,
-		bool verbose)
-{
-	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
-	int i, rc, log;
-
-	for (i = 0; i < argc; i++)
-		if (util_dimm_filter(dimm, argv[i]))
-			break;
-	if (i >= argc)
-		return -ENODEV;
-
-	log = ndctl_get_log_priority(ctx);
-	if (verbose)
-		ndctl_set_log_priority(ctx, LOG_DEBUG);
-	rc = ndctl_dimm_zero_labels(dimm);
-	ndctl_set_log_priority(ctx, log);
-
-	return rc;
-}
-
-int cmd_zero_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
-{
-	const char *nmem_bus = NULL;
-	bool verbose = false;
-	const struct option nmem_options[] = {
-		OPT_STRING('b', "bus", &nmem_bus, "bus-id",
-				"<nmem> must be on a bus with an id/provider of <bus-id>"),
-		OPT_BOOLEAN('v',"verbose", &verbose, "turn on debug"),
-		OPT_END(),
-	};
-	const char * const u[] = {
-		"ndctl zero-labels <nmem0> [<nmem1>..<nmemN>] [<options>]",
-		NULL
-	};
-	struct ndctl_dimm *dimm;
-	struct ndctl_bus *bus;
-	int i, rc, count, err = 0;
-
-        argc = parse_options(argc, argv, nmem_options, u, 0);
-
-	if (argc == 0)
-		usage_with_options(u, nmem_options);
-	for (i = 0; i < argc; i++) {
-		unsigned long id;
-
-		if (strcmp(argv[i], "all") == 0)
-			continue;
-		if (sscanf(argv[i], "nmem%lu", &id) != 1) {
-			fprintf(stderr, "unknown extra parameter \"%s\"\n",
-					argv[i]);
-			usage_with_options(u, nmem_options);
-		}
-	}
-
-	count = 0;
-        ndctl_bus_foreach(ctx, bus) {
-		if (!util_bus_filter(bus, nmem_bus))
-			continue;
-
-		ndctl_dimm_foreach(bus, dimm) {
-			rc = do_zero_dimm(dimm, argv, argc, verbose);
-			if (rc == 0)
-				count++;
-			else if (rc && !err)
-				err = rc;
-		}
-	}
-	rc = err;
-
-	fprintf(stderr, "zeroed %d nmem%s\n", count, count > 1 ? "s" : "");
-
-	/*
-	 * 0 if all dimms zeroed, count if at least 1 dimm zeroed, < 0
-	 * if all errors
-	 */
-	if (rc == 0)
-		return 0;
-	if (count)
-		return count;
-	return rc;
-}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
