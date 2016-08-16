Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 286481A1E15
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 10:23:57 -0700 (PDT)
Subject: [ndctl PATCH 1/8] ndctl: centralize libndctl context init across
 commands
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Aug 2016 10:21:32 -0700
Message-ID: <147136809208.27902.16635786074472545016.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147136808681.27902.14029119240021638000.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147136808681.27902.14029119240021638000.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Each command currently establishes its own libndctl context. This is
redundant and prevents unit test scenarios where we examine the state of
the context after command execution. Move context init to be external to
each command.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-bat.c               |    6 +++---
 ndctl/builtin-create-nfit.c       |    3 ++-
 ndctl/builtin-help.c              |    2 +-
 ndctl/builtin-list.c              |    9 ++-------
 ndctl/builtin-read-labels.c       |    9 +--------
 ndctl/builtin-test.c              |    8 ++++----
 ndctl/builtin-xable-region.c      |   17 ++++++-----------
 ndctl/builtin-xaction-namespace.c |   34 +++++++++++++---------------------
 ndctl/builtin-zero-labels.c       |    9 +--------
 ndctl/builtin.h                   |   29 +++++++++++++++--------------
 ndctl/ndctl.c                     |   17 ++++++++++++++---
 test.h                            |   13 +++++++------
 test/blk_namespaces.c             |   24 ++++++++++++------------
 test/dpa-alloc.c                  |   19 +++++++++----------
 test/libndctl.c                   |   18 ++++++++----------
 test/parent-uuid.c                |   19 +++++++++----------
 test/pmem_namespaces.c            |   22 +++++++++++-----------
 17 files changed, 118 insertions(+), 140 deletions(-)

diff --git a/ndctl/builtin-bat.c b/ndctl/builtin-bat.c
index a83eb0fec063..48b41dab6d92 100644
--- a/ndctl/builtin-bat.c
+++ b/ndctl/builtin-bat.c
@@ -4,7 +4,7 @@
 #include <limits.h>
 #include <util/parse-options.h>
 
-int cmd_bat(int argc, const char **argv)
+int cmd_bat(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	int loglevel = LOG_DEBUG, i, rc;
 	struct ndctl_test *test;
@@ -39,12 +39,12 @@ int cmd_bat(int argc, const char **argv)
 		return EXIT_FAILURE;
 	}
 
-	rc = test_blk_namespaces(loglevel, test);
+	rc = test_blk_namespaces(loglevel, test, ctx);
 	fprintf(stderr, "test_blk_namespaces: %s\n", rc ? "FAIL" : "PASS");
 	if (rc && rc != 77)
 		return rc;
 
-	rc = test_pmem_namespaces(loglevel, test);
+	rc = test_pmem_namespaces(loglevel, test, ctx);
 	fprintf(stderr, "test_pmem_namespaces: %s\n", rc ? "FAIL" : "PASS");
 	return ndctl_test_result(test, rc);
 }
diff --git a/ndctl/builtin-create-nfit.c b/ndctl/builtin-create-nfit.c
index fad6b9a4b65d..780bb84580f5 100644
--- a/ndctl/builtin-create-nfit.c
+++ b/ndctl/builtin-create-nfit.c
@@ -163,7 +163,8 @@ static int write_nfit(struct nfit *nfit, const char *file, int force)
 	return rc;
 }
 
-int cmd_create_nfit(int argc, const char **argv)
+struct ndctl_ctx;
+int cmd_create_nfit(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	int i, rc = -ENXIO, force = 0;
 	const char * const u[] = {
diff --git a/ndctl/builtin-help.c b/ndctl/builtin-help.c
index 55d3114c4bf8..14ad9d5738d0 100644
--- a/ndctl/builtin-help.c
+++ b/ndctl/builtin-help.c
@@ -137,7 +137,7 @@ static int show_man_page(const char *ndctl_cmd)
 	return -1;
 }
 
-int cmd_help(int argc, const char **argv)
+int cmd_help(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	const char * const builtin_help_subcommands[] = {
 		"enable-region", "disable-region", "zero-labels",
diff --git a/ndctl/builtin-list.c b/ndctl/builtin-list.c
index 0875ca95cd14..1486cb1dedc3 100644
--- a/ndctl/builtin-list.c
+++ b/ndctl/builtin-list.c
@@ -188,7 +188,7 @@ static int num_list_flags(void)
 	return list.buses + list.dimms + list.regions + list.namespaces;
 }
 
-int cmd_list(int argc, const char **argv)
+int cmd_list(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	const struct option options[] = {
 		OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
@@ -218,10 +218,9 @@ int cmd_list(int argc, const char **argv)
 	struct json_object *jregions = NULL;
 	struct json_object *jdimms = NULL;
 	struct json_object *jbuses = NULL;
-	struct ndctl_ctx *ctx;
 	struct ndctl_bus *bus;
 	unsigned int type = 0;
-	int i, rc;
+	int i;
 
         argc = parse_options(argc, argv, options, u, 0);
 	for (i = 0; i < argc; i++)
@@ -252,10 +251,6 @@ int cmd_list(int argc, const char **argv)
 			type = ND_DEVICE_REGION_BLK;
 	}
 
-	rc = ndctl_new(&ctx);
-	if (rc < 0)
-		return rc;
-
 	ndctl_bus_foreach(ctx, bus) {
 		struct json_object *jbus = NULL;
 		struct ndctl_region *region;
diff --git a/ndctl/builtin-read-labels.c b/ndctl/builtin-read-labels.c
index 9dd90c92304e..207d44ce7f68 100644
--- a/ndctl/builtin-read-labels.c
+++ b/ndctl/builtin-read-labels.c
@@ -315,7 +315,7 @@ static int do_read_dimm(FILE *f_out, struct ndctl_dimm *dimm, const char **argv,
 	return rc;
 }
 
-int cmd_read_labels(int argc, const char **argv)
+int cmd_read_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	const char *nmem_bus = NULL, *output = NULL;
 	bool verbose = false, json = false;
@@ -334,7 +334,6 @@ int cmd_read_labels(int argc, const char **argv)
 	};
 	struct json_object *jdimms = NULL;
 	struct ndctl_dimm *dimm;
-	struct ndctl_ctx *ctx;
 	struct ndctl_bus *bus;
 	int i, rc, count = 0, err = 0;
 	FILE *f_out = NULL;
@@ -373,10 +372,6 @@ int cmd_read_labels(int argc, const char **argv)
 		}
 	}
 
-	rc = ndctl_new(&ctx);
-	if (rc < 0)
-		goto out;
-
         ndctl_bus_foreach(ctx, bus) {
 		if (!util_bus_filter(bus, nmem_bus))
 			continue;
@@ -396,8 +391,6 @@ int cmd_read_labels(int argc, const char **argv)
 
 	fprintf(stderr, "read %d nmem%s\n", count, count > 1 ? "s" : "");
 
-	ndctl_unref(ctx);
-
  out:
 	if (jdimms) {
 		util_display_json_array(f_out, jdimms, JSON_C_TO_STRING_PRETTY);
diff --git a/ndctl/builtin-test.c b/ndctl/builtin-test.c
index 9c3b7a827128..d9c5b0f28d6e 100644
--- a/ndctl/builtin-test.c
+++ b/ndctl/builtin-test.c
@@ -14,7 +14,7 @@ static char *result(int rc)
 		return "PASS";
 }
 
-int cmd_test(int argc, const char **argv)
+int cmd_test(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	struct ndctl_test *test;
 	int loglevel = LOG_DEBUG, i, rc;
@@ -44,17 +44,17 @@ int cmd_test(int argc, const char **argv)
 	else
 		test = ndctl_test_new(0);
 
-	rc = test_libndctl(loglevel, test);
+	rc = test_libndctl(loglevel, test, ctx);
 	fprintf(stderr, "test-libndctl: %s\n", result(rc));
 	if (rc && rc != 77)
 		return rc;
 
-	rc = test_dpa_alloc(loglevel, test);
+	rc = test_dpa_alloc(loglevel, test, ctx);
 	fprintf(stderr, "test-dpa-alloc: %s\n", result(rc));
 	if (rc && rc != 77)
 		return rc;
 
-	rc = test_parent_uuid(loglevel, test);
+	rc = test_parent_uuid(loglevel, test, ctx);
 	fprintf(stderr, "test-parent-uuid: %s\n", result(rc));
 
 	return ndctl_test_result(test, rc);
diff --git a/ndctl/builtin-xable-region.c b/ndctl/builtin-xable-region.c
index 1de1e97634cf..41f465a4543f 100644
--- a/ndctl/builtin-xable-region.c
+++ b/ndctl/builtin-xable-region.c
@@ -37,20 +37,15 @@ static const char *parse_region_options(int argc, const char **argv,
 }
 
 static int do_xable_region(const char *region_arg,
-		int (*xable_fn)(struct ndctl_region *))
+		int (*xable_fn)(struct ndctl_region *), struct ndctl_ctx *ctx)
 {
 	int rc = -ENXIO, success = 0;
 	struct ndctl_region *region;
-	struct ndctl_ctx *ctx;
 	struct ndctl_bus *bus;
 
 	if (!region_arg)
 		goto out;
 
-	rc = ndctl_new(&ctx);
-	if (rc < 0)
-		goto out;
-
         ndctl_bus_foreach(ctx, bus) {
 		if (!util_bus_filter(bus, region_bus))
 			continue;
@@ -64,17 +59,17 @@ static int do_xable_region(const char *region_arg,
 	}
 
 	rc = success;
-	ndctl_unref(ctx);
  out:
 	region_bus = NULL;
 	return rc;
 }
 
-int cmd_disable_region(int argc, const char **argv)
+int cmd_disable_region(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	char *xable_usage = "ndctl disable-region <region> [<options>]";
 	const char *region = parse_region_options(argc, argv, xable_usage);
-	int disabled = do_xable_region(region, ndctl_region_disable_invalidate);
+	int disabled = do_xable_region(region, ndctl_region_disable_invalidate,
+			ctx);
 
 	if (disabled < 0) {
 		fprintf(stderr, "error disabling regions: %s\n",
@@ -90,11 +85,11 @@ int cmd_disable_region(int argc, const char **argv)
 	}
 }
 
-int cmd_enable_region(int argc, const char **argv)
+int cmd_enable_region(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	char *xable_usage = "ndctl enable-region <region> [<options>]";
 	const char *region = parse_region_options(argc, argv, xable_usage);
-	int enabled = do_xable_region(region, ndctl_region_enable);
+	int enabled = do_xable_region(region, ndctl_region_enable, ctx);
 
 	if (enabled < 0) {
 		fprintf(stderr, "error enabling regions: %s\n",
diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 9c7a64ef38d9..12ade241ff64 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -684,22 +684,17 @@ static int namespace_reconfig(struct ndctl_region *region,
 }
 
 static int do_xaction_namespace(const char *namespace,
-		enum namespace_action action)
+		enum namespace_action action, struct ndctl_ctx *ctx)
 {
 	struct ndctl_namespace *ndns, *_n;
 	int rc = -ENXIO, success = 0;
 	struct ndctl_region *region;
 	const char *ndns_name;
-	struct ndctl_ctx *ctx;
 	struct ndctl_bus *bus;
 
 	if (!namespace && action != ACTION_CREATE)
 		return rc;
 
-	rc = ndctl_new(&ctx);
-	if (rc < 0)
-		return rc;
-
 	if (verbose)
 		ndctl_set_log_priority(ctx, LOG_DEBUG);
 
@@ -732,7 +727,7 @@ static int do_xaction_namespace(const char *namespace,
 				}
 				if (rc == 0)
 					rc = 1;
-				goto done;
+				return rc;
 			}
 			ndctl_namespace_foreach_safe(region, ndns, _n) {
 				ndns_name = ndctl_namespace_get_devname(ndns);
@@ -753,9 +748,8 @@ static int do_xaction_namespace(const char *namespace,
 				case ACTION_CREATE:
 					rc = namespace_reconfig(region, ndns);
 					if (rc < 0)
-						goto done;
-					rc = 1;
-					goto done;
+						return rc;
+					return 1;
 				}
 				if (rc >= 0)
 					success++;
@@ -764,17 +758,15 @@ static int do_xaction_namespace(const char *namespace,
 	}
 
 	rc = success;
- done:
-	ndctl_unref(ctx);
 	return rc;
 }
 
-int cmd_disable_namespace(int argc, const char **argv)
+int cmd_disable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	char *xable_usage = "ndctl disable-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
 			ACTION_DISABLE, base_options, xable_usage);
-	int disabled = do_xaction_namespace(namespace, ACTION_DISABLE);
+	int disabled = do_xaction_namespace(namespace, ACTION_DISABLE, ctx);
 
 	if (disabled < 0) {
 		fprintf(stderr, "error disabling namespaces: %s\n",
@@ -790,12 +782,12 @@ int cmd_disable_namespace(int argc, const char **argv)
 	}
 }
 
-int cmd_enable_namespace(int argc, const char **argv)
+int cmd_enable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	char *xable_usage = "ndctl enable-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
 			ACTION_ENABLE, base_options, xable_usage);
-	int enabled = do_xaction_namespace(namespace, ACTION_ENABLE);
+	int enabled = do_xaction_namespace(namespace, ACTION_ENABLE, ctx);
 
 	if (enabled < 0) {
 		fprintf(stderr, "error enabling namespaces: %s\n",
@@ -811,12 +803,12 @@ int cmd_enable_namespace(int argc, const char **argv)
 	}
 }
 
-int cmd_create_namespace(int argc, const char **argv)
+int cmd_create_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	char *xable_usage = "ndctl create-namespace [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
 			ACTION_CREATE, create_options, xable_usage);
-	int created = do_xaction_namespace(namespace, ACTION_CREATE);
+	int created = do_xaction_namespace(namespace, ACTION_CREATE, ctx);
 
 	if (created < 1 && param.do_scan) {
 		/*
@@ -826,7 +818,7 @@ int cmd_create_namespace(int argc, const char **argv)
 		memset(&param, 0, sizeof(param));
 		param.type = "blk";
 		set_defaults(ACTION_CREATE);
-		created = do_xaction_namespace(NULL, ACTION_CREATE);
+		created = do_xaction_namespace(NULL, ACTION_CREATE, ctx);
 	}
 
 	if (created < 0 || (!namespace && created < 1)) {
@@ -841,12 +833,12 @@ int cmd_create_namespace(int argc, const char **argv)
 	return 0;
 }
 
-int cmd_destroy_namespace(int argc , const char **argv)
+int cmd_destroy_namespace(int argc , const char **argv, struct ndctl_ctx *ctx)
 {
 	char *xable_usage = "ndctl destroy-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
 			ACTION_DESTROY, destroy_options, xable_usage);
-	int destroyed = do_xaction_namespace(namespace, ACTION_DESTROY);
+	int destroyed = do_xaction_namespace(namespace, ACTION_DESTROY, ctx);
 
 	if (destroyed < 0) {
 		fprintf(stderr, "error destroying namespaces: %s\n",
diff --git a/ndctl/builtin-zero-labels.c b/ndctl/builtin-zero-labels.c
index 649bd9eb9c08..2fe466e6ba34 100644
--- a/ndctl/builtin-zero-labels.c
+++ b/ndctl/builtin-zero-labels.c
@@ -29,7 +29,7 @@ static int do_zero_dimm(struct ndctl_dimm *dimm, const char **argv, int argc,
 	return rc;
 }
 
-int cmd_zero_labels(int argc, const char **argv)
+int cmd_zero_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	const char *nmem_bus = NULL;
 	bool verbose = false;
@@ -44,7 +44,6 @@ int cmd_zero_labels(int argc, const char **argv)
 		NULL
 	};
 	struct ndctl_dimm *dimm;
-	struct ndctl_ctx *ctx;
 	struct ndctl_bus *bus;
 	int i, rc, count, err = 0;
 
@@ -64,10 +63,6 @@ int cmd_zero_labels(int argc, const char **argv)
 		}
 	}
 
-	rc = ndctl_new(&ctx);
-	if (rc < 0)
-		return rc;
-
 	count = 0;
         ndctl_bus_foreach(ctx, bus) {
 		if (!util_bus_filter(bus, nmem_bus))
@@ -85,8 +80,6 @@ int cmd_zero_labels(int argc, const char **argv)
 
 	fprintf(stderr, "zeroed %d nmem%s\n", count, count > 1 ? "s" : "");
 
-	ndctl_unref(ctx);
-
 	/*
 	 * 0 if all dimms zeroed, count if at least 1 dimm zeroed, < 0
 	 * if all errors
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index 53ec25b8a76a..46cd5d2d439c 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -3,26 +3,27 @@
 extern const char ndctl_usage_string[];
 extern const char ndctl_more_info_string[];
 
+struct ndctl_ctx;
 struct cmd_struct {
 	const char *cmd;
-	int (*fn)(int, const char **);
+	int (*fn)(int, const char **, struct ndctl_ctx *ctx);
 };
 
-int cmd_create_nfit(int argc, const char **argv);
-int cmd_enable_namespace(int argc, const char **argv);
-int cmd_create_namespace(int argc, const char **argv);
-int cmd_destroy_namespace(int argc, const char **argv);
-int cmd_disable_namespace(int argc, const char **argv);
-int cmd_enable_region(int argc, const char **argv);
-int cmd_disable_region(int argc, const char **argv);
-int cmd_zero_labels(int argc, const char **argv);
-int cmd_read_labels(int argc, const char **argv);
-int cmd_help(int argc, const char **argv);
-int cmd_list(int argc, const char **argv);
+int cmd_create_nfit(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_enable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_create_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_destroy_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_disable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_enable_region(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_disable_region(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_zero_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_read_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_list(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_help(int argc, const char **argv, struct ndctl_ctx *ctx);
 #ifdef ENABLE_TEST
-int cmd_test(int argc, const char **argv);
+int cmd_test(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif
 #ifdef ENABLE_DESTRUCTIVE
-int cmd_bat(int argc, const char **argv);
+int cmd_bat(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index bf0754cb454c..77f90d6087ba 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -6,6 +6,7 @@
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <builtin.h>
+#include <ndctl/libndctl.h>
 #include <ccan/array_size/array_size.h>
 
 #include <util/strbuf.h>
@@ -16,7 +17,7 @@ const char ndctl_more_info_string[] =
 	"See 'ndctl help COMMAND' for more information on a specific command.\n"
 	" ndctl --list-cmds to see all available commands";
 
-static int cmd_version(int argc, const char **argv)
+static int cmd_version(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	printf("%s\n", VERSION);
 	return 0;
@@ -101,8 +102,18 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 {
 	int status;
 	struct stat st;
-
-	status = p->fn(argc, argv);
+	struct ndctl_ctx *ctx;
+
+	/*
+	 * Yes, establishing the ndctl context here makes this code less
+	 * generic, but it allows for unit testing the top level
+	 * interface to the built-in commands.
+	 */
+	status = ndctl_new(&ctx);
+	if (status)
+		return status;
+	status = p->fn(argc, argv, ctx);
+	ndctl_unref(ctx);
 
 	if (status)
 		return status & 0xff;
diff --git a/test.h b/test.h
index 5425be1bc107..1ac03aa09762 100644
--- a/test.h
+++ b/test.h
@@ -12,10 +12,11 @@ int __ndctl_test_attempt(struct ndctl_test *test, unsigned int kver,
 void __ndctl_test_skip(struct ndctl_test *test, const char *caller, int line);
 #define ndctl_test_skip(t) __ndctl_test_skip(t, __func__, __LINE__)
 
-int test_parent_uuid(int loglevel, struct ndctl_test *test);
-int test_direct_io(int loglevel, struct ndctl_test *test);
-int test_dpa_alloc(int loglevel, struct ndctl_test *test);
-int test_libndctl(int loglevel, struct ndctl_test *test);
-int test_blk_namespaces(int loglevel, struct ndctl_test *test);
-int test_pmem_namespaces(int loglevel, struct ndctl_test *test);
+struct ndctl_ctx;
+int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
+int test_direct_io(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
+int test_dpa_alloc(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
+int test_libndctl(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
+int test_blk_namespaces(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
+int test_pmem_namespaces(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 #endif /* __TEST_H__ */
diff --git a/test/blk_namespaces.c b/test/blk_namespaces.c
index 2e25c19b2f59..6b36c8c9fc03 100644
--- a/test/blk_namespaces.c
+++ b/test/blk_namespaces.c
@@ -214,11 +214,11 @@ static int ns_do_io(const char *bdev)
 
 static const char *comm = "test-blk-namespaces";
 
-int test_blk_namespaces(int log_level, struct ndctl_test *test)
+int test_blk_namespaces(int log_level, struct ndctl_test *test,
+		struct ndctl_ctx *ctx)
 {
-	int rc;
 	char bdev[50];
-	struct ndctl_ctx *ctx;
+	int rc = -ENXIO;
 	struct ndctl_bus *bus;
 	struct ndctl_dimm *dimm;
 	struct kmod_module *mod = NULL;
@@ -229,10 +229,6 @@ int test_blk_namespaces(int log_level, struct ndctl_test *test)
 	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
 		return 77;
 
-	rc = ndctl_new(&ctx);
-	if (rc < 0)
-		return rc;
-
 	ndctl_set_log_priority(ctx, log_level);
 
 	bus = ndctl_bus_get_by_provider(ctx, "ACPI.NFIT");
@@ -250,7 +246,7 @@ int test_blk_namespaces(int log_level, struct ndctl_test *test)
 		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
 		kmod_ctx = kmod_new(NULL, NULL);
 		if (!kmod_ctx)
-			goto err_kmod;
+			return rc;
 		kmod_set_log_priority(kmod_ctx, log_level);
 
 		rc = kmod_module_new_from_name(kmod_ctx, "nfit_test", &mod);
@@ -282,7 +278,7 @@ int test_blk_namespaces(int log_level, struct ndctl_test *test)
                 if (rc < 0) {
                         fprintf(stderr, "failed to zero %s\n",
                                         ndctl_dimm_get_devname(dimm));
-                        return rc;
+			goto err_module;
                 }
         }
 
@@ -364,14 +360,13 @@ int test_blk_namespaces(int log_level, struct ndctl_test *test)
  err_module:
 	if (kmod_ctx)
 		kmod_unref(kmod_ctx);
- err_kmod:
-	ndctl_unref(ctx);
 	return rc;
 }
 
 int __attribute__((weak)) main(int argc, char *argv[])
 {
 	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_ctx *ctx;
 	int rc;
 
 	comm = argv[0];
@@ -380,6 +375,11 @@ int __attribute__((weak)) main(int argc, char *argv[])
 		return EXIT_FAILURE;
 	}
 
-	rc = test_blk_namespaces(LOG_DEBUG, test);
+	rc = ndctl_new(&ctx);
+	if (rc)
+		return ndctl_test_result(test, rc);
+
+	rc = test_blk_namespaces(LOG_DEBUG, test, ctx);
+	ndctl_unref(ctx);
 	return ndctl_test_result(test, rc);
 }
diff --git a/test/dpa-alloc.c b/test/dpa-alloc.c
index 87f374fe0540..8b100abeb466 100644
--- a/test/dpa-alloc.c
+++ b/test/dpa-alloc.c
@@ -290,9 +290,8 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 	return 0;
 }
 
-int test_dpa_alloc(int loglevel, struct ndctl_test *test)
+int test_dpa_alloc(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
 {
-	struct ndctl_ctx *ctx;
 	struct kmod_module *mod;
 	struct kmod_ctx *kmod_ctx;
 	int err, result = EXIT_FAILURE;
@@ -300,15 +299,11 @@ int test_dpa_alloc(int loglevel, struct ndctl_test *test)
 	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
 		return 77;
 
-	err = ndctl_new(&ctx);
-	if (err < 0)
-		exit(EXIT_FAILURE);
-
 	ndctl_set_log_priority(ctx, loglevel);
 
 	kmod_ctx = kmod_new(NULL, NULL);
 	if (!kmod_ctx)
-		goto err_kmod;
+		return result;
 
 	err = kmod_module_new_from_name(kmod_ctx, NFIT_TEST_MODULE, &mod);
 	if (err < 0)
@@ -331,14 +326,13 @@ int test_dpa_alloc(int loglevel, struct ndctl_test *test)
 
  err_module:
 	kmod_unref(kmod_ctx);
- err_kmod:
-	ndctl_unref(ctx);
 	return result;
 }
 
 int __attribute__((weak)) main(int argc, char *argv[])
 {
 	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_ctx *ctx;
 	int rc;
 
 	if (!test) {
@@ -346,6 +340,11 @@ int __attribute__((weak)) main(int argc, char *argv[])
 		return EXIT_FAILURE;
 	}
 
-	rc = test_dpa_alloc(LOG_DEBUG, test);
+	rc = ndctl_new(&ctx);
+	if (rc)
+		return ndctl_test_result(test, rc);
+
+	rc = test_dpa_alloc(LOG_DEBUG, test, ctx);
+	ndctl_unref(ctx);
 	return ndctl_test_result(test, rc);
 }
diff --git a/test/libndctl.c b/test/libndctl.c
index 684235d65eac..de2c47c3f91b 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2505,10 +2505,9 @@ static do_test_fn do_test[] = {
 	do_test1,
 };
 
-int test_libndctl(int loglevel, struct ndctl_test *test)
+int test_libndctl(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
 {
 	unsigned int i;
-	struct ndctl_ctx *ctx;
 	struct kmod_module *mod;
 	struct kmod_ctx *kmod_ctx;
 	struct daxctl_ctx *daxctl_ctx;
@@ -2517,17 +2516,13 @@ int test_libndctl(int loglevel, struct ndctl_test *test)
 	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
 		return 77;
 
-	err = ndctl_new(&ctx);
-	if (err < 0)
-		exit(EXIT_FAILURE);
-
 	ndctl_set_log_priority(ctx, loglevel);
 	daxctl_ctx = ndctl_get_daxctl_ctx(ctx);
 	daxctl_set_log_priority(daxctl_ctx, loglevel);
 
 	kmod_ctx = kmod_new(NULL, NULL);
 	if (!kmod_ctx)
-		goto err_kmod;
+		return result;
 	kmod_set_log_priority(kmod_ctx, loglevel);
 
 	err = kmod_module_new_from_name(kmod_ctx, NFIT_TEST_MODULE, &mod);
@@ -2558,14 +2553,13 @@ int test_libndctl(int loglevel, struct ndctl_test *test)
 
  err_module:
 	kmod_unref(kmod_ctx);
- err_kmod:
-	ndctl_unref(ctx);
 	return result;
 }
 
 int __attribute__((weak)) main(int argc, char *argv[])
 {
 	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_ctx *ctx;
 	int rc;
 
 	if (!test) {
@@ -2573,6 +2567,10 @@ int __attribute__((weak)) main(int argc, char *argv[])
 		return EXIT_FAILURE;
 	}
 
-	rc = test_libndctl(LOG_DEBUG, test);
+	rc = ndctl_new(&ctx);
+	if (rc)
+		return ndctl_test_result(test, rc);
+	rc = test_libndctl(LOG_DEBUG, test, ctx);
+	ndctl_unref(ctx);
 	return ndctl_test_result(test, rc);
 }
diff --git a/test/parent-uuid.c b/test/parent-uuid.c
index 676b3ad63b15..89c13956985e 100644
--- a/test/parent-uuid.c
+++ b/test/parent-uuid.c
@@ -220,9 +220,8 @@ static int do_test(struct ndctl_ctx *ctx)
 	return 0;
 }
 
-int test_parent_uuid(int loglevel, struct ndctl_test *test)
+int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
 {
-	struct ndctl_ctx *ctx;
 	struct kmod_module *mod;
 	struct kmod_ctx *kmod_ctx;
 	int err, result = EXIT_FAILURE;
@@ -230,15 +229,11 @@ int test_parent_uuid(int loglevel, struct ndctl_test *test)
 	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 3, 0)))
 		return 77;
 
-	err = ndctl_new(&ctx);
-	if (err < 0)
-		exit(EXIT_FAILURE);
-
 	ndctl_set_log_priority(ctx, loglevel);
 
 	kmod_ctx = kmod_new(NULL, NULL);
 	if (!kmod_ctx)
-		goto err_kmod;
+		return result;
 
 	err = kmod_module_new_from_name(kmod_ctx, NFIT_TEST_MODULE, &mod);
 	if (err < 0)
@@ -261,14 +256,13 @@ int test_parent_uuid(int loglevel, struct ndctl_test *test)
 
  err_module:
 	kmod_unref(kmod_ctx);
- err_kmod:
-	ndctl_unref(ctx);
 	return result;
 }
 
 int __attribute__((weak)) main(int argc, char *argv[])
 {
 	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_ctx *ctx;
 	int rc;
 
 	if (!test) {
@@ -276,6 +270,11 @@ int __attribute__((weak)) main(int argc, char *argv[])
 		return EXIT_FAILURE;
 	}
 
-	rc = test_parent_uuid(LOG_DEBUG, test);
+	rc = ndctl_new(&ctx);
+	if (rc)
+		return ndctl_test_result(test, rc);
+
+	rc = test_parent_uuid(LOG_DEBUG, test, ctx);
+	ndctl_unref(ctx);
 	return ndctl_test_result(test, rc);
 }
diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
index 8edfaba2d7f3..908706bce4bb 100644
--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -178,25 +178,21 @@ static int ns_do_io(const char *bdev)
 
 static const char *comm = "test-pmem-namespaces";
 
-int test_pmem_namespaces(int log_level, struct ndctl_test *test)
+int test_pmem_namespaces(int log_level, struct ndctl_test *test,
+		struct ndctl_ctx *ctx)
 {
 	struct ndctl_region *region, *pmem_region = NULL;
 	struct kmod_ctx *kmod_ctx = NULL;
 	struct kmod_module *mod = NULL;
 	struct ndctl_namespace *ndns;
 	struct ndctl_dimm *dimm;
-	struct ndctl_ctx *ctx;
 	struct ndctl_bus *bus;
+	int rc = -ENXIO;
 	char bdev[50];
-	int rc;
 
 	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
 		return 77;
 
-	rc = ndctl_new(&ctx);
-	if (rc < 0)
-		return rc;
-
 	ndctl_set_log_priority(ctx, log_level);
 
 	bus = ndctl_bus_get_by_provider(ctx, "ACPI.NFIT");
@@ -214,7 +210,7 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test)
 		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
 		kmod_ctx = kmod_new(NULL, NULL);
 		if (!kmod_ctx)
-			goto err_kmod;
+			return rc;
 		kmod_set_log_priority(kmod_ctx, log_level);
 
 		rc = kmod_module_new_from_name(kmod_ctx, "nfit_test", &mod);
@@ -289,14 +285,13 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test)
 
  err_module:
 	kmod_unref(kmod_ctx);
- err_kmod:
-	ndctl_unref(ctx);
 	return rc;
 }
 
 int __attribute__((weak)) main(int argc, char *argv[])
 {
 	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_ctx *ctx;
 	int rc;
 
 	comm = argv[0];
@@ -305,6 +300,11 @@ int __attribute__((weak)) main(int argc, char *argv[])
 		return EXIT_FAILURE;
 	}
 
-	rc = test_pmem_namespaces(LOG_DEBUG, test);
+	rc = ndctl_new(&ctx);
+	if (rc)
+		return ndctl_test_result(test, rc);
+
+	rc = test_pmem_namespaces(LOG_DEBUG, test, ctx);
+	ndctl_unref(ctx);
 	return ndctl_test_result(test, rc);
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
