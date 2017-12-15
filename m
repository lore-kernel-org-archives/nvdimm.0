Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 042B122119BCA
 for <linux-nvdimm@lists.01.org>; Fri, 15 Dec 2017 15:19:28 -0800 (PST)
Subject: [PATCH v3 2/4] ndctl: add firmware download support functions in
 libndctl
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 15 Dec 2017 16:24:10 -0700
Message-ID: <151338025094.4485.13991359044481053238.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151338007905.4485.4189717376304274611.stgit@djiang5-desk3.ch.intel.com>
References: <151338007905.4485.4189717376304274611.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding the DSM commands from Intel DSM v1.6 to support firmware update
sequence in the libndctl library as additional dimm_ops.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/lib/Makefile.am  |    1 
 ndctl/lib/firmware.c   |  119 ++++++++++++++++++++++
 ndctl/lib/intel.c      |  262 ++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/intel.h      |   77 ++++++++++++++
 ndctl/lib/libndctl.sym |   15 +++
 ndctl/lib/private.h    |   16 +++
 ndctl/libndctl.h       |   36 +++++++
 7 files changed, 526 insertions(+)
 create mode 100644 ndctl/lib/firmware.c

diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
index 5e10fde..e3a12e7 100644
--- a/ndctl/lib/Makefile.am
+++ b/ndctl/lib/Makefile.am
@@ -21,6 +21,7 @@ libndctl_la_SOURCES =\
 	hpe1.c \
 	msft.c \
 	ars.c \
+	firmware.c \
 	libndctl.c
 
 libndctl_la_LIBADD =\
diff --git a/ndctl/lib/firmware.c b/ndctl/lib/firmware.c
new file mode 100644
index 0000000..4e69847
--- /dev/null
+++ b/ndctl/lib/firmware.c
@@ -0,0 +1,119 @@
+/*
+ * Copyright (c) 2017, Intel Corporation.
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
+/*
+ * Define the wrappers around the ndctl_dimm_ops for firmware update:
+ */
+NDCTL_EXPORT struct ndctl_cmd *
+ndctl_dimm_cmd_new_fw_get_info(struct ndctl_dimm *dimm)
+{
+	struct ndctl_dimm_ops *ops = dimm->ops;
+
+	if (ops && ops->new_fw_get_info)
+		return ops->new_fw_get_info(dimm);
+	else
+		return NULL;
+}
+
+NDCTL_EXPORT struct ndctl_cmd *
+ndctl_dimm_cmd_new_fw_start_update(struct ndctl_dimm *dimm)
+{
+	struct ndctl_dimm_ops *ops = dimm->ops;
+
+	if (ops && ops->new_fw_start_update)
+		return ops->new_fw_start_update(dimm);
+	else
+		return NULL;
+}
+
+NDCTL_EXPORT struct ndctl_cmd *
+ndctl_dimm_cmd_new_fw_send(struct ndctl_cmd *start, unsigned int offset,
+		unsigned int len, void *data)
+{
+	struct ndctl_dimm_ops *ops = start->dimm->ops;
+
+	if (ops && ops->new_fw_send)
+		return ops->new_fw_send(start, offset, len, data);
+	else
+		return NULL;
+}
+
+NDCTL_EXPORT struct ndctl_cmd *
+ndctl_dimm_cmd_new_fw_finish(struct ndctl_cmd *start)
+{
+	struct ndctl_dimm_ops *ops = start->dimm->ops;
+
+	if (ops && ops->new_fw_finish)
+		return ops->new_fw_finish(start);
+	else
+		return NULL;
+}
+
+NDCTL_EXPORT struct ndctl_cmd *
+ndctl_dimm_cmd_new_fw_abort(struct ndctl_cmd *start)
+{
+	struct ndctl_dimm_ops *ops = start->dimm->ops;
+
+	if (ops && ops->new_fw_finish)
+		return ops->new_fw_abort(start);
+	else
+		return NULL;
+}
+
+NDCTL_EXPORT struct ndctl_cmd *
+ndctl_dimm_cmd_new_fw_finish_query(struct ndctl_cmd *start)
+{
+	struct ndctl_dimm_ops *ops = start->dimm->ops;
+
+	if (ops && ops->new_fw_finish_query)
+		return ops->new_fw_finish_query(start);
+	else
+		return NULL;
+}
+
+
+#define firmware_cmd_op(op, rettype, defretvalue) \
+NDCTL_EXPORT rettype ndctl_cmd_##op(struct ndctl_cmd *cmd) \
+{ \
+	if (cmd->dimm) { \
+		struct ndctl_dimm_ops *ops = cmd->dimm->ops; \
+		if (ops && ops->op) \
+			return ops->op(cmd); \
+	} \
+	return defretvalue; \
+}
+
+firmware_cmd_op(fw_info_get_storage_size, unsigned int, 0)
+firmware_cmd_op(fw_info_get_max_send_len, unsigned int, 0)
+firmware_cmd_op(fw_info_get_query_interval, unsigned int, 0)
+firmware_cmd_op(fw_info_get_max_query_time, unsigned int, 0)
+firmware_cmd_op(fw_info_get_run_version, unsigned long long, 0)
+firmware_cmd_op(fw_info_get_updated_version, unsigned long long, 0)
+firmware_cmd_op(fw_start_get_context, unsigned int, 0)
+firmware_cmd_op(fw_fquery_get_fw_rev, unsigned long long, 0)
+
+NDCTL_EXPORT enum ND_FW_STATUS
+ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd)
+{
+	struct ndctl_dimm_ops *ops = cmd->dimm->ops;
+
+	if (ops && ops->fw_xlat_firmware_status)
+		return ops->fw_xlat_firmware_status(cmd);
+	else
+		return FW_EUNKNOWN;
+}
diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index b85a682..047b026 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -288,6 +288,11 @@ static const char *intel_cmd_desc(int fn)
 	static const char *descs[] = {
 		[ND_INTEL_SMART] = "smart",
 		[ND_INTEL_SMART_THRESHOLD] = "smart_thresh",
+		[ND_INTEL_FW_GET_INFO] = "firmware_get_info",
+		[ND_INTEL_FW_START_UPDATE] = "firmware_start_update",
+		[ND_INTEL_FW_SEND_DATA] = "firmware_send_data",
+		[ND_INTEL_FW_FINISH_UPDATE] = "firmware_finish_update",
+		[ND_INTEL_FW_FINISH_STATUS_QUERY] = "firmware_finish_query",
 		[ND_INTEL_SMART_SET_THRESHOLD] = "smart_set_thresh",
 	};
 	const char *desc = descs[fn];
@@ -299,6 +304,248 @@ static const char *intel_cmd_desc(int fn)
 	return desc;
 }
 
+static struct ndctl_cmd *intel_dimm_cmd_new_fw_get_info(struct ndctl_dimm *dimm)
+{
+	struct ndctl_cmd *cmd;
+
+	BUILD_ASSERT(sizeof(struct nd_intel_fw_info) == 44);
+
+	cmd = alloc_intel_cmd(dimm, ND_INTEL_FW_GET_INFO,
+			0, sizeof(cmd->intel->info));
+	if (!cmd)
+		return NULL;
+
+	cmd->firmware_status = &cmd->intel->info.status;
+	return cmd;
+}
+
+static int intel_fw_get_info_valid(struct ndctl_cmd *cmd)
+{
+	struct nd_pkg_intel *pkg = cmd->intel;
+
+	if (cmd->type != ND_CMD_CALL || cmd->status != 0
+			|| pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
+			|| pkg->gen.nd_command != ND_INTEL_FW_GET_INFO)
+		return -EINVAL;
+	return 0;
+}
+
+#define intel_fw_info_get_field32(cmd, field) \
+static unsigned int intel_cmd_fw_info_get_##field( \
+			struct ndctl_cmd *cmd) \
+{ \
+	if (intel_fw_get_info_valid(cmd) < 0) \
+		return UINT_MAX; \
+	return cmd->intel->info.field; \
+}
+
+#define intel_fw_info_get_field64(cmd, field) \
+static unsigned long long intel_cmd_fw_info_get_##field( \
+			struct ndctl_cmd *cmd) \
+{ \
+	if (intel_fw_get_info_valid(cmd) < 0) \
+		return ULLONG_MAX; \
+	return cmd->intel->info.field; \
+}
+
+intel_fw_info_get_field32(cmd, storage_size)
+intel_fw_info_get_field32(cmd, max_send_len)
+intel_fw_info_get_field32(cmd, query_interval)
+intel_fw_info_get_field32(cmd, max_query_time);
+intel_fw_info_get_field64(cmd, run_version);
+intel_fw_info_get_field64(cmd, updated_version);
+
+static struct ndctl_cmd *intel_dimm_cmd_new_fw_start(struct ndctl_dimm *dimm)
+{
+	struct ndctl_cmd *cmd;
+
+	BUILD_ASSERT(sizeof(struct nd_intel_fw_start) == 8);
+
+	cmd = alloc_intel_cmd(dimm, ND_INTEL_FW_START_UPDATE,
+			sizeof(cmd->intel->start) - 4, 4);
+	if (!cmd)
+		return NULL;
+
+	cmd->firmware_status = &cmd->intel->start.status;
+	return cmd;
+}
+
+static int intel_fw_start_valid(struct ndctl_cmd *cmd)
+{
+	struct nd_pkg_intel *pkg = cmd->intel;
+
+	if (cmd->type != ND_CMD_CALL || cmd->status != 0
+			|| pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
+			|| pkg->gen.nd_command != ND_INTEL_FW_START_UPDATE)
+		return -EINVAL;
+	return 0;
+}
+
+static unsigned int intel_cmd_fw_start_get_context(struct ndctl_cmd *cmd)
+{
+	if (intel_fw_start_valid(cmd) < 0)
+		return UINT_MAX;
+	return cmd->intel->start.context;
+}
+
+static struct ndctl_cmd *intel_dimm_cmd_new_fw_send(struct ndctl_cmd *start,
+		unsigned int offset, unsigned int len, void *data)
+{
+	struct ndctl_cmd *cmd;
+
+	BUILD_ASSERT(sizeof(struct nd_intel_fw_send_data) == 12);
+
+	cmd = alloc_intel_cmd(start->dimm, ND_INTEL_FW_SEND_DATA,
+		sizeof(cmd->intel->send) + len, 4);
+	if (!cmd)
+		return NULL;
+
+	cmd->intel->send.context = start->intel->start.context;
+	cmd->intel->send.offset = offset;
+	cmd->intel->send.length = len;
+	memcpy(cmd->intel->send.data, data, len);
+	/* the last dword is reserved for status */
+	cmd->firmware_status =
+		(unsigned int *)(&cmd->intel->send.data[0] + len);
+	return cmd;
+}
+
+static struct ndctl_cmd *intel_dimm_cmd_new_fw_finish(struct ndctl_cmd *start)
+{
+	struct ndctl_cmd *cmd;
+
+	BUILD_ASSERT(sizeof(struct nd_intel_fw_finish_update) == 12);
+
+	cmd = alloc_intel_cmd(start->dimm, ND_INTEL_FW_FINISH_UPDATE,
+			offsetof(struct nd_intel_fw_finish_update, status), 4);
+	if (!cmd)
+		return NULL;
+
+	cmd->intel->finish.context = start->intel->start.context;
+	cmd->intel->finish.ctrl_flags = 0;
+	cmd->firmware_status = &cmd->intel->finish.status;
+	return cmd;
+}
+
+static struct ndctl_cmd *intel_dimm_cmd_new_fw_abort(struct ndctl_cmd *start)
+{
+	struct ndctl_cmd *cmd;
+
+	BUILD_ASSERT(sizeof(struct nd_intel_fw_finish_update) == 12);
+
+	cmd = alloc_intel_cmd(start->dimm, ND_INTEL_FW_FINISH_UPDATE,
+			sizeof(cmd->intel->finish) - 4, 4);
+	if (!cmd)
+		return NULL;
+
+	cmd->intel->finish.context = start->intel->start.context;
+	cmd->intel->finish.ctrl_flags = 1;
+	cmd->firmware_status = &cmd->intel->finish.status;
+	return cmd;
+}
+
+static struct ndctl_cmd *
+intel_dimm_cmd_new_fw_finish_query(struct ndctl_cmd *start)
+{
+	struct ndctl_cmd *cmd;
+
+	BUILD_ASSERT(sizeof(struct nd_intel_fw_finish_query) == 16);
+
+	cmd = alloc_intel_cmd(start->dimm, ND_INTEL_FW_FINISH_STATUS_QUERY,
+			4, sizeof(cmd->intel->fquery) - 4);
+	if (!cmd)
+		return NULL;
+
+	cmd->intel->fquery.context = start->intel->start.context;
+	cmd->firmware_status = &cmd->intel->fquery.status;
+	return cmd;
+}
+
+static int intel_fw_fquery_valid(struct ndctl_cmd *cmd)
+{
+	struct nd_pkg_intel *pkg = cmd->intel;
+
+	if (cmd->type != ND_CMD_CALL || cmd->status != 0
+			|| pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
+			|| pkg->gen.nd_command != ND_INTEL_FW_FINISH_STATUS_QUERY)
+		return -EINVAL;
+	return 0;
+}
+
+static unsigned long long
+intel_cmd_fw_fquery_get_fw_rev(struct ndctl_cmd *cmd)
+{
+	if (intel_fw_fquery_valid(cmd) < 0)
+		return ULLONG_MAX;
+	return cmd->intel->fquery.updated_fw_rev;
+}
+
+static enum ND_FW_STATUS
+intel_cmd_fw_xlat_extend_firmware_status(struct ndctl_cmd *cmd,
+		unsigned int status)
+{
+	/*
+	 * Note: the cases commented out are identical to the ones that are
+	 * not. They are there for reference.
+	 */
+	switch (status & ND_INTEL_STATUS_EXTEND_MASK) {
+	case ND_INTEL_STATUS_START_BUSY:
+	/* case ND_INTEL_STATUS_SEND_CTXINVAL: */
+	/* case ND_INTEL_STATUS_FIN_CTXINVAL: */
+	/* case ND_INTEL_STATUS_FQ_CTXINVAL: */
+		if (cmd->intel->gen.nd_command == ND_INTEL_FW_START_UPDATE)
+			return FW_EBUSY;
+		else
+			return FW_EINVAL_CTX;
+	case ND_INTEL_STATUS_FIN_DONE:
+	/* case ND_INTEL_STATUS_FQ_BUSY: */
+		if (cmd->intel->gen.nd_command == ND_INTEL_FW_FINISH_UPDATE)
+			return FW_ALREADY_DONE;
+		else
+			return FW_EBUSY;
+	case ND_INTEL_STATUS_FIN_BAD:
+	/* case ND_INTEL_STATUS_FQ_BAD: */
+		return FW_EBADFW;
+	case ND_INTEL_STATUS_FIN_ABORTED:
+	/* case ND_INTEL_STATUS_FQ_ORDER: */
+		if (cmd->intel->gen.nd_command == ND_INTEL_FW_FINISH_UPDATE)
+			return FW_ABORTED;
+		else
+			return FW_ESEQUENCE;
+	}
+
+	return FW_EUNKNOWN;
+}
+
+static enum ND_FW_STATUS
+intel_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd)
+{
+	unsigned int status = *cmd->firmware_status;
+
+	switch (status & ND_INTEL_STATUS_MASK) {
+	case ND_INTEL_STATUS_SUCCESS:
+		return FW_SUCCESS;
+	case ND_INTEL_STATUS_NOTSUPP:
+		return FW_ENOTSUPP;
+	case ND_INTEL_STATUS_NOTEXIST:
+		return FW_ENOTEXIST;
+	case ND_INTEL_STATUS_INVALPARM:
+		return FW_EINVAL;
+	case ND_INTEL_STATUS_HWERR:
+		return FW_EHWERR;
+	case ND_INTEL_STATUS_RETRY:
+		return FW_ERETRY;
+	case ND_INTEL_STATUS_EXTEND:
+		return intel_cmd_fw_xlat_extend_firmware_status(cmd, status);
+	case ND_INTEL_STATUS_NORES:
+		return FW_ENORES;
+	case ND_INTEL_STATUS_NOTREADY:
+		return FW_ENOTREADY;
+	}
+
+	return FW_EUNKNOWN;
+}
+
 struct ndctl_dimm_ops * const intel_dimm_ops = &(struct ndctl_dimm_ops) {
 	.cmd_desc = intel_cmd_desc,
 	.new_smart = intel_dimm_cmd_new_smart,
@@ -331,4 +578,19 @@ struct ndctl_dimm_ops * const intel_dimm_ops = &(struct ndctl_dimm_ops) {
 	.smart_threshold_set_ctrl_temperature
 		= intel_cmd_smart_threshold_set_ctrl_temperature,
 	.smart_threshold_set_spares = intel_cmd_smart_threshold_set_spares,
+	.new_fw_get_info = intel_dimm_cmd_new_fw_get_info,
+	.fw_info_get_storage_size = intel_cmd_fw_info_get_storage_size,
+	.fw_info_get_max_send_len = intel_cmd_fw_info_get_max_send_len,
+	.fw_info_get_query_interval = intel_cmd_fw_info_get_query_interval,
+	.fw_info_get_max_query_time = intel_cmd_fw_info_get_max_query_time,
+	.fw_info_get_run_version = intel_cmd_fw_info_get_run_version,
+	.fw_info_get_updated_version = intel_cmd_fw_info_get_updated_version,
+	.new_fw_start_update = intel_dimm_cmd_new_fw_start,
+	.fw_start_get_context = intel_cmd_fw_start_get_context,
+	.new_fw_send = intel_dimm_cmd_new_fw_send,
+	.new_fw_finish = intel_dimm_cmd_new_fw_finish,
+	.new_fw_abort = intel_dimm_cmd_new_fw_abort,
+	.new_fw_finish_query = intel_dimm_cmd_new_fw_finish_query,
+	.fw_fquery_get_fw_rev = intel_cmd_fw_fquery_get_fw_rev,
+	.fw_xlat_firmware_status = intel_cmd_fw_xlat_firmware_status,
 };
diff --git a/ndctl/lib/intel.h b/ndctl/lib/intel.h
index 9e63985..ff414a4 100644
--- a/ndctl/lib/intel.h
+++ b/ndctl/lib/intel.h
@@ -5,6 +5,12 @@
 #define __INTEL_H__
 #define ND_INTEL_SMART 1
 #define ND_INTEL_SMART_THRESHOLD 2
+
+#define ND_INTEL_FW_GET_INFO 12
+#define ND_INTEL_FW_START_UPDATE 13
+#define ND_INTEL_FW_SEND_DATA 14
+#define ND_INTEL_FW_FINISH_UPDATE 15
+#define ND_INTEL_FW_FINISH_STATUS_QUERY 16
 #define ND_INTEL_SMART_SET_THRESHOLD 17
 
 #define ND_INTEL_SMART_HEALTH_VALID             (1 << 0)
@@ -71,12 +77,83 @@ struct nd_intel_smart_set_threshold {
 	__u32 status;
 } __attribute__((packed));
 
+struct nd_intel_fw_info {
+	__u32 status;
+	__u32 storage_size;
+	__u32 max_send_len;
+	__u32 query_interval;
+	__u32 max_query_time;
+	__u8 update_cap;
+	__u8 reserved[3];
+	__u32 fis_version;
+	__u64 run_version;
+	__u64 updated_version;
+} __attribute__((packed));
+
+struct nd_intel_fw_start {
+	__u32 status;
+	__u32 context;
+} __attribute__((packed));
+
+/* this one has the output first because the variable input data size */
+struct nd_intel_fw_send_data {
+	__u32 context;
+	__u32 offset;
+	__u32 length;
+	__u8 data[0];
+/* reserving last 4 bytes as status */
+/*	__u32 status; */
+} __attribute__((packed));
+
+struct nd_intel_fw_finish_update {
+	__u8 ctrl_flags;
+	__u8 reserved[3];
+	__u32 context;
+	__u32 status;
+} __attribute__((packed));
+
+struct nd_intel_fw_finish_query {
+	__u32 context;
+	__u32 status;
+	__u64 updated_fw_rev;
+} __attribute__((packed));
+
 struct nd_pkg_intel {
 	struct nd_cmd_pkg gen;
 	union {
 		struct nd_intel_smart smart;
 		struct nd_intel_smart_threshold	thresh;
 		struct nd_intel_smart_set_threshold set_thresh;
+		struct nd_intel_fw_info info;
+		struct nd_intel_fw_start start;
+		struct nd_intel_fw_send_data send;
+		struct nd_intel_fw_finish_update finish;
+		struct nd_intel_fw_finish_query fquery;
 	};
 };
+
+#define ND_INTEL_STATUS_MASK		0xffff
+#define ND_INTEL_STATUS_SUCCESS		0
+#define ND_INTEL_STATUS_NOTSUPP		1
+#define ND_INTEL_STATUS_NOTEXIST	2
+#define ND_INTEL_STATUS_INVALPARM	3
+#define ND_INTEL_STATUS_HWERR		4
+#define ND_INTEL_STATUS_RETRY		5
+#define ND_INTEL_STATUS_UNKNOWN		6
+#define ND_INTEL_STATUS_EXTEND		7
+#define ND_INTEL_STATUS_NORES		8
+#define ND_INTEL_STATUS_NOTREADY	9
+
+#define ND_INTEL_STATUS_EXTEND_MASK	0xffff0000
+#define ND_INTEL_STATUS_START_BUSY	0x10000
+#define ND_INTEL_STATUS_SEND_CTXINVAL	0x10000
+#define ND_INTEL_STATUS_FIN_CTXINVAL	0x10000
+#define ND_INTEL_STATUS_FIN_DONE	0x20000
+#define ND_INTEL_STATUS_FIN_BAD		0x30000
+#define ND_INTEL_STATUS_FIN_ABORTED	0x40000
+#define ND_INTEL_STATUS_FQ_CTXINVAL	0x10000
+#define ND_INTEL_STATUS_FQ_BUSY		0x20000
+#define ND_INTEL_STATUS_FQ_BAD		0x30000
+#define ND_INTEL_STATUS_FQ_ORDER	0x40000
+
 #endif /* __INTEL_H__ */
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 2ace942..d35d3fd 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -322,4 +322,19 @@ global:
 	ndctl_cmd_smart_threshold_set_ctrl_temperature;
 	ndctl_cmd_smart_threshold_set_spares;
 	ndctl_decode_smart_temperature;
+	ndctl_dimm_cmd_new_fw_get_info;
+	ndctl_dimm_cmd_new_fw_start_update;
+	ndctl_dimm_cmd_new_fw_send;
+	ndctl_dimm_cmd_new_fw_finish;
+	ndctl_dimm_cmd_new_fw_abort;
+	ndctl_dimm_cmd_new_fw_finish_query;
+	ndctl_cmd_fw_info_get_storage_size;
+	ndctl_cmd_fw_info_get_max_send_len;
+	ndctl_cmd_fw_info_get_query_interval;
+	ndctl_cmd_fw_info_get_max_query_time;
+	ndctl_cmd_fw_info_get_run_version;
+	ndctl_cmd_fw_info_get_updated_version;
+	ndctl_cmd_fw_start_get_context;
+	ndctl_cmd_fw_fquery_get_fw_rev;
+	ndctl_cmd_fw_xlat_firmware_status;
 } LIBNDCTL_13;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 6726097..26b56ea 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -303,6 +303,22 @@ struct ndctl_dimm_ops {
 	int (*smart_threshold_set_media_temperature)(struct ndctl_cmd *, unsigned int);
 	int (*smart_threshold_set_ctrl_temperature)(struct ndctl_cmd *, unsigned int);
 	int (*smart_threshold_set_spares)(struct ndctl_cmd *, unsigned int);
+	struct ndctl_cmd *(*new_fw_get_info)(struct ndctl_dimm *);
+	unsigned int (*fw_info_get_storage_size)(struct ndctl_cmd *);
+	unsigned int (*fw_info_get_max_send_len)(struct ndctl_cmd *);
+	unsigned int (*fw_info_get_query_interval)(struct ndctl_cmd *);
+	unsigned int (*fw_info_get_max_query_time)(struct ndctl_cmd *);
+	unsigned long long (*fw_info_get_run_version)(struct ndctl_cmd *);
+	unsigned long long (*fw_info_get_updated_version)(struct ndctl_cmd *);
+	struct ndctl_cmd *(*new_fw_start_update)(struct ndctl_dimm *);
+	unsigned int (*fw_start_get_context)(struct ndctl_cmd *);
+	struct ndctl_cmd *(*new_fw_send)(struct ndctl_cmd *,
+			unsigned int, unsigned int, void *);
+	struct ndctl_cmd *(*new_fw_finish)(struct ndctl_cmd *);
+	struct ndctl_cmd *(*new_fw_abort)(struct ndctl_cmd *);
+	struct ndctl_cmd *(*new_fw_finish_query)(struct ndctl_cmd *);
+	unsigned long long (*fw_fquery_get_fw_rev)(struct ndctl_cmd *);
+	enum ND_FW_STATUS (*fw_xlat_firmware_status)(struct ndctl_cmd *);
 };
 
 struct ndctl_dimm_ops * const intel_dimm_ops;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index e9da20e..c02e8c7 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -15,6 +15,7 @@
 
 #include <stdbool.h>
 #include <stdarg.h>
+#include <stdint.h>
 #include <unistd.h>
 #include <errno.h>
 
@@ -581,6 +582,41 @@ int ndctl_dax_delete(struct ndctl_dax *dax);
 int ndctl_dax_is_configured(struct ndctl_dax *dax);
 struct daxctl_region *ndctl_dax_get_daxctl_region(struct ndctl_dax *dax);
 
+enum ND_FW_STATUS {
+	FW_SUCCESS = 0,		/* success */
+	FW_ENOTSUPP,		/* not supported */
+	FW_ENOTEXIST,		/* device not exist */
+	FW_EINVAL,		/* invalid input */
+	FW_EHWERR,		/* hardware error */
+	FW_ERETRY,		/* try again */
+	FW_EUNKNOWN,		/* unknown reason */
+	FW_ENORES,		/* out of resource */
+	FW_ENOTREADY,		/* hardware not ready */
+	FW_EBUSY,		/* firmware inprogress */
+	FW_EINVAL_CTX,		/* invalid context passed in */
+	FW_ALREADY_DONE,	/* firmware already updated */
+	FW_EBADFW,		/* firmware failed verification */
+	FW_ABORTED,		/* update sequence aborted success */
+	FW_ESEQUENCE,		/* update sequence incorrect */
+};
+
+struct ndctl_cmd *ndctl_dimm_cmd_new_fw_get_info(struct ndctl_dimm *dimm);
+struct ndctl_cmd *ndctl_dimm_cmd_new_fw_start_update(struct ndctl_dimm *dimm);
+struct ndctl_cmd *ndctl_dimm_cmd_new_fw_send(struct ndctl_cmd *start,
+		unsigned int offset, unsigned int len, void *data);
+struct ndctl_cmd *ndctl_dimm_cmd_new_fw_finish(struct ndctl_cmd *start);
+struct ndctl_cmd *ndctl_dimm_cmd_new_fw_abort(struct ndctl_cmd *start);
+struct ndctl_cmd *ndctl_dimm_cmd_new_fw_finish_query(struct ndctl_cmd *start);
+unsigned int ndctl_cmd_fw_info_get_storage_size(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_fw_info_get_max_send_len(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_fw_info_get_query_interval(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_fw_info_get_max_query_time(struct ndctl_cmd *cmd);
+unsigned long long ndctl_cmd_fw_info_get_run_version(struct ndctl_cmd *cmd);
+unsigned long long ndctl_cmd_fw_info_get_updated_version(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_fw_start_get_context(struct ndctl_cmd *cmd);
+unsigned long long ndctl_cmd_fw_fquery_get_fw_rev(struct ndctl_cmd *cmd);
+enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
