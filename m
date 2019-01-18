Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B1DCC211B509C
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 18:45:49 -0800 (PST)
Subject: [daxctl PATCH v3 2/3] daxctl: Opt-in to /sys/bus/dax ABI
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 17 Jan 2019 18:33:12 -0800
Message-ID: <154777879210.2060068.9499556446000630007.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154777878104.2060068.1465998507656988115.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <154777878104.2060068.1465998507656988115.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The kernel is implementing a '/sys/bus/dax' ABI to allow for alternate
device-DAX drivers to be bound to device instances. While the kernel's
conversion to '/sys/bus/dax' does not affect the primary ndctl use case
of putting namespaces into 'devdax' mode since that uses libnvdimm
namespace device relative paths, it does break current implementations
of 'ndctl list -X' and 'daxctl list'.  It is also known to break fio and
some pmdk versions that explicitly reference "/sys/class/dax".

In order to avoid userspace regressions the kernel can be configured to
maintain '/sys/class/dax' as the default ABI. However, once all
'/sys/class/dax' users have been converted, or removed from the
installation, an administrator can opt-in to the new '/sys/bus/dax' ABI.
The 'dax migrate-device-model' command installs a modprobe rule to
blacklist the dax_pmem_compat module and arrange for the dax_pmem module
to auto-load in response to the detection of device-DAX instances
emitted from the libnvdimm subsystem.

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 .gitignore                                         |    1 
 Documentation/daxctl/Makefile.am                   |    3 +
 .../daxctl/daxctl-migrate-device-model.txt         |   47 ++++++++++++++++++++
 configure.ac                                       |    5 ++
 daxctl/Makefile.am                                 |   10 ++++
 daxctl/builtin.h                                   |    1 
 daxctl/daxctl.c                                    |    1 
 daxctl/lib/Makefile.am                             |    2 +
 daxctl/lib/daxctl.conf                             |    2 +
 daxctl/migrate.c                                   |   41 +++++++++++++++++
 ndctl.spec.in                                      |    1 
 11 files changed, 113 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/daxctl/daxctl-migrate-device-model.txt
 create mode 100644 daxctl/lib/daxctl.conf
 create mode 100644 daxctl/migrate.c

diff --git a/.gitignore b/.gitignore
index 5a3d8e4507e5..3ef9ff7a9a2f 100644
--- a/.gitignore
+++ b/.gitignore
@@ -18,6 +18,7 @@ Documentation/ndctl/asciidoc.conf
 Documentation/daxctl/asciidoctor-extensions.rb
 Documentation/ndctl/asciidoctor-extensions.rb
 .dirstamp
+daxctl/config.h
 daxctl/daxctl
 daxctl/lib/libdaxctl.la
 daxctl/lib/libdaxctl.lo
diff --git a/Documentation/daxctl/Makefile.am b/Documentation/daxctl/Makefile.am
index fc0fbe138d93..6aba035ff543 100644
--- a/Documentation/daxctl/Makefile.am
+++ b/Documentation/daxctl/Makefile.am
@@ -27,7 +27,8 @@ endif
 
 man1_MANS = \
 	daxctl.1 \
-	daxctl-list.1
+	daxctl-list.1 \
+	daxctl-migrate-device-model.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/daxctl/daxctl-migrate-device-model.txt b/Documentation/daxctl/daxctl-migrate-device-model.txt
new file mode 100644
index 000000000000..23e89f1afafc
--- /dev/null
+++ b/Documentation/daxctl/daxctl-migrate-device-model.txt
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+
+daxctl-migrate-device-model(1)
+==============================
+
+NAME
+----
+daxctl-migrate-device-model - Opt-in to the /sys/bus/dax device-model,
+allow for alternative Device-DAX instance drivers.
+
+SYNOPSIS
+--------
+[verse]
+'daxctl migrate-device-model'
+
+Arrange for modprobe to disable the dax_pmem_compat, if present, and
+instead deploy the dax_pmem module to convert to the /sys/bus/dax model.
+Kernel versions prior to v5.1 may not support /sys/bus/dax in which case
+the result of this command is a nop until the kernel is updated.  The
+motivation for changing from /sys/class/dax to /sys/bus/dax is to allow
+for alternative drivers for Device-DAX instances, in particular the
+dax_kmem driver.
+
+By default device-dax publishes a /dev/daxX.Y character device for
+userspace to directly map performance differentiated memory. This is
+fine if the memory is to be exclusively consumed / managed by userspace.
+Alternatively an administrator may want the kernel to manage the memory,
+make it available via malloc(), allow for over-provisioning, and / or
+apply kernel-based resource control schemes to the memory. In that case
+the memory fronted by a given Device-DAX instance can be assigned to the
+dax_kmem driver which arranges for the core-kernel memory-management
+sub-system to assume management of the memory range.
+
+This behavior is opt-in for consideration of existing applications /
+scripts that may be hard coded to use /sys/class/dax. Fixes have been
+submitted to applications known to have these direct dependencies
+http://git.kernel.dk/cgit/fio/commit/?id=b08e7d6b18b4[FIO]
+https://github.com/pmem/pmdk/commit/91bc8620884e[PMDK], however, there may
+be others and a system-owner should be aware of the potential for
+regression of Device-DAX consuming scripts, applications, or older
+daxctl binaries.
+
+The modprobe policy established by this utility becomes effective after
+the next reboot, or after all DAX related modules have been removed and
+re-loaded with "udevadm trigger"
+
+include::../copyright.txt[]
diff --git a/configure.ac b/configure.ac
index a02a2d80e1d5..5b4f1fc8d346 100644
--- a/configure.ac
+++ b/configure.ac
@@ -159,6 +159,11 @@ ndctl_monitorconf=monitor.conf
 AC_SUBST([ndctl_monitorconfdir])
 AC_SUBST([ndctl_monitorconf])
 
+daxctl_modprobe_datadir=${datadir}/daxctl
+daxctl_modprobe_data=daxctl.conf
+AC_SUBST([daxctl_modprobe_datadir])
+AC_SUBST([daxctl_modprobe_data])
+
 my_CFLAGS="\
 -Wall \
 -Wchar-subscripts \
diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
index fe467d030c38..94f73f93f388 100644
--- a/daxctl/Makefile.am
+++ b/daxctl/Makefile.am
@@ -2,9 +2,19 @@ include $(top_srcdir)/Makefile.am.in
 
 bin_PROGRAMS = daxctl
 
+DISTCLEANFILES = config.h
+BUILT_SOURCES = config.h
+config.h: $(srcdir)/Makefile.am
+	$(AM_V_GEN) echo "/* Autogenerated by daxctl/Makefile.am */" >$@ && \
+	echo '#define DAXCTL_MODPROBE_DATA \
+		"$(daxctl_modprobe_datadir)/$(daxctl_modprobe_data)"' >>$@ && \
+	echo '#define DAXCTL_MODPROBE_INSTALL \
+		"$(sysconfdir)/modprobe.d/$(daxctl_modprobe_data)"' >>$@
+
 daxctl_SOURCES =\
 		daxctl.c \
 		list.c \
+		migrate.c \
 		../util/json.c
 
 daxctl_LDADD =\
diff --git a/daxctl/builtin.h b/daxctl/builtin.h
index dae2615b7ddb..00ef5e930417 100644
--- a/daxctl/builtin.h
+++ b/daxctl/builtin.h
@@ -5,4 +5,5 @@
 
 struct daxctl_ctx;
 int cmd_list(int argc, const char **argv, struct daxctl_ctx *ctx);
+int cmd_migrate(int argc, const char **argv, struct daxctl_ctx *ctx);
 #endif /* _DAXCTL_BUILTIN_H_ */
diff --git a/daxctl/daxctl.c b/daxctl/daxctl.c
index cb6f50e39170..2e41747b5ea9 100644
--- a/daxctl/daxctl.c
+++ b/daxctl/daxctl.c
@@ -70,6 +70,7 @@ static struct cmd_struct commands[] = {
 	{ "version", .d_fn = cmd_version },
 	{ "list", .d_fn = cmd_list },
 	{ "help", .d_fn = cmd_help },
+	{ "migrate-device-model", .d_fn = cmd_migrate },
 };
 
 int main(int argc, const char **argv)
diff --git a/daxctl/lib/Makefile.am b/daxctl/lib/Makefile.am
index 0167e3995b00..d3d4852916ca 100644
--- a/daxctl/lib/Makefile.am
+++ b/daxctl/lib/Makefile.am
@@ -18,6 +18,8 @@ libdaxctl_la_SOURCES =\
 libdaxctl_la_LIBADD =\
 	$(UUID_LIBS)
 
+daxctl_modprobe_data_DATA = daxctl.conf
+
 EXTRA_DIST += libdaxctl.sym
 
 libdaxctl_la_LDFLAGS = $(AM_LDFLAGS) \
diff --git a/daxctl/lib/daxctl.conf b/daxctl/lib/daxctl.conf
new file mode 100644
index 000000000000..c64a088cbc0b
--- /dev/null
+++ b/daxctl/lib/daxctl.conf
@@ -0,0 +1,2 @@
+blacklist dax_pmem_compat
+alias nd:t7* dax_pmem
diff --git a/daxctl/migrate.c b/daxctl/migrate.c
new file mode 100644
index 000000000000..d859b0856338
--- /dev/null
+++ b/daxctl/migrate.c
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2019 Intel Corporation. All rights reserved. */
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <stdio.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <daxctl/config.h>
+#include <daxctl/libdaxctl.h>
+#include <util/parse-options.h>
+#include <ccan/array_size/array_size.h>
+
+int cmd_migrate(int argc, const char **argv, struct daxctl_ctx *ctx)
+{
+	int i;
+	static const struct option options[] = {
+		OPT_END(),
+	};
+	const char * const u[] = {
+		"daxctl migrate-device-model",
+		NULL
+	};
+
+	argc = parse_options(argc, argv, options, u, 0);
+	for (i = 0; i < argc; i++)
+		error("unknown parameter \"%s\"\n", argv[i]);
+
+	if (argc)
+		usage_with_options(u, options);
+
+	if (symlink(DAXCTL_MODPROBE_DATA, DAXCTL_MODPROBE_INSTALL) == 0) {
+		fprintf(stderr, " success: installed %s\n",
+				DAXCTL_MODPROBE_INSTALL);
+		return EXIT_SUCCESS;
+	}
+
+	error("failed to install %s: %s\n", DAXCTL_MODPROBE_INSTALL,
+			strerror(errno));
+
+	return EXIT_FAILURE;
+}
diff --git a/ndctl.spec.in b/ndctl.spec.in
index bc4d65c1f988..bc65a471a6d2 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -126,6 +126,7 @@ make check
 %license util/COPYING licenses/BSD-MIT licenses/CC0
 %{_bindir}/daxctl
 %{_mandir}/man1/daxctl*
+%{_datadir}/daxctl/daxctl.conf
 
 %files -n LNAME
 %defattr(-,root,root)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
