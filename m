Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F17EF223FCF48
 for <linux-nvdimm@lists.01.org>; Wed, 21 Mar 2018 21:44:58 -0700 (PDT)
Subject: [PATCH] nfit: skip region registration for incomplete control regions
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 21 Mar 2018 21:42:24 -0700
Message-ID: <152169374458.19742.14326187212131249042.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Per the ACPI specification the only functional purpose for a DIMM
Control Region to be mapped into the system physical address space, from
an OSPM perspective, is to support block-apertures. However, there are
some BIOSen that publish DIMM Control Region SPA entries for pre-boot
environment consumption.  Undo the kernel policy of generating disabled
'ndblk' regions when this configuration is detected.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 39ad06143e78..4530d89044db 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2578,7 +2578,7 @@ static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
 	struct acpi_nfit_system_address *spa = nfit_spa->spa;
 	struct nd_blk_region_desc *ndbr_desc;
 	struct nfit_mem *nfit_mem;
-	int blk_valid = 0, rc;
+	int rc;
 
 	if (!nvdimm) {
 		dev_err(acpi_desc->dev, "spa%d dimm: %#x not found\n",
@@ -2598,15 +2598,14 @@ static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
 		if (!nfit_mem || !nfit_mem->bdw) {
 			dev_dbg(acpi_desc->dev, "spa%d %s missing bdw\n",
 					spa->range_index, nvdimm_name(nvdimm));
-		} else {
-			mapping->size = nfit_mem->bdw->capacity;
-			mapping->start = nfit_mem->bdw->start_address;
-			ndr_desc->num_lanes = nfit_mem->bdw->windows;
-			blk_valid = 1;
+			break;
 		}
 
+		mapping->size = nfit_mem->bdw->capacity;
+		mapping->start = nfit_mem->bdw->start_address;
+		ndr_desc->num_lanes = nfit_mem->bdw->windows;
 		ndr_desc->mapping = mapping;
-		ndr_desc->num_mappings = blk_valid;
+		ndr_desc->num_mappings = 1;
 		ndbr_desc = to_blk_region_desc(ndr_desc);
 		ndbr_desc->enable = acpi_nfit_blk_region_enable;
 		ndbr_desc->do_io = acpi_desc->blk_do_io;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
