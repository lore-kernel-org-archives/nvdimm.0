Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH 07/15] fs/block_dev.c: skip rw_page if bdev has integrity
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:55:24 -0400
Message-ID: <20150617235524.12943.51967.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-nvdimm@lists.01.org
Cc: boaz@plexistor.com, toshi.kani@hp.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, linux-kernel@vger.kernel.org, mingo@kernel.org, Jens Axboe <axboe@fb.com>, linux-acpi@vger.kernel.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

From: Vishal Verma <vishal.l.verma@linux.intel.com>

If a block device has bio integrity enabled, rw_page will bypass the
integrity payload, which is undesirable. Skip rw_page if this is the
case.

Currently brd and zram provide rw_page, and the proposed 'nd' drivers
will too.

Cc: Jens Axboe <axboe@fb.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Suggested-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/block_dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index c7e4163ede87..054ef1bbb821 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -376,7 +376,7 @@ int bdev_read_page(struct block_device *bdev, sector_t sector,
 			struct page *page)
 {
 	const struct block_device_operations *ops = bdev->bd_disk->fops;
-	if (!ops->rw_page)
+	if (!ops->rw_page || bdev_get_integrity(bdev))
 		return -EOPNOTSUPP;
 	return ops->rw_page(bdev, sector + get_start_sect(bdev), page, READ);
 }
@@ -407,7 +407,7 @@ int bdev_write_page(struct block_device *bdev, sector_t sector,
 	int result;
 	int rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE;
 	const struct block_device_operations *ops = bdev->bd_disk->fops;
-	if (!ops->rw_page)
+	if (!ops->rw_page || bdev_get_integrity(bdev))
 		return -EOPNOTSUPP;
 	set_page_writeback(page);
 	result = ops->rw_page(bdev, sector + get_start_sect(bdev), page, rw);

