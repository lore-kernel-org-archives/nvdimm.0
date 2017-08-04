Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 354C22095D9C2
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 02:06:23 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id AE0EAAC013E
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 18:08:28 +0900 (JST)
Date: Fri, 04 Aug 2017 18:08:24 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [RFC/Patch 2/5] Support Translate SPA for NVDIMM Root Device.
In-Reply-To: <20170804180231.27BC.E1E9C6FF@jp.fujitsu.com>
References: <20170804180231.27BC.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170804180822.27C4.E1E9C6FF@jp.fujitsu.com>
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
To: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


Support Translate SPA for NVDIMM Root Device.

ACPI 6.2 has new specification on _DSM of NVDIMM Root Device
It is "Translate SPA" which translate from system physical address(SPA)
to NVDIMM handle and dimm physical address(DPA).

This patch is to support Translate SPA.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
---
 drivers/acpi/nfit/core.c   |  7 +++++--
 drivers/nvdimm/bus.c       | 11 ++++++++++-
 include/linux/libnvdimm.h  |  2 +-
 include/uapi/linux/ndctl.h |  4 ++++
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 5334755..e8c67a3 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -173,6 +173,8 @@ static int xlat_bus_status(void *buf, unsigned int cmd, u32 status)
 		if (clear_err->length > clear_err->cleared)
 			return clear_err->cleared;
 		return 0;
+	case ND_CMD_TRANS_SPA:
+		return 0;
 	default:
 		break;
 	}
@@ -352,7 +354,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	 * Set fw_status for all the commands with a known format to be
 	 * later interpreted by xlat_status().
 	 */
-	if (i >= 1 && ((cmd >= ND_CMD_ARS_CAP && cmd <= ND_CMD_CLEAR_ERROR)
+	if (i >= 1 && ((cmd >= ND_CMD_ARS_CAP && cmd <= ND_CMD_TRANS_SPA)
 			|| (cmd >= ND_CMD_SMART && cmd <= ND_CMD_VENDOR)))
 		fw_status = *(u32 *) out_obj->buffer.pointer;
 
@@ -1644,7 +1646,7 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 	if (!adev)
 		return;
 
-	for (i = ND_CMD_ARS_CAP; i <= ND_CMD_CLEAR_ERROR; i++)
+	for (i = ND_CMD_ARS_CAP; i <= ND_CMD_TRANS_SPA; i++)
 		if (acpi_check_dsm(adev->handle, guid, 1, 1ULL << i))
 			set_bit(i, &nd_desc->cmd_mask);
 	set_bit(ND_CMD_CALL, &nd_desc->cmd_mask);
@@ -1654,6 +1656,7 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 		(1 << ND_CMD_ARS_START) |
 		(1 << ND_CMD_ARS_STATUS) |
 		(1 << ND_CMD_CLEAR_ERROR) |
+		(1 << ND_CMD_TRANS_SPA) |
 		(1 << NFIT_CMD_ARS_INJECT_SET) |
 		(1 << NFIT_CMD_ARS_INJECT_CLEAR) |
 		(1 << NFIT_CMD_ARS_INJECT_GET);
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 937fafa..ef05fe1 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -727,6 +727,12 @@ static const struct nd_cmd_desc __nd_cmd_bus_descs[] = {
 		.out_num = 3,
 		.out_sizes = { 4, 4, 8, },
 	},
+	[ND_CMD_TRANS_SPA] = {
+		.in_num = 1,
+		.in_sizes = { 8, },
+		.out_num = 7,
+		.out_sizes = { 2, 2, 1, 3, 8, 4, UINT_MAX, },
+	},
 	[ND_CMD_CALL] = {
 		.in_num = 2,
 		.in_sizes = { sizeof(struct nd_cmd_pkg), UINT_MAX, },
@@ -801,7 +807,9 @@ u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
 		if (out_field[1] - 8 == remainder)
 			return remainder;
 		return out_field[1] - 4;
-	} else if (cmd == ND_CMD_CALL) {
+	} else if (!nvdimm && cmd == ND_CMD_TRANS_SPA && idx == 6)
+		return out_field[2];
+	else if (cmd == ND_CMD_CALL) {
 		struct nd_cmd_pkg *pkg = (struct nd_cmd_pkg *) in_field;
 
 		return pkg->nd_size_out;
@@ -947,6 +955,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		case ND_CMD_SET_CONFIG_DATA:
 		case ND_CMD_ARS_START:
 		case ND_CMD_CLEAR_ERROR:
+		case ND_CMD_TRANS_SPA:
 		case ND_CMD_CALL:
 			dev_dbg(&nvdimm_bus->dev, "'%s' command while read-only.\n",
 					nvdimm ? nvdimm_cmd_name(cmd)
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index f3d3e6a..c179ed0 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -29,7 +29,7 @@ enum {
 
 	/* need to set a limit somewhere, but yes, this is likely overkill */
 	ND_IOCTL_MAX_BUFLEN = SZ_4M,
-	ND_CMD_MAX_ELEM = 5,
+	ND_CMD_MAX_ELEM = 7,
 	ND_CMD_MAX_ENVELOPE = 256,
 	ND_MAX_MAPPINGS = 32,
 
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 6d3c542..91bf129 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -190,6 +190,7 @@ enum {
 	ND_CMD_ARS_START = 2,
 	ND_CMD_ARS_STATUS = 3,
 	ND_CMD_CLEAR_ERROR = 4,
+	ND_CMD_TRANS_SPA = 5,
 
 	/* per-dimm commands */
 	ND_CMD_SMART = 1,
@@ -218,6 +219,7 @@ static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
 		[ND_CMD_ARS_START] = "ars_start",
 		[ND_CMD_ARS_STATUS] = "ars_status",
 		[ND_CMD_CLEAR_ERROR] = "clear_error",
+		[ND_CMD_TRANS_SPA] = "trans_spa",
 		[ND_CMD_CALL] = "cmd_call",
 	};
 
@@ -280,6 +282,8 @@ static inline const char *nvdimm_cmd_name(unsigned cmd)
 
 #define ND_IOCTL_CLEAR_ERROR		_IOWR(ND_IOCTL, ND_CMD_CLEAR_ERROR,\
 					struct nd_cmd_clear_error)
+#define ND_IOCTL_TRANS_SPA		_IOWR(ND_IOCTL, ND_CMD_TRANS_SPA,\
+					struct nd_cmd_trans_spa)
 
 #define ND_DEVICE_DIMM 1            /* nd_dimm: container for "config data" */
 #define ND_DEVICE_REGION_PMEM 2     /* nd_region: (parent of PMEM namespaces) */



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
