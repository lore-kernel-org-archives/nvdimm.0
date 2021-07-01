Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B903D6D13
	for <nvdimm@lists.linux.dev>; Thu,  1 Jul 2021 20:10:27 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="205606911"
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="205606911"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:19 -0700
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="409271345"
Received: from anandvig-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.38.85])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:18 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 09/21] libcxl: add GET_HEALTH_INFO mailbox command and accessors
Date: Thu,  1 Jul 2021 14:09:53 -0600
Message-Id: <20210701201005.3065299-10-vishal.l.verma@intel.com>
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

Add libcxl APIs to create a new GET_HEALTH_INFO mailbox command, the
command output data structure (privately), and accessor APIs to return
the different fields in the health info output.

Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h  | 11 +++++++++
 cxl/lib/libcxl.c   | 61 ++++++++++++++++++++++++++++++++++++++++++++++
 cxl/libcxl.h       |  9 +++++++
 cxl/lib/libcxl.sym |  9 +++++++
 4 files changed, 90 insertions(+)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 3273f21..2232f4c 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -73,6 +73,17 @@ struct cxl_cmd_identify {
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
 static inline int check_kmod(struct kmod_ctx *kmod_ctx)
 {
 	return kmod_ctx ? 0 : -ENXIO;
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 06a6c20..2e33c5e 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -673,6 +673,67 @@ CXL_EXPORT const char *cxl_cmd_get_devname(struct cxl_cmd *cmd)
 	return cxl_memdev_get_devname(cmd->memdev);
 }
 
+#define cmd_get_int(cmd, n, N, field) \
+do { \
+	struct cxl_cmd_##n *c = (void *)cmd->send_cmd->out.payload; \
+	if (cmd->send_cmd->id != CXL_MEM_COMMAND_ID_##N) \
+		return EINVAL; \
+	if (cmd->status < 0) \
+		return cmd->status; \
+	return le32_to_cpu(c->field); \
+} while(0);
+
+CXL_EXPORT struct cxl_cmd *cxl_cmd_new_get_health_info(
+		struct cxl_memdev *memdev)
+{
+	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_GET_HEALTH_INFO);
+}
+
+#define cmd_health_get_int(c, f) \
+do { \
+	cmd_get_int(c, get_health_info, GET_HEALTH_INFO, f); \
+} while (0);
+
+CXL_EXPORT int cxl_cmd_get_health_info_get_health_status(struct cxl_cmd *cmd)
+{
+	cmd_health_get_int(cmd, health_status);
+}
+
+CXL_EXPORT int cxl_cmd_get_health_info_get_media_status(struct cxl_cmd *cmd)
+{
+	cmd_health_get_int(cmd, media_status);
+}
+
+CXL_EXPORT int cxl_cmd_get_health_info_get_ext_status(struct cxl_cmd *cmd)
+{
+	cmd_health_get_int(cmd, ext_status);
+}
+
+CXL_EXPORT int cxl_cmd_get_health_info_get_life_used(struct cxl_cmd *cmd)
+{
+	cmd_health_get_int(cmd, life_used);
+}
+
+CXL_EXPORT int cxl_cmd_get_health_info_get_temperature(struct cxl_cmd *cmd)
+{
+	cmd_health_get_int(cmd, temperature);
+}
+
+CXL_EXPORT int cxl_cmd_get_health_info_get_dirty_shutdowns(struct cxl_cmd *cmd)
+{
+	cmd_health_get_int(cmd, dirty_shutdowns);
+}
+
+CXL_EXPORT int cxl_cmd_get_health_info_get_volatile_errors(struct cxl_cmd *cmd)
+{
+	cmd_health_get_int(cmd, volatile_errors);
+}
+
+CXL_EXPORT int cxl_cmd_get_health_info_get_pmem_errors(struct cxl_cmd *cmd)
+{
+	cmd_health_get_int(cmd, pmem_errors);
+}
+
 CXL_EXPORT struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev)
 {
 	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_IDENTIFY);
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 9ed8c83..56ae4af 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -62,6 +62,15 @@ struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev);
 int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev, int fw_len);
 unsigned long long cxl_cmd_identify_get_partition_align(struct cxl_cmd *cmd);
 unsigned int cxl_cmd_identify_get_lsa_size(struct cxl_cmd *cmd);
+struct cxl_cmd *cxl_cmd_new_get_health_info(struct cxl_memdev *memdev);
+int cxl_cmd_get_health_info_get_health_status(struct cxl_cmd *cmd);
+int cxl_cmd_get_health_info_get_media_status(struct cxl_cmd *cmd);
+int cxl_cmd_get_health_info_get_ext_status(struct cxl_cmd *cmd);
+int cxl_cmd_get_health_info_get_life_used(struct cxl_cmd *cmd);
+int cxl_cmd_get_health_info_get_temperature(struct cxl_cmd *cmd);
+int cxl_cmd_get_health_info_get_dirty_shutdowns(struct cxl_cmd *cmd);
+int cxl_cmd_get_health_info_get_volatile_errors(struct cxl_cmd *cmd);
+int cxl_cmd_get_health_info_get_pmem_errors(struct cxl_cmd *cmd);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index d6aa0b2..e00443d 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -43,4 +43,13 @@ global:
 	cxl_cmd_identify_get_fw_rev;
 	cxl_cmd_identify_get_partition_align;
 	cxl_cmd_identify_get_lsa_size;
+	cxl_cmd_new_get_health_info;
+	cxl_cmd_get_health_info_get_health_status;
+	cxl_cmd_get_health_info_get_media_status;
+	cxl_cmd_get_health_info_get_ext_status;
+	cxl_cmd_get_health_info_get_life_used;
+	cxl_cmd_get_health_info_get_temperature;
+	cxl_cmd_get_health_info_get_dirty_shutdowns;
+	cxl_cmd_get_health_info_get_volatile_errors;
+	cxl_cmd_get_health_info_get_pmem_errors;
 } LIBCXL_2;
-- 
2.31.1

