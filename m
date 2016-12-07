Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A768F81FD4
 for <linux-nvdimm@lists.01.org>; Tue,  6 Dec 2016 16:43:45 -0800 (PST)
Subject: [PATCH 3/5] acpi, nfit: validate ars_status output buffer size
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 06 Dec 2016 16:39:36 -0800
Message-ID: <148107117614.25138.4254032116058462860.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148107115997.25138.3445497812509173966.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148107115997.25138.3445497812509173966.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

If an ARS Status command returns truncated output, do not process
partial records or otherwise consume non-status fields.

Cc: <stable@vger.kernel.org>
Fixes: 0caeef63e6d2 ("libnvdimm: Add a poison list and export badblocks")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index e58ec32393b7..4b8b4f520d76 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -146,7 +146,8 @@ static int xlat_status(void *buf, unsigned int cmd, u32 status)
 		 * then just continue with the returned results.
 		 */
 		if (status == NFIT_ARS_STATUS_INTR) {
-			if (ars_status->flags & NFIT_ARS_F_OVERFLOW)
+			if (ars_status->out_length >= 40 && (ars_status->flags
+						& NFIT_ARS_F_OVERFLOW))
 				return -ENOSPC;
 			return 0;
 		}
@@ -2002,19 +2003,32 @@ static int ars_get_status(struct acpi_nfit_desc *acpi_desc)
 	return cmd_rc;
 }
 
-static int ars_status_process_records(struct nvdimm_bus *nvdimm_bus,
+static int ars_status_process_records(struct acpi_nfit_desc *acpi_desc,
 		struct nd_cmd_ars_status *ars_status)
 {
+	struct nvdimm_bus *nvdimm_bus = acpi_desc->nvdimm_bus;
 	int rc;
 	u32 i;
 
+	/*
+	 * First record starts at 44 byte offset from the start of the
+	 * payload.
+	 */
+	if (ars_status->out_length < 44)
+		return 0;
 	for (i = 0; i < ars_status->num_records; i++) {
+		/* only process full records */
+		if (ars_status->out_length
+				< 44 + sizeof(struct nd_ars_record) * (i + 1))
+			break;
 		rc = nvdimm_bus_add_poison(nvdimm_bus,
 				ars_status->records[i].err_address,
 				ars_status->records[i].length);
 		if (rc)
 			return rc;
 	}
+	if (i < ars_status->num_records)
+		dev_warn(acpi_desc->dev, "detected truncated ars results\n");
 
 	return 0;
 }
@@ -2267,8 +2281,7 @@ static int acpi_nfit_query_poison(struct acpi_nfit_desc *acpi_desc,
 	if (rc < 0 && rc != -ENOSPC)
 		return rc;
 
-	if (ars_status_process_records(acpi_desc->nvdimm_bus,
-				acpi_desc->ars_status))
+	if (ars_status_process_records(acpi_desc, acpi_desc->ars_status))
 		return -ENOMEM;
 
 	return 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
