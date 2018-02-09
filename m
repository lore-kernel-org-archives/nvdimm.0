Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 98A7A223DB7BA
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 21:29:20 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 3/4] ndctl: add a new command - inject-smart
Date: Thu,  8 Feb 2018 22:34:59 -0700
Message-Id: <20180209053500.6871-3-vishal.l.verma@intel.com>
In-Reply-To: <20180209053500.6871-1-vishal.l.verma@intel.com>
References: <20180209053500.6871-1-vishal.l.verma@intel.com>
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
 Documentation/ndctl/ndctl-inject-smart.txt | 102 +++++++
 builtin.h                                  |   1 +
 ndctl/Makefile.am                          |   3 +-
 ndctl/inject-smart.c                       | 436 +++++++++++++++++++++++++++++
 ndctl/ndctl.c                              |   1 +
 5 files changed, 542 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ndctl/ndctl-inject-smart.txt
 create mode 100644 ndctl/inject-smart.c

v2: Change inject-smart semantics to avoid sub-commands like --inject
and --set. Instead allow injection and threshold setting all in one
command by making each a distinct option. (Dan)

diff --git a/Documentation/ndctl/ndctl-inject-smart.txt b/Documentation/ndctl/ndctl-inject-smart.txt
new file mode 100644
index 0000000..212bca0
--- /dev/null
+++ b/Documentation/ndctl/ndctl-inject-smart.txt
@@ -0,0 +1,102 @@
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
+ndctl-inject-smart can be used to set smart thresholds, and inject smart
+attributes.
+
+EXAMPLES
+--------
+
+Set smart controller temperature and spares threshold for DIMM-0 to 32C, spares
+threshold to 8, and enable the spares alarm.
+[verse]
+ndctl inject-smart --ctrl-temperature-threshold=32 --spares-threshold=8 --spares-alarm nmem0
+
+Inject a media temperature value of 52 and fatal health status flag for DIMM-0
+[verse]
+ndctl inject-smart --media-temperature=52 --health=fatal nmem0
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
+-m::
+--media-temperature=::
+	Inject <value> for the media temperature smart attribute.
+
+-M::
+--media-temperature-threshold=::
+	Set <value> for the smart media temperature threshold.
+
+--media-temperature-alarm=::
+	Enable or disable the smart media temperature alarm. Options are
+	'on' or 'off'.
+
+-c::
+--ctrl-temperature=::
+	Inject <value> for the controller temperature smart attribute.
+
+-C::
+--ctrl-temperature-threshold=::
+	Set <value> for the smart controller temperature threshold.
+
+--ctrl-temperature-alarm=::
+	Enable or disable the smart controller temperature alarm. Options are
+	'on' or 'off'.
+
+-s::
+--spares=::
+	Inject <value> for the spares smart attribute.
+
+-S::
+--spares-threshold=::
+	Set <value> for the smart spares threshold.
+
+--spares-alarm=::
+	Enable or disable the smart spares alarm. Options are 'on' or 'off'.
+
+-H::
+--health=::
+	Smart attribute for health status. Provide either 'fatal' or 'nominal'
+	to set the state of the attribute.
+
+-U::
+--unsafe-shutdown=::
+	Set the flag to spoof an unsafe shutdown on the next power down.
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
index 0000000..02f8b0e
--- /dev/null
+++ b/ndctl/inject-smart.c
@@ -0,0 +1,436 @@
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
+static struct parameters {
+	const char *bus;
+	const char *dimm;
+	bool verbose;
+	bool human;
+	const char *media_temperature;
+	const char *ctrl_temperature;
+	const char *spares;
+	const char *media_temperature_threshold;
+	const char *ctrl_temperature_threshold;
+	const char *spares_threshold;
+	const char *media_temperature_alarm;
+	const char *ctrl_temperature_alarm;
+	const char *spares_alarm;
+	bool fatal;
+	bool unsafe_shutdown;
+} param;
+
+static struct smart_ctx {
+	bool alarms_present;
+	unsigned long op_mask;
+	unsigned long flags;
+	unsigned int media_temperature;
+	unsigned int ctrl_temperature;
+	unsigned long spares;
+	unsigned int media_temperature_threshold;
+	unsigned int ctrl_temperature_threshold;
+	unsigned long spares_threshold;
+	unsigned int media_temperature_alarm;
+	unsigned int ctrl_temperature_alarm;
+	unsigned long spares_alarm;
+} sctx;
+
+#define SMART_OPTIONS() \
+OPT_STRING('b', "bus", &param.bus, "bus-id", \
+	"limit dimm to a bus with an id or provider of <bus-id>"), \
+OPT_BOOLEAN('v', "verbose", &param.verbose, "emit extra debug messages to stderr"), \
+OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats"), \
+OPT_STRING('m', "media-temperature", &param.media_temperature, \
+	"smart media temperature attribute", \
+	"inject a value for smart media temperature"), \
+OPT_STRING('M', "media-temperature-threshold", \
+	&param.media_temperature_threshold, \
+	"set smart media temperature threshold", \
+	"set threshold value for smart media temperature"), \
+OPT_STRING('x', "media-temperature-alarm", &param.media_temperature_alarm, \
+	"smart media temperature alarm", \
+	"enable or disable the smart media temperature alarm"), \
+OPT_STRING('c', "ctrl-temperature", &param.ctrl_temperature, \
+	"smart controller temperature attribute", \
+	"inject a value for smart controller temperature"), \
+OPT_STRING('C', "ctrl-temperature-threshold", \
+	&param.ctrl_temperature_threshold, \
+	"set smart controller temperature threshold", \
+	"set threshold value for smart controller temperature"), \
+OPT_STRING('y', "ctrl-temperature-alarm", &param.ctrl_temperature_alarm, \
+	"smart controller temperature alarm", \
+	"enable or disable the smart controller temperature alarm"), \
+OPT_STRING('s', "spares", &param.spares, \
+	"smart spares attribute", \
+	"inject a value for smart spares"), \
+OPT_STRING('S', "spares-threshold", &param.spares_threshold, \
+	"set smart spares threshold", \
+	"set a threshold value for smart spares"), \
+OPT_STRING('z', "spares-alarm", &param.spares_alarm, \
+	"smart spares alarm", \
+	"enable or disable the smart spares alarm"), \
+OPT_BOOLEAN('f', "fatal", &param.fatal, "inject fatal smart health status"), \
+OPT_BOOLEAN('U', "unsafe-shutdown", &param.unsafe_shutdown, \
+	"inject smart unsafe shutdown status")
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
+enum alarms {
+	ALARM_ON = 1,
+	ALARM_OFF,
+};
+
+static inline void enable_set(void)
+{
+	sctx.op_mask |= 1 << OP_SET;
+}
+
+static inline void enable_inject(void)
+{
+	sctx.op_mask |= 1 << OP_INJECT;
+}
+
+#define smart_param_setup_uint(arg) \
+{ \
+	if (param.arg) { \
+		sctx.arg = strtoul(param.arg, NULL, 0); \
+		if (sctx.arg == ULONG_MAX || sctx.arg > UINT_MAX) { \
+			error("Invalid argument: %s: %s\n", #arg, param.arg); \
+			return -EINVAL; \
+		} \
+		enable_inject(); \
+	} \
+	if (param.arg##_threshold) { \
+		sctx.arg##_threshold = \
+			strtoul(param.arg##_threshold, NULL, 0); \
+		if (sctx.arg##_threshold == ULONG_MAX \
+				|| sctx.arg##_threshold > UINT_MAX) { \
+			error("Invalid argument: %s\n", \
+				param.arg##_threshold); \
+			return -EINVAL; \
+		} \
+		enable_set(); \
+	} \
+}
+
+#define smart_param_setup_temps(arg) \
+{ \
+	double temp; \
+	if (param.arg) { \
+		temp = strtod(param.arg, NULL); \
+		if (temp == HUGE_VAL || temp == -HUGE_VAL) { \
+			error("Invalid argument: %s: %s\n", #arg, param.arg); \
+			return -EINVAL; \
+		} \
+		sctx.arg = ndctl_encode_smart_temperature(temp); \
+		enable_inject(); \
+	} \
+	if (param.arg##_threshold) { \
+		temp = strtod(param.arg##_threshold, NULL); \
+		if (temp == HUGE_VAL || temp == -HUGE_VAL) { \
+			error("Invalid argument: %s\n", \
+				param.arg##_threshold); \
+			return -EINVAL; \
+		} \
+		sctx.arg##_threshold = ndctl_encode_smart_temperature(temp); \
+		enable_set(); \
+	} \
+}
+
+#define smart_param_setup_alarm(arg) \
+{ \
+	if (param.arg##_alarm) { \
+		if (strncmp(param.arg##_alarm, "on", 2) == 0) \
+			sctx.arg##_alarm = ALARM_ON; \
+		else if (strncmp(param.arg##_alarm, "off", 3) == 0) \
+			sctx.arg##_alarm = ALARM_OFF; \
+		sctx.alarms_present = true; \
+	} \
+}
+
+static int smart_init(void)
+{
+	if (param.human)
+		sctx.flags |= UTIL_JSON_HUMAN;
+
+	/* setup attributes and thresholds except alarm_control */
+	smart_param_setup_temps(media_temperature)
+	smart_param_setup_temps(ctrl_temperature)
+	smart_param_setup_uint(spares)
+
+	/* set up alarm_control */
+	smart_param_setup_alarm(media_temperature)
+	smart_param_setup_alarm(ctrl_temperature)
+	smart_param_setup_alarm(spares)
+	if (sctx.alarms_present)
+		enable_set();
+
+	/* setup remaining injection attributes */
+	if (param.fatal || param.unsafe_shutdown)
+		enable_inject();
+
+	if (sctx.op_mask == 0) {
+		error("No valid operation specified\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+#define setup_thresh_field(arg) \
+{ \
+	if (param.arg##_threshold) \
+		ndctl_cmd_smart_threshold_set_##arg(sst_cmd, \
+					sctx.arg##_threshold); \
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
+	/* setup all thresholds except alarm_control */
+	setup_thresh_field(media_temperature)
+	setup_thresh_field(ctrl_temperature)
+	setup_thresh_field(spares)
+
+	/* setup alarm_control manually */
+	if (sctx.alarms_present) {
+		unsigned int alarm;
+
+		alarm = ndctl_cmd_smart_threshold_get_alarm_control(st_cmd);
+		if (sctx.media_temperature_alarm == ALARM_ON)
+			alarm |= ND_SMART_TEMP_TRIP;
+		else if (sctx.media_temperature_alarm == ALARM_OFF)
+			alarm &= ~ND_SMART_TEMP_TRIP;
+		if (sctx.ctrl_temperature_alarm == ALARM_ON)
+			alarm |= ND_SMART_CTEMP_TRIP;
+		else if (sctx.ctrl_temperature_alarm == ALARM_OFF)
+			alarm &= ~ND_SMART_CTEMP_TRIP;
+		if (sctx.spares_alarm == ALARM_ON)
+			alarm |= ND_SMART_SPARE_TRIP;
+		else if (sctx.spares_alarm == ALARM_OFF)
+			alarm &= ~ND_SMART_SPARE_TRIP;
+
+		ndctl_cmd_smart_threshold_set_alarm_control(sst_cmd, alarm);
+	}
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
+	if (param.arg) { \
+		si_cmd = ndctl_dimm_cmd_new_smart_inject(dimm); \
+		if (!si_cmd) { \
+			error("%s: no smart inject command support\n", name); \
+			goto out; \
+		} \
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
+		ndctl_cmd_unref(si_cmd); \
+	} \
+}
+
+#define send_inject_bool(arg) \
+{ \
+	if (param.arg) { \
+		si_cmd = ndctl_dimm_cmd_new_smart_inject(dimm); \
+		if (!si_cmd) { \
+			error("%s: no smart inject command support\n", name); \
+			goto out; \
+		} \
+		rc = ndctl_cmd_smart_inject_##arg(si_cmd, true); \
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
+		ndctl_cmd_unref(si_cmd); \
+	} \
+}
+
+static int smart_inject(struct ndctl_dimm *dimm)
+{
+	const char *name = ndctl_dimm_get_devname(dimm);
+	struct ndctl_cmd *si_cmd;
+	int rc = -EOPNOTSUPP;
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
+	if (sctx.op_mask & (1 << OP_SET)) {
+		rc = smart_set_thresh(dimm);
+		if (rc)
+			goto out;
+	}
+	if (sctx.op_mask & (1 << OP_INJECT)) {
+		rc = smart_inject(dimm);
+		if (rc)
+			goto out;
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
+	if (param.verbose)
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
