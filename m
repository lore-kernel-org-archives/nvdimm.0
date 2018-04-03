Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 30FE921FB7D37
 for <linux-nvdimm@lists.01.org>; Mon,  2 Apr 2018 21:56:03 -0700 (PDT)
Subject: [PATCH 1/6] nfit: fix region registration vs block-data-window ranges
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 02 Apr 2018 21:46:06 -0700
Message-ID: <152273076649.38372.8379231668189794225.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152273076087.38372.4803377088477706610.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152273076087.38372.4803377088477706610.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: stable@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Commit 1cf03c00e7c1 "nfit: scrub and register regions in a workqueue"
mistakenly attempts to register a region per BLK aperture. There is
nothing to register for individual apertures as they belong as a set to
a BLK aperture group that are registered with a corresponding
DIMM-control-region. Filter them for registration to prevent some
needless devm_kzalloc() allocations.

Cc: <stable@vger.kernel.org>
Fixes: 1cf03c00e7c1 ("nfit: scrub and register regions in a workqueue")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 12fb414fa678..ea9f3e727fef 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3018,15 +3018,21 @@ static void acpi_nfit_scrub(struct work_struct *work)
 static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
 {
 	struct nfit_spa *nfit_spa;
-	int rc;
 
-	list_for_each_entry(nfit_spa, &acpi_desc->spas, list)
-		if (nfit_spa_type(nfit_spa->spa) == NFIT_SPA_DCR) {
-			/* BLK regions don't need to wait for ars results */
-			rc = acpi_nfit_register_region(acpi_desc, nfit_spa);
-			if (rc)
-				return rc;
-		}
+	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
+		int rc, type = nfit_spa_type(nfit_spa->spa);
+
+		/* PMEM and VMEM will be registered by the ARS workqueue */
+		if (type == NFIT_SPA_PM || type == NFIT_SPA_VOLATILE)
+			continue;
+		/* BLK apertures belong to BLK region registration below */
+		if (type == NFIT_SPA_BDW)
+			continue;
+		/* BLK regions don't need to wait for ARS results */
+		rc = acpi_nfit_register_region(acpi_desc, nfit_spa);
+		if (rc)
+			return rc;
+	}
 
 	acpi_desc->ars_start_flags = 0;
 	if (!acpi_desc->cancel)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
