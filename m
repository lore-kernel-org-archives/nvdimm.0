Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7A6C81A1F3F
 for <linux-nvdimm@lists.01.org>; Wed,  9 Mar 2016 14:05:23 -0800 (PST)
From: NeilBrown <neilb@suse.com>
Date: Thu, 10 Mar 2016 08:59:28 +1100
Subject: [PATCH 1/4] nvdimm/blk: don't allocate unused major device number
Message-ID: <20160309215928.20904.11773.stgit@noble>
In-Reply-To: <20160309215702.20904.61407.stgit@noble>
References: <20160309215702.20904.61407.stgit@noble>
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
To: Keith Busch <keith.busch@intel.com>, Maxim Levitsky <maximlevitsky@gmail.com>, Vishal Verma <vishal.l.verma@intel.com>, Jens Axboe <axboe@fb.com>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

When alloc_disk(0) is used ->major is completely ignored, all devices
are allocated with a "major" of BLOCK_EXT_MAJOR.

So don't allocate nd_blk_major

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/nvdimm/blk.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 91a336ea8c4f..e9ff9229d942 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -31,8 +31,6 @@ struct nd_blk_device {
 	u32 internal_lbasize;
 };
 
-static int nd_blk_major;
-
 static u32 nd_blk_meta_size(struct nd_blk_device *blk_dev)
 {
 	return blk_dev->nsblk->lbasize - blk_dev->sector_size;
@@ -264,7 +262,6 @@ static int nd_blk_attach_disk(struct nd_namespace_common *ndns,
 	}
 
 	disk->driverfs_dev	= &ndns->dev;
-	disk->major		= nd_blk_major;
 	disk->first_minor	= 0;
 	disk->fops		= &nd_blk_fops;
 	disk->private_data	= blk_dev;
@@ -358,25 +355,12 @@ static struct nd_device_driver nd_blk_driver = {
 
 static int __init nd_blk_init(void)
 {
-	int rc;
-
-	rc = register_blkdev(0, "nd_blk");
-	if (rc < 0)
-		return rc;
-
-	nd_blk_major = rc;
-	rc = nd_driver_register(&nd_blk_driver);
-
-	if (rc < 0)
-		unregister_blkdev(nd_blk_major, "nd_blk");
-
-	return rc;
+	return nd_driver_register(&nd_blk_driver);
 }
 
 static void __exit nd_blk_exit(void)
 {
 	driver_unregister(&nd_blk_driver.drv);
-	unregister_blkdev(nd_blk_major, "nd_blk");
 }
 
 MODULE_AUTHOR("Ross Zwisler <ross.zwisler@linux.intel.com>");


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
