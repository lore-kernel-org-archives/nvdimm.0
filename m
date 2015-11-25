Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 7/7] mm, dax: unmap dax mappings at bdev shutdown
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 25 Nov 2015 10:37:36 -0800
Message-ID: <20151125183736.12508.86178.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20151125183656.12508.52212.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151125183656.12508.52212.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Dave Chinner <david@fromorbit.com>, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Currently dax mappings leak past / survive block_device shutdown.  While
page cache pages are permitted to be read/written after the block_device
is torn down this is not acceptable in the dax case as all media access
must end when the device is disabled.  The pfn backing a dax mapping is
permitted to be invalidated after bdev shutdown and this is indeed the
case with brd.

When a dax capable block_device driver calls del_gendisk_queue() in its
shutdown path it needs to ensure that all DAX pfns are unmapped, and
that no new mappings can be established.  This is different than the
pagecache backed case where the disk is protected by the queue being
torn down which ends I/O to the device.  Since dax bypasses the page
cache we need to unconditionally unmap the inode.

Cc: Jan Kara <jack@suse.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
[honza: drop changes to truncate_inode_pages_final]
[honza: ensure mappings can't be re-established]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/genhd.c                |   95 +++++++++++++++++++++++++++++++++++-------
 drivers/block/brd.c          |    3 -
 drivers/nvdimm/pmem.c        |    3 -
 drivers/s390/block/dcssblk.c |    6 +--
 fs/block_dev.c               |   41 ++++++++++++++++++
 include/linux/fs.h           |    1 
 include/linux/genhd.h        |    1 
 7 files changed, 126 insertions(+), 24 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 8a743cb81fb4..e1748365f9b3 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -634,26 +634,14 @@ void add_disk(struct gendisk *disk)
 }
 EXPORT_SYMBOL(add_disk);
 
-void del_gendisk(struct gendisk *disk)
+static void del_gendisk_start(struct gendisk *disk)
 {
-	struct disk_part_iter piter;
-	struct hd_struct *part;
-
 	blk_integrity_del(disk);
 	disk_del_events(disk);
+}
 
-	/* invalidate stuff */
-	disk_part_iter_init(&piter, disk,
-			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
-	while ((part = disk_part_iter_next(&piter))) {
-		invalidate_partition(disk, part->partno);
-		delete_partition(disk, part->partno);
-		kill_bdev_super(disk, part->partno);
-	}
-	disk_part_iter_exit(&piter);
-
-	invalidate_partition(disk, 0);
-	kill_bdev_super(disk, 0);
+static void del_gendisk_end(struct gendisk *disk)
+{
 	set_capacity(disk, 0);
 	disk->flags &= ~GENHD_FL_UP;
 
@@ -672,9 +660,84 @@ void del_gendisk(struct gendisk *disk)
 	pm_runtime_set_memalloc_noio(disk_to_dev(disk), false);
 	device_del(disk_to_dev(disk));
 }
+
+#define for_each_part(part, piter) \
+	for (part = disk_part_iter_next(piter); part; \
+			part = disk_part_iter_next(piter))
+void del_gendisk(struct gendisk *disk)
+{
+	struct disk_part_iter piter;
+	struct hd_struct *part;
+
+	del_gendisk_start(disk);
+
+	/* invalidate stuff */
+	disk_part_iter_init(&piter, disk,
+			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
+	for_each_part(part, &piter) {
+		invalidate_partition(disk, part->partno);
+		delete_partition(disk, part->partno);
+		kill_bdev_super(disk, part->partno);
+	}
+	disk_part_iter_exit(&piter);
+	invalidate_partition(disk, 0);
+	kill_bdev_super(disk, 0);
+
+	del_gendisk_end(disk);
+}
 EXPORT_SYMBOL(del_gendisk);
 
 /**
+ * del_gendisk_queue - combined del_gendisk + blk_cleanup_queue
+ * @disk: disk to delete, invalidate, unmap, and end i/o
+ *
+ * This alternative for open coded calls to:
+ *     del_gendisk()
+ *     blk_cleanup_queue()
+ * ...is for ->direct_access() (DAX) capable devices.  DAX bypasses page
+ * cache and mappings go directly to storage media.  When such a disk is
+ * removed the pfn backing a mapping may be invalid or removed from the
+ * system.  Upon return accessing DAX mappings of this disk will trigger
+ * SIGBUS.
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
+	for_each_part(part, &piter) {
+		invalidate_partition(disk, part->partno);
+		kill_bdev_super(disk, part->partno);
+	}
+	disk_part_iter_exit(&piter);
+	invalidate_partition(disk, 0);
+	kill_bdev_super(disk, 0);
+
+	blk_cleanup_queue(disk->queue);
+
+	/*
+	 * pass2 now that the queue is dead unmap DAX inodes, and delete
+	 * partitions
+	 */
+	disk_part_iter_init(&piter, disk,
+			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
+	for_each_part(part, &piter) {
+		unmap_partition(disk, part->partno);
+		delete_partition(disk, part->partno);
+	}
+	disk_part_iter_exit(&piter);
+	unmap_partition(disk, 0);
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
index a5880f4ab40e..f149dd57bba3 100644
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
diff --git a/fs/block_dev.c b/fs/block_dev.c
index d0233d643d33..f53e9e3e0f83 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1812,6 +1812,47 @@ void kill_bdev_super(struct gendisk *disk, int partno)
 	bdput(bdev);
 }
 
+void unmap_partition(struct gendisk *disk, int partno)
+{
+	bool dax = !!disk->fops->direct_access;
+	struct block_device *bdev = dax ? bdget_disk(disk, partno) : NULL;
+	struct super_block *sb = get_super(bdev);
+	struct inode *inode, *_inode = NULL;
+
+	if (!bdev)
+		return;
+
+	if (!sb) {
+		bdput(bdev);
+		return;
+	}
+
+	spin_lock(&sb->s_inode_list_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		spin_lock(&inode->i_lock);
+		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
+				|| !IS_DAX(inode)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
+		__iget(inode);
+		spin_unlock(&inode->i_lock);
+		spin_unlock(&sb->s_inode_list_lock);
+
+		unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+		iput(_inode);
+		_inode = inode;
+		cond_resched();
+
+		spin_lock(&sb->s_inode_list_lock);
+	}
+	spin_unlock(&sb->s_inode_list_lock);
+	iput(_inode);
+
+	drop_super(sb);
+	bdput(bdev);
+}
+
 void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
 {
 	struct inode *inode, *old_inode = NULL;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 76925e322e87..5eb8b29264a8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2392,6 +2392,7 @@ extern int check_disk_change(struct block_device *);
 extern int __invalidate_device(struct block_device *, bool);
 extern int invalidate_partition(struct gendisk *, int);
 extern void kill_bdev_super(struct gendisk *, int);
+extern void unmap_partition(struct gendisk *, int);
 #endif
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
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
 

