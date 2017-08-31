Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3150F21E70D3D
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 18:22:46 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 5769FAC013A
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 10:23:50 +0900 (JST)
Date: Thu, 31 Aug 2017 10:23:37 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [ndctl PATCH 1/5] Introduce libndctl-nfit.h
In-Reply-To: <20170831102101.DA2C.E1E9C6FF@jp.fujitsu.com>
References: <20170831102101.DA2C.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170831102334.DA30.E1E9C6FF@jp.fujitsu.com>
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


This patch introduces libndctl-nfit.h.

Since these command can be executed via ND_CMD_CALL,
libndctl.h which is shared between ndctl command and kernel does not
have to include these defintions.

So, libndctl-nfit.h, which is defined for only ndctl, is created instead,
and move definitions from ndctl.h to it.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 ndctl/lib/libndctl-nfit.h | 61 +++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/ndctl.h             | 37 ----------------------------
 2 files changed, 61 insertions(+), 37 deletions(-)

diff --git a/ndctl/lib/libndctl-nfit.h b/ndctl/lib/libndctl-nfit.h
new file mode 100644
index 0000000..1398662
--- /dev/null
+++ b/ndctl/lib/libndctl-nfit.h
@@ -0,0 +1,61 @@
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
+ * more details.
+ */
+#ifndef __LIBNDCTL_NFIT_H__
+#define __LIBNDCTL_NFIT_H__
+
+#define ND_TRANSLATE_SPA_STATUS_INVALID_SPA  2
+
+/* bus passthru commands */
+enum {
+	NFIT_CMD_TRANSLATE_SPA = 5,
+	NFIT_CMD_ARS_INJECT_SET = 7,
+	NFIT_CMD_ARS_INJECT_CLEAR = 8,
+	NFIT_CMD_ARS_INJECT_GET = 9,
+};
+
+struct nd_cmd_translate_spa {
+	__u64 spa;
+	__u32 status;
+	__u8  flags;
+	__u8  _reserved[3];
+	__u64 translate_length;
+	__u32 num_nvdimms;
+	struct nd_nvdimm_device {
+		__u32 nfit_device_handle;
+		__u32 _reserved;
+		__u64 dpa;
+	} __attribute__((packed)) devices[0];
+
+} __attribute__((packed));
+
+struct nd_cmd_ars_err_inj {
+	__u64 err_inj_spa_range_base;
+	__u64 err_inj_spa_range_length;
+	__u8  err_inj_options;
+	__u32 status;
+} __attribute__((packed));
+
+struct nd_cmd_ars_err_inj_clr {
+	__u64 err_inj_clr_spa_range_base;
+	__u64 err_inj_clr_spa_range_length;
+	__u32 status;
+} __attribute__((packed));
+
+struct nd_cmd_ars_err_inj_stat {
+	__u32 status;
+	__u32 inj_err_rec_count;
+	struct nd_error_stat_query_record {
+		__u64 err_inj_stat_spa_range_base;
+		__u64 err_inj_stat_spa_range_length;
+	} __attribute__((packed)) record[0];
+} __attribute__((packed));
+
+#endif /* __LIBNDCTL_NFIT_H__ */
diff --git a/ndctl/ndctl.h b/ndctl/ndctl.h
index d70b97d..2dd461b 100644
--- a/ndctl/ndctl.h
+++ b/ndctl/ndctl.h
@@ -145,43 +145,6 @@ struct nd_cmd_clear_error {
 	__u64 cleared;
 } __attribute__((packed));
 
-struct nd_cmd_trans_spa {
-	__u64 spa;
-	__u32 status;
-	__u8  flags;
-	__u8  _reserved[3];
-	__u64 trans_length;
-	__u32 num_nvdimms;
-	struct nd_nvdimm_device {
-		__u32 nfit_device_handle;
-		__u32 _reserved;
-		__u64 dpa;
-	} __attribute__((packed)) devices[0];
-
-} __attribute__((packed));
-
-struct nd_cmd_ars_err_inj {
-	__u64 err_inj_spa_range_base;
-	__u64 err_inj_spa_range_length;
-	__u8  err_inj_options;
-	__u32 status;
-} __attribute__((packed));
-
-struct nd_cmd_ars_err_inj_clr {
-	__u64 err_inj_clr_spa_range_base;
-	__u64 err_inj_clr_spa_range_length;
-	__u32 status;
-} __attribute__((packed));
-
-struct nd_cmd_ars_err_inj_stat {
-	__u32 status;
-	__u32 inj_err_rec_count;
-	struct nd_error_stat_query_record {
-		__u64 err_inj_stat_spa_range_base;
-		__u64 err_inj_stat_spa_range_length;
-	} __attribute__((packed)) record[0];
-} __attribute__((packed));
-
 enum {
 	ND_CMD_IMPLEMENTED = 0,
 



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
