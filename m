Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH 1/4] nvdimm: Add wrapper for IOCTL pass thru.
Date: Fri,  6 Nov 2015 15:27:28 -0700
Message-Id: <5411049831df211c8280e3239aaf344af033fa25.1446684001.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1446684001.git.jerry.hoemann@hpe.com>
References: <cover.1446684001.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1446684001.git.jerry.hoemann@hpe.com>
References: <cover.1446684001.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Add IOCTL type 'P' to denote NVDIMM_TYPE_PASSTHRU.

Add struct ndn_pkg which the pass thru IOCTL interfaces uses.
ndn_pkg serves as a wrapper for the data being passed to the
underlying DSM and specifies siz data in a uniform manner allowing
the kernel to call the DSM without knowing specifics of the DSM.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 include/uapi/linux/ndctl.h | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 5b4a4be..1c81a99 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -15,6 +15,9 @@
 
 #include <linux/types.h>
 
+#define NVDIMM_TYPE_INTEL		'N'
+#define NVDIMM_TYPE_PASSTHRU		'P'
+
 struct nd_cmd_smart {
 	__u32 status;
 	__u8 data[128];
@@ -148,7 +151,8 @@ static inline const char *nvdimm_cmd_name(unsigned cmd)
 	return "unknown";
 }
 
-#define ND_IOCTL 'N'
+#define ND_IOCTL			NVDIMM_TYPE_INTEL
+
 
 #define ND_IOCTL_SMART			_IOWR(ND_IOCTL, ND_CMD_SMART,\
 					struct nd_cmd_smart)
@@ -204,4 +208,18 @@ enum ars_masks {
 	ARS_STATUS_MASK = 0x0000FFFF,
 	ARS_EXT_STATUS_SHIFT = 16,
 };
+
+
+struct ndn_pkg {
+	struct {
+		__u8	dsm_uuid[16];
+		__u32	dsm_in;			/* size of _DSM input    */
+		__u32	dsm_out;		/* size of user buffer   */
+		__u32	dsm_rev;		/* revision of dsm call  */
+		__u32	res[8];			/* reserved must be zero */
+		__u32	dsm_size;		/* size _DSM would write */
+	} h;
+	unsigned char buf[];
+} __packed;
+
 #endif /* __NDCTL_H__ */
-- 
1.7.11.3

