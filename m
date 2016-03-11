Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t6214.austin.hp.com (g1t6214.austin.hp.com [15.73.96.122])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BDFEE1A1F7F
 for <linux-nvdimm@lists.01.org>; Fri, 11 Mar 2016 13:17:01 -0800 (PST)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [RFC v6 2/8] nvdimm: Add wrapper for IOCTL pass thru
Date: Fri, 11 Mar 2016 14:16:26 -0700
Message-Id: <833a627a8cff27a72f946fa9432cacf2a855e485.1457730736.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1457730736.git.jerry.hoemann@hpe.com>
References: <cover.1457730736.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1457730736.git.jerry.hoemann@hpe.com>
References: <cover.1457730736.git.jerry.hoemann@hpe.com>
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

Add struct nd_cmd_pkg which serves as a warapper for
the data being passed via a pass thru to a NVDIMM DSM.
This wrapper specifies the extra information in a uniform
manner allowing the kenrel to call a DSM without knowing
specifics of the DSM.

Add dsm_call command to nvdimm_bus_cmd_name and nvdimm_cmd_name.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 include/uapi/linux/ndctl.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 7cc28ab..459c6ba 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -125,6 +125,7 @@ enum {
 	ND_CMD_VENDOR_EFFECT_LOG_SIZE = 7,
 	ND_CMD_VENDOR_EFFECT_LOG = 8,
 	ND_CMD_VENDOR = 9,
+	ND_CMD_CALL_DSM = 10,
 };
 
 enum {
@@ -139,6 +140,7 @@ static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
 		[ND_CMD_ARS_START] = "ars_start",
 		[ND_CMD_ARS_STATUS] = "ars_status",
 		[ND_CMD_CLEAR_ERROR] = "clear_error",
+		[ND_CMD_CALL_DSM] = "dsm_call",
 	};
 
 	if (cmd < ARRAY_SIZE(names) && names[cmd])
@@ -158,6 +160,7 @@ static inline const char *nvdimm_cmd_name(unsigned cmd)
 		[ND_CMD_VENDOR_EFFECT_LOG_SIZE] = "effect_size",
 		[ND_CMD_VENDOR_EFFECT_LOG] = "effect_log",
 		[ND_CMD_VENDOR] = "vendor",
+		[ND_CMD_CALL_DSM] = "dsm_call",
 	};
 
 	if (cmd < ARRAY_SIZE(names) && names[cmd])
@@ -224,4 +227,23 @@ enum ars_masks {
 	ARS_STATUS_MASK = 0x0000FFFF,
 	ARS_EXT_STATUS_SHIFT = 16,
 };
+
+
+struct nd_cmd_pkg {
+	__u32   ncp_type;
+	__u32   ncp_rev;
+	__u64   ncp_command;
+	__u32   ncp_size_in;                    /* size of input payload */
+	__u32   ncp_size_out;                   /* size of user buffer   */
+	__u32   ncp_reserved2[9];               /* reserved must be zero */
+	__u32   ncp_pot_size;                   /* potential output size */
+	unsigned char ncp_payload[];            /* Contents of call      */
+};
+
+#define NCP_TYPE_BUS                   1
+#define NCP_TYPE_DIMM_INTEL1           2
+#define NCP_TYPE_DIMM_N_HPE1           3
+#define NCP_TYPE_DIMM_N_HPE2           4
+
+
 #endif /* __NDCTL_H__ */
-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
