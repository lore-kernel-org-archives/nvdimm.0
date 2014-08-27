Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 3/4] pmem: Add support for rw_page()
Date: Wed, 27 Aug 2014 15:12:01 -0600
Message-Id: <1409173922-7484-4-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Boaz Harrosh <boaz@plexistor.com>, Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Based on commit a72132c31d58 ("brd: add support for rw_page()")

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/block/pmem.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index 60bbe0d..0be3669 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -183,8 +183,19 @@ out:
 	bio_endio(bio, err);
 }
 
+static int pmem_rw_page(struct block_device *bdev, sector_t sector,
+		       struct page *page, int rw)
+{
+	struct pmem_device *pmem = bdev->bd_disk->private_data;
+
+	pmem_do_bvec(pmem, page, PAGE_CACHE_SIZE, 0, rw, sector);
+	page_endio(page, rw & WRITE, 0);
+	return 0;
+}
+
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
+	.rw_page =		pmem_rw_page,
 	.getgeo =		pmem_getgeo,
 };
 
-- 
1.9.3

