Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE6D51A1E5C
 for <linux-nvdimm@lists.01.org>; Tue, 13 Sep 2016 18:03:26 -0700 (PDT)
Subject: [ndctl PATCH 1/3] ndctl: {enable|disable}-dimm commands
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Sep 2016 18:00:23 -0700
Message-ID: <147381482309.12944.5502167246946077488.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147381481774.12944.1660067055752367684.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147381481774.12944.1660067055752367684.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Similar to ndctl {enable|disable}-region it may be useful to disable and
re-enable a dimm.  This refreshes the kernel's cached copy of a namespace
label, provided that any regions that the dimm contributes to have also been
disabled.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/Makefile.am            |    4 +
 Documentation/dimm-description.txt   |   15 ++++
 Documentation/ndctl-disable-dimm.txt |   22 +++++++
 Documentation/ndctl-enable-dimm.txt  |   22 +++++++
 Documentation/xable-dimm-options.txt |    9 +++
 ndctl/Makefile.am                    |    1 
 ndctl/builtin-xable-dimm.c           |  115 ++++++++++++++++++++++++++++++++++
 ndctl/builtin.h                      |    2 +
 ndctl/ndctl.c                        |    2 +
 9 files changed, 192 insertions(+)
 create mode 100644 Documentation/dimm-description.txt
 create mode 100644 Documentation/ndctl-disable-dimm.txt
 create mode 100644 Documentation/ndctl-enable-dimm.txt
 create mode 100644 Documentation/xable-dimm-options.txt
 create mode 100644 ndctl/builtin-xable-dimm.c

diff --git a/Documentation/Makefile.am b/Documentation/Makefile.am
index f0593e4fc7eb..63ef1ce7f2d7 100644
--- a/Documentation/Makefile.am
+++ b/Documentation/Makefile.am
@@ -4,6 +4,8 @@ man1_MANS = \
 	ndctl-read-labels.1 \
 	ndctl-enable-region.1 \
 	ndctl-disable-region.1 \
+	ndctl-enable-dimm.1 \
+	ndctl-disable-dimm.1 \
 	ndctl-enable-namespace.1 \
 	ndctl-disable-namespace.1 \
 	ndctl-create-namespace.1 \
@@ -17,6 +19,8 @@ XML_DEPS = \
 	Makefile \
 	region-description.txt \
 	xable-region-options.txt \
+	dimm-description.txt \
+	xable-dimm-options.txt \
 	xable-namespace-options.txt \
 	labels-description.txt \
 	labels-options.txt
diff --git a/Documentation/dimm-description.txt b/Documentation/dimm-description.txt
new file mode 100644
index 000000000000..95d0891c0b13
--- /dev/null
+++ b/Documentation/dimm-description.txt
@@ -0,0 +1,15 @@
+DESCRIPTION
+-----------
+A generic DIMM device object, named /dev/nmemX, is registered for each
+memory device indicated in the ACPI NFIT table, or other platform NVDIMM
+resource discovery mechanism.  The LIBNVDIMM core provides a built-in
+driver for these DIMM devices.  The driver is responsible for
+determining if the DIMM implements a namespace label area, and
+initializing the kernel's in-memory copy of that label data.
+
+The kernel performs runtime modifications of that data when namespace
+provisioning actions are taken, and actively blocks userspace from
+initiating label data changes while the DIMM is active in any region.
+Disabling a DIMM, after all the regions it is a member of have been
+disabled, allows userspace to manually update the label data to be
+consumed when the DIMM is next enabled.
diff --git a/Documentation/ndctl-disable-dimm.txt b/Documentation/ndctl-disable-dimm.txt
new file mode 100644
index 000000000000..b87314ffd197
--- /dev/null
+++ b/Documentation/ndctl-disable-dimm.txt
@@ -0,0 +1,22 @@
+ndctl-disable-dimm(1)
+=======================
+
+NAME
+----
+ndctl-disable-dimm - disable one or more idle dimms
+
+SYNOPSIS
+--------
+[verse]
+'ndctl disable-dimm' <dimm> [<options>]
+
+include::dimm-description.txt[]
+
+OPTIONS
+-------
+<dimm>::
+include::xable-dimm-options.txt[]
+
+SEE ALSO
+--------
+linkndctl:ndctl-enable-dimm[1]
diff --git a/Documentation/ndctl-enable-dimm.txt b/Documentation/ndctl-enable-dimm.txt
new file mode 100644
index 000000000000..0b0c6e0c965e
--- /dev/null
+++ b/Documentation/ndctl-enable-dimm.txt
@@ -0,0 +1,22 @@
+ndctl-enable-dimm(1)
+====================
+
+NAME
+----
+ndctl-enable-dimm - enable one more dimms
+
+SYNOPSIS
+--------
+[verse]
+'ndctl enable-dimm' <dimm> [<options>]
+
+include::dimm-description.txt[]
+
+OPTIONS
+-------
+<dimm>::
+include::xable-dimm-options.txt[]
+
+SEE ALSO
+--------
+linkndctl:ndctl-disable-dimm[1]
diff --git a/Documentation/xable-dimm-options.txt b/Documentation/xable-dimm-options.txt
new file mode 100644
index 000000000000..ad79208a61eb
--- /dev/null
+++ b/Documentation/xable-dimm-options.txt
@@ -0,0 +1,9 @@
+	A 'nmemX' device name, or a dimm id number. The keyword 'all' can
+	be specified to carry out the operation on every dimm in the system,
+	optionally filtered by bus id (see --bus= option).
+
+-b::
+--bus=::
+	Enforce that the operation only be carried on devices that are
+	attached to the given bus. Where 'bus' can be a provider name or a bus
+	id number.
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 04f3a63ff999..f7d0a96af4f9 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -39,6 +39,7 @@ ndctl_SOURCES = ndctl.c \
 		builtin-create-nfit.c \
 		builtin-xaction-namespace.c \
 		builtin-xable-region.c \
+		builtin-xable-dimm.c \
 		builtin-list.c \
 		builtin-test.c \
 		builtin-help.c \
diff --git a/ndctl/builtin-xable-dimm.c b/ndctl/builtin-xable-dimm.c
new file mode 100644
index 000000000000..4bdbc7f8eea3
--- /dev/null
+++ b/ndctl/builtin-xable-dimm.c
@@ -0,0 +1,115 @@
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <util/filter.h>
+#include <util/parse-options.h>
+#include <ndctl/libndctl.h>
+
+static const char *dimm_bus;
+
+static const struct option dimm_options[] = {
+	OPT_STRING('b', "bus", &dimm_bus, "bus-id",
+			"<dimm> must be on a bus with an id/provider of <bus-id>"),
+	OPT_END(),
+};
+
+static const char *parse_dimm_options(int argc, const char **argv,
+		char *xable_usage)
+{
+	const char * const u[] = {
+		xable_usage,
+		NULL
+	};
+	int i;
+
+        argc = parse_options(argc, argv, dimm_options, u, 0);
+
+	if (argc == 0)
+		error("specify a dimm to disable, or \"all\"\n");
+	for (i = 1; i < argc; i++)
+		error("unknown extra parameter \"%s\"\n", argv[i]);
+	if (argc == 0 || argc > 1) {
+		usage_with_options(u, dimm_options);
+		return NULL; /* we won't return from usage_with_options() */
+	}
+	return argv[0];
+}
+
+static int do_xable_dimm(const char *dimm_arg,
+		int (*xable_fn)(struct ndctl_dimm *), struct ndctl_ctx *ctx)
+{
+	int rc = -ENXIO, skip = 0, success = 0;
+	struct ndctl_dimm *dimm;
+	struct ndctl_bus *bus;
+
+	if (!dimm_arg)
+		goto out;
+
+        ndctl_bus_foreach(ctx, bus) {
+		if (!util_bus_filter(bus, dimm_bus))
+			continue;
+
+		ndctl_dimm_foreach(bus, dimm) {
+			if (!util_dimm_filter(dimm, dimm_arg))
+				continue;
+			if (xable_fn == ndctl_dimm_disable
+					&& ndctl_dimm_is_active(dimm)) {
+				fprintf(stderr, "%s is active, skipping...\n",
+						ndctl_dimm_get_devname(dimm));
+				skip++;
+				continue;
+			}
+			if (xable_fn(dimm) == 0)
+				success++;
+		}
+	}
+
+	rc = success;
+	if (!success && skip)
+		rc = EBUSY;
+ out:
+	dimm_bus = NULL;
+	return rc;
+}
+
+int cmd_disable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	char *xable_usage = "ndctl disable-dimm <dimm> [<options>]";
+	const char *dimm = parse_dimm_options(argc, argv, xable_usage);
+	int disabled = do_xable_dimm(dimm, ndctl_dimm_disable,
+			ctx);
+
+	if (disabled < 0) {
+		fprintf(stderr, "error disabling dimms: %s\n",
+				strerror(-disabled));
+		return disabled;
+	} else if (disabled == 0) {
+		fprintf(stderr, "disabled 0 dimms\n");
+		return 0;
+	} else {
+		fprintf(stderr, "disabled %d dimm%s\n", disabled,
+				disabled > 1 ? "s" : "");
+		return 0;
+	}
+}
+
+int cmd_enable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	char *xable_usage = "ndctl enable-dimm <dimm> [<options>]";
+	const char *dimm = parse_dimm_options(argc, argv, xable_usage);
+	int enabled = do_xable_dimm(dimm, ndctl_dimm_enable, ctx);
+
+	if (enabled < 0) {
+		fprintf(stderr, "error enabling dimms: %s\n",
+				strerror(-enabled));
+		return enabled;
+	} else if (enabled == 0) {
+		fprintf(stderr, "enabled 0 dimms\n");
+		return 0;
+	} else {
+		fprintf(stderr, "enabled %d dimm%s\n", enabled,
+				enabled > 1 ? "s" : "");
+		return 0;
+	}
+}
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index 46cd5d2d439c..ec55865ecea8 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -16,6 +16,8 @@ int cmd_destroy_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_disable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_enable_region(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_disable_region(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_enable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_disable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_zero_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_read_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_list(int argc, const char **argv, struct ndctl_ctx *ctx);
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 77f90d6087ba..aaeb3f7c2bec 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -32,6 +32,8 @@ static struct cmd_struct commands[] = {
 	{ "destroy-namespace", cmd_destroy_namespace },
 	{ "enable-region", cmd_enable_region },
 	{ "disable-region", cmd_disable_region },
+	{ "enable-dimm", cmd_enable_dimm },
+	{ "disable-dimm", cmd_disable_dimm },
 	{ "zero-labels", cmd_zero_labels },
 	{ "read-labels", cmd_read_labels },
 	{ "list", cmd_list },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
