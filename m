Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A1C5220886FCB
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 12:22:49 -0800 (PST)
Subject: [PATCH 1/6] nfit/ars: Attempt a short-ARS whenever the ARS state is
 idle at boot
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Feb 2019 12:10:10 -0800
Message-ID: <155017501057.944049.2284804890743224154.stgit@dwillia2-desk3.amr.corp.intel.com>
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
