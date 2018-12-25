Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1576F2194D387
 for <linux-nvdimm@lists.01.org>; Mon, 24 Dec 2018 18:14:50 -0800 (PST)
From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] acpi, nfit: Remove duplicated include from core.c
Date: Tue, 25 Dec 2018 02:21:56 +0000
Message-ID: <1545704516-10147-1-git-send-email-yuehaibing@huawei.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <zwisler@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, kernel-janitors@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/acpi/nfit/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 011d3db..328e464 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -26,7 +26,6 @@
 #include <acpi/nfit.h>
 #include "intel.h"
 #include "nfit.h"
-#include "intel.h"
 
 /*
  * For readq() and writeq() on 32-bit builds, the hi-lo, lo-hi order is





_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
