Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EC14A21E70D55
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 18:35:37 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 46022AC013A
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 10:36:42 +0900 (JST)
Date: Thu, 31 Aug 2017 10:36:23 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [PATCH v3 1/3] nfit_test Make private definitions to command emulation
In-Reply-To: <20170831103238.DA41.E1E9C6FF@jp.fujitsu.com>
References: <20170831103238.DA41.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170831103620.DA44.E1E9C6FF@jp.fujitsu.com>
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


Make private definitions to command emulation.
These definitions were originally defined at include/uapi/linux/ndctl.h,
but they are only for nfit_test emulation now.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
---
 tools/testing/nvdimm/test/nfit_test.h | 48 +++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/tools/testing/nvdimm/test/nfit_test.h b/tools/testing/nvdimm/test/nfit_test.h
index d3d63dd..735a452 100644
--- a/tools/testing/nvdimm/test/nfit_test.h
+++ b/tools/testing/nvdimm/test/nfit_test.h
@@ -32,6 +32,54 @@ struct nfit_test_resource {
 	void *buf;
 };
 
+#define ND_TRANSLATE_SPA_STATUS_INVALID_SPA  2
+
+/* bus passthru commands */
+enum nfit_test_passthru_cmd {
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
+
 union acpi_object;
 typedef void *acpi_handle;
 



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
