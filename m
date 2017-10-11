Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8DCC621F7D50A
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 10:54:11 -0700 (PDT)
Subject: [PATCH] libnvdimm: add smart payload fields added in DSM 1.6
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 11 Oct 2017 10:57:40 -0700
Message-ID: <150774466038.55191.18214496952092405741.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: piotr.balcer@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

NVDIMM DSM interface v1.6 added additional smart health fields. Updating the
smart payload data structure accordingly.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 include/uapi/linux/ndctl.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 3f03567..5ca8628 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -25,6 +25,7 @@ struct nd_cmd_smart {
 #define ND_SMART_USED_VALID	(1 << 2)
 #define ND_SMART_TEMP_VALID 	(1 << 3)
 #define ND_SMART_CTEMP_VALID 	(1 << 4)
+#define ND_SMART_SHUTDOWN_COUNT_VALID (1 << 5)
 #define ND_SMART_ALARM_VALID	(1 << 9)
 #define ND_SMART_SHUTDOWN_VALID	(1 << 10)
 #define ND_SMART_VENDOR_VALID	(1 << 11)
@@ -44,7 +45,10 @@ struct nd_smart_payload {
 	__u8 alarm_flags;
 	__u16 temperature;
 	__u16 ctrl_temperature;
-	__u8 reserved1[15];
+	__u32 shutdown_count;
+	__u8 ait_status;
+	__u16 pmic_temperature;
+	__u8 reserved1[8];
 	__u8 shutdown_state;
 	__u32 vendor_size;
 	__u8 vendor_data[92];

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
