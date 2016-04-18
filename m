Return-Path: <linux-ext4-owner@vger.kernel.org>
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 12/18] dax: Remove redundant inode size checks
Date: Mon, 18 Apr 2016 23:35:35 +0200
Message-Id: <1461015341-20153-13-git-send-email-jack@suse.cz>
In-Reply-To: <1461015341-20153-1-git-send-email-jack@suse.cz>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-mm@kvack.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <willy@linux.intel.com>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Callers of dax fault handlers must make sure these calls cannot race
with truncate. Thus it is enough to check inode size when entering the
function and we don't have to recheck it again later in the handler.
Note that inode size itself can be decreased while the fault handler
runs but filesystem locking prevents against any radix tree or block
mapping information changes resulting from the truncate and that is what
we really care about.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 60 +-----------------------------------------------------------
 1 file changed, 1 insertion(+), 59 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 42bf65b4e752..d7addfab2094 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -305,20 +305,11 @@ EXPORT_SYMBOL_GPL(dax_do_io);
 static int dax_load_hole(struct address_space *mapping, struct page *page,
 							struct vm_fault *vmf)
 {
-	unsigned long size;
-	struct inode *inode = mapping->host;
 	if (!page)
 		page = find_or_create_page(mapping, vmf->pgoff,
 						GFP_KERNEL | __GFP_ZERO);
 	if (!page)
 		return VM_FAULT_OOM;
-	/* Recheck i_size under page lock to avoid truncate race */
-	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (vmf->pgoff >= size) {
-		unlock_page(page);
-		put_page(page);
-		return VM_FAULT_SIGBUS;
-	}
 
 	vmf->page = page;
 	return VM_FAULT_LOCKED;
@@ -549,24 +540,10 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 		.sector = to_sector(bh, inode),
 		.size = bh->b_size,
 	};
-	pgoff_t size;
 	int error;
 
 	i_mmap_lock_read(mapping);
 
-	/*
-	 * Check truncate didn't happen while we were allocating a block.
-	 * If it did, this block may or may not be still allocated to the
-	 * file.  We can't tell the filesystem to free it because we can't
-	 * take i_mutex here.  In the worst case, the file still has blocks
-	 * allocated past the end of the file.
-	 */
-	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (unlikely(vmf->pgoff >= size)) {
-		error = -EIO;
-		goto out;
-	}
-
 	if (dax_map_atomic(bdev, &dax) < 0) {
 		error = PTR_ERR(dax.addr);
 		goto out;
@@ -632,15 +609,6 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			put_page(page);
 			goto repeat;
 		}
-		size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		if (unlikely(vmf->pgoff >= size)) {
-			/*
-			 * We have a struct page covering a hole in the file
-			 * from a read fault and we've raced with a truncate
-			 */
-			error = -EIO;
-			goto unlock_page;
-		}
 	}
 
 	error = get_block(inode, block, &bh, 0);
@@ -673,17 +641,8 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		if (error)
 			goto unlock_page;
 		vmf->page = page;
-		if (!page) {
+		if (!page)
 			i_mmap_lock_read(mapping);
-			/* Check we didn't race with truncate */
-			size = (i_size_read(inode) + PAGE_SIZE - 1) >>
-								PAGE_SHIFT;
-			if (vmf->pgoff >= size) {
-				i_mmap_unlock_read(mapping);
-				error = -EIO;
-				goto out;
-			}
-		}
 		return VM_FAULT_LOCKED;
 	}
 
@@ -861,23 +820,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 
 	i_mmap_lock_read(mapping);
 
-	/*
-	 * If a truncate happened while we were allocating blocks, we may
-	 * leave blocks allocated to the file that are beyond EOF.  We can't
-	 * take i_mutex here, so just leave them hanging; they'll be freed
-	 * when the file is deleted.
-	 */
-	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (pgoff >= size) {
-		result = VM_FAULT_SIGBUS;
-		goto out;
-	}
-	if ((pgoff | PG_PMD_COLOUR) >= size) {
-		dax_pmd_dbg(&bh, address,
-				"offset + huge page size > file size");
-		goto fallback;
-	}
-
 	if (!write && !buffer_mapped(&bh)) {
 		spinlock_t *ptl;
 		pmd_t entry;
-- 
2.6.6

