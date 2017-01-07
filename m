Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3622B8178C
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jan 2017 17:07:03 -0800 (PST)
Subject: [RFC PATCH v2 1/2] block: fix lifetime of request_queue /
 backing_dev_info relative to bdev
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 06 Jan 2017 17:02:56 -0800
Message-ID: <148375097659.37020.8663217538744770382.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@fb.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

By definition the lifetime of a struct block_device is equal to the
lifetime of its corresponding inode since they both live in struct
bdev_inode. Up until the inode is destroyed it may be the target of
delayed write-back requests. Issuing write-back to a block_device
requires a lookup of the bdev backing_dev_info that is embedded in the
request_queue.

It follows that a struct request_queue must be alive as long as a
corresponding block device inode is the active target of requests.

Match the lifetimes of backing_dev_info and its usage in
inode-write-back by arranging for the bdev to take a reference against
its request_queue when the bdev is instantiated. Release the
request_queue reference when the inode is freed.

Cc: Jens Axboe <axboe@fb.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/blk-core.c   |    3 ++-
 fs/block_dev.c     |   25 +++++++++++++++----------
 include/linux/fs.h |    1 +
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 14d7c0740dc0..e8713137b846 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -378,7 +378,8 @@ EXPORT_SYMBOL(blk_run_queue);
 
 void blk_put_queue(struct request_queue *q)
 {
-	kobject_put(&q->kobj);
+	if (q)
+		kobject_put(&q->kobj);
 }
 EXPORT_SYMBOL(blk_put_queue);
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 899fa8ccc347..8f94b74bfc7d 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -589,12 +589,22 @@ static struct inode *bdev_alloc_inode(struct super_block *sb)
 	return &ei->vfs_inode;
 }
 
+static void bdev_release(struct work_struct *w)
+{
+	struct block_device *bdev = container_of(w, typeof(*bdev), bd_release);
+	struct bdev_inode *bdi = container_of(bdev, typeof(*bdi), bdev);
+
+	blk_put_queue(bdev->bd_queue);
+	kmem_cache_free(bdev_cachep, bdi);
+}
+
 static void bdev_i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
-	struct bdev_inode *bdi = BDEV_I(inode);
+	struct block_device *bdev = &BDEV_I(inode)->bdev;
 
-	kmem_cache_free(bdev_cachep, bdi);
+	/* blk_put_queue needs process context */
+	schedule_work(&bdev->bd_release);
 }
 
 static void bdev_destroy_inode(struct inode *inode)
@@ -613,6 +623,7 @@ static void init_once(void *foo)
 #ifdef CONFIG_SYSFS
 	INIT_LIST_HEAD(&bdev->bd_holder_disks);
 #endif
+	INIT_WORK(&bdev->bd_release, bdev_release);
 	inode_init_once(&ei->vfs_inode);
 	/* Initialize mutex for freeze. */
 	mutex_init(&bdev->bd_fsfreeze_mutex);
@@ -1268,6 +1279,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (!bdev->bd_openers) {
 		bdev->bd_disk = disk;
+		if (!blk_get_queue(disk->queue))
+			goto out_clear;
 		bdev->bd_queue = disk->queue;
 		bdev->bd_contains = bdev;
 
@@ -1288,7 +1301,6 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 					disk_put_part(bdev->bd_part);
 					bdev->bd_part = NULL;
 					bdev->bd_disk = NULL;
-					bdev->bd_queue = NULL;
 					mutex_unlock(&bdev->bd_mutex);
 					disk_unblock_events(disk);
 					put_disk(disk);
@@ -1364,7 +1376,6 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	disk_put_part(bdev->bd_part);
 	bdev->bd_disk = NULL;
 	bdev->bd_part = NULL;
-	bdev->bd_queue = NULL;
 	if (bdev != bdev->bd_contains)
 		__blkdev_put(bdev->bd_contains, mode, 1);
 	bdev->bd_contains = NULL;
@@ -1586,12 +1597,6 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 		kill_bdev(bdev);
 
 		bdev_write_inode(bdev);
-		/*
-		 * Detaching bdev inode from its wb in __destroy_inode()
-		 * is too late: the queue which embeds its bdi (along with
-		 * root wb) can be gone as soon as we put_disk() below.
-		 */
-		inode_detach_wb(bdev->bd_inode);
 	}
 	if (bdev->bd_contains == bdev) {
 		if (disk->fops->release)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dc0478c07b2a..f084e4a2198b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -488,6 +488,7 @@ struct block_device {
 	int			bd_fsfreeze_count;
 	/* Mutex for freeze */
 	struct mutex		bd_fsfreeze_mutex;
+	struct work_struct	bd_release;
 };
 
 /*

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
