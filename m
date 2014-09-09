Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <540F1FBB.2000706@plexistor.com>
Date: Tue, 09 Sep 2014 18:41:47 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 2/9] SQUASHME: pmem: Request from fdisk 4k alignment
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com> <540F1EC6.4000504@plexistor.com>
In-Reply-To: <540F1EC6.4000504@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org
Cc: Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Boaz Harrosh <boaz@plexistor.com>

Because of the direct_access() API which returns a PFN. partitions
better start on 4K boundary, else offset ZERO of a partition will
not be aligned and blk_direct_access() will fail the call.

By setting blk_queue_physical_block_size(PAGE_SIZE) we can communicate
this to fdisk and friends.
Note that blk_queue_physical_block_size() also trashes io_min, but
we can leave this one to be 512.

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/pmem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index 8b0b9b0..499536c 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -258,6 +258,12 @@ static struct pmem_device *pmem_alloc(int i)
 	blk_queue_max_hw_sectors(pmem->pmem_queue, 1024);
 	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
 
+	/* This is so fdisk will align partitions on 4k, because of
+	 * direct_access API needing 4k alignment, returning a PFN
+	 */
+	blk_queue_physical_block_size(pmem->pmem_queue, PAGE_SIZE);
+	pmem->pmem_queue->limits.io_min = 512; /* Don't use the accessor */
+
 	disk = pmem->pmem_disk = alloc_disk(0);
 	if (!disk)
 		goto out_free_queue;
-- 
1.9.3

