Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9ADCB21198CC2
 for <linux-nvdimm@lists.01.org>; Thu, 27 Dec 2018 19:42:45 -0800 (PST)
Subject: [ndctl PATCH 2/7] ndctl, daxctl: Add type-safety to command harness
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Dec 2018 19:30:09 -0800
Message-ID: <154596780916.164521.4486406844809825010.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154596779833.164521.12632457592535372923.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <154596779833.164521.12632457592535372923.stgit@dwillia2-desk3.amr.corp.intel.com>
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

A recent attempt to drop casts from ndctl/monitor.c ran afoul of the
'struct btt_chk' usage of an embedded 'struct log_ctx'. It is
generically useful to be able to reuse the log functions and fragile to
force them to be placed at offset zero in the container context.
Instead, just teach the harness the difference between ndctl and daxctl
commands. Let the leaf command implementations receive their expected
context with the correct type.

Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/builtin.h     |    4 +++
 daxctl/daxctl.c      |   12 +++++-----
 daxctl/list.c        |    2 +-
 ndctl/bat.c          |    2 +-
 ndctl/builtin.h      |   50 ++++++++++++++++++++++---------------------
 ndctl/bus.c          |    4 ++-
 ndctl/create-nfit.c  |    2 +-
 ndctl/dimm.c         |   18 ++++++++--------
 ndctl/inject-error.c |    2 +-
 ndctl/inject-smart.c |    2 +-
 ndctl/list.c         |    2 +-
 ndctl/monitor.c      |    2 +-
 ndctl/namespace.c    |   10 ++++-----
 ndctl/ndctl.c        |   58 +++++++++++++++++++++++++-------------------------
 ndctl/region.c       |    4 ++-
 ndctl/test.c         |    2 +-
 util/main.c          |   11 ++++++---
 util/main.h          |   15 +++++++++++--
 18 files changed, 110 insertions(+), 92 deletions(-)

diff --git a/daxctl/builtin.h b/daxctl/builtin.h
index 131a5d86258b..dae2615b7ddb 100644
--- a/daxctl/builtin.h
+++ b/daxctl/builtin.h
@@ -2,5 +2,7 @@
 /* Copyright(c) 2015-2018 Intel Corporation. All rights reserved. */
 #ifndef _DAXCTL_BUILTIN_H_
 #define _DAXCTL_BUILTIN_H_
-int cmd_list(int argc, const char **argv, void *ctx);
+
+struct daxctl_ctx;
+int cmd_list(int argc, const char **argv, struct daxctl_ctx *ctx);
 #endif /* _DAXCTL_BUILTIN_H_ */
diff --git a/daxctl/daxctl.c b/daxctl/daxctl.c
index 545e117a5aad..cb6f50e39170 100644
--- a/daxctl/daxctl.c
+++ b/daxctl/daxctl.c
@@ -35,13 +35,13 @@ const char daxctl_more_info_string[] =
 	"See 'daxctl help COMMAND' for more information on a specific command.\n"
 	" daxctl --list-cmds to see all available commands";
 
-static int cmd_version(int argc, const char **argv, void *ctx)
+static int cmd_version(int argc, const char **argv, struct daxctl_ctx *ctx)
 {
 	printf("%s\n", VERSION);
 	return 0;
 }
 
-static int cmd_help(int argc, const char **argv, void *ctx)
+static int cmd_help(int argc, const char **argv, struct daxctl_ctx *ctx)
 {
 	const char * const builtin_help_subcommands[] = {
 		"list", NULL,
@@ -67,9 +67,9 @@ static int cmd_help(int argc, const char **argv, void *ctx)
 }
 
 static struct cmd_struct commands[] = {
-	{ "version", cmd_version },
-	{ "list", cmd_list },
-	{ "help", cmd_help },
+	{ "version", .d_fn = cmd_version },
+	{ "list", .d_fn = cmd_list },
+	{ "help", .d_fn = cmd_help },
 };
 
 int main(int argc, const char **argv)
@@ -97,7 +97,7 @@ int main(int argc, const char **argv)
 	if (rc)
 		goto out;
 	main_handle_internal_command(argc, argv, ctx, commands,
-			ARRAY_SIZE(commands));
+			ARRAY_SIZE(commands), PROG_DAXCTL);
 	daxctl_unref(ctx);
 	fprintf(stderr, "Unknown command: '%s'\n", argv[0]);
 out:
diff --git a/daxctl/list.c b/daxctl/list.c
index 58c35fafcd4c..e56300ddd95f 100644
--- a/daxctl/list.c
+++ b/daxctl/list.c
@@ -63,7 +63,7 @@ static int num_list_flags(void)
 	return list.regions + list.devs;
 }
 
-int cmd_list(int argc, const char **argv, void *ctx)
+int cmd_list(int argc, const char **argv, struct daxctl_ctx *ctx)
 {
 	const struct option options[] = {
 		OPT_INTEGER('r', "region", &param.region_id, "filter by region"),
diff --git a/ndctl/bat.c b/ndctl/bat.c
index 5e84f6459890..c4496f0aeaa0 100644
--- a/ndctl/bat.c
+++ b/ndctl/bat.c
@@ -16,7 +16,7 @@
 #include <limits.h>
 #include <util/parse-options.h>
 
-int cmd_bat(int argc, const char **argv, void *ctx)
+int cmd_bat(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	int loglevel = LOG_DEBUG, i, rc;
 	struct ndctl_test *test;
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index 4ebc50406247..17300df0403e 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -2,32 +2,34 @@
 /* Copyright(c) 2015-2018 Intel Corporation. All rights reserved. */
 #ifndef _NDCTL_BUILTIN_H_
 #define _NDCTL_BUILTIN_H_
-int cmd_create_nfit(int argc, const char **argv, void *ctx);
-int cmd_enable_namespace(int argc, const char **argv, void *ctx);
-int cmd_create_namespace(int argc, const char **argv, void *ctx);
-int cmd_destroy_namespace(int argc, const char **argv, void *ctx);
-int cmd_disable_namespace(int argc, const char **argv, void *ctx);
-int cmd_check_namespace(int argc, const char **argv, void *ctx);
-int cmd_enable_region(int argc, const char **argv, void *ctx);
-int cmd_disable_region(int argc, const char **argv, void *ctx);
-int cmd_enable_dimm(int argc, const char **argv, void *ctx);
-int cmd_disable_dimm(int argc, const char **argv, void *ctx);
-int cmd_zero_labels(int argc, const char **argv, void *ctx);
-int cmd_read_labels(int argc, const char **argv, void *ctx);
-int cmd_write_labels(int argc, const char **argv, void *ctx);
-int cmd_init_labels(int argc, const char **argv, void *ctx);
-int cmd_check_labels(int argc, const char **argv, void *ctx);
-int cmd_inject_error(int argc, const char **argv, void *ctx);
-int cmd_wait_scrub(int argc, const char **argv, void *ctx);
-int cmd_start_scrub(int argc, const char **argv, void *ctx);
-int cmd_list(int argc, const char **argv, void *ctx);
-int cmd_monitor(int argc, const char **argv, void *ctx);
+
+struct ndctl_ctx;
+int cmd_create_nfit(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_enable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_create_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_destroy_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_disable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_check_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_enable_region(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_disable_region(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_enable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_disable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_zero_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_read_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_write_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_init_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_check_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_inject_error(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_wait_scrub(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_start_scrub(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_list(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx);
 #ifdef ENABLE_TEST
-int cmd_test(int argc, const char **argv, void *ctx);
+int cmd_test(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif
 #ifdef ENABLE_DESTRUCTIVE
-int cmd_bat(int argc, const char **argv, void *ctx);
+int cmd_bat(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif
-int cmd_update_firmware(int argc, const char **argv, void *ctx);
-int cmd_inject_smart(int argc, const char **argv, void *ctx);
+int cmd_update_firmware(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_inject_smart(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/bus.c b/ndctl/bus.c
index bcb8c7199152..ce7f76add777 100644
--- a/ndctl/bus.c
+++ b/ndctl/bus.c
@@ -97,7 +97,7 @@ static int bus_action(int argc, const char **argv, const char *usage,
 	return fail ? fail : -ENXIO;
 }
 
-int cmd_start_scrub(int argc, const char **argv, void *ctx)
+int cmd_start_scrub(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	char *usage = "ndctl start-scrub [<bus-id> <bus-id2> ... <bus-idN>] [<options>]";
 	int start = bus_action(argc, argv, usage, bus_options,
@@ -112,7 +112,7 @@ int cmd_start_scrub(int argc, const char **argv, void *ctx)
 	}
 }
 
-int cmd_wait_scrub(int argc, const char **argv, void *ctx)
+int cmd_wait_scrub(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	char *usage = "ndctl wait-scrub [<bus-id> <bus-id2> ... <bus-idN>] [<options>]";
 	int wait = bus_action(argc, argv, usage, bus_options,
diff --git a/ndctl/create-nfit.c b/ndctl/create-nfit.c
index 6adfae7af014..53319182d8a4 100644
--- a/ndctl/create-nfit.c
+++ b/ndctl/create-nfit.c
@@ -176,7 +176,7 @@ static int write_nfit(struct nfit *nfit, const char *file, int force)
 }
 
 struct ndctl_ctx;
-int cmd_create_nfit(int argc, const char **argv, void *ctx)
+int cmd_create_nfit(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	int i, rc = -ENXIO, force = 0;
 	const char * const u[] = {
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 699ab57d9faa..c717beeb78ff 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -954,7 +954,7 @@ static const struct option init_options[] = {
 	OPT_END(),
 };
 
-static int dimm_action(int argc, const char **argv, void *ctx,
+static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
 		int (*action)(struct ndctl_dimm *dimm, struct action_context *actx),
 		const struct option *options, const char *usage)
 {
@@ -1102,7 +1102,7 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 	return rc;
 }
 
-int cmd_write_labels(int argc, const char **argv, void *ctx)
+int cmd_write_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_write, write_options,
 			"ndctl write-labels <nmem> [-i <filename>]");
@@ -1112,7 +1112,7 @@ int cmd_write_labels(int argc, const char **argv, void *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
-int cmd_read_labels(int argc, const char **argv, void *ctx)
+int cmd_read_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_read, read_options,
 			"ndctl read-labels <nmem0> [<nmem1>..<nmemN>] [-o <filename>]");
@@ -1122,7 +1122,7 @@ int cmd_read_labels(int argc, const char **argv, void *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
-int cmd_zero_labels(int argc, const char **argv, void *ctx)
+int cmd_zero_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_zero, base_options,
 			"ndctl zero-labels <nmem0> [<nmem1>..<nmemN>] [<options>]");
@@ -1132,7 +1132,7 @@ int cmd_zero_labels(int argc, const char **argv, void *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
-int cmd_init_labels(int argc, const char **argv, void *ctx)
+int cmd_init_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_init, init_options,
 			"ndctl init-labels <nmem0> [<nmem1>..<nmemN>] [<options>]");
@@ -1142,7 +1142,7 @@ int cmd_init_labels(int argc, const char **argv, void *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
-int cmd_check_labels(int argc, const char **argv, void *ctx)
+int cmd_check_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_check, base_options,
 			"ndctl check-labels <nmem0> [<nmem1>..<nmemN>] [<options>]");
@@ -1152,7 +1152,7 @@ int cmd_check_labels(int argc, const char **argv, void *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
-int cmd_disable_dimm(int argc, const char **argv, void *ctx)
+int cmd_disable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_disable, base_options,
 			"ndctl disable-dimm <nmem0> [<nmem1>..<nmemN>] [<options>]");
@@ -1162,7 +1162,7 @@ int cmd_disable_dimm(int argc, const char **argv, void *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
-int cmd_enable_dimm(int argc, const char **argv, void *ctx)
+int cmd_enable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_enable, base_options,
 			"ndctl enable-dimm <nmem0> [<nmem1>..<nmemN>] [<options>]");
@@ -1172,7 +1172,7 @@ int cmd_enable_dimm(int argc, const char **argv, void *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
-int cmd_update_firmware(int argc, const char **argv, void *ctx)
+int cmd_update_firmware(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_update, update_options,
 			"ndctl update-firmware <nmem0> [<nmem1>..<nmemN>] [<options>]");
diff --git a/ndctl/inject-error.c b/ndctl/inject-error.c
index 2b2fec0df706..fef6f75716be 100644
--- a/ndctl/inject-error.c
+++ b/ndctl/inject-error.c
@@ -353,7 +353,7 @@ static int do_inject(const char *namespace, struct ndctl_ctx *ctx)
 	return rc;
 }
 
-int cmd_inject_error(int argc, const char **argv, void *ctx)
+int cmd_inject_error(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	const char * const u[] = {
 		"ndctl inject-error <namespace> [<options>]",
diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index d60bbf15801d..7a44a684d630 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -491,7 +491,7 @@ static int do_smart(const char *dimm_arg, struct ndctl_ctx *ctx)
 	return rc;
 }
 
-int cmd_inject_smart(int argc, const char **argv, void *ctx)
+int cmd_inject_smart(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	const char * const u[] = {
 		"ndctl inject-smart <dimm> [<options>]",
diff --git a/ndctl/list.c b/ndctl/list.c
index 33f111fca9d3..506404db11b0 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -424,7 +424,7 @@ static int num_list_flags(void)
 	return list.buses + list.dimms + list.regions + list.namespaces;
 }
 
-int cmd_list(int argc, const char **argv, void *ctx)
+int cmd_list(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	const struct option options[] = {
 		OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index b92a133b7b94..47caae55d56d 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -580,7 +580,7 @@ out:
 	return rc;
 }
 
-int cmd_monitor(int argc, const char **argv, void *ctx)
+int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	const struct option options[] = {
 		OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index ac49fba9d0f4..b35812bd17a9 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -1138,7 +1138,7 @@ static int do_xaction_namespace(const char *namespace,
 	return rc;
 }
 
-int cmd_disable_namespace(int argc, const char **argv, void *ctx)
+int cmd_disable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	char *xable_usage = "ndctl disable-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
@@ -1155,7 +1155,7 @@ int cmd_disable_namespace(int argc, const char **argv, void *ctx)
 	return rc;
 }
 
-int cmd_enable_namespace(int argc, const char **argv, void *ctx)
+int cmd_enable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	char *xable_usage = "ndctl enable-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
@@ -1171,7 +1171,7 @@ int cmd_enable_namespace(int argc, const char **argv, void *ctx)
 	return rc;
 }
 
-int cmd_create_namespace(int argc, const char **argv, void *ctx)
+int cmd_create_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	char *xable_usage = "ndctl create-namespace [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
@@ -1200,7 +1200,7 @@ int cmd_create_namespace(int argc, const char **argv, void *ctx)
 	return rc;
 }
 
-int cmd_destroy_namespace(int argc , const char **argv, void *ctx)
+int cmd_destroy_namespace(int argc , const char **argv, struct ndctl_ctx *ctx)
 {
 	char *xable_usage = "ndctl destroy-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
@@ -1216,7 +1216,7 @@ int cmd_destroy_namespace(int argc , const char **argv, void *ctx)
 	return rc;
 }
 
-int cmd_check_namespace(int argc , const char **argv, void *ctx)
+int cmd_check_namespace(int argc , const char **argv, struct ndctl_ctx *ctx)
 {
 	char *xable_usage = "ndctl check-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 9c930b92fe44..b01594e06739 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -35,13 +35,13 @@ static const char ndctl_more_info_string[] =
 	"See 'ndctl help COMMAND' for more information on a specific command.\n"
 	" ndctl --list-cmds to see all available commands";
 
-static int cmd_version(int argc, const char **argv, void *ctx)
+static int cmd_version(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	printf("%s\n", VERSION);
 	return 0;
 }
 
-static int cmd_help(int argc, const char **argv, void *ctx)
+static int cmd_help(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	const char * const builtin_help_subcommands[] = {
 		"enable-region", "disable-region", "zero-labels",
@@ -67,35 +67,35 @@ static int cmd_help(int argc, const char **argv, void *ctx)
 }
 
 static struct cmd_struct commands[] = {
-	{ "version", cmd_version },
-	{ "create-nfit", cmd_create_nfit },
-	{ "enable-namespace", cmd_enable_namespace },
-	{ "disable-namespace", cmd_disable_namespace },
-	{ "create-namespace", cmd_create_namespace },
-	{ "destroy-namespace", cmd_destroy_namespace },
-	{ "check-namespace", cmd_check_namespace },
-	{ "enable-region", cmd_enable_region },
-	{ "disable-region", cmd_disable_region },
-	{ "enable-dimm", cmd_enable_dimm },
-	{ "disable-dimm", cmd_disable_dimm },
-	{ "zero-labels", cmd_zero_labels },
-	{ "read-labels", cmd_read_labels },
-	{ "write-labels", cmd_write_labels },
-	{ "init-labels", cmd_init_labels },
-	{ "check-labels", cmd_check_labels },
-	{ "inject-error", cmd_inject_error },
-	{ "update-firmware", cmd_update_firmware },
-	{ "inject-smart", cmd_inject_smart },
-	{ "wait-scrub", cmd_wait_scrub },
-	{ "start-scrub", cmd_start_scrub },
-	{ "list", cmd_list },
-	{ "monitor", cmd_monitor},
-	{ "help", cmd_help },
+	{ "version", { cmd_version } },
+	{ "create-nfit", { cmd_create_nfit } },
+	{ "enable-namespace", { cmd_enable_namespace } },
+	{ "disable-namespace", { cmd_disable_namespace } },
+	{ "create-namespace", { cmd_create_namespace } },
+	{ "destroy-namespace", { cmd_destroy_namespace } },
+	{ "check-namespace", { cmd_check_namespace } },
+	{ "enable-region", { cmd_enable_region } },
+	{ "disable-region", { cmd_disable_region } },
+	{ "enable-dimm", { cmd_enable_dimm } },
+	{ "disable-dimm", { cmd_disable_dimm } },
+	{ "zero-labels", { cmd_zero_labels } },
+	{ "read-labels", { cmd_read_labels } },
+	{ "write-labels", { cmd_write_labels } },
+	{ "init-labels", { cmd_init_labels } },
+	{ "check-labels", { cmd_check_labels } },
+	{ "inject-error", { cmd_inject_error } },
+	{ "update-firmware", { cmd_update_firmware } },
+	{ "inject-smart", { cmd_inject_smart } },
+	{ "wait-scrub", { cmd_wait_scrub } },
+	{ "start-scrub", { cmd_start_scrub } },
+	{ "list", { cmd_list } },
+	{ "monitor", { cmd_monitor } },
+	{ "help", { cmd_help } },
 	#ifdef ENABLE_TEST
-	{ "test", cmd_test },
+	{ "test", { cmd_test } },
 	#endif
 	#ifdef ENABLE_DESTRUCTIVE
-	{ "bat", cmd_bat },
+	{ "bat", { cmd_bat } },
 	#endif
 };
 
@@ -124,7 +124,7 @@ int main(int argc, const char **argv)
 	if (rc)
 		goto out;
 	main_handle_internal_command(argc, argv, ctx, commands,
-			ARRAY_SIZE(commands));
+			ARRAY_SIZE(commands), PROG_NDCTL);
 	ndctl_unref(ctx);
 	fprintf(stderr, "Unknown command: '%s'\n", argv[0]);
 out:
diff --git a/ndctl/region.c b/ndctl/region.c
index 9fc90808e338..993b3f87eb40 100644
--- a/ndctl/region.c
+++ b/ndctl/region.c
@@ -124,7 +124,7 @@ static int do_xable_region(const char *region_arg, enum device_action mode,
 	return rc;
 }
 
-int cmd_disable_region(int argc, const char **argv, void *ctx)
+int cmd_disable_region(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	char *xable_usage = "ndctl disable-region <region> [<options>]";
 	const char *region = parse_region_options(argc, argv, xable_usage);
@@ -144,7 +144,7 @@ int cmd_disable_region(int argc, const char **argv, void *ctx)
 	}
 }
 
-int cmd_enable_region(int argc, const char **argv, void *ctx)
+int cmd_enable_region(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	char *xable_usage = "ndctl enable-region <region> [<options>]";
 	const char *region = parse_region_options(argc, argv, xable_usage);
diff --git a/ndctl/test.c b/ndctl/test.c
index 25ec61cdec1e..b78776311125 100644
--- a/ndctl/test.c
+++ b/ndctl/test.c
@@ -26,7 +26,7 @@ static char *result(int rc)
 		return "PASS";
 }
 
-int cmd_test(int argc, const char **argv, void *ctx)
+int cmd_test(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	struct ndctl_test *test;
 	int loglevel = LOG_DEBUG, i, rc;
diff --git a/util/main.c b/util/main.c
index a7992589cfcc..4f925f84966a 100644
--- a/util/main.c
+++ b/util/main.c
@@ -82,12 +82,15 @@ int main_handle_options(const char ***argv, int *argc, const char *usage_msg,
 }
 
 static int run_builtin(struct cmd_struct *p, int argc, const char **argv,
-		void *ctx)
+		void *ctx, enum program prog)
 {
 	int status;
 	struct stat st;
 
-	status = p->fn(argc, argv, ctx);
+	if (prog == PROG_NDCTL)
+		status = p->n_fn(argc, argv, ctx);
+	else
+		status = p->d_fn(argc, argv, ctx);
 
 	if (status)
 		return status & 0xff;
@@ -119,7 +122,7 @@ out:
 }
 
 void main_handle_internal_command(int argc, const char **argv, void *ctx,
-		struct cmd_struct *cmds, int num_cmds)
+		struct cmd_struct *cmds, int num_cmds, enum program prog)
 {
 	const char *cmd = argv[0];
 	int i;
@@ -134,6 +137,6 @@ void main_handle_internal_command(int argc, const char **argv, void *ctx,
 		struct cmd_struct *p = cmds+i;
 		if (strcmp(p->cmd, cmd))
 			continue;
-		exit(run_builtin(p, argc, argv, ctx));
+		exit(run_builtin(p, argc, argv, ctx, prog));
 	}
 }
diff --git a/util/main.h b/util/main.h
index d61d10c79630..35fb33e63049 100644
--- a/util/main.h
+++ b/util/main.h
@@ -17,15 +17,26 @@
 #ifndef __MAIN_H__
 #define __MAIN_H__
 
+enum program {
+	PROG_NDCTL,
+	PROG_DAXCTL,
+};
+
+struct ndctl_ctx;
+struct daxctl_ctx;
+
 struct cmd_struct {
 	const char *cmd;
-	int (*fn)(int, const char **, void *ctx);
+	union {
+		int (*n_fn)(int, const char **, struct ndctl_ctx *ctx);
+		int (*d_fn)(int, const char **, struct daxctl_ctx *ctx);
+	};
 };
 
 int main_handle_options(const char ***argv, int *argc, const char *usage_msg,
 		struct cmd_struct *cmds, int num_cmds);
 void main_handle_internal_command(int argc, const char **argv, void *ctx,
-		struct cmd_struct *cmds, int num_cmds);
+		struct cmd_struct *cmds, int num_cmds, enum program prog);
 int help_show_man_page(const char *cmd, const char *util_name,
 		const char *viewer);
 #endif /* __MAIN_H__ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
