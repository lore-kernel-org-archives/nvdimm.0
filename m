Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1782C9A
	for <nvdimm@lists.linux.dev>; Thu,  7 Oct 2021 08:21:58 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="249511713"
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="249511713"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 01:21:55 -0700
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="568555098"
Received: from abishekh-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.239])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 01:21:55 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v4 06/17] libcxl: add support for the 'Identify Device' command
Date: Thu,  7 Oct 2021 02:21:28 -0600
Message-Id: <20211007082139.3088615-7-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007082139.3088615-1-vishal.l.verma@intel.com>
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4490; h=from:subject; bh=CKBDjAWZiWN3N0tdA+H/65v+nloeW1zhaldbio5Dqnw=; b=owGbwMvMwCHGf25diOft7jLG02pJDIlx61hnddz4ebTzCz/LgfiL7IGGBfsWRj9YbH3A9t3rxgu1 OzLaOkpZGMQ4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjARSXZGhtUKxwITJQqtuA3f593+p3 ButsJ13wVtblq3NzO9ZF4o8Yzhr/Cdw7dWPssKmt0nvfyCYpfCX1mWL+UV36+dZE5rfZ72khsA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add APIs to allocate and send an 'Identify Device' command, and
accessors to retrieve some of the fields from the resulting data.

Only add a handful accessor functions; more can be added as the need
arises. The fields added are fw_revision, partition_align, and
lsa_size.

Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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
index ae13795..38fdd89 100644
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
 #include <util/size.h>
@@ -674,6 +677,52 @@ CXL_EXPORT const char *cxl_cmd_get_devname(struct cxl_cmd *cmd)
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
+CXL_EXPORT unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd)
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
index 6e87b80..0f2d5e9 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -58,6 +58,10 @@ void cxl_cmd_unref(struct cxl_cmd *cmd);
 int cxl_cmd_submit(struct cxl_cmd *cmd);
 int cxl_cmd_get_mbox_status(struct cxl_cmd *cmd);
 int cxl_cmd_get_out_size(struct cxl_cmd *cmd);
+struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev);
+int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev, int fw_len);
+unsigned long long cxl_cmd_identify_get_partition_align(struct cxl_cmd *cmd);
+unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 493429c..c083304 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -39,4 +39,8 @@ global:
 	cxl_cmd_submit;
 	cxl_cmd_get_mbox_status;
 	cxl_cmd_get_out_size;
+	cxl_cmd_new_identify;
+	cxl_cmd_identify_get_fw_rev;
+	cxl_cmd_identify_get_partition_align;
+	cxl_cmd_identify_get_label_size;
 } LIBCXL_2;
-- 
2.31.1

