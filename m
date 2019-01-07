Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from m50-132.163.com (m50-132.163.com [123.125.50.132])
 by ml01.01.org (Postfix) with ESMTP id B3FF5211B1117
 for <linux-nvdimm@lists.01.org>; Sun,  6 Jan 2019 18:34:00 -0800 (PST)
From: Xiaochun Lee <lixiaochun.2888@163.com>
Subject: [PATCH] ACPI/nfit: delete the redundant header file
Date: Mon,  7 Jan 2019 10:33:36 +0800
Message-Id: <1546828416-3040-2-git-send-email-lixiaochun.2888@163.com>
In-Reply-To: <1546828416-3040-1-git-send-email-lixiaochun.2888@163.com>
References: <1546828416-3040-1-git-send-email-lixiaochun.2888@163.com>
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
To: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: rjw@rjwysocki.net, linux-kernel@vger.kernel.org, Xiaochun Lee <lixc17@lenovo.com>, zwisler@kernel.org, lenb@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Xiaochun Lee <lixc17@lenovo.com>

The header file "intel.h" is repeated here, So delete one.

Signed-off-by: Xiaochun Lee <lixc17@lenovo.com>
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
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
