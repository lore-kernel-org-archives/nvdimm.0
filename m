Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v2 2/3] nvdimm: Add wrapper for IOCTL pass thru
Date: Mon, 16 Nov 2015 11:38:18 -0700
Message-Id: <464a9ff2c5636fd55b6e1376d54b65d5b4b1b959.1447698598.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1447698598.git.jerry.hoemann@hpe.com>
References: <cover.1447698598.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1447698598.git.jerry.hoemann@hpe.com>
References: <cover.1447698598.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com, elliott@hpe.com, jmoyer@redhat.com, krivenok.dmitry@gmail.com, linda.knippers@hpe.com
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Add struct nd_passthru_pkg which serves as a warapper for
the data being passed via a pass thru to a NVDIMM DSM.
This wrapper specifies the extra information in a uniform
manner allowing the kenrel to call a DSM without knowing
specifics of the DSM.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 include/uapi/linux/ndctl.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 5b4a4be..934a49f 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -109,6 +109,7 @@ enum {
 	ND_CMD_VENDOR_EFFECT_LOG_SIZE = 7,
 	ND_CMD_VENDOR_EFFECT_LOG = 8,
 	ND_CMD_VENDOR = 9,
+	ND_CMD_PASSTHRU = 100,
 };
 
 enum {
@@ -204,4 +205,19 @@ enum ars_masks {
 	ARS_STATUS_MASK = 0x0000FFFF,
 	ARS_EXT_STATUS_SHIFT = 16,
 };
+
+
+struct nd_passthru_pkg {
+	struct {
+		__u8	dsm_uuid[16];
+		__u64	dsm_rev;		/* revision of dsm call  */
+		__u64	dsm_fun_idx;		/* DSM function id       */
+		__u32	dsm_in;			/* size of _DSM input    */
+		__u32	dsm_out;		/* size of user buffer   */
+		__u64	reserved[12];		/* reserved must be zero */
+		__u32	dsm_size;		/* size _DSM would write */
+	} h;
+	unsigned char buf[];
+};
+
 #endif /* __NDCTL_H__ */
-- 
1.7.11.3

