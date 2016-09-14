From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/12] dax: don't pass buffer_head to copy_user_dax
Date: Wed, 14 Sep 2016 12:01:23 +0200
Message-ID: <1473847291-18913-5-git-send-email-hch@lst.de>
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
index 98463bb..84343ce 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -580,14 +580,13 @@ static int dax_load_hole(struct address_space *mapping, void *entry,
 	return VM_FAULT_LOCKED;
 }
 
-static int copy_user_bh(struct page *to, struct inode *inode,
-		struct buffer_head *bh, unsigned long vaddr)
+static int copy_user_dax(struct block_device *bdev, sector_t sector, size_t size,
+		struct page *to, unsigned long vaddr)
 {
 	struct blk_dax_ctl dax = {
-		.sector = to_sector(bh, inode),
-		.size = bh->b_size,
+		.sector = sector,
+		.size = size,
 	};
-	struct block_device *bdev = bh->b_bdev;
 	void *vto;
 
 	if (dax_map_atomic(bdev, &dax) < 0)
@@ -867,7 +866,8 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	if (vmf->cow_page) {
 		struct page *new_page = vmf->cow_page;
 		if (buffer_written(&bh))
-			error = copy_user_bh(new_page, inode, &bh, vaddr);
+			error = copy_user_dax(bh.b_bdev, to_sector(&bh, inode),
+					bh.b_size, new_page, vaddr);
 		else
 			clear_user_highpage(new_page, vaddr);
 		if (error)
-- 
2.1.4

