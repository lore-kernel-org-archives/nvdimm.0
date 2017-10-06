Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BCAA821EA15C5
 for <linux-nvdimm@lists.01.org>; Thu,  5 Oct 2017 18:52:52 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 5/8] ndctl: add an inject-error command
Date: Thu,  5 Oct 2017 19:54:02 -0600
Message-Id: <20171006015405.29908-6-vishal.l.verma@intel.com>
In-Reply-To: <20171006015405.29908-1-vishal.l.verma@intel.com>
References: <20171006015405.29908-1-vishal.l.verma@intel.com>
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
 Documentation/ndctl/ndctl-inject-error.txt | 108 +++++
 Documentation/ndctl/ndctl.txt              |   1 +
 builtin.h                                  |   1 +
 contrib/ndctl                              |   5 +-
 ndctl/Makefile.am                          |   3 +-
 ndctl/inject-error.c                       | 745 +++++++++++++++++++++++++++++
 ndctl/libndctl-nfit.h                      |   8 +
 ndctl/ndctl.c                              |   1 +
 util/json.c                                |  26 +
 util/json.h                                |   3 +
 util/size.h                                |   1 +
 12 files changed, 901 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ndctl/ndctl-inject-error.txt
 create mode 100644 ndctl/inject-error.c

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
index 0000000..bd9e197
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
+in the nvdimm address space to aid debugging and development of features
+related to error handling.
+
+WARNING: These commands are DANGEROUS and can cause data loss. They are
+only provided for testing and debugging purposes.
+
+EXAMPLES
+--------
+
+Inject errors in namespace0.0 at sector 12 for a 2 sectors (i.e. 12, 13)
+[verse]
+ndctl inject-error --sector=12 --count=2 namespace0.0
+
+Check status of injected errors on namespace0.0
+[verse]
+ndctl inject-error --status namespacce0.0
+
+Clear the injected errors at sector 12 for 2 sectors on namespace0.0
+[verse]
+ndctl inject-error --clear --sector=12 --count=2 namespacce0.0
+
+OPTIONS
+-------
+-S::
+--sector=::
+	Namespace sector offset in 512 byte sized sectors where the error is
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
+-c::
+--count=::
+	Number of sectors to inject as errors. This is also in terms of fixed,
+	512 byte sectors.
+
+-d::
+--clear::
+	This option will ask the platform to clear any injected errors for the
+	specified sector offset, and count.
+
+	WARNING: This will not clear the kernel's internal "badrange" and
+	"badblock" tracking - those can only be cleared by doing a write to
+	the affected locations. Hence use the --clear option only if you know
+	exactly what you are doing. For normal usage, injected errors should
+	only be cleared by doing writes. Do not expect have the original data
+	intact after injecting an error, and clearing it using --clear - it
+	will be lost, as the only "real" way to clear the error location is
+	to write to it or zero it (truncate/hole-punch).
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
index c7d1b67..8745fb5 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -91,7 +91,7 @@ __ndctlcomp()
 
 	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
 	for cword in "${COMPREPLY[@]}"; do
-		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace|--input|--output|--label-version|--align) ]]; then
+		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace|--input|--output|--label-version|--align|--sector|--count) ]]; then
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
index 0000000..a6bcc1b
--- /dev/null
+++ b/ndctl/inject-error.c
@@ -0,0 +1,745 @@
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
+#include <setjmp.h>
+#include <limits.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <libkmod.h>
+#include <stdbool.h>
+#include <linux/fs.h>
+#include <sys/wait.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/ioctl.h>
+#include <linux/fiemap.h>
+
+#include <util/log.h>
+#include <util/size.h>
+#include <util/json.h>
+#include <util/sysfs.h>
+#include <json-c/json.h>
+#include <util/filter.h>
+#include <ndctl/libndctl.h>
+#include <ccan/list/list.h>
+#include <util/parse-options.h>
+#include <ndctl/libndctl-nfit.h>
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
+	const char *sector;
+	const char *count;
+	bool clear;
+	bool status;
+	bool notify;
+	bool human;
+} param;
+
+static struct inject_ctx {
+	u64 sector;
+	u64 count;
+	u64 off_bytes;
+	u64 len_bytes;
+	u64 options;
+	unsigned int op_mask;
+	unsigned long flags;
+	struct list_head bb_list;
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
+OPT_STRING('S', "sector", &param.sector, "namespace sector offset", \
+	"specify the sector at which to inject the error"), \
+OPT_STRING('c', "count", &param.count, "count", \
+	"specify the number of sectors of errors to inject"), \
+OPT_BOOLEAN('d', "clear", &param.clear, \
+	"send the ARS error inject clear DSM"), \
+OPT_BOOLEAN('t', "status", &param.status, "get error injection status"), \
+OPT_BOOLEAN('N', "no-notify", &param.notify, "firmware should not notify OS"), \
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
+struct bb {
+	u64 sector;
+	u64 count;
+	struct list_node list;
+};
+
+static int inject_init(void)
+{
+	if (!param.clear && !param.status) {
+		ictx.op_mask |= 1 << OP_INJECT;
+		ictx.options |= 1 << ND_ARS_ERR_INJ_OPT_NOTIFY;
+		if (param.notify)
+			ictx.options &= ~(1 << ND_ARS_ERR_INJ_OPT_NOTIFY);
+	}
+	if (param.clear) {
+		if (param.status) {
+			error("status is invalid with clear or inject\n");
+			return -EINVAL;
+		}
+		ictx.op_mask |= 1 << OP_CLEAR;
+	}
+	if (param.status) {
+		if (param.sector || param.count) {
+			error("status is invalid with clear or inject\n");
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
+	if (param.sector) {
+		ictx.sector = parse_size64(param.sector);
+		if (ictx.sector == ULLONG_MAX) {
+			error("Invalid sector: %s\n", param.sector);
+			return -EINVAL;
+		}
+		ictx.off_bytes = ictx.sector * 512;
+	}
+	if (param.count) {
+		ictx.count = parse_size64(param.count);
+		if (ictx.count == ULLONG_MAX) {
+			error("Invalid count: %s\n", param.count);
+			return -EINVAL;
+		}
+		ictx.len_bytes = ictx.count * 512;
+	}
+
+	/* For inject or clear, an sector and count are required */
+	if (ictx.op_mask & ((1 << OP_INJECT) | (1 << OP_CLEAR))) {
+		if (!param.sector || !param.count) {
+			error("sector and count required for inject/clear\n");
+			return -EINVAL;
+		}
+	}
+
+	if (param.human)
+		ictx.flags |= UTIL_JSON_HUMAN;
+
+	list_head_init(&ictx.bb_list);
+
+	return 0;
+}
+
+static int bus_has_ars_inject(struct ndctl_bus *bus)
+{
+	if (!ndctl_bus_has_nfit(bus))
+		return 0;
+
+	if (ndctl_bus_is_nfit_cmd_supported(bus, NFIT_CMD_ARS_INJECT_SET) &&
+		ndctl_bus_is_nfit_cmd_supported(bus, NFIT_CMD_ARS_INJECT_GET) &&
+		ndctl_bus_is_nfit_cmd_supported(bus, NFIT_CMD_ARS_INJECT_CLEAR))
+		return 1;
+	else
+		return 0;
+}
+
+static struct ndctl_cmd *ndctl_bus_cmd_new_err_inj(struct ndctl_bus *bus)
+{
+	struct nd_cmd_ars_err_inj *err_inj;
+	size_t size, cmd_length;
+	struct nd_cmd_pkg *pkg;
+	struct ndctl_cmd *cmd;
+
+	cmd_length = sizeof(struct nd_cmd_ars_err_inj);
+	size = sizeof(*cmd) + sizeof(*pkg) + cmd_length;
+	cmd = calloc(1, size);
+	if (!cmd)
+		return NULL;
+
+	cmd->bus = bus;
+	ndctl_cmd_ref(cmd);
+	cmd->type = ND_CMD_CALL;
+	cmd->size = size;
+	cmd->status = 1;
+	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+	pkg->nd_command = NFIT_CMD_ARS_INJECT_SET;
+	pkg->nd_size_in = (2 * sizeof(u64)) + sizeof(u32);
+	pkg->nd_size_out = cmd_length;
+	pkg->nd_fw_size = cmd_length;
+	err_inj = (struct nd_cmd_ars_err_inj *)&pkg->nd_payload[0];
+	cmd->firmware_status = &err_inj->status;
+
+	return cmd;
+}
+
+static struct ndctl_cmd *ndctl_bus_cmd_new_err_inj_clr(struct ndctl_bus *bus)
+{
+	struct nd_cmd_ars_err_inj_clr *err_inj_clr;
+	size_t size, cmd_length;
+	struct nd_cmd_pkg *pkg;
+	struct ndctl_cmd *cmd;
+
+	cmd_length = sizeof(struct nd_cmd_ars_err_inj_clr);
+	size = sizeof(*cmd) + sizeof(*pkg) + cmd_length;
+	cmd = calloc(1, size);
+	if (!cmd)
+		return NULL;
+
+	cmd->bus = bus;
+	ndctl_cmd_ref(cmd);
+	cmd->type = ND_CMD_CALL;
+	cmd->size = size;
+	cmd->status = 1;
+	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+	pkg->nd_command = NFIT_CMD_ARS_INJECT_CLEAR;
+	pkg->nd_size_in = 2 * sizeof(u64);
+	pkg->nd_size_out = cmd_length;
+	pkg->nd_fw_size = cmd_length;
+	err_inj_clr = (struct nd_cmd_ars_err_inj_clr *)&pkg->nd_payload[0];
+	cmd->firmware_status = &err_inj_clr->status;
+
+	return cmd;
+}
+
+static struct ndctl_cmd *ndctl_bus_cmd_new_err_inj_stat(struct ndctl_bus *bus,
+	u32 buf_size)
+{
+	struct nd_cmd_ars_err_inj_stat *err_inj_stat;
+	size_t size, cmd_length;
+	struct nd_cmd_pkg *pkg;
+	struct ndctl_cmd *cmd;
+
+
+	cmd_length = sizeof(struct nd_cmd_ars_err_inj_stat);
+	size = sizeof(*cmd) + sizeof(*pkg) + cmd_length + buf_size;
+	cmd = calloc(1, size);
+	if (!cmd)
+		return NULL;
+
+	cmd->bus = bus;
+	ndctl_cmd_ref(cmd);
+	cmd->type = ND_CMD_CALL;
+	cmd->size = size;
+	cmd->status = 1;
+	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+	pkg->nd_command = NFIT_CMD_ARS_INJECT_GET;
+	pkg->nd_size_in = cmd_length;
+	pkg->nd_size_out = cmd_length + buf_size;
+	pkg->nd_fw_size = cmd_length + buf_size;
+	err_inj_stat = (struct nd_cmd_ars_err_inj_stat *)&pkg->nd_payload[0];
+	cmd->firmware_status = &err_inj_stat->status;
+
+	return cmd;
+}
+
+static void translate_status(u32 status)
+{
+	if (status == ND_ARS_ERR_INJ_STATUS_NOT_SUPP)
+		fprintf(stderr,
+			"error: error injection is not supported\n");
+	if (status == ND_ARS_ERR_INJ_STATUS_INVALID_PARAM)
+		fprintf(stderr, "error: invalid parameters\n");
+}
+
+static int ndctl_bus_nfit_err_inj(struct ndctl_bus *bus, u64 offset,
+	u64 length, u32 options)
+{
+	struct nd_cmd_ars_err_inj *err_inj;
+	struct nd_cmd_pkg *pkg;
+	struct ndctl_cmd *cmd;
+	int rc;
+
+	if (!bus)
+		return -EINVAL;
+
+	cmd = ndctl_bus_cmd_new_err_inj(bus);
+	if (!cmd)
+		return -ENOMEM;
+
+	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+	err_inj = (struct nd_cmd_ars_err_inj *)&pkg->nd_payload[0];
+	err_inj->err_inj_spa_range_base = offset;
+	err_inj->err_inj_spa_range_length = length;
+	err_inj->err_inj_options = options;
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
+		fprintf(stderr, "Error submitting command: %d\n", rc);
+		goto out;
+	}
+	translate_status(err_inj->status);
+
+ out:
+	ndctl_cmd_unref(cmd);
+	return rc;
+}
+
+static int ndctl_bus_nfit_err_inj_clr(struct ndctl_bus *bus, u64 offset,
+	u64 length)
+{
+	struct nd_cmd_ars_err_inj_clr *err_inj_clr;
+	struct nd_cmd_pkg *pkg;
+	struct ndctl_cmd *cmd;
+	int rc;
+
+	if (!bus)
+		return -EINVAL;
+
+	cmd = ndctl_bus_cmd_new_err_inj_clr(bus);
+	if (!cmd)
+		return -ENOMEM;
+
+	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+	err_inj_clr = (struct nd_cmd_ars_err_inj_clr *)&pkg->nd_payload[0];
+	err_inj_clr->err_inj_clr_spa_range_base = offset;
+	err_inj_clr->err_inj_clr_spa_range_length = length;
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
+		fprintf(stderr, "Error submitting command: %d\n", rc);
+		goto out;
+	}
+	translate_status(err_inj_clr->status);
+	printf("Warning: Clearing injected errors here clears them in the\n");
+	printf("badrange list in nfit_test, but the kernel won't 'forget'\n");
+	printf("any entries it has found in a scrub until they are cleared\n");
+	printf("through the normal process of writing the affected blocks\n\n");
+ out:
+	ndctl_cmd_unref(cmd);
+	return rc;
+}
+
+static int bb_add_record(u64 sector, u64 count)
+{
+	struct bb *bb, *bb_iter, *bb_next, *bb_prev;
+	struct list_head *h = &ictx.bb_list;
+	int merged = 0;
+
+	bb = calloc(1, sizeof(*bb));
+	if (bb == NULL)
+		return -ENOMEM;
+	bb->sector = sector;
+	bb->count = count;
+
+	if (list_empty(h)) {
+		list_add(h, &bb->list);
+		return 0;
+	}
+
+	/* add 'bb' to the list such that it remains sorted */
+	list_for_each(h, bb_iter, list) {
+		/* Find insertion point */
+		bb_prev = list_prev(h, bb_iter, list);
+		bb_next = list_next(h, bb_iter, list);
+
+		if (bb_prev == NULL) {
+			/* bb_iter is the first entry */
+			if (bb->sector < bb_iter->sector) {
+				list_add(h, &bb->list);
+				break;
+			}
+		}
+		if (bb_next == NULL) {
+			/*
+			 * bb_iter is the last entry. If we've reached here,
+			 * the only option is to add to the tail as the case
+			 * for "tail - 1" should have been covered by the
+			 * following checks for the previous iteration.
+			 */
+			list_add_tail(h, &bb->list);
+			break;
+		}
+		/* Add to the left of bb_iter */
+		if (bb->sector <= bb_iter->sector) {
+			if (bb_prev && (bb_prev->sector <= bb->sector)) {
+				list_add_after(h, &bb_prev->list, &bb->list);
+				break;
+			}
+		}
+		/* Add to the right of bb_iter */
+		if (bb_iter->sector <= bb->sector) {
+			if (bb_next && (bb->sector <= bb_next->sector)) {
+				list_add_after(h, &bb_iter->list, &bb->list);
+				break;
+			}
+		}
+	}
+
+	/* second pass over the list looking for mergeable entries */
+	list_for_each(h, bb_iter, list) {
+		u64 cur_end, next_end, cur_start, next_start;
+
+		/*
+		 * test for merges in a loop here because one addition can
+		 * potentially have a cascading merge effect on multiple
+		 * remaining entries
+		 */
+		do {
+			/* reset the merged flag */
+			merged = 0;
+
+			bb_next = list_next(h, bb_iter, list);
+			if (bb_next == NULL)
+				break;
+
+			cur_start = bb_iter->sector;
+			next_start = bb_next->sector;
+			cur_end = bb_iter->sector + bb_iter->count - 1;
+			next_end = bb_next->sector + bb_next->count - 1;
+
+			if (cur_end >= next_start) {
+				/* overlapping records that can be merged */
+				if (next_end > cur_end) {
+					/* next extends cur */
+					bb_iter->count =
+						next_end - cur_start + 1;
+				} else {
+					/* next is contained in cur */
+					;
+				}
+				/* next is now redundant */
+				list_del_from(h, &bb_next->list);
+				free(bb_next);
+				merged = 1;
+				continue;
+			}
+			if (next_start == cur_end + 1) {
+				/* adjoining records that can be merged */
+				bb_iter->count = next_end - cur_start + 1;
+				list_del_from(h, &bb_next->list);
+				free(bb_next);
+				merged = 1;
+				continue;
+			}
+		} while (merged);
+	}
+
+	return 0;
+}
+
+static int print_err_inj_status(struct nd_cmd_ars_err_inj_stat *stat,
+	u64 ns_spa, u64 ns_size)
+{
+	struct list_head *h = &ictx.bb_list;
+	struct json_object *jbbs, *jbb, *jobj;
+	struct bb *bb_iter, *next;
+	int rc = 0;
+	u32 i;
+
+	for (i = 0; i < stat->inj_err_rec_count; i++) {
+		u64 ns_off, rec_off, rec_len;
+		u64 sector, count, start_pad;
+
+		rec_off = stat->record[i].err_inj_stat_spa_range_base;
+		rec_len = stat->record[i].err_inj_stat_spa_range_length;
+		/* discard ranges outside the provided namespace */
+		if (rec_off < ns_spa)
+			continue;
+		if (rec_off >= ns_spa + ns_size)
+			continue;
+
+		/* translate spa offset to namespace offset */
+		ns_off = rec_off - ns_spa;
+
+		sector = ALIGN_DOWN(ns_off, 512)/512;
+		start_pad = ns_off - (sector * 512);
+		count = ALIGN(start_pad + rec_len, 512)/512;
+		rc = bb_add_record(sector, count);
+		if (rc)
+			goto err_list;
+	}
+
+	jobj = json_object_new_object();
+	if (!jobj) {
+		rc = -ENOMEM;
+		goto err_list;
+	}
+	jbbs = json_object_new_array();
+	if (!jbbs) {
+		rc = -ENOMEM;
+		goto err_obj;
+	}
+
+	list_for_each(h, bb_iter, list) {
+		jbb = util_badblock_rec_to_json(bb_iter->sector,
+				bb_iter->count, ictx.flags);
+		if (!jbb)
+			break;
+		json_object_array_add(jbbs, jbb);
+	}
+	if (!list_empty(h)) {
+		json_object_object_add(jobj, "badblocks", jbbs);
+		printf("%s\n", json_object_to_json_string_ext(jobj,
+			JSON_C_TO_STRING_PRETTY));
+	}
+
+	json_object_put(jbbs);
+ err_obj:
+	json_object_put(jobj);
+ err_list:
+	/* done with the bb list, we can free it now */
+	list_for_each_safe(h, bb_iter, next, list) {
+		list_del_from(h, &bb_iter->list);
+		free(bb_iter);
+	}
+
+	return rc;
+}
+
+static int ndctl_bus_nfit_err_inj_stat(struct ndctl_bus *bus, u64 ns_offset,
+	u64 ns_size)
+{
+	struct ndctl_cmd *cmd;
+	struct nd_cmd_pkg *pkg;
+	struct nd_cmd_ars_err_inj_stat *err_inj_stat;
+	int rc, buf_size;
+
+	if (!bus)
+		return -EINVAL;
+
+	cmd = ndctl_bus_cmd_new_ars_cap(bus, ns_offset, ns_size);
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
+		fprintf(stderr, "Error submitting ars_cap: %d\n", rc);
+		goto out;
+	}
+	buf_size = ndctl_cmd_ars_cap_get_size(cmd);
+	if (buf_size == 0) {
+		fprintf(stderr, "Got an invalid max_ars_out from ars_cap\n");
+		rc = -EINVAL;
+		goto out;
+	}
+	ndctl_cmd_unref(cmd);
+
+	cmd = ndctl_bus_cmd_new_err_inj_stat(bus, buf_size);
+	if (!cmd)
+		return -ENOMEM;
+
+	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+	err_inj_stat = (struct nd_cmd_ars_err_inj_stat *)&pkg->nd_payload[0];
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
+		fprintf(stderr, "Error submitting command: %d\n", rc);
+		goto out;
+	}
+	translate_status(err_inj_stat->status);
+	rc = print_err_inj_status(err_inj_stat, ns_offset, ns_size);
+
+ out:
+	ndctl_cmd_unref(cmd);
+	return rc;
+}
+
+static int ns_errors_to_json(struct ndctl_namespace *ndns,
+		unsigned int start_count)
+{
+	unsigned long flags = ictx.flags | UTIL_JSON_MEDIA_ERRORS;
+	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
+	struct json_object *jndns;
+	unsigned int count;
+	int rc;
+
+	/* only wait for scrubs for the inject and notify case */
+	if (ictx.options & (1 << ND_ARS_ERR_INJ_OPT_NOTIFY)) {
+		do {
+			count = ndctl_bus_get_scrub_count(bus);
+			if (count == UINT_MAX) {
+				fprintf(stderr, "Unable to get scrub count\n");
+				return -ENXIO;
+			}
+			sleep(1);
+		} while (count <= start_count);
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
+static int err_inject_ns(struct ndctl_bus *bus, struct ndctl_namespace *ndns)
+{
+	unsigned long long ns_offset, err_spa_offset;
+	unsigned long long ns_size;
+	unsigned int scrub_count;
+	struct ndctl_pfn *pfn;
+	struct ndctl_dax *dax;
+	unsigned int op_mask;
+	int rc;
+
+	dax = ndctl_namespace_get_dax(ndns);
+	pfn = ndctl_namespace_get_pfn(ndns);
+	if (pfn) {
+		ns_offset = ndctl_pfn_get_resource(pfn);
+		ns_size = ndctl_pfn_get_size(pfn);
+	} else if (dax) {
+		ns_offset = ndctl_dax_get_resource(dax);
+		ns_size = ndctl_dax_get_size(dax);
+	} else {
+		/* raw or btt */
+		ns_offset = ndctl_namespace_get_resource(ndns);
+		ns_size = ndctl_namespace_get_size(ndns);
+	}
+
+	if (ictx.off_bytes + ictx.len_bytes > ns_size) {
+		fprintf(stderr,
+			"Error: sector %#lx, count %#lx are out of bounds\n",
+			ictx.sector, ictx.count);
+		fprintf(stderr, "  namespace size is %#llx\n", ns_size);
+		return -EINVAL;
+	}
+	err_spa_offset = ns_offset + ictx.off_bytes;
+
+	op_mask = ictx.op_mask;
+	while (op_mask) {
+		if (op_mask & (1 << OP_INJECT)) {
+			scrub_count = ndctl_bus_get_scrub_count(bus);
+			if (scrub_count == UINT_MAX) {
+				fprintf(stderr, "Unable to get scrub count\n");
+				return -ENXIO;
+			}
+			rc = ndctl_bus_nfit_err_inj(bus, err_spa_offset,
+				ictx.len_bytes, ictx.options);
+			op_mask &= ~(1 << OP_INJECT);
+			rc = ns_errors_to_json(ndns, scrub_count);
+			if (rc)
+				return rc;
+		}
+		if (op_mask & (1 << OP_CLEAR)) {
+			rc = ndctl_bus_nfit_err_inj_clr(bus, err_spa_offset,
+				ictx.len_bytes);
+			op_mask &= ~(1 << OP_CLEAR);
+			rc = ns_errors_to_json(ndns, 0);
+			if (rc)
+				return rc;
+		}
+		if (op_mask & (1 << OP_STATUS)) {
+			rc = ndctl_bus_nfit_err_inj_stat(bus, ns_offset,
+				ns_size);
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
+				if (!bus_has_ars_inject(bus)) {
+					fprintf(stderr,
+						"%s: error injection not supported\n",
+						ndns_name);
+					return -EOPNOTSUPP;
+				}
+				return err_inject_ns(bus, ndns);
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
index ae9e5ce..7dafd64 100644
--- a/ndctl/libndctl-nfit.h
+++ b/ndctl/libndctl-nfit.h
@@ -31,6 +31,14 @@ enum {
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
index 9b7773e..052e6c5 100644
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
+struct json_object *util_badblock_rec_to_json(u64 sector, u64 count,
+		unsigned long flags)
+{
+	struct json_object *jerr = json_object_new_object();
+	struct json_object *jobj;
+
+	if (!jerr)
+		return NULL;
+
+	jobj = util_json_object_hex(sector, flags);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jerr, "sector", jobj);
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
index d934b2e..4d0dcc9 100644
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
+struct json_object *util_badblock_rec_to_json(u64 sector, u64 count,
+		unsigned long flags);
 struct daxctl_region;
 struct daxctl_dev;
 struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
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
