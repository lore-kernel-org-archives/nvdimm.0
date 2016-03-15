Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t6216.austin.hp.com (g1t6216.austin.hp.com [15.73.96.123])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 824F81A1E91
 for <linux-nvdimm@lists.01.org>; Tue, 15 Mar 2016 14:32:40 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v7 2/7] nvdimm: Add wrapper for IOCTL pass thru
Date: Tue, 15 Mar 2016 15:32:11 -0600
Message-Id: <6205de98024dfa849a668aedd678bf699eb9e20c.1458076114.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1458076114.git.jerry.hoemann@hpe.com>
References: <cover.1458076114.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1458076114.git.jerry.hoemann@hpe.com>
References: <cover.1458076114.git.jerry.hoemann@hpe.com>
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
 include/uapi/linux/ndctl.h | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 7cc28ab..c043cd1 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -114,6 +114,7 @@ enum {
 	ND_CMD_ARS_START = 2,
 	ND_CMD_ARS_STATUS = 3,
 	ND_CMD_CLEAR_ERROR = 4,
+	/* 10 reserved for ND_CMD_CALL below */
 
 	/* per-dimm commands */
 	ND_CMD_SMART = 1,
@@ -125,6 +126,7 @@ enum {
 	ND_CMD_VENDOR_EFFECT_LOG_SIZE = 7,
 	ND_CMD_VENDOR_EFFECT_LOG = 8,
 	ND_CMD_VENDOR = 9,
+	ND_CMD_CALL = 10,
 };
 
 enum {
@@ -139,6 +141,7 @@ static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
 		[ND_CMD_ARS_START] = "ars_start",
 		[ND_CMD_ARS_STATUS] = "ars_status",
 		[ND_CMD_CLEAR_ERROR] = "clear_error",
+		[ND_CMD_CALL] = "cmd_call",
 	};
 
 	if (cmd < ARRAY_SIZE(names) && names[cmd])
@@ -158,6 +161,7 @@ static inline const char *nvdimm_cmd_name(unsigned cmd)
 		[ND_CMD_VENDOR_EFFECT_LOG_SIZE] = "effect_size",
 		[ND_CMD_VENDOR_EFFECT_LOG] = "effect_log",
 		[ND_CMD_VENDOR] = "vendor",
+		[ND_CMD_CALL] = "cmd_call",
 	};
 
 	if (cmd < ARRAY_SIZE(names) && names[cmd])
@@ -224,4 +228,53 @@ enum ars_masks {
 	ARS_STATUS_MASK = 0x0000FFFF,
 	ARS_EXT_STATUS_SHIFT = 16,
 };
+
+
+/*
+ * struct nd_cmd_pkg
+ *
+ * is a wrapper to a quasi pass thru interface for invoking firmware
+ * associated with nvdimms.
+ *
+ * INPUT PARAMETERS
+ *
+ * nd_family corresponds to the firmware (e.g. DSM) interface.
+ *
+ * nd_command are the function index advertised by the firmware.
+ *
+ * nd_size_in is the size of the input parameters being passed to firmware
+ *
+ * OUTPUT PARAMETERS
+ *
+ * nd_fw_size is the size of the data firmware wants to return for
+ * the call.  If nd_fw_size is greater than size of nd_size_out, only
+ * the first nd_size_out bytes are returned.
+ */
+
+struct nd_cmd_pkg {
+	__u64   nd_family;		/* family of commands, eg ND_TYPE_BUS */
+	__u64   nd_command;
+	__u32   nd_size_in;		/* INPUT: size of input args */
+	__u32   nd_size_out;		/* INPUT: size of payload */
+	__u32   nd_reserved2[9];	/* reserved must be zero */
+	__u32   nd_fw_size;		/* OUTPUT: size fw wants to return */
+	unsigned char nd_payload[];	/* Contents of call      */
+};
+
+/*
+ * the list nd_family of commands.  The mapping to firmware handles
+ * is definied in the nfit_cmd_family_tbl
+ *
+ */
+#define ND_TYPE_BUS			1
+#define ND_TYPE_DIMM_INTEL1		2
+#define ND_TYPE_DIMM_N_HPE1		3
+#define ND_TYPE_DIMM_N_HPE2		4
+
+
+#define ND_IOCTL_CALL			_IOWR(ND_IOCTL, ND_CMD_CALL,\
+					struct nd_cmd_pkg)
+
+
+
 #endif /* __NDCTL_H__ */
-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
