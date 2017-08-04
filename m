Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7DE3D21E1DAD3
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 02:04:51 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 48F2CAC00DE
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 18:07:00 +0900 (JST)
Date: Fri, 04 Aug 2017 18:06:57 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [RFC/Patch 1/5] Remove old enum definition of "Translate Spa"
In-Reply-To: <20170804180231.27BC.E1E9C6FF@jp.fujitsu.com>
References: <20170804180231.27BC.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170804180655.27BF.E1E9C6FF@jp.fujitsu.com>
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


Remove old enum definition of "Translate Spa".

Translate SPA becomes standard specification on ACPI 6.2,
but current definition is likely temporary.
So it is removed.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>


---
 drivers/acpi/nfit/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 19182d0..5334755 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1626,7 +1626,6 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
  * these commands.
  */
 enum nfit_aux_cmds {
-        NFIT_CMD_TRANSLATE_SPA = 5,
         NFIT_CMD_ARS_INJECT_SET = 7,
         NFIT_CMD_ARS_INJECT_CLEAR = 8,
         NFIT_CMD_ARS_INJECT_GET = 9,
@@ -1655,7 +1654,6 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 		(1 << ND_CMD_ARS_START) |
 		(1 << ND_CMD_ARS_STATUS) |
 		(1 << ND_CMD_CLEAR_ERROR) |
-		(1 << NFIT_CMD_TRANSLATE_SPA) |
 		(1 << NFIT_CMD_ARS_INJECT_SET) |
 		(1 << NFIT_CMD_ARS_INJECT_CLEAR) |
 		(1 << NFIT_CMD_ARS_INJECT_GET);




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
