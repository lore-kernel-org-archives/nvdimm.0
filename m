Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BDB041A1E06
 for <linux-nvdimm@lists.01.org>; Fri,  2 Sep 2016 16:28:12 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] nfit, mce: Fix SPA matching logic in MCE handler
Date: Fri,  2 Sep 2016 17:27:30 -0600
Message-Id: <1472858850-8807-1-git-send-email-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The check for a 'pmem' type SPA in the MCE handler was inverted due to a
merge/rebase error.

Fixes: 6839a6d nfit: do an ARS scrub on hitting a latent media error
Cc: linux-acpi@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/acpi/nfit/mce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
index 0dfe50e..05005e2 100644
--- a/drivers/acpi/nfit/mce.c
+++ b/drivers/acpi/nfit/mce.c
@@ -43,7 +43,7 @@ static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
 		list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
 			struct acpi_nfit_system_address *spa = nfit_spa->spa;
 
-			if (nfit_spa_type(spa) == NFIT_SPA_PM)
+			if (nfit_spa_type(spa) != NFIT_SPA_PM)
 				continue;
 			/* find the spa that covers the mce addr */
 			if (spa->address > mce->addr)
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
