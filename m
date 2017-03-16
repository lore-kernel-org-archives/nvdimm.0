Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6565680417
 for <linux-nvdimm@lists.01.org>; Thu, 16 Mar 2017 15:59:11 -0700 (PDT)
Subject: [PATCH v4 3/5] acpi: code cleanup for acpi_nfit_ctl calling
 xlat_status
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 16 Mar 2017 15:59:07 -0700
Message-ID: <148970514754.49411.8466981511141701031.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <148970513650.49411.10791297905780906216.stgit@djiang5-desk3.ch.intel.com>
References: <148970513650.49411.10791297905780906216.stgit@djiang5-desk3.ch.intel.com>
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

Moving the xlat_status() call to a single location to clean up the code
since it is getting called in the main code paths already. We only need
to bail on the error path at a single location.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
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
