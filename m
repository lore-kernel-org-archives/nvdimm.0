Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5157D211982F4
 for <linux-nvdimm@lists.01.org>; Sun, 13 Jan 2019 18:19:52 -0800 (PST)
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: [PATCH] acpi/nfit: remove duplicate set nd_set in
 acpi_nfit_init_interleave_set()
Date: Mon, 14 Jan 2019 10:19:29 +0800
Message-Id: <20190114021929.3658-1-richardw.yang@linux.intel.com>
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
Cc: Wei Yang <richardw.yang@linux.intel.com>, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

We allocate nd_set in acpi_nfit_init_interleave_set() and assignn it to
ndr_desc, while the assignment is done twice in this function.

This patch removes the second assignment. No functional change.

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
---
 drivers/acpi/nfit/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 5912d30020c7..7b66d701d8ac 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2260,7 +2260,6 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 		}
 	}
 
-	ndr_desc->nd_set = nd_set;
 	devm_kfree(dev, info);
 	devm_kfree(dev, info2);
 
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
