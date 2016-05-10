Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5424.austin.hp.com (g1t5424.austin.hp.com [15.216.225.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C23391A1F84
 for <linux-nvdimm@lists.01.org>; Tue, 10 May 2016 09:33:12 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v4 6/6] block: Update blkdev_dax_capable() for consistency
Date: Tue, 10 May 2016 10:23:57 -0600
Message-Id: <1462897437-16626-7-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1462897437-16626-1-git-send-email-toshi.kani@hpe.com>
References: <1462897437-16626-1-git-send-email-toshi.kani@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com, jack@suse.cz, david@fromorbit.com, viro@zeniv.linux.org.uk
Cc: hch@infradead.org, tytso@mit.edu, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, axboe@fb.com, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

blkdev_dax_capable() is similar to bdev_dax_supported(), but needs
to remain as a separate interface for checking dax capability of
a raw block device.

Rename and relocate blkdev_dax_capable() to keep them maintained
consistently, and call bdev_direct_access() for the dax capability
check.

There is no change in the behavior.

Link: https://lkml.org/lkml/2016/5/9/950
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@fb.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Boaz Harrosh <boaz@plexistor.com>
---
 block/ioctl.c          |   30 ------------------------------
 fs/block_dev.c         |   39 +++++++++++++++++++++++++++++++++++++--
 include/linux/blkdev.h |    1 +
 include/linux/fs.h     |    8 --------
 4 files changed, 38 insertions(+), 40 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 4ff1f92..7eeda07 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -4,7 +4,6 @@
 #include <linux/gfp.h>
 #include <linux/blkpg.h>
 #include <linux/hdreg.h>
-#include <linux/badblocks.h>
 #include <linux/backing-dev.h>
 #include <linux/fs.h>
 #include <linux/blktrace_api.h>
@@ -407,35 +406,6 @@ static inline int is_unrecognized_ioctl(int ret)
 		ret == -ENOIOCTLCMD;
 }
 
-#ifdef CONFIG_FS_DAX
-bool blkdev_dax_capable(struct block_device *bdev)
-{
-	struct gendisk *disk = bdev->bd_disk;
-
-	if (!disk->fops->direct_access)
-		return false;
-
-	/*
-	 * If the partition is not aligned on a page boundary, we can't
-	 * do dax I/O to it.
-	 */
-	if ((bdev->bd_part->start_sect % (PAGE_SIZE / 512))
-			|| (bdev->bd_part->nr_sects % (PAGE_SIZE / 512)))
-		return false;
-
-	/*
-	 * If the device has known bad blocks, force all I/O through the
-	 * driver / page cache.
-	 *
-	 * TODO: support finer grained dax error handling
-	 */
-	if (disk->bb && disk->bb->count)
-		return false;
-
-	return true;
-}
-#endif
-
 static int blkdev_flushbuf(struct block_device *bdev, fmode_t mode,
 		unsigned cmd, unsigned long arg)
 {
diff --git a/fs/block_dev.c b/fs/block_dev.c
index db55638..5d79093 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -29,6 +29,7 @@
 #include <linux/log2.h>
 #include <linux/cleancache.h>
 #include <linux/dax.h>
+#include <linux/badblocks.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -554,6 +555,40 @@ int bdev_dax_supported(struct super_block *sb, int blocksize)
 }
 EXPORT_SYMBOL_GPL(bdev_dax_supported);
 
+/**
+ * bdev_dax_capable() - Return if the raw device is capable for dax
+ * @bdev: The device for raw block device access
+ */
+bool bdev_dax_capable(struct block_device *bdev)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct blk_dax_ctl dax = {
+		.size = PAGE_SIZE,
+	};
+
+	if (!IS_ENABLED(CONFIG_FS_DAX))
+		return false;
+
+	dax.sector = 0;
+	if (bdev_direct_access(bdev, &dax) < 0)
+		return false;
+
+	dax.sector = bdev->bd_part->nr_sects - (PAGE_SIZE / 512);
+	if (bdev_direct_access(bdev, &dax) < 0)
+		return false;
+
+	/*
+	 * If the device has known bad blocks, force all I/O through the
+	 * driver / page cache.
+	 *
+	 * TODO: support finer grained dax error handling
+	 */
+	if (disk->bb && disk->bb->count)
+		return false;
+
+	return true;
+}
+
 /*
  * pseudo-fs
  */
@@ -1295,7 +1330,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 
 			if (!ret) {
 				bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
-				if (!blkdev_dax_capable(bdev))
+				if (!bdev_dax_capable(bdev))
 					bdev->bd_inode->i_flags &= ~S_DAX;
 			}
 
@@ -1332,7 +1367,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 				goto out_clear;
 			}
 			bd_set_size(bdev, (loff_t)bdev->bd_part->nr_sects << 9);
-			if (!blkdev_dax_capable(bdev))
+			if (!bdev_dax_capable(bdev))
 				bdev->bd_inode->i_flags &= ~S_DAX;
 		}
 	} else {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 71231a5..27cbefe 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1689,6 +1689,7 @@ extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
 extern long bdev_direct_access(struct block_device *, struct blk_dax_ctl *);
 extern int bdev_dax_supported(struct super_block *, int);
+extern bool bdev_dax_capable(struct block_device *);
 #else /* CONFIG_BLOCK */
 
 struct block_device;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 70e61b5..8363a10 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2320,14 +2320,6 @@ extern struct super_block *freeze_bdev(struct block_device *);
 extern void emergency_thaw_all(void);
 extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
 extern int fsync_bdev(struct block_device *);
-#ifdef CONFIG_FS_DAX
-extern bool blkdev_dax_capable(struct block_device *bdev);
-#else
-static inline bool blkdev_dax_capable(struct block_device *bdev)
-{
-	return false;
-}
-#endif
 
 extern struct super_block *blockdev_superblock;
 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
