Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 6EDBA1A1DEB
 for <linux-nvdimm@lists.01.org>; Thu, 11 Aug 2016 18:25:45 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: update to latest ndctl.h
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Aug 2016 18:23:21 -0700
Message-ID: <147096500170.21247.3776147346860250510.stgit@dwillia2-desk3.amr.corp.intel.com>
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

SMART Health and Threshold payload updates.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/ndctl.h |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/ndctl/ndctl.h b/ndctl/ndctl.h
index 7c19e9764da0..3b1d703e4af1 100644
--- a/ndctl/ndctl.h
+++ b/ndctl/ndctl.h
@@ -21,14 +21,16 @@ struct nd_cmd_smart {
 } __attribute__((packed));
 
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
 } __attribute__((packed));
 
 struct nd_cmd_smart_threshold {
@@ -53,7 +56,8 @@ struct nd_cmd_smart_threshold {
 } __attribute__((packed));
 
 struct nd_smart_threshold_payload {
-	__u16 alarm_control;
+	__u8 alarm_control;
+	__u8 reserved0;
 	__u16 temperature;
 	__u8 spares;
 	__u8 reserved[3];
@@ -298,6 +302,7 @@ struct nd_cmd_pkg {
 #define NVDIMM_FAMILY_INTEL 0
 #define NVDIMM_FAMILY_HPE1 1
 #define NVDIMM_FAMILY_HPE2 2
+#define NVDIMM_FAMILY_MSFT 3
 
 #define ND_IOCTL_CALL			_IOWR(ND_IOCTL, ND_CMD_CALL,\
 					struct nd_cmd_pkg)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
