Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 2/4] block: introduce del_gendisk_queue()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 05 Jan 2016 20:56:27 -0800
Message-ID: <20160106045627.38788.90127.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160106045616.38788.61076.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160106045616.38788.61076.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Historically we have waited for filesystem specific heuristics to
attempt to guess when a block device is gone.  Sometimes this works, but
in other cases the system can hang waiting for the fs to trigger its
shutdown protocol.

The initial motivation for this investigation was to prevent DAX
mappings (direct mmap access to persistent memory) from leaking past the
lifetime of the hosting block device.  However, Dave points out that
these shutdown operations are needed in other scenarios.  Quoting Dave:

    For example, if we detect a free space corruption during allocation,
    it is not safe to trust *any active mapping* because we can't trust
    that we having handed out the same block to multiple owners. Hence
    on such a filesystem shutdown, we have to prevent any new DAX
    mapping from occurring and invalidate all existing mappings as we
    cannot allow userspace to modify any data or metadata until we've
    resolved the corruption situation.

The current block device shutdown sequence of del_gendisk +
blk_cleanup_queue is problematic.  We want to tell the fs after
blk_cleanup_queue that there is no possibility of recovery, but by that
time we have deleted partitions and lost the ability to find all the
super-blocks on a block device.

del_gendisk_queue() combines block device shutdown, blk_cleanup_queue(),
with block device end of life notification, del_gendisk().  A later
patch builds on this sequence to additionally communicate to the fs that
it should force-fail all future i/o since the queue is permanently dead.

Cc: Jan Kara <jack@suse.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/genhd.c                |   46 ++++++++++++++++++++++++++++++++++++++++++
 drivers/block/brd.c          |    9 +++-----
 drivers/nvdimm/pmem.c        |    3 +--
 drivers/s390/block/dcssblk.c |    6 ++---
 fs/block_dev.c               |   19 +++++++++++++++++
 fs/inode.c                   |   28 ++++++++++++++++++++++++++
 include/linux/fs.h           |    2 ++
 include/linux/genhd.h        |    1 +
 8 files changed, 102 insertions(+), 12 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index b1d1df42ba13..ac0d12c4f895 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -686,6 +686,52 @@ void del_gendisk(struct gendisk *disk)
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
+	/* pass2 the queue is dead, halt dax */
+	disk_part_iter_init(&piter, disk,
+			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
+	for_each_part(part, &piter) {
+		force_failure_partition(disk, part->partno);
+		delete_partition(disk, part->partno);
+	}
+	disk_part_iter_exit(&piter);
+	force_failure_partition(disk, 0);
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
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 44d4a1e9244e..9cff33b6baab 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1799,6 +1799,25 @@ int __invalidate_device(struct block_device *bdev, bool kill_dirty)
 }
 EXPORT_SYMBOL(__invalidate_device);
 
+void force_failure_partition(struct gendisk *disk, int partno)
+{
+	struct block_device *bdev;
+	struct super_block *sb;
+
+	bdev = bdget_disk(disk, partno);
+	if (!bdev)
+		return;
+
+	sb = get_super(bdev);
+	if (!sb)
+		goto out;
+
+	unmap_dax_inodes(sb);
+	drop_super(sb);
+ out:
+	bdput(bdev);
+}
+
 void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
 {
 	struct inode *inode, *old_inode = NULL;
diff --git a/fs/inode.c b/fs/inode.c
index 1be5f9003eb3..ed62e5f78f35 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -673,6 +673,34 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 	return busy;
 }
 
+void unmap_dax_inodes(struct super_block *sb)
+{
+	struct inode *inode, *_inode = NULL;
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
+}
+EXPORT_SYMBOL(unmap_dax_inodes);
+
 /*
  * Isolate the inode from the LRU in preparation for freeing it.
  *
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3aa514254161..a0d55199e628 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2390,6 +2390,7 @@ extern int revalidate_disk(struct gendisk *);
 extern int check_disk_change(struct block_device *);
 extern int __invalidate_device(struct block_device *, bool);
 extern int invalidate_partition(struct gendisk *, int);
+extern void force_failure_partition(struct gendisk *, int);
 #endif
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
@@ -2544,6 +2545,7 @@ extern loff_t default_llseek(struct file *file, loff_t offset, int whence);
 
 extern loff_t vfs_llseek(struct file *file, loff_t offset, int whence);
 
+extern void unmap_dax_inodes(struct super_block *sb);
 extern int inode_init_always(struct super_block *, struct inode *);
 extern void inode_init_once(struct inode *);
 extern void address_space_init_once(struct address_space *mapping);
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
 

