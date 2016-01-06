Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 4/4] block, xfs: implement 'force_failure' notifications
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 05 Jan 2016 20:56:38 -0800
Message-ID: <20160106045638.38788.98997.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160106045616.38788.61076.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160106045616.38788.61076.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Introduce a new super operation, 'force_failure', that is invoked by
force_failure_partition() when the block device is dead.  This
unambiguously communicates to a filesystem that i/o errors are permanent
and no recovery effort will succeed.

'force_failure' simply becomes another exceptional event that can
trigger xfs_force_shutdown().

Cc: Jan Kara <jack@suse.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/genhd.c      |    2 +-
 fs/block_dev.c     |    5 ++++-
 fs/xfs/xfs_super.c |    8 ++++++++
 include/linux/fs.h |    1 +
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index ac0d12c4f895..45f9f123013b 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -717,7 +717,7 @@ void del_gendisk_queue(struct gendisk *disk)
 
 	blk_cleanup_queue(disk->queue);
 
-	/* pass2 the queue is dead, halt dax */
+	/* pass2 the queue is dead, halt dax, and halt fs operations */
 	disk_part_iter_init(&piter, disk,
 			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
 	for_each_part(part, &piter) {
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9cff33b6baab..a9c07910481c 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1812,7 +1812,10 @@ void force_failure_partition(struct gendisk *disk, int partno)
 	if (!sb)
 		goto out;
 
-	unmap_dax_inodes(sb);
+	if (sb->s_op->force_failure)
+		sb->s_op->force_failure(sb);
+	else
+		unmap_dax_inodes(sb);
 	drop_super(sb);
  out:
 	bdput(bdev);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 36bd8825bfb0..e1113ac2e342 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1618,6 +1618,13 @@ xfs_fs_free_cached_objects(
 	return xfs_reclaim_inodes_nr(XFS_M(sb), sc->nr_to_scan);
 }
 
+static void
+xfs_fs_force_failure(
+	struct super_block *sb)
+{
+	xfs_force_shutdown(XFS_M(sb), SHUTDOWN_DEVICE_REQ);
+}
+
 static const struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
@@ -1632,6 +1639,7 @@ static const struct super_operations xfs_super_operations = {
 	.show_options		= xfs_fs_show_options,
 	.nr_cached_objects	= xfs_fs_nr_cached_objects,
 	.free_cached_objects	= xfs_fs_free_cached_objects,
+	.force_failure		= xfs_fs_force_failure,
 };
 
 static struct file_system_type xfs_fs_type = {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a0d55199e628..bfd9bb7b529d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1713,6 +1713,7 @@ struct super_operations {
 				  struct shrink_control *);
 	long (*free_cached_objects)(struct super_block *,
 				    struct shrink_control *);
+	void (*force_failure)(struct super_block *);
 };
 
 /*

