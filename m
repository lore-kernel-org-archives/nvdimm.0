Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 38A6A2194EB78
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 11:56:41 -0800 (PST)
Subject: [PATCH v2 3/6] nfit/ars: Remove ars_start_flags
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Feb 2019 11:44:02 -0800
Message-ID: <155025984267.1043225.13642468395161111076.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155025982726.1043225.15436410616433285475.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155025982726.1043225.15436410616433285475.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The ars_start_flags property of 'struct acpi_nfit_desc' is no longer
used since ARS_REQ_SHORT and ARS_REQ_LONG were added.

Cc: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   10 +++++-----
 drivers/acpi/nfit/nfit.h |    1 -
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 934be96dc149..9a23ae74e82b 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2651,11 +2651,11 @@ static int ars_continue(struct acpi_nfit_desc *acpi_desc)
 	struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
 	struct nd_cmd_ars_status *ars_status = acpi_desc->ars_status;
 
-	memset(&ars_start, 0, sizeof(ars_start));
-	ars_start.address = ars_status->restart_address;
-	ars_start.length = ars_status->restart_length;
-	ars_start.type = ars_status->type;
-	ars_start.flags = acpi_desc->ars_start_flags;
+	ars_start = (struct nd_cmd_ars_start) {
+		.address = ars_status->restart_address,
+		.length = ars_status->restart_length,
+		.type = ars_status->type,
+	};
 	rc = nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_START, &ars_start,
 			sizeof(ars_start), &cmd_rc);
 	if (rc < 0)
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 33691aecfcee..871fb3de3b30 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -223,7 +223,6 @@ struct acpi_nfit_desc {
 	struct list_head idts;
 	struct nvdimm_bus *nvdimm_bus;
 	struct device *dev;
-	u8 ars_start_flags;
 	struct nd_cmd_ars_status *ars_status;
 	struct nfit_spa *scrub_spa;
 	struct delayed_work dwork;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
