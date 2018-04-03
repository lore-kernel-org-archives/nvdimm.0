Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 223FF21FB7D3A
 for <linux-nvdimm@lists.01.org>; Mon,  2 Apr 2018 21:56:29 -0700 (PDT)
Subject: [PATCH 6/6] nfit,
 address-range-scrub: add module option to skip initial ars
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 02 Apr 2018 21:46:33 -0700
Message-ID: <152273079304.38372.3756477895030033611.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

After attempting to quickly retrieve known errors the kernel proceeds to
kick off a long running ARS. Add a module option to disable this
behavior at initialization time, or at new region discovery time.
Otherwise, ARS can be started manually regardless of the state of this
setting.

Co-developed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 29a033f3455d..848e05b25d7d 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -49,6 +49,10 @@ module_param(default_dsm_family, int, S_IRUGO);
 MODULE_PARM_DESC(default_dsm_family,
 		"Try this DSM type first when identifying NVDIMM family");
 
+static int no_init_ars;
+module_param(no_init_ars, int, 0644);
+MODULE_PARM_DESC(no_init_ars, "Skip ARS run at nfit init time");
+
 LIST_HEAD(acpi_descs);
 DEFINE_MUTEX(acpi_desc_lock);
 
@@ -2868,8 +2872,11 @@ static int init_ars(struct acpi_nfit_desc *acpi_desc, struct nfit_spa *nfit_spa,
 
 	WARN_ON_ONCE(!test_bit(ARS_SHORT, &nfit_spa->ars_state));
 	rc = ars_start(acpi_desc, nfit_spa);
-	if (rc == 0)
+	if (rc == 0) {
 		rc = acpi_nfit_query_poison(acpi_desc, nfit_spa);
+		if (!no_init_ars)
+			set_bit(ARS_REQ, &nfit_spa->ars_state);
+	}
 out:
 	if (acpi_nfit_register_region(acpi_desc, nfit_spa))
 		set_bit(ARS_FAILED, &nfit_spa->ars_state);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
