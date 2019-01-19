Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E14B1207DF293
 for <linux-nvdimm@lists.01.org>; Sat, 19 Jan 2019 11:09:24 -0800 (PST)
Subject: [PATCH v4] acpi/nfit: Fix command-supported detection
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 19 Jan 2019 10:56:47 -0800
Message-ID: <154792410908.2360577.7879178748203288256.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Sujith Pandel <sujith_pandel@dell.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The _DSM function number validation only happens to succeed when the
generic Linux command number translation corresponds with a
DSM-family-specific function number. This breaks NVDIMM-N
implementations that correctly implement _LSR, _LSW, and _LSI, but do
not happen to publish support for DSM function numbers 4, 5, and 6.

Recall that the support for _LS{I,R,W} family of methods results in the
DIMM being marked as supporting those command numbers at
acpi_nfit_register_dimms() time. The DSM function mask is only used for
ND_CMD_CALL support of non-NVDIMM_FAMILY_INTEL devices.

Fixes: 31eca76ba2fc ("nfit, libnvdimm: limited/whitelisted dimm command...")
Cc: <stable@vger.kernel.org>
Link: https://github.com/pmem/ndctl/issues/78
Reported-by: Sujith Pandel <sujith_pandel@dell.com>
Tested-by: Sujith Pandel <sujith_pandel@dell.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v3:
* Fix ND_CMD_CALL regression:
  https://lists.01.org/pipermail/linux-nvdimm/2019-January/019644.html

 drivers/acpi/nfit/core.c |   54 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 73281b19d3dd..71d03a4004fb 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -409,6 +409,32 @@ static bool payload_dumpable(struct nvdimm *nvdimm, unsigned int func)
 	return true;
 }
 
+static int cmd_to_func(struct nfit_mem *nfit_mem, unsigned int cmd,
+		struct nd_cmd_pkg *call_pkg)
+{
+	if (call_pkg) {
+		int i;
+
+		if (nfit_mem->family != call_pkg->nd_family)
+			return -ENOTTY;
+
+		for (i = 0; i < ARRAY_SIZE(call_pkg->nd_reserved2); i++)
+			if (call_pkg->nd_reserved2[i])
+				return -EINVAL;
+		return call_pkg->nd_command;
+	}
+
+	/* Linux ND commands == NVDIMM_FAMILY_INTEL function numbers */
+	if (nfit_mem->family == NVDIMM_FAMILY_INTEL)
+		return cmd;
+
+	/*
+	 * Force function number validation to fail since 0 is never
+	 * published as a valid function in dsm_mask.
+	 */
+	return 0;
+}
+
 int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		unsigned int cmd, void *buf, unsigned int buf_len, int *cmd_rc)
 {
@@ -422,30 +448,23 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	unsigned long cmd_mask, dsm_mask;
 	u32 offset, fw_status = 0;
 	acpi_handle handle;
-	unsigned int func;
 	const guid_t *guid;
-	int rc, i;
+	int func, rc, i;
 
 	if (cmd_rc)
 		*cmd_rc = -EINVAL;
-	func = cmd;
-	if (cmd == ND_CMD_CALL) {
-		call_pkg = buf;
-		func = call_pkg->nd_command;
-
-		for (i = 0; i < ARRAY_SIZE(call_pkg->nd_reserved2); i++)
-			if (call_pkg->nd_reserved2[i])
-				return -EINVAL;
-	}
 
 	if (nvdimm) {
 		struct acpi_device *adev = nfit_mem->adev;
 
 		if (!adev)
 			return -ENOTTY;
-		if (call_pkg && nfit_mem->family != call_pkg->nd_family)
-			return -ENOTTY;
 
+		if (cmd == ND_CMD_CALL)
+			call_pkg = buf;
+		func = cmd_to_func(nfit_mem, cmd, call_pkg);
+		if (func < 0)
+			return func;
 		dimm_name = nvdimm_name(nvdimm);
 		cmd_name = nvdimm_cmd_name(cmd);
 		cmd_mask = nvdimm_cmd_mask(nvdimm);
@@ -456,6 +475,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	} else {
 		struct acpi_device *adev = to_acpi_dev(acpi_desc);
 
+		func = cmd;
 		cmd_name = nvdimm_bus_cmd_name(cmd);
 		cmd_mask = nd_desc->cmd_mask;
 		dsm_mask = cmd_mask;
@@ -470,7 +490,13 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	if (!desc || (cmd && (desc->out_num + desc->in_num == 0)))
 		return -ENOTTY;
 
-	if (!test_bit(cmd, &cmd_mask) || !test_bit(func, &dsm_mask))
+	/*
+	 * Check for a valid command.  For ND_CMD_CALL, we also have to
+	 * make sure that the DSM function is supported.
+	 */
+	if (cmd == ND_CMD_CALL && !test_bit(func, &dsm_mask))
+		return -ENOTTY;
+	else if (!test_bit(cmd, &cmd_mask))
 		return -ENOTTY;
 
 	in_obj.type = ACPI_TYPE_PACKAGE;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
