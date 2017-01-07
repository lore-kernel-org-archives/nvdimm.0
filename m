Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B5056817B1
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jan 2017 17:46:18 -0800 (PST)
Subject: [ndctl PATCH 1/7] ndctl,
 daxctl: refactor main boilerplate for a new 'daxctl' utility
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 06 Jan 2017 17:42:11 -0800
Message-ID: <148375333167.38836.6539434328188570516.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Prepare the generic command infrastructure for reuse with daxctl.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am                       |    2 
 ndctl/Makefile.am                 |    1 
 ndctl/builtin-bat.c               |    2 
 ndctl/builtin-create-nfit.c       |    2 
 ndctl/builtin-dimm.c              |   14 ++-
 ndctl/builtin-list.c              |    2 
 ndctl/builtin-test.c              |    2 
 ndctl/builtin-xable-region.c      |    4 -
 ndctl/builtin-xaction-namespace.c |    8 +-
 ndctl/builtin.h                   |   36 ++++----
 ndctl/ndctl.c                     |  160 +++++++++----------------------------
 test/device-dax.c                 |    2 
 util/help.c                       |   44 ++--------
 util/main.c                       |  123 ++++++++++++++++++++++++++++
 util/main.h                       |   10 ++
 15 files changed, 219 insertions(+), 193 deletions(-)
 rename ndctl/builtin-help.c => util/help.c (73%)
 create mode 100644 util/main.c
 create mode 100644 util/main.h

diff --git a/Makefile.am b/Makefile.am
index 9eb396639efe..01caca803540 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -64,6 +64,8 @@ libutil_a_SOURCES = \
 	util/parse-options.h \
 	util/usage.c \
 	util/size.c \
+	util/main.c \
+	util/help.c \
 	util/strbuf.c \
 	util/wrapper.c \
 	util/filter.c
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 2d0d8eb40841..f03647ae9d99 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -10,7 +10,6 @@ ndctl_SOURCES = ndctl.c \
 		 ../util/log.c \
 		builtin-list.c \
 		builtin-test.c \
-		builtin-help.c \
 		util/json.c
 
 if ENABLE_SMART
diff --git a/ndctl/builtin-bat.c b/ndctl/builtin-bat.c
index 48b41dab6d92..5e14d39cfac5 100644
--- a/ndctl/builtin-bat.c
+++ b/ndctl/builtin-bat.c
@@ -4,7 +4,7 @@
 #include <limits.h>
 #include <util/parse-options.h>
 
-int cmd_bat(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_bat(int argc, const char **argv, void *ctx)
 {
 	int loglevel = LOG_DEBUG, i, rc;
 	struct ndctl_test *test;
diff --git a/ndctl/builtin-create-nfit.c b/ndctl/builtin-create-nfit.c
index 780bb84580f5..ebcd7446d14f 100644
--- a/ndctl/builtin-create-nfit.c
+++ b/ndctl/builtin-create-nfit.c
@@ -164,7 +164,7 @@ static int write_nfit(struct nfit *nfit, const char *file, int force)
 }
 
 struct ndctl_ctx;
-int cmd_create_nfit(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_create_nfit(int argc, const char **argv, void *ctx)
 {
 	int i, rc = -ENXIO, force = 0;
 	const char * const u[] = {
diff --git a/ndctl/builtin-dimm.c b/ndctl/builtin-dimm.c
index 4c433d56dfe3..8a041cee8cab 100644
--- a/ndctl/builtin-dimm.c
+++ b/ndctl/builtin-dimm.c
@@ -772,7 +772,7 @@ static const struct option init_options[] = {
 	OPT_END(),
 };
 
-static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
+static int dimm_action(int argc, const char **argv, void *ctx,
 		int (*action)(struct ndctl_dimm *dimm, struct action_context *actx),
 		const struct option *options, const char *usage)
 {
@@ -874,7 +874,7 @@ static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
 	return count;
 }
 
-int cmd_read_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_read_labels(int argc, const char **argv, void *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_read, read_options,
 			"ndctl read-labels <nmem0> [<nmem1>..<nmemN>] [-o <filename>]");
@@ -884,7 +884,7 @@ int cmd_read_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
-int cmd_zero_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_zero_labels(int argc, const char **argv, void *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_zero, base_options,
 			"ndctl zero-labels <nmem0> [<nmem1>..<nmemN>] [<options>]");
@@ -894,7 +894,7 @@ int cmd_zero_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
-int cmd_init_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_init_labels(int argc, const char **argv, void *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_init, init_options,
 			"ndctl init-labels <nmem0> [<nmem1>..<nmemN>] [<options>]");
@@ -904,7 +904,7 @@ int cmd_init_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
-int cmd_check_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_check_labels(int argc, const char **argv, void *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_check, base_options,
 			"ndctl check-labels <nmem0> [<nmem1>..<nmemN>] [<options>]");
@@ -914,7 +914,7 @@ int cmd_check_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
-int cmd_disable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_disable_dimm(int argc, const char **argv, void *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_disable, base_options,
 			"ndctl disable-dimm <nmem0> [<nmem1>..<nmemN>] [<options>]");
@@ -924,7 +924,7 @@ int cmd_disable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
-int cmd_enable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_enable_dimm(int argc, const char **argv, void *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_enable, base_options,
 			"ndctl enable-dimm <nmem0> [<nmem1>..<nmemN>] [<options>]");
diff --git a/ndctl/builtin-list.c b/ndctl/builtin-list.c
index 1486cb1dedc3..caafec8b8f39 100644
--- a/ndctl/builtin-list.c
+++ b/ndctl/builtin-list.c
@@ -188,7 +188,7 @@ static int num_list_flags(void)
 	return list.buses + list.dimms + list.regions + list.namespaces;
 }
 
-int cmd_list(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_list(int argc, const char **argv, void *ctx)
 {
 	const struct option options[] = {
 		OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
diff --git a/ndctl/builtin-test.c b/ndctl/builtin-test.c
index caa666b68e69..01ff981749fc 100644
--- a/ndctl/builtin-test.c
+++ b/ndctl/builtin-test.c
@@ -14,7 +14,7 @@ static char *result(int rc)
 		return "PASS";
 }
 
-int cmd_test(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_test(int argc, const char **argv, void *ctx)
 {
 	struct ndctl_test *test;
 	int loglevel = LOG_DEBUG, i, rc;
diff --git a/ndctl/builtin-xable-region.c b/ndctl/builtin-xable-region.c
index 41f465a4543f..50cbdef5b339 100644
--- a/ndctl/builtin-xable-region.c
+++ b/ndctl/builtin-xable-region.c
@@ -64,7 +64,7 @@ static int do_xable_region(const char *region_arg,
 	return rc;
 }
 
-int cmd_disable_region(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_disable_region(int argc, const char **argv, void *ctx)
 {
 	char *xable_usage = "ndctl disable-region <region> [<options>]";
 	const char *region = parse_region_options(argc, argv, xable_usage);
@@ -85,7 +85,7 @@ int cmd_disable_region(int argc, const char **argv, struct ndctl_ctx *ctx)
 	}
 }
 
-int cmd_enable_region(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_enable_region(int argc, const char **argv, void *ctx)
 {
 	char *xable_usage = "ndctl enable-region <region> [<options>]";
 	const char *region = parse_region_options(argc, argv, xable_usage);
diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 8257eb9cd65e..f7a4e5b74a16 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -781,7 +781,7 @@ static int do_xaction_namespace(const char *namespace,
 	return rc;
 }
 
-int cmd_disable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_disable_namespace(int argc, const char **argv, void *ctx)
 {
 	char *xable_usage = "ndctl disable-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
@@ -802,7 +802,7 @@ int cmd_disable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
 	}
 }
 
-int cmd_enable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_enable_namespace(int argc, const char **argv, void *ctx)
 {
 	char *xable_usage = "ndctl enable-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
@@ -823,7 +823,7 @@ int cmd_enable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
 	}
 }
 
-int cmd_create_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_create_namespace(int argc, const char **argv, void *ctx)
 {
 	char *xable_usage = "ndctl create-namespace [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
@@ -853,7 +853,7 @@ int cmd_create_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
 	return 0;
 }
 
-int cmd_destroy_namespace(int argc , const char **argv, struct ndctl_ctx *ctx)
+int cmd_destroy_namespace(int argc , const char **argv, void *ctx)
 {
 	char *xable_usage = "ndctl destroy-namespace <namespace> [<options>]";
 	const char *namespace = parse_namespace_options(argc, argv,
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index 0293335c127e..9b66196450fd 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -3,31 +3,29 @@
 extern const char ndctl_usage_string[];
 extern const char ndctl_more_info_string[];
 
-struct ndctl_ctx;
 struct cmd_struct {
 	const char *cmd;
-	int (*fn)(int, const char **, struct ndctl_ctx *ctx);
+	int (*fn)(int, const char **, void *ctx);
 };
 
-int cmd_create_nfit(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_enable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_create_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_destroy_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_disable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_enable_region(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_disable_region(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_enable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_disable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_zero_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_read_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_init_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_check_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_list(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_help(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_create_nfit(int argc, const char **argv, void *ctx);
+int cmd_enable_namespace(int argc, const char **argv, void *ctx);
+int cmd_create_namespace(int argc, const char **argv, void *ctx);
+int cmd_destroy_namespace(int argc, const char **argv, void *ctx);
+int cmd_disable_namespace(int argc, const char **argv, void *ctx);
+int cmd_enable_region(int argc, const char **argv, void *ctx);
+int cmd_disable_region(int argc, const char **argv, void *ctx);
+int cmd_enable_dimm(int argc, const char **argv, void *ctx);
+int cmd_disable_dimm(int argc, const char **argv, void *ctx);
+int cmd_zero_labels(int argc, const char **argv, void *ctx);
+int cmd_read_labels(int argc, const char **argv, void *ctx);
+int cmd_init_labels(int argc, const char **argv, void *ctx);
+int cmd_check_labels(int argc, const char **argv, void *ctx);
+int cmd_list(int argc, const char **argv, void *ctx);
 #ifdef ENABLE_TEST
-int cmd_test(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_test(int argc, const char **argv, void *ctx);
 #endif
 #ifdef ENABLE_DESTRUCTIVE
-int cmd_bat(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_bat(int argc, const char **argv, void *ctx);
 #endif
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 4f000fe51fae..80a0491c440a 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -9,20 +9,47 @@
 #include <ndctl/libndctl.h>
 #include <ccan/array_size/array_size.h>
 
+#include <util/parse-options.h>
 #include <util/strbuf.h>
 #include <util/util.h>
+#include <util/main.h>
 
 const char ndctl_usage_string[] = "ndctl [--version] [--help] COMMAND [ARGS]";
 const char ndctl_more_info_string[] =
 	"See 'ndctl help COMMAND' for more information on a specific command.\n"
 	" ndctl --list-cmds to see all available commands";
 
-static int cmd_version(int argc, const char **argv, struct ndctl_ctx *ctx)
+static int cmd_version(int argc, const char **argv, void *ctx)
 {
 	printf("%s\n", VERSION);
 	return 0;
 }
 
+static int cmd_help(int argc, const char **argv, void *ctx)
+{
+	const char * const builtin_help_subcommands[] = {
+		"enable-region", "disable-region", "zero-labels",
+		"enable-namespace", "disable-namespace", NULL };
+	struct option builtin_help_options[] = {
+		OPT_END(),
+	};
+	const char *builtin_help_usage[] = {
+		"ndctl help [command]",
+		NULL
+	};
+
+	argc = parse_options_subcommand(argc, argv, builtin_help_options,
+			builtin_help_subcommands, builtin_help_usage, 0);
+
+	if (!argv[0]) {
+		printf("\n usage: %s\n\n", ndctl_usage_string);
+		printf("\n %s\n\n", ndctl_more_info_string);
+		return 0;
+	}
+
+	return help_show_man_page(argv[0], "ndctl", "NDCTL_MAN_VIEWER");
+}
+
 static struct cmd_struct commands[] = {
 	{ "version", cmd_version },
 	{ "create-nfit", cmd_create_nfit },
@@ -48,131 +75,16 @@ static struct cmd_struct commands[] = {
 	#endif
 };
 
-static int handle_options(const char ***argv, int *argc)
-{
-	int handled = 0;
-
-	while (*argc > 0) {
-		const char *cmd = (*argv)[0];
-		if (cmd[0] != '-')
-			break;
-
-		if (!strcmp(cmd, "--version") || !strcmp(cmd, "--help"))
-			break;
-
-		/*
-		 * Shortcut for '-h' and '-v' options to invoke help
-		 * and version command.
-		 */
-		if (!strcmp(cmd, "-h")) {
-			(*argv)[0] = "--help";
-			break;
-		}
-
-		if (!strcmp(cmd, "-v")) {
-			(*argv)[0] = "--version";
-			break;
-		}
-
-		if (!strcmp(cmd, "--list-cmds")) {
-			unsigned int i;
-
-			for (i = 0; i < ARRAY_SIZE(commands); i++) {
-				struct cmd_struct *p = commands+i;
-
-				/* filter out commands from auto-complete */
-				if (strcmp(p->cmd, "create-nfit") == 0)
-					continue;
-				if (strcmp(p->cmd, "test") == 0)
-					continue;
-				if (strcmp(p->cmd, "bat") == 0)
-					continue;
-				printf("%s\n", p->cmd);
-			}
-			exit(0);
-		} else {
-			fprintf(stderr, "Unknown option: %s\n", cmd);
-			usage(ndctl_usage_string);
-		}
-
-		(*argv)++;
-		(*argc)--;
-		handled++;
-	}
-	return handled;
-}
-
-static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
+int main(int argc, const char **argv)
 {
-	int status;
-	struct stat st;
 	struct ndctl_ctx *ctx;
+	int rc;
 
-	/*
-	 * Yes, establishing the ndctl context here makes this code less
-	 * generic, but it allows for unit testing the top level
-	 * interface to the built-in commands.
-	 */
-	status = ndctl_new(&ctx);
-	if (status)
-		return status;
-	status = p->fn(argc, argv, ctx);
-	ndctl_unref(ctx);
-
-	if (status)
-		return status & 0xff;
-
-	/* Somebody closed stdout? */
-	if (fstat(fileno(stdout), &st))
-		return 0;
-	/* Ignore write errors for pipes and sockets.. */
-	if (S_ISFIFO(st.st_mode) || S_ISSOCK(st.st_mode))
-		return 0;
-
-	status = 1;
-	/* Check for ENOSPC and EIO errors.. */
-	if (fflush(stdout)) {
-		fprintf(stderr, "write failure on standard output: %s", strerror(errno));
-		goto out;
-	}
-	if (ferror(stdout)) {
-		fprintf(stderr, "unknown write failure on standard output");
-		goto out;
-	}
-	if (fclose(stdout)) {
-		fprintf(stderr, "close failed on standard output: %s", strerror(errno));
-		goto out;
-	}
-	status = 0;
-out:
-	return status;
-}
-
-static void handle_internal_command(int argc, const char **argv)
-{
-	const char *cmd = argv[0];
-	unsigned int i;
-
-	/* Turn "ndctl cmd --help" into "ndctl help cmd" */
-	if (argc > 1 && !strcmp(argv[1], "--help")) {
-		argv[1] = argv[0];
-		argv[0] = cmd = "help";
-	}
-
-	for (i = 0; i < ARRAY_SIZE(commands); i++) {
-		struct cmd_struct *p = commands+i;
-		if (strcmp(p->cmd, cmd))
-			continue;
-		exit(run_builtin(p, argc, argv));
-	}
-}
-
-int main(int argc, const char **argv)
-{
 	/* Look for flags.. */
 	argv++;
 	argc--;
-	handle_options(&argv, &argc);
+	main_handle_options(&argv, &argc, ndctl_usage_string, commands,
+			ARRAY_SIZE(commands));
 
 	if (argc > 0) {
 		if (!prefixcmp(argv[0], "--"))
@@ -183,7 +95,13 @@ int main(int argc, const char **argv)
 		printf("\n %s\n\n", ndctl_more_info_string);
 		goto out;
 	}
-	handle_internal_command(argc, argv);
+
+	rc = ndctl_new(&ctx);
+	if (rc)
+		goto out;
+	main_handle_internal_command(argc, argv, ctx, commands,
+			ARRAY_SIZE(commands));
+	ndctl_unref(ctx);
 	fprintf(stderr, "Unknown command: '%s'\n", argv[0]);
 out:
 	return 1;
diff --git a/test/device-dax.c b/test/device-dax.c
index 75b17ed63088..0ace922ee55d 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -23,7 +23,7 @@
 
 static sigjmp_buf sj_env;
 
-static int create_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
+static int create_namespace(int argc, const char **argv, void *ctx)
 {
 	builtin_xaction_namespace_reset();
 	return cmd_create_namespace(argc, argv, ctx);
diff --git a/ndctl/builtin-help.c b/util/help.c
similarity index 73%
rename from ndctl/builtin-help.c
rename to util/help.c
index 14ad9d5738d0..310a40bd83e8 100644
--- a/ndctl/builtin-help.c
+++ b/util/help.c
@@ -56,16 +56,16 @@ static void exec_man_man(const char *path, const char *page)
 		strerror_r(errno, sbuf, sizeof(sbuf)));
 }
 
-static char *cmd_to_page(const char *ndctl_cmd, char **page)
+static char *cmd_to_page(const char *cmd, char **page, const char *util_name)
 {
 	int rc;
 
-	if (!ndctl_cmd)
-		rc = asprintf(page, "ndctl");
-	else if (!prefixcmp(ndctl_cmd, "ndctl"))
-		rc = asprintf(page, "%s", ndctl_cmd);
+	if (!cmd)
+		rc = asprintf(page, "%s", util_name);
+	else if (!prefixcmp(cmd, util_name))
+		rc = asprintf(page, "%s", cmd);
 	else
-		rc = asprintf(page, "ndctl-%s", ndctl_cmd);
+		rc = asprintf(page, "%s-%s", util_name, cmd);
 
 	if (rc < 0)
 		return NULL;
@@ -119,12 +119,13 @@ static void exec_viewer(const char *name, const char *page)
 		warning("'%s': unknown man viewer.", name);
 }
 
-static int show_man_page(const char *ndctl_cmd)
+int help_show_man_page(const char *cmd, const char *util_name,
+		const char *viewer)
 {
-	const char *fallback = getenv("NDCTL_MAN_VIEWER");
+	const char *fallback = getenv(viewer);
 	char *page;
 
-	page = cmd_to_page(ndctl_cmd, &page);
+	page = cmd_to_page(cmd, &page, util_name);
 	if (!page)
 		return -1;
 	setup_man_path();
@@ -136,28 +137,3 @@ static int show_man_page(const char *ndctl_cmd)
 	free(page);
 	return -1;
 }
-
-int cmd_help(int argc, const char **argv, struct ndctl_ctx *ctx)
-{
-	const char * const builtin_help_subcommands[] = {
-		"enable-region", "disable-region", "zero-labels",
-		"enable-namespace", "disable-namespace", NULL };
-	struct option builtin_help_options[] = {
-		OPT_END(),
-	};
-	const char *builtin_help_usage[] = {
-		"ndctl help [command]",
-		NULL
-	};
-
-	argc = parse_options_subcommand(argc, argv, builtin_help_options,
-			builtin_help_subcommands, builtin_help_usage, 0);
-
-	if (!argv[0]) {
-		printf("\n usage: %s\n\n", ndctl_usage_string);
-		printf("\n %s\n\n", ndctl_more_info_string);
-		return 0;
-	}
-
-	return show_man_page(argv[0]);
-}
diff --git a/util/main.c b/util/main.c
new file mode 100644
index 000000000000..cb3c634e93f5
--- /dev/null
+++ b/util/main.c
@@ -0,0 +1,123 @@
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <builtin.h>
+
+#include <util/strbuf.h>
+#include <util/util.h>
+
+int main_handle_options(const char ***argv, int *argc, const char *usage_msg,
+		struct cmd_struct *cmds, int num_cmds)
+{
+	int handled = 0;
+
+	while (*argc > 0) {
+		const char *cmd = (*argv)[0];
+		if (cmd[0] != '-')
+			break;
+
+		if (!strcmp(cmd, "--version") || !strcmp(cmd, "--help"))
+			break;
+
+		/*
+		 * Shortcut for '-h' and '-v' options to invoke help
+		 * and version command.
+		 */
+		if (!strcmp(cmd, "-h")) {
+			(*argv)[0] = "--help";
+			break;
+		}
+
+		if (!strcmp(cmd, "-v")) {
+			(*argv)[0] = "--version";
+			break;
+		}
+
+		if (!strcmp(cmd, "--list-cmds")) {
+			int i;
+
+			for (i = 0; i < num_cmds; i++) {
+				struct cmd_struct *p = cmds+i;
+
+				/* filter out commands from auto-complete */
+				if (strcmp(p->cmd, "create-nfit") == 0)
+					continue;
+				if (strcmp(p->cmd, "test") == 0)
+					continue;
+				if (strcmp(p->cmd, "bat") == 0)
+					continue;
+				printf("%s\n", p->cmd);
+			}
+			exit(0);
+		} else {
+			fprintf(stderr, "Unknown option: %s\n", cmd);
+			usage(usage_msg);
+		}
+
+		(*argv)++;
+		(*argc)--;
+		handled++;
+	}
+	return handled;
+}
+
+static int run_builtin(struct cmd_struct *p, int argc, const char **argv,
+		void *ctx)
+{
+	int status;
+	struct stat st;
+
+	status = p->fn(argc, argv, ctx);
+
+	if (status)
+		return status & 0xff;
+
+	/* Somebody closed stdout? */
+	if (fstat(fileno(stdout), &st))
+		return 0;
+	/* Ignore write errors for pipes and sockets.. */
+	if (S_ISFIFO(st.st_mode) || S_ISSOCK(st.st_mode))
+		return 0;
+
+	status = 1;
+	/* Check for ENOSPC and EIO errors.. */
+	if (fflush(stdout)) {
+		fprintf(stderr, "write failure on standard output: %s", strerror(errno));
+		goto out;
+	}
+	if (ferror(stdout)) {
+		fprintf(stderr, "unknown write failure on standard output");
+		goto out;
+	}
+	if (fclose(stdout)) {
+		fprintf(stderr, "close failed on standard output: %s", strerror(errno));
+		goto out;
+	}
+	status = 0;
+out:
+	return status;
+}
+
+void main_handle_internal_command(int argc, const char **argv, void *ctx,
+		struct cmd_struct *cmds, int num_cmds)
+{
+	const char *cmd = argv[0];
+	int i;
+
+	/* Turn "<binary> cmd --help" into "<binary> help cmd" */
+	if (argc > 1 && !strcmp(argv[1], "--help")) {
+		argv[1] = argv[0];
+		argv[0] = cmd = "help";
+	}
+
+	for (i = 0; i < num_cmds; i++) {
+		struct cmd_struct *p = cmds+i;
+		if (strcmp(p->cmd, cmd))
+			continue;
+		exit(run_builtin(p, argc, argv, ctx));
+	}
+}
diff --git a/util/main.h b/util/main.h
new file mode 100644
index 000000000000..bdd4f701665c
--- /dev/null
+++ b/util/main.h
@@ -0,0 +1,10 @@
+#ifndef __MAIN_H__
+#define __MAIN_H__
+struct cmd_struct;
+int main_handle_options(const char ***argv, int *argc, const char *usage_msg,
+		struct cmd_struct *cmds, int num_cmds);
+void main_handle_internal_command(int argc, const char **argv, void *ctx,
+		struct cmd_struct *cmds, int num_cmds);
+int help_show_man_page(const char *cmd, const char *util_name,
+		const char *viewer);
+#endif /* __MAIN_H__ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
