Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3C2A72096AEFB
 for <linux-nvdimm@lists.01.org>; Fri, 18 May 2018 14:46:10 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: refactor validation of the ars_status command
Date: Fri, 18 May 2018 15:45:59 -0600
Message-Id: <20180518214559.21134-1-vishal.l.verma@intel.com>
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
Cc: tomasz.rochumski@intel.com
List-ID: <linux-nvdimm@lists.01.org>

The APIs that iterate over the information contained in an ars_atatus
command require a prior, successfully completed ars_status command
struct. We were neglecting to verify that the firmware status too
indicates a success. Refactor this checking to mimic validate_ars_cap()
which checks both the command status as well as the formware status.

Reported-by: Tomasz Rochumski <tomasz.rochumski@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/ars.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/ndctl/lib/ars.c b/ndctl/lib/ars.c
index 1ff6cf7..ef30617 100644
--- a/ndctl/lib/ars.c
+++ b/ndctl/lib/ars.c
@@ -216,15 +216,31 @@ NDCTL_EXPORT int ndctl_cmd_ars_in_progress(struct ndctl_cmd *cmd)
 	return 0;
 }
 
+static bool __validate_ars_stat(struct ndctl_cmd *ars_stat)
+{
+	if (ars_stat->type != ND_CMD_ARS_STATUS || ars_stat->status != 0)
+		return false;
+	if ((*ars_stat->firmware_status & ARS_STATUS_MASK) != 0)
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
 NDCTL_EXPORT unsigned int ndctl_cmd_ars_num_records(struct ndctl_cmd *ars_stat)
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
@@ -237,11 +253,10 @@ NDCTL_EXPORT unsigned long long ndctl_cmd_ars_get_record_addr(
 		return 0;
 	}
 
-	if (ars_stat->type == ND_CMD_ARS_STATUS && ars_stat->status == 0)
-		return ars_stat->ars_status->records[rec_index].err_address;
+	if (!validate_ars_stat(ctx, ars_stat))
+		return 0;
 
-	dbg(ctx, "invalid ars_status\n");
-	return 0;
+	return ars_stat->ars_status->records[rec_index].err_address;
 }
 
 NDCTL_EXPORT unsigned long long ndctl_cmd_ars_get_record_len(
@@ -254,11 +269,10 @@ NDCTL_EXPORT unsigned long long ndctl_cmd_ars_get_record_len(
 		return 0;
 	}
 
-	if (ars_stat->type == ND_CMD_ARS_STATUS && ars_stat->status == 0)
-		return ars_stat->ars_status->records[rec_index].length;
+	if (!validate_ars_stat(ctx, ars_stat))
+		return 0;
 
-	dbg(ctx, "invalid ars_status\n");
-	return 0;
+	return ars_stat->ars_status->records[rec_index].length;
 }
 
 NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_clear_error(
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
