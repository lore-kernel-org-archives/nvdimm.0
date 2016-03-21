Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 35F121A1FCE
 for <linux-nvdimm@lists.01.org>; Mon, 21 Mar 2016 06:22:56 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 06/10] dax: Remove redundant inode size checks
Date: Mon, 21 Mar 2016 14:22:51 +0100
Message-Id: <1458566575-28063-7-git-send-email-jack@suse.cz>
In-Reply-To: <1458566575-28063-1-git-send-email-jack@suse.cz>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Callers of dax fault handlers must make sure these calls cannot race
with truncate. Thus it is enough to check inode size when entering the
function and we don't have to recheck it again later in the handler.
Note that inode size itself can be decreased while the fault handler
runs but filesystem locking prevents against any radix tree or block
mapping information changes resulting from the truncate and that is what
we really care about.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 59 +----------------------------------------------------------
 1 file changed, 1 insertion(+), 58 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 50d81172438b..0329ec0bee2e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -316,20 +316,12 @@ EXPORT_SYMBOL_GPL(dax_do_io);
 static int dax_load_hole(struct address_space *mapping, struct page *page,
 							struct vm_fault *vmf)
 {
-	unsigned long size;
 	struct inode *inode = mapping->host;
 	if (!page)
 		page = find_or_create_page(mapping, vmf->pgoff,
 						GFP_KERNEL | __GFP_ZERO);
 	if (!page)
 		return VM_FAULT_OOM;
-	/* Recheck i_size under page lock to avoid truncate race */
-	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (vmf->pgoff >= size) {
-		unlock_page(page);
-		page_cache_release(page);
-		return VM_FAULT_SIGBUS;
-	}
 
 	vmf->page = page;
 	return VM_FAULT_LOCKED;
@@ -560,24 +552,10 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
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
@@ -643,15 +621,6 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			page_cache_release(page);
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
@@ -684,17 +653,8 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
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
 
@@ -872,23 +832,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 
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
 	if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
 		spinlock_t *ptl;
 		pmd_t entry;
-- 
2.6.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
