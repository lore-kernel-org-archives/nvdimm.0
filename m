Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 467C21A1F3A
 for <linux-nvdimm@lists.01.org>; Wed,  9 Mar 2016 14:05:34 -0800 (PST)
From: NeilBrown <neilb@suse.com>
Date: Thu, 10 Mar 2016 08:59:28 +1100
Subject: [PATCH 2/4] nvdimm/btt: don't allocate unused major device number
Message-ID: <20160309215928.20904.21111.stgit@noble>
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

alloc_disk(0) does not require or use a ->major number,
all devices are allocated with a major of BLOCK_EXT_MAJOR.

So don't allocate btt_major.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/nvdimm/btt.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index efb2c1ceef98..c32cbb593600 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -31,8 +31,6 @@ enum log_ent_request {
 	LOG_OLD_ENT
 };
 
-static int btt_major;
-
 static int arena_read_bytes(struct arena_info *arena, resource_size_t offset,
 		void *buf, size_t n)
 {
@@ -1246,7 +1244,6 @@ static int btt_blk_init(struct btt *btt)
 
 	nvdimm_namespace_disk_name(ndns, btt->btt_disk->disk_name);
 	btt->btt_disk->driverfs_dev = &btt->nd_btt->dev;
-	btt->btt_disk->major = btt_major;
 	btt->btt_disk->first_minor = 0;
 	btt->btt_disk->fops = &btt_fops;
 	btt->btt_disk->private_data = btt;
@@ -1423,22 +1420,11 @@ EXPORT_SYMBOL(nvdimm_namespace_detach_btt);
 
 static int __init nd_btt_init(void)
 {
-	int rc;
-
-	btt_major = register_blkdev(0, "btt");
-	if (btt_major < 0)
-		return btt_major;
+	int rc = 0;
 
 	debugfs_root = debugfs_create_dir("btt", NULL);
-	if (IS_ERR_OR_NULL(debugfs_root)) {
+	if (IS_ERR_OR_NULL(debugfs_root))
 		rc = -ENXIO;
-		goto err_debugfs;
-	}
-
-	return 0;
-
- err_debugfs:
-	unregister_blkdev(btt_major, "btt");
 
 	return rc;
 }
@@ -1446,7 +1432,6 @@ static int __init nd_btt_init(void)
 static void __exit nd_btt_exit(void)
 {
 	debugfs_remove_recursive(debugfs_root);
-	unregister_blkdev(btt_major, "btt");
 }
 
 MODULE_ALIAS_ND_DEVICE(ND_DEVICE_BTT);


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
