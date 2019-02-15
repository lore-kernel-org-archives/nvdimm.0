Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DC74D2194EB78
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 11:56:35 -0800 (PST)
Subject: [PATCH v2 2/6] nfit/ars: Attempt short-ARS even in the no_init_ars
 case
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Feb 2019 11:43:57 -0800
Message-ID: <155025983758.1043225.7069046151889688538.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Erwin Tsaur <erwin.tsaur@oracle.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The no_init_ars option is meant to prevent long-ARS, but short-ARS
should be allowed to grab any immediate results.

Reported-by: Erwin Tsaur <erwin.tsaur@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 3d681a92ff7f..934be96dc149 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3004,11 +3004,12 @@ static int ars_register(struct acpi_nfit_desc *acpi_desc,
 {
 	int rc;
 
-	if (no_init_ars || test_bit(ARS_FAILED, &nfit_spa->ars_state))
+	if (test_bit(ARS_FAILED, &nfit_spa->ars_state))
 		return acpi_nfit_register_region(acpi_desc, nfit_spa);
 
 	set_bit(ARS_REQ_SHORT, &nfit_spa->ars_state);
-	set_bit(ARS_REQ_LONG, &nfit_spa->ars_state);
+	if (!no_init_ars)
+		set_bit(ARS_REQ_LONG, &nfit_spa->ars_state);
 
 	switch (acpi_nfit_query_poison(acpi_desc)) {
 	case 0:

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
