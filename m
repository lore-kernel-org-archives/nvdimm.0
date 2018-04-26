Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 28614203B8FF3
 for <linux-nvdimm@lists.01.org>; Thu, 26 Apr 2018 11:17:14 -0700 (PDT)
Subject: [PATCH v3 2/4] ndctl: convert namespace actions to use
 util_filter_walk()
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 26 Apr 2018 11:17:13 -0700
Message-ID: <152476663350.70161.1906714489582336946.stgit@djiang5-desk3.ch.intel.com>
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

util_filter_walk() does the looping through of busses and regions. Removing
duplicate code in namespace ops and provide filter functions so we can
utilize util_filter_walk() and share common code.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/namespace.c |  164 ++++++++++++++++++++++++++++++-----------------------
 test/btt-check.sh |    2 -
 util/filter.c     |    5 +-
 util/filter.h     |    8 +++
 4 files changed, 105 insertions(+), 74 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index e61f500c..d2a4fbaf 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -983,14 +983,92 @@ static int namespace_reconfig(struct ndctl_region *region,
 int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
 		bool repair, bool logfix);
 
+static bool filter_bus(struct ndctl_bus *bus, struct util_filter_ctx *ctx)
+{
+	return true;
+}
+
+static bool filter_region(struct ndctl_region *region,
+		struct util_filter_ctx *ctx)
+{
+	struct ndns_filter_arg *nfa = ctx->ndns;
+	int rc = 0;
+	bool out = true;
+
+	if (nfa->action == ACTION_CREATE && !nfa->namespace) {
+		if (nfa->rc == 1)
+			return false;
+
+		rc = namespace_create(region);
+		if (rc != -EAGAIN) {
+			if (rc == 0)
+				rc = 1;
+			/* don't proceed in the filter loop */
+			out = false;
+		}
+		nfa->rc = rc;
+	}
+
+	return out;
+}
+
+static void filter_namespace(struct ndctl_namespace *ndns,
+		struct util_filter_ctx *ctx)
+{
+	struct ndctl_region *region = ndctl_namespace_get_region(ndns);
+	struct ndns_filter_arg *nfa = ctx->ndns;
+	const char *ndns_name;
+	int rc;
+
+	/* we have an error, don't do anything else */
+	if (nfa->rc < 0)
+		return;
+
+	ndns_name = ndctl_namespace_get_devname(ndns);
+	if (strcmp(nfa->namespace, "all") != 0
+			&& strcmp(nfa->namespace, ndns_name) != 0) {
+		return;
+	}
+
+	switch (nfa->action) {
+	case ACTION_DISABLE:
+		rc = ndctl_namespace_disable_safe(ndns);
+		break;
+	case ACTION_ENABLE:
+		rc = ndctl_namespace_enable(ndns);
+		break;
+	case ACTION_DESTROY:
+		rc = namespace_destroy(region, ndns);
+		break;
+	case ACTION_CHECK:
+		rc = namespace_check(ndns, verbose, force, repair, logfix);
+		if (rc < 0) {
+			nfa->rc = rc;
+			return;
+		}
+		break;
+	case ACTION_CREATE:
+		rc = namespace_reconfig(region, ndns);
+		if (rc < 0) {
+			nfa->rc = rc;
+			return;
+		}
+		break;
+	default:
+		rc = -EINVAL;
+		break;
+	}
+
+	if (rc >= 0)
+		nfa->rc++;
+}
+
 static int do_xaction_namespace(const char *namespace,
 		enum device_action action, struct ndctl_ctx *ctx)
 {
-	struct ndctl_namespace *ndns, *_n;
-	int rc = -ENXIO, success = 0;
-	struct ndctl_region *region;
-	const char *ndns_name;
-	struct ndctl_bus *bus;
+	int rc = -ENXIO;
+	struct util_filter_ctx fctx = { 0 };
+	struct ndns_filter_arg nfa = { 0 };
 
 	if (!namespace && action != ACTION_CREATE)
 		return rc;
@@ -998,74 +1076,18 @@ static int do_xaction_namespace(const char *namespace,
 	if (verbose)
 		ndctl_set_log_priority(ctx, LOG_DEBUG);
 
-        ndctl_bus_foreach(ctx, bus) {
-		if (!util_bus_filter(bus, uf_param.bus))
-			continue;
-
-		ndctl_region_foreach(bus, region) {
-			if (!util_region_filter(region, uf_param.region))
-				continue;
-
-			if (uf_param.type) {
-				if (strcmp(uf_param.type, "pmem") == 0
-						&& ndctl_region_get_type(region)
-						== ND_DEVICE_REGION_PMEM)
-					/* pass */;
-				else if (strcmp(uf_param.type, "blk") == 0
-						&& ndctl_region_get_type(region)
-						== ND_DEVICE_REGION_BLK)
-					/* pass */;
-				else
-					continue;
-			}
+	fctx.filter_bus = filter_bus;
+	fctx.filter_region = filter_region;
+	fctx.filter_namespace = filter_namespace;
+	fctx.ndns = &nfa;
+	fctx.ndns->action = action;
+	fctx.ndns->namespace = namespace;
 
-			if (action == ACTION_CREATE && !namespace) {
-				rc = namespace_create(region);
-				if (rc == -EAGAIN)
-					continue;
-				if (rc == 0)
-					rc = 1;
-				return rc;
-			}
-			ndctl_namespace_foreach_safe(region, ndns, _n) {
-				ndns_name = ndctl_namespace_get_devname(ndns);
-
-				if (strcmp(namespace, "all") != 0
-						&& strcmp(namespace, ndns_name) != 0)
-					continue;
-				switch (action) {
-				case ACTION_DISABLE:
-					rc = ndctl_namespace_disable_safe(ndns);
-					break;
-				case ACTION_ENABLE:
-					rc = ndctl_namespace_enable(ndns);
-					break;
-				case ACTION_DESTROY:
-					rc = namespace_destroy(region, ndns);
-					break;
-				case ACTION_CHECK:
-					rc = namespace_check(ndns, verbose,
-							force, repair, logfix);
-					if (rc < 0)
-						return rc;
-					break;
-				case ACTION_CREATE:
-					rc = namespace_reconfig(region, ndns);
-					if (rc < 0)
-						return rc;
-					return 1;
-				default:
-					rc = -EINVAL;
-					break;
-				}
-				if (rc >= 0)
-					success++;
-			}
-		}
-	}
+	rc = util_filter_walk(ctx, &fctx, &uf_param);
+	if (rc < 0)
+		return rc;
 
-	if (success)
-		return success;
+	rc = nfa.rc;
 	return rc;
 }
 
diff --git a/test/btt-check.sh b/test/btt-check.sh
index 353d4375..50c1b592 100755
--- a/test/btt-check.sh
+++ b/test/btt-check.sh
@@ -1,4 +1,4 @@
-#!/bin/bash -E
+#!/bin/bash -Ex
 
 # Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
 # 
diff --git a/util/filter.c b/util/filter.c
index 0d3cc02f..b7a4fbd6 100644
--- a/util/filter.c
+++ b/util/filter.c
@@ -18,6 +18,7 @@
 #include <sys/stat.h>
 #include <util/util.h>
 #include <sys/types.h>
+#include <ndctl/action.h>
 #include <ndctl/ndctl.h>
 #include <util/filter.h>
 #include <ndctl/libndctl.h>
@@ -418,7 +419,7 @@ int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
 		}
 
 		ndctl_region_foreach(bus, region) {
-			struct ndctl_namespace *ndns;
+			struct ndctl_namespace *ndns, *_n;
 
 			if (!util_region_filter(region, param->region)
 					|| !util_region_filter_by_dimm(region,
@@ -437,7 +438,7 @@ int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
 			if (!fctx->filter_region(region, fctx))
 				continue;
 
-			ndctl_namespace_foreach(region, ndns) {
+			ndctl_namespace_foreach_safe(region, ndns, _n) {
 				enum ndctl_namespace_mode mode;
 
 				if (!fctx->filter_namespace)
diff --git a/util/filter.h b/util/filter.h
index effda24b..ce3336a5 100644
--- a/util/filter.h
+++ b/util/filter.h
@@ -13,6 +13,7 @@
 #ifndef _UTIL_FILTER_H_
 #define _UTIL_FILTER_H_
 #include <stdbool.h>
+#include <ndctl/action.h>
 
 struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *ident);
 struct ndctl_region *util_region_filter(struct ndctl_region *region,
@@ -50,6 +51,12 @@ struct list_filter_arg {
 	unsigned long flags;
 };
 
+struct ndns_filter_arg {
+	enum device_action action;
+	const char *namespace;
+	int rc;
+};
+
 /*
  * struct util_filter_ctx - control and callbacks for util_filter_walk()
  * ->filter_bus() and ->filter_region() return bool because the
@@ -67,6 +74,7 @@ struct util_filter_ctx {
 	union {
 		void *arg;
 		struct list_filter_arg *list;
+		struct ndns_filter_arg *ndns;
 	};
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
