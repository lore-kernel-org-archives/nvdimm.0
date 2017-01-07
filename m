Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A1D8881A56
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jan 2017 17:07:08 -0800 (PST)
Subject: [RFC PATCH v2 2/2] block: fix blk_get_backing_dev_info() crash,
 use bdev->bd_queue
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 06 Jan 2017 17:03:01 -0800
Message-ID: <148375098178.37020.13124065464072336113.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148375097100.37020.495735345355345658.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148375097100.37020.495735345355345658.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-block@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, Jan Kara <jack@suse.cz>, Rabin Vincent <rabinv@axis.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@fb.com>, Wei Fang <fangwei1@huawei.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

The ->bd_queue member of struct block_device was added in commit
87192a2a49c4 ("vfs: cache request_queue in struct block_device") in
v3.3. However, blk_get_backing_dev_info() has been using
bdev_get_queue() and grabbing the request_queue through the gendisk
since before the git era.

At final __blkdev_put() time ->bd_disk is cleared while ->bd_queue is
not. The queue remains valid until the final put of the parent disk.

The following crash signature results from blk_get_backing_dev_info()
trying to lookup the queue through ->bd_disk after the final put of the
block device. Simply switch bdev_get_queue() to use ->bd_queue directly
which is guaranteed to still be valid since the request_queue is alive
as long as the inode corresponding to the bdev has not been destroyed.

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000568
 IP: blk_get_backing_dev_info+0x10/0x20
 [..]
 Call Trace:
  __inode_attach_wb+0x3a7/0x5d0
  __filemap_fdatawrite_range+0xf8/0x100
  filemap_write_and_wait+0x40/0x90
  fsync_bdev+0x54/0x60
  ? bdget_disk+0x30/0x40
  invalidate_partition+0x24/0x50
  del_gendisk+0xfa/0x230

Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Wei Fang <fangwei1@huawei.com>
Cc: Rabin Vincent <rabinv@axis.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/blk-core.c       |    4 ++--
 include/linux/blkdev.h |    6 +++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e8713137b846..cfd6731dfed7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -108,8 +108,8 @@ void blk_queue_congestion_threshold(struct request_queue *q)
  * @bdev:	device
  *
  * Locates the passed device's request queue and returns the address of its
- * backing_dev_info.  This function can only be called if @bdev is opened
- * and the return value is never NULL.
+ * backing_dev_info.  This function can be called until the final iput()
+ * of the bdev inode.
  */
 struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c47c358ba052..fd332da0fc38 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -841,7 +841,11 @@ bool blk_poll(struct request_queue *q, blk_qc_t cookie);
 
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 {
-	return bdev->bd_disk->queue;	/* this is never NULL */
+	/*
+	 * ->bd_queue is valid as long as there is a reference against
+	 *  the bdev inode.
+	 */
+	return bdev->bd_queue;
 }
 
 /*

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
