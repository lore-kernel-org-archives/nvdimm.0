Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 490E721A07A94
 for <linux-nvdimm@lists.01.org>; Fri, 16 Jun 2017 21:44:42 -0700 (PDT)
Subject: [RFC PATCH] daxctl: new utilities to enable / disable a file for
 static dax access
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Jun 2017 21:39:33 -0700
Message-ID: <149767437349.23079.13999360299057821299.stgit@dwillia2-desk3.amr.corp.intel.com>
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

'daxctl enable' and 'daxctl disable' are wrapper utilities around the
new daxctl() syscall that pins / guarantees a given block-map for a
file.

The "dax.sh" unit test is extended to run its tests against the target
file in daxfile mode.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am.in           |    1 
 configure.ac             |    8 ++
 daxctl/Makefile.am       |   14 +++
 daxctl/dax.h             |    8 ++
 daxctl/daxctl.c          |    4 +
 daxctl/daxfile.c         |  211 ++++++++++++++++++++++++++++++++++++++++++++++
 daxctl/daxoff.in         |    3 +
 daxctl/daxon.in          |    3 +
 ndctl/lib/libndctl-ars.c |    6 -
 test/Makefile.am         |    4 +
 test/dax-pmd.c           |   77 +++++++++++++++++
 test/dax.sh              |   24 ++++-
 util/size.h              |    8 ++
 13 files changed, 360 insertions(+), 11 deletions(-)
 create mode 100644 daxctl/dax.h
 create mode 100644 daxctl/daxfile.c
 create mode 100644 daxctl/daxoff.in
 create mode 100644 daxctl/daxon.in

diff --git a/Makefile.am.in b/Makefile.am.in
index 9cb8d4a055c7..28cb487b233d 100644
--- a/Makefile.am.in
+++ b/Makefile.am.in
@@ -11,6 +11,7 @@ AM_CPPFLAGS = \
 	-DNDCTL_MAN_PATH=\""$(mandir)"\" \
 	-I${top_srcdir}/ndctl/lib \
 	-I${top_srcdir}/ndctl \
+	-I${top_srcdir}/daxctl \
 	-I${top_srcdir}/ \
 	$(KMOD_CFLAGS) \
 	$(UDEV_CFLAGS) \
diff --git a/configure.ac b/configure.ac
index e79623ac1d82..0b8c68899374 100644
--- a/configure.ac
+++ b/configure.ac
@@ -123,6 +123,14 @@ AS_IF([test "x$enable_local" = "xyes"], [], [
 	]
 )
 
+AS_IF([test "x$enable_local" = "xyes"], [], [
+	AC_CHECK_HEADER([linux/dax.h], [
+		AC_DEFINE([HAVE_DAX_H], [1],
+			[Define to 1 if you have <linux/dax.h>.])
+		], [])
+	]
+)
+
 # when building against kernel headers check version specific features
 AC_MSG_CHECKING([for ARS support])
 AC_LANG(C)
diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
index fe467d030c38..8245b0888faf 100644
--- a/daxctl/Makefile.am
+++ b/daxctl/Makefile.am
@@ -2,9 +2,23 @@ include $(top_srcdir)/Makefile.am.in
 
 bin_PROGRAMS = daxctl
 
+bin_SCRIPTS = daxon daxoff
+CLEANFILES += $(bin_SCRIPTS)
+EXTRA_DIST += daxon.in daxoff.in
+
+do_subst = sed -e 's,BINDIR,$(bindir),g'
+
+daxon: daxon.in
+	$(AM_V_GEN) $(do_subst) < $< > $@ && chmod +x $@
+
+daxoff: daxoff.in
+	$(AM_V_GEN) $(do_subst) < $< > $@ && chmod +x $@
+
 daxctl_SOURCES =\
 		daxctl.c \
+		daxfile.c \
 		list.c \
+		../util/log.c \
 		../util/json.c
 
 daxctl_LDADD =\
diff --git a/daxctl/dax.h b/daxctl/dax.h
new file mode 100644
index 000000000000..1b5f87500c6c
--- /dev/null
+++ b/daxctl/dax.h
@@ -0,0 +1,8 @@
+#ifndef _LINUX_DAX_H
+#define _LINUX_DAX_H
+
+#define DAXCTL_F_GET    (1 << 0)
+#define DAXCTL_F_DAX    (1 << 1)
+#define DAXCTL_F_STATIC (1 << 2)
+
+#endif /* _LINUX_DAX_H */
diff --git a/daxctl/daxctl.c b/daxctl/daxctl.c
index 91a4600e262f..67b5a4cbce9a 100644
--- a/daxctl/daxctl.c
+++ b/daxctl/daxctl.c
@@ -67,10 +67,14 @@ static int cmd_help(int argc, const char **argv, void *ctx)
 }
 
 int cmd_list(int argc, const char **argv, void *ctx);
+int cmd_enable(int argc, const char **argv, void *ctx);
+int cmd_disable(int argc, const char **argv, void *ctx);
 
 static struct cmd_struct commands[] = {
 	{ "version", cmd_version },
 	{ "list", cmd_list },
+	{ "enable", cmd_enable },
+	{ "disable", cmd_disable },
 	{ "help", cmd_help },
 };
 
diff --git a/daxctl/daxfile.c b/daxctl/daxfile.c
new file mode 100644
index 000000000000..f8a18b973615
--- /dev/null
+++ b/daxctl/daxfile.c
@@ -0,0 +1,211 @@
+/*
+ * Copyright (c) 2015-2017 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <stdio.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <assert.h>
+#include <limits.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <util/log.h>
+#include <util/size.h>
+#include <sys/syscall.h>
+#include <util/parse-options.h>
+#include <ccan/endian/endian.h>
+#include <ccan/short_types/short_types.h>
+
+#ifdef HAVE_DAX_H
+#include <linux/dax.h>
+#else
+#include <dax.h>
+#endif
+
+static struct parameters {
+	bool verbose;
+	bool check;
+	bool static_mode;
+	const char *align;
+} param;
+
+#define BASE_OPTIONS() \
+OPT_BOOLEAN('v', "verbose", &param.verbose, "enable extra logging"), \
+OPT_BOOLEAN('s', "static", &param.static_mode, \
+	"toggle / check <daxfile> static-dax capability")
+
+#define ENABLE_OPTIONS() \
+OPT_BOOLEAN('c', "check", &param.check, \
+	"check if <daxfile> is enabled for dax"), \
+OPT_STRING('a', "align", &param.align, "align", \
+	"specify expected minimum alignment of allocated extents")
+
+static const struct option enable_options[] = {
+	BASE_OPTIONS(),
+	ENABLE_OPTIONS(),
+	OPT_END(),
+};
+
+static const struct option disable_options[] = {
+	BASE_OPTIONS(),
+	OPT_END(),
+};
+
+struct dax_ctl {
+	struct log_ctx ctx;
+	const char *path;
+	struct stat stat;
+	int fd;
+};
+
+#ifdef __NR_daxctl
+#define daxctl(path, flags, align) \
+	syscall(__NR_daxctl, (path), (flags), (align))
+#else
+static int daxctl(const char *path, int flags, int align)
+{
+	errno = ENOTTY;
+	return -1;
+}
+#endif
+
+static bool enable_checks(struct dax_ctl *ctl)
+{
+	int fd;
+	struct stat st;
+
+	fd = open(ctl->path, O_RDONLY);
+	if (fd < 0) {
+		err(ctl, "failed to open %s (%s\n)", ctl->path, strerror(errno));
+		goto err;
+	}
+	ctl->fd = fd;
+
+	if (fstat(fd, &st) < 0) {
+		err(ctl, "failed to stat %s (%s\n)", ctl->path, strerror(errno));
+		goto err;
+	}
+
+	if (!S_ISREG(st.st_mode)) {
+		err(ctl, "error: %s not a regular file\n", ctl->path);
+		goto err;
+	}
+
+	/* test for holes by LBT */
+	if (st.st_blocks * 512 < st.st_size) {
+		err(ctl, "error: %s appears to be a sparse file\n", ctl->path);
+		goto err;
+	}
+
+	close(fd);
+	ctl->fd = -1;
+	return true;
+err:
+	if (fd >= 0)
+		close(fd);
+	ctl->fd = -1;
+	return false;
+}
+
+int cmd_enable(int argc, const char **argv, void *ctx)
+{
+	const char * const u[] = {
+		"daxctl enable <daxfile> [<options>]",
+		NULL
+	};
+	struct dax_ctl _ctl, *ctl = &_ctl;
+	int i, rc, flags = DAXCTL_F_STATIC;
+	unsigned long long align = 0; /* default to PAGE_SIZE */
+
+        argc = parse_options(argc, argv, enable_options, u, 0);
+	for (i = 1; i < argc; i++)
+		error("unknown parameter \"%s\"\n", argv[i]);
+
+	if (argc != 1) {
+		error("missing 'daxfile' to register\n");
+		usage_with_options(u, enable_options);
+	}
+
+	log_init(&ctl->ctx, "enable", "DAXCTL_ENABLE_LOGLEVEL");
+	if (param.verbose)
+		ctl->ctx.log_priority = LOG_DEBUG;
+	else
+		ctl->ctx.log_priority = LOG_INFO;
+
+	if (param.align) {
+		align = parse_size64(param.align);
+		if (align == ULLONG_MAX) {
+			error("could not parse --align parameter '%s'\n",
+					param.align);
+			return EXIT_FAILURE;
+		}
+		if (align > SZ_1G || !is_power_of_2(align)) {
+			error("invalid --align parameter '%s'\n",
+					param.align);
+			return EXIT_FAILURE;
+		}
+	}
+
+	ctl->path = argv[0];
+
+	if (param.check)
+		flags |= DAXCTL_F_GET;
+	else if (!enable_checks(ctl))
+		return EXIT_FAILURE;
+
+	rc = daxctl(ctl->path, flags, align);
+	if (rc < 0) {
+		err(ctl, "failed to %s daxfile: %s (%s)\n",
+				ctl->path, param.check ? "check" : "register",
+				strerror(errno));
+		return EXIT_FAILURE;
+	}
+
+	if (param.check && rc != DAXCTL_F_STATIC) {
+		dbg(ctl, "static-dax disabled for: %s\n", ctl->path);
+		return EXIT_FAILURE;
+	}
+	return EXIT_SUCCESS;
+}
+
+int cmd_disable(int argc, const char **argv, void *ctx)
+{
+	const char * const u[] = {
+		"daxctl disable <daxfile> [<options>]",
+		NULL
+	};
+	struct dax_ctl _ctl, *ctl = &_ctl;
+	int i, rc;
+
+	argc = parse_options(argc, argv, disable_options, u, 0);
+	for (i = 1; i < argc; i++)
+		error("unknown parameter \"%s\"\n", argv[i]);
+
+	if (argc != 1) {
+		error("missing 'daxfile' to unregister\n");
+		usage_with_options(u, disable_options);
+	}
+
+	log_init(&ctl->ctx, "disable", "DAXCTL_DISABLE_LOGLEVEL");
+	ctl->path = argv[0];
+
+	rc = daxctl(ctl->path, 0, 0);
+	if (rc < 0) {
+		err(ctl, "failed to unregister daxfile: %s (%s)\n",
+				ctl->path, strerror(errno));
+		return EXIT_FAILURE;
+	}
+	return EXIT_SUCCESS;
+}
diff --git a/daxctl/daxoff.in b/daxctl/daxoff.in
new file mode 100644
index 000000000000..a3e33364fd2c
--- /dev/null
+++ b/daxctl/daxoff.in
@@ -0,0 +1,3 @@
+#!/bin/sh
+
+BINDIR/daxctl disable $@
diff --git a/daxctl/daxon.in b/daxctl/daxon.in
new file mode 100644
index 000000000000..2380c32bed1a
--- /dev/null
+++ b/daxctl/daxon.in
@@ -0,0 +1,3 @@
+#!/bin/sh
+
+BINDIR/daxctl enable $@
diff --git a/ndctl/lib/libndctl-ars.c b/ndctl/lib/libndctl-ars.c
index 9b1a0cb6e1d6..1e463cf347a5 100644
--- a/ndctl/lib/libndctl-ars.c
+++ b/ndctl/lib/libndctl-ars.c
@@ -11,6 +11,7 @@
  * more details.
  */
 #include <stdlib.h>
+#include <util/size.h>
 #include <ndctl/libndctl.h>
 #include "libndctl-private.h"
 
@@ -44,11 +45,6 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
 }
 
 #ifdef HAVE_NDCTL_CLEAR_ERROR
-static bool is_power_of_2(unsigned int v)
-{
-	return v && ((v & (v - 1)) == 0);
-}
-
 static bool validate_clear_error(struct ndctl_cmd *ars_cap)
 {
 	if (!is_power_of_2(ars_cap->ars_cap->clear_err_unit))
diff --git a/test/Makefile.am b/test/Makefile.am
index 9353a34326c1..44a92e8d4864 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -75,7 +75,9 @@ parent_uuid_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
 dax_dev_SOURCES = dax-dev.c $(testcore)
 dax_dev_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
 
-dax_pmd_SOURCES = dax-pmd.c
+dax_pmd_SOURCES = dax-pmd.c \
+		  $(testcore)
+
 mmap_SOURCES = mmap.c
 dax_errors_SOURCES = dax-errors.c
 daxdev_errors_SOURCES = daxdev-errors.c \
diff --git a/test/dax-pmd.c b/test/dax-pmd.c
index 6276913a0fda..264b28631e2a 100644
--- a/test/dax-pmd.c
+++ b/test/dax-pmd.c
@@ -24,7 +24,25 @@
 #include <linux/fs.h>
 #include <test.h>
 #include <util/size.h>
+#include <sys/syscall.h>
 #include <linux/fiemap.h>
+#include <linux/version.h>
+#ifdef HAVE_DAX_H
+#include <linux/dax.h>
+#else
+#include <dax.h>
+#endif
+
+#ifdef __NR_daxctl
+#define daxctl(path, flags, align) \
+	syscall(__NR_daxctl, (path), (flags), (align))
+#else
+static int daxctl(const char *path, int flags, int align)
+{
+	errno = ENOTTY;
+	return -1;
+}
+#endif
 
 #define NUM_EXTENTS 5
 #define fail() fprintf(stderr, "%s: failed at: %d\n", __func__, __LINE__)
@@ -185,8 +203,59 @@ static int test_pmd(int fd)
 	return rc;
 }
 
+static int test_daxfile(char *daxfile)
+{
+	int fd, rc;
+
+	rc = daxctl(daxfile, DAXCTL_F_GET, 0);
+	if (rc < 0) {
+		fprintf(stderr, "%s: failed to retrieve dax flags: %s\n",
+				__func__, strerror(errno));
+		return -errno;
+	}
+	if (rc != 0) {
+		fprintf(stderr, "%s: expected dax flags %d got %d\n",
+				__func__, 0, rc);
+		return -ENXIO;
+	}
+
+	rc = daxctl(daxfile, DAXCTL_F_STATIC, 0);
+	if (rc < 0) {
+		fprintf(stderr, "%s: failed to set static dax: %s\n",
+				__func__, strerror(errno));
+		return -errno;
+	}
+
+	rc = daxctl(daxfile, DAXCTL_F_GET, 0);
+	if (rc < 0) {
+		fprintf(stderr, "%s: failed to retrieve dax flags: %s\n",
+				__func__, strerror(errno));
+		return -errno;
+	}
+	if (rc != DAXCTL_F_STATIC) {
+		fprintf(stderr, "%s: expected dax flags %d got %d\n",
+				__func__, DAXCTL_F_STATIC, rc);
+		return -ENXIO;
+	}
+
+	fd = open(daxfile, O_RDWR);
+	rc = test_pmd(fd);
+	if (rc)
+		return rc;
+
+	rc = daxctl(daxfile, 0, 0);
+	if (rc < 0) {
+		fprintf(stderr, "%s: failed to clear static dax: %s\n",
+				__func__, strerror(errno));
+		return -errno;
+	}
+
+	return 0;
+}
+
 int __attribute__((weak)) main(int argc, char *argv[])
 {
+	struct ndctl_test *test = ndctl_test_new(0);
 	int fd, rc;
 
 	if (argc < 1)
@@ -196,5 +265,11 @@ int __attribute__((weak)) main(int argc, char *argv[])
 	rc = test_pmd(fd);
 	if (fd >= 0)
 		close(fd);
-	return rc;
+	if (rc)
+		return rc;
+
+	/* try the same test with a daxfile */
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 14, 0)))
+		return 0;
+	return test_daxfile(argv[1]);
 }
diff --git a/test/dax.sh b/test/dax.sh
index e1f3c8f6ff79..4478b9a0295b 100755
--- a/test/dax.sh
+++ b/test/dax.sh
@@ -29,6 +29,22 @@ err() {
 	exit $rc
 }
 
+alloc_file() {
+	# Note, we use dd here to get guarantees that the filesystem
+	# allocates the extents. ext4 is fine to use fallocate like so:
+	#
+	#     fallocate -l 1GiB $MNT/$FILE
+	#
+	# ...but that does not work for xfs. xfs does support the -z
+	# option to allocate unwritten extents, like so:
+	#
+	#     fallocate -z -l 1GiB $MNT/$FILE
+	#
+	# ...but that does not appear to work for ext4.
+
+	dd if=/dev/zero bs=1G count=1 of=$MNT/$FILE
+}
+
 set -e
 mkdir -p $MNT
 trap 'err $LINENO' ERR
@@ -39,7 +55,7 @@ eval $(echo $json | sed -e "$json2var")
 
 mkfs.ext4 /dev/$blockdev
 mount /dev/$blockdev $MNT -o dax
-fallocate -l 1GiB $MNT/$FILE
+alloc_file
 ./dax-pmd $MNT/$FILE
 umount $MNT
 
@@ -51,7 +67,7 @@ eval $(echo $json | sed -e "$json2var")
 #note the blockdev returned from ndctl create-namespace lacks the /dev prefix
 mkfs.ext4 /dev/$blockdev
 mount /dev/$blockdev $MNT -o dax
-fallocate -l 1GiB $MNT/$FILE
+alloc_file
 ./dax-pmd $MNT/$FILE
 umount $MNT
 
@@ -61,7 +77,7 @@ eval $(echo $json | sed -e "$json2var")
 
 mkfs.xfs -f /dev/$blockdev
 mount /dev/$blockdev $MNT -o dax
-fallocate -l 1GiB $MNT/$FILE
+alloc_file
 ./dax-pmd $MNT/$FILE
 umount $MNT
 
@@ -72,7 +88,7 @@ eval $(echo $json | sed -e "$json2var")
 
 mkfs.xfs -f /dev/$blockdev
 mount /dev/$blockdev $MNT -o dax
-fallocate -l 1GiB $MNT/$FILE
+alloc_file
 ./dax-pmd $MNT/$FILE
 umount $MNT
 
diff --git a/util/size.h b/util/size.h
index 3c27079fc2b8..f81a73ce884c 100644
--- a/util/size.h
+++ b/util/size.h
@@ -13,9 +13,12 @@
 
 #ifndef _NDCTL_SIZE_H_
 #define _NDCTL_SIZE_H_
+#include <stdbool.h>
 
 #define SZ_1K     0x00000400
 #define SZ_4K     0x00001000
+#define SZ_32K    0x00008000
+#define SZ_64K    0x00010000
 #define SZ_1M     0x00100000
 #define SZ_2M     0x00200000
 #define SZ_4M     0x00400000
@@ -27,6 +30,11 @@
 unsigned long long parse_size64(const char *str);
 unsigned long long __parse_size64(const char *str, unsigned long long *units);
 
+static inline bool is_power_of_2(unsigned int v)
+{
+	return v && ((v & (v - 1)) == 0);
+}
+
 #define ALIGN(x, a) ((((unsigned long long) x) + (a - 1)) & ~(a - 1))
 #define BITS_PER_LONG (sizeof(unsigned long) * 8)
 #define HPAGE_SIZE (2 << 20)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
