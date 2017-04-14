Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7053A2194EB66
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 10:04:22 -0700 (PDT)
Subject: [PATCH 5/5] acpi, nfit: limit ->flush_probe() to initialization work
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 09:58:38 -0700
Message-ID: <149218911796.3926.17292323458849061393.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149218909065.3926.1234846095650907678.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149218909065.3926.1234846095650907678.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The nvdimm probe flushing mechanism gives userspace a sync point where
it knows all asynchronous driver probe sequences have completed.
However, it need not wait for other asynchronous actions, like
on-demand address-range-scrub. Track the init work separately from other
work in the workqueue, and only flush the former.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   13 ++++++++++---
 drivers/acpi/nfit/nfit.h |    1 +
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 06738df477db..17cac9d369e0 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -738,7 +738,7 @@ static void nfit_mem_init_bdw(struct acpi_nfit_desc *acpi_desc,
 	}
 }
 
-static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
+static int __nfit_mem_init(struct acpi_nfit_desc *acpi_desc,
 		struct acpi_nfit_system_address *spa)
 {
 	struct nfit_mem *nfit_mem, *found;
@@ -898,7 +898,7 @@ static int nfit_mem_init(struct acpi_nfit_desc *acpi_desc)
 	 * BDWs are optional.
 	 */
 	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
-		rc = nfit_mem_dcr_init(acpi_desc, nfit_spa->spa);
+		rc = __nfit_mem_init(acpi_desc, nfit_spa->spa);
 		if (rc)
 			return rc;
 	}
@@ -908,7 +908,7 @@ static int nfit_mem_init(struct acpi_nfit_desc *acpi_desc)
 	 * SPA entries above. Find and register all the unmapped DIMMs
 	 * for reporting and recovery purposes.
 	 */
-	rc = nfit_mem_dcr_init(acpi_desc, NULL);
+	rc = __nfit_mem_init(acpi_desc, NULL);
 	if (rc)
 		return rc;
 
@@ -2568,6 +2568,7 @@ static void acpi_nfit_scrub(struct work_struct *work)
 			acpi_nfit_register_region(acpi_desc, nfit_spa);
 		}
 	}
+	acpi_desc->init_complete = 1;
 
 	list_for_each_entry(nfit_spa, &acpi_desc->spas, list)
 		acpi_nfit_async_scrub(acpi_desc, nfit_spa);
@@ -2771,6 +2772,12 @@ static int acpi_nfit_flush_probe(struct nvdimm_bus_descriptor *nd_desc)
 	device_lock(dev);
 	device_unlock(dev);
 
+	/* bounce the init_mutex to make init_complete valid */
+	mutex_lock(&acpi_desc->init_mutex);
+	mutex_unlock(&acpi_desc->init_mutex);
+	if (acpi_desc->init_complete)
+		return 0;
+
 	/*
 	 * Scrub work could take 10s of seconds, userspace may give up so we
 	 * need to be interruptible while waiting.
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index fc29c2e9832e..256829597585 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -163,6 +163,7 @@ struct acpi_nfit_desc {
 	unsigned int scrub_count;
 	unsigned int scrub_mode;
 	unsigned int cancel:1;
+	unsigned int init_complete:1;
 	unsigned long dimm_cmd_force_en;
 	unsigned long bus_cmd_force_en;
 	int (*blk_do_io)(struct nd_blk_region *ndbr, resource_size_t dpa,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
