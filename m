Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9C75B22526491
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 14:22:18 -0700 (PDT)
Subject: [ndctl PATCH 5/5] ndctl, scrub: add {wait,
 start}-scrub helper utilities
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Apr 2018 14:12:22 -0700
Message-ID: <152287634230.29230.8601744610482065793.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152287631592.29230.11531789298631204393.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152287631592.29230.11531789298631204393.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Provide utilities to make it easy for a platform owner to poll for the
completion of ARS scrubbing, or otherwise launch an ARS run across 1 or
more nvdimm buses.

These commands take 1 or more bus identifiers (bus device name, bus
number, or bus provider name), and runs a 'start' or 'wait' ARS
operation on each.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl/Makefile.am           |    3 +
 Documentation/ndctl/ars-description.txt   |    9 ++
 Documentation/ndctl/ndctl-start-scrub.txt |   61 ++++++++++++++
 Documentation/ndctl/ndctl-wait-scrub.txt  |   61 ++++++++++++++
 builtin.h                                 |    2 
 ndctl/Makefile.am                         |    1 
 ndctl/bus.c                               |  129 +++++++++++++++++++++++++++++
 ndctl/ndctl.c                             |    2 
 8 files changed, 268 insertions(+)
 create mode 100644 Documentation/ndctl/ars-description.txt
 create mode 100644 Documentation/ndctl/ndctl-start-scrub.txt
 create mode 100644 Documentation/ndctl/ndctl-wait-scrub.txt
 create mode 100644 ndctl/bus.c

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 9acb4acd966a..4f04087598b5 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -16,6 +16,8 @@ asciidoc.conf: ../asciidoc.conf.in
 
 man1_MANS = \
 	ndctl.1 \
+	ndctl-wait-scrub.1 \
+	ndctl-start-scrub.1 \
 	ndctl-zero-labels.1 \
 	ndctl-read-labels.1 \
 	ndctl-write-labels.1 \
@@ -46,6 +48,7 @@ XML_DEPS = \
 	dimm-description.txt \
 	xable-dimm-options.txt \
 	xable-namespace-options.txt \
+	ars-description.txt \
 	labels-description.txt \
 	labels-options.txt
 
diff --git a/Documentation/ndctl/ars-description.txt b/Documentation/ndctl/ars-description.txt
new file mode 100644
index 000000000000..23db8184dcf2
--- /dev/null
+++ b/Documentation/ndctl/ars-description.txt
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
+
+DESCRIPTION
+-----------
+NVDIMM Address Range Scrub is a capability provided by platform firmware
+that allows for the discovery of memory errors by system software. It
+enables system software to pre-emptively avoid accesses that could lead
+to uncorrectable memory error handling events, and it otherwise allows
+memory errors to be enumerated.
diff --git a/Documentation/ndctl/ndctl-start-scrub.txt b/Documentation/ndctl/ndctl-start-scrub.txt
new file mode 100644
index 000000000000..365918dec920
--- /dev/null
+++ b/Documentation/ndctl/ndctl-start-scrub.txt
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-start-scrub(1)
+====================
+
+NAME
+----
+ndctl-start-scrub - start an Address Range Scrub (ARS) operation
+
+SYNOPSIS
+--------
+[verse]
+'ndctl start-scrub' [<bus-id> <bus-id2> ... <bus-idN>] [<options>]
+
+include::ars-description.txt[]
+
+The kernel provides a sysfs file ('scrub') that when written with the
+string "1\n" initiates an ARS operation. The 'ndctl start-scrub'
+operation starts an ARS, across all specified buses, and the kernel in
+turn proceeds to scrub every persistent memory address region on the
+specified buses.
+
+EXAMPLE
+-------
+Start a scrub on all nvdimm buses in the system. The json listing report
+only includes the buses that support ARS operations.
+[verse]
+
+# ndctl start-scrub
+[
+  {
+    "provider":"nfit_test.1",
+    "dev":"ndbus3",
+    "scrub_state":"active"
+  },
+  {
+    "provider":"nfit_test.0",
+    "dev":"ndbus2",
+    "scrub_state":"active"
+  }
+]
+
+When specifying an individual bus, or if there is only one bus in the
+system, the command reports whether ARS support is available.
+[verse]
+# ndctl start-scrub e820
+error starting scrub: Operation not supported
+
+OPTIONS
+-------
+-v::
+--verbose::
+	Emit debug messages for the ARS start process
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkndctl:ndctl-wait-scrub[1],
+http://www.uefi.org/sites/default/files/resources/ACPI%206_2_A_Sept29.pdf[ACPI
+6.2 Specification Section 9.20.7.2 Address Range Scrubbing (ARS) Overview]
diff --git a/Documentation/ndctl/ndctl-wait-scrub.txt b/Documentation/ndctl/ndctl-wait-scrub.txt
new file mode 100644
index 000000000000..6b5f61fcf48f
--- /dev/null
+++ b/Documentation/ndctl/ndctl-wait-scrub.txt
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-wait-scrub(1)
+====================
+
+NAME
+----
+ndctl-wait-scrub - wait for an Address Range Scrub (ARS) operation to complete
+
+SYNOPSIS
+--------
+[verse]
+'ndctl wait-scrub' [<bus-id> <bus-id2> ... <bus-idN>] [<options>]
+
+include::ars-description.txt[]
+
+The kernel provides a POLL(2) capable sysfs file ('scrub') to indicate
+the state of ARS. The 'scrub' file maintains a running count of ARS runs
+that have taken place. While a current run is in progress a '+'
+character is emitted along with the current count. The 'ndctl
+wait-scrub' operation waits for 'scrub', across all specified buses, to
+indicate not in-progress at least once.
+
+EXAMPLE
+-------
+Wait for scrub on all nvdimm buses in the system. The json listing
+report at the end only includes the buses that support ARS operations.
+[verse]
+# ndctl wait-scrub
+[
+  {
+    "provider":"nfit_test.1",
+    "dev":"ndbus3",
+    "scrub_state":"idle"
+  },
+  {
+    "provider":"nfit_test.0",
+    "dev":"ndbus2",
+    "scrub_state":"idle"
+  }
+]
+
+When specifying an individual bus, or if there is only one bus in the
+system, the command reports whether ARS support is available.
+[verse]
+# ndctl wait-scrub e820
+error waiting for scrub completion: Operation not supported
+
+OPTIONS
+-------
+-v::
+--verbose::
+	Emit debug messages for the ARS wait process
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkndctl:ndctl-start-scrub[1],
+http://www.uefi.org/sites/default/files/resources/ACPI%206_2_A_Sept29.pdf[ACPI
+6.2 Specification Section 9.20.7.2 Address Range Scrubbing (ARS) Overview]
diff --git a/builtin.h b/builtin.h
index b24fc99781a9..d3cc7239cdd7 100644
--- a/builtin.h
+++ b/builtin.h
@@ -36,6 +36,8 @@ int cmd_write_labels(int argc, const char **argv, void *ctx);
 int cmd_init_labels(int argc, const char **argv, void *ctx);
 int cmd_check_labels(int argc, const char **argv, void *ctx);
 int cmd_inject_error(int argc, const char **argv, void *ctx);
+int cmd_wait_scrub(int argc, const char **argv, void *ctx);
+int cmd_start_scrub(int argc, const char **argv, void *ctx);
 int cmd_list(int argc, const char **argv, void *ctx);
 #ifdef ENABLE_TEST
 int cmd_test(int argc, const char **argv, void *ctx);
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 213cabd77a39..d22a37951537 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -3,6 +3,7 @@ include $(top_srcdir)/Makefile.am.in
 bin_PROGRAMS = ndctl
 
 ndctl_SOURCES = ndctl.c \
+		bus.c \
 		create-nfit.c \
 		namespace.c \
 		check.c \
diff --git a/ndctl/bus.c b/ndctl/bus.c
new file mode 100644
index 000000000000..fc31d065b1a5
--- /dev/null
+++ b/ndctl/bus.c
@@ -0,0 +1,129 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2015-2018 Intel Corporation. All rights reserved. */
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include "action.h"
+#include <syslog.h>
+#include <builtin.h>
+#include <util/json.h>
+#include <util/filter.h>
+#include <json-c/json.h>
+#include <util/parse-options.h>
+#include <ndctl/libndctl.h>
+#include <ccan/array_size/array_size.h>
+
+static struct {
+	bool verbose;
+} param;
+
+static const struct option bus_options[] = {
+	OPT_BOOLEAN('v',"verbose", &param.verbose, "turn on debug"),
+	OPT_END(),
+};
+
+static int scrub_action(struct ndctl_bus *bus, enum device_action action)
+{
+	switch (action) {
+	case ACTION_WAIT:
+		return ndctl_bus_wait_for_scrub_completion(bus);
+	case ACTION_START:
+		return ndctl_bus_start_scrub(bus);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int bus_action(int argc, const char **argv, const char *usage,
+		const struct option *options, enum device_action action,
+		struct ndctl_ctx *ctx)
+{
+	const char * const u[] = {
+		usage,
+		NULL
+	};
+	struct json_object *jbuses, *jbus;
+	int i, rc, success = 0, fail = 0;
+	struct ndctl_bus *bus;
+	const char *all = "all";
+
+	argc = parse_options(argc, argv, options, u, 0);
+
+	if (param.verbose)
+		ndctl_set_log_priority(ctx, LOG_DEBUG);
+
+	if (argc == 0) {
+		argc = 1;
+		argv = &all;
+	} else
+		for (i = 0; i < argc; i++)
+			if (strcmp(argv[i], "all") == 0) {
+				argv[0] = "all";
+				argc = 1;
+				break;
+			}
+
+	jbuses = json_object_new_array();
+	if (!jbuses)
+		return -ENOMEM;
+	for (i = 0; i < argc; i++) {
+		int found = 0;
+
+		ndctl_bus_foreach(ctx, bus) {
+			if (!util_bus_filter(bus, argv[i]))
+				continue;
+			found++;
+			rc = scrub_action(bus, action);
+			if (rc == 0) {
+				success++;
+				jbus = util_bus_to_json(bus);
+				if (jbus)
+					json_object_array_add(jbuses, jbus);
+			} else if (!fail)
+				fail = rc;
+		}
+		if (!found && param.verbose)
+			fprintf(stderr, "no bus matches id: %s\n", argv[i]);
+	}
+
+	if (success)
+		util_display_json_array(stdout, jbuses,
+				JSON_C_TO_STRING_PRETTY);
+	else
+		json_object_put(jbuses);
+
+	if (success)
+		return success;
+	return fail ? fail : -ENXIO;
+}
+
+int cmd_start_scrub(int argc, const char **argv, void *ctx)
+{
+	char *usage = "ndctl start-scrub [<bus-id> <bus-id2> ... <bus-idN>] [<options>]";
+	int start = bus_action(argc, argv, usage, bus_options,
+			ACTION_START, ctx);
+
+	if (start <= 0) {
+		fprintf(stderr, "error starting scrub: %s\n",
+				strerror(-start));
+		return start;
+	} else {
+		return 0;
+	}
+}
+
+int cmd_wait_scrub(int argc, const char **argv, void *ctx)
+{
+	char *usage = "ndctl wait-scrub [<bus-id> <bus-id2> ... <bus-idN>] [<options>]";
+	int wait = bus_action(argc, argv, usage, bus_options,
+			ACTION_WAIT, ctx);
+
+	if (wait <= 0) {
+		fprintf(stderr, "error waiting for scrub completion: %s\n",
+				strerror(-wait));
+		return wait;
+	} else {
+		return 0;
+	}
+}
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index d3c6db1b6bf0..7daadebd52fc 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -86,6 +86,8 @@ static struct cmd_struct commands[] = {
 	{ "inject-error", cmd_inject_error },
 	{ "update-firmware", cmd_update_firmware },
 	{ "inject-smart", cmd_inject_smart },
+	{ "wait-scrub", cmd_wait_scrub },
+	{ "start-scrub", cmd_start_scrub },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
