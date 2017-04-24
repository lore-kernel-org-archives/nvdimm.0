Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C4DF321954084
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 15:37:50 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [RFC] nvdimm: Unitialized variable used in DSM calls
Date: Mon, 24 Apr 2017 16:36:50 -0600
Message-Id: <1493073410-80159-1-git-send-email-jerry.hoemann@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

nd_cmd_out_size is called by __nd_ioctl to size the buffer passed to
acpi_nfit_ctl.  If the DSM function being called has a variable
sized output, nd_cmd_out_size will look at the return field to
determine buffer size.   However, the DSM call hasn't been made yet,
so output size is core residue.

Have nd_cmd_out_size be bimodal with version "early" to be called
before the DSM call is made.  For variable sized output fields
have it return ND_IOCTL_MAX_BUFLEN.  __nd_ioctl sees new return
values and adjust buffer size accordingly.

The downside to this approach are:
1) Requires user buffer input size to be ND_IOCTL_MAX_BUFLEN (4 MB) for
   calls to DSM with variable return.
2) The needless copyin of 4MB

An alternative approach (not yet prototyped) would move the call
to nd_cmd_out_size until after the return from acpi_nfit_ctl.  Here,
the call has been made and return size would be known.

The size of the buffer allocated in would always be ND_IOCTL_MAX_BUFLEN.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/nvdimm/bus.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 23d4a17..50f8cc6 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -713,9 +713,9 @@ u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,
 }
 EXPORT_SYMBOL_GPL(nd_cmd_in_size);
 
-u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
+u32 nd_cmd_out_size_early(struct nvdimm *nvdimm, int cmd,
 		const struct nd_cmd_desc *desc, int idx, const u32 *in_field,
-		const u32 *out_field, unsigned long remainder)
+		const u32 *out_field, unsigned long remainder, int early)
 {
 	if (idx >= desc->out_num)
 		return UINT_MAX;
@@ -725,9 +725,13 @@ u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
 
 	if (nvdimm && cmd == ND_CMD_GET_CONFIG_DATA && idx == 1)
 		return in_field[1];
-	else if (nvdimm && cmd == ND_CMD_VENDOR && idx == 2)
+	else if (nvdimm && cmd == ND_CMD_VENDOR && idx == 2) {
+		if (early)
+			return ND_IOCTL_MAX_BUFLEN;
 		return out_field[1];
-	else if (!nvdimm && cmd == ND_CMD_ARS_STATUS && idx == 2) {
+	} else if (!nvdimm && cmd == ND_CMD_ARS_STATUS && idx == 2) {
+		if (early)
+			return ND_IOCTL_MAX_BUFLEN;
 		/*
 		 * Per table 9-276 ARS Data in ACPI 6.1, out_field[1] is
 		 * "Size of Output Buffer in bytes, including this
@@ -753,6 +757,13 @@ u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
 
 	return UINT_MAX;
 }
+
+u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
+		const struct nd_cmd_desc *desc, int idx, const u32 *in_field,
+		const u32 *out_field, unsigned long remainder)
+{
+	return nd_cmd_out_size_early(nvdimm, cmd, desc, idx, in_field, out_field, remainder, 0);
+}
 EXPORT_SYMBOL_GPL(nd_cmd_out_size);
 
 void wait_nvdimm_bus_probe_idle(struct device *dev)
@@ -890,10 +901,17 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 
 	/* process an output envelope */
 	for (i = 0; i < desc->out_num; i++) {
-		u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i,
-				(u32 *) in_env, (u32 *) out_env, 0);
+		u32 out_size = nd_cmd_out_size_early(nvdimm, cmd, desc, i,
+				(u32 *) in_env, (u32 *) out_env, 0, 1);
 		u32 copy;
 
+		if (out_size == ND_IOCTL_MAX_BUFLEN) {
+			/* variable sized output */
+			out_len = out_size;
+			out_len -= in_len;
+			break;
+		}
+
 		if (out_size == UINT_MAX) {
 			dev_dbg(dev, "%s:%s unknown output size cmd: %s field: %d\n",
 					__func__, dimm_name, cmd_name, i);
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
