Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam03on071e.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe48::71e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A8BB7820A5
 for <linux-nvdimm@lists.01.org>; Mon, 13 Feb 2017 08:28:22 -0800 (PST)
From: Linda Knippers <linda.knippers@hpe.com>
Subject: [PATCH 3/3] Remove unnecessary newline
Date: Mon, 13 Feb 2017 11:27:49 -0500
Message-ID: <057ada9967af9e029d2d32cef87b5ab87db4de47.1486750247.git.linda.knippers@hpe.com>
In-Reply-To: <cover.1486750246.git.linda.knippers@hpe.com>
References: <cover.1486750246.git.linda.knippers@hpe.com>
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
To: linux-nvdimm@lists.01.org, dan.j.williams@intel.com
List-ID: <linux-nvdimm@lists.01.org>

Newline in MODULE_PARM_DESC messes up the modprobe output so remove it.

Signed-off-by: Linda Knippers <linda.knippers@hpe.com>
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index e38773f..6c522c8 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -49,7 +49,7 @@
 static bool disable_vendor_specific;
 module_param(disable_vendor_specific, bool, S_IRUGO);
 MODULE_PARM_DESC(disable_vendor_specific,
-		"Limit commands to the publicly specified set\n");
+		"Limit commands to the publicly specified set");
 
 static int default_dsm_family = -1;
 module_param(default_dsm_family, int, S_IRUGO);
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
