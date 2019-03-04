Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D858211CED7C
 for <linux-nvdimm@lists.01.org>; Sun,  3 Mar 2019 16:58:26 -0800 (PST)
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH -next] device-dax: Make function 'dev_dax_kmem_probe' static
Date: Mon, 4 Mar 2019 01:11:21 +0000
Message-ID: <20190304011121.64398-1-weiyongjun1@huawei.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Keith Busch <keith.busch@intel.com>, Dave Jiang <dave.jiang@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: kernel-janitors@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Fixes the following sparse warning:

drivers/dax/kmem.c:17:5: warning:
 symbol 'dev_dax_kmem_probe' was not declared. Should it be static?

Fixes: c221c0b0308f ("device-dax: "Hotplug" persistent memory for use like normal RAM")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/dax/kmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a02318c6d28a..e5cbbe22a19b 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -14,7 +14,7 @@
 #include "dax-private.h"
 #include "bus.h"
 
-int dev_dax_kmem_probe(struct device *dev)
+static int dev_dax_kmem_probe(struct device *dev)
 {
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 	struct resource *res = &dev_dax->region->res;



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
