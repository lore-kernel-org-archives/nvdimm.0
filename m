Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85588226FAA85
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 21:28:53 -0700 (PDT)
Subject: [ndctl PATCH v2 1/3] nfit,
 address-range-scrub: determine one platform max_ars value
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 05 Apr 2018 21:18:57 -0700
Message-ID: <152298833688.13386.7576881427707042306.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152298833162.13386.16059994933936258291.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152298833162.13386.16059994933936258291.stgit@dwillia2-desk3.amr.corp.intel.com>
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

acpi_nfit_query_poison() is awkward in that it requires an nfit_spa
argument in order to determine what max_ars value to use. Instead probe
for the minimum max_ars across all scrub-capable ranges in the system
and drop the nfit_spa argument.

This enables a larger rework / simplification of the ARS state machine
whereby the status can be retrieved once and then iterated over all
address ranges to reap completions.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   78 ++++++++++++++++++++++++----------------------
 drivers/acpi/nfit/nfit.h |    2 +
 2 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 9c56022c216f..866853abebea 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2494,16 +2494,16 @@ static int ars_get_status(struct acpi_nfit_desc *acpi_desc)
 	int rc, cmd_rc;
 
 	rc = nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_STATUS, ars_status,
-			acpi_desc->ars_status_size, &cmd_rc);
+			acpi_desc->max_ars, &cmd_rc);
 	if (rc < 0)
 		return rc;
 	return cmd_rc;
 }
 
-static int ars_status_process_records(struct acpi_nfit_desc *acpi_desc,
-		struct nd_cmd_ars_status *ars_status)
+static int ars_status_process_records(struct acpi_nfit_desc *acpi_desc)
 {
 	struct nvdimm_bus *nvdimm_bus = acpi_desc->nvdimm_bus;
+	struct nd_cmd_ars_status *ars_status = acpi_desc->ars_status;
 	int rc;
 	u32 i;
 
@@ -2739,60 +2739,35 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 	return rc;
 }
 
-static int ars_status_alloc(struct acpi_nfit_desc *acpi_desc,
-		u32 max_ars)
+static int ars_status_alloc(struct acpi_nfit_desc *acpi_desc)
 {
 	struct device *dev = acpi_desc->dev;
 	struct nd_cmd_ars_status *ars_status;
 
-	if (acpi_desc->ars_status && acpi_desc->ars_status_size >= max_ars) {
-		memset(acpi_desc->ars_status, 0, acpi_desc->ars_status_size);
+	if (acpi_desc->ars_status) {
+		memset(acpi_desc->ars_status, 0, acpi_desc->max_ars);
 		return 0;
 	}
 
-	if (acpi_desc->ars_status)
-		devm_kfree(dev, acpi_desc->ars_status);
-	acpi_desc->ars_status = NULL;
-	ars_status = devm_kzalloc(dev, max_ars, GFP_KERNEL);
+	ars_status = devm_kzalloc(dev, acpi_desc->max_ars, GFP_KERNEL);
 	if (!ars_status)
 		return -ENOMEM;
 	acpi_desc->ars_status = ars_status;
-	acpi_desc->ars_status_size = max_ars;
 	return 0;
 }
 
-static int acpi_nfit_query_poison(struct acpi_nfit_desc *acpi_desc,
-		struct nfit_spa *nfit_spa)
+static int acpi_nfit_query_poison(struct acpi_nfit_desc *acpi_desc)
 {
-	struct acpi_nfit_system_address *spa = nfit_spa->spa;
 	int rc;
 
-	if (!nfit_spa->max_ars) {
-		struct nd_cmd_ars_cap ars_cap;
-
-		memset(&ars_cap, 0, sizeof(ars_cap));
-		rc = ars_get_cap(acpi_desc, &ars_cap, nfit_spa);
-		if (rc < 0)
-			return rc;
-		nfit_spa->max_ars = ars_cap.max_ars_out;
-		nfit_spa->clear_err_unit = ars_cap.clear_err_unit;
-		/* check that the supported scrub types match the spa type */
-		if (nfit_spa_type(spa) == NFIT_SPA_VOLATILE &&
-				((ars_cap.status >> 16) & ND_ARS_VOLATILE) == 0)
-			return -ENOTTY;
-		else if (nfit_spa_type(spa) == NFIT_SPA_PM &&
-				((ars_cap.status >> 16) & ND_ARS_PERSISTENT) == 0)
-			return -ENOTTY;
-	}
-
-	if (ars_status_alloc(acpi_desc, nfit_spa->max_ars))
+	if (ars_status_alloc(acpi_desc))
 		return -ENOMEM;
 
 	rc = ars_get_status(acpi_desc);
 	if (rc < 0 && rc != -ENOSPC)
 		return rc;
 
-	if (ars_status_process_records(acpi_desc, acpi_desc->ars_status))
+	if (ars_status_process_records(acpi_desc))
 		return -ENOMEM;
 
 	return 0;
@@ -2824,7 +2799,7 @@ static void acpi_nfit_async_scrub(struct acpi_nfit_desc *acpi_desc,
 
 		if (acpi_desc->cancel)
 			break;
-		rc = acpi_nfit_query_poison(acpi_desc, nfit_spa);
+		rc = acpi_nfit_query_poison(acpi_desc);
 		if (rc == -ENOTTY)
 			break;
 		if (rc == -EBUSY && !tmo) {
@@ -2925,7 +2900,7 @@ static void acpi_nfit_scrub(struct work_struct *work)
 			 */
 			rc = 0;
 		} else
-			rc = acpi_nfit_query_poison(acpi_desc, nfit_spa);
+			rc = acpi_nfit_query_poison(acpi_desc);
 
 		if (rc == -ENOTTY) {
 			/* no ars capability, just register spa and move on */
@@ -3018,6 +2993,31 @@ static void acpi_nfit_scrub(struct work_struct *work)
 	mutex_unlock(&acpi_desc->init_mutex);
 }
 
+static void acpi_nfit_init_ars(struct acpi_nfit_desc *acpi_desc,
+		struct nfit_spa *nfit_spa)
+{
+	int type = nfit_spa_type(nfit_spa->spa);
+	struct nd_cmd_ars_cap ars_cap;
+	int rc;
+
+	memset(&ars_cap, 0, sizeof(ars_cap));
+	rc = ars_get_cap(acpi_desc, &ars_cap, nfit_spa);
+	if (rc < 0)
+		return;
+	/* check that the supported scrub types match the spa type */
+	if (type == NFIT_SPA_VOLATILE && ((ars_cap.status >> 16)
+				& ND_ARS_VOLATILE) == 0)
+		return;
+	if (type == NFIT_SPA_PM && ((ars_cap.status >> 16)
+				& ND_ARS_PERSISTENT) == 0)
+		return;
+
+	nfit_spa->max_ars = ars_cap.max_ars_out;
+	nfit_spa->clear_err_unit = ars_cap.clear_err_unit;
+	acpi_desc->max_ars = max(nfit_spa->max_ars, acpi_desc->max_ars);
+}
+
+
 static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
 {
 	struct nfit_spa *nfit_spa;
@@ -3026,8 +3026,10 @@ static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
 		int rc, type = nfit_spa_type(nfit_spa->spa);
 
 		/* PMEM and VMEM will be registered by the ARS workqueue */
-		if (type == NFIT_SPA_PM || type == NFIT_SPA_VOLATILE)
+		if (type == NFIT_SPA_PM || type == NFIT_SPA_VOLATILE) {
+			acpi_nfit_init_ars(acpi_desc, nfit_spa);
 			continue;
+		}
 		/* BLK apertures belong to BLK region registration below */
 		if (type == NFIT_SPA_BDW)
 			continue;
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 2b97e5f76bdf..45e7949986a8 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -197,10 +197,10 @@ struct acpi_nfit_desc {
 	struct device *dev;
 	u8 ars_start_flags;
 	struct nd_cmd_ars_status *ars_status;
-	size_t ars_status_size;
 	struct work_struct work;
 	struct list_head list;
 	struct kernfs_node *scrub_count_state;
+	unsigned int max_ars;
 	unsigned int scrub_count;
 	unsigned int scrub_mode;
 	unsigned int cancel:1;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
