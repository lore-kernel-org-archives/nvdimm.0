Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4D5C2194EB78
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 11:56:30 -0800 (PST)
Subject: [PATCH v2 1/6] nfit/ars: Attempt a short-ARS whenever the ARS state
 is idle at boot
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Feb 2019 11:43:52 -0800
Message-ID: <155025983247.1043225.5927153534700111609.stgit@dwillia2-desk3.amr.corp.intel.com>
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

If query-ARS reports that ARS has stopped and requires continuation
attempt to retrieve short-ARS results before continuing the long
operation.

Reported-by: Krzysztof Rusocki <krzysztof.rusocki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index e18ade5d74e9..3d681a92ff7f 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3012,6 +3012,7 @@ static int ars_register(struct acpi_nfit_desc *acpi_desc,
 
 	switch (acpi_nfit_query_poison(acpi_desc)) {
 	case 0:
+	case -ENOSPC:
 	case -EAGAIN:
 		rc = ars_start(acpi_desc, nfit_spa, ARS_REQ_SHORT);
 		/* shouldn't happen, try again later */
@@ -3036,7 +3037,6 @@ static int ars_register(struct acpi_nfit_desc *acpi_desc,
 		break;
 	case -EBUSY:
 	case -ENOMEM:
-	case -ENOSPC:
 		/*
 		 * BIOS was using ARS, wait for it to complete (or
 		 * resources to become available) and then perform our

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
