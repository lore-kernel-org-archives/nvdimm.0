Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6CBCB21167463
 for <linux-nvdimm@lists.01.org>; Mon, 15 Oct 2018 13:57:49 -0700 (PDT)
Subject: [PATCH] acpi, nfit: Further restrict userspace ARS start requests
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Oct 2018 13:46:01 -0700
Message-ID: <153963636159.2102929.5769352106580143614.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In addition to not allowing ARS start while the background thread is
actively running, prevent ARS start while any scrub request is pending.

This aligns the window for ARS start submission with the status of ARS
reported via sysfs. Previously userspace could sneak its own ARS start
requests in while sysfs reported -EBUSY.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index f7efcd9843e0..0eaf934ca624 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3364,6 +3364,8 @@ static int __acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd)
 {
 	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
+	struct nfit_spa *nfit_spa;
+	int rc = 0;
 
 	if (nvdimm)
 		return 0;
@@ -3373,13 +3375,22 @@ static int __acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
 	/*
 	 * The kernel and userspace may race to initiate a scrub, but
 	 * the scrub thread is prepared to lose that initial race.  It
-	 * just needs guarantees that any ars it initiates are not
-	 * interrupted by any intervening start reqeusts from userspace.
+	 * just needs guarantees that any ARS it initiates are not
+	 * interrupted by any intervening start requests from userspace.
 	 */
-	if (work_busy(&acpi_desc->dwork.work))
-		return -EBUSY;
+	mutex_lock(&acpi_desc->init_mutex);
+	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
+		if (test_bit(ARS_REQ_SHORT, &nfit_spa->ars_state)) {
+			rc = -EBUSY;
+			break;
+		} else if (test_bit(ARS_REQ_LONG, &nfit_spa->ars_state)) {
+			rc = -EBUSY;
+			break;
+		}
+	}
+	mutex_unlock(&acpi_desc->init_mutex);
 
-	return 0;
+	return rc;
 }
 
 /* prevent security commands from being issued via ioctl */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
