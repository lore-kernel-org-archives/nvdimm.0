Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316D36D00
	for <nvdimm@lists.linux.dev>; Thu,  1 Jul 2021 20:10:20 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="205606888"
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="205606888"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:16 -0700
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="409271321"
Received: from anandvig-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.38.85])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:15 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 05/21] libcxl: add support for the 'Identify Device' command
Date: Thu,  1 Jul 2021 14:09:49 -0600
Message-Id: <20210701201005.3065299-6-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210701201005.3065299-1-vishal.l.verma@intel.com>
References: <20210701201005.3065299-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add APIs to allocate and send an 'Identify Device' command, and
accessors to retrieve some of the fields from the resulting data.

Only add a handful accessor functions; more can be added as the need
arises. The fields added are fw_revision, partition_align, and
lsa_size.

Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h  | 19 ++++++++++++++++++
 cxl/lib/libcxl.c   | 49 ++++++++++++++++++++++++++++++++++++++++++++++
 cxl/libcxl.h       |  4 ++++
 cxl/lib/libcxl.sym |  4 ++++
 4 files changed, 76 insertions(+)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 87ca17e..3273f21 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -54,6 +54,25 @@ struct cxl_cmd {
 	int status;
 };
 
+#define CXL_CMD_IDENTIFY_FW_REV_LENGTH 0x10
+
+struct cxl_cmd_identify {
+	char fw_revision[CXL_CMD_IDENTIFY_FW_REV_LENGTH];
+	le64 total_capacity;
+	le64 volatile_capacity;
+	le64 persistent_capacity;
+	le64 partition_align;
+	le16 info_event_log_size;
+	le16 warning_event_log_size;
+	le16 failure_event_log_size;
+	le16 fatal_event_log_size;
+	le32 lsa_size;
+	u8 poison_list_max_mer[3];
+	le16 inject_poison_limit;
+	u8 poison_caps;
+	u8 qos_telemetry_caps;
+} __attribute__((packed));
+
 static inline int check_kmod(struct kmod_ctx *kmod_ctx)
 {
 	return kmod_ctx ? 0 : -ENXIO;
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 3be4f3d..06a6c20 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -13,7 +13,10 @@
 #include <sys/sysmacros.h>
 #include <uuid/uuid.h>
 #include <ccan/list/list.h>
+#include <ccan/endian/endian.h>
+#include <ccan/minmax/minmax.h>
 #include <ccan/array_size/array_size.h>
+#include <ccan/short_types/short_types.h>
 
 #include <util/log.h>
 #include <util/sysfs.h>
@@ -670,6 +673,52 @@ CXL_EXPORT const char *cxl_cmd_get_devname(struct cxl_cmd *cmd)
 	return cxl_memdev_get_devname(cmd->memdev);
 }
 
+CXL_EXPORT struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev)
+{
+	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_IDENTIFY);
+}
+
+CXL_EXPORT int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev,
+		int fw_len)
+{
+	struct cxl_cmd_identify *id = (void *)cmd->send_cmd->out.payload;
+
+	if (cmd->send_cmd->id != CXL_MEM_COMMAND_ID_IDENTIFY)
+		return -EINVAL;
+	if (cmd->status < 0)
+		return cmd->status;
+
+	if (fw_len > 0)
+		memcpy(fw_rev, id->fw_revision,
+			min(fw_len, CXL_CMD_IDENTIFY_FW_REV_LENGTH));
+	return 0;
+}
+
+CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align(
+		struct cxl_cmd *cmd)
+{
+	struct cxl_cmd_identify *id = (void *)cmd->send_cmd->out.payload;
+
+	if (cmd->send_cmd->id != CXL_MEM_COMMAND_ID_IDENTIFY)
+		return -EINVAL;
+	if (cmd->status < 0)
+		return cmd->status;
+
+	return le64_to_cpu(id->partition_align);
+}
+
+CXL_EXPORT unsigned int cxl_cmd_identify_get_lsa_size(struct cxl_cmd *cmd)
+{
+	struct cxl_cmd_identify *id = (void *)cmd->send_cmd->out.payload;
+
+	if (cmd->send_cmd->id != CXL_MEM_COMMAND_ID_IDENTIFY)
+		return -EINVAL;
+	if (cmd->status < 0)
+		return cmd->status;
+
+	return le32_to_cpu(id->lsa_size);
+}
+
 CXL_EXPORT struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev,
 		int opcode)
 {
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 6e87b80..9ed8c83 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -58,6 +58,10 @@ void cxl_cmd_unref(struct cxl_cmd *cmd);
 int cxl_cmd_submit(struct cxl_cmd *cmd);
 int cxl_cmd_get_mbox_status(struct cxl_cmd *cmd);
 int cxl_cmd_get_out_size(struct cxl_cmd *cmd);
+struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev);
+int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev, int fw_len);
+unsigned long long cxl_cmd_identify_get_partition_align(struct cxl_cmd *cmd);
+unsigned int cxl_cmd_identify_get_lsa_size(struct cxl_cmd *cmd);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 493429c..d6aa0b2 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -39,4 +39,8 @@ global:
 	cxl_cmd_submit;
 	cxl_cmd_get_mbox_status;
 	cxl_cmd_get_out_size;
+	cxl_cmd_new_identify;
+	cxl_cmd_identify_get_fw_rev;
+	cxl_cmd_identify_get_partition_align;
+	cxl_cmd_identify_get_lsa_size;
 } LIBCXL_2;
-- 
2.31.1

