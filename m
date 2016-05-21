Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 00CFE1A1E1E
 for <linux-nvdimm@lists.01.org>; Sat, 21 May 2016 14:56:09 -0700 (PDT)
Subject: [ndctl PATCH 1/5] util: centralize logging
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 21 May 2016 14:55:15 -0700
Message-ID: <146386771553.1884.12986212679343163408.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146386771020.1884.14405221977201209581.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146386771020.1884.14405221977201209581.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Make the logging implementation generic in preparation for a new user in
libdaxctl.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/Makefile.am            |    2 +
 ndctl/lib/libndctl-private.h |   59 ++++++++++++------------------
 ndctl/lib/libndctl-smart.c   |    1 +
 ndctl/lib/libndctl.c         |   83 +++++-------------------------------------
 util/log.c                   |   65 +++++++++++++++++++++++++++++++++
 util/log.h                   |   69 +++++++++++++++++++++++++++++++++++
 6 files changed, 169 insertions(+), 110 deletions(-)
 create mode 100644 util/log.c
 create mode 100644 util/log.h

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 7c5c461aef86..91f057caa82c 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -13,6 +13,8 @@ lib_LTLIBRARIES = lib/libndctl.la
 lib_libndctl_la_SOURCES =\
 	libndctl.h \
 	lib/libndctl-private.h \
+	../util/log.c \
+	../util/log.h \
 	lib/libndctl.c
 
 lib_libndctl_la_LIBADD =\
diff --git a/ndctl/lib/libndctl-private.h b/ndctl/lib/libndctl-private.h
index a0a36885b160..1996efd1baaf 100644
--- a/ndctl/lib/libndctl-private.h
+++ b/ndctl/lib/libndctl-private.h
@@ -19,7 +19,9 @@
 #include <string.h>
 #include <libudev.h>
 #include <libkmod.h>
+#include <util/log.h>
 #include <uuid/uuid.h>
+#include <ccan/list/list.h>
 #include <ccan/array_size/array_size.h>
 #ifdef HAVE_NDCTL_H
 #include <linux/ndctl.h>
@@ -121,6 +123,27 @@ struct namespace_label {
 };
 
 /**
+ * struct ndctl_ctx - library user context to find "nd" instances
+ *
+ * Instantiate with ndctl_new(), which takes an initial reference.  Free
+ * the context by dropping the reference count to zero with
+ * ndctrl_unref(), or take additional references with ndctl_ref()
+ * @timeout: default library timeout in milliseconds
+ */
+struct ndctl_ctx {
+	/* log_ctx must be first member for ndctl_set_log_fn compat */
+	struct log_ctx ctx;
+	int refcount;
+	void *userdata;
+	struct list_head busses;
+	int busses_init;
+	struct udev *udev;
+	struct udev_queue *udev_queue;
+	struct kmod_ctx *kmod_ctx;
+	unsigned long timeout;
+};
+
+/**
  * struct ndctl_cmd - device-specific-method (_DSM ioctl) container
  * @dimm: set if the command is relative to a dimm, NULL otherwise
  * @bus: set if the command is relative to a bus (like ARS), NULL otherwise
@@ -199,44 +222,8 @@ static inline struct ndctl_bus *cmd_to_bus(struct ndctl_cmd *cmd)
 	return cmd->bus;
 }
 
-static inline void __attribute__((always_inline, format(printf, 2, 3)))
-ndctl_log_null(struct ndctl_ctx *ctx, const char *format, ...) {}
-
-#define ndctl_log_cond(ctx, prio, arg...) \
-do { \
-	if (ndctl_get_log_priority(ctx) >= prio) \
-		ndctl_log(ctx, prio, __FILE__, __LINE__, __FUNCTION__, ## arg); \
-} while (0)
-
-#ifdef ENABLE_LOGGING
-#  ifdef ENABLE_DEBUG
-#    define dbg(ctx, arg...) ndctl_log_cond(ctx, LOG_DEBUG, ## arg)
-#  else
-#    define dbg(ctx, arg...) ndctl_log_null(ctx, ## arg)
-#  endif
-#  define info(ctx, arg...) ndctl_log_cond(ctx, LOG_INFO, ## arg)
-#  define err(ctx, arg...) ndctl_log_cond(ctx, LOG_ERR, ## arg)
-#else
-#  define dbg(ctx, arg...) ndctl_log_null(ctx, ## arg)
-#  define info(ctx, arg...) ndctl_log_null(ctx, ## arg)
-#  define err(ctx, arg...) ndctl_log_null(ctx, ## arg)
-#endif
-
-#ifndef HAVE_SECURE_GETENV
-#  ifdef HAVE___SECURE_GETENV
-#    define secure_getenv __secure_getenv
-#  else
-#    error neither secure_getenv nor __secure_getenv is available
-#  endif
-#endif
-
 #define NDCTL_EXPORT __attribute__ ((visibility("default")))
 
-void ndctl_log(struct ndctl_ctx *ctx,
-		int priority, const char *file, int line, const char *fn,
-		const char *format, ...)
-	__attribute__((format(printf, 6, 7)));
-
 static inline const char *devpath_to_devname(const char *devpath)
 {
 	return strrchr(devpath, '/') + 1;
diff --git a/ndctl/lib/libndctl-smart.c b/ndctl/lib/libndctl-smart.c
index e93ac8084892..cba1e9d5180e 100644
--- a/ndctl/lib/libndctl-smart.c
+++ b/ndctl/lib/libndctl-smart.c
@@ -12,6 +12,7 @@
  */
 #include <stdlib.h>
 #include <limits.h>
+#include <util/log.h>
 #include <ndctl/libndctl.h>
 #include "libndctl-private.h"
 
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index c9ade76c26d2..d3c8d9e1edb3 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -321,48 +321,6 @@ struct ndctl_dax {
 };
 
 /**
- * struct ndctl_ctx - library user context to find "nd" instances
- *
- * Instantiate with ndctl_new(), which takes an initial reference.  Free
- * the context by dropping the reference count to zero with
- * ndctrl_unref(), or take additional references with ndctl_ref()
- * @timeout: default library timeout in milliseconds
- */
-struct ndctl_ctx {
-	int refcount;
-	void (*log_fn)(struct ndctl_ctx *ctx,
-			int priority, const char *file, int line, const char *fn,
-			const char *format, va_list args);
-	void *userdata;
-	int log_priority;
-	struct list_head busses;
-	int busses_init;
-	struct udev *udev;
-	struct udev_queue *udev_queue;
-	struct kmod_ctx *kmod_ctx;
-	unsigned long timeout;
-};
-
-void ndctl_log(struct ndctl_ctx *ctx,
-		int priority, const char *file, int line, const char *fn,
-		const char *format, ...)
-{
-	va_list args;
-
-	va_start(args, format);
-	ctx->log_fn(ctx, priority, file, line, fn, format, args);
-	va_end(args);
-}
-
-static void log_stderr(struct ndctl_ctx *ctx,
-		int priority, const char *file, int line, const char *fn,
-		const char *format, va_list args)
-{
-	fprintf(stderr, "libndctl: %s: ", fn);
-	vfprintf(stderr, format, args);
-}
-
-/**
  * ndctl_get_userdata - retrieve stored data pointer from library context
  * @ctx: ndctl library context
  *
@@ -388,23 +346,6 @@ NDCTL_EXPORT void ndctl_set_userdata(struct ndctl_ctx *ctx, void *userdata)
 	ctx->userdata = userdata;
 }
 
-static int log_priority(const char *priority)
-{
-	char *endptr;
-	int prio;
-
-	prio = strtol(priority, &endptr, 10);
-	if (endptr[0] == '\0' || isspace(endptr[0]))
-		return prio;
-	if (strncmp(priority, "err", 3) == 0)
-		return LOG_ERR;
-	if (strncmp(priority, "info", 4) == 0)
-		return LOG_INFO;
-	if (strncmp(priority, "debug", 5) == 0)
-		return LOG_DEBUG;
-	return 0;
-}
-
 /**
  * ndctl_new - instantiate a new library context
  * @ctx: context to establish
@@ -438,18 +379,13 @@ NDCTL_EXPORT int ndctl_new(struct ndctl_ctx **ctx)
 	}
 
 	c->refcount = 1;
-	c->log_fn = log_stderr;
-	c->log_priority = LOG_ERR;
+	log_init(&c->ctx, "libndctl", "NDCTL_LOG");
 	c->udev = udev;
 	c->timeout = 5000;
 	list_head_init(&c->busses);
 
-	/* environment overwrites config */
-	env = secure_getenv("NDCTL_LOG");
-	if (env != NULL)
-		ndctl_set_log_priority(c, log_priority(env));
 	info(c, "ctx %p created\n", c);
-	dbg(c, "log_priority=%d\n", c->log_priority);
+	dbg(c, "log_priority=%d\n", c->ctx.log_priority);
 	*ctx = c;
 
 	env = secure_getenv("NDCTL_TIMEOUT");
@@ -699,13 +635,12 @@ NDCTL_EXPORT struct ndctl_ctx *ndctl_unref(struct ndctl_ctx *ctx)
  * functionality.
  */
 NDCTL_EXPORT void ndctl_set_log_fn(struct ndctl_ctx *ctx,
-		void (*log_fn)(struct ndctl_ctx *ctx,
-			int priority, const char *file,
-			int line, const char *fn,
-			const char *format, va_list args))
+                 void (*ndctl_log_fn)(struct ndctl_ctx *ctx,
+                                 int priority, const char *file, int line, const char *fn,
+                                 const char *format, va_list args))
 {
-	ctx->log_fn = log_fn;
-	info(ctx, "custom logging function %p registered\n", log_fn);
+	ctx->ctx.log_fn = (log_fn) ndctl_log_fn;
+	info(ctx, "custom logging function %p registered\n", ndctl_log_fn);
 }
 
 /**
@@ -714,7 +649,7 @@ NDCTL_EXPORT void ndctl_set_log_fn(struct ndctl_ctx *ctx,
  */
 NDCTL_EXPORT int ndctl_get_log_priority(struct ndctl_ctx *ctx)
 {
-	return ctx->log_priority;
+	return ctx->ctx.log_priority;
 }
 
 /**
@@ -725,7 +660,7 @@ NDCTL_EXPORT int ndctl_get_log_priority(struct ndctl_ctx *ctx)
  */
 NDCTL_EXPORT void ndctl_set_log_priority(struct ndctl_ctx *ctx, int priority)
 {
-	ctx->log_priority = priority;
+	ctx->ctx.log_priority = priority;
 }
 
 #define SYSFS_ATTR_SIZE 1024
diff --git a/util/log.c b/util/log.c
new file mode 100644
index 000000000000..8ecaf11d3d64
--- /dev/null
+++ b/util/log.c
@@ -0,0 +1,65 @@
+/*
+ * Copyright (c) 2016, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
+ * more details.
+ */
+#include <syslog.h>
+#include <stdlib.h>
+#include <ctype.h>
+#include <string.h>
+#include <util/log.h>
+
+void do_log(struct log_ctx *ctx, int priority, const char *file,
+		int line, const char *fn, const char *format, ...)
+{
+	va_list args;
+
+	va_start(args, format);
+	ctx->log_fn(ctx, priority, file, line, fn, format, args);
+	va_end(args);
+}
+
+static void log_stderr(struct log_ctx *ctx, int priority, const char *file,
+		int line, const char *fn, const char *format, va_list args)
+{
+	fprintf(stderr, "%s: %s: ", ctx->owner, fn);
+	vfprintf(stderr, format, args);
+}
+
+static int log_priority(const char *priority)
+{
+	char *endptr;
+	int prio;
+
+	prio = strtol(priority, &endptr, 10);
+	if (endptr[0] == '\0' || isspace(endptr[0]))
+		return prio;
+	if (strncmp(priority, "err", 3) == 0)
+		return LOG_ERR;
+	if (strncmp(priority, "info", 4) == 0)
+		return LOG_INFO;
+	if (strncmp(priority, "debug", 5) == 0)
+		return LOG_DEBUG;
+	return 0;
+}
+
+void log_init(struct log_ctx *ctx, const char *owner, const char *log_env)
+{
+	const char *env;
+
+	ctx->owner = owner;
+	ctx->log_fn = log_stderr;
+	ctx->log_priority = LOG_ERR;
+
+	/* environment overwrites config */
+	env = secure_getenv(log_env);
+	if (env != NULL)
+		ctx->log_priority = log_priority(env);
+}
diff --git a/util/log.h b/util/log.h
new file mode 100644
index 000000000000..5c5922f412f2
--- /dev/null
+++ b/util/log.h
@@ -0,0 +1,69 @@
+/*
+ * Copyright (c) 2016, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
+ * more details.
+ */
+#ifndef __UTIL_LOG_H__
+#define __UTIL_LOG_H__
+#include <stdio.h>
+#include <stdarg.h>
+#include <syslog.h>
+
+struct log_ctx;
+typedef void (*log_fn)(struct log_ctx *ctx, int priority, const char *file,
+		int line, const char *fn, const char *format, va_list args);
+
+struct log_ctx {
+	log_fn log_fn;
+	const char *owner;
+	int log_priority;
+};
+
+
+void do_log(struct log_ctx *ctx, int priority, const char *file, int line,
+		const char *fn, const char *format, ...)
+	__attribute__((format(printf, 6, 7)));
+void log_init(struct log_ctx *ctx, const char *owner, const char *log_env);
+static inline void __attribute__((always_inline, format(printf, 2, 3)))
+	log_null(struct log_ctx *ctx, const char *format, ...) {}
+
+#define log_cond(ctx, prio, arg...) \
+do { \
+	if ((ctx)->log_priority >= prio) \
+		do_log(ctx, prio, __FILE__, __LINE__, __FUNCTION__, ## arg); \
+} while (0)
+
+#ifdef ENABLE_LOGGING
+#  ifdef ENABLE_DEBUG
+#    define log_dbg(ctx, arg...) log_cond(ctx, LOG_DEBUG, ## arg)
+#  else
+#    define log_dbg(ctx, arg...) log_null(ctx, ## arg)
+#  endif
+#  define log_info(ctx, arg...) log_cond(ctx, LOG_INFO, ## arg)
+#  define log_err(ctx, arg...) log_cond(ctx, LOG_ERR, ## arg)
+#else
+#  define log_dbg(ctx, arg...) log_null(ctx, ## arg)
+#  define log_info(ctx, arg...) log_null(ctx, ## arg)
+#  define log_err(ctx, arg...) log_null(ctx, ## arg)
+#endif
+
+#define dbg(x, arg...) log_dbg(&(x)->ctx, ## arg)
+#define info(x, arg...) log_info(&(x)->ctx, ## arg)
+#define err(x, arg...) log_err(&(x)->ctx, ## arg)
+
+#ifndef HAVE_SECURE_GETENV
+#  ifdef HAVE___SECURE_GETENV
+#    define secure_getenv __secure_getenv
+#  else
+#    error neither secure_getenv nor __secure_getenv is available
+#  endif
+#endif
+
+#endif /* __UTIL_LOG_H__ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
