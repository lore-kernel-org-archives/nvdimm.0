Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id E01F91A1E1C
 for <linux-nvdimm@lists.01.org>; Sat, 21 May 2016 14:56:14 -0700 (PDT)
Subject: [ndctl PATCH 2/5] util: centralize sysfs helpers
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 21 May 2016 14:55:20 -0700
Message-ID: <146386772076.1884.11491968915744268837.stgit@dwillia2-desk3.amr.corp.intel.com>
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

libdaxctl will also need this functionality so move it to a shared
location.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/Makefile.am            |    2 +
 ndctl/lib/libndctl-private.h |    5 --
 ndctl/lib/libndctl.c         |  100 +--------------------------------
 util/sysfs.c                 |  127 ++++++++++++++++++++++++++++++++++++++++++
 util/sysfs.h                 |   40 +++++++++++++
 5 files changed, 171 insertions(+), 103 deletions(-)
 create mode 100644 util/sysfs.c
 create mode 100644 util/sysfs.h

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 91f057caa82c..1e7df1da97de 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -15,6 +15,8 @@ lib_libndctl_la_SOURCES =\
 	lib/libndctl-private.h \
 	../util/log.c \
 	../util/log.h \
+	../util/sysfs.c \
+	../util/sysfs.h \
 	lib/libndctl.c
 
 lib_libndctl_la_LIBADD =\
diff --git a/ndctl/lib/libndctl-private.h b/ndctl/lib/libndctl-private.h
index 1996efd1baaf..604062abc9ad 100644
--- a/ndctl/lib/libndctl-private.h
+++ b/ndctl/lib/libndctl-private.h
@@ -224,11 +224,6 @@ static inline struct ndctl_bus *cmd_to_bus(struct ndctl_cmd *cmd)
 
 #define NDCTL_EXPORT __attribute__ ((visibility("default")))
 
-static inline const char *devpath_to_devname(const char *devpath)
-{
-	return strrchr(devpath, '/') + 1;
-}
-
 static inline int check_udev(struct udev *udev)
 {
 	return udev ? 0 : -ENXIO;
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index d3c8d9e1edb3..e587fdd17d1b 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -34,6 +34,7 @@
 #include <ndctl.h>
 #endif
 
+#include <util/sysfs.h>
 #include <ndctl/libndctl.h>
 #include "libndctl-private.h"
 
@@ -663,62 +664,6 @@ NDCTL_EXPORT void ndctl_set_log_priority(struct ndctl_ctx *ctx, int priority)
 	ctx->ctx.log_priority = priority;
 }
 
-#define SYSFS_ATTR_SIZE 1024
-
-static int sysfs_read_attr(struct ndctl_ctx *ctx, const char *path, char *buf)
-{
-	int fd = open(path, O_RDONLY|O_CLOEXEC);
-	int n;
-
-	if (fd < 0) {
-		dbg(ctx, "failed to open %s: %s\n", path, strerror(errno));
-		return -1;
-	}
-	n = read(fd, buf, SYSFS_ATTR_SIZE);
-	close(fd);
-	if (n < 0 || n >= SYSFS_ATTR_SIZE) {
-		dbg(ctx, "failed to read %s: %s\n", path, strerror(errno));
-		return -1;
-	}
-	buf[n] = 0;
-	if (n && buf[n-1] == '\n')
-		buf[n-1] = 0;
-	return 0;
-}
-
-static int __sysfs_write_attr(struct ndctl_ctx *ctx, const char *path,
-		const char *buf, int quiet)
-{
-	int fd = open(path, O_WRONLY|O_CLOEXEC);
-	int n, len = strlen(buf) + 1;
-
-	if (fd < 0) {
-		dbg(ctx, "failed to open %s: %s\n", path, strerror(errno));
-		return -1;
-	}
-	n = write(fd, buf, len);
-	close(fd);
-	if (n < len) {
-		if (!quiet)
-			dbg(ctx, "failed to write %s to %s: %s\n", buf, path,
-					strerror(errno));
-		return -1;
-	}
-	return 0;
-}
-
-static int sysfs_write_attr(struct ndctl_ctx *ctx, const char *path,
-		const char *buf)
-{
-	return __sysfs_write_attr(ctx, path, buf, 0);
-}
-
-static int sysfs_write_attr_quiet(struct ndctl_ctx *ctx, const char *path,
-		const char *buf)
-{
-	return __sysfs_write_attr(ctx, path, buf, 1);
-}
-
 static char *__dev_path(char *type, int major, int minor, int parent)
 {
 	char *path, *dev_path;
@@ -737,54 +682,13 @@ static char *parent_dev_path(char *type, int major, int minor)
         return __dev_path(type, major, minor, 1);
 }
 
-typedef int (*add_dev_fn)(void *parent, int id, const char *dev_path);
-
 static int device_parse(struct ndctl_ctx *ctx, struct ndctl_bus *bus,
 		const char *base_path, const char *dev_name, void *parent,
 		add_dev_fn add_dev)
 {
-	int add_errors = 0;
-	struct dirent *de;
-	DIR *dir;
-
 	if (bus)
 		ndctl_bus_wait_probe(bus);
-	dir = opendir(base_path);
-	if (!dir) {
-		dbg(ctx, "no \"%s\" devices found\n", dev_name);
-		return -ENODEV;
-	}
-
-	while ((de = readdir(dir)) != NULL) {
-		char *dev_path;
-		char fmt[20];
-		int id, rc;
-
-		sprintf(fmt, "%s%%d", dev_name);
-		if (de->d_ino == 0)
-			continue;
-		if (sscanf(de->d_name, fmt, &id) != 1)
-			continue;
-		if (asprintf(&dev_path, "%s/%s", base_path, de->d_name) < 0) {
-			err(ctx, "%s%d: path allocation failure\n",
-					dev_name, id);
-			continue;
-		}
-
-		rc = add_dev(parent, id, dev_path);
-		free(dev_path);
-		if (rc < 0) {
-			add_errors++;
-			err(ctx, "%s%d: add_dev() failed: %d\n",
-					dev_name, id, rc);
-		} else if (rc == 0) {
-			dbg(ctx, "%s%d: added\n", dev_name, id);
-		} else
-			dbg(ctx, "%s%d: duplicate\n", dev_name, id);
-	}
-	closedir(dir);
-
-	return add_errors;
+	return sysfs_device_parse(ctx, base_path, dev_name, parent, add_dev);
 }
 
 static int to_dsm_index(const char *name, int dimm)
diff --git a/util/sysfs.c b/util/sysfs.c
new file mode 100644
index 000000000000..9f6a84172e91
--- /dev/null
+++ b/util/sysfs.c
@@ -0,0 +1,127 @@
+/*
+ * Copyright (c) 2014-2016, Intel Corporation.
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
+#include <stdio.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <stdarg.h>
+#include <unistd.h>
+#include <errno.h>
+#include <string.h>
+#include <ctype.h>
+#include <fcntl.h>
+#include <dirent.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/ioctl.h>
+
+#include <util/log.h>
+#include <util/sysfs.h>
+
+int __sysfs_read_attr(struct log_ctx *ctx, const char *path, char *buf)
+{
+	int fd = open(path, O_RDONLY|O_CLOEXEC);
+	int n;
+
+	if (fd < 0) {
+		log_dbg(ctx, "failed to open %s: %s\n", path, strerror(errno));
+		return -1;
+	}
+	n = read(fd, buf, SYSFS_ATTR_SIZE);
+	close(fd);
+	if (n < 0 || n >= SYSFS_ATTR_SIZE) {
+		log_dbg(ctx, "failed to read %s: %s\n", path, strerror(errno));
+		return -1;
+	}
+	buf[n] = 0;
+	if (n && buf[n-1] == '\n')
+		buf[n-1] = 0;
+	return 0;
+}
+
+static int write_attr(struct log_ctx *ctx, const char *path,
+		const char *buf, int quiet)
+{
+	int fd = open(path, O_WRONLY|O_CLOEXEC);
+	int n, len = strlen(buf) + 1;
+
+	if (fd < 0) {
+		log_dbg(ctx, "failed to open %s: %s\n", path, strerror(errno));
+		return -1;
+	}
+	n = write(fd, buf, len);
+	close(fd);
+	if (n < len) {
+		if (!quiet)
+			log_dbg(ctx, "failed to write %s to %s: %s\n", buf, path,
+					strerror(errno));
+		return -1;
+	}
+	return 0;
+}
+
+int __sysfs_write_attr(struct log_ctx *ctx, const char *path,
+		const char *buf)
+{
+	return write_attr(ctx, path, buf, 0);
+}
+
+int __sysfs_write_attr_quiet(struct log_ctx *ctx, const char *path,
+		const char *buf)
+{
+	return write_attr(ctx, path, buf, 1);
+}
+
+int __sysfs_device_parse(struct log_ctx *ctx, const char *base_path,
+		const char *dev_name, void *parent, add_dev_fn add_dev)
+{
+	int add_errors = 0;
+	struct dirent *de;
+	DIR *dir;
+
+	dir = opendir(base_path);
+	if (!dir) {
+		log_dbg(ctx, "no \"%s\" devices found\n", dev_name);
+		return -ENODEV;
+	}
+
+	while ((de = readdir(dir)) != NULL) {
+		char *dev_path;
+		char fmt[20];
+		int id, rc;
+
+		sprintf(fmt, "%s%%d", dev_name);
+		if (de->d_ino == 0)
+			continue;
+		if (sscanf(de->d_name, fmt, &id) != 1)
+			continue;
+		if (asprintf(&dev_path, "%s/%s", base_path, de->d_name) < 0) {
+			log_err(ctx, "%s%d: path allocation failure\n",
+					dev_name, id);
+			continue;
+		}
+
+		rc = add_dev(parent, id, dev_path);
+		free(dev_path);
+		if (rc < 0) {
+			add_errors++;
+			log_err(ctx, "%s%d: add_dev() failed: %d\n",
+					dev_name, id, rc);
+		} else if (rc == 0) {
+			log_dbg(ctx, "%s%d: added\n", dev_name, id);
+		} else
+			log_dbg(ctx, "%s%d: duplicate\n", dev_name, id);
+	}
+	closedir(dir);
+
+	return add_errors;
+}
diff --git a/util/sysfs.h b/util/sysfs.h
new file mode 100644
index 000000000000..6a7b6449adcb
--- /dev/null
+++ b/util/sysfs.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (c) 2014-2016, Intel Corporation.
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
+#ifndef __UTIL_SYSFS_H__
+#define __UTIL_SYSFS_H__
+
+#include <string.h>
+
+typedef int (*add_dev_fn)(void *parent, int id, const char *dev_path);
+
+#define SYSFS_ATTR_SIZE 1024
+
+struct log_ctx;
+int __sysfs_read_attr(struct log_ctx *ctx, const char *path, char *buf);
+int __sysfs_write_attr(struct log_ctx *ctx, const char *path, const char *buf);
+int __sysfs_write_attr_quiet(struct log_ctx *ctx, const char *path,
+		const char *buf);
+int __sysfs_device_parse(struct log_ctx *ctx, const char *base_path,
+		const char *dev_name, void *parent, add_dev_fn add_dev);
+
+#define sysfs_read_attr(c, p, b) __sysfs_read_attr(&(c)->ctx, (p), (b))
+#define sysfs_write_attr(c, p, b) __sysfs_write_attr(&(c)->ctx, (p), (b))
+#define sysfs_write_attr_quiet(c, p, b) __sysfs_write_attr_quiet(&(c)->ctx, (p), (b))
+#define sysfs_device_parse(c, b, d, p, fn) __sysfs_device_parse(&(c)->ctx, \
+		(b), (d), (p), (fn))
+
+static inline const char *devpath_to_devname(const char *devpath)
+{
+	return strrchr(devpath, '/') + 1;
+}
+#endif /* __UTIL_SYSFS_H__ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
