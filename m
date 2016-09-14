Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A3A011A1E5B
 for <linux-nvdimm@lists.01.org>; Tue, 13 Sep 2016 18:31:56 -0700 (PDT)
Subject: [PATCH 1/2] nfit: fail DSMs that return non-zero status by default
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Sep 2016 18:28:53 -0700
Message-ID: <147381653306.13555.14745102134571847874.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147381652762.13555.2547727388390513900.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147381652762.13555.2547727388390513900.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

For the DSMs where the kernel knows the format of the output buffer and
originates those DSMs from within the kernel, return -EIO for any
non-zero status.  If the BIOS is indicating a status that we do not know
how to handle, fail the DSM.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   48 +++++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index ceb6671ab355..8d7cbecd7cce 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -94,54 +94,50 @@ static struct acpi_device *to_acpi_dev(struct acpi_nfit_desc *acpi_desc)
 	return to_acpi_device(acpi_desc->dev);
 }
 
-static int xlat_status(void *buf, unsigned int cmd)
+static int xlat_status(void *buf, unsigned int cmd, u32 status)
 {
 	struct nd_cmd_clear_error *clear_err;
 	struct nd_cmd_ars_status *ars_status;
-	struct nd_cmd_ars_start *ars_start;
-	struct nd_cmd_ars_cap *ars_cap;
 	u16 flags;
 
 	switch (cmd) {
 	case ND_CMD_ARS_CAP:
-		ars_cap = buf;
-		if ((ars_cap->status & 0xffff) == NFIT_ARS_CAP_NONE)
+		if ((status & 0xffff) == NFIT_ARS_CAP_NONE)
 			return -ENOTTY;
 
 		/* Command failed */
-		if (ars_cap->status & 0xffff)
+		if (status & 0xffff)
 			return -EIO;
 
 		/* No supported scan types for this range */
 		flags = ND_ARS_PERSISTENT | ND_ARS_VOLATILE;
-		if ((ars_cap->status >> 16 & flags) == 0)
+		if ((status >> 16 & flags) == 0)
 			return -ENOTTY;
 		break;
 	case ND_CMD_ARS_START:
-		ars_start = buf;
 		/* ARS is in progress */
-		if ((ars_start->status & 0xffff) == NFIT_ARS_START_BUSY)
+		if ((status & 0xffff) == NFIT_ARS_START_BUSY)
 			return -EBUSY;
 
 		/* Command failed */
-		if (ars_start->status & 0xffff)
+		if (status & 0xffff)
 			return -EIO;
 		break;
 	case ND_CMD_ARS_STATUS:
 		ars_status = buf;
 		/* Command failed */
-		if (ars_status->status & 0xffff)
+		if (status & 0xffff)
 			return -EIO;
 		/* Check extended status (Upper two bytes) */
-		if (ars_status->status == NFIT_ARS_STATUS_DONE)
+		if (status == NFIT_ARS_STATUS_DONE)
 			return 0;
 
 		/* ARS is in progress */
-		if (ars_status->status == NFIT_ARS_STATUS_BUSY)
+		if (status == NFIT_ARS_STATUS_BUSY)
 			return -EBUSY;
 
 		/* No ARS performed for the current boot */
-		if (ars_status->status == NFIT_ARS_STATUS_NONE)
+		if (status == NFIT_ARS_STATUS_NONE)
 			return -EAGAIN;
 
 		/*
@@ -149,19 +145,19 @@ static int xlat_status(void *buf, unsigned int cmd)
 		 * agent wants the scan to stop.  If we didn't overflow
 		 * then just continue with the returned results.
 		 */
-		if (ars_status->status == NFIT_ARS_STATUS_INTR) {
+		if (status == NFIT_ARS_STATUS_INTR) {
 			if (ars_status->flags & NFIT_ARS_F_OVERFLOW)
 				return -ENOSPC;
 			return 0;
 		}
 
 		/* Unknown status */
-		if (ars_status->status >> 16)
+		if (status >> 16)
 			return -EIO;
 		break;
 	case ND_CMD_CLEAR_ERROR:
 		clear_err = buf;
-		if (clear_err->status & 0xffff)
+		if (status & 0xffff)
 			return -EIO;
 		if (!clear_err->cleared)
 			return -EIO;
@@ -172,6 +168,9 @@ static int xlat_status(void *buf, unsigned int cmd)
 		break;
 	}
 
+	/* all other non-zero status results in an error */
+	if (status)
+		return -EIO;
 	return 0;
 }
 
@@ -186,10 +185,10 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	struct nd_cmd_pkg *call_pkg = NULL;
 	const char *cmd_name, *dimm_name;
 	unsigned long cmd_mask, dsm_mask;
+	u32 offset, fw_status = 0;
 	acpi_handle handle;
 	unsigned int func;
 	const u8 *uuid;
-	u32 offset;
 	int rc, i;
 
 	func = cmd;
@@ -317,6 +316,15 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 				out_obj->buffer.pointer + offset, out_size);
 		offset += out_size;
 	}
+
+	/*
+	 * Set fw_status for all the commands with a known format to be
+	 * later interpreted by xlat_status().
+	 */
+	if (i >= 1 && ((cmd >= ND_CMD_ARS_CAP && cmd <= ND_CMD_CLEAR_ERROR)
+			|| (cmd >= ND_CMD_SMART && cmd <= ND_CMD_VENDOR)))
+		fw_status = *(u32 *) out_obj->buffer.pointer;
+
 	if (offset + in_buf.buffer.length < buf_len) {
 		if (i >= 1) {
 			/*
@@ -325,7 +333,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 			 */
 			rc = buf_len - offset - in_buf.buffer.length;
 			if (cmd_rc)
-				*cmd_rc = xlat_status(buf, cmd);
+				*cmd_rc = xlat_status(buf, cmd, fw_status);
 		} else {
 			dev_err(dev, "%s:%s underrun cmd: %s buf_len: %d out_len: %d\n",
 					__func__, dimm_name, cmd_name, buf_len,
@@ -335,7 +343,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	} else {
 		rc = 0;
 		if (cmd_rc)
-			*cmd_rc = xlat_status(buf, cmd);
+			*cmd_rc = xlat_status(buf, cmd, fw_status);
 	}
 
  out:

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
