Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam03on0714.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe48::714])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 08F48820D3
 for <linux-nvdimm@lists.01.org>; Mon, 13 Feb 2017 08:28:17 -0800 (PST)
From: Linda Knippers <linda.knippers@hpe.com>
Subject: [PATCH 1/3] Allow all supported HPE DSM functions to be called
Date: Mon, 13 Feb 2017 11:27:47 -0500
Message-ID: <5d86cd3620ca9eb3cda38cce0401b2984526cad7.1486750247.git.linda.knippers@hpe.com>
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

As it is today, we can't enable or test new functions in firmware without
changing the kernel.

With this patch we allow function 0 for the HPE DSM families,
as is already allowed with the MS family. We now only restrict
the functions to the currently documented set if the module parameter
"disable_vendor_specific" is set.  Since the module parameter
description says "Limit commands to the publicly specified set",
this approach seems correct.

Signed-off-by: Linda Knippers <linda.knippers@hpe.com>
---
 drivers/acpi/nfit/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 7361d00..b80d4d9 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1407,11 +1407,13 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		if (disable_vendor_specific)
 			dsm_mask &= ~(1 << ND_CMD_VENDOR);
 	} else if (nfit_mem->family == NVDIMM_FAMILY_HPE1) {
-		dsm_mask = 0x1c3c76;
+		dsm_mask = 0xffffffff;
+		if (disable_vendor_specific)
+			dsm_mask &= ~(0x1c3c77);
 	} else if (nfit_mem->family == NVDIMM_FAMILY_HPE2) {
-		dsm_mask = 0x1fe;
+		dsm_mask = 0xffffffff;
 		if (disable_vendor_specific)
-			dsm_mask &= ~(1 << 8);
+			dsm_mask &= ~(0x0ff);
 	} else if (nfit_mem->family == NVDIMM_FAMILY_MSFT) {
 		dsm_mask = 0xffffffff;
 	} else {
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
