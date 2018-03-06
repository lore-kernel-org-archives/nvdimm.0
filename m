Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8568A22283504
 for <linux-nvdimm@lists.01.org>; Tue,  6 Mar 2018 15:38:49 -0800 (PST)
Subject: [PATCH v3 1/2] ndctl: add check for update firmware supported
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 06 Mar 2018 16:45:03 -0700
Message-ID: <152037990300.39720.17920182486732406168.stgit@djiang5-desk3.ch.intel.com>
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
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/firmware.c   |   11 +++++++++++
 ndctl/lib/intel.c      |   24 ++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |    1 +
 ndctl/lib/private.h    |    1 +
 ndctl/libndctl.h       |    1 +
 ndctl/update.c         |   13 +++++++++++++
 6 files changed, 51 insertions(+)

diff --git a/ndctl/lib/firmware.c b/ndctl/lib/firmware.c
index f6deec5d..277b5399 100644
--- a/ndctl/lib/firmware.c
+++ b/ndctl/lib/firmware.c
@@ -107,3 +107,14 @@ ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd)
 	else
 		return FW_EUNKNOWN;
 }
+
+NDCTL_EXPORT int
+ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm)
+{
+	struct ndctl_dimm_ops *ops = dimm->ops;
+
+	if (ops && ops->fw_update_supported)
+		return ops->fw_update_supported(dimm);
+	else
+		return -ENOTTY;
+}
diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index cee5204c..a4f0af26 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -650,6 +650,29 @@ intel_dimm_cmd_new_lss(struct ndctl_dimm *dimm)
 	return cmd;
 }
 
+static int intel_dimm_fw_update_supported(struct ndctl_dimm *dimm)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL)) {
+		dbg(ctx, "unsupported cmd: %d\n", ND_CMD_CALL);
+		return -EOPNOTSUPP;
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
+		return -EIO;
+	}
+
+	return 0;
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
index af9b7d54..cc580f9c 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -344,4 +344,5 @@ global:
 	ndctl_cmd_fw_fquery_get_fw_rev;
 	ndctl_cmd_fw_xlat_firmware_status;
 	ndctl_dimm_cmd_new_ack_shutdown_count;
+	ndctl_dimm_fw_update_supported;
 } LIBNDCTL_13;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 015eeb2d..1cad06b7 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -325,6 +325,7 @@ struct ndctl_dimm_ops {
 	unsigned long long (*fw_fquery_get_fw_rev)(struct ndctl_cmd *);
 	enum ND_FW_STATUS (*fw_xlat_firmware_status)(struct ndctl_cmd *);
 	struct ndctl_cmd *(*new_ack_shutdown_count)(struct ndctl_dimm *);
+	int (*fw_update_supported)(struct ndctl_dimm *);
 };
 
 struct ndctl_dimm_ops * const intel_dimm_ops;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 9db775ba..d223ea81 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -625,6 +625,7 @@ unsigned int ndctl_cmd_fw_start_get_context(struct ndctl_cmd *cmd);
 unsigned long long ndctl_cmd_fw_fquery_get_fw_rev(struct ndctl_cmd *cmd);
 enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
 struct ndctl_cmd *ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm);
+int ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/ndctl/update.c b/ndctl/update.c
index 0f0f0d81..b4ae1ddb 100644
--- a/ndctl/update.c
+++ b/ndctl/update.c
@@ -449,11 +449,24 @@ static int get_ndctl_dimm(struct update_context *uctx, void *ctx)
 {
 	struct ndctl_dimm *dimm;
 	struct ndctl_bus *bus;
+	int rc;
 
 	ndctl_bus_foreach(ctx, bus)
 		ndctl_dimm_foreach(bus, dimm) {
 			if (!util_dimm_filter(dimm, uctx->dimm_id))
 				continue;
+			rc = ndctl_dimm_fw_update_supported(dimm);
+			switch (rc) {
+			case -ENOTTY:
+				error("DIMM firmware update not supported by ndctl.");
+				return rc;
+			case -EOPNOTSUPP:
+				error("DIMM firmware update not supported by the kernel");
+				return rc;
+			case -EIO:
+				error("DIMM firmware update not supported by platform firmware.");
+				return rc;
+			}
 			uctx->dimm = dimm;
 			return 0;
 		}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
