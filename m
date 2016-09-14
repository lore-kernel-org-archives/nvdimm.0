From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH] block_dev: remove DAX leftovers
Date: Wed, 14 Sep 2016 11:56:13 +0200
Message-ID: <1473846973-18798-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

DAX support for block devices was removed in commits 03cdad
("block: disable block device DAX by default") and 99a01cd
("block: remove BLK_DEV_DAX config option"), but we still kept a call to
dax_do_io and some uneeded i_flags manipulations introduced in commit
bbab37 ("block: Add support for DAX reads/writes to block devices").

Remove those leftovers.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/block_dev.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index c3cdde8..45f5491 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -180,9 +180,6 @@ blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = bdev_file_inode(file);
 
-	if (IS_DAX(inode))
-		return dax_do_io(iocb, inode, iter, blkdev_get_block,
-				NULL, DIO_SKIP_DIO_COUNT);
 	return __blockdev_direct_IO(iocb, inode, I_BDEV(inode), iter,
 				    blkdev_get_block, NULL, NULL,
 				    DIO_SKIP_DIO_COUNT);
@@ -1274,7 +1271,6 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 		bdev->bd_disk = disk;
 		bdev->bd_queue = disk->queue;
 		bdev->bd_contains = bdev;
-		bdev->bd_inode->i_flags = 0;
 
 		if (!partno) {
 			ret = -ENXIO;
@@ -1302,11 +1298,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 				}
 			}
 
-			if (!ret) {
+			if (!ret)
 				bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
-				if (!bdev_dax_capable(bdev))
-					bdev->bd_inode->i_flags &= ~S_DAX;
-			}
 
 			/*
 			 * If the device is invalidated, rescan partition
@@ -1341,8 +1334,6 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 				goto out_clear;
 			}
 			bd_set_size(bdev, (loff_t)bdev->bd_part->nr_sects << 9);
-			if (!bdev_dax_capable(bdev))
-				bdev->bd_inode->i_flags &= ~S_DAX;
 		}
 	} else {
 		if (bdev->bd_contains == bdev) {
-- 
2.1.4
