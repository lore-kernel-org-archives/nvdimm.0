Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id C99C61A1F61
 for <linux-nvdimm@lists.01.org>; Wed,  6 Apr 2016 18:08:00 -0700 (PDT)
Subject: [ndctl PATCH 2/5] ndctl: helper for S.M.A.R.T. data retrieval
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 06 Apr 2016 18:07:09 -0700
Message-ID: <20160407010709.30641.55484.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160407010659.30641.26139.stgit@dwillia2-desk3.jf.intel.com>
References: <20160407010659.30641.26139.stgit@dwillia2-desk3.jf.intel.com>
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

Helper functions to issue the "SMART and Health Info (Function Index 1)"
DSM and parse its results.

    http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am             |    4 ++
 configure.ac            |   26 +++++++++++++++
 lib/libndctl-private.h  |    1 +
 lib/libndctl-smart.c    |   81 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/libndctl.c          |    1 +
 lib/libndctl.sym        |   10 ++++++
 lib/ndctl/libndctl.h.in |   55 ++++++++++++++++++++++++++++++++
 ndctl.h                 |   29 +++++++++++++++++
 test/libndctl.c         |   68 +++++++++++++++++++++++++++++++++++++++
 9 files changed, 274 insertions(+), 1 deletion(-)
 create mode 100644 lib/libndctl-smart.c

diff --git a/Makefile.am b/Makefile.am
index 379f6404671f..9c6b37410642 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -85,6 +85,10 @@ if ENABLE_ARS
 lib_libndctl_la_SOURCES += lib/libndctl-ars.c
 endif
 
+if ENABLE_SMART
+lib_libndctl_la_SOURCES += lib/libndctl-smart.c
+endif
+
 bin_PROGRAMS = ndctl
 
 ndctl_SOURCES = ndctl.c \
diff --git a/configure.ac b/configure.ac
index 1ab376885215..01f347a7f137 100644
--- a/configure.ac
+++ b/configure.ac
@@ -144,6 +144,25 @@ AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
 )
 AM_CONDITIONAL([ENABLE_CLEAR_ERROR], [test "x$enable_clear_err" = "xyes"])
 
+AC_MSG_CHECKING([for SMART support])
+AC_LANG(C)
+AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
+			#ifdef HAVE_NDCTL_H
+			#include <linux/ndctl.h>
+			#else
+			#include "ndctl.h"
+			#endif
+			]], [[
+			int x = ND_SMART_HEALTH_VALID;
+			]]
+		)], [AC_MSG_RESULT([yes])
+		     enable_smart=yes
+		     AC_DEFINE([HAVE_NDCTL_SMART], [1],
+				[Define to 1 if ndctl.h has SMART support.])
+		], [AC_MSG_RESULT([no])]
+)
+AM_CONDITIONAL([ENABLE_SMART], [test "x$enable_smart" = "xyes"])
+
 AC_CONFIG_COMMANDS([gen-libndctl.h],
 		[[
 		if test "x$enable_ars" = "xyes"; then
@@ -151,17 +170,24 @@ AC_CONFIG_COMMANDS([gen-libndctl.h],
 		else
 			enable_ars=0
 		fi
+		if test "x$enable_smart" = "xyes"; then
+			enable_smart=1
+		else
+			enable_smart=0
+		fi
 		if test "x$enable_clear_err" = "xyes"; then
 			enable_clear_err=1
 		else
 			enable_clear_err=0
 		fi
 		sed -e s/HAVE_NDCTL_ARS/$enable_ars/ \
+		    -e s/HAVE_NDCTL_SMART/$enable_smart/ \
 		    -e s/HAVE_NDCTL_CLEAR_ERROR/$enable_clear_err/ \
 		< lib/ndctl/libndctl.h.in > lib/ndctl/libndctl.h
 		]],
 		[[
 		enable_ars=$enable_ars
+		enable_smart=$enable_smart
 		enable_clear_err=$enable_clear_err
 		]])
 
diff --git a/lib/libndctl-private.h b/lib/libndctl-private.h
index 50b03743751f..37aed296a571 100644
--- a/lib/libndctl-private.h
+++ b/lib/libndctl-private.h
@@ -167,6 +167,7 @@ struct ndctl_cmd {
 #ifdef HAVE_NDCTL_CLEAR_ERROR
 		struct nd_cmd_clear_error clear_err[0];
 #endif
+		struct nd_cmd_smart smart[0];
 		struct nd_cmd_get_config_size get_size[0];
 		struct nd_cmd_get_config_data_hdr get_data[0];
 		struct nd_cmd_set_config_hdr set_data[0];
diff --git a/lib/libndctl-smart.c b/lib/libndctl-smart.c
new file mode 100644
index 000000000000..1013eddd45dc
--- /dev/null
+++ b/lib/libndctl-smart.c
@@ -0,0 +1,81 @@
+/*
+ * Copyright (c) 2016, Intel Corporation.
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
+#include <stdlib.h>
+#include <limits.h>
+#include <ndctl/libndctl.h>
+#include "libndctl-private.h"
+
+NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
+{
+	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+	struct ndctl_cmd *cmd;
+	size_t size;
+
+	BUILD_ASSERT(sizeof(struct nd_smart_payload) == 128);
+
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART)) {
+		dbg(ctx, "unsupported cmd\n");
+		return NULL;
+	}
+
+	size = sizeof(*cmd) + sizeof(struct nd_cmd_smart);
+	cmd = calloc(1, size);
+	if (!cmd)
+		return NULL;
+
+	cmd->dimm = dimm;
+	ndctl_cmd_ref(cmd);
+	cmd->type = ND_CMD_SMART;
+	cmd->size = size;
+	cmd->status = 1;
+	cmd->firmware_status = &cmd->smart->status;
+
+	return cmd;
+}
+
+static int smart_valid(struct ndctl_cmd *cmd)
+{
+	if (cmd->type != ND_CMD_SMART || cmd->status != 0)
+		return cmd->status < 0 ? cmd->status : -EINVAL;
+	return 0;
+}
+
+#define ndctl_cmd_get_field(cmd, field) \
+NDCTL_EXPORT unsigned int ndctl_cmd_smart_get_##field(struct ndctl_cmd *cmd) \
+{ \
+	struct nd_smart_payload *smart_data; \
+	if (smart_valid(cmd) < 0) \
+		return UINT_MAX; \
+	smart_data = (struct nd_smart_payload *) cmd->smart->data; \
+	return smart_data->field; \
+}
+
+ndctl_cmd_get_field(cmd, flags)
+ndctl_cmd_get_field(cmd, health)
+ndctl_cmd_get_field(cmd, temperature)
+ndctl_cmd_get_field(cmd, spares)
+ndctl_cmd_get_field(cmd, alarm_flags)
+ndctl_cmd_get_field(cmd, life_used)
+ndctl_cmd_get_field(cmd, shutdown_state)
+ndctl_cmd_get_field(cmd, vendor_size)
+
+NDCTL_EXPORT unsigned char *ndctl_cmd_smart_get_vendor_data(struct ndctl_cmd *cmd)
+{
+	struct nd_smart_payload *smart_data;
+
+	if (smart_valid(cmd) < 0)
+		return NULL;
+	smart_data = (struct nd_smart_payload *) cmd->smart->data;
+	return (unsigned char *) smart_data->vendor_data;
+}
diff --git a/lib/libndctl.c b/lib/libndctl.c
index 26de91af8a63..c25107f3eba7 100644
--- a/lib/libndctl.c
+++ b/lib/libndctl.c
@@ -26,6 +26,7 @@
 #include <ccan/list/list.h>
 #include <ccan/minmax/minmax.h>
 #include <ccan/array_size/array_size.h>
+#include <ccan/build_assert/build_assert.h>
 
 #ifdef HAVE_NDCTL_H
 #include <linux/ndctl.h>
diff --git a/lib/libndctl.sym b/lib/libndctl.sym
index 5ff8848ee6d3..2a0d36d89f67 100644
--- a/lib/libndctl.sym
+++ b/lib/libndctl.sym
@@ -86,6 +86,16 @@ global:
 	ndctl_dimm_cmd_new_cfg_size;
 	ndctl_dimm_cmd_new_cfg_read;
 	ndctl_dimm_cmd_new_cfg_write;
+	ndctl_dimm_cmd_new_smart;
+	ndctl_cmd_smart_get_flags;
+	ndctl_cmd_smart_get_health;
+	ndctl_cmd_smart_get_temperature;
+	ndctl_cmd_smart_get_spares;
+	ndctl_cmd_smart_get_alarm_flags;
+	ndctl_cmd_smart_get_life_used;
+	ndctl_cmd_smart_get_shutdown_state;
+	ndctl_cmd_smart_get_vendor_size;
+	ndctl_cmd_smart_get_vendor_data;
 	ndctl_dimm_zero_labels;
 	ndctl_dimm_get_available_labels;
 	ndctl_region_get_first;
diff --git a/lib/ndctl/libndctl.h.in b/lib/ndctl/libndctl.h.in
index 2a05e0ba477c..37527a7251ff 100644
--- a/lib/ndctl/libndctl.h.in
+++ b/lib/ndctl/libndctl.h.in
@@ -252,6 +252,61 @@ static inline unsigned long long ndctl_cmd_clear_error_get_cleared(
 }
 #endif
 
+#define HAS_SMART HAVE_NDCTL_SMART
+#if HAS_SMART == 1
+struct ndctl_cmd *ndctl_dimm_cmd_new_smart(struct ndctl_dimm *dimm);
+unsigned int ndctl_cmd_smart_get_flags(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_smart_get_health(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_smart_get_temperature(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_smart_get_spares(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_smart_get_alarm_flags(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_smart_get_life_used(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_smart_get_shutdown_state(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_smart_get_vendor_size(struct ndctl_cmd *cmd);
+unsigned char *ndctl_cmd_smart_get_vendor_data(struct ndctl_cmd *cmd);
+#else
+static inline struct ndctl_cmd *ndctl_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
+{
+	return NULL;
+}
+static inline unsigned int ndctl_cmd_smart_get_flags(struct ndctl_cmd *cmd)
+{
+	return 0;
+}
+static inline unsigned int ndctl_cmd_smart_get_health(struct ndctl_cmd *cmd)
+{
+	return 0;
+}
+static inline unsigned int ndctl_cmd_smart_get_temperature(struct ndctl_cmd *cmd)
+{
+	return 0;
+}
+static inline unsigned int ndctl_cmd_smart_get_spares(struct ndctl_cmd *cmd)
+{
+	return 0;
+}
+static inline unsigned int ndctl_cmd_smart_get_alarm_flags(struct ndctl_cmd *cmd)
+{
+	return 0;
+}
+static inline unsigned int ndctl_cmd_smart_get_life_used(struct ndctl_cmd *cmd)
+{
+	return 0;
+}
+static inline unsigned int ndctl_cmd_smart_get_shutdown_state(struct ndctl_cmd *cmd)
+{
+	return 0;
+}
+static inline unsigned int ndctl_cmd_smart_get_vendor_size(struct ndctl_cmd *cmd)
+{
+	return 0;
+}
+static inline unsigned char *ndctl_cmd_smart_get_vendor_data(struct ndctl_cmd *cmd)
+{
+	return NULL;
+}
+#endif
+
 struct ndctl_cmd *ndctl_dimm_cmd_new_vendor_specific(struct ndctl_dimm *dimm,
 		unsigned int opcode, size_t input_size, size_t output_size);
 ssize_t ndctl_cmd_vendor_set_input(struct ndctl_cmd *cmd, void *buf,
diff --git a/ndctl.h b/ndctl.h
index 69b8e707fc49..445b4d6d4df0 100644
--- a/ndctl.h
+++ b/ndctl.h
@@ -20,6 +20,35 @@ struct nd_cmd_smart {
 	__u8 data[128];
 } __attribute__((packed));
 
+enum {
+	ND_SMART_HEALTH_VALID	= 1 << 0,
+	ND_SMART_TEMP_VALID 	= 1 << 1,
+	ND_SMART_SPARES_VALID	= 1 << 2,
+	ND_SMART_ALARM_VALID	= 1 << 3,
+	ND_SMART_USED_VALID	= 1 << 4,
+	ND_SMART_SHUTDOWN_VALID	= 1 << 5,
+	ND_SMART_VENDOR_VALID	= 1 << 6,
+	ND_SMART_TEMP_TRIP	= 1 << 0,
+	ND_SMART_SPARE_TRIP	= 1 << 1,
+	ND_SMART_NON_CRITICAL_HEALTH	= 1 << 0,
+	ND_SMART_CRITICAL_HEALTH	= 1 << 1,
+	ND_SMART_FATAL_HEALTH		= 1 << 2,
+};
+
+struct nd_smart_payload {
+	__u32 flags;
+	__u8 reserved0[4];
+	__u8 health;
+	__u16 temperature;
+	__u8 spares;
+	__u8 alarm_flags;
+	__u8 life_used;
+	__u8 shutdown_state;
+	__u8 reserved1;
+	__u32 vendor_size;
+	__u8 vendor_data[108];
+} __attribute__((packed));
+
 struct nd_cmd_smart_threshold {
 	__u32 status;
 	__u8 data[8];
diff --git a/test/libndctl.c b/test/libndctl.c
index 0e9c830e68a1..11c05f590ad7 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -377,7 +377,7 @@ static struct region regions1[] = {
 
 static unsigned long dimm_commands0 = 1UL << ND_CMD_GET_CONFIG_SIZE
 		| 1UL << ND_CMD_GET_CONFIG_DATA
-		| 1UL << ND_CMD_SET_CONFIG_DATA;
+		| 1UL << ND_CMD_SET_CONFIG_DATA | 1UL << ND_CMD_SMART;
 
 static unsigned long bus_commands0 = 1UL << ND_CMD_ARS_CAP
 		| 1UL << ND_CMD_ARS_START
@@ -1586,6 +1586,71 @@ static int check_set_config_data(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	return 0;
 }
 
+#ifdef HAVE_NDCTL_SMART
+#define __check_smart(dimm, cmd, field) ({ \
+	if (ndctl_cmd_smart_get_##field(cmd) != smart_data.field) { \
+		fprintf(stderr, "%s dimm: %#x expected field %#x got: %#x\n", \
+				__func__, ndctl_dimm_get_handle(dimm), \
+				smart_data.field, \
+				ndctl_cmd_smart_get_##field(cmd)); \
+		ndctl_cmd_unref(cmd); \
+		return -ENXIO; \
+	} \
+})
+
+static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
+		struct check_cmd *check)
+{
+	static const struct nd_smart_payload smart_data = {
+		.flags = ND_SMART_HEALTH_VALID | ND_SMART_TEMP_VALID
+			| ND_SMART_SPARES_VALID | ND_SMART_ALARM_VALID
+			| ND_SMART_USED_VALID | ND_SMART_SHUTDOWN_VALID,
+		.health = ND_SMART_NON_CRITICAL_HEALTH,
+		.temperature = 23 * 16,
+		.spares = 75,
+		.alarm_flags = ND_SMART_SPARE_TRIP | ND_SMART_TEMP_TRIP,
+		.life_used = 5,
+		.shutdown_state = 0,
+		.vendor_size = 0,
+	};
+	struct ndctl_cmd *cmd = ndctl_dimm_cmd_new_smart(dimm);
+	int rc;
+
+	if (!cmd) {
+		fprintf(stderr, "%s: dimm: %#x failed to create cmd\n",
+				__func__, ndctl_dimm_get_handle(dimm));
+		return -ENXIO;
+	}
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
+		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %d\n",
+			__func__, ndctl_dimm_get_handle(dimm), rc);
+		ndctl_cmd_unref(cmd);
+		return rc;
+	}
+
+	__check_smart(dimm, cmd, flags);
+	__check_smart(dimm, cmd, health);
+	__check_smart(dimm, cmd, temperature);
+	__check_smart(dimm, cmd, spares);
+	__check_smart(dimm, cmd, alarm_flags);
+	__check_smart(dimm, cmd, life_used);
+	__check_smart(dimm, cmd, shutdown_state);
+	__check_smart(dimm, cmd, vendor_size);
+
+	ndctl_cmd_unref(cmd);
+	return 0;
+}
+#else
+static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
+		struct check_cmd *check)
+{
+	fprintf(stderr, "%s: HAVE_NDCTL_SMART disabled, skipping\n", __func__);
+	return 0;
+}
+#endif
+
 #ifdef HAVE_NDCTL_ARS
 static int check_ars_cap(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		struct check_cmd *check)
@@ -1808,6 +1873,7 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		[ND_CMD_GET_CONFIG_SIZE] = { check_get_config_size },
 		[ND_CMD_GET_CONFIG_DATA] = { check_get_config_data },
 		[ND_CMD_SET_CONFIG_DATA] = { check_set_config_data },
+		[ND_CMD_SMART] = { check_smart },
 		[ND_CMD_SMART_THRESHOLD] = { },
 	};
 	static struct check_cmd __check_bus_cmds[] = {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
