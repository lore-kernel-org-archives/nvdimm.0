Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D06021F0DA7B
 for <linux-nvdimm@lists.01.org>; Thu, 15 Feb 2018 14:26:07 -0800 (PST)
Subject: [PATCH v2 1/2] ndctl: add support for acknolwedge shutdown count
 enable
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 15 Feb 2018 15:31:59 -0700
Message-ID: <151873391945.71747.13665559556426100454.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding generic support for Ack Shutdown Count enable and the
Enable Latch System Shutdown Status (Function Index 10) for
DSM v1.6 spec.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 0 files changed

diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index 8daf5d2..c40df95 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -626,6 +626,22 @@ intel_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd)
 	return FW_EUNKNOWN;
 }
 
+static struct ndctl_cmd *
+intel_dimm_cmd_new_lss(struct ndctl_dimm *dimm)
+{
+	struct ndctl_cmd *cmd;
+
+	BUILD_ASSERT(sizeof(struct nd_intel_lss) == 5);
+
+	cmd = alloc_intel_cmd(dimm, ND_INTEL_ENABLE_LSS_STATUS, 1, 4);
+	if (!cmd)
+		return NULL;
+
+	cmd->intel->lss.enable = 1;
+	cmd->firmware_status = &cmd->intel->lss.status;
+	return cmd;
+}
+
 struct ndctl_dimm_ops * const intel_dimm_ops = &(struct ndctl_dimm_ops) {
 	.cmd_desc = intel_cmd_desc,
 	.new_smart = intel_dimm_cmd_new_smart,
@@ -678,4 +694,5 @@ struct ndctl_dimm_ops * const intel_dimm_ops = &(struct ndctl_dimm_ops) {
 	.new_fw_finish_query = intel_dimm_cmd_new_fw_finish_query,
 	.fw_fquery_get_fw_rev = intel_cmd_fw_fquery_get_fw_rev,
 	.fw_xlat_firmware_status = intel_cmd_fw_xlat_firmware_status,
+	.new_ack_shutdown_count = intel_dimm_cmd_new_lss,
 };
diff --git a/ndctl/lib/intel.h b/ndctl/lib/intel.h
index e9627b0..3b01bba 100644
--- a/ndctl/lib/intel.h
+++ b/ndctl/lib/intel.h
@@ -6,6 +6,7 @@
 #define ND_INTEL_SMART 1
 #define ND_INTEL_SMART_THRESHOLD 2
 
+#define ND_INTEL_ENABLE_LSS_STATUS 10
 #define ND_INTEL_FW_GET_INFO 12
 #define ND_INTEL_FW_START_UPDATE 13
 #define ND_INTEL_FW_SEND_DATA 14
@@ -134,6 +135,11 @@ struct nd_intel_fw_finish_query {
 	__u64 updated_fw_rev;
 } __attribute__((packed));
 
+struct nd_intel_lss {
+	__u8 enable;
+	__u32 status;
+} __attribute__((packed));
+
 struct nd_pkg_intel {
 	struct nd_cmd_pkg gen;
 	union {
@@ -146,6 +152,7 @@ struct nd_pkg_intel {
 		struct nd_intel_fw_send_data send;
 		struct nd_intel_fw_finish_update finish;
 		struct nd_intel_fw_finish_query fquery;
+		struct nd_intel_lss lss;
 	};
 };
 
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index e7f9675..25fd0c2 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -343,4 +343,5 @@ global:
 	ndctl_cmd_fw_start_get_context;
 	ndctl_cmd_fw_fquery_get_fw_rev;
 	ndctl_cmd_fw_xlat_firmware_status;
+	ndctl_dimm_cmd_new_ack_shutdown_count;
 } LIBNDCTL_13;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index b9e3c1d..f32d32a 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -324,6 +324,7 @@ struct ndctl_dimm_ops {
 	struct ndctl_cmd *(*new_fw_finish_query)(struct ndctl_cmd *);
 	unsigned long long (*fw_fquery_get_fw_rev)(struct ndctl_cmd *);
 	enum ND_FW_STATUS (*fw_xlat_firmware_status)(struct ndctl_cmd *);
+	struct ndctl_cmd *(*new_ack_shutdown_count)(struct ndctl_dimm *);
 };
 
 struct ndctl_dimm_ops * const intel_dimm_ops;
diff --git a/ndctl/lib/smart.c b/ndctl/lib/smart.c
index 4ab94bb..8bf5d35 100644
--- a/ndctl/lib/smart.c
+++ b/ndctl/lib/smart.c
@@ -155,3 +155,14 @@ NDCTL_EXPORT int ndctl_cmd_##op(struct ndctl_cmd *cmd, bool enable) \
 
 smart_cmd_inject(smart_inject_fatal)
 smart_cmd_inject(smart_inject_unsafe_shutdown)
+
+NDCTL_EXPORT struct ndctl_cmd *
+ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm)
+{
+	struct ndctl_dimm_ops *ops = dimm->ops;
+
+	if (ops && ops->new_ack_shutdown_count)
+		return ops->new_ack_shutdown_count(dimm);
+	else
+		return NULL;
+}
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 6091ff3..0102948 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -624,6 +624,7 @@ unsigned long long ndctl_cmd_fw_info_get_updated_version(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_fw_start_get_context(struct ndctl_cmd *cmd);
 unsigned long long ndctl_cmd_fw_fquery_get_fw_rev(struct ndctl_cmd *cmd);
 enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
+struct ndctl_cmd *ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm);
 
 #ifdef __cplusplus
 } /* extern "C" */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
