Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676E72C9A
	for <nvdimm@lists.linux.dev>; Thu,  7 Oct 2021 08:21:59 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="249511715"
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="249511715"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 01:21:55 -0700
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="568555101"
Received: from abishekh-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.239])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 01:21:55 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v4 07/17] libcxl: add GET_HEALTH_INFO mailbox command and accessors
Date: Thu,  7 Oct 2021 02:21:29 -0600
Message-Id: <20211007082139.3088615-8-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007082139.3088615-1-vishal.l.verma@intel.com>
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=18014; h=from:subject; bh=LpB6Cbux/maw38L5FUCOAaBGO1onuyQ4TjQsYKnR0R0=; b=owGbwMvMwCHGf25diOft7jLG02pJDIlx69j4g0qmf78zZ0Kw98EvK3c4egpq6K3xKIj74l76yb37 WnRXRykLgxgHg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACZykYfhn1LNsbjjndNPLGiKZz955V NoouTro1qWZarOb87fWnzkFC/Dfx8xpVn7FhaKrz672nP+ajGvv1as5w7cP3hmkYG/5Tvml0wA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add libcxl APIs to create a new GET_HEALTH_INFO mailbox command, the
command output data structure (privately), and accessor APIs to return
the different fields in the health info output.

Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h  |  47 ++++++++
 cxl/lib/libcxl.c   | 286 +++++++++++++++++++++++++++++++++++++++++++++
 cxl/libcxl.h       |  38 ++++++
 util/bitmap.h      |  23 ++++
 cxl/lib/libcxl.sym |  31 +++++
 5 files changed, 425 insertions(+)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 3273f21..f76b518 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -73,6 +73,53 @@ struct cxl_cmd_identify {
 	u8 qos_telemetry_caps;
 } __attribute__((packed));
 
+struct cxl_cmd_get_health_info {
+	u8 health_status;
+	u8 media_status;
+	u8 ext_status;
+	u8 life_used;
+	le16 temperature;
+	le32 dirty_shutdowns;
+	le32 volatile_errors;
+	le32 pmem_errors;
+} __attribute__((packed));
+
+/* CXL 2.0 8.2.9.5.3 Byte 0 Health Status */
+#define CXL_CMD_HEALTH_INFO_STATUS_MAINTENANCE_NEEDED_MASK		BIT(0)
+#define CXL_CMD_HEALTH_INFO_STATUS_PERFORMANCE_DEGRADED_MASK		BIT(1)
+#define CXL_CMD_HEALTH_INFO_STATUS_HW_REPLACEMENT_NEEDED_MASK		BIT(2)
+
+/* CXL 2.0 8.2.9.5.3 Byte 1 Media Status */
+#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_NORMAL				0x0
+#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_NOT_READY			0x1
+#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_PERSISTENCE_LOST		0x2
+#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_DATA_LOST			0x3
+#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_POWERLOSS_PERSISTENCE_LOSS	0x4
+#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_SHUTDOWN_PERSISTENCE_LOSS	0x5
+#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_PERSISTENCE_LOSS_IMMINENT	0x6
+#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_POWERLOSS_DATA_LOSS		0x7
+#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_SHUTDOWN_DATA_LOSS		0x8
+#define CXL_CMD_HEALTH_INFO_MEDIA_STATUS_DATA_LOSS_IMMINENT		0x9
+
+/* CXL 2.0 8.2.9.5.3 Byte 2 Additional Status */
+#define CXL_CMD_HEALTH_INFO_EXT_LIFE_USED_MASK				GENMASK(1, 0)
+#define CXL_CMD_HEALTH_INFO_EXT_LIFE_USED_NORMAL			0x0
+#define CXL_CMD_HEALTH_INFO_EXT_LIFE_USED_WARNING			0x1
+#define CXL_CMD_HEALTH_INFO_EXT_LIFE_USED_CRITICAL			0x2
+#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_MASK			GENMASK(3, 2)
+#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_NORMAL			(0x0 << 2)
+#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_WARNING			(0x1 << 2)
+#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_CRITICAL			(0x2 << 2)
+#define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_VOLATILE_MASK			BIT(4)
+#define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_VOLATILE_NORMAL		(0x0 << 4)
+#define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_VOLATILE_WARNING		(0x1 << 4)
+#define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_PERSISTENT_MASK		BIT(5)
+#define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_PERSISTENT_NORMAL		(0x0 << 5)
+#define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_PERSISTENT_WARNING		(0x1 << 5)
+
+#define CXL_CMD_HEALTH_INFO_LIFE_USED_NOT_IMPL				0xff
+#define CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL			0xffff
+
 static inline int check_kmod(struct kmod_ctx *kmod_ctx)
 {
 	return kmod_ctx ? 0 : -ENXIO;
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 38fdd89..413be9c 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -677,6 +677,292 @@ CXL_EXPORT const char *cxl_cmd_get_devname(struct cxl_cmd *cmd)
 	return cxl_memdev_get_devname(cmd->memdev);
 }
 
+static int cxl_cmd_validate_status(struct cxl_cmd *cmd, u32 id)
+{
+	if (cmd->send_cmd->id != id)
+		return -EINVAL;
+	if (cmd->status < 0)
+		return cmd->status;
+	return 0;
+}
+
+/* Helpers for health_info fields (no endian conversion) */
+#define cmd_get_field_u8(cmd, n, N, field)				\
+do {									\
+	struct cxl_cmd_##n *c = (void *)cmd->send_cmd->out.payload;	\
+	int rc = cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_##N);	\
+	if (rc)								\
+		return rc;						\
+	return c->field;						\
+} while(0)
+
+#define cmd_get_field_u16(cmd, n, N, field)				\
+do {									\
+	struct cxl_cmd_##n *c = (void *)cmd->send_cmd->out.payload;	\
+	int rc = cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_##N);	\
+	if (rc)								\
+		return rc;						\
+	return le16_to_cpu(c->field);					\
+} while(0)
+
+
+#define cmd_get_field_u32(cmd, n, N, field)				\
+do {									\
+	struct cxl_cmd_##n *c = (void *)cmd->send_cmd->out.payload;	\
+	int rc = cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_##N);	\
+	if (rc)								\
+		return rc;						\
+	return le32_to_cpu(c->field);					\
+} while(0)
+
+
+#define cmd_get_field_u8_mask(cmd, n, N, field, mask)			\
+do {									\
+	struct cxl_cmd_##n *c = (void *)cmd->send_cmd->out.payload;	\
+	int rc = cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_##N);	\
+	if (rc)								\
+		return rc;						\
+	return !!(c->field & mask);					\
+} while(0)
+
+CXL_EXPORT struct cxl_cmd *cxl_cmd_new_get_health_info(
+		struct cxl_memdev *memdev)
+{
+	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_GET_HEALTH_INFO);
+}
+
+#define cmd_health_get_status_field(c, m)					\
+	cmd_get_field_u8_mask(c, get_health_info, GET_HEALTH_INFO, health_status, m)
+
+CXL_EXPORT int cxl_cmd_health_info_get_maintenance_needed(struct cxl_cmd *cmd)
+{
+	cmd_health_get_status_field(cmd,
+		CXL_CMD_HEALTH_INFO_STATUS_MAINTENANCE_NEEDED_MASK);
+}
+
+CXL_EXPORT int cxl_cmd_health_info_get_performance_degraded(struct cxl_cmd *cmd)
+{
+	cmd_health_get_status_field(cmd,
+		CXL_CMD_HEALTH_INFO_STATUS_PERFORMANCE_DEGRADED_MASK);
+}
+
+CXL_EXPORT int cxl_cmd_health_info_get_hw_replacement_needed(struct cxl_cmd *cmd)
+{
+	cmd_health_get_status_field(cmd,
+		CXL_CMD_HEALTH_INFO_STATUS_HW_REPLACEMENT_NEEDED_MASK);
+}
+
+#define cmd_health_check_media_field(cmd, f)				\
+do {									\
+	struct cxl_cmd_get_health_info *c =				\
+		(void *)cmd->send_cmd->out.payload;			\
+	int rc = cxl_cmd_validate_status(cmd,				\
+			CXL_MEM_COMMAND_ID_GET_HEALTH_INFO);		\
+	if (rc)								\
+		return rc;						\
+	return (c->media_status == f);						\
+} while(0)
+
+CXL_EXPORT int cxl_cmd_health_info_get_media_normal(struct cxl_cmd *cmd)
+{
+	cmd_health_check_media_field(cmd,
+		CXL_CMD_HEALTH_INFO_MEDIA_STATUS_NORMAL);
+}
+
+CXL_EXPORT int cxl_cmd_health_info_get_media_not_ready(struct cxl_cmd *cmd)
+{
+	cmd_health_check_media_field(cmd,
+		CXL_CMD_HEALTH_INFO_MEDIA_STATUS_NOT_READY);
+}
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_media_persistence_lost(struct cxl_cmd *cmd)
+{
+	cmd_health_check_media_field(cmd,
+		CXL_CMD_HEALTH_INFO_MEDIA_STATUS_PERSISTENCE_LOST);
+}
+
+CXL_EXPORT int cxl_cmd_health_info_get_media_data_lost(struct cxl_cmd *cmd)
+{
+	cmd_health_check_media_field(cmd,
+		CXL_CMD_HEALTH_INFO_MEDIA_STATUS_DATA_LOST);
+}
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_media_powerloss_persistence_loss(struct cxl_cmd *cmd)
+{
+	cmd_health_check_media_field(cmd,
+		CXL_CMD_HEALTH_INFO_MEDIA_STATUS_POWERLOSS_PERSISTENCE_LOSS);
+}
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_media_shutdown_persistence_loss(struct cxl_cmd *cmd)
+{
+	cmd_health_check_media_field(cmd,
+		CXL_CMD_HEALTH_INFO_MEDIA_STATUS_SHUTDOWN_PERSISTENCE_LOSS);
+}
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_media_persistence_loss_imminent(struct cxl_cmd *cmd)
+{
+	cmd_health_check_media_field(cmd,
+		CXL_CMD_HEALTH_INFO_MEDIA_STATUS_PERSISTENCE_LOSS_IMMINENT);
+}
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_media_powerloss_data_loss(struct cxl_cmd *cmd)
+{
+	cmd_health_check_media_field(cmd,
+		CXL_CMD_HEALTH_INFO_MEDIA_STATUS_POWERLOSS_DATA_LOSS);
+}
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_media_shutdown_data_loss(struct cxl_cmd *cmd)
+{
+	cmd_health_check_media_field(cmd,
+		CXL_CMD_HEALTH_INFO_MEDIA_STATUS_SHUTDOWN_DATA_LOSS);
+}
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_media_data_loss_imminent(struct cxl_cmd *cmd)
+{
+	cmd_health_check_media_field(cmd,
+		CXL_CMD_HEALTH_INFO_MEDIA_STATUS_DATA_LOSS_IMMINENT);
+}
+
+#define cmd_health_check_ext_field(cmd, fname, type)			\
+do {									\
+	struct cxl_cmd_get_health_info *c =				\
+		(void *)cmd->send_cmd->out.payload;			\
+	int rc = cxl_cmd_validate_status(cmd,				\
+			CXL_MEM_COMMAND_ID_GET_HEALTH_INFO);		\
+	if (rc)								\
+		return rc;						\
+	return ((c->ext_status & fname##_MASK) == fname##_##type);	\
+} while(0)
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_ext_life_used_normal(struct cxl_cmd *cmd)
+{
+	cmd_health_check_ext_field(cmd,
+		CXL_CMD_HEALTH_INFO_EXT_LIFE_USED, NORMAL);
+}
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_ext_life_used_warning(struct cxl_cmd *cmd)
+{
+	cmd_health_check_ext_field(cmd,
+		CXL_CMD_HEALTH_INFO_EXT_LIFE_USED, WARNING);
+}
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_ext_life_used_critical(struct cxl_cmd *cmd)
+{
+	cmd_health_check_ext_field(cmd,
+		CXL_CMD_HEALTH_INFO_EXT_LIFE_USED, CRITICAL);
+}
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_ext_temperature_normal(struct cxl_cmd *cmd)
+{
+	cmd_health_check_ext_field(cmd,
+		CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE, NORMAL);
+}
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_ext_temperature_warning(struct cxl_cmd *cmd)
+{
+	cmd_health_check_ext_field(cmd,
+		CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE, WARNING);
+}
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_ext_temperature_critical(struct cxl_cmd *cmd)
+{
+	cmd_health_check_ext_field(cmd,
+		CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE, CRITICAL);
+}
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_ext_corrected_volatile_normal(struct cxl_cmd *cmd)
+{
+	cmd_health_check_ext_field(cmd,
+		CXL_CMD_HEALTH_INFO_EXT_CORRECTED_VOLATILE, NORMAL);
+}
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_ext_corrected_volatile_warning(struct cxl_cmd *cmd)
+{
+	cmd_health_check_ext_field(cmd,
+		CXL_CMD_HEALTH_INFO_EXT_CORRECTED_VOLATILE, WARNING);
+}
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_ext_corrected_persistent_normal(struct cxl_cmd *cmd)
+{
+	cmd_health_check_ext_field(cmd,
+		CXL_CMD_HEALTH_INFO_EXT_CORRECTED_PERSISTENT, NORMAL);
+}
+
+CXL_EXPORT int
+cxl_cmd_health_info_get_ext_corrected_persistent_warning(struct cxl_cmd *cmd)
+{
+	cmd_health_check_ext_field(cmd,
+		CXL_CMD_HEALTH_INFO_EXT_CORRECTED_PERSISTENT, WARNING);
+}
+
+static int health_info_get_life_used_raw(struct cxl_cmd *cmd)
+{
+	cmd_get_field_u8(cmd, get_health_info, GET_HEALTH_INFO,
+				life_used);
+}
+
+CXL_EXPORT int cxl_cmd_health_info_get_life_used(struct cxl_cmd *cmd)
+{
+	int rc = health_info_get_life_used_raw(cmd);
+
+	if (rc < 0)
+		return rc;
+	if (rc == CXL_CMD_HEALTH_INFO_LIFE_USED_NOT_IMPL)
+		return -EOPNOTSUPP;
+	return rc;
+}
+
+static int health_info_get_temperature_raw(struct cxl_cmd *cmd)
+{
+	cmd_get_field_u16(cmd, get_health_info, GET_HEALTH_INFO,
+				 temperature);
+}
+
+CXL_EXPORT int cxl_cmd_health_info_get_temperature(struct cxl_cmd *cmd)
+{
+	int rc = health_info_get_temperature_raw(cmd);
+
+	if (rc < 0)
+		return rc;
+	if (rc == CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL)
+		return -EOPNOTSUPP;
+	return rc;
+}
+
+CXL_EXPORT int cxl_cmd_health_info_get_dirty_shutdowns(struct cxl_cmd *cmd)
+{
+	cmd_get_field_u32(cmd, get_health_info, GET_HEALTH_INFO,
+				 dirty_shutdowns);
+}
+
+CXL_EXPORT int cxl_cmd_health_info_get_volatile_errors(struct cxl_cmd *cmd)
+{
+	cmd_get_field_u32(cmd, get_health_info, GET_HEALTH_INFO,
+				 volatile_errors);
+}
+
+CXL_EXPORT int cxl_cmd_health_info_get_pmem_errors(struct cxl_cmd *cmd)
+{
+	cmd_get_field_u32(cmd, get_health_info, GET_HEALTH_INFO,
+				 pmem_errors);
+}
+
 CXL_EXPORT struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev)
 {
 	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_IDENTIFY);
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 0f2d5e9..68f5bc2 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -62,6 +62,44 @@ struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev);
 int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev, int fw_len);
 unsigned long long cxl_cmd_identify_get_partition_align(struct cxl_cmd *cmd);
 unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd);
+struct cxl_cmd *cxl_cmd_new_get_health_info(struct cxl_memdev *memdev);
+int cxl_cmd_health_info_get_maintenance_needed(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_performance_degraded(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_hw_replacement_needed(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_media_normal(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_media_not_ready(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_media_persistence_lost(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_media_data_lost(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_media_normal(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_media_not_ready(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_media_persistence_lost(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_media_data_lost(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_media_powerloss_persistence_loss(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_media_shutdown_persistence_loss(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_media_persistence_loss_imminent(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_media_powerloss_data_loss(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_media_shutdown_data_loss(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_media_data_loss_imminent(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_ext_life_used_normal(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_ext_life_used_warning(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_ext_life_used_critical(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_ext_temperature_normal(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_ext_temperature_warning(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_ext_temperature_critical(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_ext_corrected_volatile_normal(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_ext_corrected_volatile_warning(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_ext_corrected_persistent_normal(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_ext_corrected_persistent_warning(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_life_used(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_temperature(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_dirty_shutdowns(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_volatile_errors(struct cxl_cmd *cmd);
+int cxl_cmd_health_info_get_pmem_errors(struct cxl_cmd *cmd);
+struct cxl_cmd *cxl_cmd_new_get_lsa(struct cxl_memdev *memdev,
+		unsigned int offset, unsigned int length);
+void *cxl_cmd_get_lsa_get_payload(struct cxl_cmd *cmd);
+struct cxl_cmd *cxl_cmd_new_set_lsa(struct cxl_memdev *memdev,
+		void *buf, unsigned int offset, unsigned int length);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/util/bitmap.h b/util/bitmap.h
index 490f3f0..d3411ff 100644
--- a/util/bitmap.h
+++ b/util/bitmap.h
@@ -3,10 +3,33 @@
 #ifndef _NDCTL_BITMAP_H_
 #define _NDCTL_BITMAP_H_
 
+#include <linux/const.h>
 #include <util/size.h>
+#include <util/util.h>
 #include <ccan/short_types/short_types.h>
 
+#ifndef _UL
+#define _UL(x)		(_AC(x, UL))
+#endif
+#ifndef _ULL
+#define _ULL(x)		(_AC(x, ULL))
+#endif
+
 #define DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+#define UL(x)		(_UL(x))
+#define ULL(x)		(_ULL(x))
+
+/* GENMASK() and its dependencies copied from include/linux/{bits.h, const.h} */
+#define __is_constexpr(x) \
+	(sizeof(int) == sizeof(*(8 ? ((void *)((long)(x) * 0l)) : (int *)8)))
+#define GENMASK_INPUT_CHECK(h, l) \
+	(BUILD_BUG_ON_ZERO(__builtin_choose_expr( \
+		__is_constexpr((l) > (h)), (l) > (h), 0)))
+#define __GENMASK(h, l) \
+	(((~UL(0)) - (UL(1) << (l)) + 1) & \
+	 (~UL(0) >> (BITS_PER_LONG - 1 - (h))))
+#define GENMASK(h, l) \
+	(GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
 
 #define BIT(nr)			(1UL << (nr))
 #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index c083304..b0a3047 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -43,4 +43,35 @@ global:
 	cxl_cmd_identify_get_fw_rev;
 	cxl_cmd_identify_get_partition_align;
 	cxl_cmd_identify_get_label_size;
+	cxl_cmd_new_get_health_info;
+	cxl_cmd_health_info_get_maintenance_needed;
+	cxl_cmd_health_info_get_performance_degraded;
+	cxl_cmd_health_info_get_hw_replacement_needed;
+	cxl_cmd_health_info_get_media_normal;
+	cxl_cmd_health_info_get_media_not_ready;
+	cxl_cmd_health_info_get_media_persistence_lost;
+	cxl_cmd_health_info_get_media_data_lost;
+	cxl_cmd_health_info_get_media_powerloss_persistence_loss;
+	cxl_cmd_health_info_get_media_shutdown_persistence_loss;
+	cxl_cmd_health_info_get_media_persistence_loss_imminent;
+	cxl_cmd_health_info_get_media_powerloss_data_loss;
+	cxl_cmd_health_info_get_media_shutdown_data_loss;
+	cxl_cmd_health_info_get_media_data_loss_imminent;
+	cxl_cmd_health_info_get_ext_life_used_normal;
+	cxl_cmd_health_info_get_ext_life_used_warning;
+	cxl_cmd_health_info_get_ext_life_used_critical;
+	cxl_cmd_health_info_get_ext_temperature_normal;
+	cxl_cmd_health_info_get_ext_temperature_warning;
+	cxl_cmd_health_info_get_ext_temperature_critical;
+	cxl_cmd_health_info_get_ext_corrected_volatile_normal;
+	cxl_cmd_health_info_get_ext_corrected_volatile_warning;
+	cxl_cmd_health_info_get_ext_corrected_persistent_normal;
+	cxl_cmd_health_info_get_ext_corrected_persistent_warning;
+	cxl_cmd_health_info_get_life_used;
+	cxl_cmd_health_info_get_temperature;
+	cxl_cmd_health_info_get_dirty_shutdowns;
+	cxl_cmd_health_info_get_volatile_errors;
+	cxl_cmd_health_info_get_pmem_errors;
+	cxl_cmd_new_get_lsa;
+	cxl_cmd_get_lsa_get_payload;
 } LIBCXL_2;
-- 
2.31.1

