Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 116BA21A10961
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:28:38 -0800 (PST)
Subject: [ndctl PATCH 04/17] ndctl,
 intel: switch to ND_CMD_CALL passthrough for SMART commands
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:24:51 -0800
Message-ID: <151217069123.28402.5348297664855420445.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The kernel's ND_IOCTL_SMART_THRESHOLD command is based on a payload
definition that has become broken / out-of-sync with recent versions of
the NVDIMM_FAMILY_INTEL definition. Deprecate the use of the
ND_IOCTL_SMART_THRESHOLD command in favor of the ND_CMD_CALL approach
taken by NVDIMM_FAMILY_{HPE,MSFT}, and update to the new payload format.

In a couple years, when the new scheme is widely deployed, the
ND_IOCTL_SMART_THRESHOLD definition can be removed.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/Makefile.am |    1 
 ndctl/lib/intel.c     |  230 +++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/intel.h     |   72 +++++++++++++++
 ndctl/lib/libndctl.c  |    3 -
 ndctl/lib/private.h   |    4 -
 ndctl/lib/smart.c     |  155 ---------------------------------
 6 files changed, 307 insertions(+), 158 deletions(-)
 create mode 100644 ndctl/lib/intel.c
 create mode 100644 ndctl/lib/intel.h

diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
index 3a6024ead6fb..3a51e799afa1 100644
--- a/ndctl/lib/Makefile.am
+++ b/ndctl/lib/Makefile.am
@@ -33,6 +33,7 @@ endif
 
 if ENABLE_SMART
 libndctl_la_SOURCES += smart.c
+libndctl_la_SOURCES += intel.c
 libndctl_la_SOURCES += hpe1.c
 libndctl_la_SOURCES += msft.c
 endif
diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
new file mode 100644
index 000000000000..5aad8c24f00c
--- /dev/null
+++ b/ndctl/lib/intel.c
@@ -0,0 +1,230 @@
+/*
+ * Copyright (c) 2016-2017, Intel Corporation.
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
+#include <util/log.h>
+#include <ndctl/libndctl.h>
+#include "private.h"
+
+static struct ndctl_cmd *alloc_intel_cmd(struct ndctl_dimm *dimm,
+		unsigned func, size_t in_size, size_t out_size)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	struct ndctl_cmd *cmd;
+	size_t size;
+
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL)) {
+		dbg(ctx, "unsupported cmd: %d\n", ND_CMD_CALL);
+		return NULL;
+	}
+
+	if (test_dimm_dsm(dimm, func) == DIMM_DSM_UNSUPPORTED) {
+		dbg(ctx, "unsupported function: %d\n", func);
+		return NULL;
+	}
+
+	size = sizeof(*cmd) + sizeof(struct nd_pkg_intel);
+	cmd = calloc(1, size);
+	if (!cmd)
+		return NULL;
+
+	cmd->dimm = dimm;
+	ndctl_cmd_ref(cmd);
+	cmd->type = ND_CMD_CALL;
+	cmd->size = size;
+	cmd->status = 1;
+
+	*(cmd->intel) = (struct nd_pkg_intel) {
+		.gen = {
+			.nd_family = NVDIMM_FAMILY_INTEL,
+			.nd_command = func,
+			.nd_size_in = in_size,
+			.nd_size_out = out_size,
+		},
+	};
+
+	return cmd;
+}
+
+static struct ndctl_cmd *intel_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
+{
+	struct ndctl_cmd *cmd;
+
+	BUILD_ASSERT(sizeof(struct nd_intel_smart) == 132);
+
+	cmd = alloc_intel_cmd(dimm, ND_INTEL_SMART,
+			0, sizeof(cmd->intel->smart));
+	if (!cmd)
+		return NULL;
+	cmd->firmware_status = &cmd->intel->smart.status;
+
+	return cmd;
+}
+
+static int intel_smart_valid(struct ndctl_cmd *cmd)
+{
+	struct nd_pkg_intel *pkg = cmd->intel;
+
+	if (cmd->type != ND_CMD_CALL || cmd->status != 0
+			|| pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
+			|| pkg->gen.nd_command != ND_INTEL_SMART)
+		return cmd->status < 0 ? cmd->status : -EINVAL;
+	return 0;
+}
+
+#define intel_smart_get_field(cmd, field) \
+static unsigned int intel_cmd_smart_get_##field(struct ndctl_cmd *cmd) \
+{ \
+	if (intel_smart_valid(cmd) < 0) \
+		return UINT_MAX; \
+	return cmd->intel->smart.field; \
+}
+
+static unsigned int intel_cmd_smart_get_flags(struct ndctl_cmd *cmd)
+{
+	unsigned int flags = 0;
+	unsigned int intel_flags;
+
+	if (intel_smart_valid(cmd) < 0)
+		return 0;
+
+	/* translate intel specific flags to libndctl api smart flags */
+	intel_flags = cmd->intel->smart.flags;
+	if (intel_flags & ND_INTEL_SMART_HEALTH_VALID)
+		flags |= ND_SMART_HEALTH_VALID;
+	if (intel_flags & ND_INTEL_SMART_SPARES_VALID)
+		flags |= ND_SMART_SPARES_VALID;
+	if (intel_flags & ND_INTEL_SMART_USED_VALID)
+		flags |= ND_SMART_USED_VALID;
+	if (intel_flags & ND_INTEL_SMART_MTEMP_VALID)
+		flags |= ND_SMART_TEMP_VALID;
+	if (intel_flags & ND_INTEL_SMART_SHUTDOWN_COUNT_VALID)
+		flags |= ND_SMART_SHUTDOWN_COUNT_VALID;
+	if (intel_flags & ND_INTEL_SMART_ALARM_VALID)
+		flags |= ND_SMART_ALARM_VALID;
+	if (intel_flags & ND_INTEL_SMART_SHUTDOWN_VALID)
+		flags |= ND_SMART_SHUTDOWN_VALID;
+	if (intel_flags & ND_INTEL_SMART_VENDOR_VALID)
+		flags |= ND_SMART_VENDOR_VALID;
+	return flags;
+}
+
+static unsigned int intel_cmd_smart_get_health(struct ndctl_cmd *cmd)
+{
+	unsigned int health = 0;
+	unsigned int intel_health;
+
+	if (intel_smart_valid(cmd) < 0)
+		return 0;
+	intel_health = cmd->intel->smart.health;
+	if (intel_health & ND_INTEL_SMART_NON_CRITICAL_HEALTH)
+		health |= ND_SMART_NON_CRITICAL_HEALTH;
+	if (intel_health & ND_INTEL_SMART_CRITICAL_HEALTH)
+		health |= ND_SMART_CRITICAL_HEALTH;
+	if (intel_health & ND_INTEL_SMART_FATAL_HEALTH)
+		health |= ND_SMART_FATAL_HEALTH;
+	return health;
+}
+
+intel_smart_get_field(cmd, media_temperature)
+intel_smart_get_field(cmd, spares)
+intel_smart_get_field(cmd, alarm_flags)
+intel_smart_get_field(cmd, life_used)
+intel_smart_get_field(cmd, shutdown_state)
+intel_smart_get_field(cmd, shutdown_count)
+intel_smart_get_field(cmd, vendor_size)
+
+static unsigned char *intel_cmd_smart_get_vendor_data(struct ndctl_cmd *cmd)
+{
+	if (intel_smart_valid(cmd) < 0)
+		return NULL;
+	return cmd->intel->smart.vendor_data;
+}
+
+static int intel_smart_threshold_valid(struct ndctl_cmd *cmd)
+{
+	struct nd_pkg_intel *pkg = cmd->intel;
+
+	if (cmd->type != ND_CMD_CALL || cmd->status != 0
+			|| pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
+			|| pkg->gen.nd_command != ND_INTEL_SMART_THRESHOLD)
+		return cmd->status < 0 ? cmd->status : -EINVAL;
+	return 0;
+}
+
+#define intel_smart_threshold_get_field(cmd, field) \
+static unsigned int intel_cmd_smart_threshold_get_##field( \
+			struct ndctl_cmd *cmd) \
+{ \
+	if (intel_smart_threshold_valid(cmd) < 0) \
+		return UINT_MAX; \
+	return cmd->intel->thresh.field; \
+}
+
+static unsigned int intel_cmd_smart_threshold_get_alarm_control(
+		struct ndctl_cmd *cmd)
+{
+	struct nd_intel_smart_threshold *thresh;
+	unsigned int flags = 0;
+
+        if (intel_smart_threshold_valid(cmd) < 0)
+		return 0;
+
+	thresh = &cmd->intel->thresh;
+	if (thresh->alarm_control & ND_INTEL_SMART_SPARE_TRIP)
+		flags |= ND_SMART_SPARE_TRIP;
+	if (thresh->alarm_control & ND_INTEL_SMART_TEMP_TRIP)
+		flags |= ND_SMART_TEMP_TRIP;
+	if (thresh->alarm_control & ND_INTEL_SMART_CTEMP_TRIP)
+		flags |= ND_SMART_CTEMP_TRIP;
+
+	return flags;
+}
+
+intel_smart_threshold_get_field(cmd, media_temperature)
+intel_smart_threshold_get_field(cmd, spares)
+
+static struct ndctl_cmd *intel_dimm_cmd_new_smart_threshold(
+		struct ndctl_dimm *dimm)
+{
+	struct ndctl_cmd *cmd;
+
+	BUILD_ASSERT(sizeof(struct nd_intel_smart_threshold) == 12);
+
+	cmd = alloc_intel_cmd(dimm, ND_INTEL_SMART_THRESHOLD,
+			0, sizeof(cmd->intel->thresh));
+	if (!cmd)
+		return NULL;
+	cmd->firmware_status = &cmd->intel->thresh.status;
+
+	return cmd;
+}
+
+struct ndctl_smart_ops * const intel_smart_ops = &(struct ndctl_smart_ops) {
+	.new_smart = intel_dimm_cmd_new_smart,
+	.smart_get_flags = intel_cmd_smart_get_flags,
+	.smart_get_health = intel_cmd_smart_get_health,
+	.smart_get_media_temperature = intel_cmd_smart_get_media_temperature,
+	.smart_get_spares = intel_cmd_smart_get_spares,
+	.smart_get_alarm_flags = intel_cmd_smart_get_alarm_flags,
+	.smart_get_life_used = intel_cmd_smart_get_life_used,
+	.smart_get_shutdown_state = intel_cmd_smart_get_shutdown_state,
+	.smart_get_shutdown_count = intel_cmd_smart_get_shutdown_count,
+	.smart_get_vendor_size = intel_cmd_smart_get_vendor_size,
+	.smart_get_vendor_data = intel_cmd_smart_get_vendor_data,
+	.new_smart_threshold = intel_dimm_cmd_new_smart_threshold,
+	.smart_threshold_get_alarm_control = intel_cmd_smart_threshold_get_alarm_control,
+	.smart_threshold_get_media_temperature
+		= intel_cmd_smart_threshold_get_media_temperature,
+	.smart_threshold_get_spares = intel_cmd_smart_threshold_get_spares,
+};
diff --git a/ndctl/lib/intel.h b/ndctl/lib/intel.h
new file mode 100644
index 000000000000..8cecc02f9ae6
--- /dev/null
+++ b/ndctl/lib/intel.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/* Copyright (c) 2017, Intel Corporation. All rights reserved. */
+
+#ifndef __INTEL_H__
+#define __INTEL_H__
+#define ND_INTEL_SMART 1
+#define ND_INTEL_SMART_THRESHOLD 2
+
+#define ND_INTEL_SMART_HEALTH_VALID             (1 << 0)
+#define ND_INTEL_SMART_SPARES_VALID             (1 << 1)
+#define ND_INTEL_SMART_USED_VALID               (1 << 2)
+#define ND_INTEL_SMART_MTEMP_VALID              (1 << 3)
+#define ND_INTEL_SMART_CTEMP_VALID              (1 << 4)
+#define ND_INTEL_SMART_SHUTDOWN_COUNT_VALID     (1 << 5)
+#define ND_INTEL_SMART_AIT_STATUS_VALID         (1 << 6)
+#define ND_INTEL_SMART_PTEMP_VALID              (1 << 7)
+#define ND_INTEL_SMART_ALARM_VALID              (1 << 9)
+#define ND_INTEL_SMART_SHUTDOWN_VALID           (1 << 10)
+#define ND_INTEL_SMART_VENDOR_VALID             (1 << 11)
+#define ND_INTEL_SMART_SPARE_TRIP               (1 << 0)
+#define ND_INTEL_SMART_TEMP_TRIP                (1 << 1)
+#define ND_INTEL_SMART_CTEMP_TRIP               (1 << 2)
+#define ND_INTEL_SMART_NON_CRITICAL_HEALTH      (1 << 0)
+#define ND_INTEL_SMART_CRITICAL_HEALTH          (1 << 1)
+#define ND_INTEL_SMART_FATAL_HEALTH             (1 << 2)
+
+struct nd_intel_smart {
+        __u32 status;
+	union {
+		struct {
+			__u32 flags;
+			__u8 reserved0[4];
+			__u8 health;
+			__u8 spares;
+			__u8 life_used;
+			__u8 alarm_flags;
+			__u16 media_temperature;
+			__u16 ctrl_temperature;
+			__u32 shutdown_count;
+			__u8 ait_status;
+			__u16 pmic_temperature;
+			__u8 reserved1[8];
+			__u8 shutdown_state;
+			__u32 vendor_size;
+			__u8 vendor_data[92];
+		} __attribute__((packed));
+		__u8 data[128];
+	};
+} __attribute__((packed));
+
+struct nd_intel_smart_threshold {
+        __u32 status;
+	union {
+		struct {
+			__u16 alarm_control;
+			__u8 spares;
+			__u16 media_temperature;
+			__u16 ctrl_temperature;
+			__u8 reserved[1];
+		} __attribute__((packed));
+		__u8 data[8];
+	};
+} __attribute__((packed));
+
+struct nd_pkg_intel {
+	struct nd_cmd_pkg gen;
+	union {
+		struct nd_intel_smart smart;
+		struct nd_intel_smart_threshold	thresh;
+	};
+};
+#endif /* __INTEL_H__ */
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 0473b482ad23..26d1a1705397 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1218,7 +1218,6 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 		goto err_read;
 	dimm->module = to_module(ctx, buf);
 
-	dimm->smart_ops = intel_smart_ops;
 	dimm->handle = -1;
 	dimm->phys_id = -1;
 	dimm->serial = -1;
@@ -1306,6 +1305,8 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 	sprintf(path, "%s/nfit/family", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		dimm->cmd_family = strtoul(buf, NULL, 0);
+	if (dimm->cmd_family == NVDIMM_FAMILY_INTEL)
+		dimm->smart_ops = intel_smart_ops;
 	if (dimm->cmd_family == NVDIMM_FAMILY_HPE1)
 		dimm->smart_ops = hpe1_smart_ops;
 	if (dimm->cmd_family == NVDIMM_FAMILY_MSFT)
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index c2ce519ebad2..08e60af95e9e 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -31,6 +31,7 @@
 #include <ndctl/libndctl.h>
 #include <ccan/endian/endian.h>
 #include <ccan/short_types/short_types.h>
+#include "intel.h"
 #include "hpe1.h"
 #include "msft.h"
 
@@ -268,8 +269,7 @@ struct ndctl_cmd {
 #endif
 		struct ndn_pkg_hpe1 hpe1[0];
 		struct ndn_pkg_msft msft[0];
-		struct nd_cmd_smart smart[0];
-		struct nd_cmd_smart_threshold smart_t[0];
+		struct nd_pkg_intel intel[0];
 		struct nd_cmd_get_config_size get_size[0];
 		struct nd_cmd_get_config_data_hdr get_data[0];
 		struct nd_cmd_set_config_hdr set_data[0];
diff --git a/ndctl/lib/smart.c b/ndctl/lib/smart.c
index d30288a1486a..3eeb70e0d2b1 100644
--- a/ndctl/lib/smart.c
+++ b/ndctl/lib/smart.c
@@ -77,158 +77,3 @@ NDCTL_EXPORT unsigned int ndctl_cmd_smart_threshold_get_temperature(
 {
 	return ndctl_cmd_smart_threshold_get_media_temperature(cmd);
 }
-
-/*
- * The following intel_dimm_*() and intel_smart_*() functions implement
- * the ndctl_smart_ops for the Intel DSM family (NVDIMM_FAMILY_INTEL):
- */
-
-static struct ndctl_cmd *intel_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
-{
-	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
-	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
-	struct ndctl_cmd *cmd;
-	size_t size;
-
-	BUILD_ASSERT(sizeof(struct nd_smart_payload) == 128);
-
-	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART)) {
-		dbg(ctx, "unsupported cmd\n");
-		return NULL;
-	}
-
-	size = sizeof(*cmd) + sizeof(struct nd_cmd_smart);
-	cmd = calloc(1, size);
-	if (!cmd)
-		return NULL;
-
-	cmd->dimm = dimm;
-	ndctl_cmd_ref(cmd);
-	cmd->type = ND_CMD_SMART;
-	cmd->size = size;
-	cmd->status = 1;
-	cmd->firmware_status = &cmd->smart->status;
-
-	return cmd;
-}
-
-static int intel_smart_valid(struct ndctl_cmd *cmd)
-{
-	if (cmd->type != ND_CMD_SMART || cmd->status != 0)
-		return cmd->status < 0 ? cmd->status : -EINVAL;
-	return 0;
-}
-
-#define intel_smart_get_field(cmd, field) \
-static unsigned int intel_cmd_smart_get_##field(struct ndctl_cmd *cmd) \
-{ \
-	struct nd_smart_payload *smart_data; \
-	if (intel_smart_valid(cmd) < 0) \
-		return UINT_MAX; \
-	smart_data = (struct nd_smart_payload *) cmd->smart->data; \
-	return smart_data->field; \
-}
-
-intel_smart_get_field(cmd, flags)
-intel_smart_get_field(cmd, health)
-intel_smart_get_field(cmd, temperature)
-intel_smart_get_field(cmd, spares)
-intel_smart_get_field(cmd, alarm_flags)
-intel_smart_get_field(cmd, life_used)
-intel_smart_get_field(cmd, shutdown_state)
-intel_smart_get_field(cmd, shutdown_count)
-intel_smart_get_field(cmd, vendor_size)
-
-static unsigned int intel_cmd_smart_get_media_temperature(
-		struct ndctl_cmd *cmd)
-{
-	return intel_cmd_smart_get_temperature(cmd);
-}
-
-static unsigned char *intel_cmd_smart_get_vendor_data(struct ndctl_cmd *cmd)
-{
-	struct nd_smart_payload *smart_data;
-
-	if (intel_smart_valid(cmd) < 0)
-		return NULL;
-	smart_data = (struct nd_smart_payload *) cmd->smart->data;
-	return (unsigned char *) smart_data->vendor_data;
-}
-
-static int intel_smart_threshold_valid(struct ndctl_cmd *cmd)
-{
-	if (cmd->type != ND_CMD_SMART_THRESHOLD || cmd->status != 0)
-		return cmd->status < 0 ? cmd->status : -EINVAL;
-	return 0;
-}
-
-#define intel_smart_threshold_get_field(cmd, field) \
-static unsigned int intel_cmd_smart_threshold_get_##field( \
-			struct ndctl_cmd *cmd) \
-{ \
-	struct nd_smart_threshold_payload *smart_t_data; \
-	if (intel_smart_threshold_valid(cmd) < 0) \
-		return UINT_MAX; \
-	smart_t_data = (struct nd_smart_threshold_payload *) \
-			cmd->smart_t->data; \
-	return smart_t_data->field; \
-}
-
-intel_smart_threshold_get_field(cmd, alarm_control)
-intel_smart_threshold_get_field(cmd, temperature)
-intel_smart_threshold_get_field(cmd, spares)
-
-static unsigned int intel_cmd_smart_threshold_get_media_temperature(
-		struct ndctl_cmd *cmd)
-{
-	return intel_cmd_smart_threshold_get_temperature(cmd);
-}
-
-static struct ndctl_cmd *intel_dimm_cmd_new_smart_threshold(
-		struct ndctl_dimm *dimm)
-{
-	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
-	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
-	struct ndctl_cmd *cmd;
-	size_t size;
-
-	BUILD_ASSERT(sizeof(struct nd_smart_threshold_payload) == 8);
-
-	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART_THRESHOLD)) {
-		dbg(ctx, "unsupported cmd\n");
-		return NULL;
-	}
-
-	size = sizeof(*cmd) + sizeof(struct nd_cmd_smart_threshold);
-	cmd = calloc(1, size);
-	if (!cmd)
-		return NULL;
-
-	cmd->dimm = dimm;
-	ndctl_cmd_ref(cmd);
-	cmd->type = ND_CMD_SMART_THRESHOLD;
-	cmd->size = size;
-	cmd->status = 1;
-	cmd->firmware_status = &cmd->smart_t->status;
-
-	return cmd;
-}
-
-struct ndctl_smart_ops * const intel_smart_ops = &(struct ndctl_smart_ops) {
-	.new_smart = intel_dimm_cmd_new_smart,
-	.smart_get_flags = intel_cmd_smart_get_flags,
-	.smart_get_health = intel_cmd_smart_get_health,
-	.smart_get_media_temperature = intel_cmd_smart_get_media_temperature,
-	.smart_get_spares = intel_cmd_smart_get_spares,
-	.smart_get_alarm_flags = intel_cmd_smart_get_alarm_flags,
-	.smart_get_life_used = intel_cmd_smart_get_life_used,
-	.smart_get_shutdown_state = intel_cmd_smart_get_shutdown_state,
-	.smart_get_shutdown_count = intel_cmd_smart_get_shutdown_count,
-	.smart_get_vendor_size = intel_cmd_smart_get_vendor_size,
-	.smart_get_vendor_data = intel_cmd_smart_get_vendor_data,
-	.new_smart_threshold = intel_dimm_cmd_new_smart_threshold,
-	.smart_threshold_get_alarm_control = intel_cmd_smart_threshold_get_alarm_control,
-	.smart_threshold_get_media_temperature
-		= intel_cmd_smart_threshold_get_media_temperature,
-	.smart_threshold_get_spares = intel_cmd_smart_threshold_get_spares,
-};

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
