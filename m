Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6FBB42034D8FF
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 12:43:42 -0800 (PST)
Subject: [PATCH v2 3/4] ndctl: add check for update firmware supported
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 22 Feb 2018 13:49:42 -0700
Message-ID: <151933258238.36856.9023500158077113403.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151933257135.36856.6462188364046414070.stgit@djiang5-desk3.ch.intel.com>
References: <151933257135.36856.6462188364046414070.stgit@djiang5-desk3.ch.intel.com>
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

Adding generic and intel support function to allow check if update firmware
is supported by the kernel.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/lib/firmware.c   |   11 +++++++++++
 ndctl/lib/intel.c      |   24 ++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |    1 +
 ndctl/lib/private.h    |    1 +
 ndctl/libndctl.h       |    1 +
 ndctl/update.c         |    7 ++++++-
 6 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/ndctl/lib/firmware.c b/ndctl/lib/firmware.c
index f6deec5..78d753c 100644
--- a/ndctl/lib/firmware.c
+++ b/ndctl/lib/firmware.c
@@ -107,3 +107,14 @@ ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd)
 	else
 		return FW_EUNKNOWN;
 }
+
+NDCTL_EXPORT bool
+ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm)
+{
+	struct ndctl_dimm_ops *ops = dimm->ops;
+
+	if (ops && ops->fw_update_supported)
+		return ops->fw_update_supported(dimm);
+	else
+		return false;
+}
diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index cee5204..7d976c5 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -650,6 +650,29 @@ intel_dimm_cmd_new_lss(struct ndctl_dimm *dimm)
 	return cmd;
 }
 
+static bool intel_dimm_fw_update_supported(struct ndctl_dimm *dimm)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL)) {
+		dbg(ctx, "unsupported cmd: %d\n", ND_CMD_CALL);
+		return false;
+	}
+
+	/*
+	 * We only need to check FW_GET_INFO. If that isn't supported then
+	 * the others aren't either.
+	 */
+	if (test_dimm_dsm(dimm, ND_INTEL_FW_GET_INFO)
+			== DIMM_DSM_UNSUPPORTED) {
+		dbg(ctx, "unsupported function: %d\n",
+				ND_INTEL_FW_GET_INFO);
+		return false;
+	}
+
+	return true;
+}
+
 struct ndctl_dimm_ops * const intel_dimm_ops = &(struct ndctl_dimm_ops) {
 	.cmd_desc = intel_cmd_desc,
 	.new_smart = intel_dimm_cmd_new_smart,
@@ -703,4 +726,5 @@ struct ndctl_dimm_ops * const intel_dimm_ops = &(struct ndctl_dimm_ops) {
 	.fw_fquery_get_fw_rev = intel_cmd_fw_fquery_get_fw_rev,
 	.fw_xlat_firmware_status = intel_cmd_fw_xlat_firmware_status,
 	.new_ack_shutdown_count = intel_dimm_cmd_new_lss,
+	.fw_update_supported = intel_dimm_fw_update_supported,
 };
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index af9b7d5..cc580f9 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -344,4 +344,5 @@ global:
 	ndctl_cmd_fw_fquery_get_fw_rev;
 	ndctl_cmd_fw_xlat_firmware_status;
 	ndctl_dimm_cmd_new_ack_shutdown_count;
+	ndctl_dimm_fw_update_supported;
 } LIBNDCTL_13;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 015eeb2..ae4454c 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -325,6 +325,7 @@ struct ndctl_dimm_ops {
 	unsigned long long (*fw_fquery_get_fw_rev)(struct ndctl_cmd *);
 	enum ND_FW_STATUS (*fw_xlat_firmware_status)(struct ndctl_cmd *);
 	struct ndctl_cmd *(*new_ack_shutdown_count)(struct ndctl_dimm *);
+	bool (*fw_update_supported)(struct ndctl_dimm *);
 };
 
 struct ndctl_dimm_ops * const intel_dimm_ops;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 9db775b..08030d3 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -625,6 +625,7 @@ unsigned int ndctl_cmd_fw_start_get_context(struct ndctl_cmd *cmd);
 unsigned long long ndctl_cmd_fw_fquery_get_fw_rev(struct ndctl_cmd *cmd);
 enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
 struct ndctl_cmd *ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm);
+bool ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/ndctl/update.c b/ndctl/update.c
index 4fb572d..b148b70 100644
--- a/ndctl/update.c
+++ b/ndctl/update.c
@@ -477,6 +477,10 @@ static int get_ndctl_dimm(struct update_context *uctx, void *ctx)
 		ndctl_dimm_foreach(bus, dimm) {
 			if (!util_dimm_filter(dimm, uctx->dimm_id))
 				continue;
+			if (!ndctl_dimm_fw_update_supported(dimm)) {
+				error("DIMM firmware update not supported by the kernel.");
+				return -ENOTSUP;
+			}
 			uctx->dimm = dimm;
 			rc = update_firmware(uctx);
 			if (rc < 0) {
@@ -581,7 +585,8 @@ int cmd_update_firmware(int argc, const char **argv, void *ctx)
 
 	rc = get_ndctl_dimm(&uctx, ctx);
 	if (rc < 0) {
-		error("DIMM %s not found", uctx.dimm_id);
+		if (rc == -ENODEV)
+			error("DIMM %s not found", uctx.dimm_id);
 		return rc;
 	}
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
