Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AB924210FC0D5
 for <linux-nvdimm@lists.01.org>; Wed, 22 Aug 2018 15:23:00 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/2] ndctl, namespace: rework namespace action accounting
Date: Wed, 22 Aug 2018 16:22:49 -0600
Message-Id: <20180822222249.30838-3-vishal.l.verma@intel.com>
In-Reply-To: <20180822222249.30838-1-vishal.l.verma@intel.com>
References: <20180822222249.30838-1-vishal.l.verma@intel.com>
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
Cc: Steve Scargal <steve.scargall@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Make the count calculations consistent for all namespace actions by
introducing a new parameter to do_xaction_namespace() which explicitly
keeps a count of successful operations.

For destroy-namespace, correctly propagate errors so that the above
accounting works as expected. For legacy (labelless or emulated)
namespaces, if we perform a destructive action such as writing zeroes to
the info block area, acccount for them in the destroy count, but
otherwise consider them as 'skipped' since they cannot be truly
'destroyed'.

Cc: Steve Scargall <steve.scargall@intel.com>
Link: https://github.com/pmem/ndctl/issues/41
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/namespace.c | 154 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 82 insertions(+), 72 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 65e8f7c..b6f1230 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -860,6 +860,7 @@ static int namespace_destroy(struct ndctl_region *region,
 	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
 	struct ndctl_dax *dax = ndctl_namespace_get_dax(ndns);
 	struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
+	bool did_zero = false;
 	int rc;
 
 	if (ndctl_region_get_ro(region)) {
@@ -884,13 +885,33 @@ static int namespace_destroy(struct ndctl_region *region,
 		rc = zero_info_block(ndns);
 		if (rc < 0)
 			return rc;
+		if (rc == 0)
+			did_zero = true;
+	}
+
+	switch (ndctl_namespace_get_type(ndns)) {
+        case ND_DEVICE_NAMESPACE_PMEM:
+        case ND_DEVICE_NAMESPACE_BLK:
+		break;
+	default:
+		/*
+		 * for legacy namespaces, we we did any info block
+		 * zeroing, we need "processed" to be incremented
+		 * but otherwise we are skipping in the count
+		 */
+		if (did_zero)
+			rc = 0;
+		else
+			rc = 1;
+		goto out;
 	}
 
 	rc = ndctl_namespace_delete(ndns);
 	if (rc)
 		debug("%s: failed to reclaim\n", devname);
 
-	return 0;
+out:
+	return rc;
 }
 
 static int enable_labels(struct ndctl_region *region)
@@ -987,7 +1008,7 @@ static int namespace_reconfig(struct ndctl_region *region,
 		return rc;
 
 	rc = namespace_destroy(region, ndns);
-	if (rc)
+	if (rc < 0)
 		return rc;
 
 	/* check if we can enable labels on this region */
@@ -1012,13 +1033,16 @@ int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
 		bool repair, bool logfix);
 
 static int do_xaction_namespace(const char *namespace,
-		enum device_action action, struct ndctl_ctx *ctx)
+		enum device_action action, struct ndctl_ctx *ctx,
+		int *processed)
 {
 	struct ndctl_namespace *ndns, *_n;
-	int rc = -ENXIO, success = 0;
 	struct ndctl_region *region;
 	const char *ndns_name;
 	struct ndctl_bus *bus;
+	int rc = -ENXIO;
+
+	*processed = 0;
 
 	if (!namespace && action != ACTION_CREATE)
 		return rc;
@@ -1052,7 +1076,7 @@ static int do_xaction_namespace(const char *namespace,
 				if (rc == -EAGAIN)
 					continue;
 				if (rc == 0)
-					rc = 1;
+					*processed = 1;
 				return rc;
 			}
 			ndctl_namespace_foreach_safe(region, ndns, _n) {
@@ -1064,36 +1088,43 @@ static int do_xaction_namespace(const char *namespace,
 				switch (action) {
 				case ACTION_DISABLE:
 					rc = ndctl_namespace_disable_safe(ndns);
+					if (rc == 0)
+						(*processed)++;
 					break;
 				case ACTION_ENABLE:
 					rc = ndctl_namespace_enable(ndns);
+					if (rc >= 0) {
+						(*processed)++;
+						rc = 0;
+					}
 					break;
 				case ACTION_DESTROY:
 					rc = namespace_destroy(region, ndns);
+					if (rc == 0)
+						(*processed)++;
+					/* return success if skipped */
+					if (rc > 0)
+						rc = 0;
 					break;
 				case ACTION_CHECK:
 					rc = namespace_check(ndns, verbose,
 							force, repair, logfix);
-					if (rc < 0)
-						return rc;
+					if (rc == 0)
+						(*processed)++;
 					break;
 				case ACTION_CREATE:
 					rc = namespace_reconfig(region, ndns);
-					if (rc < 0)
-						return rc;
-					return 1;
+					if (rc == 0)
+						*processed = 1;
+					return rc;
 				default:
 					rc = -EINVAL;
 					break;
 				}
-				if (rc >= 0)
-					success++;
 			}
 		}
 	}
 
-	if (success)
-		return success;
 	return rc;
 }
 
@@ -1102,20 +1133,16 @@ int cmd_disable_namespace(int argc, const char **argv, void *ctx)
 	char *xable_usage = "ndctl disable-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
 			ACTION_DISABLE, base_options, xable_usage);
-	int disabled = do_xaction_namespace(namespace, ACTION_DISABLE, ctx);
+	int disabled, rc;
 
-	if (disabled < 0) {
+	rc = do_xaction_namespace(namespace, ACTION_DISABLE, ctx, &disabled);
+	if (rc < 0)
 		fprintf(stderr, "error disabling namespaces: %s\n",
-				strerror(-disabled));
-		return disabled;
-	} else if (disabled == 0) {
-		fprintf(stderr, "disabled 0 namespaces\n");
-		return -ENXIO;
-	} else {
-		fprintf(stderr, "disabled %d namespace%s\n", disabled,
-				disabled > 1 ? "s" : "");
-		return 0;
-	}
+				strerror(-rc));
+
+	fprintf(stderr, "disabled %d namespace%s\n", disabled,
+			disabled == 1 ? "" : "s");
+	return rc;
 }
 
 int cmd_enable_namespace(int argc, const char **argv, void *ctx)
@@ -1123,20 +1150,15 @@ int cmd_enable_namespace(int argc, const char **argv, void *ctx)
 	char *xable_usage = "ndctl enable-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
 			ACTION_ENABLE, base_options, xable_usage);
-	int enabled = do_xaction_namespace(namespace, ACTION_ENABLE, ctx);
+	int enabled, rc;
 
-	if (enabled < 0) {
+	rc = do_xaction_namespace(namespace, ACTION_ENABLE, ctx, &enabled);
+	if (rc < 0)
 		fprintf(stderr, "error enabling namespaces: %s\n",
-				strerror(-enabled));
-		return enabled;
-	} else if (enabled == 0) {
-		fprintf(stderr, "enabled 0 namespaces\n");
-		return 0;
-	} else {
-		fprintf(stderr, "enabled %d namespace%s\n", enabled,
-				enabled > 1 ? "s" : "");
-		return 0;
-	}
+				strerror(-rc));
+	fprintf(stderr, "enabled %d namespace%s\n", enabled,
+			enabled == 1 ? "" : "s");
+	return rc;
 }
 
 int cmd_create_namespace(int argc, const char **argv, void *ctx)
@@ -1144,9 +1166,10 @@ int cmd_create_namespace(int argc, const char **argv, void *ctx)
 	char *xable_usage = "ndctl create-namespace [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
 			ACTION_CREATE, create_options, xable_usage);
-	int created = do_xaction_namespace(namespace, ACTION_CREATE, ctx);
+	int created, rc;
 
-	if (created < 1 && param.do_scan) {
+	rc = do_xaction_namespace(namespace, ACTION_CREATE, ctx, &created);
+	if (rc < 0 && created < 1 && param.do_scan) {
 		/*
 		 * In the default scan case we try pmem first and then
 		 * fallback to blk before giving up.
@@ -1154,19 +1177,17 @@ int cmd_create_namespace(int argc, const char **argv, void *ctx)
 		memset(&param, 0, sizeof(param));
 		param.type = "blk";
 		set_defaults(ACTION_CREATE);
-		created = do_xaction_namespace(NULL, ACTION_CREATE, ctx);
+		rc = do_xaction_namespace(NULL, ACTION_CREATE, ctx, &created);
 	}
 
-	if (created < 0 || (!namespace && created < 1)) {
+	if (rc < 0 || (!namespace && created < 1)) {
 		fprintf(stderr, "failed to %s namespace: %s\n", namespace
-				? "reconfigure" : "create", strerror(-created));
+				? "reconfigure" : "create", strerror(-rc));
 		if (!namespace)
-			created = -ENODEV;
+			rc = -ENODEV;
 	}
 
-	if (created < 0)
-		return created;
-	return 0;
+	return rc;
 }
 
 int cmd_destroy_namespace(int argc , const char **argv, void *ctx)
@@ -1174,20 +1195,15 @@ int cmd_destroy_namespace(int argc , const char **argv, void *ctx)
 	char *xable_usage = "ndctl destroy-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
 			ACTION_DESTROY, destroy_options, xable_usage);
-	int destroyed = do_xaction_namespace(namespace, ACTION_DESTROY, ctx);
+	int destroyed, rc;
 
-	if (destroyed < 0) {
+	rc = do_xaction_namespace(namespace, ACTION_DESTROY, ctx, &destroyed);
+	if (rc < 0)
 		fprintf(stderr, "error destroying namespaces: %s\n",
-				strerror(-destroyed));
-		return destroyed;
-	} else if (destroyed == 0) {
-		fprintf(stderr, "destroyed 0 namespaces\n");
-		return 0;
-	} else {
-		fprintf(stderr, "destroyed %d namespace%s\n", destroyed,
-				destroyed > 1 ? "s" : "");
-		return 0;
-	}
+				strerror(-rc));
+	fprintf(stderr, "destroyed %d namespace%s\n", destroyed,
+			destroyed == 1 ? "" : "s");
+	return rc;
 }
 
 int cmd_check_namespace(int argc , const char **argv, void *ctx)
@@ -1195,19 +1211,13 @@ int cmd_check_namespace(int argc , const char **argv, void *ctx)
 	char *xable_usage = "ndctl check-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
 			ACTION_CHECK, check_options, xable_usage);
-	int checked;
+	int checked, rc;
 
-	checked = do_xaction_namespace(namespace, ACTION_CHECK, ctx);
-	if (checked < 0) {
+	rc = do_xaction_namespace(namespace, ACTION_CHECK, ctx, &checked);
+	if (rc < 0)
 		fprintf(stderr, "error checking namespaces: %s\n",
-				strerror(-checked));
-		return checked;
-	} else if (checked == 0) {
-		fprintf(stderr, "checked 0 namespaces\n");
-		return 0;
-	} else {
-		fprintf(stderr, "checked %d namespace%s\n", checked,
-				checked > 1 ? "s" : "");
-		return 0;
-	}
+				strerror(-rc));
+	fprintf(stderr, "checked %d namespace%s\n", checked,
+			checked == 1 ? "" : "s");
+	return rc;
 }
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
