Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1EC5521E43B61
 for <linux-nvdimm@lists.01.org>; Fri, 22 Sep 2017 00:43:41 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id F2DE8AC011D
 for <linux-nvdimm@lists.01.org>; Fri, 22 Sep 2017 16:46:43 +0900 (JST)
Date: Fri, 22 Sep 2017 16:46:26 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [PATCH v4 1/3] nfit_test Make private definitions to command emulation
In-Reply-To: <20170922164440.4A35.E1E9C6FF@jp.fujitsu.com>
References: <20170922164440.4A35.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170922164622.4A38.E1E9C6FF@jp.fujitsu.com>
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


Move private definitions to command emulation.
These definitions were originally defined at include/uapi/linux/ndctl.h,
but they are used at only nfit_test emulation now.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
---
 include/uapi/linux/ndctl.h            | 37 ---------------------------
 tools/testing/nvdimm/test/nfit_test.h | 47 +++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 37 deletions(-)

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 6d3c542..3f03567 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -145,43 +145,6 @@ struct nd_cmd_clear_error {
 	__u64 cleared;
 } __packed;
 
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
-	} __packed devices[0];
-
-} __packed;
-
-struct nd_cmd_ars_err_inj {
-	__u64 err_inj_spa_range_base;
-	__u64 err_inj_spa_range_length;
-	__u8  err_inj_options;
-	__u32 status;
-} __packed;
-
-struct nd_cmd_ars_err_inj_clr {
-	__u64 err_inj_clr_spa_range_base;
-	__u64 err_inj_clr_spa_range_length;
-	__u32 status;
-} __packed;
-
-struct nd_cmd_ars_err_inj_stat {
-	__u32 status;
-	__u32 inj_err_rec_count;
-	struct nd_error_stat_query_record {
-		__u64 err_inj_stat_spa_range_base;
-		__u64 err_inj_stat_spa_range_length;
-	} __packed record[0];
-} __packed;
-
 enum {
 	ND_CMD_IMPLEMENTED = 0,
 
diff --git a/tools/testing/nvdimm/test/nfit_test.h b/tools/testing/nvdimm/test/nfit_test.h
index d3d63dd..52c83be9 100644
--- a/tools/testing/nvdimm/test/nfit_test.h
+++ b/tools/testing/nvdimm/test/nfit_test.h
@@ -32,6 +32,53 @@ struct nfit_test_resource {
 	void *buf;
 };
 
+#define ND_TRANSLATE_SPA_STATUS_INVALID_SPA  2
+
+/* nfit commands */
+enum nfit_cmd_num {
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
+	} __packed devices[0];
+
+} __packed;
+
+struct nd_cmd_ars_err_inj {
+	__u64 err_inj_spa_range_base;
+	__u64 err_inj_spa_range_length;
+	__u8  err_inj_options;
+	__u32 status;
+} __packed;
+
+struct nd_cmd_ars_err_inj_clr {
+	__u64 err_inj_clr_spa_range_base;
+	__u64 err_inj_clr_spa_range_length;
+	__u32 status;
+} __packed;
+
+struct nd_cmd_ars_err_inj_stat {
+	__u32 status;
+	__u32 inj_err_rec_count;
+	struct nd_error_stat_query_record {
+		__u64 err_inj_stat_spa_range_base;
+		__u64 err_inj_stat_spa_range_length;
+	} __packed record[0];
+} __packed;
+
 union acpi_object;
 typedef void *acpi_handle;
 


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
