Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym01.jp.fujitsu.com (mgwym01.jp.fujitsu.com [211.128.242.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5178B2094609D
 for <linux-nvdimm@lists.01.org>; Sun,  6 May 2018 22:10:21 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 20204AC00D0
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 14:10:14 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH v6 1/4] ndctl, util: add OPTION_FILENAME to parse_opt_type
Date: Mon,  7 May 2018 14:09:23 +0900
Message-Id: <20180507050926.17243-2-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180507050926.17243-1-qi.fuli@jp.fujitsu.com>
References: <20180507050926.17243-1-qi.fuli@jp.fujitsu.com>
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

This patch borrows the OPTION_FILENAME from git to ndctl to make sure
filename is correct. Some related refactoring is also included:
  - adds parse_options_prefix() interface
  - moves is_absolute from util/help.c to util/util.c
  - adds a new file util/abspath.c

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 Makefile.am          |  3 ++-
 util/abspath.c       | 29 +++++++++++++++++++++++++++
 util/help.c          |  5 -----
 util/parse-options.c | 47 ++++++++++++++++++++++++++++++++++++++------
 util/parse-options.h | 11 +++++++++--
 util/util.h          |  7 +++++++
 6 files changed, 88 insertions(+), 14 deletions(-)
 create mode 100644 util/abspath.c

diff --git a/Makefile.am b/Makefile.am
index b538b1f..e0c463a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -69,6 +69,7 @@ libutil_a_SOURCES = \
 	util/strbuf.c \
 	util/wrapper.c \
 	util/filter.c \
-	util/bitmap.c
+	util/bitmap.c \
+	util/abspath.c
 
 nobase_include_HEADERS = daxctl/libdaxctl.h
diff --git a/util/abspath.c b/util/abspath.c
new file mode 100644
index 0000000..09bbd27
--- /dev/null
+++ b/util/abspath.c
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* originally copied from git/abspath.c */
+
+#include <util/util.h>
+#include <util/strbuf.h>
+
+char *prefix_filename(const char *pfx, const char *arg)
+{
+	struct strbuf path = STRBUF_INIT;
+	size_t pfx_len = pfx ? strlen(pfx) : 0;
+
+	if (!pfx_len)
+		;
+	else if (is_absolute_path(arg))
+		pfx_len = 0;
+	else
+		strbuf_add(&path, pfx, pfx_len);
+
+	strbuf_addstr(&path, arg);
+	return strbuf_detach(&path, NULL);
+}
+
+void fix_filename(const char *prefix, const char **file)
+{
+	if (!file || !*file || !prefix || is_absolute_path(*file)
+			|| !strcmp("-", *file))
+		return;
+	*file = prefix_filename(prefix, *file);
+}
diff --git a/util/help.c b/util/help.c
index 8b8f951..2d57fa1 100644
--- a/util/help.c
+++ b/util/help.c
@@ -89,11 +89,6 @@ static char *cmd_to_page(const char *cmd, char **page, const char *util_name)
 	return *page;
 }
 
-static int is_absolute_path(const char *path)
-{
-	return path[0] == '/';
-}
-
 static const char *system_path(const char *path)
 {
         static const char *prefix = PREFIX;
diff --git a/util/parse-options.c b/util/parse-options.c
index 751c091..c781174 100644
--- a/util/parse-options.c
+++ b/util/parse-options.c
@@ -55,6 +55,7 @@ static int get_value(struct parse_opt_ctx_t *p,
 {
 	const char *s, *arg = NULL;
 	const int unset = flags & OPT_UNSET;
+	int err;
 
 	if (unset && p->opt)
 		return opterror(opt, "takes no value", flags);
@@ -77,6 +78,7 @@ static int get_value(struct parse_opt_ctx_t *p,
 		case OPTION_ARGUMENT:
 		case OPTION_GROUP:
 		case OPTION_STRING:
+		case OPTION_FILENAME:
 		case OPTION_INTEGER:
 		case OPTION_UINTEGER:
 		case OPTION_LONG:
@@ -121,6 +123,19 @@ static int get_value(struct parse_opt_ctx_t *p,
 			return get_arg(p, opt, flags, (const char **)opt->value);
 		return 0;
 
+	case OPTION_FILENAME:
+		err = 0;
+		if (unset)
+			*(const char **)opt->value = NULL;
+		else if (opt->flags & PARSE_OPT_OPTARG && !p->opt)
+			*(const char **)opt->value = (const char *)opt->defval;
+		else
+			err = get_arg(p, opt, flags, (const char **)opt->value);
+
+		if (!err)
+			fix_filename(p->prefix, (const char **)opt->value);
+		return err;
+
 	case OPTION_CALLBACK:
 		if (unset)
 			return (*opt->callback)(opt, NULL, 1) ? (-1) : 0;
@@ -339,13 +354,14 @@ static void check_typos(const char *arg, const struct option *options)
 	}
 }
 
-void parse_options_start(struct parse_opt_ctx_t *ctx,
-			 int argc, const char **argv, int flags)
+void parse_options_start(struct parse_opt_ctx_t *ctx, int argc,
+			const char **argv, const char *prefix, int flags)
 {
 	memset(ctx, 0, sizeof(*ctx));
 	ctx->argc = argc - 1;
 	ctx->argv = argv + 1;
 	ctx->out  = argv;
+	ctx->prefix = prefix;
 	ctx->cpidx = ((flags & PARSE_OPT_KEEP_ARGV0) != 0);
 	ctx->flags = flags;
 	if ((flags & PARSE_OPT_KEEP_UNKNOWN) &&
@@ -453,8 +469,10 @@ int parse_options_end(struct parse_opt_ctx_t *ctx)
 	return ctx->cpidx + ctx->argc;
 }
 
-int parse_options_subcommand(int argc, const char **argv, const struct option *options,
-			const char *const subcommands[], const char *usagestr[], int flags)
+static int parse_options_subcommand_prefix(int argc, const char **argv,
+			const char *prefix, const struct option *options,
+			const char *const subcommands[],
+			const char *usagestr[], int flags)
 {
 	struct parse_opt_ctx_t ctx;
 
@@ -474,7 +492,7 @@ int parse_options_subcommand(int argc, const char **argv, const struct option *o
 		strbuf_release(&buf);
 	}
 
-	parse_options_start(&ctx, argc, argv, flags);
+	parse_options_start(&ctx, argc, argv, prefix, flags);
 	switch (parse_options_step(&ctx, options, usagestr)) {
 	case PARSE_OPT_HELP:
 		exit(129);
@@ -503,10 +521,26 @@ int parse_options_subcommand(int argc, const char **argv, const struct option *o
 	return parse_options_end(&ctx);
 }
 
+int parse_options_subcommand(int argc, const char **argv,
+		const struct option *options, const char *const subcommands[],
+		const char *usagestr[], int flags)
+{
+	return parse_options_subcommand_prefix(argc, argv, NULL, options,
+					subcommands, usagestr, flags);
+}
+
+int parse_options_prefix(int argc, const char **argv, const char *prefix,
+			const struct option *options,
+			const char * const usagestr[], int flags)
+{
+	return parse_options_subcommand_prefix(argc, argv, prefix, options,
+				NULL, (const char **) usagestr, flags);
+}
+
 int parse_options(int argc, const char **argv, const struct option *options,
 		  const char * const usagestr[], int flags)
 {
-	return parse_options_subcommand(argc, argv, options, NULL,
+	return parse_options_subcommand_prefix(argc, argv, NULL, options, NULL,
 					(const char **) usagestr, flags);
 }
 
@@ -557,6 +591,7 @@ static void print_option_help(const struct option *opts, int full)
 		if (opts->flags & PARSE_OPT_NOARG)
 			break;
 		/* FALLTHROUGH */
+	case OPTION_FILENAME:
 	case OPTION_STRING:
 		if (opts->argh) {
 			if (opts->flags & PARSE_OPT_OPTARG)
diff --git a/util/parse-options.h b/util/parse-options.h
index 6fd6b24..fc5015a 100644
--- a/util/parse-options.h
+++ b/util/parse-options.h
@@ -38,6 +38,7 @@ enum parse_opt_type {
 	OPTION_CALLBACK,
 	OPTION_U64,
 	OPTION_UINTEGER,
+	OPTION_FILENAME,
 };
 
 enum parse_opt_flags {
@@ -135,6 +136,7 @@ struct option {
 #define OPT_LONG(s, l, v, h)        { .type = OPTION_LONG, .short_name = (s), .long_name = (l), .value = check_vtype(v, long *), .help = (h) }
 #define OPT_U64(s, l, v, h)         { .type = OPTION_U64, .short_name = (s), .long_name = (l), .value = check_vtype(v, u64 *), .help = (h) }
 #define OPT_STRING(s, l, v, a, h)   { .type = OPTION_STRING,  .short_name = (s), .long_name = (l), .value = check_vtype(v, const char **), (a), .help = (h) }
+#define OPT_FILENAME(s, l, v, a, h) { .type = OPTION_FILENAME, .short_name = (s), .long_name = (l), .value = check_vtype(v, const char **), (a), .help = (h) }
 #define OPT_DATE(s, l, v, h) \
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), .argh = "time", .help = (h), .callback = parse_opt_approxidate_cb }
 #define OPT_CALLBACK(s, l, v, a, h, f) \
@@ -156,6 +158,10 @@ extern int parse_options(int argc, const char **argv,
                          const struct option *options,
                          const char * const usagestr[], int flags);
 
+extern int parse_options_prefix(int argc, const char **argv,
+			const char *prefix, const struct option *options,
+			const char * const usagestr[], int flags);
+
 extern int parse_options_subcommand(int argc, const char **argv,
 				const struct option *options,
 				const char *const subcommands[],
@@ -185,6 +191,7 @@ struct parse_opt_ctx_t {
 	int argc, cpidx;
 	const char *opt;
 	int flags;
+	const char *prefix;
 };
 
 extern int parse_options_usage(const char * const *usagestr,
@@ -192,8 +199,8 @@ extern int parse_options_usage(const char * const *usagestr,
 			       const char *optstr,
 			       bool short_opt);
 
-extern void parse_options_start(struct parse_opt_ctx_t *ctx,
-				int argc, const char **argv, int flags);
+extern void parse_options_start(struct parse_opt_ctx_t *ctx, int argc,
+			const char **argv, const char *prefix, int flags);
 
 extern int parse_options_step(struct parse_opt_ctx_t *ctx,
 			      const struct option *options,
diff --git a/util/util.h b/util/util.h
index 162aade..001707e 100644
--- a/util/util.h
+++ b/util/util.h
@@ -79,6 +79,11 @@ static inline const char *skip_prefix(const char *str, const char *prefix)
         return strncmp(str, prefix, len) ? NULL : str + len;
 }
 
+static inline int is_absolute_path(const char *path)
+{
+	return path[0] == '/';
+}
+
 void usage(const char *err) NORETURN;
 void die(const char *err, ...) NORETURN __attribute__((format (printf, 1, 2)));
 int error(const char *err, ...) __attribute__((format (printf, 1, 2)));
@@ -87,5 +92,7 @@ void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
 char *xstrdup(const char *str);
 void *xrealloc(void *ptr, size_t size);
 int prefixcmp(const char *str, const char *prefix);
+char *prefix_filename(const char *pfx, const char *arg);
+void fix_filename(const char *prefix, const char **file);
 
 #endif /* __UTIL_H__ */
-- 
2.17.0.140.g0b0cc9f86


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
