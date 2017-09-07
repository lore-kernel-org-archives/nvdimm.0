Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F1F321E97806
 for <linux-nvdimm@lists.01.org>; Wed,  6 Sep 2017 22:00:20 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id B4ACFAC0201
 for <linux-nvdimm@lists.01.org>;
 Thu,  7 Sep 2017 14:02:44 +0900 (JST)
Date: Thu, 07 Sep 2017 14:02:40 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [ndctl PATCH v5 1/5] ndctl: Introduce libndctl-nfit.h
In-Reply-To: <20170907140049.7F71.E1E9C6FF@jp.fujitsu.com>
References: <20170907140049.7F71.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170907140236.7F74.E1E9C6FF@jp.fujitsu.com>
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

So, libndctl-nfit.h, which is defined for only ndctl, is created instead.
---
 ndctl/libndctl-nfit.h | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/ndctl/libndctl-nfit.h b/ndctl/libndctl-nfit.h
new file mode 100644
index 0000000..8eeeb10
--- /dev/null
+++ b/ndctl/libndctl-nfit.h
@@ -0,0 +1,76 @@
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
+
+#ifndef __LIBNDCTL_NFIT_H__
+#define __LIBNDCTL_NFIT_H__
+
+/*
+ * libndctl-nfit.h : definitions for NFIT related commands/functions.
+ */
+
+/* nfit command numbers which are called via ND_CMD_CALL */
+enum {
+	NFIT_CMD_TRANSLATE_SPA = 5,
+	NFIT_CMD_ARS_INJECT_SET = 7,
+	NFIT_CMD_ARS_INJECT_CLEAR = 8,
+	NFIT_CMD_ARS_INJECT_GET = 9,
+};
+
+/* error number of Translate SPA by firmware  */
+#define ND_TRANSLATE_SPA_STATUS_INVALID_SPA  2
+
+/*
+ * The following structures are command packages which are
+ * defined by ACPI 6.2 (or later).
+ */
+
+/* For Translate SPA */
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
+/* For ARS Error Inject */
+struct nd_cmd_ars_err_inj {
+	__u64 err_inj_spa_range_base;
+	__u64 err_inj_spa_range_length;
+	__u8  err_inj_options;
+	__u32 status;
+} __attribute__((packed));
+
+/* For ARS Error Inject Clear */
+struct nd_cmd_ars_err_inj_clr {
+	__u64 err_inj_clr_spa_range_base;
+	__u64 err_inj_clr_spa_range_length;
+	__u32 status;
+} __attribute__((packed));
+
+/* For ARS Error Inject Status Query */
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



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
