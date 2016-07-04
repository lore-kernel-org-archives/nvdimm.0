Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E51C81A1E00
 for <linux-nvdimm@lists.01.org>; Sun,  3 Jul 2016 21:39:14 -0700 (PDT)
From: Vikas C Sajjan <vikas.cha.sajjan@hpe.com>
Subject: [PATCH] nfit: use devm_add_action_or_reset()
Date: Mon,  4 Jul 2016 10:02:51 +0530
Message-Id: <1467606771-21704-1-git-send-email-vikas.cha.sajjan@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-acpi@vger.kernel.org, Vikas C Sajjan <vikas.cha.sajjan@hpe.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

If devm_add_action() fails, we are explicitly calling the cleanup to free
the resources allocated. Lets use the helper devm_add_action_or_reset()
and return directly in case of error, since the cleanup function
has been already called by the helper if there was any error.

Signed-off-by: Vikas C Sajjan <vikas.cha.sajjan@hpe.com>
---
 drivers/acpi/nfit.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index c2ad967..44ebe1e 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1920,11 +1920,11 @@ static int acpi_nfit_insert_resource(struct acpi_nfit_desc *acpi_desc,
 	if (ret)
 		return ret;
 
-	ret = devm_add_action(acpi_desc->dev, acpi_nfit_remove_resource, res);
-	if (ret) {
-		remove_resource(res);
+	ret = devm_add_action_or_reset(acpi_desc->dev,
+					acpi_nfit_remove_resource,
+					res);
+	if (ret)
 		return ret;
-	}
 
 	return 0;
 }
-- 
1.9.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
