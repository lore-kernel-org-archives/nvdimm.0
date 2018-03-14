Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 220E821ED1C53
 for <linux-nvdimm@lists.01.org>; Wed, 14 Mar 2018 11:19:29 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 3/3] device-dax: use module_nd_driver
Date: Wed, 14 Mar 2018 19:25:08 +0100
Message-Id: <20180314182508.10351-4-jthumshirn@suse.de>
In-Reply-To: <20180314182508.10351-1-jthumshirn@suse.de>
References: <20180314182508.10351-1-jthumshirn@suse.de>
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
To: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux NV-DIMM Mailing List <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Use module_nd_driver() instead of having module_init() and
module_exit() callbacks which just call nd_driver_register() and
nd_driver_unregister().

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/dax/pmem.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index 31b6ecce4c64..d927ae82ba0d 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -150,17 +150,7 @@ static struct nd_device_driver dax_pmem_driver = {
 	.type = ND_DRIVER_DAX_PMEM,
 };
 
-static int __init dax_pmem_init(void)
-{
-	return nd_driver_register(&dax_pmem_driver);
-}
-module_init(dax_pmem_init);
-
-static void __exit dax_pmem_exit(void)
-{
-	driver_unregister(&dax_pmem_driver.drv);
-}
-module_exit(dax_pmem_exit);
+module_nd_driver(dax_pmem_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Intel Corporation");
-- 
2.13.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
