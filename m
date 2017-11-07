Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2BF8F2034D837
 for <linux-nvdimm@lists.01.org>; Tue,  7 Nov 2017 14:49:17 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] libndctl,
 nfit: Fix in/out sizes for error injection commands
Date: Tue,  7 Nov 2017 15:50:58 -0700
Message-Id: <20171107225058.12805-1-vishal.l.verma@intel.com>
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
Cc: dariusz.dokupil@intel.com
List-ID: <linux-nvdimm@lists.01.org>

The input/output size bounds being set in the various nd_bus_cmd_new_*
helpers for error injection commands were larger than they needed to be,
and platforms could reject these. Fix the bounds to be exactly as the
spec describes.

Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Dariusz Dokupil <dariusz.dokupil@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/nfit.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/ndctl/lib/nfit.c b/ndctl/lib/nfit.c
index fb6af32..6346fd9 100644
--- a/ndctl/lib/nfit.c
+++ b/ndctl/lib/nfit.c
@@ -164,9 +164,9 @@ struct ndctl_cmd *ndctl_bus_cmd_new_err_inj(struct ndctl_bus *bus)
 	cmd->status = 1;
 	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
 	pkg->nd_command = NFIT_CMD_ARS_INJECT_SET;
-	pkg->nd_size_in = (2 * sizeof(u64)) + sizeof(u32);
-	pkg->nd_size_out = cmd_length;
-	pkg->nd_fw_size = cmd_length;
+	pkg->nd_size_in = (2 * sizeof(u64)) + sizeof(u8);
+	pkg->nd_size_out = sizeof(u32);
+	pkg->nd_fw_size = sizeof(u32);
 	err_inj = (struct nd_cmd_ars_err_inj *)&pkg->nd_payload[0];
 	cmd->firmware_status = &err_inj->status;
 
@@ -194,8 +194,8 @@ struct ndctl_cmd *ndctl_bus_cmd_new_err_inj_clr(struct ndctl_bus *bus)
 	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
 	pkg->nd_command = NFIT_CMD_ARS_INJECT_CLEAR;
 	pkg->nd_size_in = 2 * sizeof(u64);
-	pkg->nd_size_out = cmd_length;
-	pkg->nd_fw_size = cmd_length;
+	pkg->nd_size_out = sizeof(u32);
+	pkg->nd_fw_size = sizeof(u32);
 	err_inj_clr = (struct nd_cmd_ars_err_inj_clr *)&pkg->nd_payload[0];
 	cmd->firmware_status = &err_inj_clr->status;
 
@@ -224,9 +224,9 @@ struct ndctl_cmd *ndctl_bus_cmd_new_err_inj_stat(struct ndctl_bus *bus,
 	cmd->status = 1;
 	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
 	pkg->nd_command = NFIT_CMD_ARS_INJECT_GET;
-	pkg->nd_size_in = cmd_length;
-	pkg->nd_size_out = cmd_length + buf_size;
-	pkg->nd_fw_size = cmd_length + buf_size;
+	pkg->nd_size_in = 0;
+	pkg->nd_size_out = (2 * sizeof(u32)) + buf_size;
+	pkg->nd_fw_size = (2 * sizeof(u32)) + buf_size;
 	err_inj_stat = (struct nd_cmd_ars_err_inj_stat *)&pkg->nd_payload[0];
 	cmd->firmware_status = &err_inj_stat->status;
 
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
