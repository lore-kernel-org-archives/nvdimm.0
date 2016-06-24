Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB23B1A1DF1
 for <linux-nvdimm@lists.01.org>; Fri, 24 Jun 2016 03:30:00 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] e820: use module_platform_driver
Date: Fri, 24 Jun 2016 12:29:24 +0200
Message-Id: <1466764164-69726-1-git-send-email-jthumshirn@suse.de>
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

User module_platform_driver macro instead of open-coding it.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/nvdimm/e820.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
index 95825b3..6c449fe 100644
--- a/drivers/nvdimm/e820.c
+++ b/drivers/nvdimm/e820.c
@@ -82,19 +82,8 @@ static struct platform_driver e820_pmem_driver = {
 		.name = "e820_pmem",
 	},
 };
-
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
1.8.5.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
