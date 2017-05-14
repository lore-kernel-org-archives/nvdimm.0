Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 32F7721A0BAB0
 for <linux-nvdimm@lists.01.org>; Sat, 13 May 2017 17:58:51 -0700 (PDT)
Subject: [PATCH] dax: fix false CONFIG_BLOCK dependency
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 13 May 2017 17:52:59 -0700
Message-ID: <149472317902.18012.17388980379890362403.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In the BLOCK=n case the dax core does not need to / must not emit the
block-device-dax helpers. Otherwise it leads to compile errors.

Cc: Arnd Bergmann <arnd@arndb.de>
Reported-by: Fabian Frederick <fabf@skynet.be>
Fixes: ef51042472f5 ("block, dax: move 'select DAX' from BLOCK to FS_DAX")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index ebf43f531ada..6ed32aac8bbe 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -44,6 +44,7 @@ void dax_read_unlock(int id)
 }
 EXPORT_SYMBOL_GPL(dax_read_unlock);
 
+#ifdef CONFIG_BLOCK
 int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
 		pgoff_t *pgoff)
 {
@@ -112,6 +113,7 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__bdev_dax_supported);
+#endif
 
 /**
  * struct dax_device - anchor object for dax services

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
