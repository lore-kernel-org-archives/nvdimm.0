Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6C301211B7F72
 for <linux-nvdimm@lists.01.org>; Tue, 15 Jan 2019 17:48:27 -0800 (PST)
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: [PATCH] acpi/nfit: not set nfit_mem when it is found
Date: Wed, 16 Jan 2019 09:48:07 +0800
Message-Id: <20190116014807.11195-1-richardw.yang@linux.intel.com>
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
Cc: zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In __nfit_mem_init(), one nfit_mem will be created in case we can't find
one nfit_mem with matched device_handle. The variable *found* indicates
this research result.

If we found one, variable *found* is set to non-NULL and variable
*nfit_mem* already points to the data structure we want to set up. This
is not necessary to reset variable *nfit_mem* to *found* again.

This patch removes the assignment of *nfit_mem* to *found* when they are
the same.

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
---
 drivers/acpi/nfit/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 9c3c2d2f37be..4643aa10ed2a 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1053,9 +1053,7 @@ static int __nfit_mem_init(struct acpi_nfit_desc *acpi_desc,
 				break;
 			}
 
-		if (found)
-			nfit_mem = found;
-		else {
+		if (!found) {
 			nfit_mem = devm_kzalloc(acpi_desc->dev,
 					sizeof(*nfit_mem), GFP_KERNEL);
 			if (!nfit_mem)
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
