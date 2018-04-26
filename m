Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 82AD9203B8FF3
 for <linux-nvdimm@lists.01.org>; Thu, 26 Apr 2018 11:17:25 -0700 (PDT)
Subject: [PATCH v3 4/4] ndctl: convert dimm actions to use util_filter_walk()
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 26 Apr 2018 11:17:24 -0700
Message-ID: <152476664464.70161.16388942191624363940.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <152476632250.70161.9698682147434730585.stgit@djiang5-desk3.ch.intel.com>
References: <152476632250.70161.9698682147434730585.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

util_filter_walk() does the looping through of busses and dimms. Removing
duplicate code for dimm actions and provide filter functions so we can
utilize util_filter_walk() and share common code.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/dimm.c  |   83 ++++++++++++++++++++++++++++++++++-----------------------
 util/filter.h |    9 ++++++
 2 files changed, 59 insertions(+), 33 deletions(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 1c168997..f55b5ff0 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -822,7 +822,6 @@ static int action_update(struct ndctl_dimm *dimm, struct action_context *actx)
 }
 
 static struct parameters {
-	const char *bus;
 	const char *outfile;
 	const char *infile;
 	const char *labelversion;
@@ -833,6 +832,8 @@ static struct parameters {
 	.labelversion = "1.1",
 };
 
+struct util_filter_params uf_param;
+
 static int __action_init(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version version, int chk_only)
 {
@@ -899,7 +900,7 @@ static int action_check(struct ndctl_dimm *dimm, struct action_context *actx)
 
 
 #define BASE_OPTIONS() \
-OPT_STRING('b', "bus", &param.bus, "bus-id", \
+OPT_STRING('b', "bus", &uf_param.bus, "bus-id", \
 	"<nmem> must be on a bus with an id/provider of <bus-id>"), \
 OPT_BOOLEAN('v',"verbose", &param.verbose, "turn on debug")
 
@@ -951,18 +952,48 @@ static const struct option init_options[] = {
 	OPT_END(),
 };
 
+static bool filter_bus(struct ndctl_bus *bus, struct util_filter_ctx *ctx)
+{
+	return true;
+}
+
+static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *ctx)
+{
+	struct dimm_filter_arg *dfa = ctx->dimm;
+	int rc;
+
+	if (dfa->action == action_write) {
+		dfa->dimm = dimm;
+		rc = 0;
+	} else
+		rc = dfa->action(dimm, dfa->actx);
+
+	if (rc == 0)
+		dfa->count++;
+	else if (rc && !dfa->rc)
+		dfa->rc = rc;
+}
+
+/* dummy filter function to skip the loop */
+static bool filter_region(struct ndctl_region *region,
+		struct util_filter_ctx *ctx)
+{
+	return false;
+}
+
 static int dimm_action(int argc, const char **argv, void *ctx,
 		int (*action)(struct ndctl_dimm *dimm, struct action_context *actx),
 		const struct option *options, const char *usage)
 {
 	struct action_context actx = { 0 };
-	int i, rc = 0, count = 0, err = 0;
-	struct ndctl_dimm *single = NULL;
+	int i, rc = 0, err = 0;
 	const char * const u[] = {
 		usage,
 		NULL
 	};
 	unsigned long id;
+	struct util_filter_ctx fctx = { 0 };
+	struct dimm_filter_arg dfa = { 0 };
 
         argc = parse_options(argc, argv, options, u, 0);
 
@@ -1039,45 +1070,31 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 		goto out;
 	}
 
+	fctx.filter_bus = filter_bus;
+	fctx.filter_dimm = filter_dimm;
+	fctx.filter_region = filter_region;
+	fctx.dimm = &dfa;
+	dfa.action = action;
+	dfa.actx = &actx;
+
 	rc = 0;
-	err = 0;
-	count = 0;
 	for (i = 0; i < argc; i++) {
-		struct ndctl_dimm *dimm;
-		struct ndctl_bus *bus;
-
 		if (sscanf(argv[i], "nmem%lu", &id) != 1
 				&& strcmp(argv[i], "all") != 0)
 			continue;
 
-		ndctl_bus_foreach(ctx, bus) {
-			if (!util_bus_filter(bus, param.bus))
-				continue;
-			ndctl_dimm_foreach(bus, dimm) {
-				if (!util_dimm_filter(dimm, argv[i]))
-					continue;
-				if (action == action_write) {
-					single = dimm;
-					rc = 0;
-				} else
-					rc = action(dimm, &actx);
-
-				if (rc == 0)
-					count++;
-				else if (rc && !err)
-					err = rc;
-			}
-		}
+		uf_param.dimm = argv[i];
+		rc = util_filter_walk(ctx, &fctx, &uf_param);
 	}
-	rc = err;
+	rc = dfa.rc;
 
 	if (action == action_write) {
-		if (count > 1) {
+		if (dfa.count > 1) {
 			error("write-labels only supports writing a single dimm\n");
 			usage_with_options(u, options);
 			return -EINVAL;
-		} else if (single)
-			rc = action(single, &actx);
+		} else if (dfa.dimm)
+			rc = action(dfa.dimm, &actx);
 	}
 
 	if (actx.jdimms)
@@ -1095,8 +1112,8 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 	 * count if some actions succeeded, 0 if none were attempted,
 	 * negative error code otherwise.
 	 */
-	if (count > 0)
-		return count;
+	if (dfa.count > 0)
+		return dfa.count;
 	return rc;
 }
 
diff --git a/util/filter.h b/util/filter.h
index 6c14a303..3224ef2e 100644
--- a/util/filter.h
+++ b/util/filter.h
@@ -62,6 +62,14 @@ struct region_filter_arg {
 	int rc;
 };
 
+struct dimm_filter_arg {
+	struct action_context *actx;
+	struct ndctl_dimm *dimm;
+	int (*action)(struct ndctl_dimm *dimm, struct action_context *actx);
+	int count;
+	int rc;
+};
+
 /*
  * struct util_filter_ctx - control and callbacks for util_filter_walk()
  * ->filter_bus() and ->filter_region() return bool because the
@@ -81,6 +89,7 @@ struct util_filter_ctx {
 		struct list_filter_arg *list;
 		struct ndns_filter_arg *ndns;
 		struct region_filter_arg *region;
+		struct dimm_filter_arg *dimm;
 	};
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
