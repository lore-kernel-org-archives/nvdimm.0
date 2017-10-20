Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E31B2034715B
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 22:20:32 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/2] dm log writes: add support for DAX
Date: Thu, 19 Oct 2017 23:24:04 -0600
Message-Id: <20171020052404.13762-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20171020052404.13762-1-ross.zwisler@linux.intel.com>
References: <20171020052404.13762-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Now that we have the ability log filesystem writes using a flat buffer, add
support for DAX.  Unfortunately we can't easily track data that has been
written via mmap() now that the dax_flush() abstraction was removed by this
commit:

commit c3ca015fab6d ("dax: remove the pmem_dax_ops->flush abstraction")

Otherwise we could just treat each flush as a big write, and store the data
that is being synced to media.  It may be worthwhile to add the dax_flush()
entry point back, just as a notifier so we can do this logging.

The motivation for this support is the need for an xfstest that can test
the new MAP_SYNC DAX flag.  By logging the filesystem activity with
dm-log-writes we can show that the MAP_SYNC page faults are writing out
their metadata as they happen, instead of requiring an explicit
msync/fsync.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---

Here's a link to Jan's latest MAP_SYNC set, which can be used for the
fstest:

https://www.spinics.net/lists/linux-xfs/msg11852.html

MAP_SYNC is not needed for basic DAX+dm-log-writes functionality.

---
 drivers/md/dm-log-writes.c | 90 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 89 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index c65f9d1..6a8d352 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -10,9 +10,11 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/bio.h>
+#include <linux/dax.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/uio.h>
 
 #define DM_MSG_PREFIX "log-writes"
 
@@ -609,6 +611,50 @@ static int log_mark(struct log_writes_c *lc, char *data)
 	return 0;
 }
 
+static int log_dax(struct log_writes_c *lc, sector_t sector, size_t bytes,
+		struct iov_iter *i)
+{
+	struct pending_block *block;
+
+	if (!bytes)
+		return 0;
+
+	block = kzalloc(sizeof(struct pending_block), GFP_KERNEL);
+	if (!block) {
+		DMERR("Error allocating dax pending block");
+		return -ENOMEM;
+	}
+
+	block->data = kzalloc(bytes, GFP_KERNEL);
+	if (!block->data) {
+		DMERR("Error allocating dax data space");
+		kfree(block);
+		return -ENOMEM;
+	}
+
+	/* write data provided via the iterator */
+	if (!copy_from_iter(block->data, bytes, i)) {
+		DMERR("Error copying dax data");
+		kfree(block->data);
+		kfree(block);
+		return -EIO;
+	}
+
+	/* rewind the iterator so that the block driver can use it */
+	iov_iter_revert(i, bytes);
+
+	block->datalen = bytes;
+	block->sector = bio_to_dev_sectors(lc, sector);
+	block->nr_sectors = ALIGN(bytes, lc->sectorsize) >> lc->sectorshift;
+
+	atomic_inc(&lc->pending_blocks);
+	spin_lock_irq(&lc->blocks_lock);
+	list_add_tail(&block->list, &lc->unflushed_blocks);
+	spin_unlock_irq(&lc->blocks_lock);
+	wake_up_process(lc->log_kthread);
+	return 0;
+}
+
 static void log_writes_dtr(struct dm_target *ti)
 {
 	struct log_writes_c *lc = ti->private;
@@ -874,9 +920,49 @@ static void log_writes_io_hints(struct dm_target *ti, struct queue_limits *limit
 	limits->io_min = limits->physical_block_size;
 }
 
+static long log_writes_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn)
+{
+	struct log_writes_c *lc = ti->private;
+	struct block_device *bdev = lc->dev->bdev;
+	struct dax_device *dax_dev = lc->dev->dax_dev;
+	sector_t sector = pgoff * PAGE_SECTORS;
+	int ret;
+
+	ret = bdev_dax_pgoff(bdev, sector, nr_pages * PAGE_SIZE, &pgoff);
+	if (ret)
+		return ret;
+	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
+}
+
+static size_t log_writes_dax_copy_from_iter(struct dm_target *ti,
+		pgoff_t pgoff, void *addr, size_t bytes, struct iov_iter *i)
+{
+	struct log_writes_c *lc = ti->private;
+	struct block_device *bdev = lc->dev->bdev;
+	struct dax_device *dax_dev = lc->dev->dax_dev;
+	sector_t sector = pgoff * PAGE_SECTORS;
+	int err;
+
+	if (bdev_dax_pgoff(bdev, sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
+		return 0;
+
+	/* Don't bother doing anything if logging has been disabled */
+	if (!lc->logging_enabled)
+		goto dax_copy;
+
+	err = log_dax(lc, sector, bytes, i);
+	if (err) {
+		DMWARN("Error %d logging DAX write", err);
+		return 0;
+	}
+dax_copy:
+	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
+}
+
 static struct target_type log_writes_target = {
 	.name   = "log-writes",
-	.version = {1, 0, 0},
+	.version = {1, 0, 1},
 	.module = THIS_MODULE,
 	.ctr    = log_writes_ctr,
 	.dtr    = log_writes_dtr,
@@ -887,6 +973,8 @@ static struct target_type log_writes_target = {
 	.message = log_writes_message,
 	.iterate_devices = log_writes_iterate_devices,
 	.io_hints = log_writes_io_hints,
+	.direct_access = log_writes_dax_direct_access,
+	.dax_copy_from_iter = log_writes_dax_copy_from_iter,
 };
 
 static int __init dm_log_writes_init(void)
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
