Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id EB7D31A1DEB
 for <linux-nvdimm@lists.01.org>; Thu, 11 Aug 2016 18:24:23 -0700 (PDT)
Subject: [PATCH] libnvdimm: fix SMART Health DSM payload definition
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Aug 2016 18:22:00 -0700
Message-ID: <147096479825.21179.13980044056080259548.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

"NVDIMM DSM Interface Example" v1.2 made an incompatible change to the
layout of function1 "SMART and Health Info".  While the kernel does not
directly consume this payload, it does define it in ndctl.h that
userpace utilities consume.

Reported-by: Brian Boylston <brian.boylston@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

Note, there's no urgency to get this into the kernel since the only
consumer of it is userspace [1], and it can update in advance of this
patch being merged upstream in v4.9.

[1]: github.com/pmem/ndctl

 include/uapi/linux/ndctl.h |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index ba5a8c79652a..ede5c6a62164 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -21,14 +21,16 @@ struct nd_cmd_smart {
 } __packed;
 
 #define ND_SMART_HEALTH_VALID	(1 << 0)
-#define ND_SMART_TEMP_VALID 	(1 << 1)
-#define ND_SMART_SPARES_VALID	(1 << 2)
-#define ND_SMART_ALARM_VALID	(1 << 3)
-#define ND_SMART_USED_VALID	(1 << 4)
-#define ND_SMART_SHUTDOWN_VALID	(1 << 5)
-#define ND_SMART_VENDOR_VALID	(1 << 6)
-#define ND_SMART_TEMP_TRIP	(1 << 0)
-#define ND_SMART_SPARE_TRIP	(1 << 1)
+#define ND_SMART_SPARES_VALID	(1 << 1)
+#define ND_SMART_USED_VALID	(1 << 2)
+#define ND_SMART_TEMP_VALID 	(1 << 3)
+#define ND_SMART_CTEMP_VALID 	(1 << 4)
+#define ND_SMART_ALARM_VALID	(1 << 9)
+#define ND_SMART_SHUTDOWN_VALID	(1 << 10)
+#define ND_SMART_VENDOR_VALID	(1 << 11)
+#define ND_SMART_SPARE_TRIP	(1 << 0)
+#define ND_SMART_TEMP_TRIP	(1 << 1)
+#define ND_SMART_CTEMP_TRIP	(1 << 2)
 #define ND_SMART_NON_CRITICAL_HEALTH	(1 << 0)
 #define ND_SMART_CRITICAL_HEALTH	(1 << 1)
 #define ND_SMART_FATAL_HEALTH		(1 << 2)
@@ -37,14 +39,15 @@ struct nd_smart_payload {
 	__u32 flags;
 	__u8 reserved0[4];
 	__u8 health;
-	__u16 temperature;
 	__u8 spares;
-	__u8 alarm_flags;
 	__u8 life_used;
+	__u8 alarm_flags;
+	__u16 temperature;
+	__u16 ctrl_temperature;
+	__u8 reserved1[15];
 	__u8 shutdown_state;
-	__u8 reserved1;
 	__u32 vendor_size;
-	__u8 vendor_data[108];
+	__u8 vendor_data[92];
 } __packed;
 
 struct nd_cmd_smart_threshold {
@@ -53,7 +56,8 @@ struct nd_cmd_smart_threshold {
 } __packed;
 
 struct nd_smart_threshold_payload {
-	__u16 alarm_control;
+	__u8 alarm_control;
+	__u8 reserved0;
 	__u16 temperature;
 	__u8 spares;
 	__u8 reserved[3];

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
