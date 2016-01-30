Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2] block: use DAX for partition table reads
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Jan 2016 16:33:50 -0800
Message-ID: <20160130003125.6392.17801.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160129151846.18752.48460.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160129151846.18752.48460.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, axboe@fb.com, Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Avoid populating pagecache when the block device is in DAX mode.
Otherwise these page cache entries collide with the fsync/msync
implementation and break data durability guarantees.

Cc: Jan Kara <jack@suse.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes in v2:
1/ Switch from __page_cache_alloc to alloc_pages (Jens)

2/ Move read_dax_sector() declaration to include/linux/dax.h (Willy)

3/ Collect Reviewed-by and Tested-by tags from Willy and Ross.

 block/partition-generic.c |   18 +++++++++++++++---
 fs/dax.c                  |   20 ++++++++++++++++++++
 include/linux/dax.h       |   11 +++++++++++
 3 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index 746935a5973c..fefd01b496a0 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -16,6 +16,7 @@
 #include <linux/kmod.h>
 #include <linux/ctype.h>
 #include <linux/genhd.h>
+#include <linux/dax.h>
 #include <linux/blktrace_api.h>
 
 #include "partitions/check.h"
@@ -550,13 +551,24 @@ int invalidate_partitions(struct gendisk *disk, struct block_device *bdev)
 	return 0;
 }
 
-unsigned char *read_dev_sector(struct block_device *bdev, sector_t n, Sector *p)
+static struct page *read_pagecache_sector(struct block_device *bdev, sector_t n)
 {
 	struct address_space *mapping = bdev->bd_inode->i_mapping;
+
+	return read_mapping_page(mapping, (pgoff_t)(n >> (PAGE_CACHE_SHIFT-9)),
+			NULL);
+}
+
+unsigned char *read_dev_sector(struct block_device *bdev, sector_t n, Sector *p)
+{
 	struct page *page;
 
-	page = read_mapping_page(mapping, (pgoff_t)(n >> (PAGE_CACHE_SHIFT-9)),
-				 NULL);
+	/* don't populate page cache for dax capable devices */
+	if (IS_DAX(bdev->bd_inode))
+		page = read_dax_sector(bdev, n);
+	else
+		page = read_pagecache_sector(bdev, n);
+
 	if (!IS_ERR(page)) {
 		if (PageError(page))
 			goto fail;
diff --git a/fs/dax.c b/fs/dax.c
index 4fd6b0c5c6b5..e0e9358baf35 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -58,6 +58,26 @@ static void dax_unmap_atomic(struct block_device *bdev,
 	blk_queue_exit(bdev->bd_queue);
 }
 
+struct page *read_dax_sector(struct block_device *bdev, sector_t n)
+{
+	struct page *page = alloc_pages(GFP_KERNEL, 0);
+	struct blk_dax_ctl dax = {
+		.size = PAGE_SIZE,
+		.sector = n & ~((((int) PAGE_SIZE) / 512) - 1),
+	};
+	long rc;
+
+	if (!page)
+		return ERR_PTR(-ENOMEM);
+
+	rc = dax_map_atomic(bdev, &dax);
+	if (rc < 0)
+		return ERR_PTR(rc);
+	memcpy_from_pmem(page_address(page), dax.addr, PAGE_SIZE);
+	dax_unmap_atomic(bdev, &dax);
+	return page;
+}
+
 /*
  * dax_clear_blocks() is called from within transaction context from XFS,
  * and hence this means the stack from this point must follow GFP_NOFS
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 8204c3dc3800..818e45078929 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -14,6 +14,17 @@ int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
 		dax_iodone_t);
 int __dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
 		dax_iodone_t);
+
+#ifdef CONFIG_FS_DAX
+struct page *read_dax_sector(struct block_device *bdev, sector_t n);
+#else
+static inline struct page *read_dax_sector(struct block_device *bdev,
+		sector_t n)
+{
+	return ERR_PTR(-ENXIO);
+}
+#endif
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 int dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
 				unsigned int flags, get_block_t, dax_iodone_t);

