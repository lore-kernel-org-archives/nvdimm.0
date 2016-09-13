Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B2361A1E47
 for <linux-nvdimm@lists.01.org>; Tue, 13 Sep 2016 10:44:11 -0700 (PDT)
From: Brian Boylston <brian.boylston@hpe.com>
Subject: [ndctl PATCH v2 4/4] libndctl: add support for the HPE1 family of DSM
 SMART functions
Date: Tue, 13 Sep 2016 12:41:40 -0500
Message-Id: <20160913174140.10810-5-brian.boylston@hpe.com>
In-Reply-To: <20160913174140.10810-1-brian.boylston@hpe.com>
References: <20160913174140.10810-1-brian.boylston@hpe.com>
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

This patch introduces a set of ndctl_smart_ops for the HPE1 DSM family.
The implementation calls the HPE1 DSM functions defined in [1] and
translates the results to match the existing Intel DSM-inspired
smart_ops.  This delivers health reporting parity for HPE type N
NVDIMMs, but we are planning a future patch to add reporting for some of
the additional health data defined in [1].

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
---
 ndctl/Makefile.am            |   1 +
 ndctl/lib/libndctl-hpe1.c    | 303 ++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl-private.h |   1 +
 ndctl/lib/libndctl.c         |   5 +-
 ndctl/lib/ndctl-hpe1.h       | 335 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 644 insertions(+), 1 deletion(-)
 create mode 100644 ndctl/lib/libndctl-hpe1.c
 create mode 100644 ndctl/lib/ndctl-hpe1.h

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 04f3a63..fdec355 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -31,6 +31,7 @@ endif
 
 if ENABLE_SMART
 lib_libndctl_la_SOURCES += lib/libndctl-smart.c
+lib_libndctl_la_SOURCES += lib/libndctl-hpe1.c
 endif
 
 bin_PROGRAMS = ndctl
diff --git a/ndctl/lib/libndctl-hpe1.c b/ndctl/lib/libndctl-hpe1.c
new file mode 100644
index 0000000..b61acf4
--- /dev/null
+++ b/ndctl/lib/libndctl-hpe1.c
@@ -0,0 +1,303 @@
+/*
+ * Copyright (C) 2016 Hewlett Packard Enterprise Development LP
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
+#include <util/log.h>
+#include <ndctl/libndctl.h>
+#include "libndctl-private.h"
+
+#include "ndctl-hpe1.h"
+
+#define CMD_HPE1(_c) ((struct ndn_pkg_hpe1 *)((_c)->cmd_buf))
+#define CMD_HPE1_SMART(_c) \
+	((struct ndn_hpe1_smart_data *)(CMD_HPE1(_c)->u.smart.data))
+#define CMD_HPE1_SMART_THRESH(_c) \
+	((struct ndn_hpe1_smart_threshold_data *)(CMD_HPE1(_c)->u.thresh.data))
+
+static struct ndctl_cmd *hpe1_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
+{
+	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+	struct ndctl_cmd *cmd;
+	size_t size;
+	struct ndn_pkg_hpe1 *hpe1;
+
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL)) {
+		dbg(ctx, "unsupported cmd\n");
+		return NULL;
+	}
+
+	size = sizeof(*cmd) + sizeof(struct ndn_pkg_hpe1);
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
+	hpe1 = CMD_HPE1(cmd);
+	hpe1->gen.nd_family = NVDIMM_FAMILY_HPE1;
+	hpe1->gen.nd_command = NDN_HPE1_CMD_SMART;
+	hpe1->gen.nd_fw_size = 0;
+	hpe1->gen.nd_size_in = offsetof(struct ndn_hpe1_smart, status);
+	hpe1->gen.nd_size_out = sizeof(hpe1->u.smart);
+	hpe1->u.smart.status = 3;
+
+	hpe1->u.smart.in_valid_flags = 0;
+	hpe1->u.smart.in_valid_flags |= NDN_HPE1_SMART_HEALTH_VALID;
+	hpe1->u.smart.in_valid_flags |= NDN_HPE1_SMART_TEMP_VALID;
+	hpe1->u.smart.in_valid_flags |= NDN_HPE1_SMART_SPARES_VALID;
+	hpe1->u.smart.in_valid_flags |= NDN_HPE1_SMART_ALARM_VALID;
+	hpe1->u.smart.in_valid_flags |= NDN_HPE1_SMART_USED_VALID;
+	hpe1->u.smart.in_valid_flags |= NDN_HPE1_SMART_SHUTDOWN_VALID;
+	hpe1->u.smart.in_valid_flags |= NDN_HPE1_SMART_VENDOR_VALID;
+
+	cmd->firmware_status = &hpe1->u.smart.status;
+
+	return cmd;
+}
+
+static int hpe1_smart_valid(struct ndctl_cmd *cmd)
+{
+	if (cmd->type != ND_CMD_CALL ||
+	    cmd->size != sizeof(*cmd) + sizeof(struct ndn_pkg_hpe1) ||
+	    CMD_HPE1(cmd)->gen.nd_family != NVDIMM_FAMILY_HPE1 ||
+	    CMD_HPE1(cmd)->gen.nd_command != NDN_HPE1_CMD_SMART ||
+	    cmd->status != 0)
+		return cmd->status < 0 ? cmd->status : -EINVAL;
+	return 0;
+}
+
+static unsigned int hpe1_cmd_smart_get_flags(struct ndctl_cmd *cmd)
+{
+	unsigned int hpe1flags;
+	unsigned int flags;
+
+	if (hpe1_smart_valid(cmd) < 0)
+		return UINT_MAX;
+
+	hpe1flags = CMD_HPE1_SMART(cmd)->out_valid_flags;
+	flags = 0;
+	if (hpe1flags & NDN_HPE1_SMART_HEALTH_VALID)
+		flags |= ND_SMART_HEALTH_VALID;
+	if (hpe1flags & NDN_HPE1_SMART_TEMP_VALID)
+		flags |= ND_SMART_TEMP_VALID ;
+	if (hpe1flags & NDN_HPE1_SMART_SPARES_VALID)
+		flags |= ND_SMART_SPARES_VALID;
+	if (hpe1flags & NDN_HPE1_SMART_ALARM_VALID)
+		flags |= ND_SMART_ALARM_VALID;
+	if (hpe1flags & NDN_HPE1_SMART_USED_VALID)
+		flags |= ND_SMART_USED_VALID;
+	if (hpe1flags & NDN_HPE1_SMART_SHUTDOWN_VALID)
+		flags |= ND_SMART_SHUTDOWN_VALID;
+	if (hpe1flags & NDN_HPE1_SMART_VENDOR_VALID)
+		flags |= ND_SMART_VENDOR_VALID;
+
+	return flags;
+}
+
+static unsigned int hpe1_cmd_smart_get_health(struct ndctl_cmd *cmd)
+{
+	unsigned char hpe1health;
+	unsigned int health;
+
+	if (hpe1_smart_valid(cmd) < 0)
+		return UINT_MAX;
+
+	hpe1health = CMD_HPE1_SMART(cmd)->stat_summary;
+	health = 0;
+	if (hpe1health & NDN_HPE1_SMART_NONCRIT_HEALTH)
+		health |= ND_SMART_NON_CRITICAL_HEALTH;;
+	if (hpe1health & NDN_HPE1_SMART_CRITICAL_HEALTH)
+		health |= ND_SMART_CRITICAL_HEALTH;
+	if (hpe1health & NDN_HPE1_SMART_FATAL_HEALTH)
+		health |= ND_SMART_FATAL_HEALTH;
+
+	return health;
+}
+
+static unsigned int hpe1_cmd_smart_get_temperature(struct ndctl_cmd *cmd)
+{
+	if (hpe1_smart_valid(cmd) < 0)
+		return UINT_MAX;
+
+	return CMD_HPE1_SMART(cmd)->curr_temp;
+}
+
+static unsigned int hpe1_cmd_smart_get_spares(struct ndctl_cmd *cmd)
+{
+	if (hpe1_smart_valid(cmd) < 0)
+		return UINT_MAX;
+
+	return CMD_HPE1_SMART(cmd)->spare_blocks;
+}
+
+static unsigned int hpe1_cmd_smart_get_alarm_flags(struct ndctl_cmd *cmd)
+{
+	unsigned int hpe1flags;
+	unsigned int flags;
+
+	if (hpe1_smart_valid(cmd) < 0)
+		return UINT_MAX;
+
+	hpe1flags = CMD_HPE1_SMART(cmd)->alarm_trips;
+	flags = 0;
+	if (hpe1flags & NDN_HPE1_SMART_TEMP_TRIP)
+		flags |= ND_SMART_TEMP_TRIP;
+	if (hpe1flags & NDN_HPE1_SMART_SPARE_TRIP)
+		flags |= ND_SMART_SPARE_TRIP;
+
+	return flags;
+}
+
+static unsigned int hpe1_cmd_smart_get_life_used(struct ndctl_cmd *cmd)
+{
+	if (hpe1_smart_valid(cmd) < 0)
+		return UINT_MAX;
+
+	return CMD_HPE1_SMART(cmd)->device_life;
+}
+
+static unsigned int hpe1_cmd_smart_get_shutdown_state(struct ndctl_cmd *cmd)
+{
+	unsigned int shutdown;
+
+	if (hpe1_smart_valid(cmd) < 0)
+		return UINT_MAX;
+
+	shutdown = CMD_HPE1_SMART(cmd)->last_shutdown_stat;
+	if (shutdown == NDN_HPE1_SMART_LASTSAVEGOOD)
+		return 0;
+	else
+		return 1;
+}
+
+static unsigned int hpe1_cmd_smart_get_vendor_size(struct ndctl_cmd *cmd)
+{
+	if (hpe1_smart_valid(cmd) < 0)
+		return UINT_MAX;
+
+	return CMD_HPE1_SMART(cmd)->vndr_spec_data_size;
+}
+
+static unsigned char *hpe1_cmd_smart_get_vendor_data(struct ndctl_cmd *cmd)
+{
+	if (hpe1_smart_valid(cmd) < 0)
+		return NULL;
+
+	return CMD_HPE1_SMART(cmd)->vnd_spec_data;
+}
+
+
+static struct ndctl_cmd *hpe1_dimm_cmd_new_smart_threshold(struct ndctl_dimm *dimm)
+{
+	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+	struct ndctl_cmd *cmd;
+	size_t size;
+	struct ndn_pkg_hpe1 *hpe1;
+
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL)) {
+		dbg(ctx, "unsupported cmd\n");
+		return NULL;
+	}
+
+	size = sizeof(*cmd) + sizeof(struct ndn_pkg_hpe1);
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
+	hpe1 = CMD_HPE1(cmd);
+	hpe1->gen.nd_family = NVDIMM_FAMILY_HPE1;
+	hpe1->gen.nd_command = NDN_HPE1_CMD_SMART_THRESHOLD;
+	hpe1->gen.nd_fw_size = 0;
+	hpe1->gen.nd_size_in = offsetof(struct ndn_hpe1_smart_threshold, status);
+	hpe1->gen.nd_size_out = sizeof(hpe1->u.smart);
+	hpe1->u.thresh.status = 3;
+
+	cmd->firmware_status = &hpe1->u.thresh.status;
+
+	return cmd;
+}
+
+static int hpe1_smart_threshold_valid(struct ndctl_cmd *cmd)
+{
+	if (cmd->type != ND_CMD_CALL ||
+	    cmd->size != sizeof(*cmd) + sizeof(struct ndn_pkg_hpe1) ||
+	    CMD_HPE1(cmd)->gen.nd_family != NVDIMM_FAMILY_HPE1 ||
+	    CMD_HPE1(cmd)->gen.nd_command != NDN_HPE1_CMD_SMART_THRESHOLD ||
+	    cmd->status != 0)
+		return cmd->status < 0 ? cmd->status : -EINVAL;
+	return 0;
+}
+
+static unsigned int hpe1_cmd_smart_threshold_get_alarm_control(struct ndctl_cmd *cmd)
+{
+	unsigned int hpe1flags;
+	unsigned int flags;
+
+	if (hpe1_smart_threshold_valid(cmd) < 0)
+		return UINT_MAX;
+
+	hpe1flags = CMD_HPE1_SMART_THRESH(cmd)->threshold_alarm_ctl;
+	flags = 0;
+	if (hpe1flags & NDN_HPE1_SMART_TEMP_TRIP)
+		flags |= ND_SMART_TEMP_TRIP;
+	if (hpe1flags & NDN_HPE1_SMART_SPARE_TRIP)
+		flags |= ND_SMART_SPARE_TRIP;
+
+	return flags;
+}
+
+static unsigned int hpe1_cmd_smart_threshold_get_temperature(struct ndctl_cmd *cmd)
+{
+	if (hpe1_smart_threshold_valid(cmd) < 0)
+		return UINT_MAX;
+
+	return CMD_HPE1_SMART_THRESH(cmd)->temp_threshold;
+}
+
+static unsigned int hpe1_cmd_smart_threshold_get_spares(struct ndctl_cmd *cmd)
+{
+	if (hpe1_smart_threshold_valid(cmd) < 0)
+		return UINT_MAX;
+
+	return CMD_HPE1_SMART_THRESH(cmd)->spare_block_threshold;
+}
+
+struct ndctl_smart_ops hpe1_smart_ops = {
+	.new_smart = hpe1_dimm_cmd_new_smart,
+	.smart_get_flags = hpe1_cmd_smart_get_flags,
+	.smart_get_health = hpe1_cmd_smart_get_health,
+	.smart_get_temperature = hpe1_cmd_smart_get_temperature,
+	.smart_get_spares = hpe1_cmd_smart_get_spares,
+	.smart_get_alarm_flags = hpe1_cmd_smart_get_alarm_flags,
+	.smart_get_life_used = hpe1_cmd_smart_get_life_used,
+	.smart_get_shutdown_state = hpe1_cmd_smart_get_shutdown_state,
+	.smart_get_vendor_size = hpe1_cmd_smart_get_vendor_size,
+	.smart_get_vendor_data = hpe1_cmd_smart_get_vendor_data,
+	.new_smart_threshold = hpe1_dimm_cmd_new_smart_threshold,
+	.smart_threshold_get_alarm_control = hpe1_cmd_smart_threshold_get_alarm_control,
+	.smart_threshold_get_temperature = hpe1_cmd_smart_threshold_get_temperature,
+	.smart_threshold_get_spares = hpe1_cmd_smart_threshold_get_spares,
+};
diff --git a/ndctl/lib/libndctl-private.h b/ndctl/lib/libndctl-private.h
index 8d2ebfc..52a3c71 100644
--- a/ndctl/lib/libndctl-private.h
+++ b/ndctl/lib/libndctl-private.h
@@ -220,6 +220,7 @@ struct ndctl_smart_ops {
 
 #if HAS_SMART == 1
 struct ndctl_smart_ops intel_smart_ops;
+struct ndctl_smart_ops hpe1_smart_ops;
 #endif
 
 /* internal library helpers for conditionally defined command numbers */
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 1e07520..c4c8cae 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1156,7 +1156,10 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 		goto err_read;
 	dimm->dsm_mask = parse_commands(buf, 1);
 
-	dimm->smart_ops = &intel_smart_ops;
+	if (dimm->dsm_family == NVDIMM_FAMILY_HPE1)
+		dimm->smart_ops = &hpe1_smart_ops;
+	else
+		dimm->smart_ops = &intel_smart_ops;
 
 	dimm->dimm_buf = calloc(1, strlen(dimm_base) + 50);
 	if (!dimm->dimm_buf)
diff --git a/ndctl/lib/ndctl-hpe1.h b/ndctl/lib/ndctl-hpe1.h
new file mode 100644
index 0000000..0d41aab
--- /dev/null
+++ b/ndctl/lib/ndctl-hpe1.h
@@ -0,0 +1,335 @@
+/*
+ * Copyright (C) 2016 Hewlett Packard Enterprise Development LP
+ * Copyright (c) 2014-2015, Intel Corporation.
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
+#ifndef __NDCTL_HPE1_H__
+#define __NDCTL_HPE1_H__
+
+enum {
+	NDN_HPE1_CMD_QUERY = 0,
+
+	/* non-root commands */
+	NDN_HPE1_CMD_SMART = 1,
+	NDN_HPE1_CMD_SMART_THRESHOLD = 2,
+	NDN_HPE1_CMD_GET_CONFIG_SIZE = 4,
+	NDN_HPE1_CMD_GET_CONFIG_DATA = 5,
+	NDN_HPE1_CMD_SET_CONFIG_DATA = 6,
+	NDN_HPE1_CMD_GET_IDENT = 10,
+	NDN_HPE1_CMD_GET_ES_IDENT = 11,
+	NDN_HPE1_CMD_GET_LAST_BACKUP = 12,
+	NDN_HPE1_CMD_SET_LIFE_THRESHOLD = 13,
+	NDN_HPE1_CMD_ERRINJ_QUERY = 18,
+	NDN_HPE1_CMD_ERRINJ_INJECT = 19,
+	NDN_HPE1_CMD_ERRINJ_STATUS = 20,
+};
+
+/* NDN_HPE1_CMD_SMART */
+struct ndn_hpe1_smart {
+	__u32 in_valid_flags;
+	__u32 status;
+	__u8 data[124];
+} __attribute__((packed));
+
+/* ndn_hpe1_smart.in_valid_flags / ndn_hpe1_smart_data.out_valid_flags */
+#define NDN_HPE1_SMART_HEALTH_VALID	(1 << 0)
+#define NDN_HPE1_SMART_TEMP_VALID	(1 << 1)
+#define NDN_HPE1_SMART_SPARES_VALID	(1 << 2)
+#define NDN_HPE1_SMART_ALARM_VALID	(1 << 3)
+#define NDN_HPE1_SMART_USED_VALID	(1 << 4)
+#define NDN_HPE1_SMART_SHUTDOWN_VALID	(1 << 5)
+#define NDN_HPE1_SMART_STATS_VALID	(1 << 6)
+#define NDN_HPE1_SMART_DETAIL_VALID	(1 << 7)
+#define NDN_HPE1_SMART_ENERGY_VALID	(1 << 8)
+#define NDN_HPE1_SMART_VENDOR_VALID	(1 << 9)
+#define NDN_HPE1_SMART_NOTIFIED		(1 << 31)
+
+/* ndn_hpe1_smart_data.stat_summary */
+#define NDN_HPE1_SMART_NONCRIT_HEALTH	(1 << 0)
+#define NDN_HPE1_SMART_CRITICAL_HEALTH	(1 << 1)
+#define NDN_HPE1_SMART_FATAL_HEALTH	(1 << 2)
+
+/* ndn_hpe1_smart_data.alarm_trips */
+#define NDN_HPE1_SMART_TEMP_TRIP	(1 << 0)
+#define NDN_HPE1_SMART_SPARE_TRIP	(1 << 1)
+#define NDN_HPE1_SMART_LIFEWARN_TRIP	(1 << 2)
+#define NDN_HPE1_SMART_LIFEERR_TRIP	(1 << 3)
+#define NDN_HPE1_SMART_ESLIFEWARN_TRIP	(1 << 4)
+#define NDN_HPE1_SMART_ESLIFEERR_TRIP	(1 << 5)
+#define NDN_HPE1_SMART_ESTEMPWARN_TRIP	(1 << 6)
+#define NDN_HPE1_SMART_ESTEMPERR_TRIP	(1 << 7)
+
+/* ndn_hpe1_smart_data.last_shutdown_stat */
+#define NDN_HPE1_SMART_LASTSAVEGOOD	(1 << 1)
+
+/* ndn_hpe1_smart_data.mod_hlth_stat */
+#define NDN_HPE1_SMART_ES_FAILURE	(1 << 0)
+#define NDN_HPE1_SMART_CTLR_FAILURE	(1 << 1)
+#define NDN_HPE1_SMART_UE_TRIP		(1 << 2)
+#define NDN_HPE1_SMART_CE_TRIP		(1 << 3)
+#define NDN_HPE1_SMART_SAVE_FAILED	(1 << 4)
+#define NDN_HPE1_SMART_RESTORE_FAILED	(1 << 5)
+#define NDN_HPE1_SMART_ARM_FAILED	(1 << 6)
+#define NDN_HPE1_SMART_ERASE_FAILED	(1 << 7)
+#define NDN_HPE1_SMART_CONFIG_ERROR	(1 << 8)
+#define NDN_HPE1_SMART_FW_ERROR		(1 << 9)
+#define NDN_HPE1_SMART_VENDOR_ERROR	(1 << 10)
+
+struct ndn_hpe1_smart_data {
+	__u32	out_valid_flags;
+	__u8	stat_summary;
+	__u16	curr_temp;
+	__u8	spare_blocks;
+	__u16	alarm_trips;
+	__u8	device_life;
+	__u8	last_shutdown_stat;
+	__u16	last_save_op_dur;
+	__u16	last_restore_op_dur;
+	__u16	last_erase_op_dur;
+	__u16	res1;
+	__u32	save_ops;
+	__u32	restore_ops;
+	__u32	erase_ops;
+	__u32	life_save_ops;
+	__u32	life_restore_ops;
+	__u32	life_erase_ops;
+	__u32	life_mod_pwr_cycles;
+	__u32	mod_hlth_stat;
+	__u32	energy_src_check;
+	__u8	energy_src_life_percent;
+	__u16	energy_src_curr_temp;
+	__u8	res2;
+	__u16	energy_src_total_runtime;
+	__u16	vndr_spec_data_size;
+	__u8	vnd_spec_data[60];
+} __attribute__((packed));
+
+/* NDN_HPE1_CMD_SMART_THRESHOLD */
+struct ndn_hpe1_smart_threshold {
+	__u32 status;
+	__u8 data[32];
+} __attribute__((packed));
+
+struct ndn_hpe1_smart_threshold_data {
+	__u16	threshold_alarm_ctl;
+	__u16	temp_threshold;
+	__u8	spare_block_threshold;
+	__u8	res1[3];
+	__u8	dev_lifewarn_threshold;
+	__u8	dev_lifeerr_threshold;
+	__u8	res2[6];
+	__u8	es_lifewarn_threshold;
+	__u8	es_lifeerr_threshold;
+	__u8	es_tempwarn_threshold;
+	__u8	es_temperr_threshold;
+	__u8	res3[4];
+	__u64	res4;
+} __attribute__((packed));
+
+/* NDN_HPE1_CMD_GET_CONFIG_SIZE */
+struct ndn_hpe1_get_config_size {
+	__u32 status;
+	__u32 config_size;
+	__u32 max_xfer;
+} __attribute__((packed));
+
+/* NDN_HPE1_CMD_GET_CONFIG_DATA */
+struct ndn_hpe1_get_config_data_hdr {
+	__u32 in_offset;
+	__u32 in_length;
+	__u32 status;
+	__u8 out_buf[0];
+} __attribute__((packed));
+
+/* NDN_HPE1_CMD_SET_CONFIG_DATA */
+struct ndn_hpe1_set_config_hdr {
+	__u32 in_offset;
+	__u32 in_length;
+	__u8 in_buf[0];
+} __attribute__((packed));
+
+
+/* ndn_hpe1_get_id.sup_backup_trigger */
+#define NDN_HPE1_BKUP_SUPPORT_CKE	(1 << 0)
+#define NDN_HPE1_BKUP_SUPPORT_EXTERNAL	(1 << 1)
+#define NDN_HPE1_BKUP_SUPPORT_12V	(1 << 2)
+#define NDN_HPE1_BKUP_SUPPORT_I2C	(1 << 3)
+#define NDN_HPE1_BKUP_SUPPORT_SAVEN	(1 << 4)
+
+/* NDN_HPE1_CMD_GET_IDENT */
+struct ndn_hpe1_get_id {
+	__u32	status;
+	__u8	spec_rev;
+	__u8	num_stnd_pages;
+	__u32	hw_rev;
+	__u8	sup_backup_trigger;
+	__u16	max_op_retries;
+	__u8	__res1[3];
+	__u32	backup_op_timeout;
+	__u32	restore_op_timeout;
+	__u32	erase_op_timeout;
+	__u32	arm_op_timeout;
+	__u32	fw_op_timeout;
+	__u32	region_block_size;
+	__u16	min_op_temp;
+	__u16	max_op_temp;
+	__u8	curr_fw_slot;
+	__u8	res2[1];
+	__u16	num_fw_slots;
+	__u8	fw_slot_revision[0];
+} __attribute__((packed));
+
+/* ndn_hpe1_get_energy_src_id.attr */
+#define NDN_HPE1_ES_ATTR_BUILTIN	(1 << 0)
+#define NDN_HPE1_ES_ATTR_TETHERED	(1 << 1)
+#define NDN_HPE1_ES_ATTR_SHARED		(1 << 2)
+
+/* ndn_hpe1_get_energy_src_id.tech */
+#define NDN_HPE1_ES_TECH_UNDEFINED	(1 << 0)
+#define NDN_HPE1_ES_TECH_SUPERCAP	(1 << 1)
+#define NDN_HPE1_ES_TECH_BATTERY	(1 << 2)
+#define NDN_HPE1_ES_TECH_HYBRIDCAP	(1 << 3)
+
+/* NDN_HPE1_CMD_GET_ES_IDENT */
+struct ndn_hpe1_get_energy_src_id {
+	__u32	status;
+	__u8	energy_src_policy;
+	__u8	attr;
+	__u8	tech;
+	__u8	reserved;
+	__u16	hw_rev;
+	__u16	fw_rev;
+	__u32	charge_timeout;
+	__u16	min_op_temp;
+	__u16	max_op_temp;
+} __attribute__((packed));
+
+/* ndn_hpe1_last_backup_info.last_backup_initiation */
+#define NDN_HPE1_LASTBKUP_SAVEN		(1 << 0)
+#define NDN_HPE1_LASTBKUP_EXTERNAL	(1 << 1)
+#define NDN_HPE1_LASTBKUP_CKE		(1 << 2)
+#define NDN_HPE1_LASTBKUP_FW		(1 << 3)
+#define NDN_HPE1_LASTBKUP_RESETN	(1 << 4)
+
+/* ndn_hpe1_last_backup_info.ctlr_backup_stat */
+#define NDN_HPE1_LASTBKUP_GTG		(1 << 0)
+#define NDN_HPE1_LASTBKUP_SDRAM_FAULT	(1 << 1)
+#define NDN_HPE1_LASTBKUP_GEN_FAULT	(1 << 2)
+
+/* NDN_HPE1_CMD_GET_LAST_BACKUP */
+struct ndn_hpe1_get_last_backup {
+	__u32	status;
+	__u32	last_backup_info;
+} __attribute__((packed));
+
+struct ndn_hpe1_last_backup_info {
+	__u8	backup_image;
+	__u8	backup_cmplt_stat;
+	__u8	last_backup_initiation;
+	__u8	ctlr_backup_stat;
+} __attribute__((packed));
+
+
+/* NDN_HPE1_CMD_SET_LIFE_THRESHOLD */
+struct ndn_hpe1_set_lifetime_threshold {
+	__u8	in_nvm_lifetime_warn_threshold;
+	__u32	status;
+} __attribute__((packed));
+
+
+/* ndn_hpe1_inj_err.in_err_typ
+ * ndn_hpe1_get_inj_err_status.err_inj_type
+ * log2(ndn_hpe1_query_err_inj_cap.err_inj_cap)
+ */
+enum {
+	NDN_HPE1_EINJ_DEV_NONCRIT = 1,
+	NDN_HPE1_EINJ_DEV_CRIT = 2,
+	NDN_HPE1_EINJ_DEV_FATAL = 3,
+	NDN_HPE1_EINJ_UE_BACKUP = 4,
+	NDN_HPE1_EINJ_UE_RESTORE = 5,
+	NDN_HPE1_EINJ_UE_ERASE = 6,
+	NDN_HPE1_EINJ_UE_ARM = 7,
+	NDN_HPE1_EINJ_BADBLOCK = 8,
+	NDN_HPE1_EINJ_ES_FAULT = 9,
+	NDN_HPE1_EINJ_ES_LOWCHARGE = 10,
+	NDN_HPE1_EINJ_ES_TEMPWARN = 11,
+	NDN_HPE1_EINJ_ES_TEMPERR = 12,
+	NDN_HPE1_EINJ_ES_LIFEWARN = 13,
+	NDN_HPE1_EINJ_ES_LIFEERR = 14,
+	NDN_HPE1_EINJ_DEV_LIFEWARN = 15,
+	NDN_HPE1_EINJ_DEV_LIFEERR = 16,
+	NDN_HPE1_EINJ_FWUPDATE_ERR = 17,
+	NDN_HPE1_EINJ_CTRL_ERR = 18,
+};
+
+/* ndn_hpe1_inj_err.in_options / ndn_hpe1_get_inj_err_status.err_inj_opt */
+enum {
+	NDN_HPE1_EINJ_OPT_SINGLE = 0,
+	NDN_HPE1_EINJ_OPT_PERSISTENT = 1,
+	NDN_HPE1_EINJ_OPT_CLEAR = 2,
+};
+
+/* ndn_hpe1_get_inj_err_status.err_inj_stat_info */
+enum {
+	NDN_HPE1_EINJ_STAT_NONE = 0,
+	NDN_HPE1_EINJ_STAT_INJECTED = 1,
+	NDN_HPE1_EINJ_STAT_PENDING = 2,
+};
+
+/* NDN_HPE1_CMD_ERRINJ_QUERY */
+struct ndn_hpe1_query_err_inj_cap {
+	__u32	status;
+	__u8	err_inj_cap[32];
+} __attribute__((packed));
+
+
+/* NDN_HPE1_CMD_ERRINJ_INJECT */
+struct ndn_hpe1_inj_err {
+	__u8	in_err_typ;
+	__u8	in_options;
+	__u32	status;
+} __attribute__((packed));
+
+/* NDN_HPE1_CMD_ERRINJ_STATUS */
+struct ndn_hpe1_get_inj_err_status {
+	__u32	status;
+	__u8	err_inj_stat_info;
+	__u8	err_inj_type;
+	__u8	err_inj_opt;
+} __attribute__((packed));
+
+union ndn_hpe1_cmd {
+	__u64					query;
+	struct ndn_hpe1_smart			smart;
+	struct ndn_hpe1_smart_threshold		thresh;
+	struct ndn_hpe1_get_config_size		get_size;
+	struct ndn_hpe1_get_config_data_hdr	get_data;
+	struct ndn_hpe1_get_id			get_id;
+	struct ndn_hpe1_get_energy_src_id	get_energy_src_id;
+	struct ndn_hpe1_get_last_backup		get_last_backup;
+	struct ndn_hpe1_last_backup_info	last_backup_info;
+	struct ndn_hpe1_set_lifetime_threshold	set_life_thresh;
+	struct ndn_hpe1_query_err_inj_cap	err_cap;
+	struct ndn_hpe1_inj_err			inj_err;
+	struct ndn_hpe1_get_inj_err_status	inj_err_stat;
+
+	unsigned char				buf[128];
+};
+
+struct ndn_pkg_hpe1 {
+	struct nd_cmd_pkg gen;
+	union ndn_hpe1_cmd u;
+} __attribute__((packed));
+
+#define NDN_IOCTL_HPE1_PASSTHRU		_IOWR(ND_IOCTL, ND_CMD_CALL, \
+					struct ndn_pkg_hpe1)
+
+#endif /* __NDCTL_HPE1_H__ */
-- 
2.8.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
