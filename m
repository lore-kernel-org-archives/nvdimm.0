Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 4/6] pmem: Add support for direct_access()
Date: Mon, 16 Mar 2015 15:12:58 -0600
Message-Id: <1426540380-24503-5-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1426540380-24503-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1426540380-24503-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, riel@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk
Cc: hch@infradead.org
Cc: riel@redhat.com
---
 drivers/block/pmem.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index 0be3669..d63bc96 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -74,6 +74,15 @@ static void *pmem_lookup_pg_addr(struct pmem_device *pmem, sector_t sector)
 	return pmem->virt_addr + offset;
 }
 
+/* sector must be page aligned */
+static unsigned long pmem_lookup_pfn(struct pmem_device *pmem, sector_t sector)
+{
+	size_t page_offset = sector >> PAGE_SECTORS_SHIFT;
+
+	BUG_ON(sector & (PAGE_SECTORS - 1));
+	return (pmem->phys_addr >> PAGE_SHIFT) + page_offset;
+}
+
 /*
  * sector is not required to be page aligned.
  * n is at most a single page, but could be less.
@@ -193,9 +202,24 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	return 0;
 }
 
+static long pmem_direct_access(struct block_device *bdev, sector_t sector,
+			      void **kaddr, unsigned long *pfn, long size)
+{
+	struct pmem_device *pmem = bdev->bd_disk->private_data;
+
+	if (!pmem)
+		return -ENODEV;
+
+	*kaddr = pmem_lookup_pg_addr(pmem, sector);
+	*pfn = pmem_lookup_pfn(pmem, sector);
+
+	return pmem->size - (sector * 512);
+}
+
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		pmem_rw_page,
+	.direct_access =	pmem_direct_access,
 	.getgeo =		pmem_getgeo,
 };
 
-- 
1.9.3

