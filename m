Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B4D71A1F45
 for <linux-nvdimm@lists.01.org>; Wed,  9 Mar 2016 14:05:51 -0800 (PST)
From: NeilBrown <neilb@suse.com>
Date: Thu, 10 Mar 2016 08:59:28 +1100
Subject: [PATCH 4/4] NVMe: don't allocate unused nvme_major
Message-ID: <20160309215928.20904.24799.stgit@noble>
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

When alloc_disk(0) is used, the ->major number is ignored.  All device
numbers are allocated with a major of BLOCK_EXT_MAJOR.

So remove all references to nvme_major.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/nvme/host/core.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 03c46412fff4..10e2435c84a9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -33,9 +33,6 @@
 
 #define NVME_MINORS		(1U << MINORBITS)
 
-static int nvme_major;
-module_param(nvme_major, int, 0);
-
 static int nvme_char_major;
 module_param(nvme_char_major, int, 0);
 
@@ -1170,8 +1167,6 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	blk_queue_logical_block_size(ns->queue, 1 << ns->lba_shift);
 	nvme_set_queue_limits(ctrl, ns->queue);
 
-	disk->major = nvme_major;
-	disk->first_minor = 0;
 	disk->fops = &nvme_fops;
 	disk->private_data = ns;
 	disk->queue = ns->queue;
@@ -1480,16 +1475,10 @@ int __init nvme_core_init(void)
 {
 	int result;
 
-	result = register_blkdev(nvme_major, "nvme");
-	if (result < 0)
-		return result;
-	else if (result > 0)
-		nvme_major = result;
-
 	result = __register_chrdev(nvme_char_major, 0, NVME_MINORS, "nvme",
 							&nvme_dev_fops);
 	if (result < 0)
-		goto unregister_blkdev;
+		return result;
 	else if (result > 0)
 		nvme_char_major = result;
 
@@ -1503,14 +1492,11 @@ int __init nvme_core_init(void)
 
  unregister_chrdev:
 	__unregister_chrdev(nvme_char_major, 0, NVME_MINORS, "nvme");
- unregister_blkdev:
-	unregister_blkdev(nvme_major, "nvme");
 	return result;
 }
 
 void nvme_core_exit(void)
 {
-	unregister_blkdev(nvme_major, "nvme");
 	class_destroy(nvme_class);
 	__unregister_chrdev(nvme_char_major, 0, NVME_MINORS, "nvme");
 }


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
