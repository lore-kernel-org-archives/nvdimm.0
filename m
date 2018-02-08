Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E331222DE14D
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 12:58:49 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 3/4] ndctl: add a new command - inject-smart
Date: Thu,  8 Feb 2018 14:04:27 -0700
Message-Id: <20180208210428.7285-3-vishal.l.verma@intel.com>
In-Reply-To: <20180208210428.7285-1-vishal.l.verma@intel.com>
References: <20180208210428.7285-1-vishal.l.verma@intel.com>
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

Add an inject-smart command to ndctl to allow injection of smart fields,
and setting of smart thresholds. If a field is injected that breaches
the threshold, or sets a fatal flag, or if a new threshold is set that
causes the same effect, generate an acpi health even notification.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/ndctl-inject-smart.txt |  90 +++++++
 builtin.h                                  |   1 +
 ndctl/Makefile.am                          |   3 +-
 ndctl/inject-smart.c                       | 365 +++++++++++++++++++++++++++++
 ndctl/ndctl.c                              |   1 +
 5 files changed, 459 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ndctl/ndctl-inject-smart.txt
 create mode 100644 ndctl/inject-smart.c

diff --git a/Documentation/ndctl/ndctl-inject-smart.txt b/Documentation/ndctl/ndctl-inject-smart.txt
new file mode 100644
index 0000000..da20afe
--- /dev/null
+++ b/Documentation/ndctl/ndctl-inject-smart.txt
@@ -0,0 +1,90 @@
+ndctl-inject-smart(1)
+=====================
+
+NAME
+----
+ndctl-inject-smart - perform smart threshold/injection operations on a DIMM
+
+SYNOPSIS
+--------
+[verse]
+'ndctl inject-smart' <dimm> [<options>]
+
+DESCRIPTION
+-----------
+A generic DIMM device object, named /dev/nmemX, is registered for each
+memory device indicated in the ACPI NFIT table, or other platform NVDIMM
+resource discovery mechanism.
+
+ndctl-inject-smart can be used to set smart thresholds, and inject smart errors.
+
+EXAMPLES
+--------
+
+Set smart controller temperature and spares threshold for DIMM-0 to 32C, and 8
+[verse]
+ndctl inject-smart --set-threshold --ctrl-temperature=32 --spares=8 nmem0
+
+Inject the fatal health status flag for DIMM-0
+[verse]
+ndctl inject-smart --inject --fatal nmem0
+
+
+OPTIONS
+-------
+-b::
+--bus=::
+	Enforce that the operation only be carried on devices that are
+	attached to the given bus. Where 'bus' can be a provider name or a bus
+	id number.
+
+-s::
+--set-threshold::
+	Set a smart threshold. Provide one or more of the smart fields and
+	values to set them to.
+
+-i::
+--inject::
+	Inject a smart status. This can be a boolean flag or a field with a
+	certain value. Multiple fields may be specified in a single command.
+
+-A::
+--alarm-control=::
+	Smart field for alarm control flags.
+
+-M::
+--media-temperature=::
+	Smart field for media temperature.
+
+-C::
+--ctrl-temperature=::
+	Smart field for controller temperature.
+
+-S::
+--spares=::
+	Smart field for spares.
+
+-F::
+--fatal=::
+	Smart fatal status. Only usable with --inject.
+
+-U::
+--unsafe-shutdown=::
+	Smart unsafe shutdown status. Only usable with --inject.
+
+-v::
+--verbose::
+	Emit debug messages for the error injection process
+
+include::human-option.txt[]
+
+COPYRIGHT
+---------
+Copyright (c) 2018, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
+
+SEE ALSO
+--------
+linkndctl:ndctl-list[1],
diff --git a/builtin.h b/builtin.h
index 1f423dc..b24fc99 100644
--- a/builtin.h
+++ b/builtin.h
@@ -44,4 +44,5 @@ int cmd_test(int argc, const char **argv, void *ctx);
 int cmd_bat(int argc, const char **argv, void *ctx);
 #endif
 int cmd_update_firmware(int argc, const char **argv, void *ctx);
+int cmd_inject_smart(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 5cd8678..2054c1a 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -14,7 +14,8 @@ ndctl_SOURCES = ndctl.c \
 		../util/json.c \
 		util/json-smart.c \
 		inject-error.c \
-		update.c
+		update.c \
+		inject-smart.c
 
 if ENABLE_DESTRUCTIVE
 ndctl_SOURCES += ../test/blk_namespaces.c \
diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
new file mode 100644
index 0000000..a9bd4b7
--- /dev/null
+++ b/ndctl/inject-smart.c
@@ -0,0 +1,365 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
+#include <math.h>
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
+#include <ndctl.h>
+#include <util/log.h>
+#include <util/size.h>
+#include <util/json.h>
+#include <json-c/json.h>
+#include <util/filter.h>
+#include <ndctl/libndctl.h>
+#include <util/parse-options.h>
+#include <ccan/array_size/array_size.h>
+#include <ccan/short_types/short_types.h>
+
+#include "private.h"
+#include <builtin.h>
+#include <test.h>
+
+static bool verbose;
+static struct parameters {
+	const char *bus;
+	const char *dimm;
+	bool set;
+	bool inject;
+	bool human;
+	const char *alarm_control;
+	const char *media_temperature;
+	const char *ctrl_temperature;
+	const char *spares;
+	bool fatal;
+	bool unsafe_shutdown;
+} param;
+
+static struct smart_ctx {
+	unsigned long op_mask;
+	unsigned long field_mask;
+	unsigned long flags;
+	unsigned int alarm_control;
+	unsigned int media_temperature;
+	unsigned int ctrl_temperature;
+	unsigned int spares;
+} sctx;
+
+#define SMART_OPTIONS() \
+OPT_STRING('b', "bus", &param.bus, "bus-id", \
+	"limit dimm to a bus with an id or provider of <bus-id>"), \
+OPT_STRING('A', "alarm-control", &param.alarm_control, \
+	"smart alarm control threshold", \
+	"set the alarm control flags"), \
+OPT_STRING('M', "media-temperature", &param.media_temperature, \
+	"smart media temperature threshold", \
+	"inject or set threshold for media temperature"), \
+OPT_STRING('C', "ctrl-temperature", &param.ctrl_temperature, \
+	"smart controller temperature threshold", \
+	"set the controller temperature threshold"), \
+OPT_STRING('S', "spares", &param.spares, \
+	"smart spares threshold", \
+	"inject or set threshold for spares"), \
+OPT_BOOLEAN('v', "verbose", &verbose, "emit extra debug messages to stderr"), \
+OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats"), \
+OPT_BOOLEAN('F', "fatal", &param.fatal, "inject smart fatal status"), \
+OPT_BOOLEAN('U', "unsafe-shutdown", &param.unsafe_shutdown, \
+	"inject smart unsafe shutdown status"), \
+OPT_BOOLEAN('s', "set-threshold", &param.set, "set smart thresholds"), \
+OPT_BOOLEAN('i', "inject", &param.inject, "inject smart values/flags")
+
+static const struct option smart_opts[] = {
+	SMART_OPTIONS(),
+	OPT_END(),
+};
+
+enum smart_ops {
+	OP_SET = 0,
+	OP_INJECT,
+};
+
+enum smart_fields {
+	FIELD_alarm_control = 0,
+	FIELD_media_temperature,
+	FIELD_ctrl_temperature,
+	FIELD_spares,
+	FIELD_fatal,
+	FIELD_unsafe_shutdown,
+};
+
+#define smart_param_setup_uint(arg) \
+{ \
+	if (param.arg) { \
+		sctx.arg = strtol(param.arg, NULL, 0); \
+		if (sctx.arg == ULONG_MAX) { \
+			error("Invalid argument: %s: %s\n", #arg, param.arg); \
+			return -EINVAL; \
+		} \
+		sctx.field_mask |= 1 << FIELD_##arg; \
+	} \
+}
+
+#define smart_param_setup_temps(arg) \
+{ \
+	if (param.arg) { \
+		double temp; \
+		temp = strtod(param.arg, NULL); \
+		if (temp == HUGE_VAL || temp == -HUGE_VAL) { \
+			error("Invalid argument: %s: %s\n", #arg, param.arg); \
+			return -EINVAL; \
+		} \
+		sctx.field_mask |= 1 << FIELD_##arg; \
+		sctx.arg = ndctl_encode_smart_temperature(temp); \
+	} \
+}
+
+static int smart_init(void)
+{
+	if (param.set)
+		sctx.op_mask |= 1 << OP_SET;
+	if (param.inject)
+		sctx.op_mask |= 1 << OP_INJECT;
+
+	if (sctx.op_mask == 0) {
+		error("Specify an operation (of set or inject)\n");
+		return -EINVAL;
+	}
+
+	/* ensure sctx.op_mask has only one bit set */
+	if (sctx.op_mask && (sctx.op_mask & (sctx.op_mask - 1))) {
+		error("Only one operation (of set or inject) at a time.\n");
+		return -EINVAL;
+	}
+
+	smart_param_setup_uint(alarm_control)
+	smart_param_setup_temps(media_temperature)
+	smart_param_setup_temps(ctrl_temperature)
+	smart_param_setup_uint(spares)
+
+	if (param.fatal)
+		sctx.field_mask |= 1 << FIELD_fatal;
+	if (param.unsafe_shutdown)
+		sctx.field_mask |= 1 << FIELD_unsafe_shutdown;
+
+	if (param.human)
+		sctx.flags |= UTIL_JSON_HUMAN;
+
+	if (sctx.op_mask & (1 << OP_SET)) {
+		if (sctx.field_mask &
+				((1 << FIELD_fatal) | (1 << FIELD_unsafe_shutdown)))
+			warning("--fatal or --unsafe-shutdown don't have a threshold\n");
+	}
+
+	if (sctx.op_mask & (1 << OP_INJECT)) {
+		if (sctx.field_mask & ((1 << FIELD_alarm_control) |
+					(1 << FIELD_ctrl_temperature))) {
+			error("injection not possible for alarm_control or ctrl_temperature\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+#define setup_thresh_field(arg) \
+{ \
+	if (sctx.field_mask & (1 << FIELD_##arg)) \
+		ndctl_cmd_smart_threshold_set_##arg(sst_cmd, sctx.arg); \
+}
+
+static int smart_set_thresh(struct ndctl_dimm *dimm)
+{
+	const char *name = ndctl_dimm_get_devname(dimm);
+	struct ndctl_cmd *st_cmd, *sst_cmd;
+	int rc = -EOPNOTSUPP;
+
+	st_cmd = ndctl_dimm_cmd_new_smart_threshold(dimm);
+	if (!st_cmd) {
+		error("%s: no smart threshold command support\n", name);
+		goto out;
+	}
+
+	rc = ndctl_cmd_submit(st_cmd);
+	if (rc) {
+		error("%s: smart threshold command failed: %s\n",
+			name, strerror(errno));
+		goto out;
+	}
+
+	sst_cmd = ndctl_dimm_cmd_new_smart_set_threshold(st_cmd);
+	if (!sst_cmd) {
+		error("%s: no smart set threshold command support\n", name);
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
+
+	setup_thresh_field(alarm_control)
+	setup_thresh_field(media_temperature)
+	setup_thresh_field(ctrl_temperature)
+	setup_thresh_field(spares)
+
+	rc = ndctl_cmd_submit(sst_cmd);
+	if (rc)
+		error("%s: smart set threshold command failed: %s\n",
+			name, strerror(errno));
+
+out:
+	ndctl_cmd_unref(sst_cmd);
+	ndctl_cmd_unref(st_cmd);
+	return rc;
+}
+
+#define send_inject_val(arg) \
+{ \
+	if (sctx.field_mask & (1 << FIELD_##arg)) { \
+		rc = ndctl_cmd_smart_inject_##arg(si_cmd, true, sctx.arg); \
+		if (rc) { \
+			error("%s: smart inject %s cmd invalid: %s\n", \
+				name, #arg, strerror(errno)); \
+			goto out; \
+		} \
+		rc = ndctl_cmd_submit(si_cmd); \
+		if (rc) { \
+			error("%s: smart inject %s command failed: %s\n", \
+				name, #arg, strerror(errno)); \
+			goto out; \
+		} \
+	} \
+}
+
+#define send_inject_bool(arg) \
+{ \
+	if (sctx.field_mask & (1 << FIELD_##arg)) { \
+		rc = ndctl_cmd_smart_inject_##arg(si_cmd, true); \
+		if (rc) { \
+			error("%s: smart inject %s cmd invalid: %s\n", \
+				name, #arg, strerror(errno)); \
+			goto out; \
+		} \
+		rc = ndctl_cmd_submit(si_cmd); \
+		if (rc) \
+			error("%s: smart inject %s command failed: %s\n", \
+				name, #arg, strerror(errno)); \
+	} \
+}
+
+static int smart_inject(struct ndctl_dimm *dimm)
+{
+	const char *name = ndctl_dimm_get_devname(dimm);
+	struct ndctl_cmd *si_cmd;
+	int rc = -EOPNOTSUPP;
+
+	si_cmd = ndctl_dimm_cmd_new_smart_inject(dimm);
+	if (!si_cmd) {
+		error("%s: no smart inject command support\n", name);
+		goto out;
+	}
+
+	send_inject_val(media_temperature)
+	send_inject_val(spares)
+	send_inject_bool(fatal)
+	send_inject_bool(unsafe_shutdown)
+
+out:
+	ndctl_cmd_unref(si_cmd);
+	return rc;
+}
+
+static int dimm_inject_smart(struct ndctl_dimm *dimm)
+{
+	struct json_object *jhealth;
+	struct json_object *jdimms;
+	struct json_object *jdimm;
+	int rc;
+
+	switch (sctx.op_mask) {
+	case (1 << OP_SET):
+		rc = smart_set_thresh(dimm);
+		break;
+	case (1 << OP_INJECT):
+		rc = smart_inject(dimm);
+		break;
+	default:
+		error("Unknown operation: %ld\n", sctx.op_mask);
+		return -EINVAL;
+	}
+
+	if (rc == 0) {
+		jdimms = json_object_new_array();
+		if (!jdimms)
+			goto out;
+		jdimm = util_dimm_to_json(dimm, sctx.flags);
+		if (!jdimm)
+			goto out;
+		json_object_array_add(jdimms, jdimm);
+
+		jhealth = util_dimm_health_to_json(dimm);
+		if (jhealth) {
+			json_object_object_add(jdimm, "health", jhealth);
+			util_display_json_array(stdout, jdimms,
+				JSON_C_TO_STRING_PRETTY);
+		}
+	}
+out:
+	return rc;
+}
+
+static int do_smart(const char *dimm_arg, struct ndctl_ctx *ctx)
+{
+	struct ndctl_dimm *dimm;
+	struct ndctl_bus *bus;
+	int rc = -ENXIO;
+
+	if (dimm_arg == NULL)
+		return rc;
+
+	if (verbose)
+		ndctl_set_log_priority(ctx, LOG_DEBUG);
+
+        ndctl_bus_foreach(ctx, bus) {
+		if (!util_bus_filter(bus, param.bus))
+			continue;
+
+		ndctl_dimm_foreach(bus, dimm) {
+			if (!util_dimm_filter(dimm, dimm_arg))
+				continue;
+			return dimm_inject_smart(dimm);
+		}
+	}
+	error("%s: no such dimm\n", dimm_arg);
+
+	return rc;
+}
+
+int cmd_inject_smart(int argc, const char **argv, void *ctx)
+{
+	const char * const u[] = {
+		"ndctl inject-smart <dimm> [<options>]",
+		NULL
+	};
+	int i, rc;
+
+        argc = parse_options(argc, argv, smart_opts, u, 0);
+	rc = smart_init();
+	if (rc)
+		return rc;
+
+	if (argc == 0)
+		error("specify a dimm for the smart operation\n");
+	for (i = 1; i < argc; i++)
+		error("unknown extra parameter \"%s\"\n", argv[i]);
+	if (argc == 0 || argc > 1) {
+		usage_with_options(u, smart_opts);
+		return -ENODEV; /* we won't return from usage_with_options() */
+	}
+
+	return do_smart(argv[0], ctx);
+}
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index a0e5153..d3c6db1 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -85,6 +85,7 @@ static struct cmd_struct commands[] = {
 	{ "check-labels", cmd_check_labels },
 	{ "inject-error", cmd_inject_error },
 	{ "update-firmware", cmd_update_firmware },
+	{ "inject-smart", cmd_inject_smart },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
