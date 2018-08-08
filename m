Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com
 [IPv6:2607:f8b0:4864:20::442])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 07AB9210E1292
 for <linux-nvdimm@lists.01.org>; Wed,  8 Aug 2018 07:50:35 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j8-v6so1259639pff.6
 for <linux-nvdimm@lists.01.org>; Wed, 08 Aug 2018 07:50:35 -0700 (PDT)
From: Ocean He <oceanhehy@gmail.com>
Subject: [PATCH] ACPI: nfit: check dcr immediately following its assignment
 codes
Date: Wed,  8 Aug 2018 10:50:21 -0400
Message-Id: <1533739821-9864-1-git-send-email-oceanhehy@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com, rjw@rjwysocki.net, lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, Ocean He <hehy1@lenovo.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Ocean He <hehy1@lenovo.com>

In commit 6697b2cf69d43632 ("nfit: fix multi-interface dimm handling,
acpi6.1 compatibility"), the check codes of dcr were just following its
assignment codes. But they were separated by commit ad9ac5e1957531a8
("nfit: always associate flush hints").

Just change the check codes back to original position, without function
change.

Signed-off-by: Ocean He <hehy1@lenovo.com>
---
 drivers/acpi/nfit/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 7c47900..c9e4c9a 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1078,6 +1078,12 @@ static int __nfit_mem_init(struct acpi_nfit_desc *acpi_desc,
 			break;
 		}
 
+		if (dcr && !nfit_mem->dcr) {
+			dev_err(acpi_desc->dev, "SPA %d missing DCR %d\n",
+					spa->range_index, dcr);
+			return -ENODEV;
+		}
+
 		list_for_each_entry(nfit_flush, &acpi_desc->flushes, list) {
 			struct acpi_nfit_flush_address *flush;
 			u16 i;
@@ -1101,12 +1107,6 @@ static int __nfit_mem_init(struct acpi_nfit_desc *acpi_desc,
 			break;
 		}
 
-		if (dcr && !nfit_mem->dcr) {
-			dev_err(acpi_desc->dev, "SPA %d missing DCR %d\n",
-					spa->range_index, dcr);
-			return -ENODEV;
-		}
-
 		if (type == NFIT_SPA_DCR) {
 			struct nfit_idt *nfit_idt;
 			u16 idt_idx;
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
