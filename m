Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B8A9320352AB8
 for <linux-nvdimm@lists.01.org>; Wed,  6 Dec 2017 14:43:23 -0800 (PST)
Subject: [PATCH v2 3/4] ndctl: add firmware update command option for ndctl
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 06 Dec 2017 15:47:55 -0700
Message-ID: <151260047300.3630.15691857990092270462.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151260039600.3630.12960859289293301854.stgit@djiang5-desk3.ch.intel.com>
References: <151260039600.3630.12960859289293301854.stgit@djiang5-desk3.ch.intel.com>
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

Adding option "update-firmware" to ndctl for update firmware support from
Intel DSM v1.6. ndctl update-firmware takes an option of -f for a firmware
binary and a -d for the DIMM name:
ndctl update-firmware -d nmem0 -f new_firmware.bin

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 0 files changed

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 615baf0..27b2076 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -31,6 +31,7 @@ man1_MANS = \
 	ndctl-destroy-namespace.1 \
 	ndctl-check-namespace.1 \
 	ndctl-inject-error.1 \
+	ndctl-update-firmware.1 \
 	ndctl-list.1
 
 CLEANFILES = $(man1_MANS)
diff --git a/Documentation/ndctl/ndctl-update-firmware.txt b/Documentation/ndctl/ndctl-update-firmware.txt
new file mode 100644
index 0000000..d742302
--- /dev/null
+++ b/Documentation/ndctl/ndctl-update-firmware.txt
@@ -0,0 +1,18 @@
+ndctl-update-firmware(1)
+========================
+
+NAME
+----
+ndctl-update-firmware - provides updating of NVDIMM firmware
+
+SYNOPSIS
+--------
+[verse]
+'ndctl update-firmware' -f <firmware_file> -d <dimm name>
+
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
diff --git a/builtin.h b/builtin.h
index 5e1b7ef..1f423dc 100644
--- a/builtin.h
+++ b/builtin.h
@@ -43,4 +43,5 @@ int cmd_test(int argc, const char **argv, void *ctx);
 #ifdef ENABLE_DESTRUCTIVE
 int cmd_bat(int argc, const char **argv, void *ctx);
 #endif
+int cmd_update_firmware(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 6677607..5cd8678 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -13,7 +13,8 @@ ndctl_SOURCES = ndctl.c \
 		test.c \
 		../util/json.c \
 		util/json-smart.c \
-		inject-error.c
+		inject-error.c \
+		update.c
 
 if ENABLE_DESTRUCTIVE
 ndctl_SOURCES += ../test/blk_namespaces.c \
diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index 3ac4d3b..6d26a6c 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -323,7 +323,7 @@ static int intel_fw_get_info_valid(struct ndctl_cmd *cmd)
 {
 	struct nd_pkg_intel *pkg = cmd->intel;
 
-	if (cmd->type != ND_CMD_CALL || cmd->status != 1
+	if (cmd->type != ND_CMD_CALL || cmd->status != 0
 			|| pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
 			|| pkg->gen.nd_command != ND_INTEL_FW_GET_INFO)
 		return -EINVAL;
@@ -382,7 +382,7 @@ static int intel_fw_start_valid(struct ndctl_cmd *cmd)
 {
 	struct nd_pkg_intel *pkg = cmd->intel;
 
-	if (cmd->type != ND_CMD_CALL || cmd->status != 1
+	if (cmd->type != ND_CMD_CALL || cmd->status != 0
 			|| pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
 			|| pkg->gen.nd_command != ND_INTEL_FW_START_UPDATE)
 		return -EINVAL;
@@ -414,7 +414,7 @@ static struct ndctl_cmd *intel_dimm_cmd_new_fw_send(struct ndctl_dimm *dimm,
 	return cmd;
 }
 
-static int intel_fw_send_valid(struct ndctl_cmd *cmd)
+static int intel_fw_send_set_valid(struct ndctl_cmd *cmd)
 {
 	struct nd_pkg_intel *pkg = cmd->intel;
 
@@ -428,7 +428,7 @@ static int intel_fw_send_valid(struct ndctl_cmd *cmd)
 #define intel_fw_send_set_field(field) \
 static int intel_cmd_fw_send_set_##field(struct ndctl_cmd *cmd, unsigned int val) \
 { \
-	if (intel_fw_send_valid(cmd) < 0) \
+	if (intel_fw_send_set_valid(cmd) < 0) \
 		return -EINVAL; \
 	cmd->intel->send.field = val; \
 	return 0; \
@@ -441,7 +441,7 @@ intel_fw_send_set_field(length)
 static int
 intel_cmd_fw_send_set_data(struct ndctl_cmd *cmd, void *buf, size_t len)
 {
-	if (intel_fw_send_valid(cmd) < 0)
+	if (intel_fw_send_set_valid(cmd) < 0)
 		return -EINVAL;
 
 	memcpy(cmd->intel->send.data, buf, len);
@@ -455,7 +455,7 @@ static struct ndctl_cmd *intel_dimm_cmd_new_fw_finish(struct ndctl_dimm *dimm)
 	BUILD_ASSERT(sizeof(struct nd_intel_fw_finish_update) == 12);
 
 	cmd = alloc_intel_cmd(dimm, ND_INTEL_FW_FINISH_UPDATE,
-			sizeof(cmd->intel->finish) - 4, 4);
+			offsetof(struct nd_intel_fw_finish_update, status), 4);
 	if (!cmd)
 		return NULL;
 
@@ -463,7 +463,7 @@ static struct ndctl_cmd *intel_dimm_cmd_new_fw_finish(struct ndctl_dimm *dimm)
 	return cmd;
 }
 
-static int intel_fw_finish_valid(struct ndctl_cmd *cmd)
+static int intel_fw_finish_set_valid(struct ndctl_cmd *cmd)
 {
 	struct nd_pkg_intel *pkg = cmd->intel;
 
@@ -477,7 +477,7 @@ static int intel_fw_finish_valid(struct ndctl_cmd *cmd)
 static int
 intel_cmd_fw_finish_set_ctrl_flags(struct ndctl_cmd *cmd, unsigned char ctrl)
 {
-	if (intel_fw_finish_valid(cmd) < 0)
+	if (intel_fw_finish_set_valid(cmd) < 0)
 		return -EINVAL;
 	cmd->intel->finish.ctrl_flags = ctrl;
 	return 0;
@@ -486,7 +486,7 @@ intel_cmd_fw_finish_set_ctrl_flags(struct ndctl_cmd *cmd, unsigned char ctrl)
 static int
 intel_cmd_fw_finish_set_context(struct ndctl_cmd *cmd, unsigned int context)
 {
-	if (intel_fw_finish_valid(cmd) < 0)
+	if (intel_fw_finish_set_valid(cmd) < 0)
 		return -EINVAL;
 	cmd->intel->finish.context = context;
 	return 0;
@@ -497,14 +497,14 @@ intel_dimm_cmd_new_fw_finish_query(struct ndctl_dimm *dimm)
 {
 	struct ndctl_cmd *cmd;
 
-	BUILD_ASSERT(sizeof(struct nd_intel_fw_finish_update) == 12);
+	BUILD_ASSERT(sizeof(struct nd_intel_fw_finish_query) == 16);
 
-	cmd = alloc_intel_cmd(dimm, ND_INTEL_FW_FINISH_UPDATE,
+	cmd = alloc_intel_cmd(dimm, ND_INTEL_FW_FINISH_STATUS_QUERY,
 			4, sizeof(cmd->intel->fquery) - 4);
 	if (!cmd)
 		return NULL;
 
-	cmd->firmware_status = &cmd->intel->finish.status;
+	cmd->firmware_status = &cmd->intel->fquery.status;
 	return cmd;
 
 }
@@ -513,9 +513,20 @@ static int intel_fw_fquery_valid(struct ndctl_cmd *cmd)
 {
 	struct nd_pkg_intel *pkg = cmd->intel;
 
+	if (cmd->type != ND_CMD_CALL || cmd->status != 0
+			|| pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
+			|| pkg->gen.nd_command != ND_INTEL_FW_FINISH_STATUS_QUERY)
+		return -EINVAL;
+	return 0;
+}
+
+static int intel_fw_fquery_set_valid(struct ndctl_cmd *cmd)
+{
+	struct nd_pkg_intel *pkg = cmd->intel;
+
 	if (cmd->type != ND_CMD_CALL || cmd->status != 1
 			|| pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
-			|| pkg->gen.nd_command != ND_INTEL_FW_FINISH_UPDATE)
+			|| pkg->gen.nd_command != ND_INTEL_FW_FINISH_STATUS_QUERY)
 		return -EINVAL;
 	return 0;
 }
@@ -523,7 +534,7 @@ static int intel_fw_fquery_valid(struct ndctl_cmd *cmd)
 static int
 intel_cmd_fw_fquery_set_context(struct ndctl_cmd *cmd, unsigned int context)
 {
-	if (intel_fw_fquery_valid(cmd) < 0)
+	if (intel_fw_fquery_set_valid(cmd) < 0)
 		return -EINVAL;
 	cmd->intel->fquery.context = context;
 	return 0;
@@ -531,7 +542,7 @@ intel_cmd_fw_fquery_set_context(struct ndctl_cmd *cmd, unsigned int context)
 
 static unsigned long intel_cmd_fw_fquery_get_fw_rev(struct ndctl_cmd *cmd)
 {
-	if (intel_fw_start_valid(cmd) < 0)
+	if (intel_fw_fquery_valid(cmd) < 0)
 		return -EINVAL;
 	return cmd->intel->fquery.updated_fw_rev;
 }
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 0f748e1..a0e5153 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -84,6 +84,7 @@ static struct cmd_struct commands[] = {
 	{ "init-labels", cmd_init_labels },
 	{ "check-labels", cmd_check_labels },
 	{ "inject-error", cmd_inject_error },
+	{ "update-firmware", cmd_update_firmware },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST
diff --git a/ndctl/update.c b/ndctl/update.c
new file mode 100644
index 0000000..2ac6d21
--- /dev/null
+++ b/ndctl/update.c
@@ -0,0 +1,567 @@
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
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <limits.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <syslog.h>
+#include <time.h>
+#include <sys/time.h>
+
+#include <util/log.h>
+#include <util/size.h>
+#include <util/util.h>
+#include <uuid/uuid.h>
+#include <util/json.h>
+#include <util/filter.h>
+#include <json-c/json.h>
+#include <util/fletcher.h>
+#include <ndctl/libndctl.h>
+#include <ndctl/namespace.h>
+#include <util/parse-options.h>
+#include <ccan/minmax/minmax.h>
+#include <ccan/array_size/array_size.h>
+#ifdef HAVE_NDCTL_H
+#include <linux/ndctl.h>
+#else
+#include <ndctl.h>
+#endif
+
+#include <libndctl-nfit.h>
+#include "private.h"
+#include <builtin.h>
+#include <test.h>
+
+#define ND_CMD_STATUS_SUCCESS	0
+#define ND_CMD_STATUS_NOTSUPP	1
+#define	ND_CMD_STATUS_NOTEXIST	2
+#define ND_CMD_STATUS_INVALPARM	3
+#define ND_CMD_STATUS_HWERR	4
+#define ND_CMD_STATUS_RETRY	5
+#define ND_CMD_STATUS_UNKNOWN	6
+#define ND_CMD_STATUS_EXTEND	7
+#define ND_CMD_STATUS_NORES	8
+#define ND_CMD_STATUS_NOTREADY	9
+
+#define ND_CMD_STATUS_START_BUSY	0x10000
+#define ND_CMD_STATUS_SEND_CTXINVAL	0x10000
+#define ND_CMD_STATUS_FIN_CTXINVAL	0x10000
+#define ND_CMD_STATUS_FIN_DONE		0x20000
+#define ND_CMD_STATUS_FIN_BAD		0x30000
+#define ND_CMD_STATUS_FIN_ABORTED	0x40000
+#define ND_CMD_STATUS_FQ_CTXINVAL	0x10000
+#define ND_CMD_STATUS_FQ_BUSY		0x20000
+#define ND_CMD_STATUS_FQ_BAD		0x30000
+#define ND_CMD_STATUS_FQ_ORDER		0x40000
+
+struct fw_info {
+	uint32_t store_size;
+	uint32_t update_size;
+	uint32_t query_interval;
+	uint32_t max_query;
+	uint8_t update_cap;
+	uint32_t fis_version;
+	uint64_t run_version;
+	uint32_t context;
+};
+
+struct update_context {
+	int fw_fd;
+	size_t fw_size;
+	const char *fw_path;
+	const char *dimm_id;
+	struct ndctl_dimm *dimm;
+	struct fw_info dimm_fw;
+};
+
+/*
+ * updating firmware consists of performing the following steps:
+ * 1. Call GET_FIMRWARE_INFO DSM. The return results provide:
+ *	A. Size of the firmware storage area
+ *	B. Max size per send command
+ *	C. Polling interval for check finish status
+ *	D. Max time for finish update poll
+ *	E. Update capabilities
+ *	F. Running FIS version
+ *	G. Running FW revision
+ *	H. Updated FW revision. Only valid after firmware update done.
+ * 2. Call START_FW_UPDATE. The return results provide:
+ *	A. Ready to start status
+ *	B. Valid FW update context
+ * 3. Call SEND_FW_UPDATE_DATA with valid payload
+ *    Repeat until done.
+ * 4. Call FINISH_FW_UPDATE
+ * 5. Poll with QUERY_FINISH_UPDATE success or failure
+ */
+
+static int verify_fw_size(struct update_context *uctx)
+{
+	struct fw_info *fw = &uctx->dimm_fw;
+
+	if (uctx->fw_size > fw->store_size) {
+		error("Firmware file size greater than DIMM store\n");
+		return -E2BIG;
+	}
+
+	return 0;
+}
+
+static int submit_get_firmware_info(struct update_context *uctx)
+{
+	struct ndctl_cmd *cmd;
+	int rc;
+	uint32_t status;
+	struct fw_info *fw = &uctx->dimm_fw;
+
+	cmd = ndctl_dimm_cmd_new_fw_get_info(uctx->dimm);
+	if (!cmd)
+		return -ENXIO;
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc < 0)
+		return rc;
+
+	status = ndctl_cmd_get_firmware_status(cmd);
+	if (status != 0) {
+		error("GET FIRMWARE INFO failed: %#x\n", status);
+		return -ENXIO;
+	}
+
+	fw->store_size = ndctl_cmd_fw_info_get_storage_size(cmd);
+	if (fw->store_size == UINT_MAX)
+		return -ENXIO;
+
+	fw->update_size = ndctl_cmd_fw_info_get_max_send_len(cmd);
+	if (fw->update_size == UINT_MAX)
+		return -ENXIO;
+
+	fw->query_interval = ndctl_cmd_fw_info_get_query_interval(cmd);
+	if (fw->query_interval == UINT_MAX)
+		return -ENXIO;
+
+	fw->max_query = ndctl_cmd_fw_info_get_max_query_time(cmd);
+	if (fw->max_query == UINT_MAX)
+		return -ENXIO;
+
+	fw->update_cap = ndctl_cmd_fw_info_get_update_cap(cmd);
+	if (fw->update_cap == UCHAR_MAX)
+		return -ENXIO;
+
+	fw->fis_version = ndctl_cmd_fw_info_get_fis_version(cmd);
+	if (fw->fis_version == UINT_MAX)
+		return -ENXIO;
+
+	fw->run_version = ndctl_cmd_fw_info_get_run_version(cmd);
+	if (fw->run_version == ULLONG_MAX)
+		return -ENXIO;
+
+	rc = verify_fw_size(uctx);
+	ndctl_cmd_unref(cmd);
+	return rc;
+}
+
+static int submit_start_firmware_upload(struct update_context *uctx)
+{
+	struct ndctl_cmd *cmd;
+	int rc;
+	uint32_t status;
+	struct fw_info *fw = &uctx->dimm_fw;
+
+	cmd = ndctl_dimm_cmd_new_fw_start_update(uctx->dimm);
+	if (!cmd)
+		return -ENXIO;
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc < 0)
+		return rc;
+
+	status = ndctl_cmd_get_firmware_status(cmd);
+	if (status != 0) {
+		error("START FIRMWARE UPDATE failed: %#x\n", status);
+		if (status & ND_CMD_STATUS_EXTEND &&
+				status & ND_CMD_STATUS_START_BUSY)
+			error("Another firmware upload in progress or finished.\n");
+		return -ENXIO;
+	}
+
+	fw->context = ndctl_cmd_fw_start_get_context(cmd);
+	if (fw->context == UINT_MAX)
+		return -ENXIO;
+
+	ndctl_cmd_unref(cmd);
+	return 0;
+}
+
+static int get_fw_data_from_file(int fd, void *buf, uint32_t len,
+		uint32_t offset)
+{
+	ssize_t rc, total = len;
+
+	while (len) {
+		rc = pread(fd, buf, len, offset);
+		if (rc < 0)
+			return -errno;
+		len -= rc;
+	}
+
+	return total;
+}
+
+static int send_firmware(struct update_context *uctx)
+{
+	struct ndctl_cmd *cmd = NULL;
+	ssize_t read;
+	int rc;
+	uint32_t status;
+	struct fw_info *fw = &uctx->dimm_fw;
+	uint32_t copied = 0, len, remain;
+	void *buf;
+
+	buf = malloc(fw->update_size);
+	if (!buf)
+		return -ENOMEM;
+
+	remain = uctx->fw_size;
+
+	while (remain) {
+		len = min(fw->update_size, remain);
+		read = get_fw_data_from_file(uctx->fw_fd, buf, len, copied);
+		if (read < 0) {
+			rc = read;
+			goto cleanup;
+		}
+
+		cmd = ndctl_dimm_cmd_new_fw_send(uctx->dimm, read);
+		if (!cmd) {
+			rc = -ENXIO;
+			goto cleanup;
+		}
+
+		rc = ndctl_cmd_fw_send_set_context(cmd, fw->context);
+		if (rc < 0)
+			goto cleanup;
+
+		rc = ndctl_cmd_fw_send_set_offset(cmd, copied);
+		if (rc < 0)
+			goto cleanup;
+
+		rc = ndctl_cmd_fw_send_set_length(cmd, read);
+		if (rc < 0)
+			goto cleanup;
+
+		rc = ndctl_cmd_fw_send_set_data(cmd, buf, read);
+		if (rc < 0)
+			goto cleanup;
+
+		rc = ndctl_cmd_submit(cmd);
+		if (rc < 0)
+			goto cleanup;
+
+		status = ndctl_cmd_get_firmware_status(cmd);
+		if (status != 0) {
+			error("SEND FIRMWARE failed: %#x\n", status);
+			rc = -ENXIO;
+			goto cleanup;
+		}
+
+		copied += read;
+		remain -= read;
+
+		ndctl_cmd_unref(cmd);
+		cmd = NULL;
+	}
+
+cleanup:
+	if (cmd)
+		ndctl_cmd_unref(cmd);
+	free(buf);
+	return rc;
+}
+
+static int submit_finish_firmware(struct update_context *uctx, int err)
+{
+	struct ndctl_cmd *cmd;
+	int rc;
+	uint32_t status;
+	struct fw_info *fw = &uctx->dimm_fw;
+	int abort;
+
+	abort = err < 0 ? 1 : 0;
+
+	cmd = ndctl_dimm_cmd_new_fw_finish(uctx->dimm);
+	if (!cmd)
+		return -ENXIO;
+
+	rc = ndctl_cmd_fw_finish_set_context(cmd, fw->context);
+	if (rc < 0)
+		goto out;
+
+	rc = ndctl_cmd_fw_finish_set_ctrl_flags(cmd, abort);
+	if (rc < 0)
+		goto out;
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc < 0)
+		goto out;
+
+	status = ndctl_cmd_get_firmware_status(cmd);
+	if (status != 0 && !abort) {
+		error("FINISH FIRMWARE UPDATE failed: %#x\n", status);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	if (abort && !(status & ND_CMD_STATUS_FIN_ABORTED)) {
+		error("FW update abort failed: %#x\n", status);
+		rc = -ENXIO;
+		goto out;
+	}
+
+out:
+	ndctl_cmd_unref(cmd);
+	return rc;
+}
+
+static int query_fw_finish_status(struct update_context *uctx)
+{
+	struct ndctl_cmd *cmd;
+	int rc;
+	uint32_t status;
+	struct fw_info *fw = &uctx->dimm_fw;
+	bool done = false;
+	struct timeval before, after;
+	struct timespec now;
+	uint64_t ver;
+
+	cmd = ndctl_dimm_cmd_new_fw_finish_query(uctx->dimm);
+	if (!cmd)
+		return -ENXIO;
+
+	rc = ndctl_cmd_fw_fquery_set_context(cmd, fw->context);
+	if (rc < 0)
+		goto out;
+
+	rc = gettimeofday(&before, NULL);
+	if (rc < 0)
+		goto out;
+
+	now.tv_nsec = fw->query_interval / 1000;
+	now.tv_sec = 0;
+
+	do {
+		rc = ndctl_cmd_submit(cmd);
+		if (rc < 0)
+			break;
+
+		status = ndctl_cmd_get_firmware_status(cmd);
+		switch (status & 0xffff) {
+		case ND_CMD_STATUS_SUCCESS:
+			ver = ndctl_cmd_fw_fquery_get_fw_rev(cmd);
+			if (ver == 0) {
+				printf("No firmware updated\n");
+				rc = -ENXIO;
+				goto out;
+			}
+
+			printf("Image %s updated successfully to DIMM %s\n",
+					uctx->fw_path, uctx->dimm_id);
+			printf("Firmware version %#lx.\n", ver);
+			printf("Reboot to activate.\n");
+			done = true;
+			rc = 0;
+			break;
+		case ND_CMD_STATUS_EXTEND:
+			/* Check extended status */
+			switch (status & 0xffff0000) {
+			case ND_CMD_STATUS_FQ_BUSY:
+				/* Still on going, continue */
+				rc = gettimeofday(&after, NULL);
+				if (rc < 0) {
+					rc = -errno;
+					goto out;
+				}
+
+				/*
+				 * If we expire max query time,
+				 * we timed out
+				 */
+				if (after.tv_sec - before.tv_sec >
+						fw->max_query / 1000000) {
+					rc = -ETIMEDOUT;
+					goto out;
+				}
+
+				/*
+				 * Sleep the interval dictated by firmware
+				 * before query again.
+				 */
+				rc = nanosleep(&now, NULL);
+				if (rc < 0) {
+					rc = -errno;
+					goto out;
+				}
+				break;
+			case ND_CMD_STATUS_FQ_BAD:
+				printf("Image failed to verify by DIMM\n");
+			case ND_CMD_STATUS_FQ_CTXINVAL:
+			case ND_CMD_STATUS_FQ_ORDER:
+			default:
+				done = true;
+				rc = -ENXIO;
+				goto out;
+			}
+			break;
+		case ND_CMD_STATUS_NORES:
+			printf("Firmware update sequence timed out\n");
+			rc = -ETIMEDOUT;
+			done = true;
+			goto out;
+		default:
+			rc = -EINVAL;
+			done = true;
+			goto out;
+		}
+	} while (!done);
+
+out:
+	ndctl_cmd_unref(cmd);
+	return rc;
+}
+
+static int update_firmware(struct update_context *uctx)
+{
+	int rc;
+
+	rc = submit_get_firmware_info(uctx);
+	if (rc < 0)
+		return rc;
+
+	rc = submit_start_firmware_upload(uctx);
+	if (rc < 0)
+		return rc;
+
+	printf("Uploading %s to DIMM %s\n", uctx->fw_path, uctx->dimm_id);
+
+	rc = send_firmware(uctx);
+	if (rc < 0) {
+		error("Firmware send failed. Aborting...\n");
+		rc = submit_finish_firmware(uctx, 1);
+		if (rc < 0)
+			error("Aborting update sequence failed\n");
+		return rc;
+	}
+
+	rc = submit_finish_firmware(uctx, rc);
+	if (rc < 0) {
+		error("Unable to end update sequence\n");
+		rc = submit_finish_firmware(uctx, 1);
+		if (rc < 0)
+			error("Aborting update sequence failed\n");
+		return rc;
+	}
+
+	rc = query_fw_finish_status(uctx);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
+static int get_ndctl_dimm(struct update_context *uctx, void *ctx)
+{
+	struct ndctl_dimm *dimm;
+	struct ndctl_bus *bus;
+
+	ndctl_bus_foreach(ctx, bus)
+		ndctl_dimm_foreach(bus, dimm) {
+			if (!util_dimm_filter(dimm, uctx->dimm_id))
+				continue;
+			uctx->dimm = dimm;
+			return 0;
+		}
+
+	return -ENODEV;
+}
+
+static int verify_fw_file(struct update_context *uctx)
+{
+	struct stat st;
+
+	if (stat(uctx->fw_path, &st) < 0)
+		return -errno;
+	if (!S_ISREG(st.st_mode))
+		return -EINVAL;
+
+	uctx->fw_size = st.st_size;
+	if (uctx->fw_size == 0)
+		return -EINVAL;
+
+	uctx->fw_fd = open(uctx->fw_path, O_RDONLY);
+	if (uctx->fw_fd < 0)
+		return -errno;
+
+	return 0;
+}
+
+int cmd_update_firmware(int argc, const char **argv, void *ctx)
+{
+	struct update_context uctx = { 0 };
+	const struct option options[] = {
+		OPT_STRING('f', "firmware", &uctx.fw_path,
+				"file-name", "name of firmware"),
+		OPT_STRING('d', "dimm", &uctx.dimm_id, "dimm-id",
+				"dimm to be updated"),
+		OPT_END(),
+	};
+	const char * const u[] = {
+		"ndctl update_firmware [<options>]",
+		NULL
+	};
+	int i, rc;
+
+	argc = parse_options(argc, argv, options, u, 0);
+	for (i = 0; i < argc; i++)
+		error("unknown parameter \"%s\"\n", argv[i]);
+	if (argc)
+		usage_with_options(u, options);
+
+	if (!uctx.fw_path) {
+		error("No firmware file provided\n");
+		usage_with_options(u, options);
+		return -EINVAL;
+	}
+
+	if (!uctx.dimm_id) {
+		error("No DIMM ID provided\n");
+		usage_with_options(u, options);
+		return -EINVAL;
+	}
+
+	rc = verify_fw_file(&uctx);
+	if (rc < 0)
+		return rc;
+
+	rc = get_ndctl_dimm(&uctx, ctx);
+	if (rc < 0)
+		return rc;
+
+	rc = update_firmware(&uctx);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
