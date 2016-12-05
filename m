Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC51381FD8
 for <linux-nvdimm@lists.01.org>; Mon,  5 Dec 2016 00:25:38 -0800 (PST)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] e820: use module_platform_driver
Date: Mon,  5 Dec 2016 09:23:20 +0100
Message-Id: <20161205082320.21777-1-jthumshirn@suse.de>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux NVDIMM Mailing List <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Use module_platform_driver for the e820 driver instead of open-coding it.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/nvdimm/e820.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
index 11ea901..6f9a6ff 100644
--- a/drivers/nvdimm/e820.c
+++ b/drivers/nvdimm/e820.c
@@ -84,18 +84,8 @@ static struct platform_driver e820_pmem_driver = {
 	},
 };
 
-static __init int e820_pmem_init(void)
-{
-	return platform_driver_register(&e820_pmem_driver);
-}
-
-static __exit void e820_pmem_exit(void)
-{
-	platform_driver_unregister(&e820_pmem_driver);
-}
+module_platform_driver(e820_pmem_driver);
 
 MODULE_ALIAS("platform:e820_pmem*");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Intel Corporation");
-module_init(e820_pmem_init);
-module_exit(e820_pmem_exit);
-- 
2.10.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
