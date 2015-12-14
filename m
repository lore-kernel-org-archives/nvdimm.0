Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v3 3/6] nvdimm: Add wrapper for IOCTL pass thru
Date: Sun, 13 Dec 2015 18:54:24 -0700
Message-Id: <1f8827ca2e27be08fdb8dad5952e4ce836fadaea.1450036445.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1450036445.git.jerry.hoemann@hpe.com>
References: <cover.1450036445.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1450036445.git.jerry.hoemann@hpe.com>
References: <cover.1450036445.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com, elliott@hpe.com, jmoyer@redhat.com, krivenok.dmitry@gmail.com, linda.knippers@hpe.com
Cc: robert.moore@intel.com, lv.zheng@intel.com, rafael.j.wysocki@intel.com, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Add struct nd_passthru_pkg which serves as a warapper for
the data being passed via a pass thru to a NVDIMM DSM.
This wrapper specifies the extra information in a uniform
manner allowing the kenrel to call a DSM without knowing
specifics of the DSM.

Add dsm_call command to nvdimm_bus_cmd_name and nvdimm_cmd_name.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 include/uapi/linux/ndctl.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 5b4a4be..6823af3 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -109,6 +109,7 @@ enum {
 	ND_CMD_VENDOR_EFFECT_LOG_SIZE = 7,
 	ND_CMD_VENDOR_EFFECT_LOG = 8,
 	ND_CMD_VENDOR = 9,
+	ND_CMD_CALL_DSM = 10,
 };
 
 enum {
@@ -122,6 +123,7 @@ static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
 		[ND_CMD_ARS_CAP] = "ars_cap",
 		[ND_CMD_ARS_START] = "ars_start",
 		[ND_CMD_ARS_STATUS] = "ars_status",
+		[ND_CMD_CALL_DSM] = "dsm_call",
 	};
 
 	if (cmd < ARRAY_SIZE(names) && names[cmd])
@@ -141,6 +143,7 @@ static inline const char *nvdimm_cmd_name(unsigned cmd)
 		[ND_CMD_VENDOR_EFFECT_LOG_SIZE] = "effect_size",
 		[ND_CMD_VENDOR_EFFECT_LOG] = "effect_log",
 		[ND_CMD_VENDOR] = "vendor",
+		[ND_CMD_CALL_DSM] = "dsm_call",
 	};
 
 	if (cmd < ARRAY_SIZE(names) && names[cmd])
@@ -204,4 +207,20 @@ enum ars_masks {
 	ARS_STATUS_MASK = 0x0000FFFF,
 	ARS_EXT_STATUS_SHIFT = 16,
 };
+
+
+struct nd_cmd_dsmcall_pkg {
+	struct {
+		__u8	dsm_uuid[16];
+		__u64	reserved1;		/* reserved should be zero */
+		__u64	dsm_rev;		/* revision of dsm call  */
+		__u64	dsm_fun_idx;		/* DSM function id	 */
+		__u32	dsm_in;			/* size of _DSM input	 */
+		__u32	dsm_out;		/* size of user buffer	 */
+		__u32	reserved2[23];		/* reserved must be zero */
+		__u32	dsm_size;		/* size _DSM would write */
+	} h;
+	unsigned char dsm_buf[];		/* Contents of DSM call	 */
+};
+
 #endif /* __NDCTL_H__ */
-- 
1.7.11.3

