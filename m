Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 580CB1A1F45
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 15:37:34 -0800 (PST)
Subject: [ndctl PATCH 5/8] ndctl create-namespace: fall back to blk if no pmem
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 08 Mar 2016 15:36:54 -0800
Message-ID: <20160308233654.18628.7830.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160308233628.18628.13786.stgit@dwillia2-desk3.jf.intel.com>
References: <20160308233628.18628.13786.stgit@dwillia2-desk3.jf.intel.com>
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

Arrange for ndctl create-namespace to search for blk capacity by
default.  This supports a use case of calling 'ndctl create-namespace'
with no options until it returns an error to allocate all the persistent
memory capacity in a system.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 builtin-xaction-namespace.c |   68 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 17 deletions(-)

diff --git a/builtin-xaction-namespace.c b/builtin-xaction-namespace.c
index 28999b3f8311..d83ad91a7258 100644
--- a/builtin-xaction-namespace.c
+++ b/builtin-xaction-namespace.c
@@ -37,6 +37,7 @@
 static bool verbose;
 static bool force;
 static struct parameters {
+	bool do_scan;
 	const char *bus;
 	const char *map;
 	const char *type;
@@ -109,21 +110,9 @@ enum namespace_action {
 	ACTION_CREATE,
 };
 
-/*
- * parse_namespace_options - basic parsing sanity checks before we start
- * looking at actual namespace devices and available resources.
- */
-static const char *parse_namespace_options(int argc, const char **argv,
-		enum namespace_action mode, const struct option *options,
-		char *xable_usage)
+static int set_defaults(void)
 {
-	const char * const u[] = {
-		xable_usage,
-		NULL
-	};
-	int i, rc = 0;
-
-        argc = parse_options(argc, argv, options, u, 0);
+	int rc = 0;
 
 	if (param.type) {
 		if (strcmp(param.type, "pmem") == 0)
@@ -211,6 +200,28 @@ static const char *parse_namespace_options(int argc, const char **argv,
 	} else if (!param.reconfig)
 		param.sector_size = "4096";
 
+	return rc;
+}
+
+/*
+ * parse_namespace_options - basic parsing sanity checks before we start
+ * looking at actual namespace devices and available resources.
+ */
+static const char *parse_namespace_options(int argc, const char **argv,
+		enum namespace_action mode, const struct option *options,
+		char *xable_usage)
+{
+	const char * const u[] = {
+		xable_usage,
+		NULL
+	};
+	int i, rc = 0;
+
+	param.do_scan = argc == 1;
+        argc = parse_options(argc, argv, options, u, 0);
+
+	rc = set_defaults();
+
 	if (argc == 0 && mode != ACTION_CREATE) {
 		error("specify a namespace to %s, or \"all\"\n",
 				mode == ACTION_ENABLE ? "enable" : "disable");
@@ -603,6 +614,8 @@ static int do_xaction_namespace(const char *namespace,
 					rc = 0;
 					continue;
 				}
+				if (rc == 0)
+					rc = 1;
 				goto done;
 			}
 			ndctl_namespace_foreach(region, ndns) {
@@ -619,7 +632,11 @@ static int do_xaction_namespace(const char *namespace,
 					rc = ndctl_namespace_enable(ndns);
 					break;
 				case ACTION_CREATE:
-					return namespace_reconfig(region, ndns);
+					rc = namespace_reconfig(region, ndns);
+					if (rc < 0)
+						goto done;
+					rc = 1;
+					goto done;
 				}
 				if (rc >= 0)
 					success++;
@@ -682,8 +699,25 @@ int cmd_create_namespace(int argc, const char **argv)
 			ACTION_CREATE, create_options, xable_usage);
 	int created = do_xaction_namespace(namespace, ACTION_CREATE);
 
-	if (created < 0)
+	if (created < 1 && param.do_scan) {
+		/*
+		 * In the default scan case we try pmem first and then
+		 * fallback to blk before giving up.
+		 */
+		memset(&param, 0, sizeof(param));
+		param.type = "blk";
+		set_defaults();
+		created = do_xaction_namespace(NULL, ACTION_CREATE);
+	}
+
+	if (created < 0 || (!namespace && created < 1)) {
 		fprintf(stderr, "failed to %s namespace\n", namespace
 				? "reconfigure" : "create");
-	return created;
+		if (!namespace)
+			created = -ENODEV;
+	}
+
+	if (created < 0)
+		return created;
+	return 0;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
