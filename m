Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 204D62117CE94
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 08:17:31 -0800 (PST)
Subject: [PATCH] acpi, nfit: Fix ARS overflow continuation
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 06 Nov 2018 08:05:43 -0800
Message-ID: <154152034315.1304656.17798869260848445154.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jacek Zloch <jacek.zloch@intel.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When the platform BIOS is unable to report all the media error records
it requires the OS to restart the scrub at a prescribed location. The
driver detects the overflow condition, but then fails to report it to
the ARS state machine after reaping the records. Propagate -ENOSPC
correctly to continue the ARS operation.

Cc: <stable@vger.kernel.org>
Fixes: 1cf03c00e7c1 ("nfit: scrub and register regions in a workqueue")
Reported-by: Jacek Zloch <jacek.zloch@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index f8c638f3c946..5970b8f5f768 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2928,9 +2928,9 @@ static int acpi_nfit_query_poison(struct acpi_nfit_desc *acpi_desc)
 		return rc;
 
 	if (ars_status_process_records(acpi_desc))
-		return -ENOMEM;
+		dev_err(acpi_desc->dev, "Failed to process ARS records\n");
 
-	return 0;
+	return rc;
 }
 
 static int ars_register(struct acpi_nfit_desc *acpi_desc,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
