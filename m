Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1C916211E3708
 for <linux-nvdimm@lists.01.org>; Tue,  5 Jun 2018 17:00:07 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3] ndctl: refactor validation of the ars_status command
Date: Tue,  5 Jun 2018 17:59:59 -0600
Message-Id: <20180605235959.11974-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The APIs that iterate over the information contained in an ars_atatus
command require a prior, successfully completed ars_status command
struct. We were neglecting to verify that the firmware status too
indicates a success. We were also incorrectly requiring that
ars_status->status be zero, where as a positive status only indicates an
underrun. The underrun is fine as the firmware is not expected to
completely fill the max_ars_out sized buffer.

Refactor this checking to mimic validate_ars_cap() which checks the
firmware status, and fixes the check for the cmd status. Use this for
ndctl_cmd_ars_in_progress as well which had the same (incorrect)
cmd->status check.

Reported-by: Tomasz Rochumski <tomasz.rochumski@intel.com>
Tested-by: Jacek Zloch <jacek.zloch@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/ars.c | 69 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 26 deletions(-)

v3: do cmd validation before dereferencing any of the fields in the
command.

diff --git a/ndctl/lib/ars.c b/ndctl/lib/ars.c
index 1ff6cf7..1e0cfdc 100644
--- a/ndctl/lib/ars.c
+++ b/ndctl/lib/ars.c
@@ -195,24 +195,44 @@ NDCTL_EXPORT unsigned int ndctl_cmd_ars_cap_get_clear_unit(
 	return 0;
 }
 
+static bool __validate_ars_stat(struct ndctl_cmd *ars_stat)
+{
+	/*
+	 * A positive status indicates an underrun, but that is fine since
+	 * the firmware is not expected to completely fill the max_ars_out
+	 * sized buffer.
+	 */
+	if (ars_stat->type != ND_CMD_ARS_STATUS || ars_stat->status < 0)
+		return false;
+	if ((ndctl_cmd_get_firmware_status(ars_stat) & ARS_STATUS_MASK) != 0)
+		return false;
+	return true;
+}
+
+#define validate_ars_stat(ctx, ars_stat) \
+({ \
+	bool __valid = __validate_ars_stat(ars_stat); \
+	if (!__valid) \
+		dbg(ctx, "expected sucessfully completed ars_stat command\n"); \
+	__valid; \
+})
+
 NDCTL_EXPORT int ndctl_cmd_ars_in_progress(struct ndctl_cmd *cmd)
 {
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(cmd_to_bus(cmd));
 
-	if (cmd->type == ND_CMD_ARS_STATUS && cmd->status == 0) {
-		if (cmd->ars_status->status == 1 << 16) {
-			/*
-			 * If in-progress, invalidate the ndctl_cmd, so
-			 * that if we're called again without a fresh
-			 * ars_status command, we fail.
-			 */
-			cmd->status = 1;
-			return 1;
-		}
+	if (!validate_ars_stat(ctx, cmd))
 		return 0;
-	}
 
-	dbg(ctx, "invalid ars_status\n");
+	if (ndctl_cmd_get_firmware_status(cmd) == 1 << 16) {
+		/*
+		 * If in-progress, invalidate the ndctl_cmd, so
+		 * that if we're called again without a fresh
+		 * ars_status command, we fail.
+		 */
+		cmd->status = 1;
+		return 1;
+	}
 	return 0;
 }
 
@@ -220,11 +240,10 @@ NDCTL_EXPORT unsigned int ndctl_cmd_ars_num_records(struct ndctl_cmd *ars_stat)
 {
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(cmd_to_bus(ars_stat));
 
-	if (ars_stat->type == ND_CMD_ARS_STATUS && ars_stat->status == 0)
-		return ars_stat->ars_status->num_records;
+	if (!validate_ars_stat(ctx, ars_stat))
+		return 0;
 
-	dbg(ctx, "invalid ars_status\n");
-	return 0;
+	return ars_stat->ars_status->num_records;
 }
 
 NDCTL_EXPORT unsigned long long ndctl_cmd_ars_get_record_addr(
@@ -232,16 +251,15 @@ NDCTL_EXPORT unsigned long long ndctl_cmd_ars_get_record_addr(
 {
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(cmd_to_bus(ars_stat));
 
+	if (!validate_ars_stat(ctx, ars_stat))
+		return 0;
+
 	if (rec_index >= ars_stat->ars_status->num_records) {
 		dbg(ctx, "invalid record index\n");
 		return 0;
 	}
 
-	if (ars_stat->type == ND_CMD_ARS_STATUS && ars_stat->status == 0)
-		return ars_stat->ars_status->records[rec_index].err_address;
-
-	dbg(ctx, "invalid ars_status\n");
-	return 0;
+	return ars_stat->ars_status->records[rec_index].err_address;
 }
 
 NDCTL_EXPORT unsigned long long ndctl_cmd_ars_get_record_len(
@@ -249,16 +267,15 @@ NDCTL_EXPORT unsigned long long ndctl_cmd_ars_get_record_len(
 {
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(cmd_to_bus(ars_stat));
 
+	if (!validate_ars_stat(ctx, ars_stat))
+		return 0;
+
 	if (rec_index >= ars_stat->ars_status->num_records) {
 		dbg(ctx, "invalid record index\n");
 		return 0;
 	}
 
-	if (ars_stat->type == ND_CMD_ARS_STATUS && ars_stat->status == 0)
-		return ars_stat->ars_status->records[rec_index].length;
-
-	dbg(ctx, "invalid ars_status\n");
-	return 0;
+	return ars_stat->ars_status->records[rec_index].length;
 }
 
 NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_clear_error(
-- 
2.17.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
