Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 5C7881A1E04
 for <linux-nvdimm@lists.01.org>; Wed, 15 Jun 2016 16:33:05 -0700 (PDT)
Subject: [PATCH] libnvdimm: use devm_add_action_or_reset()
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 Jun 2016 16:31:55 -0700
Message-ID: <146603351577.6734.7126797782354241391.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Clean up needless calls to the action routine by letting
devm_add_action_or_reset() call it automatically.  This does cause the
disk to registered and immediately unregistered when a memory allocation
fails, but the block layer should be prepared for such an event.

Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/blk.c  |   11 ++++-------
 drivers/nvdimm/pmem.c |   12 +++++-------
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 495e06d9f7e7..dfe691cf4d74 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -267,10 +267,8 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 	q = blk_alloc_queue(GFP_KERNEL);
 	if (!q)
 		return -ENOMEM;
-	if (devm_add_action(dev, nd_blk_release_queue, q)) {
-		blk_cleanup_queue(q);
+	if (devm_add_action_or_reset(dev, nd_blk_release_queue, q))
 		return -ENOMEM;
-	}
 
 	blk_queue_make_request(q, nd_blk_make_request);
 	blk_queue_max_hw_sectors(q, UINT_MAX);
@@ -282,10 +280,6 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 	disk = alloc_disk(0);
 	if (!disk)
 		return -ENOMEM;
-	if (devm_add_action(dev, nd_blk_release_disk, disk)) {
-		put_disk(disk);
-		return -ENOMEM;
-	}
 
 	disk->driverfs_dev	= dev;
 	disk->first_minor	= 0;
@@ -296,6 +290,9 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 	set_capacity(disk, 0);
 	add_disk(disk);
 
+	if (devm_add_action_or_reset(dev, nd_blk_release_disk, disk))
+		return -ENOMEM;
+
 	if (nsblk_meta_size(nsblk)) {
 		int rc = nd_integrity_init(disk, nsblk_meta_size(nsblk));
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 608fc4464574..2ef1229e8ded 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -269,10 +269,8 @@ static int pmem_attach_disk(struct device *dev,
 	 * At release time the queue must be dead before
 	 * devm_memremap_pages is unwound
 	 */
-	if (devm_add_action(dev, pmem_release_queue, q)) {
-		blk_cleanup_queue(q);
+	if (devm_add_action_or_reset(dev, pmem_release_queue, q))
 		return -ENOMEM;
-	}
 
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
@@ -288,10 +286,6 @@ static int pmem_attach_disk(struct device *dev,
 	disk = alloc_disk_node(0, nid);
 	if (!disk)
 		return -ENOMEM;
-	if (devm_add_action(dev, pmem_release_disk, disk)) {
-		put_disk(disk);
-		return -ENOMEM;
-	}
 
 	disk->fops		= &pmem_fops;
 	disk->queue		= q;
@@ -305,6 +299,10 @@ static int pmem_attach_disk(struct device *dev,
 	nvdimm_badblocks_populate(to_nd_region(dev->parent), &pmem->bb, res);
 	disk->bb = &pmem->bb;
 	add_disk(disk);
+
+	if (devm_add_action_or_reset(dev, pmem_release_disk, disk))
+		return -ENOMEM;
+
 	revalidate_disk(disk);
 
 	return 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
