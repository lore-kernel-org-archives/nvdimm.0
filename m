Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A721E21F3882D
 for <linux-nvdimm@lists.01.org>; Thu, 12 Oct 2017 17:08:47 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 3/6] ndctl: add an inject-error command
Date: Thu, 12 Oct 2017 18:10:01 -0600
Message-Id: <20171013001004.14963-4-vishal.l.verma@intel.com>
In-Reply-To: <20171013001004.14963-1-vishal.l.verma@intel.com>
References: <20171013001004.14963-1-vishal.l.verma@intel.com>
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

Add an inject-error command to ndctl. This uses the error injection DSMs
in ACPI6.2 to provide a generic error injection and management
interface. Once can inject errors, and view as well as clear injected
errors using these commands.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/Makefile.am            |   1 +
 Documentation/ndctl/ndctl-inject-error.txt | 108 +++++++++
 Documentation/ndctl/ndctl.txt              |   1 +
 builtin.h                                  |   1 +
 contrib/ndctl                              |   5 +-
 ndctl/Makefile.am                          |   3 +-
 ndctl/inject-error.c                       | 373 +++++++++++++++++++++++++++++
 ndctl/libndctl-nfit.h                      |   8 +
 ndctl/ndctl.c                              |   1 +
 util/json.c                                |  26 ++
 util/json.h                                |   3 +
 util/list.h                                |  50 ++++
 util/size.h                                |   1 +
 13 files changed, 579 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ndctl/ndctl-inject-error.txt
 create mode 100644 ndctl/inject-error.c
 create mode 100644 util/list.h

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 229d908..615baf0 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -30,6 +30,7 @@ man1_MANS = \
 	ndctl-create-namespace.1 \
 	ndctl-destroy-namespace.1 \
 	ndctl-check-namespace.1 \
+	ndctl-inject-error.1 \
 	ndctl-list.1
 
 CLEANFILES = $(man1_MANS)
diff --git a/Documentation/ndctl/ndctl-inject-error.txt b/Documentation/ndctl/ndctl-inject-error.txt
new file mode 100644
index 0000000..a7a8959
--- /dev/null
+++ b/Documentation/ndctl/ndctl-inject-error.txt
@@ -0,0 +1,108 @@
+ndctl-inject-error(1)
+=====================
+
+NAME
+----
+ndctl-inject-error - inject media errors at a namespace offset
+
+SYNOPSIS
+--------
+[verse]
+'ndctl inject-error' <namespace> [<options>]
+
+include::namespace-description.txt[]
+
+ndctl-inject-error can be used to ask the platform to simulate media errors
+in the NVDIMM address space to aid debugging and development of features
+related to error handling.
+
+WARNING: These commands are DANGEROUS and can cause data loss. They are
+only provided for testing and debugging purposes.
+
+EXAMPLES
+--------
+
+Inject errors in namespace0.0 at block 12 for a 2 blocks (i.e. 12, 13)
+[verse]
+ndctl inject-error --block=12 --count=2 namespace0.0
+
+Check status of injected errors on namespace0.0
+[verse]
+ndctl inject-error --status namespace0.0
+
+Uninject errors at block 12 for 2 blocks on namespace0.0
+[verse]
+ndctl inject-error --uninject --block=12 --count=2 namespace0.0
+
+OPTIONS
+-------
+-B::
+--block=::
+	Namespace block offset in 512 byte sized blocks where the error is
+	to be injected.
+
+	NOTE: The offset is interpreted in different ways based on the "mode"
+	of the namespace. For "raw" mode, the offset is the base namespace
+	offset. For "memory" mode (i.e. a "pfn" namespace), the offset is
+	relative to the user-visible part of the namespace, and the offset
+	introduced by the kernel's metadata will be accounted for. For a
+	"sector" mode namespace (i.e. a "BTT" namespace), the offset is
+	relative to the base namespace, as the BTT translation details are
+	internal to the kernel, and can't be accounted for while injecting
+	errors.
+
+-n::
+--count=::
+	Number of blocks to inject as errors. This is also in terms of fixed,
+	512 byte blocks.
+
+-d::
+--uninject::
+	This option will ask the platform to remove any injected errors for the
+	specified block offset, and count.
+
+	WARNING: This will not clear the kernel's internal badblock tracking,
+	those can only be cleared by doing a write to the affected locations.
+	Hence use the --clear option only if you know exactly what you are
+	doing. For normal usage, injected errors should only be cleared by
+	doing writes. Do not expect have the original data intact after
+	injecting an error, and clearing it using --clear - it will be lost,
+	as the only "real" way to clear the error location is to write to it
+	or zero it (truncate/hole-punch).
+
+-t::
+--status::
+	This option will retrieve the status of injected errors. Note that
+	this will not retrieve all known/latent errors (i.e. non injected
+	ones), and is NOT equivalent to performing an Address Range Scrub.
+
+-N::
+--no-notify::
+	This option is only valid when injecting errors. By default, the error
+	inject command and will ask platform firmware to trigger a notification
+	in the kernel, asking it to update its state of known errors.
+	With this option, the error will still be injected, the kernel will not
+	get a notification, and the error will appear as a latent media error
+	when the location is accessed. If the platform firmware does not
+	support this feature, this will have no effect.
+
+-v::
+--verbose::
+	Emit debug messages for the error injection process
+
+include::human-option.txt[]
+
+-r::
+--region=::
+include::xable-region-options.txt[]
+
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
+
+SEE ALSO
+--------
+linkndctl:ndctl-list[1],
diff --git a/Documentation/ndctl/ndctl.txt b/Documentation/ndctl/ndctl.txt
index b02f613..b2e2ab9 100644
--- a/Documentation/ndctl/ndctl.txt
+++ b/Documentation/ndctl/ndctl.txt
@@ -50,6 +50,7 @@ linkndctl:ndctl-enable-namespace[1],
 linkndctl:ndctl-disable-namespace[1],
 linkndctl:ndctl-zero-labels[1],
 linkndctl:ndctl-read-labels[1],
+linkndctl:ndctl-inject-error[1],
 linkndctl:ndctl-list[1],
 https://www.kernel.org/doc/Documentation/nvdimm/nvdimm.txt[LIBNVDIMM
 Overview],
diff --git a/builtin.h b/builtin.h
index 5c8b611..5e1b7ef 100644
--- a/builtin.h
+++ b/builtin.h
@@ -35,6 +35,7 @@ int cmd_read_labels(int argc, const char **argv, void *ctx);
 int cmd_write_labels(int argc, const char **argv, void *ctx);
 int cmd_init_labels(int argc, const char **argv, void *ctx);
 int cmd_check_labels(int argc, const char **argv, void *ctx);
+int cmd_inject_error(int argc, const char **argv, void *ctx);
 int cmd_list(int argc, const char **argv, void *ctx);
 #ifdef ENABLE_TEST
 int cmd_test(int argc, const char **argv, void *ctx);
diff --git a/contrib/ndctl b/contrib/ndctl
index c7d1b67..86718eb 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -91,7 +91,7 @@ __ndctlcomp()
 
 	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
 	for cword in "${COMPREPLY[@]}"; do
-		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace|--input|--output|--label-version|--align) ]]; then
+		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace|--input|--output|--label-version|--align|--block|--count) ]]; then
 			COMPREPLY[$i]="${cword}="
 		else
 			COMPREPLY[$i]="${cword} "
@@ -257,6 +257,9 @@ __ndctl_comp_non_option_args()
 	zero-labels)
 		opts="$(__ndctl_get_dimms -i) all"
 		;;
+	inject-error)
+		opts="$(__ndctl_get_ns -i)"
+		;;
 	*)
 		return
 		;;
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index d346c04..a0cf500 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -11,7 +11,8 @@ ndctl_SOURCES = ndctl.c \
 		 ../util/log.c \
 		list.c \
 		test.c \
-		../util/json.c
+		../util/json.c \
+		inject-error.c
 
 if ENABLE_SMART
 ndctl_SOURCES += util/json-smart.c
diff --git a/ndctl/inject-error.c b/ndctl/inject-error.c
new file mode 100644
index 0000000..4c45902
--- /dev/null
+++ b/ndctl/inject-error.c
@@ -0,0 +1,373 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
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
+#include <fcntl.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <string.h>
+#include <limits.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <sys/types.h>
+#include <sys/ioctl.h>
+
+#include <util/log.h>
+#include <util/size.h>
+#include <util/json.h>
+#include <json-c/json.h>
+#include <util/filter.h>
+#include <ndctl/libndctl.h>
+#include <util/parse-options.h>
+#include <ccan/array_size/array_size.h>
+#include <ccan/short_types/short_types.h>
+#ifdef HAVE_NDCTL_H
+#include <linux/ndctl.h>
+#else
+#include <ndctl.h>
+#endif
+
+#include "private.h"
+#include <builtin.h>
+#include <test.h>
+
+static bool verbose;
+static struct parameters {
+	const char *bus;
+	const char *region;
+	const char *namespace;
+	const char *block;
+	const char *count;
+	bool clear;
+	bool status;
+	bool no_notify;
+	bool human;
+} param;
+
+static struct inject_ctx {
+	u64 block;
+	u64 count;
+	unsigned int op_mask;
+	unsigned long flags;
+	bool notify;
+} ictx;
+
+#define BASE_OPTIONS() \
+OPT_STRING('b', "bus", &param.bus, "bus-id", \
+	"limit namespace to a bus with an id or provider of <bus-id>"), \
+OPT_STRING('r', "region", &param.region, "region-id", \
+	"limit namespace to a region with an id or name of <region-id>"), \
+OPT_BOOLEAN('v', "verbose", &verbose, "emit extra debug messages to stderr")
+
+#define INJECT_OPTIONS() \
+OPT_STRING('B', "block", &param.block, "namespace block offset (512B)", \
+	"specify the block at which to (un)inject the error"), \
+OPT_STRING('n', "count", &param.count, "count", \
+	"specify the number of blocks of errors to (un)inject"), \
+OPT_BOOLEAN('d', "uninject", &param.clear, \
+	"un-inject a previously injected error"), \
+OPT_BOOLEAN('t', "status", &param.status, "get error injection status"), \
+OPT_BOOLEAN('N', "no-notify", &param.no_notify, "firmware should not notify OS"), \
+OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats ")
+
+static const struct option inject_options[] = {
+	BASE_OPTIONS(),
+	INJECT_OPTIONS(),
+	OPT_END(),
+};
+
+enum {
+	OP_INJECT = 0,
+	OP_CLEAR,
+	OP_STATUS,
+};
+
+static int inject_init(void)
+{
+	if (!param.clear && !param.status) {
+		ictx.op_mask |= 1 << OP_INJECT;
+		ictx.notify = true;
+		if (param.no_notify)
+			ictx.notify = false;
+	}
+	if (param.clear) {
+		if (param.status) {
+			error("status is invalid with inject or uninject\n");
+			return -EINVAL;
+		}
+		ictx.op_mask |= 1 << OP_CLEAR;
+	}
+	if (param.status) {
+		if (param.block || param.count) {
+			error("status is invalid with inject or uninject\n");
+			return -EINVAL;
+		}
+		ictx.op_mask |= 1 << OP_STATUS;
+	}
+
+	if (ictx.op_mask == 0) {
+		error("Unable to determine operation\n");
+		return -EINVAL;
+	}
+	ictx.op_mask &= (
+		(1 << OP_INJECT) |
+		(1 << OP_CLEAR) |
+		(1 << OP_STATUS));
+
+	if (param.block) {
+		ictx.block = parse_size64(param.block);
+		if (ictx.block == ULLONG_MAX) {
+			error("Invalid block: %s\n", param.block);
+			return -EINVAL;
+		}
+	}
+	if (param.count) {
+		ictx.count = parse_size64(param.count);
+		if (ictx.count == ULLONG_MAX) {
+			error("Invalid count: %s\n", param.count);
+			return -EINVAL;
+		}
+	}
+
+	/* For inject or clear, an block and count are required */
+	if (ictx.op_mask & ((1 << OP_INJECT) | (1 << OP_CLEAR))) {
+		if (!param.block || !param.count) {
+			error("block and count required for inject/uninject\n");
+			return -EINVAL;
+		}
+	}
+
+	if (param.human)
+		ictx.flags |= UTIL_JSON_HUMAN;
+
+	return 0;
+}
+
+static int ns_errors_to_json(struct ndctl_namespace *ndns,
+		unsigned int start_count)
+{
+	unsigned long flags = ictx.flags | UTIL_JSON_MEDIA_ERRORS;
+	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
+	struct json_object *jndns;
+	unsigned int count;
+	int rc, tmo = 30;
+
+	/* only wait for scrubs for the inject and notify case */
+	if ((ictx.op_mask & (1 << OP_INJECT)) && ictx.notify) {
+		do {
+			/* wait for a scrub to start */
+			count = ndctl_bus_get_scrub_count(bus);
+			if (count == UINT_MAX) {
+				fprintf(stderr, "Unable to get scrub count\n");
+				return -ENXIO;
+			}
+			sleep(1);
+		} while (count <= start_count && --tmo > 0);
+
+		rc = ndctl_bus_wait_for_scrub_completion(bus);
+		if (rc) {
+			fprintf(stderr, "Error waiting for scrub\n");
+			return rc;
+		}
+	}
+
+	jndns = util_namespace_to_json(ndns, flags);
+	if (jndns)
+		printf("%s\n", json_object_to_json_string_ext(jndns,
+				JSON_C_TO_STRING_PRETTY));
+	return 0;
+}
+
+static int inject_error(struct ndctl_namespace *ndns, u64 offset, u64 length,
+		bool notify)
+{
+	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
+	unsigned int scrub_count;
+	int rc;
+
+	scrub_count = ndctl_bus_get_scrub_count(bus);
+	if (scrub_count == UINT_MAX) {
+		fprintf(stderr, "Unable to get scrub count\n");
+		return -ENXIO;
+	}
+
+	rc = ndctl_namespace_inject_error(ndns, offset, length, notify);
+	if (rc) {
+		fprintf(stderr, "Unable to inject error: %d\n", rc);
+		return rc;
+	}
+
+	return ns_errors_to_json(ndns, scrub_count);
+}
+
+static int uninject_error(struct ndctl_namespace *ndns, u64 offset, u64 length)
+{
+	int rc;
+
+	rc = ndctl_namespace_uninject_error(ndns, offset, length);
+	if (rc) {
+		fprintf(stderr, "Unable to uninject error: %d\n", rc);
+		return rc;
+	}
+
+	printf("Warning: Un-injecting previously injected errors here will\n");
+	printf("not cause the kernel to 'forget' its badblock entries. Those\n");
+	printf("have to be cleared through the normal process of writing\n");
+	printf("the affected blocks\n\n");
+	return ns_errors_to_json(ndns, 0);
+}
+
+static int injection_status(struct ndctl_namespace *ndns)
+{
+	unsigned long long block, count, bbs = 0;
+	struct json_object *jbbs, *jbb, *jobj;
+	struct ndctl_bb *bb;
+	int rc;
+
+	rc = ndctl_namespace_injection_status(ndns);
+	if (rc) {
+		fprintf(stderr, "Unable to get injection status: %d\n", rc);
+		return rc;
+	}
+
+	jobj = json_object_new_object();
+	if (!jobj)
+		return -ENOMEM;
+	jbbs = json_object_new_array();
+	if (!jbbs) {
+		json_object_put(jobj);
+		return -ENOMEM;
+	}
+
+	ndctl_namespace_bb_foreach(ndns, bb) {
+		if (!bb)
+			break;
+
+		block = ndctl_bb_get_block(bb);
+		count = ndctl_bb_get_count(bb);
+		jbb = util_badblock_rec_to_json(block, count, ictx.flags);
+		if (!jbb)
+			break;
+		json_object_array_add(jbbs, jbb);
+		bbs++;
+	}
+
+	if (bbs) {
+		json_object_object_add(jobj, "badblocks", jbbs);
+		printf("%s\n", json_object_to_json_string_ext(jobj,
+			JSON_C_TO_STRING_PRETTY));
+	}
+
+	json_object_put(jbbs);
+	json_object_put(jobj);
+
+	return rc;
+}
+
+static int err_inject_ns(struct ndctl_namespace *ndns)
+{
+	unsigned int op_mask;
+	int rc;
+
+	op_mask = ictx.op_mask;
+	while (op_mask) {
+		if (op_mask & (1 << OP_INJECT)) {
+			rc = inject_error(ndns, ictx.block, ictx.count,
+				ictx.notify);
+			if (rc)
+				return rc;
+			op_mask &= ~(1 << OP_INJECT);
+		}
+		if (op_mask & (1 << OP_CLEAR)) {
+			rc = uninject_error(ndns, ictx.block, ictx.count);
+			if (rc)
+				return rc;
+			op_mask &= ~(1 << OP_CLEAR);
+		}
+		if (op_mask & (1 << OP_STATUS)) {
+			rc = injection_status(ndns);
+			if (rc)
+				return rc;
+			op_mask &= ~(1 << OP_STATUS);
+		}
+	}
+
+	return rc;
+}
+
+static int do_inject(const char *namespace, struct ndctl_ctx *ctx)
+{
+	struct ndctl_namespace *ndns;
+	struct ndctl_region *region;
+	const char *ndns_name;
+	struct ndctl_bus *bus;
+	int rc = -ENXIO;
+
+	if (namespace == NULL)
+		return rc;
+
+	if (verbose)
+		ndctl_set_log_priority(ctx, LOG_DEBUG);
+
+        ndctl_bus_foreach(ctx, bus) {
+		if (!util_bus_filter(bus, param.bus))
+			continue;
+
+		ndctl_region_foreach(bus, region) {
+			if (!util_region_filter(region, param.region))
+				continue;
+
+			ndctl_namespace_foreach(region, ndns) {
+				ndns_name = ndctl_namespace_get_devname(ndns);
+
+				if (strcmp(namespace, ndns_name) != 0)
+					continue;
+
+				if (!ndctl_bus_has_error_injection(bus)) {
+					fprintf(stderr,
+						"%s: error injection not supported\n",
+						ndns_name);
+					return -EOPNOTSUPP;
+				}
+				return err_inject_ns(ndns);
+			}
+		}
+	}
+
+	return 0;
+}
+
+int cmd_inject_error(int argc, const char **argv, void *ctx)
+{
+	const char * const u[] = {
+		"ndctl inject-error <namespace> [<options>]",
+		NULL
+	};
+	int i, rc;
+
+        argc = parse_options(argc, argv, inject_options, u, 0);
+	rc = inject_init();
+	if (rc)
+		return rc;
+
+	if (argc == 0)
+		error("specify a namespace to inject error to\n");
+	for (i = 1; i < argc; i++)
+		error("unknown extra parameter \"%s\"\n", argv[i]);
+	if (argc == 0 || argc > 1) {
+		usage_with_options(u, inject_options);
+		return -ENODEV; /* we won't return from usage_with_options() */
+	}
+
+	return do_inject(argv[0], ctx);
+}
diff --git a/ndctl/libndctl-nfit.h b/ndctl/libndctl-nfit.h
index 6b730aa..d5335c2 100644
--- a/ndctl/libndctl-nfit.h
+++ b/ndctl/libndctl-nfit.h
@@ -33,6 +33,14 @@ enum {
 /* error number of Translate SPA by firmware  */
 #define ND_TRANSLATE_SPA_STATUS_INVALID_SPA  2
 
+/* status definitions for error injection */
+#define ND_ARS_ERR_INJ_STATUS_NOT_SUPP 1
+#define ND_ARS_ERR_INJ_STATUS_INVALID_PARAM 2
+
+enum err_inj_options {
+	ND_ARS_ERR_INJ_OPT_NOTIFY = 0,
+};
+
 /*
  * The following structures are command packages which are
  * defined by ACPI 6.2 (or later).
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index d10718e..0f748e1 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -83,6 +83,7 @@ static struct cmd_struct commands[] = {
 	{ "write-labels", cmd_write_labels },
 	{ "init-labels", cmd_init_labels },
 	{ "check-labels", cmd_check_labels },
+	{ "inject-error", cmd_inject_error },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST
diff --git a/util/json.c b/util/json.c
index 9b7773e..2f18163 100644
--- a/util/json.c
+++ b/util/json.c
@@ -20,6 +20,7 @@
 #include <ndctl/libndctl.h>
 #include <daxctl/libdaxctl.h>
 #include <ccan/array_size/array_size.h>
+#include <ccan/short_types/short_types.h>
 
 #ifdef HAVE_NDCTL_H
 #include <linux/ndctl.h>
@@ -845,3 +846,28 @@ struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping,
 	json_object_put(jmapping);
 	return NULL;
 }
+
+struct json_object *util_badblock_rec_to_json(u64 block, u64 count,
+		unsigned long flags)
+{
+	struct json_object *jerr = json_object_new_object();
+	struct json_object *jobj;
+
+	if (!jerr)
+		return NULL;
+
+	jobj = util_json_object_hex(block, flags);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jerr, "block", jobj);
+
+	jobj = util_json_object_hex(count, flags);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jerr, "count", jobj);
+
+	return jerr;
+ err:
+	json_object_put(jerr);
+	return NULL;
+}
diff --git a/util/json.h b/util/json.h
index d934b2e..de55127 100644
--- a/util/json.h
+++ b/util/json.h
@@ -15,6 +15,7 @@
 #include <stdio.h>
 #include <stdbool.h>
 #include <ndctl/libndctl.h>
+#include <ccan/short_types/short_types.h>
 
 enum util_json_flags {
 	UTIL_JSON_IDLE = (1 << 0),
@@ -33,6 +34,8 @@ struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping,
 		unsigned long flags);
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		unsigned long flags);
+struct json_object *util_badblock_rec_to_json(u64 block, u64 count,
+		unsigned long flags);
 struct daxctl_region;
 struct daxctl_dev;
 struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
diff --git a/util/list.h b/util/list.h
new file mode 100644
index 0000000..6439aef
--- /dev/null
+++ b/util/list.h
@@ -0,0 +1,50 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
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
+#ifndef _NDCTL_LIST_H_
+#define _NDCTL_LIST_H_
+
+#include <ccan/list/list.h>
+
+/**
+ * list_add_after - add an entry after the given node in the linked list.
+ * @h: the list_head to add the node to
+ * @l: the list_node after which to add to
+ * @n: the list_node to add to the list.
+ *
+ * The list_node does not need to be initialized; it will be overwritten.
+ * Example:
+ *	struct child *child = malloc(sizeof(*child));
+ *
+ *	child->name = "geoffrey";
+ *	list_add_after(&parent->children, &child1->list, &child->list);
+ *	parent->num_children++;
+ */
+#define list_add_after(h, l, n) list_add_after_(h, l, n, LIST_LOC)
+static inline void list_add_after_(struct list_head *h,
+				   struct list_node *l,
+				   struct list_node *n,
+				   const char *abortstr)
+{
+	if (l->next == &h->n) {
+		/* l is the last element, this becomes a list_add_tail */
+		list_add_tail(h, n);
+		return;
+	}
+	n->next = l->next;
+	n->prev = l;
+	l->next->prev = n;
+	l->next = n;
+	(void)list_debug(h, abortstr);
+}
+
+#endif /* _NDCTL_LIST_H_ */
diff --git a/util/size.h b/util/size.h
index 3c27079..34fac58 100644
--- a/util/size.h
+++ b/util/size.h
@@ -28,6 +28,7 @@ unsigned long long parse_size64(const char *str);
 unsigned long long __parse_size64(const char *str, unsigned long long *units);
 
 #define ALIGN(x, a) ((((unsigned long long) x) + (a - 1)) & ~(a - 1))
+#define ALIGN_DOWN(x, a) (((((unsigned long long) x) + a) & ~(a - 1)) - a)
 #define BITS_PER_LONG (sizeof(unsigned long) * 8)
 #define HPAGE_SIZE (2 << 20)
 
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
