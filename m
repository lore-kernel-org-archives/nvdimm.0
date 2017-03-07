Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DD37780366
 for <linux-nvdimm@lists.01.org>; Tue,  7 Mar 2017 13:06:48 -0800 (PST)
Subject: [PATCH v2 3/5] acpi: cleanup acpi_nfit_ctl calling xlat_status
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 07 Mar 2017 14:06:48 -0700
Message-ID: <148892080835.46486.13067994980370510435.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <148892068983.46486.5008198419806159468.stgit@djiang5-desk3.ch.intel.com>
References: <148892068983.46486.5008198419806159468.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Make sure that xlat_status is unconditionally called.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/core.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 662036b..e7b05df 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -199,7 +199,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	acpi_handle handle;
 	unsigned int func;
 	const u8 *uuid;
-	int rc, i;
+	int rc = 0, xlat_rc, i;
 
 	func = cmd;
 	if (cmd == ND_CMD_CALL) {
@@ -343,21 +343,20 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 			 * unfilled in the output buffer
 			 */
 			rc = buf_len - offset - in_buf.buffer.length;
-			if (cmd_rc)
-				*cmd_rc = xlat_status(nvdimm, buf, cmd,
-						fw_status);
 		} else {
 			dev_err(dev, "%s:%s underrun cmd: %s buf_len: %d out_len: %d\n",
 					__func__, dimm_name, cmd_name, buf_len,
 					offset);
 			rc = -ENXIO;
+			goto out;
 		}
-	} else {
-		rc = 0;
-		if (cmd_rc)
-			*cmd_rc = xlat_status(nvdimm, buf, cmd, fw_status);
 	}
 
+	xlat_rc = xlat_status(nvdimm, buf, cmd, fw_status);
+
+	if (cmd_rc)
+		*cmd_rc = xlat_rc;
+
  out:
 	ACPI_FREE(out_obj);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
