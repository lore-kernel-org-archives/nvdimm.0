Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/2] pmem: Add simple and slow fsync/msync support
Date: Wed, 28 Oct 2015 16:09:36 -0600
Message-Id: <1446070176-14568-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1446070176-14568-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1446070176-14568-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm@lists.01.org, x86@kernel.org, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

Make blkdev_issue_flush() behave correctly according to its required
semantics - all volatile cached data is flushed to stable storage.

Eventually this needs to be replaced with something much more precise by
tracking dirty DAX entries via the radix tree in struct address_space, but
for now this gives us correctness even if the performance is quite bad.

Userspace applications looking to avoid the fsync/msync penalty should
consider more fine-grained flushing via the NVML library:

https://github.com/pmem/nvml

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/nvdimm/pmem.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 0ba6a97..eea7997 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -80,7 +80,14 @@ static void pmem_make_request(struct request_queue *q, struct bio *bio)
 	if (do_acct)
 		nd_iostat_end(bio, start);
 
-	if (bio_data_dir(bio))
+	if (bio->bi_rw & REQ_FLUSH) {
+		void __pmem *addr = pmem->virt_addr + pmem->data_offset;
+		size_t size = pmem->size - pmem->data_offset;
+
+		wb_cache_pmem(addr, size);
+	}
+
+	if (bio_data_dir(bio) || (bio->bi_rw & REQ_FLUSH))
 		wmb_pmem();
 
 	bio_endio(bio);
@@ -189,6 +196,7 @@ static int pmem_attach_disk(struct device *dev,
 	blk_queue_physical_block_size(pmem->pmem_queue, PAGE_SIZE);
 	blk_queue_max_hw_sectors(pmem->pmem_queue, UINT_MAX);
 	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
+	blk_queue_flush(pmem->pmem_queue, REQ_FLUSH);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, pmem->pmem_queue);
 
 	disk = alloc_disk(0);
-- 
2.1.0

