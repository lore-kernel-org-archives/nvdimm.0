Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v3 2/3] nvdimm: Add wrapper for IOCTL pass thru
Date: Wed,  2 Dec 2015 14:05:20 -0700
Message-Id: <7653242fd786d624db81967ea86a6d3540cb3db9.1449089647.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1449089647.git.jerry.hoemann@hpe.com>
References: <cover.1449089647.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1449089647.git.jerry.hoemann@hpe.com>
References: <cover.1449089647.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com, elliott@hpe.com, jmoyer@redhat.com, krivenok.dmitry@gmail.com, linda.knippers@hpe.com
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Add struct nd_passthru_pkg which serves as a warapper for
the data being passed via a pass thru to a NVDIMM DSM.
This wrapper specifies the extra information in a uniform
manner allowing the kenrel to call a DSM without knowing
specifics of the DSM.

Add dsm_call command to nvdimm_bus_cmd_name and nvdimm_cmd_name.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 include/uapi/linux/ndctl.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 5b4a4be..fdb30d2 100644
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
@@ -204,4 +207,19 @@ enum ars_masks {
 	ARS_STATUS_MASK = 0x0000FFFF,
 	ARS_EXT_STATUS_SHIFT = 16,
 };
+
+
+struct nd_cmd_dsmcall_pkg {
+	struct {
+		__u8	dsm_uuid[16];
+		__u64	dsm_rev;		/* revision of dsm call  */
+		__u64	dsm_fun_idx;		/* DSM function id       */
+		__u32	dsm_in;			/* size of _DSM input    */
+		__u32	dsm_out;		/* size of user buffer   */
+		__u64	reserved[12];		/* reserved must be zero */
+		__u32	dsm_size;		/* size _DSM would write */
+	} h;
+	unsigned char dsm_buf[];		/* Contents of DSM call  */
+};
+
 #endif /* __NDCTL_H__ */
-- 
1.7.11.3

