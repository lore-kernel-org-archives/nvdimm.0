Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH] block: protect rw_page against device teardown
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Nov 2015 16:14:03 -0800
Message-ID: <20151120001403.27823.74467.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-block@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Fix use after free crashes like the following:

 general protection fault: 0000 [#1] SMP
 Call Trace:
  [<ffffffffa0050216>] ? pmem_do_bvec.isra.12+0xa6/0xf0 [nd_pmem]
  [<ffffffffa0050ba2>] pmem_rw_page+0x42/0x80 [nd_pmem]
  [<ffffffff8128fd90>] bdev_read_page+0x50/0x60
  [<ffffffff812972f0>] do_mpage_readpage+0x510/0x770
  [<ffffffff8128fd20>] ? I_BDEV+0x20/0x20
  [<ffffffff811d86dc>] ? lru_cache_add+0x1c/0x50
  [<ffffffff81297657>] mpage_readpages+0x107/0x170
  [<ffffffff8128fd20>] ? I_BDEV+0x20/0x20
  [<ffffffff8128fd20>] ? I_BDEV+0x20/0x20
  [<ffffffff8129058d>] blkdev_readpages+0x1d/0x20
  [<ffffffff811d615f>] __do_page_cache_readahead+0x28f/0x310
  [<ffffffff811d6039>] ? __do_page_cache_readahead+0x169/0x310
  [<ffffffff811c5abd>] ? pagecache_get_page+0x2d/0x1d0
  [<ffffffff811c76f6>] filemap_fault+0x396/0x530
  [<ffffffff811f816e>] __do_fault+0x4e/0xf0
  [<ffffffff811fce7d>] handle_mm_fault+0x11bd/0x1b50

Cc: <stable@vger.kernel.org>
Cc: Jens Axboe <axboe@fb.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/block_dev.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index bb0dfb1c7af1..cc0af12acf94 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -390,9 +390,17 @@ int bdev_read_page(struct block_device *bdev, sector_t sector,
 			struct page *page)
 {
 	const struct block_device_operations *ops = bdev->bd_disk->fops;
+	int rc = -EOPNOTSUPP;
+
 	if (!ops->rw_page || bdev_get_integrity(bdev))
-		return -EOPNOTSUPP;
-	return ops->rw_page(bdev, sector + get_start_sect(bdev), page, READ);
+		return rc;
+
+	rc = blk_queue_enter(bdev->bd_queue, GFP_KERNEL);
+	if (rc)
+		return rc;
+	rc = ops->rw_page(bdev, sector + get_start_sect(bdev), page, READ);
+	blk_queue_exit(bdev->bd_queue);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(bdev_read_page);
 
@@ -421,14 +429,20 @@ int bdev_write_page(struct block_device *bdev, sector_t sector,
 	int result;
 	int rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE;
 	const struct block_device_operations *ops = bdev->bd_disk->fops;
+
 	if (!ops->rw_page || bdev_get_integrity(bdev))
 		return -EOPNOTSUPP;
+	result = blk_queue_enter(bdev->bd_queue, GFP_KERNEL);
+	if (result)
+		return result;
+
 	set_page_writeback(page);
 	result = ops->rw_page(bdev, sector + get_start_sect(bdev), page, rw);
 	if (result)
 		end_page_writeback(page);
 	else
 		unlock_page(page);
+	blk_queue_exit(bdev->bd_queue);
 	return result;
 }
 EXPORT_SYMBOL_GPL(bdev_write_page);

