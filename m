Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3511F21159CAA
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 17:53:56 -0700 (PDT)
Subject: [ndctl PATCH v3 3/3] ndctl: Revert "ndctl: Create ndctl udev rules
 for dirty shutdown"
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Sep 2018 17:41:53 -0700
Message-ID: <153809531364.1963951.13699408395606545074.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153809529764.1963951.7530312689559729607.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153809529764.1963951.7530312689559729607.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Environments that choose to implement dirty-shutdown mitigation can use
'list --dimm --health nmemX' to retrieve the dirty-shutdown count, or
the new 'nmemX/nfit/dirty_shutdown' attribute in sysfs. The kernel
otherwise takes no default action on that counter rolling. If the
platform advertises support for "Memory Controller Flush to NVDIMM
Durability on Power Loss Capable" then the default Linux policy is to
trust that designation.

Otherwise this usage of libndctl enumeration apis in the udev path
causes the entire udev queue to backup behind libnvdimm sub-system
initialization:

    INFO: task systemd-udevd:1554 blocked for more than 120 seconds.
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    systemd-udevd   D    0  1554   1544 0x80000004
    Call Trace:
     ? __schedule+0x25d/0x870
     schedule+0x28/0x80
     async_synchronize_cookie_domain+0x96/0x140
     ? finish_wait+0x80/0x80
     nvdimm_bus_check_dimm_count+0x31/0xa0 [libnvdimm]
     acpi_nfit_register_dimms+0x4b5/0x800 [nfit]
     acpi_nfit_init+0xca6/0x1300 [nfit]
     ? acpi_nfit_add+0x197/0x210 [nfit]
     acpi_nfit_add+0x197/0x210 [nfit]
     acpi_device_probe+0x48/0x110

Cc: Keith Busch <keith.busch@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 .gitignore             |    1 
 Makefile.am            |    3 -
 configure.ac           |   10 ---
 contrib/80-ndctl.rules |    3 -
 ndctl.spec.in          |    3 -
 ndctl/Makefile.am      |    5 --
 ndctl/ndctl-udev.c     |  150 ------------------------------------------------
 7 files changed, 175 deletions(-)
 delete mode 100644 contrib/80-ndctl.rules
 delete mode 100644 ndctl/ndctl-udev.c

diff --git a/.gitignore b/.gitignore
index f13a7ef5a608..0baace4b457e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -25,7 +25,6 @@ daxctl/lib/libdaxctl.pc
 *.a
 ndctl/lib/libndctl.pc
 ndctl/ndctl
-ndctl/ndctl-udev
 rhel/
 sles/ndctl.spec
 util/log.lo
diff --git a/Makefile.am b/Makefile.am
index 7880eef1c890..e0c463a3493a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -42,9 +42,6 @@ bashcompletiondir = $(BASH_COMPLETION_DIR)
 dist_bashcompletion_DATA = contrib/ndctl
 endif
 
-udevrulesdir = $(UDEVDIR)/rules.d
-dist_udevrules_DATA = contrib/80-ndctl.rules
-
 noinst_LIBRARIES = libccan.a
 libccan_a_SOURCES = \
 	ccan/str/str.h \
diff --git a/configure.ac b/configure.ac
index 9dc11da194d1..bb6b03324ea8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -153,17 +153,8 @@ fi
 AC_SUBST([systemd_unitdir])
 AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" = "xyes"])
 
-AC_ARG_WITH([tmpfilesdir],
-	[AS_HELP_STRING([--with-tmpfilesdir=DIR], [Directory for temporary runtime files])],
-	[tmpfilesdir=$withval],
-	[tmpfilesdir="/run"])
-
-UDEVDIR="$(pkg-config udev --variable=udevdir)"
-AC_SUBST([UDEVDIR])
-
 my_CFLAGS="\
 -D DEF_CONF_FILE='\"${sysconfdir}/ndctl/monitor.conf\"' \
--D DEF_TMPFS_DIR='\"${tmpfilesdir}/ndctl\"' \
 -Wall \
 -Wchar-subscripts \
 -Wformat-security \
@@ -204,7 +195,6 @@ AC_MSG_RESULT([
         sysconfdir:             ${sysconfdir}
         libdir:                 ${libdir}
         includedir:             ${includedir}
-        tmpfilesdir:            ${tmpfilesdir}
 
         compiler:               ${CC}
         cflags:                 ${CFLAGS}
diff --git a/contrib/80-ndctl.rules b/contrib/80-ndctl.rules
deleted file mode 100644
index 54788c40ea9d..000000000000
--- a/contrib/80-ndctl.rules
+++ /dev/null
@@ -1,3 +0,0 @@
-# do not edit this file, it will be overwritten on update
-
-ACTION=="add", KERNEL=="nmem*", RUN+="ndctl-udev $kernel"
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 98394a924030..26396d4abad7 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -110,7 +110,6 @@ make check
 %postun -n DAX_LNAME -p /sbin/ldconfig
 
 %define bashcompdir %(pkg-config --variable=completionsdir bash-completion)
-%define udevdir  %(pkg-config --variable=udevdir udev)
 
 %files
 %defattr(-,root,root)
@@ -120,8 +119,6 @@ make check
 %{bashcompdir}/
 %{_sysconfdir}/ndctl/monitor.conf
 %{_unitdir}/ndctl-monitor.service
-%{_udevrulesdir}/80-ndctl.rules
-%{udevdir}/ndctl-udev
 
 %files -n daxctl
 %defattr(-,root,root)
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index d6839e4a9fb6..8a5e5f87e6c5 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -51,8 +51,3 @@ EXTRA_DIST += $(monitor_config_file)
 if ENABLE_SYSTEMD_UNITS
 systemd_unit_DATA = ndctl-monitor.service
 endif
-
-ndctl_udevdir = $(UDEVDIR)
-ndctl_udev_PROGRAMS = ndctl-udev
-ndctl_udev_SOURCES = ndctl-udev.c
-ndctl_udev_LDADD = lib/libndctl.la
diff --git a/ndctl/ndctl-udev.c b/ndctl/ndctl-udev.c
deleted file mode 100644
index 7b174b61d8cd..000000000000
--- a/ndctl/ndctl-udev.c
+++ /dev/null
@@ -1,150 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
-
-#include <ctype.h>
-#include <errno.h>
-#include <fcntl.h>
-#include <stddef.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <sys/stat.h>
-#include <sys/types.h>
-#include <ndctl/libndctl.h>
-
-/**
- * mkdir_p
- *
- * Copied from util-linux lib/fileutils.c
- */
-static int mkdir_p(const char *path, mode_t mode)
-{
-	char *p, *dir;
-	int rc = 0;
-
-	if (!path || !*path)
-		return -EINVAL;
-
-	dir = p = strdup(path);
-	if (!dir)
-		return -ENOMEM;
-
-	if (*p == '/')
-		p++;
-
-	while (p && *p) {
-		char *e = strchr(p, '/');
-		if (e)
-			*e = '\0';
-		if (*p) {
-			rc = mkdir(dir, mode);
-			if (rc && errno != EEXIST)
-				break;
-			rc = 0;
-		}
-		if (!e)
-			break;
-		*e = '/';
-		p = e + 1;
-	}
-
-	free(dir);
-	return rc;
-}
-
-static struct ndctl_dimm *find_dimm(struct ndctl_ctx *ctx, const char *devname)
-{
-	struct ndctl_bus *bus;
-	struct ndctl_dimm *dimm;
-
-	ndctl_bus_foreach(ctx, bus) {
-		ndctl_dimm_foreach(bus, dimm) {
-			if (strcmp(ndctl_dimm_get_devname(dimm), devname) == 0)
-				return dimm;
-		}
-	}
-	return NULL;
-}
-
-static void ack_shutdown(struct ndctl_dimm *dimm)
-{
-	struct ndctl_cmd *cmd;
-
-	cmd = ndctl_dimm_cmd_new_ack_shutdown_count(dimm);
-	if (!cmd)
-		return;
-	ndctl_cmd_submit(cmd);
-	ndctl_cmd_unref(cmd);
-}
-
-static void save_unsafe_shutdown_count(struct ndctl_dimm *dimm,
-				       const char *devname)
-{
-	char *path, *usc, count[16];
-	unsigned int shutdown;
-	struct ndctl_cmd *cmd;
-	int fd;
-
-	cmd = ndctl_dimm_cmd_new_smart(dimm);
-	if (!cmd)
-		return;
-
-	if (ndctl_cmd_submit(cmd))
-		goto unref_cmd;
-
-	shutdown = ndctl_cmd_smart_get_shutdown_count(cmd);
-	if (shutdown == UINT_MAX)
-		goto unref_cmd;
-
-	if (asprintf(&path, DEF_TMPFS_DIR "/%s", devname) < 0)
-		goto unref_cmd;
-
-	if (mkdir_p(path, 0755))
-		goto free_path;
-
-	if (asprintf(&usc, "%s/usc", path) < 0)
-		goto free_path;
-
-	fd = open(usc, O_WRONLY | O_CREAT, 0644);
-	if (fd < 0)
-		goto free_usc;
-
-	if (snprintf(count, sizeof(count), "%u\n", shutdown) < 0)
-		goto close_fd;
-
-	if (write(fd, count, strlen(count)) < 0)
-		goto close_fd;
-
- close_fd:
-	close(fd);
- free_usc:
-	free(usc);
- free_path:
-	free(path);
- unref_cmd:
-	ndctl_cmd_unref(cmd);
-}
-
-int main(int argc, char *argv[])
-{
-	struct ndctl_ctx *ctx;
-	struct ndctl_dimm *dimm = NULL;
-	const char *devname;
-
-	if (argc < 2)
-		return EINVAL;
-
-	devname = argv[1];
-	if (ndctl_new(&ctx))
-		return ENOMEM;
-
-	dimm = find_dimm(ctx, devname);
-	if (!dimm)
-		return ENODEV;
-
-	ack_shutdown(dimm);
-	save_unsafe_shutdown_count(dimm, devname);
-
-	ndctl_unref(ctx);
-	return 0;
-}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
