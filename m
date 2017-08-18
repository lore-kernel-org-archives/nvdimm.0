Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0457121E79038
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 21:45:30 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 0A4D2AC013F
 for <linux-nvdimm@lists.01.org>; Fri, 18 Aug 2017 13:47:54 +0900 (JST)
Date: Fri, 18 Aug 2017 13:47:51 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [PATCH 1/3] acpi nfit: move definitions which nfit_test will use
In-Reply-To: <20170818134627.8EBC.E1E9C6FF@jp.fujitsu.com>
References: <20170818134627.8EBC.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170818134749.8EBF.E1E9C6FF@jp.fujitsu.com>
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


To use nfit_test.ko can use the definition of NFIT_CMD_TRANSLATE_SPA,
the defintion is moved from nfit/core.c to ndctl.h.

Probably, other NFIT_CMD_XXX defintions will be used by nfit_test.ko in future.
move them to ndctl.h at this time.

---
 drivers/acpi/nfit/core.c   | 11 -----------
 include/uapi/linux/ndctl.h | 11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 19182d0..00e49c2 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1621,17 +1621,6 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 			acpi_desc);
 }
 
-/*
- * These constants are private because there are no kernel consumers of
- * these commands.
- */
-enum nfit_aux_cmds {
-        NFIT_CMD_TRANSLATE_SPA = 5,
-        NFIT_CMD_ARS_INJECT_SET = 7,
-        NFIT_CMD_ARS_INJECT_CLEAR = 8,
-        NFIT_CMD_ARS_INJECT_GET = 9,
-};
-
 static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 {
 	struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 6d3c542..a359d19 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -204,6 +204,17 @@ enum {
 	ND_CMD_CALL = 10,
 };
 
+/*
+ * Though These constants are mainly used by acpi nfit driver,
+ * they are defined here for nfit_test.ko to be able to use them.
+ */
+enum nfit_aux_cmds {
+        NFIT_CMD_TRANSLATE_SPA = 5,
+        NFIT_CMD_ARS_INJECT_SET = 7,
+        NFIT_CMD_ARS_INJECT_CLEAR = 8,
+        NFIT_CMD_ARS_INJECT_GET = 9,
+};
+
 enum {
 	ND_ARS_VOLATILE = 1,
 	ND_ARS_PERSISTENT = 2,



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
