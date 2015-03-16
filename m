Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 3/6] pmem: Add support for rw_page()
Date: Mon, 16 Mar 2015 15:12:57 -0600
Message-Id: <1426540380-24503-4-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1426540380-24503-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1426540380-24503-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, riel@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

Based on commit a72132c31d58 ("brd: add support for rw_page()")

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk
Cc: hch@infradead.org
Cc: riel@redhat.com
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

