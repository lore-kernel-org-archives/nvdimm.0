Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [resend PATCH 1/3] block, fs: reliably communicate bdev end-of-life
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 04 Jan 2016 10:20:05 -0800
Message-ID: <20160104182005.24118.50361.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160104181220.24118.96661.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160104181220.24118.96661.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Introduce del_gendisk_queue to trigger ->quiesce() and ->bdi_gone()
notifications to all the filesystems hosted on the disk.  Where
->quiesce() are 'shutdown' operations while the bdev may still be alive,
and ->bdi_gone() is a set of actions to take after the backing device
is known to be permanently dead.

generic_quiesce_super and generic_bdi_gone, are the default operations
when a filesystem does not implement ->quiesce(), ->bdi_gone().  They
invalidate inodes and unmap DAX-inodes respectively.  For now only
->bdi_gone() has an associated super operation as xfs will implement
->bdi_gone() in a later patch.

Cc: Jan Kara <jack@suse.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/genhd.c                |   87 +++++++++++++++++++++++++++++++++++-------
 drivers/block/brd.c          |    3 -
 drivers/nvdimm/pmem.c        |    3 -
 drivers/s390/block/dcssblk.c |    6 +--
 fs/block_dev.c               |   78 ++++++++++++++++++++++++++++++++------
 include/linux/fs.h           |    2 +
 include/linux/genhd.h        |    1 
 7 files changed, 147 insertions(+), 33 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e5cafa51567c..967fcfd63c98 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -634,24 +634,14 @@ void add_disk(struct gendisk *disk)
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
-	}
-	disk_part_iter_exit(&piter);
-
-	invalidate_partition(disk, 0);
+static void del_gendisk_end(struct gendisk *disk)
+{
 	set_capacity(disk, 0);
 	disk->flags &= ~GENHD_FL_UP;
 
@@ -670,9 +660,78 @@ void del_gendisk(struct gendisk *disk)
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
+	}
+	disk_part_iter_exit(&piter);
+	invalidate_partition(disk, 0);
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
+ * ...is for notifying the filesystem that the block device has gone
+ * away.  This distinction is important for triggering a filesystem to
+ * abort its error recovery and for (DAX) capable devices.  DAX bypasses
+ * page cache and mappings go directly to storage media.  When such a
+ * disk is removed the pfn backing a mapping may be invalid or removed
+ * from the system.  Upon return accessing DAX mappings of this disk
+ * will trigger SIGBUS.
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
+	/* pass2 the queue is dead, trigger fs shutdown via ->bdi_gone() */
+	disk_part_iter_init(&piter, disk,
+			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
+	for_each_part(part, &piter) {
+		shutdown_partition(disk, part->partno);
+		delete_partition(disk, part->partno);
+	}
+	disk_part_iter_exit(&piter);
+	shutdown_partition(disk, 0);
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
index 44d4a1e9244e..739e43a37e64 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1778,27 +1778,83 @@ fail:
 }
 EXPORT_SYMBOL(lookup_bdev);
 
+static int generic_quiesce_super(struct super_block *sb, bool kill_dirty)
+{
+	/*
+	 * no need to lock the super, get_super holds the read mutex so
+	 * the filesystem cannot go away under us (->put_super runs with
+	 * the write lock held).
+	 */
+	shrink_dcache_sb(sb);
+	return invalidate_inodes(sb, kill_dirty);
+}
+
 int __invalidate_device(struct block_device *bdev, bool kill_dirty)
 {
 	struct super_block *sb = get_super(bdev);
 	int res = 0;
 
-	if (sb) {
-		/*
-		 * no need to lock the super, get_super holds the
-		 * read mutex so the filesystem cannot go away
-		 * under us (->put_super runs with the write lock
-		 * hold).
-		 */
-		shrink_dcache_sb(sb);
-		res = invalidate_inodes(sb, kill_dirty);
-		drop_super(sb);
-	}
+	if (!sb)
+		goto out;
+
+	res = generic_quiesce_super(sb, kill_dirty);
+	drop_super(sb);
+ out:
 	invalidate_bdev(bdev);
+
 	return res;
 }
 EXPORT_SYMBOL(__invalidate_device);
 
+static void generic_bdi_gone(struct super_block *sb)
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
+
+void shutdown_partition(struct gendisk *disk, int partno)
+{
+	struct block_device *bdev = bdget_disk(disk, partno);
+	struct super_block *sb = get_super(bdev);
+
+	if (!bdev)
+		return;
+
+	if (!sb) {
+		bdput(bdev);
+		return;
+	}
+
+	if (sb->s_op->bdi_gone)
+		sb->s_op->bdi_gone(sb);
+	else
+		generic_bdi_gone(sb);
+
+	drop_super(sb);
+	bdput(bdev);
+}
+
 void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
 {
 	struct inode *inode, *old_inode = NULL;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3aa514254161..0e201ed38045 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1713,6 +1713,7 @@ struct super_operations {
 				  struct shrink_control *);
 	long (*free_cached_objects)(struct super_block *,
 				    struct shrink_control *);
+	void (*bdi_gone)(struct super_block *);
 };
 
 /*
@@ -2390,6 +2391,7 @@ extern int revalidate_disk(struct gendisk *);
 extern int check_disk_change(struct block_device *);
 extern int __invalidate_device(struct block_device *, bool);
 extern int invalidate_partition(struct gendisk *, int);
+extern void shutdown_partition(struct gendisk *, int);
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
 

