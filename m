Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <54108149.3060506@plexistor.com>
Date: Wed, 10 Sep 2014 19:50:17 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH] SQUASHME pmem: Micro optimization for pmem_direct_access
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com> <540F1EC6.4000504@plexistor.com>
In-Reply-To: <540F1EC6.4000504@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Boaz Harrosh <boaz@plexistor.com>

Please note: This patch spans two patches in the set:

* The changes to pmem_lookup_pg_addr from [patch 1/4]
* The removal to pmem_lookup_pfn and changes to pmem_direct_access
  from [patch 4/4]

This is the hotpath I care about / pmem_direct_access()
Easier on the eyes too

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/pmem.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index 5eda95a..4a9d65e 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -61,22 +61,12 @@ static int pmem_getgeo(struct block_device *bd, struct hd_geometry *geo)
  */
 static void *pmem_lookup_pg_addr(struct pmem_device *pmem, sector_t sector)
 {
-	size_t page_offset = sector >> PAGE_SECTORS_SHIFT;
-	size_t offset = page_offset << PAGE_SHIFT;
+	size_t offset = sector << SECTOR_SHIFT;
 
 	BUG_ON(offset >= pmem->size);
 	return pmem->virt_addr + offset;
 }
 
-/* sector must be page aligned */
-static unsigned long pmem_lookup_pfn(struct pmem_device *pmem, sector_t sector)
-{
-	size_t page_offset = sector >> PAGE_SECTORS_SHIFT;
-
-	BUG_ON(sector & (PAGE_SECTORS - 1));
-	return (pmem->phys_addr >> PAGE_SHIFT) + page_offset;
-}
-
 /*
  * sector is not required to be page aligned.
  * n is at most a single page, but could be less.
@@ -200,14 +190,16 @@ static long pmem_direct_access(struct block_device *bdev, sector_t sector,
 			      void **kaddr, unsigned long *pfn, long size)
 {
 	struct pmem_device *pmem = bdev->bd_disk->private_data;
+	size_t offset = sector << SECTOR_SHIFT;
 
 	if (!pmem)
 		return -ENODEV;
 
-	*kaddr = pmem_lookup_pg_addr(pmem, sector);
-	*pfn = pmem_lookup_pfn(pmem, sector);
+	BUG_ON(offset >= pmem->size);
+	*kaddr = pmem->virt_addr + offset;
+	*pfn = (pmem->phys_addr + offset) >> PAGE_SHIFT;
 
-	return pmem->size - (sector * 512);
+	return pmem->size - offset;
 }
 
 static const struct block_device_operations pmem_fops = {
-- 
1.9.3


