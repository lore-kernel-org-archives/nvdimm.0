Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 3/5] block: introduce force_failure_partition() and
 unmap_dax_inodes()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 07 Jan 2016 16:43:15 -0800
Message-ID: <20160108004310.36061.4099.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160108004254.36061.32864.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160108004254.36061.32864.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
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

Cc: Jan Kara <jack@suse.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/genhd.c      |    7 +++++--
 fs/block_dev.c     |   19 +++++++++++++++++++
 fs/inode.c         |   28 ++++++++++++++++++++++++++++
 include/linux/fs.h |    2 ++
 4 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index a5bb768111cc..ac0d12c4f895 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -717,12 +717,15 @@ void del_gendisk_queue(struct gendisk *disk)
 
 	blk_cleanup_queue(disk->queue);
 
-	/* pass2 the queue is dead */
+	/* pass2 the queue is dead, halt dax */
 	disk_part_iter_init(&piter, disk,
 			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
-	for_each_part(part, &piter)
+	for_each_part(part, &piter) {
+		force_failure_partition(disk, part->partno);
 		delete_partition(disk, part->partno);
+	}
 	disk_part_iter_exit(&piter);
+	force_failure_partition(disk, 0);
 
 	del_gendisk_end(disk);
 }
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
