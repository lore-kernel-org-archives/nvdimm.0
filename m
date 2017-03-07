Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-BL2-obe.outbound.protection.outlook.com
 (mail-bl2nam02on0717.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe46::717])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 77B0880352
 for <linux-nvdimm@lists.01.org>; Tue,  7 Mar 2017 13:35:41 -0800 (PST)
From: Linda Knippers <linda.knippers@hpe.com>
Subject: [PATCH 3/3] Remove unnecessary newline
Date: Tue, 7 Mar 2017 16:35:14 -0500
Message-ID: <ac65f998a81d5c3b1f01dce4be3af176bc3e0c7f.1488921944.git.linda.knippers@hpe.com>
In-Reply-To: <cover.1488921944.git.linda.knippers@hpe.com>
References: <cover.1488921944.git.linda.knippers@hpe.com>
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

The newline in MODULE_PARM_DESC causes modinfo to print the parameter
data type on a separate line, which is different from all the other
module parameters and could potentially cause a problem for someone
parsing the output of modinfo.

Signed-off-by: Linda Knippers <linda.knippers@hpe.com>
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 0564cd6..0a51b75 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -49,7 +49,7 @@
 static bool disable_vendor_specific;
 module_param(disable_vendor_specific, bool, S_IRUGO);
 MODULE_PARM_DESC(disable_vendor_specific,
-		"Limit commands to the publicly specified set\n");
+		"Limit commands to the publicly specified set");
 
 static unsigned long override_dsm_mask;
 module_param(override_dsm_mask, ulong, S_IRUGO);
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
