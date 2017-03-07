Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-BL2-obe.outbound.protection.outlook.com
 (mail-bl2nam02on0725.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe46::725])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 40DC080348
 for <linux-nvdimm@lists.01.org>; Tue,  7 Mar 2017 13:35:38 -0800 (PST)
From: Linda Knippers <linda.knippers@hpe.com>
Subject: [PATCH 1/3] Allow override of built-in bitmasks for NVDIMM DSMs
Date: Tue, 7 Mar 2017 16:35:12 -0500
Message-ID: <d82a47c3a008e7e9f8a4d6262b99eda45f3b653b.1488921944.git.linda.knippers@hpe.com>
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

As it is today, we can't enable or test new NVDIMM management functions
provided by new firmware and tools without changing the kernel.  We also
can't prevent documented DSM functions from being called in the
case of buggy firmware.  This patch provides a module parameter that
overrides the DSM function mask that is built into the kernel.

If the "disable_vendor_specific" module parameter is also used
we ignore the new parameter.

Signed-off-by: Linda Knippers <linda.knippers@hpe.com>
---
 drivers/acpi/nfit/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 662036b..97d42ff 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -51,6 +51,10 @@
 MODULE_PARM_DESC(disable_vendor_specific,
 		"Limit commands to the publicly specified set\n");
 
+static unsigned long override_dsm_mask;
+module_param(override_dsm_mask, ulong, S_IRUGO);
+MODULE_PARM_DESC(override_dsm_mask, "Bitmask of allowed NVDIMM DSM functions");
+
 LIST_HEAD(acpi_descs);
 DEFINE_MUTEX(acpi_desc_lock);
 
@@ -1402,7 +1406,9 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 
 	/* limit the supported commands to those that are publicly documented */
 	nfit_mem->family = i;
-	if (nfit_mem->family == NVDIMM_FAMILY_INTEL) {
+	if (override_dsm_mask && !disable_vendor_specific)
+		dsm_mask = override_dsm_mask;
+	else if (nfit_mem->family == NVDIMM_FAMILY_INTEL) {
 		dsm_mask = 0x3fe;
 		if (disable_vendor_specific)
 			dsm_mask &= ~(1 << ND_CMD_VENDOR);
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
