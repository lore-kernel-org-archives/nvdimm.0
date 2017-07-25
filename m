Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5664A21D28FEE
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 15:40:55 -0700 (PDT)
Subject: [PATCH 4/4] ndctl: switch to tools/lib/subcmd/
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 25 Jul 2017 15:36:32 -0700
Message-ID: <150102219199.2258.10699594100061482021.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150102217021.2258.1380624380896006.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150102217021.2258.1380624380896006.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Similar to perf, ndctl is based on the command and option-parsing
infrastructure that originated in git and has now been refactored into a
helper library in tools/lib/subcmd/.

For the time being ndctl just recompiles the same source that perf uses,
longer term we can look to unwind the use of autotools and switch to the
perf build system.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/lib/subcmd/parse-options.h |    1 
 tools/ndctl/Makefile.am          |   10 -
 tools/ndctl/Makefile.am.in       |    1 
 tools/ndctl/daxctl/daxctl.c      |    2 
 tools/ndctl/daxctl/list.c        |    4 
 tools/ndctl/ndctl/bat.c          |    4 
 tools/ndctl/ndctl/create-nfit.c  |    3 
 tools/ndctl/ndctl/dimm.c         |    3 
 tools/ndctl/ndctl/list.c         |    4 
 tools/ndctl/ndctl/namespace.c    |    5 
 tools/ndctl/ndctl/ndctl.c        |    2 
 tools/ndctl/ndctl/region.c       |    3 
 tools/ndctl/ndctl/test.c         |    4 
 tools/ndctl/nfit.h               |    1 
 tools/ndctl/util/help.c          |    4 
 tools/ndctl/util/parse-options.c |  697 --------------------------------------
 tools/ndctl/util/parse-options.h |  226 ------------
 17 files changed, 38 insertions(+), 936 deletions(-)
 delete mode 100644 tools/ndctl/util/parse-options.c
 delete mode 100644 tools/ndctl/util/parse-options.h

diff --git a/tools/lib/subcmd/parse-options.h b/tools/lib/subcmd/parse-options.h
index 11c3be3bcce7..37e2d1a6fc2a 100644
--- a/tools/lib/subcmd/parse-options.h
+++ b/tools/lib/subcmd/parse-options.h
@@ -1,6 +1,7 @@
 #ifndef __SUBCMD_PARSE_OPTIONS_H
 #define __SUBCMD_PARSE_OPTIONS_H
 
+#include <linux/kernel.h>
 #include <stdbool.h>
 #include <stdint.h>
 
diff --git a/tools/ndctl/Makefile.am b/tools/ndctl/Makefile.am
index 2803ec51a0b2..896647140104 100644
--- a/tools/ndctl/Makefile.am
+++ b/tools/ndctl/Makefile.am
@@ -56,9 +56,15 @@ libccan_a_SOURCES = \
 
 noinst_LIBRARIES += libutil.a
 libutil_a_SOURCES = \
+	../lib/subcmd/exec-cmd.c \
+	../lib/subcmd/help.c \
+	../lib/subcmd/pager.c \
+	../lib/subcmd/parse-options.c \
+	../lib/subcmd/run-command.c \
+	../lib/subcmd/sigchain.c \
+	../lib/subcmd/subcmd-config.c \
+	../lib/str_error_r.c \
 	../lib/find_bit.c \
-	util/parse-options.c \
-	util/parse-options.h \
 	util/usage.c \
 	util/size.c \
 	util/main.c \
diff --git a/tools/ndctl/Makefile.am.in b/tools/ndctl/Makefile.am.in
index 1680b738578d..a6b06870c6d5 100644
--- a/tools/ndctl/Makefile.am.in
+++ b/tools/ndctl/Makefile.am.in
@@ -10,6 +10,7 @@ AM_CPPFLAGS = \
 	-DPREFIX=\""$(prefix)"\" \
 	-DNDCTL_MAN_PATH=\""$(mandir)"\" \
 	-I${top_srcdir}/../include \
+	-I${top_srcdir}/../lib/ \
 	-I${top_srcdir}/ndctl/lib \
 	-I${top_srcdir}/ndctl \
 	-I${top_srcdir}/ \
diff --git a/tools/ndctl/daxctl/daxctl.c b/tools/ndctl/daxctl/daxctl.c
index e055d825d5e4..a33ad93082f6 100644
--- a/tools/ndctl/daxctl/daxctl.c
+++ b/tools/ndctl/daxctl/daxctl.c
@@ -23,7 +23,7 @@
 #include <sys/types.h>
 #include <util/kernel.h>
 #include <daxctl/libdaxctl.h>
-#include <util/parse-options.h>
+#include <subcmd/parse-options.h>
 
 #include <util/strbuf.h>
 #include <util/util.h>
diff --git a/tools/ndctl/daxctl/list.c b/tools/ndctl/daxctl/list.c
index 95fcaa2eb79c..18dbf335f3e0 100644
--- a/tools/ndctl/daxctl/list.c
+++ b/tools/ndctl/daxctl/list.c
@@ -15,12 +15,14 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <limits.h>
+#include <builtin.h>
 #include <util/json.h>
+#include <util/util.h>
 #include <util/filter.h>
 #include <util/kernel.h>
 #include <json-c/json.h>
 #include <daxctl/libdaxctl.h>
-#include <util/parse-options.h>
+#include <subcmd/parse-options.h>
 
 static struct {
 	bool devs;
diff --git a/tools/ndctl/ndctl/bat.c b/tools/ndctl/ndctl/bat.c
index 5e84f6459890..45f53d6187e5 100644
--- a/tools/ndctl/ndctl/bat.c
+++ b/tools/ndctl/ndctl/bat.c
@@ -14,7 +14,9 @@
 #include <syslog.h>
 #include <test.h>
 #include <limits.h>
-#include <util/parse-options.h>
+#include <builtin.h>
+#include <util/util.h>
+#include <subcmd/parse-options.h>
 
 int cmd_bat(int argc, const char **argv, void *ctx)
 {
diff --git a/tools/ndctl/ndctl/create-nfit.c b/tools/ndctl/ndctl/create-nfit.c
index fec3adfb5c70..cf1f6421aacc 100644
--- a/tools/ndctl/ndctl/create-nfit.c
+++ b/tools/ndctl/ndctl/create-nfit.c
@@ -20,8 +20,9 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <util/list.h>
-#include <util/parse-options.h>
+#include <subcmd/parse-options.h>
 #include <util/size.h>
+#include <util/util.h>
 
 #include <nfit.h>
 
diff --git a/tools/ndctl/ndctl/dimm.c b/tools/ndctl/ndctl/dimm.c
index 91bf7c53c3db..ae66e0ae7dfb 100644
--- a/tools/ndctl/ndctl/dimm.c
+++ b/tools/ndctl/ndctl/dimm.c
@@ -22,10 +22,11 @@
 #include <util/json.h>
 #include <util/filter.h>
 #include <json-c/json.h>
+#include <util/util.h>
 #include <util/kernel.h>
 #include <util/fletcher.h>
 #include <ndctl/libndctl.h>
-#include <util/parse-options.h>
+#include <subcmd/parse-options.h>
 #include <ccan/short_types/short_types.h>
 
 #include <ccan/endian/endian.h>
diff --git a/tools/ndctl/ndctl/list.c b/tools/ndctl/ndctl/list.c
index a4f9ef4a5eff..eb83ebb04aa8 100644
--- a/tools/ndctl/ndctl/list.c
+++ b/tools/ndctl/ndctl/list.c
@@ -15,12 +15,14 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <limits.h>
+#include <builtin.h>
+#include <util/util.h>
 #include <util/json.h>
 #include <util/kernel.h>
 #include <util/filter.h>
 #include <json-c/json.h>
 #include <ndctl/libndctl.h>
-#include <util/parse-options.h>
+#include <subcmd/parse-options.h>
 
 #ifdef HAVE_NDCTL_H
 #include <linux/ndctl.h>
diff --git a/tools/ndctl/ndctl/namespace.c b/tools/ndctl/ndctl/namespace.c
index 86f4405ec9e1..79769be4307a 100644
--- a/tools/ndctl/ndctl/namespace.c
+++ b/tools/ndctl/ndctl/namespace.c
@@ -17,17 +17,20 @@
 #include <unistd.h>
 #include <limits.h>
 #include <syslog.h>
+#include <builtin.h>
 #include <sys/stat.h>
 #include <uuid/uuid.h>
 #include <sys/types.h>
 #include <util/size.h>
 #include <util/json.h>
 #include <json-c/json.h>
+#include <util/util.h>
 #include <util/kernel.h>
 #include <util/filter.h>
 #include <ndctl/libndctl.h>
-#include <util/parse-options.h>
+#include <subcmd/parse-options.h>
 #include "check.h"
+#include "test.h"
 
 #ifdef HAVE_NDCTL_H
 #include <linux/ndctl.h>
diff --git a/tools/ndctl/ndctl/ndctl.c b/tools/ndctl/ndctl/ndctl.c
index c87752eccc8a..541aaa31c4c7 100644
--- a/tools/ndctl/ndctl/ndctl.c
+++ b/tools/ndctl/ndctl/ndctl.c
@@ -24,8 +24,8 @@
 #include <builtin.h>
 #include <ndctl/libndctl.h>
 
-#include <util/parse-options.h>
 #include <util/kernel.h>
+#include <subcmd/parse-options.h>
 #include <util/strbuf.h>
 #include <util/util.h>
 #include <util/main.h>
diff --git a/tools/ndctl/ndctl/region.c b/tools/ndctl/ndctl/region.c
index cc3c133c3190..a1d4c1d2410a 100644
--- a/tools/ndctl/ndctl/region.c
+++ b/tools/ndctl/ndctl/region.c
@@ -14,8 +14,9 @@
 #include <errno.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <util/util.h>
 #include <util/filter.h>
-#include <util/parse-options.h>
+#include <subcmd/parse-options.h>
 #include <ndctl/libndctl.h>
 
 static struct {
diff --git a/tools/ndctl/ndctl/test.c b/tools/ndctl/ndctl/test.c
index 285594f09cf2..f45180209ef7 100644
--- a/tools/ndctl/ndctl/test.c
+++ b/tools/ndctl/ndctl/test.c
@@ -14,7 +14,9 @@
 #include <limits.h>
 #include <syslog.h>
 #include <test.h>
-#include <util/parse-options.h>
+#include <builtin.h>
+#include <util/util.h>
+#include <subcmd/parse-options.h>
 
 static char *result(int rc)
 {
diff --git a/tools/ndctl/nfit.h b/tools/ndctl/nfit.h
index 9815d2143a9e..34705ebfb1cc 100644
--- a/tools/ndctl/nfit.h
+++ b/tools/ndctl/nfit.h
@@ -15,6 +15,7 @@
 #ifndef __NFIT_H__
 #define __NFIT_H__
 #include <stdint.h>
+#include <string.h>
 #include <linux/uuid.h>
 
 static inline void nfit_spa_uuid_pm(void *uuid)
diff --git a/tools/ndctl/util/help.c b/tools/ndctl/util/help.c
index 8b8f9510407f..da1e4f66bf13 100644
--- a/tools/ndctl/util/help.c
+++ b/tools/ndctl/util/help.c
@@ -21,12 +21,14 @@
  * Builtin help command
  */
 #include <stdio.h>
+#include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
 #include <errno.h>
 #include <builtin.h>
+#include <util/util.h>
 #include <util/strbuf.h>
-#include <util/parse-options.h>
+#include <subcmd/parse-options.h>
 
 #define pr_err(x, ...) fprintf(stderr, x, ##__VA_ARGS__)
 #define STRERR_BUFSIZE  128     /* For the buffer size of strerror_r */
diff --git a/tools/ndctl/util/parse-options.c b/tools/ndctl/util/parse-options.c
deleted file mode 100644
index 751c0916d3d3..000000000000
--- a/tools/ndctl/util/parse-options.c
+++ /dev/null
@@ -1,697 +0,0 @@
-/*
- * Copyright(c) 2007 Pierre Habouzit. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-/* originally copied from perf and git */
-
-#include <stdio.h>
-#include <string.h>
-#include <sys/types.h>
-
-#include <util/util.h>
-#include <util/strbuf.h>
-#include <util/parse-options.h>
-
-#define OPT_SHORT 1
-#define OPT_UNSET 2
-
-static int opterror(const struct option *opt, const char *reason, int flags)
-{
-	if (flags & OPT_SHORT)
-		return error("switch `%c' %s", opt->short_name, reason);
-	if (flags & OPT_UNSET)
-		return error("option `no-%s' %s", opt->long_name, reason);
-	return error("option `%s' %s", opt->long_name, reason);
-}
-
-static int get_arg(struct parse_opt_ctx_t *p, const struct option *opt,
-		   int flags, const char **arg)
-{
-	if (p->opt) {
-		*arg = p->opt;
-		p->opt = NULL;
-	} else if ((opt->flags & PARSE_OPT_LASTARG_DEFAULT) && (p->argc == 1 ||
-		    **(p->argv + 1) == '-')) {
-		*arg = (const char *)opt->defval;
-	} else if (p->argc > 1) {
-		p->argc--;
-		*arg = *++p->argv;
-	} else
-		return opterror(opt, "requires a value", flags);
-	return 0;
-}
-
-static int get_value(struct parse_opt_ctx_t *p,
-		     const struct option *opt, int flags)
-{
-	const char *s, *arg = NULL;
-	const int unset = flags & OPT_UNSET;
-
-	if (unset && p->opt)
-		return opterror(opt, "takes no value", flags);
-	if (unset && (opt->flags & PARSE_OPT_NONEG))
-		return opterror(opt, "isn't available", flags);
-
-	if (!(flags & OPT_SHORT) && p->opt) {
-		switch (opt->type) {
-		case OPTION_CALLBACK:
-			if (!(opt->flags & PARSE_OPT_NOARG))
-				break;
-			/* FALLTHROUGH */
-		case OPTION_BOOLEAN:
-		case OPTION_INCR:
-		case OPTION_BIT:
-		case OPTION_SET_UINT:
-		case OPTION_SET_PTR:
-			return opterror(opt, "takes no value", flags);
-		case OPTION_END:
-		case OPTION_ARGUMENT:
-		case OPTION_GROUP:
-		case OPTION_STRING:
-		case OPTION_INTEGER:
-		case OPTION_UINTEGER:
-		case OPTION_LONG:
-		case OPTION_U64:
-		default:
-			break;
-		}
-	}
-
-	switch (opt->type) {
-	case OPTION_BIT:
-		if (unset)
-			*(int *)opt->value &= ~opt->defval;
-		else
-			*(int *)opt->value |= opt->defval;
-		return 0;
-
-	case OPTION_BOOLEAN:
-		*(bool *)opt->value = unset ? false : true;
-		if (opt->set)
-			*(bool *)opt->set = true;
-		return 0;
-
-	case OPTION_INCR:
-		*(int *)opt->value = unset ? 0 : *(int *)opt->value + 1;
-		return 0;
-
-	case OPTION_SET_UINT:
-		*(unsigned int *)opt->value = unset ? 0 : opt->defval;
-		return 0;
-
-	case OPTION_SET_PTR:
-		*(void **)opt->value = unset ? NULL : (void *)opt->defval;
-		return 0;
-
-	case OPTION_STRING:
-		if (unset)
-			*(const char **)opt->value = NULL;
-		else if (opt->flags & PARSE_OPT_OPTARG && !p->opt)
-			*(const char **)opt->value = (const char *)opt->defval;
-		else
-			return get_arg(p, opt, flags, (const char **)opt->value);
-		return 0;
-
-	case OPTION_CALLBACK:
-		if (unset)
-			return (*opt->callback)(opt, NULL, 1) ? (-1) : 0;
-		if (opt->flags & PARSE_OPT_NOARG)
-			return (*opt->callback)(opt, NULL, 0) ? (-1) : 0;
-		if (opt->flags & PARSE_OPT_OPTARG && !p->opt)
-			return (*opt->callback)(opt, NULL, 0) ? (-1) : 0;
-		if (get_arg(p, opt, flags, &arg))
-			return -1;
-		return (*opt->callback)(opt, arg, 0) ? (-1) : 0;
-
-	case OPTION_INTEGER:
-		if (unset) {
-			*(int *)opt->value = 0;
-			return 0;
-		}
-		if (opt->flags & PARSE_OPT_OPTARG && !p->opt) {
-			*(int *)opt->value = opt->defval;
-			return 0;
-		}
-		if (get_arg(p, opt, flags, &arg))
-			return -1;
-		*(int *)opt->value = strtol(arg, (char **)&s, 10);
-		if (*s)
-			return opterror(opt, "expects a numerical value", flags);
-		return 0;
-
-	case OPTION_UINTEGER:
-		if (unset) {
-			*(unsigned int *)opt->value = 0;
-			return 0;
-		}
-		if (opt->flags & PARSE_OPT_OPTARG && !p->opt) {
-			*(unsigned int *)opt->value = opt->defval;
-			return 0;
-		}
-		if (get_arg(p, opt, flags, &arg))
-			return -1;
-		*(unsigned int *)opt->value = strtol(arg, (char **)&s, 10);
-		if (*s)
-			return opterror(opt, "expects a numerical value", flags);
-		return 0;
-
-	case OPTION_LONG:
-		if (unset) {
-			*(long *)opt->value = 0;
-			return 0;
-		}
-		if (opt->flags & PARSE_OPT_OPTARG && !p->opt) {
-			*(long *)opt->value = opt->defval;
-			return 0;
-		}
-		if (get_arg(p, opt, flags, &arg))
-			return -1;
-		*(long *)opt->value = strtol(arg, (char **)&s, 10);
-		if (*s)
-			return opterror(opt, "expects a numerical value", flags);
-		return 0;
-
-	case OPTION_U64:
-		if (unset) {
-			*(uint64_t *)opt->value = 0;
-			return 0;
-		}
-		if (opt->flags & PARSE_OPT_OPTARG && !p->opt) {
-			*(uint64_t *)opt->value = opt->defval;
-			return 0;
-		}
-		if (get_arg(p, opt, flags, &arg))
-			return -1;
-		*(uint64_t *)opt->value = strtoull(arg, (char **)&s, 10);
-		if (*s)
-			return opterror(opt, "expects a numerical value", flags);
-		return 0;
-
-	case OPTION_END:
-	case OPTION_ARGUMENT:
-	case OPTION_GROUP:
-	default:
-		die("should not happen, someone must be hit on the forehead");
-	}
-}
-
-static int parse_short_opt(struct parse_opt_ctx_t *p, const struct option *options)
-{
-	for (; options->type != OPTION_END; options++) {
-		if (options->short_name == *p->opt) {
-			p->opt = p->opt[1] ? p->opt + 1 : NULL;
-			return get_value(p, options, OPT_SHORT);
-		}
-	}
-	return -2;
-}
-
-static int parse_long_opt(struct parse_opt_ctx_t *p, const char *arg,
-                          const struct option *options)
-{
-	const char *arg_end = strchr(arg, '=');
-	const struct option *abbrev_option = NULL, *ambiguous_option = NULL;
-	int abbrev_flags = 0, ambiguous_flags = 0;
-
-	if (!arg_end)
-		arg_end = arg + strlen(arg);
-
-	for (; options->type != OPTION_END; options++) {
-		const char *rest;
-		int flags = 0;
-
-		if (!options->long_name)
-			continue;
-
-		rest = skip_prefix(arg, options->long_name);
-		if (options->type == OPTION_ARGUMENT) {
-			if (!rest)
-				continue;
-			if (*rest == '=')
-				return opterror(options, "takes no value", flags);
-			if (*rest)
-				continue;
-			p->out[p->cpidx++] = arg - 2;
-			return 0;
-		}
-		if (!rest) {
-			if (!prefixcmp(options->long_name, "no-")) {
-				/*
-				 * The long name itself starts with "no-", so
-				 * accept the option without "no-" so that users
-				 * do not have to enter "no-no-" to get the
-				 * negation.
-				 */
-				rest = skip_prefix(arg, options->long_name + 3);
-				if (rest) {
-					flags |= OPT_UNSET;
-					goto match;
-				}
-				/* Abbreviated case */
-				if (!prefixcmp(options->long_name + 3, arg)) {
-					flags |= OPT_UNSET;
-					goto is_abbreviated;
-				}
-			}
-			/* abbreviated? */
-			if (!strncmp(options->long_name, arg, arg_end - arg)) {
-is_abbreviated:
-				if (abbrev_option) {
-					/*
-					 * If this is abbreviated, it is
-					 * ambiguous. So when there is no
-					 * exact match later, we need to
-					 * error out.
-					 */
-					ambiguous_option = abbrev_option;
-					ambiguous_flags = abbrev_flags;
-				}
-				if (!(flags & OPT_UNSET) && *arg_end)
-					p->opt = arg_end + 1;
-				abbrev_option = options;
-				abbrev_flags = flags;
-				continue;
-			}
-			/* negated and abbreviated very much? */
-			if (!prefixcmp("no-", arg)) {
-				flags |= OPT_UNSET;
-				goto is_abbreviated;
-			}
-			/* negated? */
-			if (strncmp(arg, "no-", 3))
-				continue;
-			flags |= OPT_UNSET;
-			rest = skip_prefix(arg + 3, options->long_name);
-			/* abbreviated and negated? */
-			if (!rest && !prefixcmp(options->long_name, arg + 3))
-				goto is_abbreviated;
-			if (!rest)
-				continue;
-		}
-match:
-		if (*rest) {
-			if (*rest != '=')
-				continue;
-			p->opt = rest + 1;
-		}
-		return get_value(p, options, flags);
-	}
-
-	if (ambiguous_option)
-		return error("Ambiguous option: %s "
-			"(could be --%s%s or --%s%s)",
-			arg,
-			(ambiguous_flags & OPT_UNSET) ?  "no-" : "",
-			ambiguous_option->long_name,
-			(abbrev_flags & OPT_UNSET) ?  "no-" : "",
-			abbrev_option->long_name);
-	if (abbrev_option)
-		return get_value(p, abbrev_option, abbrev_flags);
-	return -2;
-}
-
-static void check_typos(const char *arg, const struct option *options)
-{
-	if (strlen(arg) < 3)
-		return;
-
-	if (!prefixcmp(arg, "no-")) {
-		error ("did you mean `--%s` (with two dashes ?)", arg);
-		exit(129);
-	}
-
-	for (; options->type != OPTION_END; options++) {
-		if (!options->long_name)
-			continue;
-		if (!prefixcmp(options->long_name, arg)) {
-			error ("did you mean `--%s` (with two dashes ?)", arg);
-			exit(129);
-		}
-	}
-}
-
-void parse_options_start(struct parse_opt_ctx_t *ctx,
-			 int argc, const char **argv, int flags)
-{
-	memset(ctx, 0, sizeof(*ctx));
-	ctx->argc = argc - 1;
-	ctx->argv = argv + 1;
-	ctx->out  = argv;
-	ctx->cpidx = ((flags & PARSE_OPT_KEEP_ARGV0) != 0);
-	ctx->flags = flags;
-	if ((flags & PARSE_OPT_KEEP_UNKNOWN) &&
-	    (flags & PARSE_OPT_STOP_AT_NON_OPTION))
-		die("STOP_AT_NON_OPTION and KEEP_UNKNOWN don't go together");
-}
-
-static int usage_with_options_internal(const char * const *,
-				       const struct option *, int);
-
-int parse_options_step(struct parse_opt_ctx_t *ctx,
-		       const struct option *options,
-		       const char * const usagestr[])
-{
-	int internal_help = !(ctx->flags & PARSE_OPT_NO_INTERNAL_HELP);
-
-	/* we must reset ->opt, unknown short option leave it dangling */
-	ctx->opt = NULL;
-
-	for (; ctx->argc; ctx->argc--, ctx->argv++) {
-		const char *arg = ctx->argv[0];
-
-		if (*arg != '-' || !arg[1]) {
-			if (ctx->flags & PARSE_OPT_STOP_AT_NON_OPTION)
-				break;
-			ctx->out[ctx->cpidx++] = ctx->argv[0];
-			continue;
-		}
-
-		if (arg[1] != '-') {
-			ctx->opt = arg + 1;
-			if (internal_help && *ctx->opt == 'h')
-				return usage_with_options_internal(usagestr, options, 0);
-			switch (parse_short_opt(ctx, options)) {
-			case -1:
-				return parse_options_usage(usagestr, options, arg + 1, 1);
-			case -2:
-				goto unknown;
-			default:
-				break;
-			}
-			if (ctx->opt)
-				check_typos(arg + 1, options);
-			while (ctx->opt) {
-				if (internal_help && *ctx->opt == 'h')
-					return usage_with_options_internal(usagestr, options, 0);
-				arg = ctx->opt;
-				switch (parse_short_opt(ctx, options)) {
-				case -1:
-					return parse_options_usage(usagestr, options, arg, 1);
-				case -2:
-					/* fake a short option thing to hide the fact that we may have
-					 * started to parse aggregated stuff
-					 *
-					 * This is leaky, too bad.
-					 */
-					ctx->argv[0] = strdup(ctx->opt - 1);
-					*(char *)ctx->argv[0] = '-';
-					goto unknown;
-				default:
-					break;
-				}
-			}
-			continue;
-		}
-
-		if (!arg[2]) { /* "--" */
-			if (!(ctx->flags & PARSE_OPT_KEEP_DASHDASH)) {
-				ctx->argc--;
-				ctx->argv++;
-			}
-			break;
-		}
-
-		if (internal_help && !strcmp(arg + 2, "help-all"))
-			return usage_with_options_internal(usagestr, options, 1);
-		if (internal_help && !strcmp(arg + 2, "help"))
-			return usage_with_options_internal(usagestr, options, 0);
-		if (!strcmp(arg + 2, "list-opts"))
-			return PARSE_OPT_LIST_OPTS;
-		if (!strcmp(arg + 2, "list-cmds"))
-			return PARSE_OPT_LIST_SUBCMDS;
-		switch (parse_long_opt(ctx, arg + 2, options)) {
-		case -1:
-			return parse_options_usage(usagestr, options, arg + 2, 0);
-		case -2:
-			goto unknown;
-		default:
-			break;
-		}
-		continue;
-unknown:
-		if (!(ctx->flags & PARSE_OPT_KEEP_UNKNOWN))
-			return PARSE_OPT_UNKNOWN;
-		ctx->out[ctx->cpidx++] = ctx->argv[0];
-		ctx->opt = NULL;
-	}
-	return PARSE_OPT_DONE;
-}
-
-int parse_options_end(struct parse_opt_ctx_t *ctx)
-{
-	memmove(ctx->out + ctx->cpidx, ctx->argv, ctx->argc * sizeof(*ctx->out));
-	ctx->out[ctx->cpidx + ctx->argc] = NULL;
-	return ctx->cpidx + ctx->argc;
-}
-
-int parse_options_subcommand(int argc, const char **argv, const struct option *options,
-			const char *const subcommands[], const char *usagestr[], int flags)
-{
-	struct parse_opt_ctx_t ctx;
-
-	/* build usage string if it's not provided */
-	if (subcommands && !usagestr[0]) {
-		struct strbuf buf = STRBUF_INIT;
-
-		strbuf_addf(&buf, "ndctl %s [<options>] {", argv[0]);
-		for (int i = 0; subcommands[i]; i++) {
-			if (i)
-				strbuf_addstr(&buf, "|");
-			strbuf_addstr(&buf, subcommands[i]);
-		}
-		strbuf_addstr(&buf, "}");
-
-		usagestr[0] = strdup(buf.buf);
-		strbuf_release(&buf);
-	}
-
-	parse_options_start(&ctx, argc, argv, flags);
-	switch (parse_options_step(&ctx, options, usagestr)) {
-	case PARSE_OPT_HELP:
-		exit(129);
-	case PARSE_OPT_DONE:
-		break;
-	case PARSE_OPT_LIST_OPTS:
-		while (options->type != OPTION_END) {
-			printf("--%s ", options->long_name);
-			options++;
-		}
-		exit(130);
-	case PARSE_OPT_LIST_SUBCMDS:
-		if (subcommands)
-			for (int i = 0; subcommands[i]; i++)
-				printf("%s ", subcommands[i]);
-		exit(130);
-	default: /* PARSE_OPT_UNKNOWN */
-		if (ctx.argv[0][1] == '-') {
-			error("unknown option `%s'", ctx.argv[0] + 2);
-		} else {
-			error("unknown switch `%c'", *ctx.opt);
-		}
-		usage_with_options(usagestr, options);
-	}
-
-	return parse_options_end(&ctx);
-}
-
-int parse_options(int argc, const char **argv, const struct option *options,
-		  const char * const usagestr[], int flags)
-{
-	return parse_options_subcommand(argc, argv, options, NULL,
-					(const char **) usagestr, flags);
-}
-
-#define USAGE_OPTS_WIDTH 24
-#define USAGE_GAP         2
-
-static void print_option_help(const struct option *opts, int full)
-{
-	size_t pos;
-	int pad;
-
-	if (opts->type == OPTION_GROUP) {
-		fputc('\n', stderr);
-		if (*opts->help)
-			fprintf(stderr, "%s\n", opts->help);
-		return;
-	}
-	if (!full && (opts->flags & PARSE_OPT_HIDDEN))
-		return;
-
-	pos = fprintf(stderr, "    ");
-	if (opts->short_name)
-		pos += fprintf(stderr, "-%c", opts->short_name);
-	else
-		pos += fprintf(stderr, "    ");
-
-	if (opts->long_name && opts->short_name)
-		pos += fprintf(stderr, ", ");
-	if (opts->long_name)
-		pos += fprintf(stderr, "--%s", opts->long_name);
-
-	switch (opts->type) {
-	case OPTION_ARGUMENT:
-		break;
-	case OPTION_LONG:
-	case OPTION_U64:
-	case OPTION_INTEGER:
-	case OPTION_UINTEGER:
-		if (opts->flags & PARSE_OPT_OPTARG)
-			if (opts->long_name)
-				pos += fprintf(stderr, "[=<n>]");
-			else
-				pos += fprintf(stderr, "[<n>]");
-		else
-			pos += fprintf(stderr, " <n>");
-		break;
-	case OPTION_CALLBACK:
-		if (opts->flags & PARSE_OPT_NOARG)
-			break;
-		/* FALLTHROUGH */
-	case OPTION_STRING:
-		if (opts->argh) {
-			if (opts->flags & PARSE_OPT_OPTARG)
-				if (opts->long_name)
-					pos += fprintf(stderr, "[=<%s>]", opts->argh);
-				else
-					pos += fprintf(stderr, "[<%s>]", opts->argh);
-			else
-				pos += fprintf(stderr, " <%s>", opts->argh);
-		} else {
-			if (opts->flags & PARSE_OPT_OPTARG)
-				if (opts->long_name)
-					pos += fprintf(stderr, "[=...]");
-				else
-					pos += fprintf(stderr, "[...]");
-			else
-				pos += fprintf(stderr, " ...");
-		}
-		break;
-	default: /* OPTION_{BIT,BOOLEAN,SET_UINT,SET_PTR} */
-	case OPTION_END:
-	case OPTION_GROUP:
-	case OPTION_BIT:
-	case OPTION_BOOLEAN:
-	case OPTION_INCR:
-	case OPTION_SET_UINT:
-	case OPTION_SET_PTR:
-		break;
-	}
-
-	if (pos <= USAGE_OPTS_WIDTH)
-		pad = USAGE_OPTS_WIDTH - pos;
-	else {
-		fputc('\n', stderr);
-		pad = USAGE_OPTS_WIDTH;
-	}
-	fprintf(stderr, "%*s%s\n", pad + USAGE_GAP, "", opts->help);
-}
-
-int usage_with_options_internal(const char * const *usagestr,
-				const struct option *opts, int full)
-{
-	if (!usagestr)
-		return PARSE_OPT_HELP;
-
-	fprintf(stderr, "\n usage: %s\n", *usagestr++);
-	while (*usagestr && **usagestr)
-		fprintf(stderr, "    or: %s\n", *usagestr++);
-	while (*usagestr) {
-		fprintf(stderr, "%s%s\n",
-				**usagestr ? "    " : "",
-				*usagestr);
-		usagestr++;
-	}
-
-	if (opts->type != OPTION_GROUP)
-		fputc('\n', stderr);
-
-	for (  ; opts->type != OPTION_END; opts++)
-		print_option_help(opts, full);
-
-	fputc('\n', stderr);
-
-	return PARSE_OPT_HELP;
-}
-
-void usage_with_options(const char * const *usagestr,
-			const struct option *opts)
-{
-	usage_with_options_internal(usagestr, opts, 0);
-	exit(129);
-}
-
-int parse_options_usage(const char * const *usagestr,
-			const struct option *opts,
-			const char *optstr, bool short_opt)
-{
-	if (!usagestr)
-		goto opt;
-
-	fprintf(stderr, "\n usage: %s\n", *usagestr++);
-	while (*usagestr && **usagestr)
-		fprintf(stderr, "    or: %s\n", *usagestr++);
-	while (*usagestr) {
-		fprintf(stderr, "%s%s\n",
-				**usagestr ? "    " : "",
-				*usagestr);
-		usagestr++;
-	}
-	fputc('\n', stderr);
-
-opt:
-	for (  ; opts->type != OPTION_END; opts++) {
-		if (short_opt) {
-			if (opts->short_name == *optstr)
-				break;
-			continue;
-		}
-
-		if (opts->long_name == NULL)
-			continue;
-
-		if (!prefixcmp(optstr, opts->long_name))
-			break;
-		if (!prefixcmp(optstr, "no-") &&
-		    !prefixcmp(optstr + 3, opts->long_name))
-			break;
-	}
-
-	if (opts->type != OPTION_END)
-		print_option_help(opts, 0);
-
-	return PARSE_OPT_HELP;
-}
-
-
-int parse_opt_verbosity_cb(const struct option *opt,
-			   const char *arg __maybe_unused,
-			   int unset)
-{
-	int *target = opt->value;
-
-	if (unset)
-		/* --no-quiet, --no-verbose */
-		*target = 0;
-	else if (opt->short_name == 'v') {
-		if (*target >= 0)
-			(*target)++;
-		else
-			*target = 1;
-	} else {
-		if (*target <= 0)
-			(*target)--;
-		else
-			*target = -1;
-	}
-	return 0;
-}
diff --git a/tools/ndctl/util/parse-options.h b/tools/ndctl/util/parse-options.h
deleted file mode 100644
index bd7cc658a4bd..000000000000
--- a/tools/ndctl/util/parse-options.h
+++ /dev/null
@@ -1,226 +0,0 @@
-/*
- * Copyright(c) 2007 Pierre Habouzit. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-/* originally copied from perf and git */
-
-#ifndef __NDCTL_PARSE_OPTIONS_H
-#define __NDCTL_PARSE_OPTIONS_H
-
-#include <stdbool.h>
-#include <stdint.h>
-#include <util/util.h>
-#include <util/kernel.h>
-
-enum parse_opt_type {
-	/* special types */
-	OPTION_END,
-	OPTION_ARGUMENT,
-	OPTION_GROUP,
-	/* options with no arguments */
-	OPTION_BIT,
-	OPTION_BOOLEAN,
-	OPTION_INCR,
-	OPTION_SET_UINT,
-	OPTION_SET_PTR,
-	/* options with arguments (usually) */
-	OPTION_STRING,
-	OPTION_INTEGER,
-	OPTION_LONG,
-	OPTION_CALLBACK,
-	OPTION_U64,
-	OPTION_UINTEGER,
-};
-
-enum parse_opt_flags {
-	PARSE_OPT_KEEP_DASHDASH = 1,
-	PARSE_OPT_STOP_AT_NON_OPTION = 2,
-	PARSE_OPT_KEEP_ARGV0 = 4,
-	PARSE_OPT_KEEP_UNKNOWN = 8,
-	PARSE_OPT_NO_INTERNAL_HELP = 16,
-};
-
-enum parse_opt_option_flags {
-	PARSE_OPT_OPTARG  = 1,
-	PARSE_OPT_NOARG   = 2,
-	PARSE_OPT_NONEG   = 4,
-	PARSE_OPT_HIDDEN  = 8,
-	PARSE_OPT_LASTARG_DEFAULT = 16,
-};
-
-struct option;
-typedef int parse_opt_cb(const struct option *, const char *arg, int unset);
-
-/*
- * `type`::
- *   holds the type of the option, you must have an OPTION_END last in your
- *   array.
- *
- * `short_name`::
- *   the character to use as a short option name, '\0' if none.
- *
- * `long_name`::
- *   the long option name, without the leading dashes, NULL if none.
- *
- * `value`::
- *   stores pointers to the values to be filled.
- *
- * `argh`::
- *   token to explain the kind of argument this option wants. Keep it
- *   homogenous across the repository.
- *
- * `help`::
- *   the short help associated to what the option does.
- *   Must never be NULL (except for OPTION_END).
- *   OPTION_GROUP uses this pointer to store the group header.
- *
- * `flags`::
- *   mask of parse_opt_option_flags.
- *   PARSE_OPT_OPTARG: says that the argument is optionnal (not for BOOLEANs)
- *   PARSE_OPT_NOARG: says that this option takes no argument, for CALLBACKs
- *   PARSE_OPT_NONEG: says that this option cannot be negated
- *   PARSE_OPT_HIDDEN this option is skipped in the default usage, showed in
- *                    the long one.
- *
- * `callback`::
- *   pointer to the callback to use for OPTION_CALLBACK.
- *
- * `defval`::
- *   default value to fill (*->value) with for PARSE_OPT_OPTARG.
- *   OPTION_{BIT,SET_UINT,SET_PTR} store the {mask,integer,pointer} to put in
- *   the value when met.
- *   CALLBACKS can use it like they want.
- *
- * `set`::
- *   whether an option was set by the user
- */
-struct option {
-	enum parse_opt_type type;
-	int short_name;
-	const char *long_name;
-	void *value;
-	const char *argh;
-	const char *help;
-
-	int flags;
-	parse_opt_cb *callback;
-	intptr_t defval;
-	bool *set;
-};
-
-#define check_vtype(v, type) ( BUILD_BUG_ON_ZERO(!__builtin_types_compatible_p(typeof(v), type)) + v )
-
-#define OPT_END()                   { .type = OPTION_END }
-#define OPT_ARGUMENT(l, h)          { .type = OPTION_ARGUMENT, .long_name = (l), .help = (h) }
-#define OPT_GROUP(h)                { .type = OPTION_GROUP, .help = (h) }
-#define OPT_BIT(s, l, v, h, b)      { .type = OPTION_BIT, .short_name = (s), .long_name = (l), .value = check_vtype(v, int *), .help = (h), .defval = (b) }
-#define OPT_BOOLEAN(s, l, v, h)     { .type = OPTION_BOOLEAN, .short_name = (s), .long_name = (l), .value = check_vtype(v, bool *), .help = (h) }
-#define OPT_BOOLEAN_SET(s, l, v, os, h) \
-	{ .type = OPTION_BOOLEAN, .short_name = (s), .long_name = (l), \
-	.value = check_vtype(v, bool *), .help = (h), \
-	.set = check_vtype(os, bool *)}
-#define OPT_INCR(s, l, v, h)        { .type = OPTION_INCR, .short_name = (s), .long_name = (l), .value = check_vtype(v, int *), .help = (h) }
-#define OPT_SET_UINT(s, l, v, h, i)  { .type = OPTION_SET_UINT, .short_name = (s), .long_name = (l), .value = check_vtype(v, unsigned int *), .help = (h), .defval = (i) }
-#define OPT_SET_PTR(s, l, v, h, p)  { .type = OPTION_SET_PTR, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (p) }
-#define OPT_INTEGER(s, l, v, h)     { .type = OPTION_INTEGER, .short_name = (s), .long_name = (l), .value = check_vtype(v, int *), .help = (h) }
-#define OPT_UINTEGER(s, l, v, h)    { .type = OPTION_UINTEGER, .short_name = (s), .long_name = (l), .value = check_vtype(v, unsigned int *), .help = (h) }
-#define OPT_LONG(s, l, v, h)        { .type = OPTION_LONG, .short_name = (s), .long_name = (l), .value = check_vtype(v, long *), .help = (h) }
-#define OPT_U64(s, l, v, h)         { .type = OPTION_U64, .short_name = (s), .long_name = (l), .value = check_vtype(v, u64 *), .help = (h) }
-#define OPT_STRING(s, l, v, a, h)   { .type = OPTION_STRING,  .short_name = (s), .long_name = (l), .value = check_vtype(v, const char **), (a), .help = (h) }
-#define OPT_DATE(s, l, v, h) \
-	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), .argh = "time", .help = (h), .callback = parse_opt_approxidate_cb }
-#define OPT_CALLBACK(s, l, v, a, h, f) \
-	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f) }
-#define OPT_CALLBACK_NOOPT(s, l, v, a, h, f) \
-	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f), .flags = PARSE_OPT_NOARG }
-#define OPT_CALLBACK_DEFAULT(s, l, v, a, h, f, d) \
-	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f), .defval = (intptr_t)d, .flags = PARSE_OPT_LASTARG_DEFAULT }
-#define OPT_CALLBACK_DEFAULT_NOOPT(s, l, v, a, h, f, d) \
-	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l),\
-	.value = (v), (a), .help = (h), .callback = (f), .defval = (intptr_t)d,\
-	.flags = PARSE_OPT_LASTARG_DEFAULT | PARSE_OPT_NOARG}
-
-/* parse_options() will filter out the processed options and leave the
- * non-option argments in argv[].
- * Returns the number of arguments left in argv[].
- */
-extern int parse_options(int argc, const char **argv,
-                         const struct option *options,
-                         const char * const usagestr[], int flags);
-
-extern int parse_options_subcommand(int argc, const char **argv,
-				const struct option *options,
-				const char *const subcommands[],
-				const char *usagestr[], int flags);
-
-extern NORETURN void usage_with_options(const char * const *usagestr,
-                                        const struct option *options);
-
-/*----- incremantal advanced APIs -----*/
-
-enum {
-	PARSE_OPT_HELP = -1,
-	PARSE_OPT_DONE,
-	PARSE_OPT_LIST_OPTS,
-	PARSE_OPT_LIST_SUBCMDS,
-	PARSE_OPT_UNKNOWN,
-};
-
-/*
- * It's okay for the caller to consume argv/argc in the usual way.
- * Other fields of that structure are private to parse-options and should not
- * be modified in any way.
- */
-struct parse_opt_ctx_t {
-	const char **argv;
-	const char **out;
-	int argc, cpidx;
-	const char *opt;
-	int flags;
-};
-
-extern int parse_options_usage(const char * const *usagestr,
-			       const struct option *opts,
-			       const char *optstr,
-			       bool short_opt);
-
-extern void parse_options_start(struct parse_opt_ctx_t *ctx,
-				int argc, const char **argv, int flags);
-
-extern int parse_options_step(struct parse_opt_ctx_t *ctx,
-			      const struct option *options,
-			      const char * const usagestr[]);
-
-extern int parse_options_end(struct parse_opt_ctx_t *ctx);
-
-
-/*----- some often used options -----*/
-extern int parse_opt_abbrev_cb(const struct option *, const char *, int);
-extern int parse_opt_approxidate_cb(const struct option *, const char *, int);
-extern int parse_opt_verbosity_cb(const struct option *, const char *, int);
-
-#define OPT__VERBOSE(var)  OPT_BOOLEAN('v', "verbose", (var), "be verbose")
-#define OPT__QUIET(var)    OPT_BOOLEAN('q', "quiet",   (var), "be quiet")
-#define OPT__VERBOSITY(var) \
-	{ OPTION_CALLBACK, 'v', "verbose", (var), NULL, "be more verbose", \
-	  PARSE_OPT_NOARG, &parse_opt_verbosity_cb, 0 }, \
-	{ OPTION_CALLBACK, 'q', "quiet", (var), NULL, "be more quiet", \
-	  PARSE_OPT_NOARG, &parse_opt_verbosity_cb, 0 }
-#define OPT__DRY_RUN(var)  OPT_BOOLEAN('n', "dry-run", (var), "dry run")
-#define OPT__ABBREV(var)  \
-	{ OPTION_CALLBACK, 0, "abbrev", (var), "n", \
-	  "use <n> digits to display SHA-1s", \
-	  PARSE_OPT_OPTARG, &parse_opt_abbrev_cb, 0 }
-
-extern const char *parse_options_fix_filename(const char *prefix, const char *file);
-
-#endif /* __NDCTL_PARSE_OPTIONS_H */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
