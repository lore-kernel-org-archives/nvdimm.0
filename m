Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 81AF62114398C
 for <linux-nvdimm@lists.01.org>; Wed, 19 Sep 2018 05:59:10 -0700 (PDT)
From: Pankaj Gupta <pagupta@redhat.com>
Subject: [PATCH] libnvdimm: remove duplicate include
Date: Wed, 19 Sep 2018 18:28:48 +0530
Message-Id: <20180919125848.6570-1-pagupta@redhat.com>
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
To: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Cc: zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Removed duplicate include.

Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
---
 drivers/nvdimm/nd-core.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index ac68072fb8cd..182258f64417 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -14,7 +14,6 @@
 #define __ND_CORE_H__
 #include <linux/libnvdimm.h>
 #include <linux/device.h>
-#include <linux/libnvdimm.h>
 #include <linux/sizes.h>
 #include <linux/mutex.h>
 #include <linux/nd.h>
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
