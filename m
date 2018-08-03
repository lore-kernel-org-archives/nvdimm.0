Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x242.google.com (mail-qt0-x242.google.com
 [IPv6:2607:f8b0:400d:c0d::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DA2F8210C5138
 for <linux-nvdimm@lists.01.org>; Fri,  3 Aug 2018 02:41:14 -0700 (PDT)
Received: by mail-qt0-x242.google.com with SMTP id n6-v6so5459292qtl.4
 for <linux-nvdimm@lists.01.org>; Fri, 03 Aug 2018 02:41:14 -0700 (PDT)
From: Ocean He <oceanhehy@gmail.com>
Subject: [PATCH] ACPI: nfit: return -ENODEV if fail to find NFIT at startup
Date: Fri,  3 Aug 2018 05:39:58 -0400
Message-Id: <1533289198-11400-1-git-send-email-oceanhehy@gmail.com>
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

In the beginning of acpi_nfit_add, if fail to find NFIT table then should
return -ENODEV, instead of 0.

Signed-off-by: Ocean He <hehy1@lenovo.com>
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 7c47900..1790d7c 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3355,7 +3355,7 @@ static int acpi_nfit_add(struct acpi_device *adev)
 	if (ACPI_FAILURE(status)) {
 		/* This is ok, we could have an nvdimm hotplugged later */
 		dev_dbg(dev, "failed to find NFIT at startup\n");
-		return 0;
+		return -ENODEV;
 	}
 
 	rc = devm_add_action_or_reset(dev, acpi_nfit_put_table, tbl);
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
