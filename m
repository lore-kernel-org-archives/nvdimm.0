Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E76E8226516B9
 for <linux-nvdimm@lists.01.org>; Sat,  7 Apr 2018 08:56:03 -0700 (PDT)
Subject: [PATCH v3 3/3] nfit,
 address-range-scrub: add module option to skip initial ars
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 07 Apr 2018 08:46:07 -0700
Message-ID: <152311596756.35426.7076649397069507532.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152311595210.35426.13667585208560808244.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152311595210.35426.13667585208560808244.stgit@dwillia2-desk3.amr.corp.intel.com>
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

After attempting to quickly retrieve known errors the kernel proceeds to
kick off a long running ARS. Add a module option to disable this
behavior at initialization time, or at new region discovery time.
Otherwise, ARS can be started manually regardless of the state of this
setting.

Co-developed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 2532294bbd68..7f3c70fde9a8 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -49,6 +49,10 @@ module_param(default_dsm_family, int, S_IRUGO);
 MODULE_PARM_DESC(default_dsm_family,
 		"Try this DSM type first when identifying NVDIMM family");
 
+static bool no_init_ars;
+module_param(no_init_ars, bool, 0644);
+MODULE_PARM_DESC(no_init_ars, "Skip ARS run at nfit init time");
+
 LIST_HEAD(acpi_descs);
 DEFINE_MUTEX(acpi_desc_lock);
 
@@ -2816,6 +2820,9 @@ static int ars_register(struct acpi_nfit_desc *acpi_desc, struct nfit_spa *nfit_
 {
 	int rc = *query_rc;
 
+	if (no_init_ars)
+		return acpi_nfit_register_region(acpi_desc, nfit_spa);
+
 	set_bit(ARS_REQ, &nfit_spa->ars_state);
 	set_bit(ARS_SHORT, &nfit_spa->ars_state);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
