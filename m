Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-BL2-obe.outbound.protection.outlook.com
 (mail-bl2nam02on0717.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe46::717])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 25B9180348
 for <linux-nvdimm@lists.01.org>; Tue,  7 Mar 2017 13:35:41 -0800 (PST)
From: Linda Knippers <linda.knippers@hpe.com>
Subject: [PATCH 2/3] Allow specifying a default DSM family
Date: Tue, 7 Mar 2017 16:35:13 -0500
Message-ID: <24665de46521e86c907e0813ee5a25956bfaf5c7.1488921944.git.linda.knippers@hpe.com>
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

Provide the ability to request a default DSM family. If it is not
supported, then fall back to the normal discovery order.

This is helpful for testing platforms that support multiple DSM families.
It will also allow administrators to request the DSM family that their
management tools support, which may not be the first one found using
the current discovery order.

Signed-off-by: Linda Knippers <linda.knippers@hpe.com>
---
 drivers/acpi/nfit/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 97d42ff..0564cd6 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -55,6 +55,11 @@
 module_param(override_dsm_mask, ulong, S_IRUGO);
 MODULE_PARM_DESC(override_dsm_mask, "Bitmask of allowed NVDIMM DSM functions");
 
+static int default_dsm_family = -1;
+module_param(default_dsm_family, int, S_IRUGO);
+MODULE_PARM_DESC(default_dsm_family,
+		"Try this DSM type first when identifying NVDIMM family");
+
 LIST_HEAD(acpi_descs);
 DEFINE_MUTEX(acpi_desc_lock);
 
@@ -1372,6 +1377,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	unsigned long dsm_mask;
 	const u8 *uuid;
 	int i;
+	int family = -1;
 
 	/* nfit test assumes 1:1 relationship between commands and dsms */
 	nfit_mem->dsm_mask = acpi_desc->dimm_cmd_force_en;
@@ -1402,10 +1408,11 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	 */
 	for (i = NVDIMM_FAMILY_INTEL; i <= NVDIMM_FAMILY_MSFT; i++)
 		if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1))
-			break;
+			if (family < 0 || i == default_dsm_family)
+				family = i;
 
 	/* limit the supported commands to those that are publicly documented */
-	nfit_mem->family = i;
+	nfit_mem->family = family;
 	if (override_dsm_mask && !disable_vendor_specific)
 		dsm_mask = override_dsm_mask;
 	else if (nfit_mem->family == NVDIMM_FAMILY_INTEL) {
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
