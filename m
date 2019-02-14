Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DC46920886FE7
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 12:23:15 -0800 (PST)
Subject: [PATCH 6/6] nfit/ars: Avoid stale ARS results
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Feb 2019 12:10:37 -0800
Message-ID: <155017503725.944049.1596090801791232896.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155017500427.944049.2254497897075714747.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155017500427.944049.2254497897075714747.stgit@dwillia2-desk3.amr.corp.intel.com>
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
index 612cf5d92e25..2a49051d5317 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2650,7 +2650,10 @@ static int ars_start(struct acpi_nfit_desc *acpi_desc,
 
 	if (rc < 0)
 		return rc;
-	return cmd_rc;
+	if (cmd_rc < 0)
+		return cmd_rc;
+	set_bit(ARS_VALID, &acpi_desc->scrub_flags);
+	return 0;
 }
 
 static int ars_continue(struct acpi_nfit_desc *acpi_desc)
@@ -2743,6 +2746,17 @@ static int ars_status_process_records(struct acpi_nfit_desc *acpi_desc)
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
@@ -3226,6 +3240,7 @@ static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
 	struct nfit_spa *nfit_spa;
 	int rc;
 
+	set_bit(ARS_VALID, &acpi_desc->scrub_flags);
 	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
 		switch (nfit_spa_type(nfit_spa->spa)) {
 		case NFIT_SPA_VOLATILE:
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 897ce10192a0..1efd248104e0 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -213,6 +213,7 @@ struct nfit_mem {
 enum scrub_flags {
 	ARS_BUSY,
 	ARS_CANCEL,
+	ARS_VALID,
 };
 
 struct acpi_nfit_desc {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
