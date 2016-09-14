From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/12] dax: don't pass buffer_head to dax_insert_mapping
Date: Wed, 14 Sep 2016 12:01:22 +0200
Message-ID: <1473847291-18913-4-git-send-email-hch@lst.de>
References: <1473847291-18913-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1473847291-18913-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
Cc: ross.zwisler@linux.intel.com
List-Id: linux-nvdimm@lists.01.org

This way we can use this helper for the iomap based DAX implementation
as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 993dc6f..98463bb 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -790,14 +790,13 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
 static int dax_insert_mapping(struct address_space *mapping,
-			struct buffer_head *bh, void **entryp,
-			struct vm_area_struct *vma, struct vm_fault *vmf)
+		struct block_device *bdev, sector_t sector, size_t size,
+		void **entryp, struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	unsigned long vaddr = (unsigned long)vmf->virtual_address;
-	struct block_device *bdev = bh->b_bdev;
 	struct blk_dax_ctl dax = {
-		.sector = to_sector(bh, mapping->host),
-		.size = bh->b_size,
+		.sector = sector,
+		.size = size,
 	};
 	void *ret;
 	void *entry = *entryp;
@@ -898,7 +897,8 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 
 	/* Filesystem should not return unwritten buffers to us! */
 	WARN_ON_ONCE(buffer_unwritten(&bh) || buffer_new(&bh));
-	error = dax_insert_mapping(mapping, &bh, &entry, vma, vmf);
+	error = dax_insert_mapping(mapping, bh.b_bdev, to_sector(&bh, inode),
+			bh.b_size, &entry, vma, vmf);
  unlock_entry:
 	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
  out:
-- 
2.1.4

