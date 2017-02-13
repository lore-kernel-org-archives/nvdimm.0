Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam03on072a.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe48::72a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B9E5820BE
 for <linux-nvdimm@lists.01.org>; Mon, 13 Feb 2017 08:28:20 -0800 (PST)
From: Linda Knippers <linda.knippers@hpe.com>
Subject: [PATCH 2/3] Allow specifying a default DSM family
Date: Mon, 13 Feb 2017 11:27:48 -0500
Message-ID: <1add4491ffe50ece3ab84e4ab2455086a928272f.1486750247.git.linda.knippers@hpe.com>
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

Provide the ability to request a default DSM family. If it is not
supported, then fall back to the normal discovery order.

This is helpful for testing platforms that support multiple DSM families.
It will also allow administrators to request the DSM family that their
management tools support, which may not be the first one found using
the current discovery order.

Signed-off-by: Linda Knippers <linda.knippers@hpe.com>
---
 drivers/acpi/nfit/core.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index b80d4d9..e38773f 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -51,6 +51,12 @@
 MODULE_PARM_DESC(disable_vendor_specific,
 		"Limit commands to the publicly specified set\n");
 
+static int default_dsm_family = -1;
+module_param(default_dsm_family, int, S_IRUGO);
+MODULE_PARM_DESC(default_dsm_family,
+		"Try this DSM type first when identifying NVDIMM family");
+
+
 LIST_HEAD(acpi_descs);
 DEFINE_MUTEX(acpi_desc_lock);
 
@@ -1367,7 +1373,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	struct device *dev = acpi_desc->dev;
 	unsigned long dsm_mask;
 	const u8 *uuid;
-	int i;
+	int i = -1;
 
 	/* nfit test assumes 1:1 relationship between commands and dsms */
 	nfit_mem->dsm_mask = acpi_desc->dimm_cmd_force_en;
@@ -1395,10 +1401,23 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	 * Until standardization materializes we need to consider 4
 	 * different command sets.  Note, that checking for function0 (bit0)
 	 * tells us if any commands are reachable through this uuid.
+	 * First check for a requested default.
 	 */
-	for (i = NVDIMM_FAMILY_INTEL; i <= NVDIMM_FAMILY_MSFT; i++)
-		if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1))
-			break;
+	if (default_dsm_family >= NVDIMM_FAMILY_INTEL &&
+			default_dsm_family <= NVDIMM_FAMILY_MSFT) {
+		if (acpi_check_dsm(adev_dimm->handle,
+				to_nfit_uuid(default_dsm_family), 1, 1))
+			i = default_dsm_family;
+		else
+			dev_dbg(dev, "default_dsm_family %d not supported\n",
+				default_dsm_family);
+	}
+	if (i == -1) {
+		for (i = NVDIMM_FAMILY_INTEL; i <= NVDIMM_FAMILY_MSFT; i++)
+			if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i),
+					1, 1))
+				break;
+	}
 
 	/* limit the supported commands to those that are publicly documented */
 	nfit_mem->family = i;
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
