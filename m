Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F03E202E531F
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 11:56:57 -0800 (PST)
Subject: [PATCH v2 6/6] nfit/ars: Avoid stale ARS results
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Feb 2019 11:44:18 -0800
Message-ID: <155025985870.1043225.8854289247736261912.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, Krzysztof Rusocki <krzysztof.rusocki@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Gate ARS result consumption on whether the OS issued start-ARS since the
previous consumption. The BIOS may only clear its result buffers after a
successful start-ARS.

Reported-by: Krzysztof Rusocki <krzysztof.rusocki@intel.com>
Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   17 ++++++++++++++++-
 drivers/acpi/nfit/nfit.h |    1 +
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 629cf91649d2..5c9eb8d700d3 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2652,7 +2652,10 @@ static int ars_start(struct acpi_nfit_desc *acpi_desc,
 
 	if (rc < 0)
 		return rc;
-	return cmd_rc;
+	if (cmd_rc < 0)
+		return cmd_rc;
+	set_bit(ARS_VALID, &acpi_desc->scrub_flags);
+	return 0;
 }
 
 static int ars_continue(struct acpi_nfit_desc *acpi_desc)
@@ -2745,6 +2748,17 @@ static int ars_status_process_records(struct acpi_nfit_desc *acpi_desc)
 	 */
 	if (ars_status->out_length < 44)
 		return 0;
+
+	/*
+	 * Ignore potentially stale results that are only refreshed
+	 * after a start-ARS event.
+	 */
+	if (!test_and_clear_bit(ARS_VALID, &acpi_desc->scrub_flags)) {
+		dev_dbg(acpi_desc->dev, "skip %d stale records\n",
+				ars_status->num_records);
+		return 0;
+	}
+
 	for (i = 0; i < ars_status->num_records; i++) {
 		/* only process full records */
 		if (ars_status->out_length
@@ -3229,6 +3243,7 @@ static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
 	struct nfit_spa *nfit_spa;
 	int rc;
 
+	set_bit(ARS_VALID, &acpi_desc->scrub_flags);
 	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
 		switch (nfit_spa_type(nfit_spa->spa)) {
 		case NFIT_SPA_VOLATILE:
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index d14bad687fb8..0cbe5009eb2c 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -213,6 +213,7 @@ struct nfit_mem {
 enum scrub_flags {
 	ARS_BUSY,
 	ARS_CANCEL,
+	ARS_VALID,
 	ARS_POLL,
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
