Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 5/7] fs: notify superblocks of backing-device death
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 25 Nov 2015 10:37:24 -0800
Message-ID: <20151125183724.12508.73971.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20151125183656.12508.52212.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151125183656.12508.52212.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Jens Axboe <axboe@fb.com>, linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

Set SB_I_BDIDEAD when a block device is no longer available to service
requests.  This will be used in several places where an fs should give
up early because the block device is gone.  Letting the fs continue on
as if the block device is still present can lead to long latencies
waiting for an fs to detect the loss of its backing device, trigger
crashes, or generate misleasing warnings.

Cc: Jan Kara <jack@suse.com>
Cc: Jens Axboe <axboe@fb.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/genhd.c      |    2 ++
 fs/block_dev.c     |   17 +++++++++++++++++
 include/linux/fs.h |    2 ++
 3 files changed, 21 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index e5cafa51567c..8a743cb81fb4 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -648,10 +648,12 @@ void del_gendisk(struct gendisk *disk)
 	while ((part = disk_part_iter_next(&piter))) {
 		invalidate_partition(disk, part->partno);
 		delete_partition(disk, part->partno);
+		kill_bdev_super(disk, part->partno);
 	}
 	disk_part_iter_exit(&piter);
 
 	invalidate_partition(disk, 0);
+	kill_bdev_super(disk, 0);
 	set_capacity(disk, 0);
 	disk->flags &= ~GENHD_FL_UP;
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1dd416bf72f7..d0233d643d33 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1795,6 +1795,23 @@ int __invalidate_device(struct block_device *bdev, bool kill_dirty)
 }
 EXPORT_SYMBOL(__invalidate_device);
 
+void kill_bdev_super(struct gendisk *disk, int partno)
+{
+	struct block_device *bdev = bdget_disk(disk, partno);
+	struct super_block *sb;
+
+	if (!bdev)
+		return;
+	sb = get_super(bdev);
+	if (!sb)
+		goto out;
+
+	sb->s_iflags |= SB_I_BDI_DEAD;
+	drop_super(sb);
+ out:
+	bdput(bdev);
+}
+
 void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
 {
 	struct inode *inode, *old_inode = NULL;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3aa514254161..76925e322e87 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1254,6 +1254,7 @@ struct mm_struct;
 /* sb->s_iflags */
 #define SB_I_CGROUPWB	0x00000001	/* cgroup-aware writeback enabled */
 #define SB_I_NOEXEC	0x00000002	/* Ignore executables on this fs */
+#define SB_I_BDI_DEAD	0x00000004	/* Give up, backing device is dead */
 
 /* Possible states of 'frozen' field */
 enum {
@@ -2390,6 +2391,7 @@ extern int revalidate_disk(struct gendisk *);
 extern int check_disk_change(struct block_device *);
 extern int __invalidate_device(struct block_device *, bool);
 extern int invalidate_partition(struct gendisk *, int);
+extern void kill_bdev_super(struct gendisk *, int);
 #endif
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);

