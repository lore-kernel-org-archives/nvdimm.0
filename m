Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 2/5] block: introduce del_gendisk_queue()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 07 Jan 2016 16:43:05 -0800
Message-ID: <20160108004305.36061.31898.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160108004254.36061.32864.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160108004254.36061.32864.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The current block device shutdown sequence of del_gendisk +
blk_cleanup_queue is problematic.  We want to tell the fs after
blk_cleanup_queue that there is no possibility of recovery, but by that
time we have deleted partitions and lost the ability to find all the
super-blocks on a block device.

del_gendisk_queue() combines block device shutdown, blk_cleanup_queue(),
with block device end of life notification, del_gendisk().  Later
patches builds on this sequence to unmap all dax inodes and communicate
to the fs that it should force-fail all future i/o since the queue is
permanently dead.  For now this is routine is functionally equivalent to
calling del_gendisk() + blk_cleanup_queue() in succession.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/genhd.c                |   43 ++++++++++++++++++++++++++++++++++++++++++
 drivers/block/brd.c          |    9 +++------
 drivers/nvdimm/pmem.c        |    3 +--
 drivers/s390/block/dcssblk.c |    6 ++----
 include/linux/genhd.h        |    1 +
 5 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index b1d1df42ba13..a5bb768111cc 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -686,6 +686,49 @@ void del_gendisk(struct gendisk *disk)
 EXPORT_SYMBOL(del_gendisk);
 
 /**
+ * del_gendisk_queue - combined del_gendisk + blk_cleanup_queue
+ * @disk: disk to delete, invalidate, unmap, and force-fail fs operations
+ *
+ * This is an alternative for open coded calls to:
+ *     del_gendisk()
+ *     blk_cleanup_queue()
+ * It notifies filesystems / vfs that a block device is permanently dead
+ * after the queue has been torn down.  This notification is needed for
+ * triggering a filesystem to abort its error recovery and for (DAX)
+ * capable devices.  DAX bypasses page cache and mappings go directly to
+ * storage media.  When such a disk is removed the pfn backing a mapping
+ * may be invalid or removed from the system.  Upon return accessing DAX
+ * mappings of this disk will trigger SIGBUS.
+ */
+void del_gendisk_queue(struct gendisk *disk)
+{
+	struct disk_part_iter piter;
+	struct hd_struct *part;
+
+	del_gendisk_start(disk);
+
+	/* pass1 sync fs + evict idle inodes */
+	disk_part_iter_init(&piter, disk,
+			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
+	for_each_part(part, &piter)
+		invalidate_partition(disk, part->partno);
+	disk_part_iter_exit(&piter);
+	invalidate_partition(disk, 0);
+
+	blk_cleanup_queue(disk->queue);
+
+	/* pass2 the queue is dead */
+	disk_part_iter_init(&piter, disk,
+			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
+	for_each_part(part, &piter)
+		delete_partition(disk, part->partno);
+	disk_part_iter_exit(&piter);
+
+	del_gendisk_end(disk);
+}
+EXPORT_SYMBOL(del_gendisk_queue);
+
+/**
  * get_gendisk - get partitioning information for a given device
  * @devt: device to get partitioning information for
  * @partno: returned partition index
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index a5880f4ab40e..013ff58f9af8 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -532,7 +532,6 @@ out:
 static void brd_free(struct brd_device *brd)
 {
 	put_disk(brd->brd_disk);
-	blk_cleanup_queue(brd->brd_queue);
 	brd_free_pages(brd);
 	kfree(brd);
 }
@@ -560,7 +559,7 @@ out:
 static void brd_del_one(struct brd_device *brd)
 {
 	list_del(&brd->brd_list);
-	del_gendisk(brd->brd_disk);
+	del_gendisk_queue(brd->brd_disk);
 	brd_free(brd);
 }
 
@@ -626,10 +625,8 @@ static int __init brd_init(void)
 	return 0;
 
 out_free:
-	list_for_each_entry_safe(brd, next, &brd_devices, brd_list) {
-		list_del(&brd->brd_list);
-		brd_free(brd);
-	}
+	list_for_each_entry_safe(brd, next, &brd_devices, brd_list)
+		brd_del_one(brd);
 	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
 
 	pr_info("brd: module NOT loaded !!!\n");
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 8ee79893d2f5..6dd06e9d34b0 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -158,9 +158,8 @@ static void pmem_detach_disk(struct pmem_device *pmem)
 	if (!pmem->pmem_disk)
 		return;
 
-	del_gendisk(pmem->pmem_disk);
+	del_gendisk_queue(pmem->pmem_disk);
 	put_disk(pmem->pmem_disk);
-	blk_cleanup_queue(pmem->pmem_queue);
 }
 
 static int pmem_attach_disk(struct device *dev,
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 94a8f4ab57bc..0c3c968b57d9 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -388,8 +388,7 @@ removeseg:
 	}
 	list_del(&dev_info->lh);
 
-	del_gendisk(dev_info->gd);
-	blk_cleanup_queue(dev_info->dcssblk_queue);
+	del_gendisk_queue(dev_info->gd);
 	dev_info->gd->queue = NULL;
 	put_disk(dev_info->gd);
 	up_write(&dcssblk_devices_sem);
@@ -751,8 +750,7 @@ dcssblk_remove_store(struct device *dev, struct device_attribute *attr, const ch
 	}
 
 	list_del(&dev_info->lh);
-	del_gendisk(dev_info->gd);
-	blk_cleanup_queue(dev_info->dcssblk_queue);
+	del_gendisk_queue(dev_info->gd);
 	dev_info->gd->queue = NULL;
 	put_disk(dev_info->gd);
 	device_unregister(&dev_info->dev);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 847cc1d91634..028cf15a8a57 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -431,6 +431,7 @@ extern void part_round_stats(int cpu, struct hd_struct *part);
 /* block/genhd.c */
 extern void add_disk(struct gendisk *disk);
 extern void del_gendisk(struct gendisk *gp);
+extern void del_gendisk_queue(struct gendisk *disk);
 extern struct gendisk *get_gendisk(dev_t dev, int *partno);
 extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
 
