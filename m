Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F56D1A1E11
 for <linux-nvdimm@lists.01.org>; Wed, 22 Jun 2016 17:05:47 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 1/3] block: add QUEUE_FLAG_DAX for devices to advertise
 their DAX support
Date: Wed, 22 Jun 2016 17:54:52 -0600
Message-Id: <1466639694-25394-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1466639694-25394-1-git-send-email-toshi.kani@hpe.com>
References: <1466639694-25394-1-git-send-email-toshi.kani@hpe.com>
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
To: snitzer@redhat.com, axboe@kernel.dk, dan.j.williams@intel.com
Cc: linux-s390@vger.kernel.org, linux-nvdimm@lists.01.org, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, viro@zeniv.linux.org.uk, Martin Schwidefsky <schwidefsky@de.ibm.com>, agk@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

Currently, presence of direct_access() in block_device_operations
indicates support of DAX on its block device.  Because
block_device_operations is instantiated with 'const', this DAX
capablity may not be enabled conditinally.

In preparation for supporting DAX to device-mapper devices, add
QUEUE_FLAG_DAX to request_queue flags to advertise their DAX
support.  This will allow to set the DAX capability based on how
mapped device is composed.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <linux-s390@vger.kernel.org>
---
 drivers/block/brd.c          |    4 +++-
 drivers/nvdimm/pmem.c        |    1 +
 drivers/s390/block/dcssblk.c |    1 +
 fs/block_dev.c               |    5 +++--
 include/linux/blkdev.h       |    2 ++
 5 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index f5b0d6f..dd96a93 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -509,7 +509,9 @@ static struct brd_device *brd_alloc(int i)
 	blk_queue_max_discard_sectors(brd->brd_queue, UINT_MAX);
 	brd->brd_queue->limits.discard_zeroes_data = 1;
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, brd->brd_queue);
-
+#ifdef CONFIG_BLK_DEV_RAM_DAX
+	queue_flag_set_unlocked(QUEUE_FLAG_DAX, brd->brd_queue);
+#endif
 	disk = brd->brd_disk = alloc_disk(max_part);
 	if (!disk)
 		goto out_free_queue;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 608fc44..53b701b 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -283,6 +283,7 @@ static int pmem_attach_disk(struct device *dev,
 	blk_queue_max_hw_sectors(q, UINT_MAX);
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
+	queue_flag_set_unlocked(QUEUE_FLAG_DAX, q);
 	q->queuedata = pmem;
 
 	disk = alloc_disk_node(0, nid);
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index bed53c4..093e9e1 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -618,6 +618,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	dev_info->gd->driverfs_dev = &dev_info->dev;
 	blk_queue_make_request(dev_info->dcssblk_queue, dcssblk_make_request);
 	blk_queue_logical_block_size(dev_info->dcssblk_queue, 4096);
+	queue_flag_set_unlocked(QUEUE_FLAG_DAX, dev_info->dcssblk_queue);
 
 	seg_byte_size = (dev_info->end - dev_info->start + 1);
 	set_capacity(dev_info->gd, seg_byte_size >> 9); // size in sectors
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 71ccab1..d012be4 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -493,7 +493,7 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
 
 	if (size < 0)
 		return size;
-	if (!ops->direct_access)
+	if (!blk_queue_dax(bdev_get_queue(bdev)) || !ops->direct_access)
 		return -EOPNOTSUPP;
 	if ((sector + DIV_ROUND_UP(size, 512)) >
 					part_nr_sects_read(bdev->bd_part))
@@ -1287,7 +1287,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 		bdev->bd_disk = disk;
 		bdev->bd_queue = disk->queue;
 		bdev->bd_contains = bdev;
-		if (IS_ENABLED(CONFIG_BLK_DEV_DAX) && disk->fops->direct_access)
+		if (IS_ENABLED(CONFIG_BLK_DEV_DAX) &&
+		    blk_queue_dax(disk->queue))
 			bdev->bd_inode->i_flags = S_DAX;
 		else
 			bdev->bd_inode->i_flags = 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9746d22..1493ab3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -505,6 +505,7 @@ struct request_queue {
 #define QUEUE_FLAG_WC	       23	/* Write back caching */
 #define QUEUE_FLAG_FUA	       24	/* device supports FUA writes */
 #define QUEUE_FLAG_FLUSH_NQ    25	/* flush not queueuable */
+#define QUEUE_FLAG_DAX         26	/* device supports DAX */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -594,6 +595,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
 #define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
 	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
+#define blk_queue_dax(q)	test_bit(QUEUE_FLAG_DAX, &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
