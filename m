Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840E32C9C
	for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 20:44:58 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233253831"
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="233253831"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:54 -0800
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="504579066"
Received: from dmamols-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.255.92.53])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:54 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v5 07/16] libcxl: add GET_HEALTH_INFO mailbox command and accessors
Date: Thu, 11 Nov 2021 13:44:27 -0700
Message-Id: <20211111204436.1560365-8-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211111204436.1560365-1-vishal.l.verma@intel.com>
References: <20211111204436.1560365-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=20053; h=from:subject; bh=BLy7E9L2NGpv7PC9/hKFq7q3AK+db2CLAYJNcJv+gy8=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm9DRuVJOzffUjX6bnV8OCBTeR3gdl7+vcvc43oCZnJa/JN +QpPRykLgxgHg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACaipc7wV/jjp5ZvPFcX7PnVd3jmOS 9Do7tqIY2Kb1b/5i9zrboyq4Phf/WDrAmxzWpLFxlOr4idPpMnx+KE6vy/skU8Pzu5GaNTGQA=
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
 cxl/lib/libcxl.c   | 291 +++++++++++++++++++++++++++++++++++++++++++++
 cxl/libcxl.h       |  33 +++++
 util/bitmap.h      |  85 +++++++++++++
 cxl/lib/libcxl.sym |  29 +++++
 5 files changed, 485 insertions(+)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 3273f21..885553a 100644
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
+#define CXL_CMD_HEALTH_INFO_EXT_LIFE_USED_NORMAL			(0)
+#define CXL_CMD_HEALTH_INFO_EXT_LIFE_USED_WARNING			(1)
+#define CXL_CMD_HEALTH_INFO_EXT_LIFE_USED_CRITICAL			(2)
+#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_MASK			GENMASK(3, 2)
+#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_NORMAL			(0)
+#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_WARNING			(1)
+#define CXL_CMD_HEALTH_INFO_EXT_TEMPERATURE_CRITICAL			(2)
+#define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_VOLATILE_MASK			BIT(4)
+#define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_VOLATILE_NORMAL		(0)
+#define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_VOLATILE_WARNING		(1)
+#define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_PERSISTENT_MASK		BIT(5)
+#define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_PERSISTENT_NORMAL		(0)
+#define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_PERSISTENT_WARNING		(1)
+
+#define CXL_CMD_HEALTH_INFO_LIFE_USED_NOT_IMPL				0xff
+#define CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL			0xffff
+
 static inline int check_kmod(struct kmod_ctx *kmod_ctx)
 {
 	return kmod_ctx ? 0 : -ENXIO;
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index ed21670..065824d 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -677,6 +677,297 @@ CXL_EXPORT const char *cxl_cmd_get_devname(struct cxl_cmd *cmd)
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
+	struct cxl_cmd_##n *c =						\
+		(struct cxl_cmd_##n *)cmd->send_cmd->out.payload;	\
+	int rc = cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_##N);	\
+	if (rc)								\
+		return rc;						\
+	return c->field;						\
+} while(0)
+
+#define cmd_get_field_u16(cmd, n, N, field)				\
+do {									\
+	struct cxl_cmd_##n *c =						\
+		(struct cxl_cmd_##n *)cmd->send_cmd->out.payload;	\
+	int rc = cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_##N);	\
+	if (rc)								\
+		return rc;						\
+	return le16_to_cpu(c->field);					\
+} while(0)
+
+
+#define cmd_get_field_u32(cmd, n, N, field)				\
+do {									\
+	struct cxl_cmd_##n *c =						\
+		(struct cxl_cmd_##n *)cmd->send_cmd->out.payload;	\
+	int rc = cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_##N);	\
+	if (rc)								\
+		return rc;						\
+	return le32_to_cpu(c->field);					\
+} while(0)
+
+
+#define cmd_get_field_u8_mask(cmd, n, N, field, mask)			\
+do {									\
+	struct cxl_cmd_##n *c =						\
+		(struct cxl_cmd_##n *)cmd->send_cmd->out.payload;	\
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
+#define cmd_health_check_media_field(cmd, f)					\
+do {										\
+	struct cxl_cmd_get_health_info *c =					\
+		(struct cxl_cmd_get_health_info *)cmd->send_cmd->out.payload;	\
+	int rc = cxl_cmd_validate_status(cmd,					\
+			CXL_MEM_COMMAND_ID_GET_HEALTH_INFO);			\
+	if (rc)									\
+		return rc;							\
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
+#define cmd_health_check_ext_field(cmd, fname, type)				\
+do {										\
+	struct cxl_cmd_get_health_info *c =					\
+		(struct cxl_cmd_get_health_info *)cmd->send_cmd->out.payload;	\
+	int rc = cxl_cmd_validate_status(cmd,					\
+			CXL_MEM_COMMAND_ID_GET_HEALTH_INFO);			\
+	if (rc)									\
+		return rc;							\
+	return (FIELD_GET(fname##_MASK, c->ext_status) ==			\
+		fname##_##type);						\
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
index 0f2d5e9..eae2db8 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -62,6 +62,39 @@ struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev);
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
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/util/bitmap.h b/util/bitmap.h
index 490f3f0..04b3429 100644
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
@@ -30,5 +53,67 @@ unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
 				 unsigned long offset);
 int bitmap_full(const unsigned long *src, unsigned int nbits);
 
+/*
+ * Bitfield access macros
+ * (Copied from Linux's include/linux/bitfield.h)
+ *
+ * FIELD_{GET,PREP} macros take as first parameter shifted mask
+ * from which they extract the base mask and shift amount.
+ * Mask must be a compilation time constant.
+ *
+ * Example:
+ *
+ *  #define REG_FIELD_A  GENMASK(6, 0)
+ *  #define REG_FIELD_B  BIT(7)
+ *  #define REG_FIELD_C  GENMASK(15, 8)
+ *  #define REG_FIELD_D  GENMASK(31, 16)
+ *
+ * Get:
+ *  a = FIELD_GET(REG_FIELD_A, reg);
+ *  b = FIELD_GET(REG_FIELD_B, reg);
+ *
+ * Set:
+ *  reg = FIELD_PREP(REG_FIELD_A, 1) |
+ *	  FIELD_PREP(REG_FIELD_B, 0) |
+ *	  FIELD_PREP(REG_FIELD_C, c) |
+ *	  FIELD_PREP(REG_FIELD_D, 0x40);
+ *
+ * Modify:
+ *  reg &= ~REG_FIELD_C;
+ *  reg |= FIELD_PREP(REG_FIELD_C, c);
+ */
+
+/* Force a compilation error if a constant expression is not a power of 2 */
+#define __BUILD_BUG_ON_NOT_POWER_OF_2(n)	\
+	BUILD_BUG_ON(((n) & ((n) - 1)) != 0)
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
+	BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
+
+#define __bf_shf(x) (__builtin_ffsll(x) - 1)
+
+#define __BF_FIELD_CHECK(_mask, _reg, _val)					\
+	({									\
+		BUILD_BUG_ON(!__builtin_constant_p(_mask));			\
+		BUILD_BUG_ON((_mask) == 0);					\
+		BUILD_BUG_ON(__builtin_constant_p(_val) ?			\
+				 ~((_mask) >> __bf_shf(_mask)) & (_val) : 0);	\
+		BUILD_BUG_ON((_mask) > (typeof(_reg))~0ull);			\
+		__BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +				\
+					      (1ULL << __bf_shf(_mask))); 	\
+	})
+
+/**
+ * FIELD_GET() - extract a bitfield element
+ * @_mask: shifted mask defining the field's length and position
+ * @_reg:  value of entire bitfield
+ *
+ * FIELD_GET() extracts the field specified by @_mask from the
+ * bitfield passed in as @_reg by masking and shifting it down.
+ */
+#define FIELD_GET(_mask, _reg)						\
+	({								\
+		__BF_FIELD_CHECK(_mask, _reg, 0U);			\
+		(typeof(_mask))(((_reg) & (_mask)) >> __bf_shf(_mask));	\
+	})
 
 #endif /* _NDCTL_BITMAP_H_ */
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 1dc45f4..c83bc28 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -33,6 +33,35 @@ global:
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
 local:
         *;
 };
-- 
2.31.1

