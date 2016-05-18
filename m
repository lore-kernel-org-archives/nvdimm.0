Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] remove unused blkdev_dax_capable() function
Date: Wed, 18 May 2016 09:54:08 +0200
Message-ID: <3280835.MNk2ItMooy@wuerfel>
In-Reply-To: <1462897437-16626-7-git-send-email-toshi.kani@hpe.com>
References: <1462897437-16626-1-git-send-email-toshi.kani@hpe.com> <1462897437-16626-7-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: dan.j.williams@intel.com, jack@suse.cz, david@fromorbit.com, viro@zeniv.linux.org.uk, axboe@fb.com, hch@infradead.org, boaz@plexistor.com, tytso@mit.edu, adilger.kernel@dilger.ca, ross.zwisler@linux.intel.com, micah.parrish@hpe.com, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The change from blkdev_dax_capable() to bdev_dax_capable() removed the only user
of the former, so we now get a build warning:

fs/block_dev.c:1244:13: error: 'blkdev_dax_capable' defined but not used [-Werror=unused-function]
 static bool blkdev_dax_capable(struct block_device *bdev)

This removes the now-unused function.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: a8078b1fc616 ("block: Update blkdev_dax_capable() for consistency")
---
On Tuesday 10 May 2016 10:23:57 Toshi Kani wrote:
> @@ -1295,7 +1330,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
>  
>                         if (!ret) {
>                                 bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
> -                               if (!blkdev_dax_capable(bdev))
> +                               if (!bdev_dax_capable(bdev))
>                                         bdev->bd_inode->i_flags &= ~S_DAX;
> 

It's not entirely from the patch description what the intention was here
in keeping two slightly different implementations of the same function
in one file, my best guess is that it was not intentional and we should
just remove this.

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 97f324642b5f..dad77225a721 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1241,33 +1241,6 @@ void bd_set_size(struct block_device *bdev, loff_t size)
 }
 EXPORT_SYMBOL(bd_set_size);
 
-static bool blkdev_dax_capable(struct block_device *bdev)
-{
-	struct gendisk *disk = bdev->bd_disk;
-
-	if (!disk->fops->direct_access || !IS_ENABLED(CONFIG_FS_DAX))
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
-
 static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part);
 
 /*
